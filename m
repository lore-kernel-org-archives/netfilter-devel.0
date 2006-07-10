From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: information about kernel locking issue
Date: Tue, 11 Jul 2006 01:41:19 +0200
Message-ID: <200607110141.20519.max@nucleus.it>
References: <200607011355.41921.delleceste@gmail.com>
	<200607012229.53134.max@nucleus.it>
	<44B2D73B.3080209@net.in.tum.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Giacomo S." <delleceste@gmail.com>, Gregor Maier <gregor@net.in.tum.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <44B2D73B.3080209@net.in.tum.de>
Content-Disposition: inline
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

On Tuesday 11 July 2006 12:39 am, Gregor Maier wrote:

> > Your code snippet doesn't show how the function is called. If this is
> > invoked by (*match)() you are in a soft interrupt context and should use
> > read_lock(). read_lock_bh() is what you use in process context when a
> > soft interrupt may use write_lock().
>
> That's wrong. When you run in interrupt context, you must ensure that
> you disable interrupts (be it soft or hardware interrupts) while holding
> a spinlock.

You're right and I made a poor choice of words, but in his case the lock 
protects dev_base and, to the best of my knowledge, it is never written by 
interrupts (soft or hard). Correct me if I'm mistaken on this point.

In this case, if you take a read lock and no other interrupt ever takes 
anything more than a read lock, while user context always disables interrupts 
while taking a write lock, you shouldn't be able to trigger a deadlock.

-- 
Bye,
   Massimiliano Hofer
