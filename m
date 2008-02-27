From: mouss <mouss@netoyen.net>
Subject: Re: [RFC] Allowing non-root to get iptables info?
Date: Wed, 27 Feb 2008 15:39:26 +0100
Message-ID: <47C5761E.5070606@netoyen.net>
References: <20080225094951.5bd89c9c@extreme> <47C54F14.4010709@trash.net> <20080227123122.GA22353@rere.qmqm.pl> <47C55AFC.7090705@trash.net> <Pine.LNX.4.64.0802271351550.12047@blackhole.kfki.hu> <47C55FC5.60607@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	=?ISO-8859-15?Q?Micha=B3?= =?ISO-8859-15?Q?_Miros=B3aw?=
	<mirq-linux@rere.qmqm.pl>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from balou.adapsec.com ([91.121.103.130]:63025 "EHLO
	balou.adapsec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbYB0OrG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 09:47:06 -0500
In-Reply-To: <47C55FC5.60607@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> [Adding Stephen back to CC list]
>
> Jozsef Kadlecsik wrote:
>> On Wed, 27 Feb 2008, Patrick McHardy wrote:
>>
>>> Micha? Miros?aw wrote:
>>>> On Wed, Feb 27, 2008 at 12:52:52PM +0100, Patrick McHardy wrote:
>>>>> Stephen Hemminger wrote:
>>>>>> Is there any strong reason why checking the status of iptables is
>>>>>> restricted?
>>>>>>
>>>>>> Vyatta makes a distribution for routers. In our case, we use a 
>>>>>> non-root
>>>>>> account
>>>>>> for operator commands, and some of the commands are about querying
>>>>>> iptables status.
>>>>>> It seems to be less risky to just fix the kernel to allow 
>>>>>> non-root user
>>>>>> to query rules
>>>>>> than the current script that uses sudo. Another alternative would be
>>>>>> building a special
>>>>>> restricted command that could be setuid root, but just changing the
>>>>>> kernel seems easiest.
>>>>> I always thought of it as a privacy thing, similar to restricting
>>>>> /proc/net/nf_conntrack. But since iptables rules usually don't
>>>>> allow you to determine active connections just from the packet
>>>>> counters that might be overkill. So I don't see any real harm
>>>>> in allowing users to list the ruleset.
>>>> At least for iptables, reading of iptables status can be done by 
>>>> making
>>>> iptables-save setuid-root. So I think no kernel patching is necessary.
>>> Thats true, but I wouldn't do that since iptables is not the
>>> most trustworthy code.
>>
>> I'd be more happy with a module parameter and/or proc switch by which 
>> this new feature could be enabled. So backward compatibility could be 
>> kept and the users could list the rules only if the system is 
>> explicitly configured to allow it.
>
>
> I don't think compatibility is a problem here, lifting this
> restriction can't possibly break anything in userspace.
>
> The question is more whether this causes privacy or other issues,
> if yes, we shouldn't do it, otherwise there's no harm in doing
> in unconditionally. I personally don't see any problems with
> this change.


on a server where are allowed to run commands, but we don't want them to 
know more than they should, I am not sure one wants them to see the 
rules. call it security by obscurity if you like, but some people may 
want this. I guess this is what Jozef meant by compatibility (is it 
"least surprise"?).
