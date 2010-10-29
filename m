From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libxtables: change option precedence order to be intuitive
Date: Fri, 29 Oct 2010 19:04:05 +0200
Message-ID: <4CCAFE85.7040409@trash.net>
References: <1287501388-5948-1-git-send-email-jengelh@medozas.de> <1287501388-5948-2-git-send-email-jengelh@medozas.de> <alpine.LNX.2.01.1010252357270.18188@obet.zrqbmnf.qr> <4CC94854.8010306@trash.net> <alpine.LNX.2.01.1010281250120.2326@obet.zrqbmnf.qr> <AANLkTi=V1vzOxF84M-weryWgQdozzwiyZwFUBMnd9MTH@mail.gmail.com> <alpine.LNX.2.01.1010291458200.3755@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Changli Gao <xiaosuo@gmail.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43231 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab0J2REH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:04:07 -0400
In-Reply-To: <alpine.LNX.2.01.1010291458200.3755@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 29.10.2010 14:59, schrieb Jan Engelhardt:
> On Friday 2010-10-29 07:26, Changli Gao wrote:
>>>>>
>>>>>> When using `-m mark --mark 2 -m connmark --mark 2`, the user currently
>>>>>> gets an error about the (libxt_mark) --mark option being used twice.
>>>>>> This is because libxt_connmark's option table does not override any
>>>>>> previous options. This patch changes this behavior, since the current
>>>>>> behavior does not allow connmark's option to be used at all, which is
>>>>>> illogical.
>>>>>
>>>>> As per fw's suggestion, I should nag you every 48 hours ;-)
>>>>>
>>>>> Really, this should be in the next tag.
>>>>
>>>> This stuff is pretty fragile and whenever we changed it, something broke
>>>> for users. Why not simply add new options  (--connmark etc). That would
>>>> also be more consistent with the other extensions.
>>>
>>> Adding new options does not fix the real problem, and you cannot easily
>>> ensure that no options will clash with another.
>>> And what do you do when you use -m hashlimit --hashlimit-name abc -m
>>> hashlimit --hashlimit-name def? You can't use new options here.
>>
>> I think this issue was discussed in this thread:
>> http://marc.info/?l=netfilter-devel&m=121881908205975&w=2 . And the
>> above command should be OK. Did you test it?
> 
> Well ok bad example; -m hashlimit twice works, as does your linked 
> example when replacing -m a and -m b with -m mac.

I've applied the patch to iptables-next, but if something breaks
I'll revert it and add --connmark- prefixed options.
