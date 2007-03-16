From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/1] Re: dangerous? Setting mark in nat table
Date: Fri, 16 Mar 2007 13:31:04 +0100
Message-ID: <45FA8E08.5000103@trash.net>
References: <et6fp4$l04$1@sea.gmane.org>	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>	<45F6CD7C.40708@ufomechanic.net>	<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>	<1173868532.26913.39.camel@henriknordstrom.net>	<45F7D657.8070907@trash.net>	<1173876211.26913.73.camel@henriknordstrom.net>	<45F7F027.9050300@ufomechanic.net>	<45F7F3C6.3060908@trash.net>	<Pine.LNX.4.64.0703141415200.26704@blackhole.kfki.hu>	<Pine.LNX.4.64.0703141453400.26704@blackhole.kfki.hu>	<45F85C89.7070107@trash.net>	<1173905134.1760.59.camel@henriknordstrom.net>	<Pine.LNX.4.61.0703142148180.1199@yvahk01.tjqt.qr>	<1173910894.1760.89.camel@henriknordstrom.net>	<45F87E06.20201@gmx.net>
	<45F87F09.2070009@trash.net> <45F9463D.6050502@drugphish.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Henrik Nordstrom <henrik@henriknordstrom.net>,
	Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Roberto Nibali <ratz@drugphish.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F9463D.6050502@drugphish.ch>
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

Roberto Nibali wrote:
>> Unfortunately the discussion pretty much came to a halt over a year
>> ago because of some disagreements. I still consider merging it a
>> good idea, but since there is no progress in this area I will start
>> working on a netlink based iptables replacement myself in the next
>> months.
> 
> 
> Cough ... could we guys over at ../ipv4/ipvs/ synchronise with your
> ideas? I've once started a port of IPVS to the netlink framework
> together with Thomas Graf, but stopped the project because I didn't find
> enough time.


We could try, but I'm not sure how much it would be possible to share.
But to be honest I don't know much about IPVS, looking over the code,
I can't even find something that looks like ruleset evaluation.

> I'll be offline for at least one year soon but my fellow
> hackers (Horms at the moment) over at IPVS sure would like to combine
> efforts; maybe we can even completely integrate IPVS into the new (fast
> and memory-efficient like nf-hipac) netfilter framework and share the
> netlink code in user space with regards to iptables and ipvsadm.


I didn't have plans to invent a new classification algorithm so far
(would be a bit of a waste of time since there already is nf-hipac),
just a better userspace interface dealing with individual rules
that doesn't use the ABI structures inside the kernel for anything
else. This will give us a lot more flexibility than what we currently
have.

Anyway, its probably going to be a few months from now before I
begin, I'll make sure to talk to Horms once I have a clearer picture.
But feel free to already push ideas.
