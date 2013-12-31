From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH nf-next] netfilter: add help information to new
 nf_tables Kconfig options
Date: Tue, 31 Dec 2013 09:57:32 +0100
Message-ID: <1388480252.3787.8.camel@ice-age2.regit.org>
References: <1388412234-10364-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:40019 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3LaI5f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Dec 2013 03:57:35 -0500
In-Reply-To: <1388412234-10364-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Some comments below even if I've got one of the worst English of the
place ;)

On Mon, 2013-12-30 at 15:03 +0100, Pablo Neira Ayuso wrote:
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/ipv4/netfilter/Kconfig |   18 ++++++++++++++++++
>  net/ipv6/netfilter/Kconfig |   12 ++++++++++++
>  net/netfilter/Kconfig      |   38 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 68 insertions(+)
> 
> diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
> index 40d5607..0cb82fa 100644
> --- a/net/ipv4/netfilter/Kconfig
> +++ b/net/ipv4/netfilter/Kconfig
> @@ -39,23 +39,41 @@ config NF_CONNTRACK_PROC_COMPAT
>  config NF_TABLES_IPV4
>  	depends on NF_TABLES
>  	tristate "IPv4 nf_tables support"
> +	help
> +	  This option enables the IPv4 support for nf_tables.
>  
>  config NFT_REJECT_IPV4
>  	depends on NF_TABLES_IPV4
>  	tristate "nf_tables IPv4 reject support"
> +	help
> +	  This option adds the "reject" expression that you can use to
> +	  explicitly deny and notify via TCP reset/ICMP informational errors
> +	  unallowed traffic.

I would say:

This option adds the "reject" expression that you can use to explicitly
deny traffic and notify it via TCP reset/ICMP informational errors.

>  
>  config NFT_CHAIN_ROUTE_IPV4
>  	depends on NF_TABLES_IPV4
>  	tristate "IPv4 nf_tables route chain support"
> +	help
> +	  This option enables the "route" chain for IPv4 in nf_tables. This
> +	  chain type is used to force packet re-routing after mangling header
> +	  fields such as the source, destination, type of service and
> +	  the packet mark.
>  
>  config NFT_CHAIN_NAT_IPV4
>  	depends on NF_TABLES_IPV4
>  	depends on NF_NAT_IPV4 && NFT_NAT
>  	tristate "IPv4 nf_tables nat chain support"
> +	help
> +	  This option enables the "nat" chain for IPv4 in nf_tables. This
> +	  chain type is used to perform Network Address Translation (NAT)
> +	  packet transformations such as the source, destination address and
> +	  source and destination ports.
>  
>  config NF_TABLES_ARP
>  	depends on NF_TABLES
>  	tristate "ARP nf_tables support"
> +	help
> +	  This option enables the ARP support for nf_tables.
>  
>  config IP_NF_IPTABLES
>  	tristate "IP tables support (required for filtering/masq/NAT)"
> diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
> index 7702f9e..35750df 100644
> --- a/net/ipv6/netfilter/Kconfig
> +++ b/net/ipv6/netfilter/Kconfig
> @@ -28,15 +28,27 @@ config NF_CONNTRACK_IPV6
>  config NF_TABLES_IPV6
>  	depends on NF_TABLES
>  	tristate "IPv6 nf_tables support"
> +	help
> +	  This option enables the IPv6 support for nf_tables.
>  
>  config NFT_CHAIN_ROUTE_IPV6
>  	depends on NF_TABLES_IPV6
>  	tristate "IPv6 nf_tables route chain support"
> +	help
> +	  This option enables the "route" chain for IPv6 in nf_tables. This
> +	  chain type is used to force packet re-routing after mangling header
> +	  fields such as the source, destination, flowlabel, hop-limit and
> +	  the packet mark.
>  
>  config NFT_CHAIN_NAT_IPV6
>  	depends on NF_TABLES_IPV6
>  	depends on NF_NAT_IPV6 && NFT_NAT
>  	tristate "IPv6 nf_tables nat chain support"
> +	help
> +	  This option enables the "nat" chain for IPv6 in nf_tables. This
> +	  chain type is used to perform Network Address Translation (NAT)
> +	  packet transformations such as the source, destination address and
> +	  source and destination ports.
>  
>  config IP6_NF_IPTABLES
>  	tristate "IP6 tables support (required for filtering)"
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index 01f9f64..22c19d2 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -416,45 +416,83 @@ endif # NF_CONNTRACK
>  config NF_TABLES
>  	select NETFILTER_NETLINK
>  	tristate "Netfilter nf_tables support"
> +	help
> +	  nftables is the new packet classification framework that intends to
> +	  replace the existing {ip,ip6,arp,eb}_tables infrastructure. It
> +	  provides a pseudo-state machine with an extensible instruction-set
> +	  (also known as expressions) that the userspace 'nft' utility
> +	  (http://www.netfilter.org/projects/nftables) uses to build the
> +	  rule-set. It also comes with the generic set infrastructure that
> +	  allows you to construct mappings between matchings and actions
> +	  for performance lookups.
> +
> +	  To compile it as a module, choose M here.
>  
>  config NFT_EXTHDR
>  	depends on NF_TABLES
>  	tristate "Netfilter nf_tables IPv6 exthdr module"
> +	help
> +	  This option adds the "exthdr" expression that you can use to match
> +	  IPv6 extension headers.
>  
>  config NFT_META
>  	depends on NF_TABLES
>  	tristate "Netfilter nf_tables meta module"
> +	help
> +	  This option adds the "meta" expression that you can use to match and
> +	  to set packet metainformation such as the packet mark.

I would add info about iface matching that is one of the more commonly
used matching in meta:

This option adds the "meta" expression that you can use to match and to
set packet metainformation such as the packet mark or network interface.

++
-- 
Eric Leblond <eric@regit.org>

