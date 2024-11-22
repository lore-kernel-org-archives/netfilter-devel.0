Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6F380604
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Nov 2024 18:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732299498; cv=none; b=SWn7XedvoCF/X1U9Q/YMDgF86O//9tctqenvStbclKUhnHKdfSN1fi7ujvkeEMqJMJuybsDFTzQOmyMh1o7J95Mzowkthbg+v+q7s4JTvn2hdc8AWWEkyYXgSBvjdtZ5PnHRUe06pYhX2VqpAusfdt81XlvHEEmBWq1U7WCU+cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732299498; c=relaxed/simple;
	bh=X8gNt6WpiJobdZO1wgKocZlXDz4ib1z1QMTRJBkGacQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ewJiXPunqxhzmDSeUEJUVk3L5G1sDx67fn0Wp+ZBcGRqZ5zjemqLiAGzWidn0U6pU8TVL/5seiRKRFzPIGoiCx6oMZN8bjENhD7dolC14fJMgqsNcf9tmVaU5AD7vsnLDwcN5q15JfFGLeHK1iUayaQVWY1QTOdW1v9yyiVwhXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jQg9aCnC; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jQg9aCnC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=P4tPFSYpSu3HZOtrJiVf2+h8yzGR8iJVBk509+iYjSc=; b=jQg9aCnCFIcGx0wOvgMW5PicFp
	cFfdLsEqb4E2aNwlUFwiUhUoyfBvS/hrk0VJ98uJM75lW75L36ko158qGNqtz1L5e+K3qv/LZyG2v
	vp5D1nCNJDYO5Tz4m9qFMOtkB9uaey53zxfBGPXr5wclKxH0C0WHDoAcyrkjVwYMyT/cLU1DDFyeJ
	rl4af6I8PLA0cSOYaGE8R7uF6whX1pEN8XYPqGoHphQ4aKnLx0IRRai9tbXWqJ6CpPAOw3C50Iz7o
	vAA31aZUjUwcGo6xvMkOTOkIPt9nm3a8MGY35fcauJ3p3JlxHEIVT6cP/AQHuQjyrOVl2tmXFrVDV
	7KB0vYkg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tEYEH-000000000hI-2hjT;
	Fri, 22 Nov 2024 19:18:05 +0100
Date: Fri, 22 Nov 2024 19:18:05 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v6 0/7] Dynamic hook interface binding part 1
Message-ID: <Z0DK3WKKfg3YEUPR@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Eric Garver <e@erig.me>
References: <20241023145730.16896-1-phil@nwl.cc>
 <Zzc3FV4FG8a6px7z@calendula>
 <Zzy4LTNe4a4bepmX@orbyte.nwl.cc>
 <Zz9oN_OBdCQ1wlQf@orbyte.nwl.cc>
 <Z0CJkzhOls1Dr4N2@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0CJkzhOls1Dr4N2@calendula>

On Fri, Nov 22, 2024 at 02:39:31PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 21, 2024 at 06:04:55PM +0100, Phil Sutter wrote:
> > Hi,
> > 
> > On Tue, Nov 19, 2024 at 05:09:17PM +0100, Phil Sutter wrote:
> > [...]
> > > Checking callers of nft_unregister_flowtable_net_hooks():
> > > 
> > > nf_tables_commit() calls it for DELFLOWTABLE, code-paths differ for
> > > flowtable updates or complete deletions: With the latter,
> > > nft_commit_release() calls nf_tables_flowtable_destroy() which does the
> > > UNBIND. So if deleting individual interfaces from an offloaded flowtable
> > > is supported, we may miss the UNBIND there.
> > > 
> > > __nf_tables_abort() calls it for NEWFLOWTABLE. The hooks should have
> > > been bound by nf_tables_newflowtable() (or nft_flowtable_update(),
> > > respectively) so this seems like missing UNBIND there.
> > > 
> > > Now about __nft_release_hook, I see:
> > > 
> > > nf_tables_pre_exit_net
> > > -> __nft_release_hooks
> > >   -> __nft_release_hook
> > > 
> > > Do we have to UNBIND at netns exit?
> > > 
> > > There is also:
> > > 
> > > nft_rcv_nl_event
> > > -> __nft_release_hook
> > > 
> > > I don't see where hooks of flowtables in owner flag tables are unbound.
> > 
> > So I validated these findings by adding printks to BIND and UNBIND calls
> > and performing these actions:
> > 
> > - Delete an interface from a flowtable with multiple interfaces
> > 
> > - Add a (device to a) flowtable with --check flag
> > 
> > - Delete a netns containing a flowtable
> > 
> > - In an interactive nft session, create a table with owner flag and
> >   flowtable inside, then quit
> > 
> > All these cases cause imbalance between BIND and UNBIND calls. Looking
> > at possible fixes, I wonder how things are supposed to be: When deleting
> > a flowtable, nf_tables_commit will unregister hooks (via
> > nf_unregister_net_hook), but not unlink/free them. Then, in
> > nft_commit_release, the UNBIND happens along with unlink/free. Is this
> > the correct process? Namely unregister and wait for RCU grace period
> > before performing UNBIND? Or is this arbitrary and combining unregister
> > with UBIND is OK in all cases?
> 
> Thanks for the detailed report.
> 
> Basically, add/delete interface to an existing flowtable is not
> supported by hardware offload at this stage, one option is to reject
> this by now.

Oh, that's interesting news! Is it sufficient to reject flowtable
updates if nf_flowtable::flags has NF_FLOWTABLE_HW_OFFLOAD bit set?

> Then, netns integration was never considered, because it was not clear
> to me how hardware offload mix with containers at this stage. This
> needs to be fixed. Same applies interactive nft session (owner flag).

Those two should be unproblematic though, both netns exit and owner exit
cause full flowtable deletion - basically same mechanism as for regular
'nft delete flowtable' should suffice.

> This is my mess, let me post a fix so we can soonish clean the way for
> you to follow up on your effort to allow for dynamic interface
> bindings in the next merge window once this fix gets to net.git.

Sure, thanks!

Cheers, Phil
