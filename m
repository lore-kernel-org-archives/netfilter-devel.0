From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 -next 1/2] netfilter: iptables: separate counters
 from iptables rules
Date: Fri, 29 May 2015 03:32:48 -0700
Message-ID: <1432895568.7456.69.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1432846296-26396-1-git-send-email-fw@strlen.de>
	 <1432848817.7456.30.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20150528214540.GF23992@breakpoint.cc>
	 <1432850096.7456.38.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20150529100516.GI23992@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:33332 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbbE2Kcu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 May 2015 06:32:50 -0400
Received: by igbpi8 with SMTP id pi8so11278188igb.0
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2015 03:32:50 -0700 (PDT)
In-Reply-To: <20150529100516.GI23992@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2015-05-29 at 12:05 +0200, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > How?  What address?  You mean relative offset to counter start?
> > 
> > No, the address itself. This is what I coded years ago.
> > > when rule x matches, I need to increment the corresponding counter
> > > for that rule.
> > 
> > Right. You have in the rule itself the storage for xt_counter. Thats 16
> > bytes. You only need 8 bytes (on 64bit arch) to store the percpu
> > address.
> 
> > Instead of leaving nothing in it, place the percpu address of the
> > corresponding counter. access to it is in the cache line needed to
> > analyze the entry anyway. Its free.
> 
> I'm dense.  So, what you're saying is that I should
> 
> alloc_percpu(sizeof(struct xt_counters));
> 
> for each rule and store the resulting address in ipt_entry?
> Then it would be possible to get the correct location for current cpu
> when counter has to be incremented.
> 
> Thanks Eric.

That was my plan.

When looking at perf record/report, ipt_do_table spends a lot of time in
setup phase to fetch all these indirections :

       IP_NF_ASSERT(table->valid_hooks & (1 << hook));
        local_bh_disable();
        addend = xt_write_recseq_begin();
        private = table->private;
        cpu        = smp_processor_id();
        /*
         * Ensure we load private-> members after we've fetched the base
         * pointer.
         */
        smp_read_barrier_depends();
        table_base = private->entries[cpu];
        jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
        stackptr   = per_cpu_ptr(private->stackptr, cpu);
        origptr    = *stackptr;

By storing the pointer to the percpu storage inside the ipt_entry,
you do not need an extra dereference on x86_64.

-               ADD_COUNTER(e->counters, skb->len, 1);
+               ADD_COUNTER(counters[e->comefrom], skb->len, 1);

Would be :

               ADD_COUNTER(e->pcu_addr, skb->len, 1);

If you alias/union pcu_addr and counters

You might need temporary arrays at load/dump times, but not in fast path.

x86_64 would then use

    load e->pcpu_addr into register R (assume it is %rax)
    load skb->len into %rdx

    incq %gs:(%rax)    // pcnt++
    addq %rdx,%gs:8(%rax)  // bcnt += skb->len




