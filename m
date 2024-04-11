Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CB214AD2C
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2024 12:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712837605; cv=none; b=kMmETzlTf2Qk0Lv76Ohd9vglCFE9wJoN6C3VDJhFfM1qJhskDqWIeyaj+Wt2ysIiNA2L/iMfZLwbRyt/T6kYfe31+xVkJBeCxG44HeFR30tsFVx0/kP1LtSUd+vGP06L/mHSa/UXaxxQskuCBODtzz6N/AFOYdlxgngloXyFPuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712837605; c=relaxed/simple;
	bh=XFjpdsupKmxSTwUCwGmn7D5a9EePQQttmPn/FP39ses=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tkrWsDIoy0crqUyT948kPWqcPrkCXpb6LJZuPi4OcdxOF2TwLgLT8WPVdoP9urKMYqpPO5NuTMzOD6m5O0skwutVWxda5v/xOyWYBBGu1+hua3Riu2YZdaVc1x6/Kg2u1NRFlFH8puPta8YhYxlaaZDOKbp8v8x8kyXEAWtPp9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rutIu-0004o6-9R; Thu, 11 Apr 2024 14:13:20 +0200
Date: Thu, 11 Apr 2024 14:13:20 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Sven Auhagen <sven.auhagen@voleatech.de>,
	netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com,
	vladbu@nvidia.com, gal@nvidia.com
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <20240411121320.GF18399@breakpoint.cc>
References: <xvnywodpmc3eui6k5kt6fnooq35533jsavkeha7af6c2fntxwm@u3bzj57ntong>
 <Zfq-1gES4VJg2zHe@calendula>
 <o7kxkadlzt2ux5bbdcsgxlfxnfedzxv4jlfd3xnhri6qpr5w3n@2vmkj5o3yrek>
 <ZfrYpvJFrrajPbHM@calendula>
 <x3qvcfxgdmurfnydhrs7ao6fmxxubmhxs2mjk24yn5zjfbo3h5@esbr3eff7bir>
 <ZhUibxdb005sYZNq@calendula>
 <uhn7bt3jdrvmczhlw3dsrinb2opr2qksnbip7asekilgczm35v@hyvzkxrgdhgn>
 <ZhetEIvz_vCB-A5D@calendula>
 <20240411110504.GE18399@breakpoint.cc>
 <ZhfMQM3KXi9dCBUd@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhfMQM3KXi9dCBUd@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I see no reason whatsoever why we need to do this, fin can be passed up
> > to conntrack and conntrack can and should handle this without any extra
> > mucking with the nf_conn state fields from flowtable infra.
> 
> You mean, just let the fin packet go without tearing down the flow
> entry?

Yes, thats what I meant.  RST would still remove the flow entry.

> > The only cases where I see why we need to take action from
> > flowtable layer are:
> > 
> > 1. timeout extensions of nf_conn from gc worker to prevent eviction
> > 2. removal of the flowtable entry on RST reception. Don't see why that
> >    needs state fixup of nf_conn.
> 
> Remove it right away then is what you propose?

Isn't that what is happeing right now?  We set TEARDOWN bit and
remove OFFLOAD bit from nf_conn.

I think we should NOT do it for FIN and let conntrack handle this,
but we should still do it for RST.

Technically I think we could also skip it for RST but I don't see
a big advantage.  For FIN it will keep offloading in place which is
a win for connetions where one end still sends more data.

> > 3. removal of the flowtable entry on hard failure of
> >    output routines, e.g. because route is stale.
> >    Don't see why that needs any nf_conn changes either.
> 
> if dst is stale, packet needs to go back to classic path to get a
> fresh route.

Yes, sure.  But I would keep the teardown in place that we have now,
I meant to say that the current code makes sense to me, i.e.:

if (!nf_flow_dst_check(&tuplehash->tuple)) {
	flow_offload_teardown(flow);
	return 0;
}

> > My impression is that all these conditionals paper over some other
> > bugs, for example gc_worker extending timeout is racing with the
> > datapath, this needs to be fixed first.
> 
> That sounds good. But I am afraid some folks will not be happy if TCP
> flow becomes stateless again.

I do not know what that means.  There can never be a flowtable entry
without a backing nf_conn, so I don't know what stateless means in this
context.
