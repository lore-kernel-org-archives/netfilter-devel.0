From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/5] netfilter: nf_tables: Add meta expression key for
 bridge interface name
Date: Mon, 14 Apr 2014 13:36:57 +0200
Message-ID: <20140414113657.GA21331@localhost>
References: <1396956324-17803-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1396956324-17803-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57668 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbaDNLhE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:37:04 -0400
Content-Disposition: inline
In-Reply-To: <1396956324-17803-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 08, 2014 at 02:25:22PM +0300, Tomasz Bursztyka wrote:
> NFT_META_BRI_IIFNAME to get packet input bridge interface name
> NFT_META_BRI_OIFNAME to get packet output bridge interface name
> 
> Such meta key are accessible only through NFPROTO_BRIDGE family, on a
> dedicated nft meta module: nft_meta_bridge.
> 
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |   4 +
>  net/bridge/Makefile                      |   1 +
>  net/bridge/netfilter/Kconfig             |  12 ++-
>  net/bridge/netfilter/Makefile            |   1 +
>  net/bridge/netfilter/nft_meta_bridge.c   | 139 +++++++++++++++++++++++++++++++
>  5 files changed, 156 insertions(+), 1 deletion(-)
>  create mode 100644 net/bridge/netfilter/nft_meta_bridge.c
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index c88ccbf..45fb37c 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -536,6 +536,8 @@ enum nft_exthdr_attributes {
>   * @NFT_META_SECMARK: packet secmark (skb->secmark)
>   * @NFT_META_NFPROTO: netfilter protocol
>   * @NFT_META_L4PROTO: layer 4 protocol number
> + * @NFT_META_BRI_IIFNAME: packet input bridge interface name
> + * @NFT_META_BRI_OIFNAME: packet output bridge interface name
>   */
>  enum nft_meta_keys {
>  	NFT_META_LEN,
> @@ -555,6 +557,8 @@ enum nft_meta_keys {
>  	NFT_META_SECMARK,
>  	NFT_META_NFPROTO,
>  	NFT_META_L4PROTO,
> +	NFT_META_BRI_IIFNAME,
> +	NFT_META_BRI_OIFNAME,
>  };
>  
>  /**
> diff --git a/net/bridge/Makefile b/net/bridge/Makefile
> index e85498b2f..58acd82 100644
> --- a/net/bridge/Makefile
> +++ b/net/bridge/Makefile
> @@ -16,4 +16,5 @@ bridge-$(CONFIG_BRIDGE_IGMP_SNOOPING) += br_multicast.o br_mdb.o
>  
>  bridge-$(CONFIG_BRIDGE_VLAN_FILTERING) += br_vlan.o
>  
> +obj-$(CONFIG_NF_TABLES_BRIDGE) += netfilter/
>  obj-$(CONFIG_BRIDGE_NF_EBTABLES) += netfilter/

I think you can add some backward compatibility alias:

config CONFIG_BRIDGE_NF_EBTABLES
        select CONFIG_NETFILTER_BRIDGE

so you can add CONFIG_NETFILTER_BRIDGE for that directory, which is
more generic.

obj-$(CONFIG_NETFILTER_BRIDGE) += netfilter/

> diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
> index 5ca74a0..906783d 100644
> --- a/net/bridge/netfilter/Kconfig
> +++ b/net/bridge/netfilter/Kconfig
> @@ -2,10 +2,20 @@
>  # Bridge netfilter configuration
>  #
>  #
> -config NF_TABLES_BRIDGE
> +menuconfig NF_TABLES_BRIDGE
>  	depends on NF_TABLES
>  	tristate "Ethernet Bridge nf_tables support"
>  
> +if NF_TABLES_BRIDGE
> +
> +config NFT_BRIDGE_META
> +	tristate "Netfilter nf_table bridge meta support"
> +	depends on NFT_META
> +	help
> +	  Add support for bridge dedicated meta key.
> +
> +endif # NF_TABLES_BRIDGE
> +
>  menuconfig BRIDGE_NF_EBTABLES
>  	tristate "Ethernet Bridge tables (ebtables) support"
>  	depends on BRIDGE && NETFILTER
> diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
> index ea7629f..6f2f394 100644
> --- a/net/bridge/netfilter/Makefile
> +++ b/net/bridge/netfilter/Makefile
> @@ -3,6 +3,7 @@
>  #
>  
>  obj-$(CONFIG_NF_TABLES_BRIDGE) += nf_tables_bridge.o
> +obj-$(CONFIG_NFT_BRIDGE_META)  += nft_meta_bridge.o
>  
>  obj-$(CONFIG_BRIDGE_NF_EBTABLES) += ebtables.o
>  
> diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
> new file mode 100644
> index 0000000..4f02109
> --- /dev/null
> +++ b/net/bridge/netfilter/nft_meta_bridge.c

I think you can remove the trailing _bridge, it's obvious that we're
already in the bridge directory.

Apart from those two, this looks good to me. Thanks Tomasz.
