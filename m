From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Problem with IP-Pools
Date: 06 Dec 2002 14:20:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1039180838.30495.104.camel@tux>
References: <20021128162921.2b2a721d.markus.schaber@student.uni-ulm.de>
	<20021205201113.GD11068@naboo.club.berlin.ccc.de>
	<20021205224314.3c38afec.markus.schaber@student.uni-ulm.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Markus Schaber <markus.schaber@student.uni-ulm.de>
In-Reply-To: <20021205224314.3c38afec.markus.schaber@student.uni-ulm.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2002-12-05 at 22:43, Markus Schaber wrote:
> Harald Welte wrote:
>
> > I think the pool stuff is pretty much unmaintained as of now, sorry.
> > It was a contribution to the project, and the original author (Gerd
> > Knorr, IIRC) has abandoned it.

No no, not at all. It's true that the original author (Patrick Shaaf)
doesn't maintain it anymore. Joakim Axelsson found it lacking a lot of
features so he rewrote it into the new ippool. The new ippool is modular
like iptables so you have one module per pool-type. And it actually has
the flush feature.

It has three diffrent pool-types, null (just an skeleton), bitmap and
macipmap (like bitmap but also matches macaddresses).

I use the macipmap pool in three production routers (SMP) here and I've
never had any problems with ippool in them. I only had a few crashes
when I wrote macipmap :)

There are still some things missing, here's the most important ones that
come to mind:
	Need to push the locking down into the pooltypes.
	Implement save/restore functionality.
	And of course more pooltypes :)

The new ippool should be integrated into the netfilter cvs (up to Joakim
to decide) or the old ippool ripped out.
The main things before it could be integrated would be to fix ipt_pool
and ipt_POOL and the iptables userspace parts so they report sensible
errors, not just errorcodes like now.

You can find the current version (0.3.2a) here:

http://gandalf.hjorten.nu/ippool/

(I hope it compiles :)

The kernel part isn't a patch, it's a bunch of loose files you have to
copy and then modify Config.in and Makefile manually.


> Not to mention the time to load an iptable with some tens of thousands
> of entries, we cannot wait half an hour for our firewall to boot up.

ippool won't eliminate the load time yet, still needs the save/restore
functionality (shouldn't be hard to implement at all).
 
> Currently, my Boss does real-life testing using single processor
> kernels, and it seems that it works using current hardware (although I
> don't know yet how it performed during the peak times), and it seems to
> manage the traffic and to be rather stable.
> 
> If you know another method of managing such high traffic and host number
> combinations, we'd love to hear about it, because we _really_ want to
> leave Checkpoint.

nfhipac (I think that was the name) and tc-firewall (Jamal wrote it when
he found out about the O(n) iptables thing) comes to mind, they aren't
O(n), they use binary trees of some kind. I havn't used either of them
so I can't say how well they work and if they are stable.

Would be nice to have some kind of general classification thing in the
kernel (that isn't O(n) but behaves like a linear scan like nfhipac
does) so that with one classification we get both routing, tc, ipsec, 
firewall info. Currently they all do their own classifications...


Good luck.
 
-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
