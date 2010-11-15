From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libxtables: change option precedence order to be intuitive
Date: Mon, 15 Nov 2010 11:38:02 +0100
Message-ID: <4CE10D8A.1090102@trash.net>
References: <1287501388-5948-1-git-send-email-jengelh@medozas.de> <1287501388-5948-2-git-send-email-jengelh@medozas.de> <alpine.LNX.2.01.1010252357270.18188@obet.zrqbmnf.qr> <4CC94854.8010306@trash.net> <alpine.LNX.2.01.1010281250120.2326@obet.zrqbmnf.qr> <AANLkTi=V1vzOxF84M-weryWgQdozzwiyZwFUBMnd9MTH@mail.gmail.com> <alpine.LNX.2.01.1010291458200.3755@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Changli Gao <xiaosuo@gmail.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61853 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab0KOKiA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:38:00 -0500
In-Reply-To: <alpine.LNX.2.01.1010291458200.3755@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 29.10.2010 14:59, Jan Engelhardt wrote:
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

Something very non-intuitive is happening with this patch:

# iptables -A OUTPUT -p tcp --dport 10000
iptables v1.4.9: host/network `port' not found
Try `iptables -h' or 'iptables --help' for more information.

port is interpreted as parameter to '-d'. I'm reverting this for
now, please resend if you can come up with a way to fix this.
