Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE243F20E8
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2026 11:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474818; cv=none; b=JPIF5Q9Ep9ao5y6c0+ZOKDPEv6ZLdTGhtWAoE1XmGYj9PyGQa1nNEo3a8v7fnVjvriYNeU0ezidf4e81JHLJ7kLR53FviWiXBbDYKyMxGKnUac3PRD0UBdCjQULIXwtiQjofjJwEbQZNVHzacJcaeqs/i/ZY+KDiBDu9i74gD14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474818; c=relaxed/simple;
	bh=dk6RhacrUqqXplsx506yWCkB9lmUYnejaqb6W2XCsZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G7gFhNXHh7Oi15h9hu53baL5Mb4ciMMlayLkSxQSwq8fLZMu6mFWmSw3g9eLG3H4w7Rdp3nwk3DW8wtw5NizB0gJehfg5PGlkKMhkNjeo1kecekdGF+AyeE9ORiC7F8odqespLLBFI2NLOwUbtL/0NuNZUfImRY0TnuEIafH/AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fujk5zZY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fujk5zZY"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A98D560585;
	Fri, 26 Jun 2026 13:53:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782474810;
	bh=OZ1dlJQIhJTaPKoseXQtx2cvQFYgF4QKhkmvyPJS6gI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fujk5zZY69XemwSOyfHKHTcG+bzbcX7EY7+/9YE2fN7wTb1ygNDGsXsTY0MnqWymI
	 q6ZKy2pOf0Oh57ZSHq0K5XnjWAIkKFgEJnaKRCfdIBMdoagWrG2aTYj250sxiD4KkX
	 2kwCHO3PuszIns/uf8o1J1MXdmDX3dYow5jFLjOoa/dBxnlMfbpKs3zSeOneNfGu58
	 DtqyBN0fxzmh1BHqVpN8hfFYA5fn8pImX/tlNSi4UHkTI2QEhzEsKUKbr4ddWg+vc5
	 kO8mrI2g/iAzvte6+wN+ENv1lwXmaMyPKC8aY0Oi3gl6KEulikuCbMRS+DnSrFbFL6
	 uuFpLqHUN2tdg==
Date: Fri, 26 Jun 2026 13:53:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 6/6] netlink: Call tunnel getters unconditionally
Message-ID: <aj5oN3PT7_QusykI@chamomile>
References: <20260603192923.1378815-1-phil@nwl.cc>
 <20260603192923.1378815-7-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260603192923.1378815-7-phil@nwl.cc>

Hi Phil,

Series LGTM, only one nitpick, see below.

On Wed, Jun 03, 2026 at 09:29:23PM +0200, Phil Sutter wrote:
> All the nftnl_obj_get_u*() and nftnl_tunnel_opt_get_u*() functions
> return 0 if the attribute is not present. Since 'obj' is zeroed upon
> allocation and no unions are used within per object or tunnel type data,
> assigning that value won't change behaviour.
> 
> Keep the check before calling nftnl_obj_tunnel_opts_foreach though. It
> looks like that function does not check tun->tun_opts before
> dereferencing it.
> 
> Also make sure obj->tunnel.{src,dst} is not initialized twice (once for
> IPv4 and once for IPv6) which happens if merely the _is_set() check is
> removed. Let netlink_obj_tunnel_parse_addr() choose between two
> attributes to use and so assign just once to each of the fields.
> 
> Fixes: 35d9c77c57452 ("src: add tunnel template support")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/netlink.c | 106 ++++++++++++++++++++------------------------------
>  1 file changed, 42 insertions(+), 64 deletions(-)
> 
> diff --git a/src/netlink.c b/src/netlink.c
> index 5c263f39791f1..57f4b7c0edea1 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -1842,7 +1842,7 @@ void netlink_dump_obj(struct nftnl_obj *nln, struct netlink_ctx *ctx)
>  static struct in6_addr all_zeroes;
>  
>  static struct expr *
> -netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int attr)
> +netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int attr, int alt_attr)

Maybe I would suggest:

netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int ipv4_attr, int ipv6_attr)

for easier reading.

Just a nitpick, no need to send v2, just amend before pushing.

BTW, if you take my proposal, maybe this needs to be reversed:

> +			netlink_obj_tunnel_parse_addr(nlo,
> +						      NFTNL_OBJ_TUNNEL_IPV6_SRC,
> +						      NFTNL_OBJ_TUNNEL_IPV4_SRC);

so it is:

> +			netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV4_SRC,
> +                                                   NFTNL_OBJ_TUNNEL_IPV6_SRC);

Although you migh consider that ipv6 is more important, which also
makes sense to me in such case, alternative is:

netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int ipv6_attr, int ipv4_attr)

Thanks.

>  {
>  	struct nft_data_delinearize nld;
>  	const struct datatype *dtype;
> @@ -1850,6 +1850,13 @@ netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int attr)
>  	struct expr *expr;
>  	uint32_t addr;
>  
> +	if (!nftnl_obj_is_set(nlo, attr)) {
> +		if (!nftnl_obj_is_set(nlo, alt_attr))
> +			return NULL;
> +		else
> +			attr = alt_attr;
> +	}
> +
>  	memset(&nld, 0, sizeof(nld));
>  
>  	switch (attr) {
> @@ -1912,33 +1919,23 @@ static int tunnel_parse_opt_cb(struct nftnl_tunnel_opt *opt, void *data) {
>  	switch (nftnl_tunnel_opt_get_type(opt)) {
>  	case NFTNL_TUNNEL_TYPE_ERSPAN:
>  		obj->tunnel.type = TUNNEL_ERSPAN;
> -		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_ERSPAN_VERSION)) {
> -			obj->tunnel.erspan.version =
> -				nftnl_tunnel_opt_get_u32(opt,
> -							 NFTNL_TUNNEL_ERSPAN_VERSION);
> -		}
> -		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_ERSPAN_V1_INDEX)) {
> -			obj->tunnel.erspan.v1.index =
> -				nftnl_tunnel_opt_get_u32(opt,
> -							 NFTNL_TUNNEL_ERSPAN_V1_INDEX);
> -		}
> -		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_ERSPAN_V2_HWID)) {
> -			obj->tunnel.erspan.v2.hwid =
> -				nftnl_tunnel_opt_get_u8(opt,
> -							NFTNL_TUNNEL_ERSPAN_V2_HWID);
> -		}
> -		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_ERSPAN_V2_DIR)) {
> -			obj->tunnel.erspan.v2.direction =
> -				nftnl_tunnel_opt_get_u8(opt,
> -							NFTNL_TUNNEL_ERSPAN_V2_DIR);
> -		}
> +		obj->tunnel.erspan.version =
> +			nftnl_tunnel_opt_get_u32(opt,
> +						 NFTNL_TUNNEL_ERSPAN_VERSION);
> +		obj->tunnel.erspan.v1.index =
> +			nftnl_tunnel_opt_get_u32(opt,
> +						 NFTNL_TUNNEL_ERSPAN_V1_INDEX);
> +		obj->tunnel.erspan.v2.hwid =
> +			nftnl_tunnel_opt_get_u8(opt,
> +						NFTNL_TUNNEL_ERSPAN_V2_HWID);
> +		obj->tunnel.erspan.v2.direction =
> +			nftnl_tunnel_opt_get_u8(opt,
> +						NFTNL_TUNNEL_ERSPAN_V2_DIR);
>  		break;
>  	case NFTNL_TUNNEL_TYPE_VXLAN:
>  		obj->tunnel.type = TUNNEL_VXLAN;
> -		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_VXLAN_GBP)) {
> -			obj->tunnel.type = TUNNEL_VXLAN;
> -			obj->tunnel.vxlan.gbp = nftnl_tunnel_opt_get_u32(opt, NFTNL_TUNNEL_VXLAN_GBP);
> -		}
> +		obj->tunnel.vxlan.gbp =
> +			nftnl_tunnel_opt_get_u32(opt, NFTNL_TUNNEL_VXLAN_GBP);
>  		break;
>  	case NFTNL_TUNNEL_TYPE_GENEVE:
>  		if (!obj->tunnel.type) {
> @@ -1950,11 +1947,11 @@ static int tunnel_parse_opt_cb(struct nftnl_tunnel_opt *opt, void *data) {
>  		if (!geneve)
>  			memory_allocation_error();
>  
> -		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_GENEVE_TYPE))
> -			geneve->type = nftnl_tunnel_opt_get_u8(opt, NFTNL_TUNNEL_GENEVE_TYPE);
> -
> -		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_GENEVE_CLASS))
> -			geneve->geneve_class = nftnl_tunnel_opt_get_u16(opt, NFTNL_TUNNEL_GENEVE_CLASS);
> +		geneve->type =
> +			nftnl_tunnel_opt_get_u8(opt, NFTNL_TUNNEL_GENEVE_TYPE);
> +		geneve->geneve_class =
> +			nftnl_tunnel_opt_get_u16(opt,
> +						 NFTNL_TUNNEL_GENEVE_CLASS);
>  
>  		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_GENEVE_DATA)) {
>  			gnv_data = nftnl_tunnel_opt_get_data(opt, NFTNL_TUNNEL_GENEVE_DATA,
> @@ -2069,40 +2066,21 @@ struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
>  			nftnl_obj_get_u32(nlo, NFTNL_OBJ_SYNPROXY_FLAGS);
>  		break;
>  	case NFT_OBJECT_TUNNEL:
> -		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_ID))
> -			obj->tunnel.id = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TUNNEL_ID);
> -		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_SPORT)) {
> -			obj->tunnel.sport =
> -				nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_SPORT);
> -		}
> -		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_DPORT)) {
> -			obj->tunnel.dport =
> -				nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_DPORT);
> -		}
> -		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_TOS)) {
> -			obj->tunnel.tos =
> -				nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_TOS);
> -		}
> -		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_TTL)) {
> -			obj->tunnel.ttl =
> -				nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_TTL);
> -		}
> -		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV4_SRC)) {
> -			obj->tunnel.src =
> -				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV4_SRC);
> -		}
> -		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV4_DST)) {
> -			obj->tunnel.dst =
> -				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV4_DST);
> -		}
> -		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV6_SRC)) {
> -			obj->tunnel.src =
> -				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV6_SRC);
> -		}
> -		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV6_DST)) {
> -			obj->tunnel.dst =
> -				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV6_DST);
> -		}
> +		obj->tunnel.id = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TUNNEL_ID);
> +		obj->tunnel.sport =
> +			nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_SPORT);
> +		obj->tunnel.dport =
> +			nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_DPORT);
> +		obj->tunnel.tos = nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_TOS);
> +		obj->tunnel.ttl = nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_TTL);
> +		obj->tunnel.src =
> +			netlink_obj_tunnel_parse_addr(nlo,
> +						      NFTNL_OBJ_TUNNEL_IPV6_SRC,
> +						      NFTNL_OBJ_TUNNEL_IPV4_SRC);
> +		obj->tunnel.dst =
> +			netlink_obj_tunnel_parse_addr(nlo,
> +						      NFTNL_OBJ_TUNNEL_IPV6_DST,
> +						      NFTNL_OBJ_TUNNEL_IPV4_DST);
>  		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_OPTS)) {
>  			nftnl_obj_tunnel_opts_foreach(nlo, tunnel_parse_opt_cb, obj);
>  		}
> -- 
> 2.54.0
> 
