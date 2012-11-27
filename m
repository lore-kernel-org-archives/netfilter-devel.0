From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 3/3] netfilter: ctnetlink: allow userspace to set labels
Date: Tue, 27 Nov 2012 12:50:00 +0100
Message-ID: <20121127115000.GA14156@breakpoint.cc>
References: <1352994915-3859-1-git-send-email-fw@strlen.de>
 <1352994915-3859-4-git-send-email-fw@strlen.de>
 <20121127111838.GA28064@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49811 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003Ab2K0LuC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:50:02 -0500
Content-Disposition: inline
In-Reply-To: <20121127111838.GA28064@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
> > +int nfnetlink_connlabel_set(struct nf_conn *ct, const void *data, unsigned int length)
> > +{
[..]
> > +	labels = nf_ct_labels_find(ct);
> > +	if (!labels)
> > +		return -ENOSPC;
[..]

> Via ctnetlink_new_conntrack, we should be able to create and set the
> connlabel if we want to support state-sync of connlabels.

Right.   Good point.

> That requires calling _ext_add(...) to allocate the label, based on
> cda[CTA_LABELS], and set it. In that case we're safe to memcpy without
> interfering with any ongoing bit testing since that conntrack is not
> in the hashes yet.

True.  So we can't race with other _ext_add() callers either.
I'll add this functionality, thanks for pointing this out.

> For the update case, I think we'll have to iterate over the mask and
> use xchg to update words, thus, we avoid any interference ongoing bit
> testing.

Could you elaborate?
Why is memcpy not good enough here?
