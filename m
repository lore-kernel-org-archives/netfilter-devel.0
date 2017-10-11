From: Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v3 nf-next 1/2] netfilter: x_tables: wait until old table
 isn't used anymore
Date: Wed, 11 Oct 2017 10:57:55 -0700
Message-ID: <CANn89iJ9r9Y1JeTzEFnyko8-h_hhdWGLw+nDLJVcMuvTm6HB0w@mail.gmail.com>
References: <20171011142607.15026-1-fw@strlen.de> <20171011142607.15026-2-fw@strlen.de>
 <CANn89iLrM-sKFLzXkcot6T2FQWZEwe6me+ux1tHQztSc6EE90w@mail.gmail.com> <20171011174832.GB26835@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org, Dan Williams <dcbw@redhat.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:52318 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752195AbdJKR55 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 13:57:57 -0400
Received: by mail-qt0-f175.google.com with SMTP id o52so7705720qtc.9
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2017 10:57:57 -0700 (PDT)
In-Reply-To: <20171011174832.GB26835@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 11, 2017 at 10:48 AM, Florian Westphal <fw@strlen.de> wrote:
> Eric Dumazet <edumazet@google.com> wrote:
>> On Wed, Oct 11, 2017 at 7:26 AM, Florian Westphal <fw@strlen.de> wrote:
>> > xt_replace_table relies on table replacement counter retrieval (which
>> > uses xt_recseq to synchronize pcpu counters).
>> >
>> > This is fine, however with large rule set get_counters() can take
>> > a very long time -- it needs to synchronize all counters because
>> > it has to assume concurrent modifications can occur.
>> >
>> > Make xt_replace_table synchronize by itself by waiting until all cpus
>> > had an even seqcount.
>> >
>> > This allows a followup patch to copy the counters of the old ruleset
>> > without any synchonization after xt_replace_table has completed.
>> >
>> > Cc: Dan Williams <dcbw@redhat.com>
>> > Cc: Eric Dumazet <edumazet@google.com>
>> > Signed-off-by: Florian Westphal <fw@strlen.de>
>> > ---
>> >  v3: check for 'seq is uneven' OR 'has changed' since
>> >  last check. Its fine if seq is uneven iff its a different
>> >  sequence number than the initial one.
>> >
>> >  v2: fix Erics email address
>> >  net/netfilter/x_tables.c | 18 +++++++++++++++---
>> >  1 file changed, 15 insertions(+), 3 deletions(-)
>> >
>> >
>>
>> Reviewed-by: Eric Dumazet <edumazet@google.com>
>>
>> But it seems we need an extra smp_wmb() after
>>
>>         smp_wmb();
>>         table->private = newinfo;
>> +      smp_wmb();
>>
>> Otherwise we have no guarantee other cpus actually see the new ->private value.
>
> Seems to be unrelated to this change, so I will submit
> a separate patch for nf.git that adds this.

This is related to this change, please read the comment before the
local_bh_enable9)

        /*
         * Even though table entries have now been swapped, other CPU's
         * may still be using the old entries. This is okay, because
         * resynchronization happens because of the locking done
         * during the get_counters() routine.
         */


Since your new code happens right after table->private  = newinfo ;
the smp_wmb() is required.
