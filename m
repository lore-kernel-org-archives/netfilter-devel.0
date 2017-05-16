From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 01/10] src: allow update of net base w. meta l4proto
 icmpv6
Date: Tue, 16 May 2017 12:04:52 +0200
Message-ID: <20170516100452.GA19069@salvia>
References: <20170509155122.26356-1-fw@strlen.de>
 <20170509155122.26356-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:33497 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751960AbdEPKE5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2017 06:04:57 -0400
Content-Disposition: inline
In-Reply-To: <20170509155122.26356-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 09, 2017 at 05:51:13PM +0200, Florian Westphal wrote:
> nft add rule ip6 f i meta l4proto ipv6-icmp icmpv6 type nd-router-advert
> <cmdline>:1:50-60: Error: conflicting protocols specified: unknown vs. icmpv6
>
> add icmpv6 to nexthdr list so base gets updated correctly.

I would like to see a new test coming with this patch. So we can
easily relate the fix with the new test.

> Reported-by: Thomas Woerner <twoerner@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

>  src/proto.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/src/proto.c b/src/proto.c
> index 79e9dbf2b33e..fcdfbe73c735 100644
> --- a/src/proto.c
> +++ b/src/proto.c
> @@ -779,6 +779,7 @@ const struct proto_desc proto_inet_service = {
>  		PROTO_LINK(IPPROTO_TCP,		&proto_tcp),
>  		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
>  		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
> +		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),
>  	},
>  	.templates	= {
>  		[0]	= PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
