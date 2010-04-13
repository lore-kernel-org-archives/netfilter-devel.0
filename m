From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/6] netfilter: xtables2: make ip_tables reentrant
Date: Tue, 13 Apr 2010 13:15:38 +0200
Message-ID: <4BC4525A.8000507@trash.net>
References: <1270666217-27670-1-git-send-email-jengelh@medozas.de> <1270666217-27670-5-git-send-email-jengelh@medozas.de> <4BC44009.4080206@trash.net> <alpine.LSU.2.01.1004131247580.11306@obet.zrqbmnf.qr> <4BC44CB8.4080405@trash.net> <alpine.LSU.2.01.1004131311330.16098@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47334 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab0DMLPj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 07:15:39 -0400
In-Reply-To: <alpine.LSU.2.01.1004131311330.16098@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2010-04-13 12:51, Patrick McHardy wrote:
>>>>> +/* Allow this many total (re)entries. */
>>>>> +static unsigned int xt_jumpstack_multiplier = 2;
>>>>> +module_param_named(jumpstack_multiplier, xt_jumpstack_multiplier,
>>>>> +	uint, S_IRUGO | S_IWUSR);
>>>>> +
>>>> This seems very wrong. Why should the user care about this?
>>> Who said every sysfs variable is for end-users?
>> Then who should care?
> 
> Developers, perhaps. Not exporting the parameter is no big deal.

Developers can change it in the source code. Please remove the
parameter and hard code it.

I'll then apply this patch if we can get rid of the ruleset
duplication for each CPU.

