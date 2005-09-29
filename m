From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: snat bridge routes reply packets
Date: Thu, 29 Sep 2005 18:33:55 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0509291817370.4714@filer.marasystems.com>
References: <dhef0t$mj3$1@sea.gmane.org>
	<Pine.LNX.4.61.0509282147100.8767@filer.marasystems.com>
	<433BA8F6.7000606@ufomechanic.net>
	<Pine.LNX.4.61.0509291155310.25933@filer.marasystems.com>
	<433BDBD7.6030609@ufomechanic.net>
	<20214.217.166.60.19.1127998151.squirrel@ma.rtij.nl>
	<433BE841.2090203@ufomechanic.net>
	<41060.217.166.60.19.1128007213.squirrel@ma.rtij.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org, azez@ufomechanic.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <41060.217.166.60.19.1128007213.squirrel@ma.rtij.nl>
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

On Thu, 29 Sep 2005, Martijn Lievaart wrote:

> I still  fail to see what you are trying to achieve. In short, you SNAT
> packets. You don't want to send the return packet to the original
> source-IP based on normal ip-routing. Instead, you want to send it to the
> MAC adres it was originally addressed to. I fail to see the value of this,
> so I think I'm still missing something.


Simplest setup explaining the case as I understood it:

unknown network mesh -> Bridge running SNAT -> Internet

and you want the bridge to SNAT whatever is seen from the internal 
network, no matter what address is being used. The bridge does not have 
full knowledge of how the internal network mesh looks like, only that 
packets coming in on that interface is from the internal network.

Today this works fine for packets coming from the internal network going 
towards the Internet, but fails on return traffic as the bridge does not 
know where to route the "client" traffic.


If connection tracking in this kind of setup remembered the original 
source MAC of the incoming packet then this could be used in the implicit 
DNAT of the return traffic to route the packets (at level 2, not IP) to 
the sending host/router on the internal network mesh without requiring 
full routing information on the bridge.

This is in some senses similar to the level 3 routing without routing 
tables problem triggering my development of CONNMARK years ago. CONNMARK 
was initially triggered by the need to have a Internet gateway/firewall 
without any detailed knowledge of what the internal network looked like 
except for a router address where internal traffic could be sent.


Quite likely the problem Amin Azez is trying to address can be solved more 
cleanly by proxy-ARP + CONNMARK based policy routing than by bridge 
firewalling, but without knowing/understanding the exact layout of his 
network mess it's hard to say what it best. But I know from experience 
that bridge firewalling with NAT is very rarely the best approach in the 
long run, only perhaps the quickest if you are in a pinch with very 
limited time or prevented of doing it right.

Regards
Henrik
