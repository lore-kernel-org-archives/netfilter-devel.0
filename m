From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC 06/26] ipc: Replace spin_unlock_wait() with
 lock/unlock pair
Date: Sat, 1 Jul 2017 20:16:24 -0700
Message-ID: <20170702031624.GS2393@linux.vnet.ibm.com>
References: <20170629235918.GA6445@linux.vnet.ibm.com>
 <1498780894-8253-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <d6da8548-6d4e-7537-05b6-8d32812c49d2@colorfullife.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, oleg@redhat.com, akpm@linux-foundation.org,
        mingo@redhat.com, dave@stgolabs.net, tj@kernel.org, arnd@arndb.de,
        linux-arch@vger.kernel.org, will.deacon@arm.com,
        peterz@infradead.org, stern@rowland.harvard.edu,
        parri.andrea@gmail.com, torvalds@linux-foundation.org
To: Manfred Spraul <manfred@colorfullife.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36824 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752374AbdGBDQb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Jul 2017 23:16:31 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v623Dcec140634
        for <netfilter-devel@vger.kernel.org>; Sat, 1 Jul 2017 23:16:30 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ber5jguxv-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <netfilter-devel@vger.kernel.org>; Sat, 01 Jul 2017 23:16:30 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netfilter-devel@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Sat, 1 Jul 2017 23:16:29 -0400
Content-Disposition: inline
In-Reply-To: <d6da8548-6d4e-7537-05b6-8d32812c49d2@colorfullife.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 01, 2017 at 09:23:03PM +0200, Manfred Spraul wrote:
> On 06/30/2017 02:01 AM, Paul E. McKenney wrote:
> >There is no agreed-upon definition of spin_unlock_wait()'s semantics,
> >and it appears that all callers could do just as well with a lock/unlock
> >pair.  This commit therefore replaces the spin_unlock_wait() call in
> >exit_sem() with spin_lock() followed immediately by spin_unlock().
> >This should be safe from a performance perspective because exit_sem()
> >is rarely invoked in production.
> >
> >Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >Cc: Andrew Morton <akpm@linux-foundation.org>
> >Cc: Davidlohr Bueso <dave@stgolabs.net>
> >Cc: Manfred Spraul <manfred@colorfullife.com>
> >Cc: Will Deacon <will.deacon@arm.com>
> >Cc: Peter Zijlstra <peterz@infradead.org>
> >Cc: Alan Stern <stern@rowland.harvard.edu>
> >Cc: Andrea Parri <parri.andrea@gmail.com>
> >Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Acked-by: Manfred Spraul <manfred@colorfullife.com>

Applied, thank you!

							Thanx, Paul

> >---
> >  ipc/sem.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> >diff --git a/ipc/sem.c b/ipc/sem.c
> >index 947dc2348271..e88d0749a929 100644
> >--- a/ipc/sem.c
> >+++ b/ipc/sem.c
> >@@ -2096,7 +2096,8 @@ void exit_sem(struct task_struct *tsk)
> >  			 * possibility where we exit while freeary() didn't
> >  			 * finish unlocking sem_undo_list.
> >  			 */
> >-			spin_unlock_wait(&ulp->lock);
> >+			spin_lock(&ulp->lock);
> >+			spin_unlock(&ulp->lock);
> >  			rcu_read_unlock();
> >  			break;
> >  		}
> 
> 

