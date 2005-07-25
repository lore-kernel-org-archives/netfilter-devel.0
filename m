From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [NETFILTER]: Kill ebt_ulog
Date: Mon, 25 Jul 2005 07:11:45 +0000
Message-ID: <1122275506.3387.18.camel@localhost.localdomain>
References: <42E2C2E8.8010900@gmx.net> <42E2D0C9.7080808@trash.net>
	<1122196971.3382.6.camel@localhost.localdomain>
	<20050724.175203.112597232.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050724.175203.112597232.davem@davemloft.net>
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

Op zo, 24-07-2005 te 17:52 -0700, schreef David S. Miller:
> > Removing ebt_ulog would be stupid. So what if it conflicts with
> > ipt_ULOG, there is no kernel panic, they just can't be used together
> > currently. That problem should be solved by the generic replacement. To
> > say that ebt_ulog is broken is plain false.
> > If the "generic" replacement is such that it can only be used by
> > iptables modules then it is not generic at all.
> 
> Bart, please stop it.

A simple question: is it the intention to make it simple for ip6tables
to get a ULOG target? I hope so. If so, then it should be very simple to
alter ebt_ulog to use the generic code. There is then no need to first
remove it.

> Secondly, let it be very clearly be known that the bridging netfilter
> layer is the largest source of problems in the netfilter and
> networking code.  All of the nf_reset() garbage that we went through
> over the last month only exists because of the funky things that
> ebtables does.  The ebtables code that made those requiments necessary
> should never have gone in to begin with.  If I had understood the
> implications, that the netfilter caching in the SKB had to be held
> on for such an unreasonably long time in the stack, I would have never
> let that code into the tree.  And I know other netfilter developers
> feel the same way about this as I do.

I made it very clear before even submitting the bridge-nf code into the
2.5 kernel that it was very intrusive. I remember very well that it was
you who asked me to get it into 2.5. I never hid the fact that iptables
calls were postponed until in the bridging code.

> Now people use that stuff, and WE ARE STUCK with the crap as a result.
> We can't rip it out, even though that is exactly what we should do.
> 
> Therefore, I will highly support inclusion of any change that
> decreases the number of broken dependencies and things that ebtables
> enforces upon the rest of the tree.
> 
> I doubt you can document more than a hand full of ebt_log users, and
> they can convert easily over to the generic mechanism.

I haven't seen any explanation of how an ebtables user will be able to
use netlink logging without an ebtables module.

> And we're not going to stop development and stop all of our progress
> just because you won't be around until the end of the first week of
> August :-)

I think I made my opinion clear about the removal of ebt_ulog.
Now I'm off on holidays.

Bart
