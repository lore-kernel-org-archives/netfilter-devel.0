From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 4/6] netfilter: xtables2: make ip_tables reentrant
Date: Tue, 13 Apr 2010 13:12:26 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004131311330.16098@obet.zrqbmnf.qr>
References: <1270666217-27670-1-git-send-email-jengelh@medozas.de> <1270666217-27670-5-git-send-email-jengelh@medozas.de> <4BC44009.4080206@trash.net> <alpine.LSU.2.01.1004131247580.11306@obet.zrqbmnf.qr> <4BC44CB8.4080405@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50892 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab0DMLM2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 07:12:28 -0400
In-Reply-To: <4BC44CB8.4080405@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-04-13 12:51, Patrick McHardy wrote:
>>>> +/* Allow this many total (re)entries. */
>>>> +static unsigned int xt_jumpstack_multiplier = 2;
>>>> +module_param_named(jumpstack_multiplier, xt_jumpstack_multiplier,
>>>> +	uint, S_IRUGO | S_IWUSR);
>>>> +
>>> This seems very wrong. Why should the user care about this?
>> 
>> Who said every sysfs variable is for end-users?
>
>Then who should care?

Developers, perhaps. Not exporting the parameter is no big deal.
