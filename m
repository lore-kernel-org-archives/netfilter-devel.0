From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] proto: Add some exotic ICMPv6 types
Date: Wed, 15 Mar 2017 17:15:14 +0100
Message-ID: <20170315161514.GB28159@salvia>
References: <20170315155501.8603-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43974 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751563AbdCOQPU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 12:15:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1A265FB450
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 17:15:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C54DDA804
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 17:15:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF43BDA865
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 17:15:14 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170315155501.8603-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 15, 2017 at 04:55:01PM +0100, Phil Sutter wrote:
> This adds support for matching on inverse ND messages as defined by
> RFC3122 (not implemented in Linux) and MLDv2 as defined by RFC3810.
> 
> Note that ICMPV6_MLD2_REPORT macro is defined in linux/icmpv6.h but
> including that header leads to conflicts with symbols defined in
> netinet/icmp6.h.
> 
> In addition to the above, "mld-listener-done" is introduced as an alias
> for "mld-listener-reduction".
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> This should resolve netfilter BZ#926.
> ---
>  src/proto.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/src/proto.c b/src/proto.c
> index fb965304e59d9..6a8eed936d858 100644
> --- a/src/proto.c
> +++ b/src/proto.c
> @@ -632,6 +632,10 @@ const struct proto_desc proto_ip = {
>  
>  #include <netinet/icmp6.h>
>  
> +#define IND_NEIGHBOR_SOLICIT	141
> +#define IND_NEIGHBOR_ADVERT	142
> +#define ICMPV6_MLD2_REPORT	143
> +
>  static const struct symbol_table icmp6_type_tbl = {
>  	.base		= BASE_DECIMAL,
>  	.symbols	= {
> @@ -644,12 +648,16 @@ static const struct symbol_table icmp6_type_tbl = {
>  		SYMBOL("mld-listener-query",		MLD_LISTENER_QUERY),
>  		SYMBOL("mld-listener-report",		MLD_LISTENER_REPORT),
>  		SYMBOL("mld-listener-reduction",	MLD_LISTENER_REDUCTION),
> +		SYMBOL("mld-listener-done",		MLD_LISTENER_REDUCTION),

This one is duplicated, right?

>  		SYMBOL("nd-router-solicit",		ND_ROUTER_SOLICIT),
>  		SYMBOL("nd-router-advert",		ND_ROUTER_ADVERT),
>  		SYMBOL("nd-neighbor-solicit",		ND_NEIGHBOR_SOLICIT),
>  		SYMBOL("nd-neighbor-advert",		ND_NEIGHBOR_ADVERT),
>  		SYMBOL("nd-redirect",			ND_REDIRECT),
>  		SYMBOL("router-renumbering",		ICMP6_ROUTER_RENUMBERING),
> +		SYMBOL("mld2-listener-report",		ICMPV6_MLD2_REPORT),
> +		SYMBOL("ind-neighbor-solicit",		IND_NEIGHBOR_SOLICIT),
> +		SYMBOL("ind-neighbor-advert",		IND_NEIGHBOR_ADVERT),
>  		SYMBOL_LIST_END
>  	},
>  };
> -- 
> 2.11.0
> 
