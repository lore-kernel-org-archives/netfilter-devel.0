From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC 02/26] task_work: Replace spin_unlock_wait() with
 lock/unlock pair
Date: Fri, 30 Jun 2017 05:50:20 -0700
Message-ID: <20170630125020.GU2393@linux.vnet.ibm.com>
References: <20170629235918.GA6445@linux.vnet.ibm.com>
 <1498780894-8253-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20170630110445.GA5123@redhat.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, akpm@linux-foundation.org,
        mingo@redhat.com, dave@stgolabs.net, manfred@colorfullife.com,
        tj@kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
        will.deacon@arm.com, peterz@infradead.org,
        stern@rowland.harvard.edu, parri.andrea@gmail.com,
        torvalds@linux-foundation.org
To: Oleg Nesterov <oleg@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170630110445.GA5123@redhat.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jun 30, 2017 at 01:04:45PM +0200, Oleg Nesterov wrote:
> On 06/29, Paul E. McKenney wrote:
> >
> > --- a/kernel/task_work.c
> > +++ b/kernel/task_work.c
> > @@ -109,7 +109,8 @@ void task_work_run(void)
> >  		 * the first entry == work, cmpxchg(task_works) should
> >  		 * fail, but it can play with *work and other entries.
> >  		 */
> > -		raw_spin_unlock_wait(&task->pi_lock);
> > +		raw_spin_lock(&task->pi_lock);
> > +		raw_spin_unlock(&task->pi_lock);
> 
> Well, bit the you need spin_lock_irq(). And this is one of the reasons
> why I personally think unlock_wait have some sense...

Good catch, and I clearly need to double-check the other commits for
any need to disable interrupts.  Anyway, like this, with the addition
of a flags variable, correct?

> > +		raw_spin_lock_irq(&task->pi_lock);
> > +		raw_spin_unlock_irq(&task->pi_lock);

I agree that the spin_unlock_wait() implementations would avoid the
deadlock with an acquisition from an interrupt handler, while also
avoiding the need to momentarily disable interrupts.  The ->pi_lock is
a per-task lock, so I am assuming (perhaps naively) that contention is
not a problem.  So is the overhead of interrupt disabling likely to be
noticeable here?

							Thanx, Paul
