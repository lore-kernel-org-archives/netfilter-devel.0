From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: ctnetlink: allow userspace to set labels
Date: Tue, 27 Nov 2012 13:31:49 +0100
Message-ID: <20121127123149.GA2351@1984>
References: <1352994915-3859-1-git-send-email-fw@strlen.de>
 <1352994915-3859-4-git-send-email-fw@strlen.de>
 <20121127111838.GA28064@1984>
 <20121127115000.GA14156@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38143 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab2K0McB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:32:01 -0500
Content-Disposition: inline
In-Reply-To: <20121127115000.GA14156@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 27, 2012 at 12:50:00PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > +#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
> > > +int nfnetlink_connlabel_set(struct nf_conn *ct, const void *data, unsigned int length)
> > > +{
> [..]
> > > +	labels = nf_ct_labels_find(ct);
> > > +	if (!labels)
> > > +		return -ENOSPC;
> [..]
> 
> > Via ctnetlink_new_conntrack, we should be able to create and set the
> > connlabel if we want to support state-sync of connlabels.
> 
> Right.   Good point.
> 
> > That requires calling _ext_add(...) to allocate the label, based on
> > cda[CTA_LABELS], and set it. In that case we're safe to memcpy without
> > interfering with any ongoing bit testing since that conntrack is not
> > in the hashes yet.
> 
> True.  So we can't race with other _ext_add() callers either.
> I'll add this functionality, thanks for pointing this out.
> 
> > For the update case, I think we'll have to iterate over the mask and
> > use xchg to update words, thus, we avoid any interference ongoing bit
> > testing.
> 
> Could you elaborate?
> Why is memcpy not good enough here?

while updating the connlabel via memcpy, some test_bit on the
connlabel may be already happening. I was suggesting some way to avoid
racing with it.
