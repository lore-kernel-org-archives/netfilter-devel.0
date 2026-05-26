Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370D63C6A27
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 22:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779833973; cv=none; b=paWklw7ILDnugkOcyzFvQbVFmRkFI/7rPMnqz5ba2Y2jc8IKEIg7geeC9icOTZOpJ531LV0q+GkTKhf+mSBuRQ6+9vbQSri5HfnYt6cvjecmWuYB8vgaAQmwqa+rWsgwDbvKmpJEgqXVyk6AqTtIzAV4Uis5g7ouvZsDDU3ryEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779833973; c=relaxed/simple;
	bh=BQ4E4sS0YEo8uKzfL1VS6Nug0cDh4xiOMySuo9Jj/iI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PjpHWIW9SAoqEcJ8yFG37TNei/nKrmA1gxzFq7t0FSXQ/DgZjHX23YLruSHDPxyQdYxLu+y5MJATuFUaHTBMbE6ewIhS4eQ6K9ET0DOoMDP2BgMI5vS/S5ZyuK38QUWRmiWa2cxf71PN5kptfVQGhsPnjx0Dss1EOXJ6MntGl5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EEKE0euA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EEKE0euA"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B9CCA600B5;
	Wed, 27 May 2026 00:19:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779833962;
	bh=aCFn09vXwlBayk6s0ga84mqWqXhsn2Po6I/z0DA5yHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EEKE0euAPXcn1qs5MSkRhYkoH7HJFcM3gjVTod9SAM1rYFeSArOaepup0WjmsquOD
	 ZDmOhmWRacPwOmiGY2VxTn+lxdTnOPXTR62QKqvMfjetSwHEkYhSRrnnDVckMQCXm2
	 KKsJrLoa0dLyFzzspajbaGTEyOJM8NQeVdOoYcDgemtXQTGpDEH5tFGsAkVMX2IC2f
	 A56GBvzs11U6l77IuJHwQGPaWajRESNbsYw58oeFRvlT1hal2qBg/+g++rHJKfNCND
	 qtik0eefEJiM4oB86Jtj4W8jWfCmrUJxjQ6IqBabpg2MjNKXd0mCPhFp2tZFwJiO6d
	 R9JucGB+kJrCg==
Date: Wed, 27 May 2026 00:19:19 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 5/6] netfilter: nf_conntrack_helper: add
 refcounting from datapath
Message-ID: <ahYcZ_dFZpAV3B1Z@chamomile>
References: <20260526164049.148218-1-pablo@netfilter.org>
 <20260526164049.148218-6-pablo@netfilter.org>
 <ahXea1N1w40Siqin@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ahXea1N1w40Siqin@strlen.de>

Hi Florian,

On Tue, May 26, 2026 at 07:54:51PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> > index 1956bc12bf56..a03cb4e59ea9 100644
> > --- a/include/net/netfilter/nf_conntrack_helper.h
> > +++ b/include/net/netfilter/nf_conntrack_helper.h
> > @@ -35,20 +35,23 @@ enum nf_ct_helper_flags {
> >  struct nf_conntrack_helper {
> >  	struct hlist_node hnode;	/* Internal use. */
> >  
> > +	struct rcu_head rcu;
> > +
> >  	char name[NF_CT_HELPER_NAME_LEN]; /* name of the module */
> >  	refcount_t refcnt;
> >  	struct module *me;		/* pointer to self */
> >  	struct nf_conntrack_expect_policy expect_policy[NF_CT_MAX_EXPECT_CLASSES];
> >  
> > +	refcount_t ct_refcnt;
> 
> Why do we need two reference counts?  I find this very confusing.
> Which refcount frees the structure?  And can one refcount hit 0 while
> other one is still in use?

The existing refcnt tracks references from the control plane, ie.
rules that point to helper. The new ct_refcnt tracks references from
ct extension.

If the ruleset is flushed, then it is possible to unregister the
helper, otherwise EBUSY is reported. On the other hand, the ct_refcnt
tracks references by ct extension, eg. skb sitting in nfqueue with a
ct helper. The idea is to allow track the helper in memory so it does
not go away even in module is removed/userspace helper is destroyed.

Thus, helper can be removed anytime if ruleset does not use it, but
ct extension that still use the helper hold a reference on ct_refcnt
so it cannot be release. It is a two-level refcount strategy: The
control plane refcnt allows to remove the helper anytime, but the
dataplane refcnt can only be removed if control plane removed the
helper and no ct extension use it.

If I use a single refcnt (the existing one), then a packet sitting in
nfqueue can postpone the module removal of the helper indefinitely.

BTW, there is one single fix I can target to nf.git which is to
disallow userspace helpers in init_user_ns. Userspace helpers have no
netns support, I can post such small patch for inclusion. Still, the
unconfirmed ct race + nfqueue can theoretically still happen without
this series.

> >  	/* Function to call when data passes; return verdict, or -1 to
> >             invalidate. */
> > -	int (*help)(struct sk_buff *skb,
> > -		    unsigned int protoff,
> > -		    struct nf_conn *ct,
> > -		    enum ip_conntrack_info conntrackinfo);
> > +	int __rcu (*help)(struct sk_buff *skb, unsigned int protoff,
> > +			  struct nf_conn *ct,
> > +			  enum ip_conntrack_info conntrackinfo);
> >  
> >  	void (*destroy)(struct nf_conn *ct);
> 
> Why is help RCU protected while other callbacks are not?

As you said above, this is the "dying flag".

> 'destroy' not being rcu protected implies that the helper module must
> remain in memory until after kfree_rcu has released the underlying
> storage anyway.

The only existing .destroy function is not moved in this series to
nf_conntrack_proto_gre.c which is part of the nf_conntrack module.

> If thats true, why do we need rcu head and kfree_rcu in the first place?

Because of userspace helpers, they do not depend on modules, they can
be removed via nfnetlink_cthelper anytime.

> module has to remain in memory until after last possible caller has
> called me->destroy(), no?  If that is correct, then there is no need for
> dynamically allocated storage.

Maybe, but not related to ->destroy(), userspace helpers still are
there.

> > @@ -445,19 +432,18 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
> >  	nf_ct_helper_count--;
> >  	mutex_unlock(&nf_ct_helper_mutex);
> >  
> > +	/* This helper is going away, disable it. */
> > +	rcu_assign_pointer(me->help, NULL);
> > +
> 
> OK, so this signals pending removal (refcnt can still be elevated) to
> prevent new packets/expectations from grabbing another reference.
> Correct?  Is this a 'dying' flag or is there more to it?

Yes, this is a "dying flag".

> I looked at patched 'nf_conntrack_ftp_fini', but I don't see anything
> that spins/waits for completion of referencing entries.

Given the helper object is allocated dynamically, it will remain
around until last reference is dropped.

> How does ->destroy/to_nlattr/from_nlattr etc. work?
> 
> I expected to find something that does a busywait until refcount has
> hit 0 to avoid any calls to the removed module.
> 
> The existing conntracks still hold a pointer to struct
> nf_conntrack_helper, and its refcount can be elevated too, while
> function pointers (not help, but others) are stale.

.help is set to NULL.
.to_nlattr and .from_nlattr are disabled.
.destroy, I moved it to nf_conntrack with the intention that this
pointer is not stale.

> I suspect you need to move the function pointers to an 'op' sub-struct,
> so that it can be cleared via single rcu_assign_pointer(me->help_ops, NULL) ?

I think I cannot disable .destroy that way, it clears the GRE entries
which release the pptp mappings.

> But that still has one problem: if helper module is gone, how can you
> call the destructor?

In this series, the only .destroy callback resides in nf_conntrack.

> Maybe we need to accelerate pptp removal so the only user of destroy
> is removed?

Flagging it as deprecated is convenient for distributors to stop
compiling this, noone should be using this pptp in 2026 I think.

I'd rather see a more simple fix, but I am not sure this can be fixed
for all scenarios (sashiko mentioned also a skb could be sitting in
nf_defrag with a template conntrack with helper/timeout reference, so
nfqueue is no the only queue around).

Let me know, thanks for you comments.
