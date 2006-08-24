From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: new ABI
Date: Thu, 24 Aug 2006 15:48:21 +0200
Message-ID: <20060824134820.GI31235@kriss.csbnet.se>
References: <200608142312.41851.max@nucleus.it>
	<20060816121653.GA31235@kriss.csbnet.se>
	<Pine.LNX.4.58.0608220901120.4038@blackhole.kfki.hu>
	<44EBE13E.9020605@trash.net>
	<20060823134842.GH31235@kriss.csbnet.se>
	<Pine.LNX.4.58.0608241051090.8098@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Massimiliano Hofer <max@nucleus.it>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0608241051090.8098@blackhole.kfki.hu>
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

2006-08-24 11:20:55+0200, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> ->
> Hi,
> 
> On Wed, 23 Aug 2006, Joakim Axelsson wrote:
> 
> > 2006-08-23 07:01:50+0200, Patrick McHardy <kaber@trash.net> ->
> > > Jozsef Kadlecsik wrote:
> > > > My views on how to communicate is a little bit old-fashioned as I'm
> > > > perfectly satisfied with sockopt. Yes, dusty. And old. Maybe even not cool
> > > > but a hack. But reliable, which cannot absolutely be said about netlink.
> > > > I shudder to think about the situation when a DDoS attack could prevent or
> > > > just delay me to reconfigure a firewall. And please note even if we accept
> > > > delaying it assumes that we are willing to face reimplementing a TCP-alike
> > > > protocol over netlink to guarantee reliable message passing.
> >
> > I have good experience with this. The solution i have found is:
> > 1. Cut the cable (or disable the port in a switch) to get enough CPU over if
> > you can't get anything at all done in userspace.
> > 2. You need tcpdump to figure out the attack-vector.
> > 3. Then insert an iptables rule droping the attack.
> 
> That's a good pratcice: cut off the source of the big trouble, find a way
> to handle it and then enable and watch the show. But usually one need to
> let the attack go on some time to analyze the patterns. Or tune some
> rules online, get the counters etc. So it's not always doable.
> 

Or use heavliy limiters in your firewall so it can't overload :-) Thats what
i do. But sometimes even those fail as i have missed something.

> > In any case there are several more paths which are more critical and needs
> > userspace cpu than netlink.
> >
> > Also, another problem with set/getsockopt() is that when you want to retrive
> > something and don't know the size of it you have a very hard time allocating
> > the memory to pass with getsockopt() for the kernel to write in. Think
> > moduels like recent where the state data can be of very different length
> > from time to time. Even having things what ask first how much memory is
> > needed and then provides it as the state can change between the two calls.
> 
> Yes, the same problems I faced with at working on ipset ;-). But it was
> easy for me, as some good guys writing ippool found workarounds ;-)).
> 

Just to point to the rest of the readers. It was who wrote that piece of
horrible code. It made use of first trying to figure the amount of memory
needed by asking the kernel, and kernel asked the kernel module to guess the
needed memory. Then userspace allocated thsi and sent a second getsockopt()
with some extra memory allocated in order to cover any state changes that
needs more memory between the two sockopt()-calls. Even so thsi could fail
so i added a loop of 5 each time allocing a factor power of 2 more
additional memory. Finally failing with an memory error to user if we still
could get all the info from a state from kernel. This was a terrible
solution :-) Netlink solves that as it packet based and doesn't need memory
from userspace to write in. 

Either we use netlink with or without some sort of ACKing, possible with
some sort of ordering as well. Or we write ourself a new ABI for this. Using
sockopt() is terrible wrong for this.

--
Joakim Axelsson
