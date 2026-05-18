Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEC73845C4
	for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 19:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779131264; cv=none; b=kMk+6F4re3xv3x7H/deuhmxgVk2xrhBkYvbWApjYZbjdRV/hAC6dqovgYI+QVX2lyXUnq8qLGm+d+mzrmjeVa51xpKC7JLZm2Tz/8oV7WKOcA7QxWdcdQsE/4QzG+Og/UU1u85dgn2Dl44hVakDEYXiArb54nYhwXLVs5+p1M/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779131264; c=relaxed/simple;
	bh=YniRGpX8lTfHzdNGmFOoHW1RIjnX59dghZsUH6m3g60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YVBDo269lgiToMxfFHeAafBQ8sX4fSrDqaiwxS03s6jloO3cb4XLPx+SWQKEUTj8jSMfNtfRSsSHteKHkoA14uEH+UMHPnjj8w47HXOcj2LGpNvEJZXJywvKfYuJePi1TXkxyeIg+7UmSYG9Wgpr/ZuMpQTRrLsCxTXAXKlSUHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vY6/D/Jx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vY6/D/Jx"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 925CB604FC;
	Mon, 18 May 2026 21:07:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779131259;
	bh=xBr5LEHXZ1dxyvNYNmYfPK3Pn4h6idz29JxXeVERsfE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vY6/D/Jxq1Niw8oOMy4VBoKKrS5rkFZEHsEV2x2PlFcZl6w/WL5MZIxbI9f73i7wL
	 SkKbHB/+Tec1fVPmGy4l/t1PEImRLeeLAdO3MEuqQV+OPrswMZoSVkxOX7SCRle9/E
	 Y3vr79KOFegHfgGXAn4QNuJt7P/it/lhvn1pNnadE0v2U2X6VUp/9dHSAQM7tOH+An
	 FyDudss0Os0EdUdXIrhoePYmIal3D8N/gFFn2hG1PaLWRodgXZpvjhY5auS7kIfJPf
	 42Q/lG67ggw2kBQdx6U75he0osb7WrgwJ3BSqYoyIyhqd8gvnkfm8oaQlOMDaQazbz
	 0bDYZwVbnaVMQ==
Date: Mon, 18 May 2026 21:07:37 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: conntrack: add dead flag to helpers
Message-ID: <agtjebGnfVh6VZ32@chamomile>
References: <20260514143016.874811-1-pablo@netfilter.org>
 <agXfhQb8Dcl9p5ce@strlen.de>
 <agXl-3NDpK3YUZiF@chamomile>
 <agXt-m9yN-oayY1G@strlen.de>
 <agZbFvp_KgGUr2Kw@chamomile>
 <agZg3JjBx6xXyEnW@strlen.de>
 <agZkiu4q1Ln9ImR4@chamomile>
 <agZm_JyKhSFOrV94@chamomile>
 <agcQ90JCmlkojf6s@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <agcQ90JCmlkojf6s@strlen.de>

On Fri, May 15, 2026 at 02:26:31PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > If the module reference grab does not work, maybe add:
> >  
> >         if (unlikely(nf_conntrack_ext_genid() != ext->id)
> >                 return NULL;
> >  
> > to nfct_help() and nfct_timeout()? So access to these ct extension
> > area is always validated before hand?

Just to close this previous thread now that we're mixing things here:
No issue with unconfirmed conntrack that gets enqueued in nfqueue
since 

  c56716c69ce1 ("netfilter: extensions: introduce extension genid count")

handles the unconfirmed ct sitting in nfqueue or elsewhere.

> > > > Another alternative would be to give up on this design completely
> > > > and just grab module references :-)
> > > 
> > > But that would not be enough for userspace ct helpers, right?
> 
> This is a mess:
> 
> https://sashiko.dev/#/patchset/20260515103501.18669-1-fw%40strlen.de
> 
> No idea how to fix this yet.  Is it ok to disable cross-helper-attach
> via ctnetlink?

Are you referring to this specifically?

"This isn't an issue introduced by this patch, but does destroy_gre_conntrack()
safely cast the master connection's helper data?
If an unprivileged attacker with CAP_NET_ADMIN uses ctnetlink to create a GRE
expectation linked to a master connection that uses a different helper
(like FTP) or no helper at all, the function blindly casts the helper data
to struct nf_ct_pptp_master.
Since FTP helper data contains attacker-controllable sequence numbers, could
this cause list_del_rcu() and kfree_rcu() to operate on attacker-controlled
addresses, leading to an arbitrary free or list corruption?"

I don't think that is really possible via ctnetlink:

- ctnetlink_alloc_expect() currently checks if nfct_help() exists,
  otherwise it reports EOPNOTSUPP.

- ctnetlink_alloc_expect() uses the existing helper in the master
  conntrack to create the expectation.

- exp->assign_helper attaches a helper to the expected conntrack.
  But that is a basically a new different conntrack.

> I don't see a way to validate nfct_help_data().
>
> Proposal: Get rid of data[] and nfct_help_data().  Explicit structure,
> explicit helpers (e.g. nfct_help_data_sip(), type enum in nf_conn_help.

I don't see how yet this access to mismatching helper data type area
can happen.

> Callers must handle NULL return value everywhere (wrong helper type,
> helper invalidated, etc).

Yes, callers must handle NULL in nfct_help_data() because the helper
extension might become stale as per c56716c69ce1.

> unhelp will have to be changed to invoke the helper
> destructor as well:
> 
> static int unhelp(struct nf_conn *ct, void *me)
> {
>         struct nf_conn_help *help = nfct_help(ct);
> 
>         if (help && rcu_dereference_raw(help->helper) == me) {
>                 nf_conntrack_event(IPCT_HELPER, ct);
>                 RCU_INIT_POINTER(help->helper, NULL);
>         }
> 
> This can't be right, we lose the ->destroy() CB?

Yes, I think .destroy should be called from unhelp() path otherwise
pptp info will remain in the GRE keymap.

> Ideally we could get rid of ->destroy, but that would require
> permanent removal of pptp.

This is the only user of ->destroy, I think the pptp helper is a
candidate to be deprecated.
