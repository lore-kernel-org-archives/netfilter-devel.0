From: Amin Azez <azez@ufomechanic.net>
Subject: Re: snat bridge routes reply packets
Date: Fri, 30 Sep 2005 10:28:02 +0100
Message-ID: <433D0522.5050502@ufomechanic.net>
References: <dhef0t$mj3$1@sea.gmane.org>	<Pine.LNX.4.61.0509282147100.8767@filer.marasystems.com>	<433BA8F6.7000606@ufomechanic.net>	<Pine.LNX.4.61.0509291155310.25933@filer.marasystems.com>	<433BDBD7.6030609@ufomechanic.net>	<20214.217.166.60.19.1127998151.squirrel@ma.rtij.nl>	<433BE841.2090203@ufomechanic.net>	<41060.217.166.60.19.1128007213.squirrel@ma.rtij.nl>
	<Pine.LNX.4.61.0509291817370.4714@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0509291817370.4714@filer.marasystems.com>
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

Henrik Nordstrom wrote:
> Quite likely the problem Amin Azez is trying to address can be solved
> more cleanly by proxy-ARP + CONNMARK based policy routing than by bridge
> firewalling, but without knowing/understanding the exact layout of his
> network mess it's hard to say what it best. 

Good points; the only reason the network-mess gets to bridge to the
router is that the bridge is arp-faking with ebtables to give out the
router mac address as if it were whatever the network-mess was arping
for. No doubt connmark routing would work too, I hadn't considered this;
but marks are already well used for other things.

> But I know from experience
> that bridge firewalling with NAT is very rarely the best approach in the
> long run, only perhaps the quickest if you are in a pinch with very
> limited time or prevented of doing it right.

Where the network mess cna be known in advance, I would agree, but in a
case where it "just needs to work" extending snat to bridging makes sense.

Anyway, I am proceeding with this, and appreciate the feedback. I shall
extend the snat iptables target to allow this as an optional extension.

Amin
