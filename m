Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7C12D781F
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Nov 2025 00:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762475513; cv=none; b=nEkrYt3MQwl5KcZjW4su51XTCmL7OlZVknNNmw5Cgzpr8/bSc1ADf/mXPWTjavPZ9SzBIC2KViJGQOoKyljx4rt4eaB0MG9csf885cplWsRSkEsPNOZQ0chKPBKGwsiV+ArI9ddgBmJIx6vtpZW+DZsCz+GPn0F0qG0dMXCfcbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762475513; c=relaxed/simple;
	bh=d8zXWmotkmUIyqbtGc33+GP7mkMgoxmLbhkc1Yc2sBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gV9XpNqrDt0BcuitVAppumsYbA3Q4CFFqdgtGHlY7uVDy22r0gAQQaCc93d+7Sl9+MGUE16rQYUhE8s3hPZTLR4nxvcVGf8I9HUGU5y+3CL534CuVjiqDspV0ZP9Wq917MT5lWE9FVNedgy8sChB2kTIGl5IyjSA/FUOCuxaLFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E7CF260072; Fri,  7 Nov 2025 01:31:48 +0100 (CET)
Date: Fri, 7 Nov 2025 01:31:43 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, phil@nwl.cc, aconole@redhat.com,
	echaudro@redhat.com, i.maximets@ovn.org, dev@openvswitch.org
Subject: Re: [PATCH 1/3 nf-next] netfilter: nf_conncount: only track
 connection if it is not confirmed
Message-ID: <aQ097wN8P96ni6rN@strlen.de>
References: <20251106005557.3849-1-fmancera@suse.de>
 <20251106005557.3849-2-fmancera@suse.de>
 <aQv8YE3sZ1Rp1iYG@strlen.de>
 <1f5a5a3d-a38a-4f81-9912-38242480de9c@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f5a5a3d-a38a-4f81-9912-38242480de9c@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> 
> 
> On 11/6/25 2:39 AM, Florian Westphal wrote:
> > Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> >> Since commit d265929930e2 ("netfilter: nf_conncount: reduce unnecessary
> >> GC") if nftables/iptables connlimit is used without a check for new
> >> connections there can be duplicated entries tracked.
> >>
> >> Pass the nf_conn struct directly to the nf_conncount API and check
> >> whether the connection is confirmed or not inside nf_conncount_add(). If
> >> the connection is confirmed, skip it.
> > 
> > I think there is a bit too much noise here, can this be
> > split in several chunks?
> > 
> 
> Not sure, I could try but the noise comes from removing zone and tuple 
> which requires many changes around. Otherwise this would compile with 
> warnings/errors. I am not sure I can split this more.

Ok.

> > I also see that this shared copypaste with xtables.
> > Would it be possible to pass 'const struct sk_buff *'
> > and let the nf_conncount core handle this internally?
> > 
> > nf_conncount_add(net, pf, skb, priv->list);
> > 
> > which does:
> > 	ct = nf_ct_get(skb, &ctinfo);
> > 	if (ct && !nf_ct_is_template(ct))
> > 		return __nf_conncount_add(ct, list);
> > 
> > 	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), pf, net,
> > 				&tuple))
> > 		return -ERR;
> > 
> > 	if (ct)	/* its a template, so do lookup in right zone */
> > 		zone = nf_ct_zone(ct);
> > 	else
> > 		zone = &nf_ct_zone_dflt;
> > 
> > 	h = nf_conntrack_find_get(nft_net(pkt), zone, &tuple);
> > 	if (!h)
> > 		return -ERR;
> > 
> > 	ct = nf_ct_tuplehash_to_ctrack(h);
> > 
> > 	err = __nf_conncount_add(ct, list);
> > 
> > 	nf_ct_put(ct):
> > 
> > 	return err;
> > 
> > I.e., the existing nf_conncount_add() becomes a helper that takes
> > a ct, as you have already proposed, but its renamed and turned into
> > an internal helper so frontends don't need to duplicate tuple lookup.
> > 
> > Alternatively, no need to rename it and instead add a new API call
> > that takes the ct argument, e.g. 'nf_conncount_add_ct' or whatever,
> > and then make nf_conncount_add() internal in a followup patch.
> > 
> 
> Unfortunately, I do not think this is possible. xt_connlimit is using 
> the rbtree with nf_conncount_count() while nft_connlimit isn't. I 
> believe we do not want to change that.

OK.  I had hoped one could start with refactoring nf_conncount_count()
and then after that nf_conncount_count().

> In addition, for the rbtree we
> need to calculate the key..

Right but AFAICS due to the missing 'template check' we pass all-zero
tuple_ptr if there is a template attached to the skb.
Not catastrophic but its not correct either.

I had hoped it was possible so s/tuple, zone/sk_buff/ in the
arguments and then handle that internally (first in count_tree and then
later in a converted nf_conncount_count(), i.e. push the sk_buff -> ct
handling down in followup patches.

> I would leave this code as duplicated given
> that is shared only between xt_connlimit and nft_connlimit. Openvswitch 
> doesn't care about this as they always call nf_conncount_count() while 
> holding a reference to a ct..

[..]

> No worries at all, I think there is some benefit from this change even 
> with the copy-paste. Maybe we can create a helper function to just get 
> the ct from the sk_buff.. what about "nf_conntrack_get_or_find()"? I 
> accept suggestions for a better name :)

OK, but the problem is that you need to know when you need to put the
reference and when you don't have to.

Task is:
given skb, return a
'ct' that is not a template
... but if its a template we need the zone to make a lookup ourselves
... and we have to bump (and put) refcount when we do that lookup
ourselves.

Maybe you could try adding a new api, e.g. call it
'nf_conncount_count_skb()' that then calls nf_conncount_count()
internally just to see how bad it looks?

If its not too bad, then all callers could be converted one after
another.

And then same with nf_conncount_add().

Just a suggestion, alternatively give your nf_conntrack_get_or_find()
a try, it would need a 'bool *refcounted' or similar arg and a
conditional 'if (refcounted) nf_ct_put(ct)' to be done by the callers.
