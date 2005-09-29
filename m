From: "Martijn Lievaart" <m@rtij.nl>
Subject: Re: snat bridge routes reply packets
Date: Thu, 29 Sep 2005 17:20:13 +0200 (CEST)
Message-ID: <41060.217.166.60.19.1128007213.squirrel@ma.rtij.nl>
References: <dhef0t$mj3$1@sea.gmane.org>	<Pine.LNX.4.61.0509282147100.8767@filer.marasystems.com>	<433BA8F6.7000606@ufomechanic.net>	<Pine.LNX.4.61.0509291155310.25933@filer.marasystems.com>	<433BDBD7.6030609@ufomechanic.net>
	<20214.217.166.60.19.1127998151.squirrel@ma.rtij.nl>
	<433BE841.2090203@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: azez@ufomechanic.net
In-Reply-To: <433BE841.2090203@ufomechanic.net>
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

Amin Azez zei:

> We have created broad network aliases for the bridge so that all IP
> addresses are local and roughly get the scenario you speak of, but then
> we need to add static arp entries to assign the default gateway's mac to
> specific known non-local ip, which is of course a worse hack than
> mending snat for source-bridge scenarios.

Why would creating routes for those specific non-local IPs to that gateway
not work?

I still  fail to see what you are trying to achieve. In short, you SNAT
packets. You don't want to send the return packet to the original
source-IP based on normal ip-routing. Instead, you want to send it to the
MAC adres it was originally addressed to. I fail to see the value of this,
so I think I'm still missing something.

However, you can still achieve this by adding a route for the original
source IP to the IP it gets natted to. This would bypass the arp mechanism
and instead route the packet to the natted IP.

HTH,
M4
