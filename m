Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018243C8717
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 08:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779178078; cv=none; b=UiMklnO5WaTgaRJ1snZl5cXcUkWpTiAvcoTUxltYikBHF7QGJgQ/Je+PrI0JXM9MU8mPvm1uCK67pFhDJ6TV96WFHNQD1S17+1NcMx4rS0lFlLSYUVu0U/ME/7JdCOvh9FRxqIhNH/ShO1Idxc+UIIKmVzlUEkLMBIDK6gkELqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779178078; c=relaxed/simple;
	bh=vSw/U/ID5cJ9yeZ+PmOjBM7kOipQ7tVkMmt5n4edUAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RcAH+IRQlEZ8pAkfeS6sURQ11K1mu4poVNg2ueGGvmqHZoHLLy47CPQqdYaa6/zFSMvjX+vazdeBO1eCXnlIyiRrS+qJYaiDtvIxvsNlLTJq0VxEaxG7q6+s8wSuE7zvGnHFGxlxh4tYgYpmMbmUm4QKsEf1ce16YvPBxWemhYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Qb9oIW2X; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Qb9oIW2X"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A8E02601AC;
	Tue, 19 May 2026 10:07:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779178074;
	bh=eoUPEiIdagalIak4XjQ6ddMKlo20ZH/vP6fX9LRnqEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qb9oIW2XxIu75fBnLVzVEu9nkYizP7DHJDZTmgiitzsfqsx/t7Ufwx45gsCqAz6rV
	 5i+B7qRMjYmICLDqQk5Q4mtpMT2leP0N5f/BoceVEza6HvfZJ09eLvV7IhP/nqAsW8
	 IqLEwVZTVNIFw9f0KvWnmowT9lOljmkrKSzvmKkeahn3wdZatMVHBLxUeV+gB9cn0f
	 ahxIrs52r7C7X6JIQW2FboYkqDmZUMSFt6GEdIcPYYv1HIzEKkfjplldnIjFkMw7rH
	 R42B+h0Y3qWHz23a+SVb59b37vuMPCwF1cxJxNb3m0a6PzpgXz9/Uiwc/WnPYIYg5R
	 cBdCJ4QG4ANDw==
Date: Tue, 19 May 2026 10:07:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: conntrack: add dead flag to helpers
Message-ID: <agwaV0TKYW9G0zPk@chamomile>
References: <agXfhQb8Dcl9p5ce@strlen.de>
 <agXl-3NDpK3YUZiF@chamomile>
 <agXt-m9yN-oayY1G@strlen.de>
 <agZbFvp_KgGUr2Kw@chamomile>
 <agZg3JjBx6xXyEnW@strlen.de>
 <agZkiu4q1Ln9ImR4@chamomile>
 <agZm_JyKhSFOrV94@chamomile>
 <agcQ90JCmlkojf6s@strlen.de>
 <agtjebGnfVh6VZ32@chamomile>
 <aguJgxyz9OemEwlZ@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aguJgxyz9OemEwlZ@strlen.de>

On Mon, May 18, 2026 at 11:49:55PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Just to close this previous thread now that we're mixing things here:
> > No issue with unconfirmed conntrack that gets enqueued in nfqueue
> > since 
> > 
> >   c56716c69ce1 ("netfilter: extensions: introduce extension genid count")
> > 
> > handles the unconfirmed ct sitting in nfqueue or elsewhere.
> 
> Sorry :-(   There are so many things going on that I am losing track
> of some stuff.

I can help collect patches in this round too.

> Yes, I think its fine but I need/want to go over this in detail.  Not
> sure I can though, I am tied up with non-software related things
> tomorrow.  I hope I can look into the conntrack stuff on Wed or
> Thursday.
> 
> > Are you referring to this specifically?
> > 
> > "This isn't an issue introduced by this patch, but does destroy_gre_conntrack()
> > safely cast the master connection's helper data?
> > If an unprivileged attacker with CAP_NET_ADMIN uses ctnetlink to create a GRE
> > expectation linked to a master connection that uses a different helper
> > (like FTP) or no helper at all, the function blindly casts the helper data
> > to struct nf_ct_pptp_master.
> > Since FTP helper data contains attacker-controllable sequence numbers, could
> > this cause list_del_rcu() and kfree_rcu() to operate on attacker-controlled
> > addresses, leading to an arbitrary free or list corruption?"
> 
> Yes, that is waht I was referring to.
> 
> > I don't think that is really possible via ctnetlink:
> > 
> > - ctnetlink_alloc_expect() currently checks if nfct_help() exists,
> >   otherwise it reports EOPNOTSUPP.
> > 
> > - ctnetlink_alloc_expect() uses the existing helper in the master
> >   conntrack to create the expectation.
> > 
> > - exp->assign_helper attaches a helper to the expected conntrack.
> >   But that is a basically a new different conntrack.
> 
> Thank you for these pointers.  The bug would only manifest if you can
> make a GRE conntrack entry whose ct->master is tracked by FTP for instance.
> 
> > > Proposal: Get rid of data[] and nfct_help_data().  Explicit structure,
> > > explicit helpers (e.g. nfct_help_data_sip(), type enum in nf_conn_help.
> > 
> > I don't see how yet this access to mismatching helper data type area
> > can happen.
> 
> Great :-)
> 
> > > Callers must handle NULL return value everywhere (wrong helper type,
> > > helper invalidated, etc).
> > 
> > Yes, callers must handle NULL in nfct_help_data() because the helper
> > extension might become stale as per c56716c69ce1.
> 
> I will work on something for nf-next to handle this. I spent yesterday
> looking at helper infra and there is some code that can be axed,
> leftovers from autoassign days.   I'll work on that.

Posted a patch for this, it needs another spin.

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260518191232.1053294-3-pablo@netfilter.org/

I will take care of this.

> > > static int unhelp(struct nf_conn *ct, void *me)
> > > {
> > >         struct nf_conn_help *help = nfct_help(ct);
> > > 
> > >         if (help && rcu_dereference_raw(help->helper) == me) {
> > >                 nf_conntrack_event(IPCT_HELPER, ct);
> > >                 RCU_INIT_POINTER(help->helper, NULL);
> > >         }
> > > 
> > > This can't be right, we lose the ->destroy() CB?
> > 
> > Yes, I think .destroy should be called from unhelp() path otherwise
> > pptp info will remain in the GRE keymap.
> 
> I'll send/apply a patch to do that this week and will include it in PR.

OK.

> > > Ideally we could get rid of ->destroy, but that would require
> > > permanent removal of pptp.
> > 
> > This is the only user of ->destroy, I think the pptp helper is a
> > candidate to be deprecated.
> 
> Yes, its the only user of this destructor.  I'll make a patch for
> nf-next to add deprecation tags (pr_warn_once + Kconfig).

OK. Would you just respin of the GRE kmap issues that sashiko reported?

Otherwise I can pick up on it.
