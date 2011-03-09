From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2] netfilter: ipt_addrtype: rename to xt_addrtype
Date: Wed, 9 Mar 2011 20:06:49 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1103092006131.9143@obet.zrqbmnf.qr>
References: <1299341328-4663-1-git-send-email-fw@strlen.de> <4D76471E.8050503@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:34001 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab1CITGu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2011 14:06:50 -0500
In-Reply-To: <4D76471E.8050503@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-03-08 16:11, Patrick McHardy wrote:

>Am 05.03.2011 17:08, schrieb Florian Westphal:
>> From: Florian Westphal <fwestphal@astaro.com>
>> 
>> followup patch will add ipv6 support.
>> 
>> Signed-off-by: Florian Westphal <fwestphal@astaro.com>
>> ---
>>  include/linux/netfilter/Kbuild                     |    1 +
>>  .../ipt_addrtype.h => netfilter/xt_addrtype.h}     |   16 +++++-----
>
>Please keep this file and the original definitions for a while
>(add to feature-removal-schedule) for compatibility. You can
>redefine them to the xt_ values/structures so they can be used
>inside the kernel.

Just like ipt_realm.h does, yeah.
