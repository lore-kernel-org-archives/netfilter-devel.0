Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538402798FD
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 10:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748429615; cv=none; b=fo2jHy5Ay3v5Qd8BTl0hh9ZvMn0aAUwnPEZLly4Y5bEsFTUoKA+ZVOzTnS1FmPBVH+E3QX6JpuTQvX98KuQPIHiLET6fdDDPT12qIe/Bnz/b1uD5S0P9kA/YB+1YOrC6NcJx4m1LjW+VcwNTeX1PwJdKCY53GwPrKCu7D6DPYT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748429615; c=relaxed/simple;
	bh=Mz50rk56f650/oMJScmkmhsiPAnXOlQkjUdzuh78Gg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kXBgrUmYiHm4vsrpztjPTGKar0uMrOQiUzl/mVFiUDTfWR2nXfVKAemVUnSvgeTRIpBmu8xOoaxb8KwZvQ7kzQPZIjvCL+N3j2kexLr26Y4C6a5PESWeboi9JU0gGympi53pyCMMJCSu5oeIfZl+j8Bc74agHEFN2Ae2mjY03sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D89A0603F8; Wed, 28 May 2025 12:53:30 +0200 (CEST)
Date: Wed, 28 May 2025 12:52:47 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 2/2 libnftnl v2] tunnel: add support to geneve options
Message-ID: <aDbq_18Jv7jRx9SL@strlen.de>
References: <20250527193420.9860-1-fmancera@suse.de>
 <20250527193420.9860-2-fmancera@suse.de>
 <aDZaAl1r0iWkAePn@strlen.de>
 <7f8d6fea-d4da-4cda-87cc-c5194e36d25e@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f8d6fea-d4da-4cda-87cc-c5194e36d25e@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> > If every flavour gets its own flag in the tunnel namespace we'll run
> > out of u64 in no time.
> > 
> > AFAICS these are mutually exclusive, e.g.
> > NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX and NFTNL_OBJ_TUNNEL_VXLAN_GBP cannot
> > be active at the same time.
> > 
> > Is there a way to re-use the internal flag namespace depending on the tunnel
> > subtype?
> > 
> > Or to have distinct tunnel object types?
> > 
> > object -> tunnel -> {vxlan, erspan, ...} ?
> > 
> 
> IMHO, this could be done by providing libnftnl its own object tunnel 
> API. Although that would require to expose more functions, but tunnel 
> object could have its own flags field.
> 
> In addition, I am afraid that ERSPAN and VXLAN enum fields have been 
> exposed in a released version so removing them would be a breaking 
> change. I am not sure whether that is acceptable or not.

Yep, looks like ERSPAN and VXLAN have to remain in place.

> > As-is, how is this API supposed to be used?  The internal union seems to
> > be asking for trouble later, when e.g. 'getting' NFTNL_OBJ_TUNNEL_GENEVE_OPTS
> > on something that was instantiated as vxlan tunnel and fields aliasing to
> > unexpected values.
> > 
> > Perhaps the first use of any of the NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX
> > etc values in a setter should interally "lock" the object to the given
> > subtype?
> > 
> > That might allow to NOT use ->flags for those enum values and instead
> > keep track of them via overlapping bits.
> > 
> > We'd need some internal 'enum nft_obj_tunnel_type' that marks which
> > part of the union is useable/instantiated so we can reject requests
> > to set bits that are not available for the specific tunnel type.
> > 
> 
> Yes, that would help but isn't that the reason why the flags field is 
> there? I mean, currently the same problem would exist with the different 
> object variants e.g the union of "struct nftnl_obj_*". When trying to 
> get the attribute we always check that the flag is set.

Right :-/

> >> +		memcpy(geneve, data, data_len);
> > 
> > Hmm, this looks like the API leaks internal data layout from nftables to
> > libnftnl and vice versa?  IMO thats a non-starter, sorry.
> > 
> 
> I agree that exposing the list abstraction to the user is problematic 
> and shouldn't be done. As you mentioned below, I couldn't come up with a 
> better API on libnftnl. Thinking about it, we could expose only the 
> relevant fields by putting them in a isolated struct.

Looking at the nftables patches, I think some of what is done there
should be moved to libnftl, e.g. the $<obj>0->tunnel.type = TUNNEL_GENEVE;
thing.  I mean, it makes sense to track the type of the object but
wouldn't it make more sense to do this in libnftnl?

Thinking about it some more, I'm not sure if NFT_OBJECT_TUNNEL was a good idea.

We have:
  NFT_OBJECT_CT_HELPER
  NFT_OBJECT_CT_TIMEOUT
  NFT_OBJECT_CT_EXPECT

What about following that model, e.g.:

#define NFT_OBJECT_TUNNEL_GENEVE	11
#define NFT_OBJECT_TUNNEL_ERSPAN	12
...

?
Pablo, what do you think?  Maybe you tried this before and it wasn't
good either because of lots of duplication with common tunnel
attributes?

Back to the geneve option handling, I think it would be best to
expose all the fields in the struct via deticated setters/getters, i.e.
from

struct tunnel_geneve {
       struct list_head        list;
       uint16_t                geneve_class;
       uint8_t                 type;
       uint8_t                 data[NFTNL_TUNNEL_GENEVE_DATA_MAXLEN];
       uint32_t                data_len;
};

expose: geneve_class, type, and data.

This could be done by moving some of the nftables code you added to
libnftnl.

Instead of this in nftables:
  list_for_each_entry(geneve, &obj->tunnel.geneve_opts, list) {
        nftnl_obj_set_data(nlo, NFTNL_OBJ_TUNNEL_GENEVE_OPTS,
                           geneve, sizeof(struct tunnel_geneve));
        }
  }

do this (error handling omitted for brevity):

  list_for_each_entry(geneve, &obj->tunnel.geneve_opts, list) {
	struct nftnl_obj_tunnel_geneve_opts *geneve;

	geneve = nftnl_obj_tunnel_geneve_opts_alloc();

	nftnl_obj_tunnel_geneve_opts_set_u32(geneve, NFT_OBJECT_TUNNEL_GENEVE_OPT_CLASS, geneve->geneve_class);
	nftnl_obj_tunnel_geneve_opts_set_u32(geneve, NFT_OBJECT_TUNNEL_GENEVE_OPT_TYPE, geneve->geneve_type);
        nftnl_obj_tunnel_geneve_opts_set_data(geneve, NFT_OBJECT_TUNNEL_GENEVE_OPT_DATA,
					      geneve->data, geneve->data_len);

        nftnl_obj_tunnel_add_geneve_opts(nlo, geneve);

(nlo/nftnl_tunnel and nftnl_obj_tunnel_geneve_opts would be similar to
 nftnl_chain vs nftnl_rule).

The major downside is a lot of more API calls that need to be added to
libnftnl :-(

I don't see any other solutions at this time.
