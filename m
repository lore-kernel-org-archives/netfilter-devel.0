From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Opinions about pom/patches [was: iptables 1.3.7, kernel 2.6.19,
 ROUTE and Layer7 issues]
Date: Wed, 10 Jan 2007 15:08:19 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701101502410.3029@yvahk01.tjqt.qr>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>
	<57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>
	<457E6997.1050001@trash.net>
	<36479.195.55.244.106.1165998665.squirrel@www.arcoscom.com>
	<457FBBFD.6060009@trash.net>
	<Pine.LNX.4.64.0612282158360.16672@bizon.gios.gov.pl>
	<45A48087.8090200@trash.net>
	<Pine.LNX.4.61.0701101233080.3029@yvahk01.tjqt.qr>
	<53212.195.55.244.106.1168434902.squirrel@www.arcoscom.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: ArcosCom Linux User <linux@arcoscom.com>
In-Reply-To: <53212.195.55.244.106.1168434902.squirrel@www.arcoscom.com>
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


On Jan 10 2007 14:15, ArcosCom Linux User wrote:
>
>Another example, some body say in the lists that using "mark" will allow
>me to change routes by "mark value" or by "and-mark mask", fine, that were
>to substitute ROUTE tarjet. I think that is a correct solution but ...
>What are the implications? 1) I can't see any documentation in netfilter
>or iproute.

<rant>
So sad that it's true. "ip r h" is possibly a complete BNF, but
heck, even if I give a command that actually satisfies this BNF, I
still get an error like "RTNETLINK: Invalid argument" and that's it.
I really find this a showstopper. Nice shiny new technology which
can't be used. At this time, -j ROUTE is *so* much simpler.

To make matters worse, I think netfilter, routing and QoS are too
separated (not that I can do much, too big a task for one man) -
unless you use classification with CLASSIFY in iptables, you have to
rematch all packets (in the style of "-p tcp") in tc egress.
</rant>



	-`J'
-- 
