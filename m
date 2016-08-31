From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 5/5] net/netfilter/nf_conntrack_core: update memory
 barriers.
Date: Wed, 31 Aug 2016 07:15:24 -0700
Message-ID: <1472652924.14381.323.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1472650950-3131-1-git-send-email-manfred@colorfullife.com>
         <1472650950-3131-6-git-send-email-manfred@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, Boqun Feng <boqun.feng@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, 1vier1@web.de,
        Davidlohr Bueso <dave@stgolabs.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Manfred Spraul <manfred@colorfullife.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33136 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933214AbcHaOPa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Aug 2016 10:15:30 -0400
In-Reply-To: <1472650950-3131-6-git-send-email-manfred@colorfullife.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2016-08-31 at 15:42 +0200, Manfred Spraul wrote:
> As explained in commit 51d7d5205d33
> ("powerpc: Add smp_mb() to arch_spin_is_locked()", for some architectures
> the ACQUIRE during spin_lock only applies to loading the lock, not to
> storing the lock state.
> 
> nf_conntrack_lock() does not handle this correctly:
>     /* 1) Acquire the lock */
>     spin_lock(lock);
>     while (unlikely(nf_conntrack_locks_all)) {
>         spin_unlock(lock);
> 
> spinlock_store_acquire() is missing between spin_lock and reading
> nf_conntrack_locks_all. In addition, reading nf_conntrack_locks_all
> needs ACQUIRE memory ordering.
> 
> 2nd, minor issue: If there would be many nf_conntrack_all_lock() callers,
> then nf_conntrack_lock() would loop forever.
> 
> Therefore: Change nf_conntrack_lock and nf_conntract_lock_all() to the
> approach used by ipc/sem.c:
> 
> - add spinlock_store_acquire()
> - add smp_load_acquire()
> - for nf_conntrack_lock, use spin_lock(&global_lock) instead of
>   spin_unlock_wait(&global_lock) and loop backward.
> - use smp_store_mb() instead of a raw smp_mb()
> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: netfilter-devel@vger.kernel.org
> 
> ---
> 
> Question: Should I split this patch?
> First a patch that uses smp_mb(), with Cc: stable.
> The replace the smp_mb() with spinlock_store_acquire, not for stable

I guess it all depends on stable backports you believe are needed.

You probably should add the tags :
Fixes: <12-digit-sha1> "patch title"
that introduced the bug(s) you fix.

By doing this archaeological research you will likely have a better
answer ?

Thanks !


