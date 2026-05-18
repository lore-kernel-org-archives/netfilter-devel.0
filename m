Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2052302CD5
	for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 22:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141675; cv=none; b=rrw6x9nX7jjW9GfJn3D9/D6iN7Bi3Lf6U3d56nVqY7dcdltB4mpwEurfxrDLTZrMlI20irLwLdkEdluGXTvoMFaFUfwOA3/upd0LyWcEuvwB8Q0L8X/Klz4wpuZJsJXHZpgAZzbP4AXnzfHjgCTV5MHhMHQLnlAHFCmZ0mQO/dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141675; c=relaxed/simple;
	bh=WRfzVV/uagex8qvOdVAvuTN8zOdMkgdQ4y1/pDwHgPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qyhV30SZL6VfkAr6hXUGARzVqAE6pMFkb/C6LtbwHRc50n3DI5ugCVvRb0pcFSV/BxiFMLCeVHmwDvZldcvR4Lz6uTVA8WD53K0XQAVEC/PL7fVnQd2nrEpP2ygcH/fHfkPdgI7I6oF+svClxd4bZM3ZaauOghUjx+TYTfW/UlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 59112607E9; Tue, 19 May 2026 00:01:11 +0200 (CEST)
Date: Mon, 18 May 2026 23:49:55 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: conntrack: add dead flag to helpers
Message-ID: <aguJgxyz9OemEwlZ@strlen.de>
References: <20260514143016.874811-1-pablo@netfilter.org>
 <agXfhQb8Dcl9p5ce@strlen.de>
 <agXl-3NDpK3YUZiF@chamomile>
 <agXt-m9yN-oayY1G@strlen.de>
 <agZbFvp_KgGUr2Kw@chamomile>
 <agZg3JjBx6xXyEnW@strlen.de>
 <agZkiu4q1Ln9ImR4@chamomile>
 <agZm_JyKhSFOrV94@chamomile>
 <agcQ90JCmlkojf6s@strlen.de>
 <agtjebGnfVh6VZ32@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agtjebGnfVh6VZ32@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Just to close this previous thread now that we're mixing things here:
> No issue with unconfirmed conntrack that gets enqueued in nfqueue
> since 
> 
>   c56716c69ce1 ("netfilter: extensions: introduce extension genid count")
> 
> handles the unconfirmed ct sitting in nfqueue or elsewhere.

Sorry :-(   There are so many things going on that I am losing track
of some stuff.

Yes, I think its fine but I need/want to go over this in detail.  Not
sure I can though, I am tied up with non-software related things
tomorrow.  I hope I can look into the conntrack stuff on Wed or
Thursday.

> Are you referring to this specifically?
> 
> "This isn't an issue introduced by this patch, but does destroy_gre_conntrack()
> safely cast the master connection's helper data?
> If an unprivileged attacker with CAP_NET_ADMIN uses ctnetlink to create a GRE
> expectation linked to a master connection that uses a different helper
> (like FTP) or no helper at all, the function blindly casts the helper data
> to struct nf_ct_pptp_master.
> Since FTP helper data contains attacker-controllable sequence numbers, could
> this cause list_del_rcu() and kfree_rcu() to operate on attacker-controlled
> addresses, leading to an arbitrary free or list corruption?"

Yes, that is waht I was referring to.

> I don't think that is really possible via ctnetlink:
> 
> - ctnetlink_alloc_expect() currently checks if nfct_help() exists,
>   otherwise it reports EOPNOTSUPP.
> 
> - ctnetlink_alloc_expect() uses the existing helper in the master
>   conntrack to create the expectation.
> 
> - exp->assign_helper attaches a helper to the expected conntrack.
>   But that is a basically a new different conntrack.

Thank you for these pointers.  The bug would only manifest if you can
make a GRE conntrack entry whose ct->master is tracked by FTP for instance.

> > Proposal: Get rid of data[] and nfct_help_data().  Explicit structure,
> > explicit helpers (e.g. nfct_help_data_sip(), type enum in nf_conn_help.
> 
> I don't see how yet this access to mismatching helper data type area
> can happen.

Great :-)

> > Callers must handle NULL return value everywhere (wrong helper type,
> > helper invalidated, etc).
> 
> Yes, callers must handle NULL in nfct_help_data() because the helper
> extension might become stale as per c56716c69ce1.

I will work on something for nf-next to handle this. I spent yesterday
looking at helper infra and there is some code that can be axed,
leftovers from autoassign days.   I'll work on that.

> > static int unhelp(struct nf_conn *ct, void *me)
> > {
> >         struct nf_conn_help *help = nfct_help(ct);
> > 
> >         if (help && rcu_dereference_raw(help->helper) == me) {
> >                 nf_conntrack_event(IPCT_HELPER, ct);
> >                 RCU_INIT_POINTER(help->helper, NULL);
> >         }
> > 
> > This can't be right, we lose the ->destroy() CB?
> 
> Yes, I think .destroy should be called from unhelp() path otherwise
> pptp info will remain in the GRE keymap.

I'll send/apply a patch to do that this week and will include it in PR.

> > Ideally we could get rid of ->destroy, but that would require
> > permanent removal of pptp.
> 
> This is the only user of ->destroy, I think the pptp helper is a
> candidate to be deprecated.

Yes, its the only user of this destructor.  I'll make a patch for
nf-next to add deprecation tags (pr_warn_once + Kconfig).

Thanks Pablo!
