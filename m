From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER]: Kill ebt_ulog
Date: Sun, 24 Jul 2005 17:52:03 -0700 (PDT)
Message-ID: <20050724.175203.112597232.davem@davemloft.net>
References: <42E2C2E8.8010900@gmx.net> <42E2D0C9.7080808@trash.net>
	<1122196971.3382.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: bdschuym@pandora.be
In-Reply-To: <1122196971.3382.6.camel@localhost.localdomain>
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

From: Bart De Schuymer <bdschuym@pandora.be>
Date: Sun, 24 Jul 2005 09:22:51 +0000

> Removing ebt_ulog would be stupid. So what if it conflicts with
> ipt_ULOG, there is no kernel panic, they just can't be used together
> currently. That problem should be solved by the generic replacement. To
> say that ebt_ulog is broken is plain false.
> If the "generic" replacement is such that it can only be used by
> iptables modules then it is not generic at all.

Bart, please stop it.

Secondly, let it be very clearly be known that the bridging netfilter
layer is the largest source of problems in the netfilter and
networking code.  All of the nf_reset() garbage that we went through
over the last month only exists because of the funky things that
ebtables does.  The ebtables code that made those requiments necessary
should never have gone in to begin with.  If I had understood the
implications, that the netfilter caching in the SKB had to be held
on for such an unreasonably long time in the stack, I would have never
let that code into the tree.  And I know other netfilter developers
feel the same way about this as I do.

Now people use that stuff, and WE ARE STUCK with the crap as a result.
We can't rip it out, even though that is exactly what we should do.

Therefore, I will highly support inclusion of any change that
decreases the number of broken dependencies and things that ebtables
enforces upon the rest of the tree.

I doubt you can document more than a hand full of ebt_log users, and
they can convert easily over to the generic mechanism.

And we're not going to stop development and stop all of our progress
just because you won't be around until the end of the first week of
August :-)
