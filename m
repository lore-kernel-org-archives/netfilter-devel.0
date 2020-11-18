Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF80C63777
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Nov 2020 12:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BABA524654
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Nov 2020 12:13:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="FfcNrT7g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgKRMNa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 07:13:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbgKRMNa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 07:13:30 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5285221F1;
        Wed, 18 Nov 2020 12:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605701609;
        bh=Hk9npYYTcYFoTOdymkyR7/vJ0NLC+SY81UtZilJlVDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FfcNrT7g9urtKkSSBcmdgfYBBuBgs0g3/rhMojttNbZ0fwBj/iACH4ZrTbGJpzhsd
         +Y44uKSR5JA9N1H2LA4GqsAsyky0aUdvHQK/coDNiaGfTtfwgv/4xJTmNzOB8rYJQH
         CJ7rlcHumAUtfpm1UgvCrTDdLp0q/bxI+Auaz/3Y=
Date:   Wed, 18 Nov 2020 12:13:24 +0000
From:   Will Deacon <will@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     subashab@codeaurora.org, pablo@netfilter.org,
        Sean Tranchetti <stranche@codeaurora.org>,
        netfilter-devel@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de
Subject: Re: [PATCH nf] x_tables: Properly close read section with
 read_seqcount_retry
Message-ID: <20201118121322.GA1821@willie-the-truck>
References: <1605320516-17810-1-git-send-email-stranche@codeaurora.org>
 <20201114165330.GM23619@breakpoint.cc>
 <2ab4bcb63cbacba12ad927621fb56aab@codeaurora.org>
 <20201116141810.GB22792@breakpoint.cc>
 <8256f40ba9b73181f121baafe12cac61@codeaurora.org>
 <20201116170440.GA26150@breakpoint.cc>
 <983d178e6f3aac81d491362ab60db61f@codeaurora.org>
 <20201116182028.GE22792@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116182028.GE22792@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi all,

[+tglx and peterz for seqcount abuse]

On Mon, Nov 16, 2020 at 07:20:28PM +0100, Florian Westphal wrote:
> subashab@codeaurora.org <subashab@codeaurora.org> wrote:
> > > > Unfortunately we are seeing it on ARM64 regression systems which
> > > > runs a
> > > > variety of
> > > > usecases so the exact steps are not known.
> > > 
> > > Ok.  Would you be willing to run some of those with your suggested
> > > change to see if that resolves the crashes or is that so rare that this
> > > isn't practical?
> > 
> > I can try that out. Let me know if you have any other suggestions as well
> > and I can try that too.
> > 
> > I assume we cant add locks here as it would be in the packet processing
> > path.
> 
> Yes.  We can add a synchronize_net() in xt_replace_table if needed
> though, before starting to put the references on the old ruleset
> This would avoid the free of the jumpstack while skbs are still
> in-flight.

I tried to make sense of what's going on here, and it looks to me like
the interaction between xt_replace_table() and ip6t_do_table() relies on
store->load order that is _not_ enforced in the code.

xt_replace_table() does:

	table->private = newinfo;

	/* make sure all cpus see new ->private value */
	smp_wmb();

	/*
	 * Even though table entries have now been swapped, other CPU's
	 * may still be using the old entries...
	 */
	local_bh_enable();

	/* ... so wait for even xt_recseq on all cpus */
	for_each_possible_cpu(cpu) {
		seqcount_t *s = &per_cpu(xt_recseq, cpu);
		u32 seq = raw_read_seqcount(s);

		if (seq & 1) {
			do {
				cond_resched();
				cpu_relax();
			} while (seq == raw_read_seqcount(s));
		}
	}

and I think the idea here is that we swizzle the table->private pointer
to point to the new data, and then wait for all pre-existing readers to
finish with the old table (isn't this what RCU is for?).

On the reader side, ip6t_do_table() does:

	addend = xt_write_recseq_begin();
	private = READ_ONCE(table->private); /* Address dependency. */

where xt_write_recseq_begin() is pretty creative:

	unsigned int addend = (__this_cpu_read(xt_recseq.sequence) + 1) & 1;
	__this_cpu_add(xt_recseq.sequence, addend);
	smp_wmb();
	return addend;

I think this can be boiled down to an instance of the "SB" litmus test:

CPU 0				CPU 1

Wtable = newinfo		Rseq = 0
smp_wmb()			Wseq = 1	(i.e. seq += 1)
Rseq = 0			smp_wmb()
<free oldinfo>			Rtable = oldinfo

Since smp_wmb() only orders store-store, then both CPUs can hoist the reads
up and we get the undesirable outcome. This should be observable on x86 too.

Given that this appears to be going wrong in practice, I've included a quick
hack below which should fix the ordering. However, I think it would be
better if we could avoid abusing the seqcount code for this sort of thing.

Cheers,

Will

--->8

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 5deb099d156d..8ec48466410a 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -376,7 +376,7 @@ static inline unsigned int xt_write_recseq_begin(void)
 	 * since addend is most likely 1
 	 */
 	__this_cpu_add(xt_recseq.sequence, addend);
-	smp_wmb();
+	smp_mb();
 
 	return addend;
 }
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index af22dbe85e2c..383a47ff0c40 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1384,10 +1384,12 @@ xt_replace_table(struct xt_table *table,
 	 * private.
 	 */
 	smp_wmb();
-	table->private = newinfo;
-
-	/* make sure all cpus see new ->private value */
-	smp_wmb();
+	WRITE_ONCE(table->private, newinfo);
+	/*
+	 * make sure all cpus see new ->private value before we load the
+	 * sequence counters
+	 */
+	smp_mb();
 
 	/*
 	 * Even though table entries have now been swapped, other CPU's
