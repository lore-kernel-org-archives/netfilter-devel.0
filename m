From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 09/10] src: ip: switch implicit dependencies to meta
 l4proto too
Date: Tue, 16 May 2017 12:35:23 +0200
Message-ID: <20170516103523.GD19858@salvia>
References: <20170509155122.26356-1-fw@strlen.de>
 <20170509155122.26356-10-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:33752 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752667AbdEPKf1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2017 06:35:27 -0400
Content-Disposition: inline
In-Reply-To: <20170509155122.26356-10-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 09, 2017 at 05:51:21PM +0200, Florian Westphal wrote:
> after ip6 nexthdr also switch ip to meta l4proto instead of ip protocol.
> 
> While its needed for ipv6 (due to extension headers) this isn't needed
> for ip but it has the advantage that
> 
> tcp dport 22
> 
> produces same expressions for ip/ip6/inet families.

Oh, this is coming later on... which is what I was asking before,
patch order in this series is a bit confusing for review.

Another comment below.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/payload.c | 17 +++++++++++------
>  src/proto.c   |  3 ++-
>  2 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/src/payload.c b/src/payload.c
> index 3a3fe8de97cf..5331b5832fd2 100644
> --- a/src/payload.c
> +++ b/src/payload.c
> @@ -118,17 +118,22 @@ static const struct expr_ops payload_expr_ops = {
>  };
>  
>  /*
> - * ipv6 is special case, we normally use 'meta l4proto' to fetch the last
> - * l4 header of the ipv6 extension header chain so we will also match
> + * We normally use 'meta l4proto' to fetch the last l4 header of the
> + * ipv6 extension header chain so we will also match
>   * tcp after a fragmentation header, for instance.
> + * For consistency we also use meta l4proto for ipv4.
>   *
> - * If user specifically asks for nexthdr x, treat is as a full
> - * dependency rather than injecting another (useless) meta l4 one.
> + * If user specifically asks for nexthdr x, don't add another (useless)
> + * meta dependency.
>   */
>  static bool proto_key_is_protocol(const struct proto_desc *desc, unsigned int type)
>  {
> -	if (type == desc->protocol_key ||
> -	    (desc == &proto_ip6 && type == IP6HDR_NEXTHDR))
> +	if (type == desc->protocol_key)
> +		return true;
> +
> +	if (desc == &proto_ip6 && type == IP6HDR_NEXTHDR)
> +		return true;
> +	if (desc == &proto_ip && type == IPHDR_PROTOCOL)
>  		return true;
>  
>  	return false;
> diff --git a/src/proto.c b/src/proto.c
> index 3b20a5fd35b1..2afedf773045 100644
> --- a/src/proto.c
> +++ b/src/proto.c
> @@ -587,7 +587,6 @@ const struct proto_desc proto_ip = {
>  	.name		= "ip",
>  	.base		= PROTO_BASE_NETWORK_HDR,
>  	.checksum_key	= IPHDR_CHECKSUM,
> -	.protocol_key	= IPHDR_PROTOCOL,
>  	.protocols	= {
>  		PROTO_LINK(IPPROTO_ICMP,	&proto_icmp),
>  		PROTO_LINK(IPPROTO_ESP,		&proto_esp),
> @@ -600,6 +599,7 @@ const struct proto_desc proto_ip = {
>  		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
>  	},
>  	.templates	= {
> +		[0]	= PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
>  		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 0, 4),
>  		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 4, 4),
>  		[IPHDR_DSCP]            = HDR_BITFIELD("dscp", &dscp_type, 8, 6),
> @@ -779,6 +779,7 @@ const struct proto_desc proto_inet_service = {
>  		PROTO_LINK(IPPROTO_TCP,		&proto_tcp),
>  		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
>  		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
> +		PROTO_LINK(IPPROTO_ICMP,	&proto_icmp),
>  		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),

We have avoid adding ICMPv4 and ICMPv6 to proto_inet_service because
of combinations like, IPv4 packet with ICMPv6 protocol should not
match. Same with IPv6 packet with ICMPv4 protocol.

So Arturo came up with the patch to solve this:

commit 0011985554e269e1cc8f8e5b41eb9dcd795ebe8c
Author: Arturo Borrero Gonzalez <arturo@debian.org>
Date:   Wed Jan 25 12:51:08 2017 +0100

    payload: explicit network ctx assignment for icmp/icmp6 in special families

My concern here is that we should not match this invalid combination
to allow fishy packets go through.
