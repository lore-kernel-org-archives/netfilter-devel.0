From: Bryan Duff <bduff@astrocorp.com>
Subject: Re: xt_statistic.c - the statistic match
Date: Thu, 15 Jan 2009 09:34:32 -0600
Message-ID: <496F5788.3060502@astrocorp.com>
References: <4967CDCB.3080306@astrocorp.com>	 <alpine.LSU.2.00.0901100433100.28890@fbirervta.pbzchgretzou.qr>	 <496B7F66.40900@astrocorp.com> <38bcb3ec0901150237nc2d8316l62c27beef7e59170@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: James King <t.james.king@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.astrocorp.com ([75.160.64.129]:21442 "EHLO
	mail.astrocorp.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750942AbZAOPdO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jan 2009 10:33:14 -0500
In-Reply-To: <38bcb3ec0901150237nc2d8316l62c27beef7e59170@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

James King wrote:
> On Mon, Jan 12, 2009 at 9:35 AM, Bryan Duff <bduff@astrocorp.com> wrote:
>   
>> Jan Engelhardt wrote:
>>     
>>> On Friday 2009-01-09 23:20, Bryan Duff wrote:
>>>
>>>
>>>       
>>>> ... gets out of sync in nth mode.  The count seems to be off somehow.  At
>>>> some
>>>> point the count is off - in my case I have 3 rules that are consecutive:
>>>>
>>>> //snip - iptables rules
>>>> iptables -t mangle -A PREROUTING -i ethX -s 10.10.10.0/24 -d
>>>> 10.10.11.0/24 -m
>>>> statistic --mode nth --every 3 --packet 0 -j MARK --set-mark 1
>>>> iptables -t mangle -A PREROUTING -i ethX -s 10.10.10.0/24 -d
>>>> 10.10.11.0/24 -m
>>>> statistic --mode nth --every 3 --packet 1 -j MARK --set-mark 2
>>>> iptables -t
>>>> mangle -A PREROUTING -i ethX -s 10.10.10.0/24 -d 10.10.11.0/24 -m
>>>> statistic
>>>> --mode nth --every 3 --packet 2 -j MARK --set-mark 3
>>>> //end snip
>>>>
>>>> Now when I accept those mark values, the packet counts which should be
>>>> almost
>>>> equal are off by large numbers (hundreds of thousands):
>>>>         
>> I have three rules.  Each rule marks one packet for every three that match -
>> no packets matching that criteria should fall through.  After they are
>> marked, I accept them.
>>     
>>>> //snip - iptables -L
>>>> 978189 1210792980 ACCEPT     all  --  ethX   *       10.10.10.0/24
>>>> 10.10.11.0/24    MARK match 0x1
>>>> 2182885 2704995300 ACCEPT     all  --  ethX   *       10.10.10.0/24
>>>> 10.10.11.0/24    MARK match 0x2
>>>> 2289382 2862482240 ACCEPT     all  --  ethX   *       10.10.10.0/24
>>>> 10.10.11.0/24    MARK match 0x3
>>>> 1417708 1807169776 MARK       all  --  ethX   *       10.10.10.0/24
>>>>  10.10.11.0/24    MARK set 0x1
>>>> 1417708 1807169776 ACCEPT     all  --  ethX   *       10.10.10.0/24
>>>>  10.10.11.0/24    MARK match 0x1
>>>>         
>> //end snip
>>     
>
> I'm a bit curious about this.  I thought it was only possible to use
> the MARK target in mangle, but you seem to be listing the filter
> table.  I notice that mark_tg_reg[] revision 2 doesn't limit the table
> to mangle like r0 and r1 do (anyone know if this a bug, or is r2
> intended to be available everywhere?), but even so, when I try to
> replicate rule #4 on 2.6.28+1.4.3-rc1, I just get a dmesg error.
>
>   
>> Those are the accept rules..., here are the match rules:
>>
>> 126489573 186243254796 MARK       all  --  eth0   *       10.10.10.0/24
>>    10.10.11.0/24    statistic mode nth every 3 MARK set 0x11
>> 126489608 186238009472 MARK       all  --  eth0   *       10.10.10.0/24
>>    10.10.11.0/24    statistic mode nth every 3 packet 1 MARK set 0x12
>> 126489614 186238262872 MARK       all  --  eth0   *       10.10.10.0/24
>>    10.10.11.0/24    statistic mode nth every 3 packet 2 MARK set 0x13
>> //the accept rules are right here...
>>
>> I mark the packets (in this case a packet goes through 3 statistic match
>> rules, and one should be marked).  And then I accept the marks - otherwise
>> the are remarked at some point later (which I don't want).  But the problem
>> is that the 3 match rules get out of sync.  So instead of each rule matching
>> on a different packet (and incrementing on every packet) - at some point 2
>> of the 3 rules are matching the same packet.
>>
>> How could that happen?  I'm not accepting between the statistic match rules
>> (which would definitely cause the rules to get out of sync).
>>     
>
> Have you tried using iptables-restore?
>
> If you're using iptables to commit these rules individually (as your
> first message implies) and the system is under traffic already, it's
> easy for them to get out of sync because each nth rule tracks its own
> state individually and MARK is non-terminating.  Any packets processed
> by the kernel between each rule addition will cause their packet
> counters (and potentially nth count) to be out of sync.  There will be
> a consistent delta between the packet counters for the mangle
> PREROUTING rules, since they only mark the packet (or not) and
> continue processing the rest of the chain.  However, if the nth count
> isn't in sync across all the rules, the mark can be overwritten
> further down the chain, and subsequently mess up the filter rules.
> An example using your rules (assuming subnet, etc already match):
>
>   
No, no.  That would imply my problem happens when I add these rules.  It 
doesn't.  The problem occurs some time much later (a few hundred 
thousand packets or more later).  So I don't see how the problem could 
be adding the rules, and letting a packet slip by while adding if that 
is _when_ the problem occurs.
> Rule #1 added
> 	Packet #1 processed
> 		Rule #1 (initial count = 2, every = 2) matches, set mark 0x11
> 	Packet #2 processed
> 		Rule #1 (count = 0, every = 2) no match
> Rule #2 added
> 	Packet #3 processed
> 		Rule #1 (count = 1, every = 2) no match
> 		Rule #2 (initial count = 1, every = 2) no match
> Rule #3 added
> 	Packet #4 processed
> 		Rule #1 (count = 2, every = 2) matches, set mark 0x11
> 		Rule #2 (count = 2, every = 2) matches, overwrite mark 0x12
> 		Rule #3 (initial count = 0, every = 2) no match
> 	Packet #5 processed
> 		Rule #1 (count = 0, every = 2) no match
> 		Rule #2 (count = 0, every = 2) no match
> 		Rule #3 (count = 1, every = 2) no match
>   

