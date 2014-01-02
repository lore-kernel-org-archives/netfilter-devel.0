From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: nftables: introduce ct_set module
Date: Thu, 2 Jan 2014 15:05:42 +0100
Message-ID: <20140102140542.GA5200@localhost>
References: <1388653976-30802-1-git-send-email-eric@regit.org>
 <1388653976-30802-3-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59143 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaABOFr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jan 2014 09:05:47 -0500
Content-Disposition: inline
In-Reply-To: <1388653976-30802-3-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

On Thu, Jan 02, 2014 at 10:12:56AM +0100, Eric Leblond wrote:
> This module is a port of iptables CT target. It allows
> user to setup connection tracking for selected packets.
> 
> The context is not containing information about layer 4
> so it is necessary to ask to userspace explicitely for
> which layer 4 protocol the connection template has to be
> created. This is the reason why the  NFTA_CT_SET_PROTO
> field has been introduced.
> 
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  36 +++++
>  net/netfilter/Kconfig                    |   5 +
>  net/netfilter/Makefile                   |   1 +
>  net/netfilter/nft_ct_set.c               | 262 +++++++++++++++++++++++++++++++
>  4 files changed, 304 insertions(+)
>  create mode 100644 net/netfilter/nft_ct_set.c
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index aa86a152..96bde79 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -707,6 +707,42 @@ enum nft_reject_attributes {
>  #define NFTA_REJECT_MAX		(__NFTA_REJECT_MAX - 1)
>  
>  /**
> + * enum nft_ct_set_attributes - nf_tables ct_set expression netlink attributes
> + *
> + * @NFTA_CT_SET_PROTO: layer 4 protocol
> + * @NFTA_CT_SET_FLAGS: flags for connection as NOTRACK for example
> + * @NFTA_CT_SET_HELPER: protocol helper to link with matching connections
> + * @NFTA_CT_SET_CTEVENTS: only generate the specified conntrack events
> + * @NFTA_CT_SET_EXPEVENTS: only generate the specified expectation events
> + * @NFTA_CT_SET_ZONEID: assign packet to sone id
> + * @NFTA_CT_SET_TIMEOUT: use timeout policy for the connection
> + *
> + */
> +enum nft_ct_set_attributes {
> +	NFTA_CT_SET_UNSPEC,
> +	NFTA_CT_SET_PROTO,
> +	NFTA_CT_SET_FLAGS,
> +	NFTA_CT_SET_HELPER,
> +	NFTA_CT_SET_CTEVENTS,
> +	NFTA_CT_SET_EXPEVENTS,
> +	NFTA_CT_SET_ZONEID,
> +	NFTA_CT_SET_TIMEOUT,
> +	__NFTA_CT_SET_MAX
> +};
> +#define NFTA_CT_SET_MAX		(__NFTA_CT_SET_MAX - 1)
> +
> +/**
> + * enum nft_ct_set_flags - nf_tables ct_set flags
> + *
> + * @NFT_CT_SET_F_NOTRACK: do not track this connection
> + */
> +enum nft_ct_set_flags {
> +
> +enum nft_ct_set_flags {
> +	NFT_CT_SET_F_NOTRACK = 0x1,
> +};
> +
> +/**
>   * enum nft_nat_types - nf_tables nat expression NAT types
>   *
>   * @NFT_NAT_SNAT: source NAT
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index a1dec61..448c389 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -430,6 +430,11 @@ config NFT_CT
>  	depends on NF_CONNTRACK
>  	tristate "Netfilter nf_tables conntrack module"
>  
> +config NFT_CT_SET
> +	depends on NF_TABLES
> +	depends on NF_CONNTRACK
> +	tristate "Netfilter nf_tables conntrack setup module"
> +
>  config NFT_RBTREE
>  	depends on NF_TABLES
>  	tristate "Netfilter nf_tables rbtree set module"
> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> index 39e4a7b..f50c501 100644
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -74,6 +74,7 @@ obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
>  obj-$(CONFIG_NFT_EXTHDR)	+= nft_exthdr.o
>  obj-$(CONFIG_NFT_META)		+= nft_meta.o
>  obj-$(CONFIG_NFT_CT)		+= nft_ct.o
> +obj-$(CONFIG_NFT_CT_SET)	+= nft_ct_set.o
>  obj-$(CONFIG_NFT_LIMIT)		+= nft_limit.o
>  obj-$(CONFIG_NFT_NAT)		+= nft_nat.o
>  obj-$(CONFIG_NFT_QUEUE)		+= nft_queue.o
> diff --git a/net/netfilter/nft_ct_set.c b/net/netfilter/nft_ct_set.c
> new file mode 100644
> index 0000000..93e862d
> --- /dev/null
> +++ b/net/netfilter/nft_ct_set.c

This has to be integrated into the existing nft_ct using the
select_ops(...) infrastructure. Depending on SREG or DREG if
interprets the rule as set or get operation. Some attributes will turn
noop depending on the flavour.

Please, see recent Arturo's work to enable meta set operation for
reference. Let me know if you have any question, thanks for working on
this.
