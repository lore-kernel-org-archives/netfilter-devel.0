From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables performance and alternatives
Date: Thu, 15 May 2008 14:01:43 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805151400140.16151@fbirervta.pbzchgretzou.qr>
References: <200805151421.23862.anton.vazir@gmail.com> <200805151557.28368.anton.vazir@gmail.com> <alpine.LNX.1.10.0805151318020.16151@fbirervta.pbzchgretzou.qr> <200805151629.22785.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42871 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbYEOMBp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 08:01:45 -0400
In-Reply-To: <200805151629.22785.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-05-15 13:29, Anton wrote:
>On Thursday 15 May 2008 16:18, Jan Engelhardt wrote:
>> On Thursday 2008-05-15 12:57, Anton wrote:
>> >Definitelly what my test shows - while rule-inserts - if
>> > you try to insert 10000 rules - after a several
>> > hundreds - it will be inserting like a 1 rule in 1
>> > second and slowness will progress :)
>>
>> Your insertion slowness is probably due to incorrect use
>> of iptables.
>
>Possible too. 
>
>But aside of use of IPMARK from xtables, if I have to match 
>80  (prio traffic)  22(realtime) port for every customer IP 

prio and realtime sound quite the same :p

>and customer's ip too (bulk traffic) for another mark set 
>and all with different htb queues - IPMARK will not help 
>and in case of, say, 1000 matching IP's, it comes to 4 
>queues per , with 3 to use with lending/borrowing (main, 
>80, and 22) and 3000 queuses in total, plus POSTROUTING 
>mangle rule per park (3000 rules) + 3000 return rules 
>(6000) rules and so on. If this PC also do NAT for 
>matches - it will come with extra 1000 rules (or single 
>IPSET :)
>
>If there is a better approach to this in relation to 
>IPTABLES - this would be just great...

Write your own module that sets the mark according to your taste, it is not
that hard. I have a semibook ("big pdf") on that entitled "Writing your own
Netfilter modules" on http://jengelh.medozas.de/. You can easily use IPMARK
as a base.
