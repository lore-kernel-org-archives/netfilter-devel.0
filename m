From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: new ABI
Date: Thu, 24 Aug 2006 11:20:55 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0608241051090.8098@blackhole.kfki.hu>
References: <200608142312.41851.max@nucleus.it>
	<20060816121653.GA31235@kriss.csbnet.se>
	<Pine.LNX.4.58.0608220901120.4038@blackhole.kfki.hu>
	<44EBE13E.9020605@trash.net>
	<20060823134842.GH31235@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Massimiliano Hofer <max@nucleus.it>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20060823134842.GH31235@kriss.csbnet.se>
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

Hi,

On Wed, 23 Aug 2006, Joakim Axelsson wrote:

> 2006-08-23 07:01:50+0200, Patrick McHardy <kaber@trash.net> ->
> > Jozsef Kadlecsik wrote:
> > > My views on how to communicate is a little bit old-fashioned as I'm
> > > perfectly satisfied with sockopt. Yes, dusty. And old. Maybe even not cool
> > > but a hack. But reliable, which cannot absolutely be said about netlink.
> > > I shudder to think about the situation when a DDoS attack could prevent or
> > > just delay me to reconfigure a firewall. And please note even if we accept
> > > delaying it assumes that we are willing to face reimplementing a TCP-alike
> > > protocol over netlink to guarantee reliable message passing.
>
> I have good experience with this. The solution i have found is:
> 1. Cut the cable (or disable the port in a switch) to get enough CPU over if
> you can't get anything at all done in userspace.
> 2. You need tcpdump to figure out the attack-vector.
> 3. Then insert an iptables rule droping the attack.

That's a good pratcice: cut off the source of the big trouble, find a way
to handle it and then enable and watch the show. But usually one need to
let the attack go on some time to analyze the patterns. Or tune some
rules online, get the counters etc. So it's not always doable.

> In any case there are several more paths which are more critical and needs
> userspace cpu than netlink.
>
> Also, another problem with set/getsockopt() is that when you want to retrive
> something and don't know the size of it you have a very hard time allocating
> the memory to pass with getsockopt() for the kernel to write in. Think
> moduels like recent where the state data can be of very different length
> from time to time. Even having things what ask first how much memory is
> needed and then provides it as the state can change between the two calls.

Yes, the same problems I faced with at working on ipset ;-). But it was
easy for me, as some good guys writing ippool found workarounds ;-)).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
