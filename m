From: Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v3 nf-next 1/2] netfilter: x_tables: wait until old table
 isn't used anymore
Date: Wed, 11 Oct 2017 11:23:28 -0700
Message-ID: <CANn89iL6m1c+7ijcfqz+31xf05M=j5jsU84SDdvLJdSDu-1E_w@mail.gmail.com>
References: <20171011142607.15026-1-fw@strlen.de> <20171011142607.15026-2-fw@strlen.de>
 <CANn89iLrM-sKFLzXkcot6T2FQWZEwe6me+ux1tHQztSc6EE90w@mail.gmail.com>
 <20171011174832.GB26835@breakpoint.cc> <CANn89iJ9r9Y1JeTzEFnyko8-h_hhdWGLw+nDLJVcMuvTm6HB0w@mail.gmail.com>
 <20171011181803.GC26835@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org, Dan Williams <dcbw@redhat.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:52982 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752502AbdJKSX3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 14:23:29 -0400
Received: by mail-ua0-f171.google.com with SMTP id i35so1626445uah.9
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2017 11:23:29 -0700 (PDT)
In-Reply-To: <20171011181803.GC26835@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 11, 2017 at 11:18 AM, Florian Westphal <fw@strlen.de> wrote:
> Eric Dumazet <edumazet@google.com> wrote:
>> On Wed, Oct 11, 2017 at 10:48 AM, Florian Westphal <fw@strlen.de> wrote:
>> > Eric Dumazet <edumazet@google.com> wrote:
>> >> On Wed, Oct 11, 2017 at 7:26 AM, Florian Westphal <fw@strlen.de> wrote:
>> >> > xt_replace_table relies on table replacement counter retrieval (which
>> >> > uses xt_recseq to synchronize pcpu counters).
>> >> >
>> >> > This is fine, however with large rule set get_counters() can take
>> >> > a very long time -- it needs to synchronize all counters because
>> >> > it has to assume concurrent modifications can occur.
>> >> >
>> >> > Make xt_replace_table synchronize by itself by waiting until all cpus
>> >> > had an even seqcount.
>> >> >
>> >> > This allows a followup patch to copy the counters of the old ruleset
>> >> > without any synchonization after xt_replace_table has completed.
>> >> >
>> >> > Cc: Dan Williams <dcbw@redhat.com>
>> >> > Cc: Eric Dumazet <edumazet@google.com>
>> >> > Signed-off-by: Florian Westphal <fw@strlen.de>
>> >> > ---
>> >> >  v3: check for 'seq is uneven' OR 'has changed' since
>> >> >  last check. Its fine if seq is uneven iff its a different
>> >> >  sequence number than the initial one.
>> >> >
>> >> >  v2: fix Erics email address
>> >> >  net/netfilter/x_tables.c | 18 +++++++++++++++---
>> >> >  1 file changed, 15 insertions(+), 3 deletions(-)
>> >> >
>> >> >
>> >>
>> >> Reviewed-by: Eric Dumazet <edumazet@google.com>
>> >>
>> >> But it seems we need an extra smp_wmb() after
>> >>
>> >>         smp_wmb();
>> >>         table->private = newinfo;
>> >> +      smp_wmb();
>> >>
>> >> Otherwise we have no guarantee other cpus actually see the new ->private value.
>> >
>> > Seems to be unrelated to this change, so I will submit
>> > a separate patch for nf.git that adds this.
>>
>> This is related to this change, please read the comment before the
>> local_bh_enable9)
>>
>>         /*
>>          * Even though table entries have now been swapped, other CPU's
>>          * may still be using the old entries. This is okay, because
>>          * resynchronization happens because of the locking done
>>          * during the get_counters() routine.
>>          */
>
> Hmm, but get_counters() does not issue a wmb, and the 'new' code added
> here essentially is the same as get_counters(), except that we only
> read seqcount until we saw a change (and not for each counter in
> the rule set).
>
> What am I missing?

Your sync code does nothing interesting if we are not sure new
table->private value is visible

Without barriers, compiler/cpu could  do this :


+       /* ... so wait for even xt_recseq on all cpus */
+       for_each_possible_cpu(cpu) {
+               seqcount_t *s = &per_cpu(xt_recseq, cpu);
+               u32 seq = raw_read_seqcount(s);
+
+               if (seq & 1) {
+                       do {
+                               cond_resched();
+                               cpu_relax();
+                       } while (seq == raw_read_seqcount(s));
+               }
+       }

/* finally, write new private value */
table->private = newinfo;

Basically, your loop is now useless and you could remove it. So there
is definitely a bug.
