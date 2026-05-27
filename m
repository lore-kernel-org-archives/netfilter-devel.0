Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715B0413256
	for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2026 13:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779889172; cv=none; b=evawV8B27pNTHcw8EWZ8eSVzhRq2bWhRNjo3BAdabh24CokPMb3BPNNiUGPSYVNVySUIFR3G0r1gWmufsnWcQ39zoNAmEK2KorvYp9xhNRaBTGzP4wJxoyPYF5K/oJ2gWhLz7BkczrmSsw0pRrrgov9OC808Nh1KnNDSKur/NC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779889172; c=relaxed/simple;
	bh=8vB6PNH5EYIKrHGMeHsKqkKHzd8mJoo3xRPmQ7v/sTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DQuPnjOaQldEqmrEcsjMWv8h9u8oFG326xMS+qVp8FDppb3BZio4d4KkQChmp1c/4bsLzAdXRAyGIlVz3kBpKPl+9AlvKtfuuPy8hOcW94AejO+Xv7aYb8SPl/YRVI5Cxv908IVfuFBiQLB3HdkFEu4PJeJEewee74emPfTkf0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AE0F56070B; Wed, 27 May 2026 15:39:24 +0200 (CEST)
Date: Wed, 27 May 2026 15:39:18 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 5/6] netfilter: nf_conntrack_helper: add
 refcounting from datapath
Message-ID: <ahb0Bgll-VmTLwlr@strlen.de>
References: <20260526164049.148218-1-pablo@netfilter.org>
 <20260526164049.148218-6-pablo@netfilter.org>
 <ahXea1N1w40Siqin@strlen.de>
 <ahYcZ_dFZpAV3B1Z@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahYcZ_dFZpAV3B1Z@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> The existing refcnt tracks references from the control plane, ie.
> rules that point to helper. The new ct_refcnt tracks references from
> ct extension.

Hmm... AFAICS its only used by userspace helpers.

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index de2f956abf34..31949f0c2755 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -33,7 +33,6 @@ struct nf_conntrack_helper {
        struct hlist_node hnode;        /* Internal use. */

        char name[NF_CT_HELPER_NAME_LEN]; /* name of the module */
-       refcount_t refcnt;
        struct module *me;              /* pointer to self */
        const struct nf_conntrack_expect_policy *expect_policy;

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 17e971bd4c74..c3698885e4ba 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -92,10 +92,6 @@ nf_conntrack_helper_try_module_get(const char *name, u16 l3num, u8 protonum)
 #endif
        if (h != NULL && !try_module_get(h->me))
                h = NULL;
-       if (h != NULL && !refcount_inc_not_zero(&h->refcnt)) {
-               module_put(h->me);
-               h = NULL;
-       }

        rcu_read_unlock();

@@ -105,7 +101,6 @@ EXPORT_SYMBOL_GPL(nf_conntrack_helper_try_module_get);

 void nf_conntrack_helper_put(struct nf_conntrack_helper *helper)
 {
-       refcount_dec(&helper->refcnt);
        module_put(helper->me);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_put);
@@ -387,7 +382,7 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
                        }
                }
        }
-       refcount_set(&me->refcnt, 1);
+
        hlist_add_head_rcu(&me->hnode, &nf_ct_helper_hash[h]);
        nf_ct_helper_count++;
 out:

... seems fine to me.  Unload is blocked by module refcount.
This breaks with CONFIG_NF_CT_NETLINK_HELPER=m|y, of course.

But I don't see the need for a separate helper either.
AFAICS one could simply ignore the refcount on delete request:
Instead of -EBUSY, -> refcount_dec + unlink from data structure.

All other refcount holders need their own reference anyway.
memory release on 1 -> 0 transition.

If thats correct then we could use same refcount for both userspace
helpers and datapath.

But it looks like this refcnt is wrong in any case and should instead
live in struct nfnl_cthelper -- its not related to the (c-implemented)
helper backends.

> ct helper. The idea is to allow track the helper in memory so it does
> not go away even in module is removed/userspace helper is destroyed.

Yes, just so we are on the same page: that part makes sense to me.

> > > +	/* This helper is going away, disable it. */
> > > +	rcu_assign_pointer(me->help, NULL);
> > > +
> > 
> > OK, so this signals pending removal (refcnt can still be elevated) to
> > prevent new packets/expectations from grabbing another reference.
> > Correct?  Is this a 'dying' flag or is there more to it?
> 
> Yes, this is a "dying flag".

Ok.

> > I looked at patched 'nf_conntrack_ftp_fini', but I don't see anything
> > that spins/waits for completion of referencing entries.
> 
> Given the helper object is allocated dynamically, it will remain
> around until last reference is dropped.

Yes, I see that now.  I was confused by other callbacks, esp.
->destroy, remaining initialised.

> .help is set to NULL.
> .to_nlattr and .from_nlattr are disabled.
> .destroy, I moved it to nf_conntrack with the intention that this
> pointer is not stale.

OK, so its in same module and followup patch could replace callback by a
direct call.

> > I suspect you need to move the function pointers to an 'op' sub-struct,
> > so that it can be cleared via single rcu_assign_pointer(me->help_ops, NULL) ?
> 
> I think I cannot disable .destroy that way, it clears the GRE entries
> which release the pptp mappings.

Yes, I missed the fact that this is moved to the core.

> > Maybe we need to accelerate pptp removal so the only user of destroy
> > is removed?
> 
> Flagging it as deprecated is convenient for distributors to stop
> compiling this, noone should be using this pptp in 2026 I think.

Agreed.

> I'd rather see a more simple fix, but I am not sure this can be fixed
> for all scenarios (sashiko mentioned also a skb could be sitting in
> nf_defrag with a template conntrack with helper/timeout reference, so
> nfqueue is no the only queue around).

Yes, agreed.  I don't think there is a simple fix for this problem and
I think the direction taken here is sound.
