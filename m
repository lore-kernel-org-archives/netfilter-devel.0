From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 02/10] src: ipv6: switch implicit dependencies to
 meta l4proto
Date: Tue, 16 May 2017 12:05:42 +0200
Message-ID: <20170516100542.GB19069@salvia>
References: <20170509155122.26356-1-fw@strlen.de>
 <20170509155122.26356-3-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:33516 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbdEPKFr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2017 06:05:47 -0400
Content-Disposition: inline
In-Reply-To: <20170509155122.26356-3-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 09, 2017 at 05:51:14PM +0200, Florian Westphal wrote:
> when using rule like
> 
> ip6 filter input tcp dport 22
> nft generates:
>   [ payload load 1b @ network header + 6 => reg 1 ]
>   [ cmp eq reg 1 0x00000006 ]
>   [ payload load 2b @ transport header + 2 => reg 1 ]
>   [ cmp eq reg 1 0x00001600 ]
> 
> which is: ip6 filter input ip6 nexthdr tcp dport 22
> IOW, such a rule won't match if e.g. a fragment header is in place.
> 
> This changes ip6_proto to use 'meta l4proto' which is the protocol header
> found by exthdr walk.
> 
> A side effect is that for bridge we get a shorter dependency chain as it
> no longer needs to prepend 'ether proto ipv6' for old 'ip6 nexthdr' dep.

Same comment regarding tests, I would prefer to see tests are amended
in this patch too.

> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  src/proto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/proto.c b/src/proto.c
> index fcdfbe73c735..3b20a5fd35b1 100644
> --- a/src/proto.c
> +++ b/src/proto.c
> @@ -707,7 +707,6 @@ const struct proto_desc proto_icmp6 = {
>  const struct proto_desc proto_ip6 = {
>  	.name		= "ip6",
>  	.base		= PROTO_BASE_NETWORK_HDR,
> -	.protocol_key	= IP6HDR_NEXTHDR,
>  	.protocols	= {
>  		PROTO_LINK(IPPROTO_ESP,		&proto_esp),
>  		PROTO_LINK(IPPROTO_AH,		&proto_ah),
> @@ -720,6 +719,7 @@ const struct proto_desc proto_ip6 = {
>  		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),
>  	},
>  	.templates	= {
> +		[0]	= PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
>  		[IP6HDR_VERSION]	= HDR_BITFIELD("version", &integer_type, 0, 4),
>  		[IP6HDR_DSCP]		= HDR_BITFIELD("dscp", &dscp_type, 4, 6),
>  		[IP6HDR_ECN]		= HDR_BITFIELD("ecn", &ecn_type, 10, 2),
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
