Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00ADD15E89
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2024 15:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712850636; cv=none; b=nB1x+Cz5tsyuYMsE+juuG10mnStyNJ39agAEKv+4CKQZwdd8pxnvkrQKr6X/B4+J/gPvhwPcBs6oEcnTuDDFw71xf0rxjp+UAHyH3ktL2X7CCTIIjHOgAdy2Z1ihgp2I0qNcNCbmSR4H2medcg8rnFwTIEjsuGltAwUMmYrG2jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712850636; c=relaxed/simple;
	bh=R9iQMcxS2DYap5IKvzxSeebeL0qPNDky1EIFpFNVY6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NNjdQbuXiiu8rU7i+kSYhd3EjRoe2XLR8UrFCb2RM5Zl7WrVzOc3nrojwl58gRz8OwSqX9OF1rgOPOUA08eyzVOJhQ+najtQu2FHwqpFNWpEjnV32fygOZ9ydUm0wsfyBpCntKh41G9cBjK+nqQ834cC9fAq53RvlZ0BaR1DLR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 11 Apr 2024 17:50:30 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Sven Auhagen <sven.auhagen@voleatech.de>,
	netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com,
	vladbu@nvidia.com, gal@nvidia.com
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <ZhgGxoJyo_1vhPN_@calendula>
References: <Zfq-1gES4VJg2zHe@calendula>
 <o7kxkadlzt2ux5bbdcsgxlfxnfedzxv4jlfd3xnhri6qpr5w3n@2vmkj5o3yrek>
 <ZfrYpvJFrrajPbHM@calendula>
 <x3qvcfxgdmurfnydhrs7ao6fmxxubmhxs2mjk24yn5zjfbo3h5@esbr3eff7bir>
 <ZhUibxdb005sYZNq@calendula>
 <uhn7bt3jdrvmczhlw3dsrinb2opr2qksnbip7asekilgczm35v@hyvzkxrgdhgn>
 <ZhetEIvz_vCB-A5D@calendula>
 <20240411110504.GE18399@breakpoint.cc>
 <ZhfMQM3KXi9dCBUd@calendula>
 <20240411121320.GF18399@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240411121320.GF18399@breakpoint.cc>

On Thu, Apr 11, 2024 at 02:13:20PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > I see no reason whatsoever why we need to do this, fin can be passed up
> > > to conntrack and conntrack can and should handle this without any extra
> > > mucking with the nf_conn state fields from flowtable infra.
> > 
> > You mean, just let the fin packet go without tearing down the flow
> > entry?
> 
> Yes, thats what I meant.  RST would still remove the flow entry.

So flow entry would remain in place if fin packet is seen. Then, an
ack packet will follow fastpath while another fin packet in the other
direction will follow classic.

> > > The only cases where I see why we need to take action from
> > > flowtable layer are:
> > > 
> > > 1. timeout extensions of nf_conn from gc worker to prevent eviction
> > > 2. removal of the flowtable entry on RST reception. Don't see why that
> > >    needs state fixup of nf_conn.
> > 
> > Remove it right away then is what you propose?
> 
> Isn't that what is happeing right now?  We set TEARDOWN bit and
> remove OFFLOAD bit from nf_conn.
> 
> I think we should NOT do it for FIN and let conntrack handle this,
> but we should still do it for RST.

Conntrack will have to deal then with an entry that is completely
out-of-sync, will that work? At least a fixup to disable sequence
tracking will be required?

> Technically I think we could also skip it for RST but I don't see
> a big advantage.  For FIN it will keep offloading in place which is
> a win for connetions where one end still sends more data.

I see.

> > > 3. removal of the flowtable entry on hard failure of
> > >    output routines, e.g. because route is stale.
> > >    Don't see why that needs any nf_conn changes either.
> > 
> > if dst is stale, packet needs to go back to classic path to get a
> > fresh route.
> 
> Yes, sure.  But I would keep the teardown in place that we have now,
> I meant to say that the current code makes sense to me, i.e.:
> 
> if (!nf_flow_dst_check(&tuplehash->tuple)) {
> 	flow_offload_teardown(flow);
> 	return 0;
> }

I see, I misunderstood.

> > > My impression is that all these conditionals paper over some other
> > > bugs, for example gc_worker extending timeout is racing with the
> > > datapath, this needs to be fixed first.
> > 
> > That sounds good. But I am afraid some folks will not be happy if TCP
> > flow becomes stateless again.
> 
> I do not know what that means.  There can never be a flowtable entry
> without a backing nf_conn, so I don't know what stateless means in this
> context.

If fin does not tear down the flow entry, then the flow entry remains
in place and it holds a reference to the conntrack object, which will
not be release until 30 seconds of no traffic activity, right?

Maybe I am just missing part of what you have in mind, I still don't
see the big picture.

Would you make a quick summary of the proposed new logic?

Thanks!
