From: Phil Oester <kernel@linuxace.com>
Subject: Re: ip_conntrack table full problem
Date: Mon, 21 Mar 2005 10:08:12 -0800
Message-ID: <20050321180812.GA14954@linuxace.com>
References: <200503141647.42299.thomas.jarosch@intra2net.com>
	<200503211513.59943.thomas.jarosch@intra2net.com>
	<20050321162147.GA14696@linuxace.com>
	<200503211803.18918.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Content-Disposition: inline
In-Reply-To: <200503211803.18918.thomas.jarosch@intra2net.com>
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

On Mon, Mar 21, 2005 at 06:03:18PM +0100, Thomas Jarosch wrote:
> > Yes, you're leaking conntracks somewhere.  Any possibility of testing
> > a somewhat newer kernel than 2.4.21?  This may have already been
> > fixed.
> 
> Thank you for your response.
> Unfortunately I cannot update to a newer kernel soon.
> 
> Would it be possible to dump the internal conntrack tables
> once the error occurs? Then we would at least know what
> is filling the table up. Is there some kind of debug macro
> I could add before the printk("conntrack table full") code?

No easy way.  Last week I posted a patch which would have made
this possible by creating a 'cleaned' list, but since you cannot
upgrade kernels, you could not use this anyway.

> Or a more aggressive solution:
> Flush the complete conntrack table once the error occurs.
> This would kill all running connections, but the machine
> would still be reachable afterwards.

Even if conntrack were modular, you would be unable to unload
it (see the thread referenced above).

> Any other ideas?

I'm still studying the root cause and have narrowed it down
somewhat, but no patch yet.

> I'll try to reproduce the problem in a test environment,
> but it will be hard to narrow the cause down.

What's the traffic pattern on this box?  In my testing I've
never seen such high rates of leakage.

Phil
