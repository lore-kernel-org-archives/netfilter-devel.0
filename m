From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 3/4] netfilter: xtables: use xt_table for hook
 instantiation
Date: Wed, 10 Feb 2010 17:07:40 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002101705590.12673@obet.zrqbmnf.qr>
References: <1265813954-13854-1-git-send-email-jengelh@medozas.de> <1265813954-13854-4-git-send-email-jengelh@medozas.de> <4B72D1DF.4040409@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52546 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab0BJQHl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:07:41 -0500
In-Reply-To: <4B72D1DF.4040409@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-02-10 16:33, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> +static unsigned int xt_hookmask_bitcount(unsigned int mask)
>> +{
>> +	unsigned int bits = 0;
>> +
>> +	for (; mask != 0; mask >>= 1)
>> +		if (mask & 1)
>> +			++bits;
>> +	return bits;
>> +}
>
>Why not use hweight32()?

Seriously, I looked for popcount (which is how this is called in 
hardware), and was disappointed. Thanks for pointing out hweight.

