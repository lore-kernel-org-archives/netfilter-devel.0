From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/1] Re: dangerous? Setting mark in nat table
Date: Thu, 15 Mar 2007 00:02:33 +0100
Message-ID: <45F87F09.2070009@trash.net>
References: <et6fp4$l04$1@sea.gmane.org>	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>	<45F6CD7C.40708@ufomechanic.net>	<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>	<1173868532.26913.39.camel@henriknordstrom.net>	<45F7D657.8070907@trash.net>	<1173876211.26913.73.camel@henriknordstrom.net>	<45F7F027.9050300@ufomechanic.net>
	<45F7F3C6.3060908@trash.net>	<Pine.LNX.4.64.0703141415200.26704@blackhole.kfki.hu>	<Pine.LNX.4.64.0703141453400.26704@blackhole.kfki.hu>	<45F85C89.7070107@trash.net>	<1173905134.1760.59.camel@henriknordstrom.net>	<Pine.LNX.4.61.0703142148180.1199@yvahk01.tjqt.qr>
	<1173910894.1760.89.camel@henriknordstrom.net>
	<45F87E06.20201@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Henrik Nordstrom <henrik@henriknordstrom.net>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F87E06.20201@gmx.net>
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

Carl-Daniel Hailfinger wrote:
> On 14.03.2007 23:21, Henrik Nordstrom wrote:
> 
>>Or whatever it will be in the successor to iptables..
>>
>>just spewing ideas at this time. As Patrick I do not consider the core
>>iptables worth the effort of such redesign and if redesigning stuff then
>>something significantly better should be done. nf-HiPAC is one possible
>>alternative where a lot is done much smarter even if communication
>>between the projects is pretty distant at the moment.
> 
> 
> Speaking of HiPAC, when is it going to be merged? IIRC the merge was
> discussed at the netfilter workshop 2005 with the goal to merge it in
> 2.6.16. Has this decision been overturned/revised/forgotten or was
> the report I read about that netfilter workshop inaccurate?


Unfortunately the discussion pretty much came to a halt over a year
ago because of some disagreements. I still consider merging it a
good idea, but since there is no progress in this area I will start
working on a netlink based iptables replacement myself in the next
months.
