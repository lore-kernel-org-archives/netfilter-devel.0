From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] Allowing non-root to get iptables info?
Date: Wed, 27 Feb 2008 15:51:20 +0100
Message-ID: <47C578E8.8040800@trash.net>
References: <20080225094951.5bd89c9c@extreme> <47C54F14.4010709@trash.net> <20080227123122.GA22353@rere.qmqm.pl> <47C55AFC.7090705@trash.net> <Pine.LNX.4.64.0802271351550.12047@blackhole.kfki.hu> <47C55FC5.60607@trash.net> <47C5761E.5070606@netoyen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	=?ISO-8859-15?Q?Micha=B3?= =?ISO-8859-15?Q?_Miros=B3aw?=
	<mirq-linux@rere.qmqm.pl>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>
To: mouss <mouss@netoyen.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:45031 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753606AbYB0OvS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 09:51:18 -0500
In-Reply-To: <47C5761E.5070606@netoyen.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

mouss wrote:
> Patrick McHardy wrote:
>> [Adding Stephen back to CC list]
>>
>> Jozsef Kadlecsik wrote:
>>> I'd be more happy with a module parameter and/or proc switch by which 
>>> this new feature could be enabled. So backward compatibility could be 
>>> kept and the users could list the rules only if the system is 
>>> explicitly configured to allow it.
>>
>>
>> I don't think compatibility is a problem here, lifting this
>> restriction can't possibly break anything in userspace.
>>
>> The question is more whether this causes privacy or other issues,
>> if yes, we shouldn't do it, otherwise there's no harm in doing
>> in unconditionally. I personally don't see any problems with
>> this change.
> 
> 
> on a server where are allowed to run commands, but we don't want them to
> know more than they should, I am not sure one wants them to see the
> rules. call it security by obscurity if you like, but some people may
> want this. I guess this is what Jozef meant by compatibility (is it
> "least surprise"?).


Well, yes, the main question is whether this causes privacy issues.
"Security by obscurity" is a pretty poor argument, does anyone have
a well founded reason for not allowing users to see the rules and
counters?


