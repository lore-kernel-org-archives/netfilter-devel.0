Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076A910942
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 00:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748392501; cv=none; b=jo48feO9PmitzltTFZXOvkX/xLCZD+Zfp9sPegpPynhf05sIuPDcJNwNqaSTJN2Q5sVKBLSYxR/GJqfu8JEFlfTySVwGceXQudpDbxbXj4uvCDlBJ7Zl0xV94F+eYpb/dhtN32GTL4pH/AD2gzf+1JLOLuxRm16ICWJm8jnhHOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748392501; c=relaxed/simple;
	bh=DErBpn7xiN9lUL5OrPPXSDnRBNYClDS0kgG5p6nOrNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i4yXj7bCqwkd8Q0cnj6EDKR+yeCGdEulPXybii4oWAr5lAJSW2N+u+eQIxChc4ci5j1r0mM7c5rZAgwkOQESUHdU5dlxh7k2DFuz1p8I6ZUk0HuT9dsbad13Vj7pe4fuPLOVdGwLgJPg+mdB5YuKrC+bbzI1rS1k/qMou1xPWcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1D2CA6043E; Wed, 28 May 2025 02:34:49 +0200 (CEST)
Date: Wed, 28 May 2025 02:34:10 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 2/2 libnftnl v2] tunnel: add support to geneve options
Message-ID: <aDZaAl1r0iWkAePn@strlen.de>
References: <20250527193420.9860-1-fmancera@suse.de>
 <20250527193420.9860-2-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250527193420.9860-2-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:

Hi Fernando

Thanks for working on this, I got inquiries as to nft_tunnel.c
and how to make use of this stuff...

> diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
> index 9930355..14a42cd 100644
> --- a/include/libnftnl/object.h
> +++ b/include/libnftnl/object.h
> @@ -117,15 +117,19 @@ enum {
>  	NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX,
>  	NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID,
>  	NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR,
> +	NFTNL_OBJ_TUNNEL_GENEVE_OPTS,

If every flavour gets its own flag in the tunnel namespace we'll run
out of u64 in no time.

AFAICS these are mutually exclusive, e.g.
NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX and NFTNL_OBJ_TUNNEL_VXLAN_GBP cannot
be active at the same time.

Is there a way to re-use the internal flag namespace depending on the tunnel
subtype?

Or to have distinct tunnel object types?

object -> tunnel -> {vxlan, erspan, ...} ?

As-is, how is this API supposed to be used?  The internal union seems to
be asking for trouble later, when e.g. 'getting' NFTNL_OBJ_TUNNEL_GENEVE_OPTS
on something that was instantiated as vxlan tunnel and fields aliasing to
unexpected values.

Perhaps the first use of any of the NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX
etc values in a setter should interally "lock" the object to the given
subtype?

That might allow to NOT use ->flags for those enum values and instead
keep track of them via overlapping bits.

We'd need some internal 'enum nft_obj_tunnel_type' that marks which
part of the union is useable/instantiated so we can reject requests
to set bits that are not available for the specific tunnel type.

>  	switch (type) {
>  	case NFTNL_OBJ_TUNNEL_ID:
> @@ -72,6 +73,15 @@ nftnl_obj_tunnel_set(struct nftnl_obj *e, uint16_t type,
>  	case NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR:
>  		memcpy(&tun->u.tun_erspan.u.v2.dir, data, data_len);
>  		break;
> +	case NFTNL_OBJ_TUNNEL_GENEVE_OPTS:
> +		geneve = malloc(sizeof(struct nftnl_obj_tunnel_geneve));

No null check.  Applies to a few other spots too.

> +		memcpy(geneve, data, data_len);

Hmm, this looks like the API leaks internal data layout from nftables to
libnftnl and vice versa?  IMO thats a non-starter, sorry.

I see that options are essentially unlimited values, so perhaps nftables
should build the netlink blob(s) directly, similar to nftnl_udata()?

Pablo, any better idea?

I don't like exposing the struct and also the list abstraction getting
exposed to libnftnl users.

As-is, there is:

json/bison -> struct tunnel_geneve -> nftnl_obj_set_data(&obj, NFTNL_OBJ_TUNNEL_GENEVE_OPTS, &blob);
 -> nftnl_obj_tunnel_build -> mnl_attr_put_u16( ...

I think it will be better if we make this internal to nftables and have
pass-through for the entire geneve blob,i.e.

json/bison -> struct tunnel_geneve ->
 (re)alloc buffer: mnl_nlmsg_put_header(), mnl_attr_put_u16 -> etc.
 nftnl_obj_set_data(obj, NFTNL_OBJ_TUNNEL_GENEVE_OPTS, blob) ->
 nftnl_obj_tunnel_build -> memcpy into NFTA_TUNNEL_KEY_OPTS nest
 container.

Less elegant but I have a hard time coming up with an api that is
extensible and doesn't need shared binary structures.

Another option would be to use udata in the frontend and then
make libnftnl xlate the udata to netlink proper.  But I don't
like this because a) udata is supposed to be "DO NOT TOUCH"
and b) it means doubling the work compared to just doing mnl_attr_put()
calls in nftables.

> +	if (tb[NFTA_TUNNEL_KEY_GENEVE_DATA]) {
> +		uint32_t len = mnl_attr_get_payload_len(tb[NFTA_TUNNEL_KEY_GENEVE_DATA]);
> +
> +		memcpy(geneve->data,
> +		       mnl_attr_get_payload(tb[NFTA_TUNNEL_KEY_GENEVE_DATA]),
> +		       len);

This should cap 'len' by sizeof(geneve->data).
But I'm not sure this deserialization should be done in libnftnl in the
first place, see above.
