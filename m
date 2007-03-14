From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH 1/1] Re: dangerous? Setting mark in nat table
Date: Thu, 15 Mar 2007 00:12:02 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703150011370.1199@yvahk01.tjqt.qr>
References: <et6fp4$l04$1@sea.gmane.org>
	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>
	<45F6CD7C.40708@ufomechanic.net>
	<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>
	<1173868532.26913.39.camel@henriknordstrom.net>
	<45F7D657.8070907@trash.net>
	<1173876211.26913.73.camel@henriknordstrom.net>
	<45F7F027.9050300@ufomechanic.net> <45F7F3C6.3060908@trash.net>
	<Pine.LNX.4.64.0703141415200.26704@blackhole.kfki.hu>
	<Pine.LNX.4.64.0703141453400.26704@blackhole.kfki.hu>
	<45F85C89.7070107@trash.net>
	<1173905134.1760.59.camel@henriknordstrom.net>
	<Pine.LNX.4.61.0703142148180.1199@yvahk01.tjqt.qr>
	<1173910894.1760.89.camel@henriknordstrom.net> <45F87E06.20201@gmx.net>
	<45F87F09.2070009@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org,
	Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>,
	Henrik Nordstrom <henrik@henriknordstrom.net>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F87F09.2070009@trash.net>
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


On Mar 15 2007 00:02, Patrick McHardy wrote:
>
>Unfortunately the discussion pretty much came to a halt over a year
>ago because of some disagreements. I still consider merging it a
>good idea, but since there is no progress in this area I will start
>working on a netlink based iptables replacement myself in the next
>months.

Does not iptables (like iproute2 and /usr/sbin/conntrack) use netlink already?

Jan
-- 
