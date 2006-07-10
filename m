From: Gregor Maier <gregor@net.in.tum.de>
Subject: Re: information about kernel locking issue
Date: Tue, 11 Jul 2006 00:39:55 +0200
Message-ID: <44B2D73B.3080209@net.in.tum.de>
References: <200607011355.41921.delleceste@gmail.com>
	<200607012229.53134.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Giacomo S." <delleceste@gmail.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200607012229.53134.max@nucleus.it>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Massimiliano Hofer wrote:
> On Saturday 1 July 2006 1:55 pm, Giacomo S. wrote:
> 
> 
>>I think the problem is that read_lock_bh is not correct, perhaps
>>i would need read_lock_irq instead??
> 
> 
> Your code snippet doesn't show how the function is called. If this is invoked 
> by (*match)() you are in a soft interrupt context and should use read_lock().
> read_lock_bh() is what you use in process context when a soft interrupt may 
> use write_lock().

That's wrong. When you run in interrupt context, you must ensure that
you disable interrupts (be it soft or hardware interrupts) while holding
a spinlock.
The _irq und _irqsave locking functions will disable hardware interrupts
on the local cpu while holding the lock (and thus softirqs are also
disabled).  The _bh functions will disable softirqs on the local cpu
while you hold the lock. This means, that the code executed with the
lock held cannot be interrupted by a hardware irq resp. softirq.

i.e.
- - if you run in hardware interrupt context you must use a *_irq
or *_irqsave lock (which guarentees that no other hardware interrupt is
serviced until you release the lock)
- - if you run in soft interrupt context you must use a *_bh locking
function (the _irq _irqsave are theoretically also ok, but you want to
avoid disabling hardware irqs when it's not necesarry)
- - in other cases (process context, you can use any lock function).

If you don't disable interrupts while holding a lock in interrupt
context, your piece of code may get interrupted while still holding the
lock. Which may (and will) result in deadlock if the new interrupt
routine also tries to aquire the same lock.

> I don't think this needs read_lock_irq() and I can't find any IRQ using it, 
> but someone with more experience may disagree with me.

so, since the code runs ins softirq context, lock_bh is fine. I suppose
the problem is, that one of the functions in the critical area may
sleep. When using spinlocks, you must ensure, that you do not call a
function that can sleep. So you may want to check if.

Have a look at the Writing Linux Device Drivers book from O'Reilly.
Chapter 5 covers locking. A online version can be found at
http://lwn.net/Kernel/LDD3/


hth
gregor


- --
Gregor Maier                                      Lehrstuhl Informatik 8
gregor@net.in.tum.de                              Tel: +49 89  289-18010
http://www.net.in.tum.de                                     TU Muenchen
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFEstc7dGiwgbikMYMRAr4UAKCd9NvHTPiqxvJZyQPUe0QV37Z7PwCgl7bq
oYuRhn8jh2OSMMRnGmeNM78=
=gvyd
-----END PGP SIGNATURE-----
