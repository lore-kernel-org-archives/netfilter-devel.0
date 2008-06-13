From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Patch] Re: Line numbering broken since bb34082d
Date: Fri, 13 Jun 2008 17:58:36 +0200
Message-ID: <4852992C.5050106@trash.net>
References: <alpine.LNX.1.10.0806131107340.23098@fbirervta.pbzchgretzou.qr> <1213354753.30942.7.camel@henriknordstrom.net> <alpine.LNX.1.10.0806131418320.23098@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <henrik@henriknordstrom.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44888 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbYFMP6j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2008 11:58:39 -0400
In-Reply-To: <alpine.LNX.1.10.0806131418320.23098@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2008-06-13 12:59, Henrik Nordstrom wrote:
>> On fre, 2008-06-13 at 11:14 +0200, Jan Engelhardt wrote:
>>
>>> `iptables -nvL --lin`, starting with bb34082de, gives a wrong count:
>>>
>>> Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
>>> num   pkts bytes target     prot opt in     out     source               
>>> destination         
>>> 2        0     0 LOG        all  --  *      *       0.0.0.0/0            
>>> 0.0.0.0/0           LOG flags 0 level 4 
>> Sorry about that. Never tested --line-numbers.
>>
>> I think the best fix is to drop the +1 from print_firewall(). Patch attached.
> 
> Indeed, that is the right thing to do, since with my patch,
> iptables -nvL INPUT 1  would still show the 2nd rule.


Thanks, I applied Henrik's patch with your description.
