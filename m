From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: new ABI
Date: Wed, 23 Aug 2006 15:48:42 +0200
Message-ID: <20060823134842.GH31235@kriss.csbnet.se>
References: <200608142312.41851.max@nucleus.it>
	<20060816121653.GA31235@kriss.csbnet.se>
	<Pine.LNX.4.58.0608220901120.4038@blackhole.kfki.hu>
	<44EBE13E.9020605@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Massimiliano Hofer <max@nucleus.it>, netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44EBE13E.9020605@trash.net>
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

2006-08-23 07:01:50+0200, Patrick McHardy <kaber@trash.net> ->
> Jozsef Kadlecsik wrote:
> > My views on how to communicate is a little bit old-fashioned as I'm
> > perfectly satisfied with sockopt. Yes, dusty. And old. Maybe even not cool
> > but a hack. But reliable, which cannot absolutely be said about netlink.
> > I shudder to think about the situation when a DDoS attack could prevent or
> > just delay me to reconfigure a firewall. And please note even if we accept
> > delaying it assumes that we are willing to face reimplementing a TCP-alike
> > protocol over netlink to guarantee reliable message passing.
> 
> I don't think a DoS attack could prevent you from using netlink any
> more than it could from setsockopt (netlink is even more efficient due
> to less data copied around). Reliability is not hard to achieve on the
> userspace->kernel path if you don't mind eating one RTT for each rule
> update (which is not very large), just send the update and wait for
> an ACK or an error, then handle it. Having more than one message in
> flight introduces another problem besides congestion control and
> reliable transmission, the resulting ruleset in the kernel might
> depend on the order in which messages are received, if messages are
> dropped in the middle and are simply retransmitted it will be wrong.
> This should probably not be done.
> 

I have good experience with this. The solution i have found is:
1. Cut the cable (or disable the port in a switch) to get enough CPU over if
you can't get anything at all done in userspace.
2. You need tcpdump to figure out the attack-vector.
3. Then insert an iptables rule droping the attack.

In any case there are several more paths which are more critical and needs
userspace cpu than netlink.

Also, another problem with set/getsockopt() is that when you want to retrive
something and don't know the size of it you have a very hard time allocating
the memory to pass with getsockopt() for the kernel to write in. Think
moduels like recent where the state data can be of very different length
from time to time. Even having things what ask first how much memory is
needed and then provides it as the state can change between the two calls.
Its easier with netlink to just allow it to send packets until a packet
arrives that says its the last one.

> > Yes. And I'd add one more priciple:
> > 
> > + All parts must be designed to take into account rule- and
> >   (match/target) state-replication between firewalls in active-active
> >   setups.
> 
> Agreed, that would be nice to have (and not very hard).

+ Agreed here as well :-)

--
Joakim Axelsson
