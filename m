From: Bryan Duff <bduff@astrocorp.com>
Subject: Re: xt_statistic.c - the statistic match
Date: Mon, 12 Jan 2009 11:35:34 -0600
Message-ID: <496B7F66.40900@astrocorp.com>
References: <4967CDCB.3080306@astrocorp.com> <alpine.LSU.2.00.0901100433100.28890@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.astrocorp.com ([75.160.64.129]:21481 "EHLO
	mail.astrocorp.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751506AbZALRee (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:34:34 -0500
In-Reply-To: <alpine.LSU.2.00.0901100433100.28890@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2009-01-09 23:20, Bryan Duff wrote:
>
>   
>> ... gets out of sync in nth mode.  The count seems to be off somehow.  At some
>> point the count is off - in my case I have 3 rules that are consecutive:
>>
>> //snip - iptables rules
>> iptables -t mangle -A PREROUTING -i ethX -s 10.10.10.0/24 -d 10.10.11.0/24 -m
>> statistic --mode nth --every 3 --packet 0 -j MARK --set-mark 1
>> iptables -t mangle -A PREROUTING -i ethX -s 10.10.10.0/24 -d 10.10.11.0/24 -m
>> statistic --mode nth --every 3 --packet 1 -j MARK --set-mark 2
>> iptables -t
>> mangle -A PREROUTING -i ethX -s 10.10.10.0/24 -d 10.10.11.0/24 -m statistic
>> --mode nth --every 3 --packet 2 -j MARK --set-mark 3
>> //end snip
>>
>> Now when I accept those mark values, the packet counts which should be almost
>> equal are off by large numbers (hundreds of thousands):
>>     
>
> Works for me..
>
> # iptables-save -c
> [11253:5051887] -A PREROUTING -m statistic --mode nth --every 3 [--packet 0]
> [11254:5117265] -A PREROUTING -m statistic --mode nth --every 3 --packet 1 
>
>   
I have three rules.  Each rule marks one packet for every three that 
match - no packets matching that criteria should fall through.  After 
they are marked, I accept them.
>> //snip - iptables -L
>> 978189 1210792980 ACCEPT     all  --  ethX   *       10.10.10.0/24
>> 10.10.11.0/24    MARK match 0x1
>> 2182885 2704995300 ACCEPT     all  --  ethX   *       10.10.10.0/24
>> 10.10.11.0/24    MARK match 0x2
>> 2289382 2862482240 ACCEPT     all  --  ethX   *       10.10.10.0/24
>> 10.10.11.0/24    MARK match 0x3
>>     
>
> These do not seem to be the same rules you posted above.
> Where do all the mark matches come from?
>
>   
Those are the accept rules..., here are the match rules:

126489573 186243254796 MARK       all  --  eth0   *       
10.10.10.0/24        10.10.11.0/24    statistic mode nth every 3 MARK 
set 0x11
126489608 186238009472 MARK       all  --  eth0   *       
10.10.10.0/24        10.10.11.0/24    statistic mode nth every 3 packet 
1 MARK set 0x12
126489614 186238262872 MARK       all  --  eth0   *       
10.10.10.0/24        10.10.11.0/24    statistic mode nth every 3 packet 
2 MARK set 0x13
//the accept rules are right here...

I mark the packets (in this case a packet goes through 3 statistic match 
rules, and one should be marked).  And then I accept the marks - 
otherwise the are remarked at some point later (which I don't want).  
But the problem is that the 3 match rules get out of sync.  So instead 
of each rule matching on a different packet (and incrementing on every 
packet) - at some point 2 of the 3 rules are matching the same packet.

How could that happen?  I'm not accepting between the statistic match 
rules (which would definitely cause the rules to get out of sync).
>> 1417708 1807169776 MARK       all  --  ethX   *       10.10.10.0/24
>> 10.10.11.0/24    MARK set 0x1
>> 1417708 1807169776 ACCEPT     all  --  ethX   *       10.10.10.0/24
>> 10.10.11.0/24    MARK match 0x1
>> //end snip
>>     

