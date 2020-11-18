Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F3EC63697
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Nov 2020 13:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26753208FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Nov 2020 13:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgKRNOZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 08:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgKRNOY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 08:14:24 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFEBC0613D4
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2020 05:14:24 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kfNHv-0003Ld-KJ; Wed, 18 Nov 2020 14:14:19 +0100
Date:   Wed, 18 Nov 2020 14:14:19 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Will Deacon <will@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, subashab@codeaurora.org,
        pablo@netfilter.org, Sean Tranchetti <stranche@codeaurora.org>,
        netfilter-devel@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de
Subject: Re: [PATCH nf] x_tables: Properly close read section with
 read_seqcount_retry
Message-ID: <20201118131419.GK22792@breakpoint.cc>
References: <20201114165330.GM23619@breakpoint.cc>
 <2ab4bcb63cbacba12ad927621fb56aab@codeaurora.org>
 <20201116141810.GB22792@breakpoint.cc>
 <8256f40ba9b73181f121baafe12cac61@codeaurora.org>
 <20201116170440.GA26150@breakpoint.cc>
 <983d178e6f3aac81d491362ab60db61f@codeaurora.org>
 <20201116182028.GE22792@breakpoint.cc>
 <20201118121322.GA1821@willie-the-truck>
 <20201118124228.GJ22792@breakpoint.cc>
 <20201118125406.GA2029@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118125406.GA2029@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Will Deacon <will@kernel.org> wrote:
> > diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> > index af22dbe85e2c..b5911985d1eb 100644
> > --- a/net/netfilter/x_tables.c
> > +++ b/net/netfilter/x_tables.c
> > @@ -1384,7 +1384,7 @@ xt_replace_table(struct xt_table *table,
> >          * private.
> >          */
> >         smp_wmb();
> > -       table->private = newinfo;
> > +       WRITE_ONCE(table->private, newinfo);
> 
> ... you could make this rcu_assign_pointer() and get rid of the preceding
> smp_wmb()...

Yes, it would make sense to add proper rcu annotation as well.

> >         /* make sure all cpus see new ->private value */
> >         smp_wmb();
> 
> ... and this smp_wmb() is no longer needed because synchronize_rcu()
> takes care of the ordering.

Right, thanks.

> > @@ -1394,19 +1394,7 @@ xt_replace_table(struct xt_table *table,
> >          * may still be using the old entries...
> >          */
> >         local_bh_enable();
> > -
> > -       /* ... so wait for even xt_recseq on all cpus */
> > -       for_each_possible_cpu(cpu) {
> > -               seqcount_t *s = &per_cpu(xt_recseq, cpu);
> > -               u32 seq = raw_read_seqcount(s);
> > -
> > -               if (seq & 1) {
> > -                       do {
> > -                               cond_resched();
> > -                               cpu_relax();
> > -                       } while (seq == raw_read_seqcount(s));
> > -               }
> > -       }
> 
> Do we still need xt_write_recseq_{begin,end}() with this removed?

Yes, it enables userspace to get stable per rule packet and byte counters.
