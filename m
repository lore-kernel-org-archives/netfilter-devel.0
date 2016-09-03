From: Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH 8/7] net/netfilter/nf_conntrack_core: Remove another
 memory barrier
Date: Sat, 3 Sep 2016 07:33:47 +0200
Message-ID: <2a6072d1-154d-6d07-dc4b-9cf1d59aa44f@colorfullife.com>
References: <1472743673-15585-1-git-send-email-manfred@colorfullife.com>
 <20160901153039.GN6721@arm.com>
 <20160901164126.GZ10153@twins.programming.kicks-ass.net>
 <1971bcf8-0f42-c0b7-5e59-2ceaa6e024a7@colorfullife.com>
 <20160902192213.GM10153@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Will Deacon <will.deacon@arm.com>, benh@kernel.crashing.org,
        paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        Boqun Feng <boqun.feng@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, 1vier1@web.de,
        Davidlohr Bueso <dave@stgolabs.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35780 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751586AbcICFeF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Sep 2016 01:34:05 -0400
Received: by mail-wm0-f66.google.com with SMTP id c133so5345062wmd.2
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Sep 2016 22:33:59 -0700 (PDT)
In-Reply-To: <20160902192213.GM10153@twins.programming.kicks-ass.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09/02/2016 09:22 PM, Peter Zijlstra wrote:
> On Fri, Sep 02, 2016 at 08:35:55AM +0200, Manfred Spraul wrote:
>> On 09/01/2016 06:41 PM, Peter Zijlstra wrote:
>>> On Thu, Sep 01, 2016 at 04:30:39PM +0100, Will Deacon wrote:
>>>> On Thu, Sep 01, 2016 at 05:27:52PM +0200, Manfred Spraul wrote:
>>>>> Since spin_unlock_wait() is defined as equivalent to spin_lock();
>>>>> spin_unlock(), the memory barrier before spin_unlock_wait() is
>>>>> also not required.
>>> Note that ACQUIRE+RELEASE isn't a barrier.
>>>
>>> Both are semi-permeable and things can cross in the middle, like:
>>>
>>>
>>> 	x = 1;
>>> 	LOCK
>>> 	UNLOCK
>>> 	r = y;
>>>
>>> can (validly) get re-ordered like:
>>>
>>> 	LOCK
>>> 	r = y;
>>> 	x = 1;
>>> 	UNLOCK
>>>
>>> So if you want things ordered, as I think you do, I think the smp_mb()
>>> is still needed.
>> CPU1:
>> x=1; /* without WRITE_ONCE */
>> LOCK(l);
>> UNLOCK(l);
>> <do_semop>
>> smp_store_release(x,0)
>>
>>
>> CPU2;
>> LOCK(l)
>> if (smp_load_acquire(x)==1) goto slow_path
>> <do_semop>
>> UNLOCK(l)
>>
>> Ordering is enforced because both CPUs access the same lock.
>>
>> x=1 can't be reordered past the UNLOCK(l), I don't see that further
>> guarantees are necessary.
>>
>> Correct?
> Correct, sadly implementations do not comply :/ In fact, even x86 is
> broken here.
>
> I spoke to Will earlier today and he suggests either making
> spin_unlock_wait() stronger to avoids any and all such surprises or just
> getting rid of the thing.
>
> I'm not sure which way we should go, but please hold off on these two
> patches until I've had a chance to audit all of those implementations
> again.
For me, it doesn't really matter.
spin_unlock_wait() as "R", as "RAcq" or as "spin_lock(); spin_lock();" - 
I just want a usable definition for ipc/sem.c

So (just to keep Andrew updated):
Ready for merging is: (Bugfixes, safe just with spin_unlock_wait() as "R"):

- 45a449340cd1 ("ipc/sem.c: fix complex_count vs. simple op race")
   Cc stable, back to 3.10 ...
- 7fd5653d9986 ("net/netfilter/nf_conntrack_core: Fix memory barriers.")
   Cc stable, back to ~4.5

--
     Manfred
