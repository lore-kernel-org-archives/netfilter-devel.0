From: Matt Walters <mattw@parasun.com>
Subject: RE: Re: libipq, kernel panics/oopses, and other undesirable traits
Date: Sun, 15 Aug 2004 09:42:20 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E1BwO5M-000718-NF@giant.mindlink.net>
Mime-Version: 1.0
Content-Type: TEXT/plain; CHARSET=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


> Matt Walters wrote:
> > 	Below is one of the stack traces that actually made it into the
logs
> > (oh yeah - did I mention that sometimes the machine is kind of
alright
> > after this?  mostly it locks up immediately, or locks up trying to
stop
> > iptables though).  The trace is from one of the times that it
exploded
> > with my application, not the test code.
> > 
> > 	Thanks in advance for any hints, confirmations, denials,
drop-kicks or
> > head smacks you might be able to offer.  I'm going to try compiling
a
> > non-SMP kernel tonight or tomorrow to see if the issue persists,
and I
> > will update the list.
> 
> This looks like the packet contents (ping) of a non-linear skb
corrupted
> the registers. Please try the ip_queue_nonlinear_skbs patch from
> patch-o-matic-ng.

Patrick et al-

  Firstly, thanks for the input.  I applied the patch yesterday to the
2.6.7 kernel without luck.  I then noticed that 2.6.8 was at
kernel.org, so I downloaded it, applied the nonlinear_skbs patch to it,
and built it.  No love there either.

  When I say "without luck", incidentally, I mean that the issue isn't
resolved.  It's become more predictable and repeatible though, which is
good, since it means I'll be able to roll up my sleeves today and dig
in.  Any packet being copied back from userspace that is larger than
the destination device's MTU (that is being fragmented, that is) is
causing the machine to throw a bunch of "Unable to handle kernel paging
request at [foo]" messages.  The good news?  Even between boots, and
even with the ip_queue module compiled statically into the kernel
(something else I tried, just for giggles), the address it is
complaining about is identical, and it's one of those suspicious
addresses (0xbcbcbcbc or something like it, sorry I don't have it
written down here).  As I said, I'll dig into it later on today and
keep the list updated.

  Thanks again,

-Matt
