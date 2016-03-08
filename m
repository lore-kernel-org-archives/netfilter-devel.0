From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv3] extensions: libip6t_icmp6: Add translation to nft
Date: Tue, 8 Mar 2016 11:51:29 +0100
Message-ID: <20160308105129.GA4008@salvia>
References: <20160307212252.GA10639@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60427 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbcCHKve (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 05:51:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8C41A8431
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 11:51:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7D3E1DA396
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 11:51:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0273BDA384
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 11:51:29 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160307212252.GA10639@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Laura,

On Mon, Mar 07, 2016 at 10:22:55PM +0100, Laura Garcia Liebana wrote:
> Add translation for icmpv6 to nftables. Not supported types in nftables
> are: no-route, communication-prohibited, beyond-scope,
> address-unreachable, port-unreachable, failed-policy, reject-route,
> ttl-zero-during-transit, ttl-zero-during-reassembly, bad-header,
> unknown-header-type and unknown-option.
> 
> Examples:
> 
> $ ip6tables-translate -t filter -A INPUT -m icmp6 --icmpv6-type 1 -j LOG
> nft add rule ip6 filter INPUT icmpv6 type destination-unreachable counter log level warn
> 
> $ ip6tables-translate -t filter -A INPUT -m icmp6 --icmpv6-type neighbour-advertisement -j LOG
> nft add rule ip6 filter INPUT icmpv6 type nd-neighbor-advert counter log level warn
> 
> $ ip6tables-translate -t filter -A INPUT -m icmp6 ! --icmpv6-type packet-too-big -j LOG
> nft add rule ip6 filter INPUT icmpv6 type != packet-too-big counter log level warn

Not related to your patches, I just noticed this:

        log level warn

Could you send a patch to remove the "level warn" thing? The default
logging level is already warning in nft so better if we don't display
this.

BTW, applied with one minor glitch below.

> Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> ---
> v2:
> 	- Detection of not supported types in nftables, as Shivani suggested.
> v3:
> 	- Generalize the source code, as Pablo suggested.
> 
>  extensions/libip6t_icmp6.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
> 
> diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
> index e183ce6..08eca99 100644
> --- a/extensions/libip6t_icmp6.c
> +++ b/extensions/libip6t_icmp6.c
> @@ -4,6 +4,9 @@
>  #include <xtables.h>
>  #include <limits.h> /* INT_MAX in ip6_tables.h */
>  #include <linux/netfilter_ipv6/ip6_tables.h>
> +#include <netinet/icmp6.h>
> +
> +#define XT_ICMPV6_TYPE(type)	(type - ND_ROUTER_SOLICIT)
>  
>  enum {
>  	O_ICMPV6_TYPE = 0,
> @@ -15,6 +18,14 @@ struct icmpv6_names {
>  	uint8_t code_min, code_max;
>  };
>  
> +static const char *icmp6_type_xlate_array[] = {
> +	[XT_ICMPV6_TYPE(ND_ROUTER_SOLICIT)]	= "nd-router-solicit",
> +	[XT_ICMPV6_TYPE(ND_ROUTER_ADVERT)]	= "nd-router-advert",
> +	[XT_ICMPV6_TYPE(ND_NEIGHBOR_SOLICIT)]	= "nd-neighbor-solicit",
> +	[XT_ICMPV6_TYPE(ND_NEIGHBOR_ADVERT)]	= "nd-neighbor-advert",
> +	[XT_ICMPV6_TYPE(ND_REDIRECT)]		= "nd-redirect",
> +};

Next time move these definitions to where they are used. I prefer to
get these where we use them, the closer we have the context to read
the code, the less you have to scroll up and down (thus change visual
context). This time, I made this manual change myself here.

Thanks.
