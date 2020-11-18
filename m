Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFF2C63697
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Nov 2020 12:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF12324199
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Nov 2020 12:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgKRMmj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 07:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgKRMmj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 07:42:39 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625DDC0613D6
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2020 04:42:39 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kfMn6-0003Br-P7; Wed, 18 Nov 2020 13:42:28 +0100
Date:   Wed, 18 Nov 2020 13:42:28 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Will Deacon <will@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, subashab@codeaurora.org,
        pablo@netfilter.org, Sean Tranchetti <stranche@codeaurora.org>,
        netfilter-devel@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de
Subject: Re: [PATCH nf] x_tables: Properly close read section with
 read_seqcount_retry
Message-ID: <20201118124228.GJ22792@breakpoint.cc>
References: <1605320516-17810-1-git-send-email-stranche@codeaurora.org>
 <20201114165330.GM23619@breakpoint.cc>
 <2ab4bcb63cbacba12ad927621fb56aab@codeaurora.org>
 <20201116141810.GB22792@breakpoint.cc>
 <8256f40ba9b73181f121baafe12cac61@codeaurora.org>
 <20201116170440.GA26150@breakpoint.cc>
 <983d178e6f3aac81d491362ab60db61f@codeaurora.org>
 <20201116182028.GE22792@breakpoint.cc>
 <20201118121322.GA1821@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118121322.GA1821@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Will Deacon <will@kernel.org> wrote:
> On Mon, Nov 16, 2020 at 07:20:28PM +0100, Florian Westphal wrote:
> > subashab@codeaurora.org <subashab@codeaurora.org> wrote:
> > > > > Unfortunately we are seeing it on ARM64 regression systems which
> > > > > runs a
> > > > > variety of
> > > > > usecases so the exact steps are not known.
> > > > 
> > > > Ok.  Would you be willing to run some of those with your suggested
> > > > change to see if that resolves the crashes or is that so rare that this
> > > > isn't practical?
> > > 
> > > I can try that out. Let me know if you have any other suggestions as well
> > > and I can try that too.
> > > 
> > > I assume we cant add locks here as it would be in the packet processing
> > > path.
> > 
> > Yes.  We can add a synchronize_net() in xt_replace_table if needed
> > though, before starting to put the references on the old ruleset
> > This would avoid the free of the jumpstack while skbs are still
> > in-flight.
> 
> I tried to make sense of what's going on here, and it looks to me like
> the interaction between xt_replace_table() and ip6t_do_table() relies on
> store->load order that is _not_ enforced in the code.
> 
> xt_replace_table() does:
> 
> 	table->private = newinfo;
> 
> 	/* make sure all cpus see new ->private value */
> 	smp_wmb();
> 
> 	/*
> 	 * Even though table entries have now been swapped, other CPU's
> 	 * may still be using the old entries...
> 	 */
> 	local_bh_enable();
> 
> 	/* ... so wait for even xt_recseq on all cpus */
> 	for_each_possible_cpu(cpu) {
> 		seqcount_t *s = &per_cpu(xt_recseq, cpu);
> 		u32 seq = raw_read_seqcount(s);
> 
> 		if (seq & 1) {
> 			do {
> 				cond_resched();
> 				cpu_relax();
> 			} while (seq == raw_read_seqcount(s));
> 		}
> 	}
> 
> and I think the idea here is that we swizzle the table->private pointer
> to point to the new data, and then wait for all pre-existing readers to
> finish with the old table (isn't this what RCU is for?).

Yes and yes.   Before the current 'for_each_possible_cpu() + seqcount
abuse the abuse was just implicit; xt_replace_table did NOT wait for
readers to go away and relied on arp, eb and ip(6)tables to store the
counters back to userspace after xt_replace_table().

This meant a read_seqcount_begin/retry for each counter & eventually
gave complaits from k8s users that x_tables rule replacement was too
slow.

[..]

> Given that this appears to be going wrong in practice, I've included a quick
> hack below which should fix the ordering. However, I think it would be
> better if we could avoid abusing the seqcount code for this sort of thing.

I'd be ok with going via the simpler solution & wait if k8s users
complain that its too slow.  Those memory blobs can be huge so I would
not use call_rcu here.

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index af22dbe85e2c..b5911985d1eb 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1384,7 +1384,7 @@ xt_replace_table(struct xt_table *table,
         * private.
         */
        smp_wmb();
-       table->private = newinfo;
+       WRITE_ONCE(table->private, newinfo);
 
        /* make sure all cpus see new ->private value */
        smp_wmb();
@@ -1394,19 +1394,7 @@ xt_replace_table(struct xt_table *table,
         * may still be using the old entries...
         */
        local_bh_enable();
-
-       /* ... so wait for even xt_recseq on all cpus */
-       for_each_possible_cpu(cpu) {
-               seqcount_t *s = &per_cpu(xt_recseq, cpu);
-               u32 seq = raw_read_seqcount(s);
-
-               if (seq & 1) {
-                       do {
-                               cond_resched();
-                               cpu_relax();
-                       } while (seq == raw_read_seqcount(s));
-               }
-       }
+       synchronize_rcu();
 
        audit_log_nfcfg(table->name, table->af, private->number,
                        !private->number ? AUDIT_XT_OP_REGISTER :

