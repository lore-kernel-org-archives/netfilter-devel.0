From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: [PATCH 1/1] Re: dangerous? Setting mark in nat table
Date: Thu, 15 Mar 2007 14:12:29 +0100
Message-ID: <45F9463D.6050502@drugphish.ch>
References: <et6fp4$l04$1@sea.gmane.org>	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>	<45F6CD7C.40708@ufomechanic.net>	<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>	<1173868532.26913.39.camel@henriknordstrom.net>	<45F7D657.8070907@trash.net>	<1173876211.26913.73.camel@henriknordstrom.net>	<45F7F027.9050300@ufomechanic.net>	<45F7F3C6.3060908@trash.net>	<Pine.LNX.4.64.0703141415200.26704@blackhole.kfki.hu>	<Pine.LNX.4.64.0703141453400.26704@blackhole.kfki.hu>	<45F85C89.7070107@trash.net>	<1173905134.1760.59.camel@henriknordstrom.net>	<Pine.LNX.4.61.0703142148180.1199@yvahk01.tjqt.qr>	<1173910894.1760.89.camel@henriknordstrom.net>	<45F87E06.20201@gmx.net>
	<45F87F09.2070009@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Henrik Nordstrom <henrik@henriknordstrom.net>,
	Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
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

>>> just spewing ideas at this time. As Patrick I do not consider the core
>>> iptables worth the effort of such redesign and if redesigning stuff then
>>> something significantly better should be done. nf-HiPAC is one possible
>>> alternative where a lot is done much smarter even if communication
>>> between the projects is pretty distant at the moment.
>>
>> Speaking of HiPAC, when is it going to be merged? IIRC the merge was
>> discussed at the netfilter workshop 2005 with the goal to merge it in
>> 2.6.16. Has this decision been overturned/revised/forgotten or was
>> the report I read about that netfilter workshop inaccurate?
> 
> Unfortunately the discussion pretty much came to a halt over a year
> ago because of some disagreements. I still consider merging it a
> good idea, but since there is no progress in this area I will start
> working on a netlink based iptables replacement myself in the next
> months.

Cough ... could we guys over at ../ipv4/ipvs/ synchronise with your 
ideas? I've once started a port of IPVS to the netlink framework 
together with Thomas Graf, but stopped the project because I didn't find 
enough time. I'll be offline for at least one year soon but my fellow 
hackers (Horms at the moment) over at IPVS sure would like to combine 
efforts; maybe we can even completely integrate IPVS into the new (fast 
and memory-efficient like nf-hipac) netfilter framework and share the 
netlink code in user space with regards to iptables and ipvsadm.

Best regards,
Roberto Nibali, ratz
-- 
echo 
'[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
