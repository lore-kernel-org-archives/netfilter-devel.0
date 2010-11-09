From: Patrick McHardy <kaber@trash.net>
Subject: Re: [arptables] rfc: add classify target
Date: Tue, 09 Nov 2010 15:25:26 +0100
Message-ID: <4CD959D6.1090705@trash.net>
References: <20101107152636.56f62235@caresse> <alpine.LNX.2.01.1011071616150.21289@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Frederic Leroy <fredo@starox.org>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56653 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab0KIOZ2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Nov 2010 09:25:28 -0500
In-Reply-To: <alpine.LNX.2.01.1011071616150.21289@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 07.11.2010 16:18, schrieb Jan Engelhardt:
> On Sunday 2010-11-07 15:26, Frederic Leroy wrote:
>>
>> I wrote a new classify target. Patches for both current linux-stable and
>> arptables cvs are joined.
>>
>> +++ b/net/ipv4/netfilter/arpt_classify.c
>> @@ -0,0 +1,41 @@
>> +/* module that allows classification of arp packet */
>> +#include <linux/module.h>
>> +#include <linux/netfilter.h>
>> +#include <linux/netfilter/x_tables.h>
>> +#include <linux/netfilter_arp/arpt_classify.h>
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Frederic Leroy <fredo@starox.org>");
>> +MODULE_DESCRIPTION("arptables arp classify target");
>> +
>> +static unsigned int
>> +target(struct sk_buff *skb, const struct xt_action_param *par)
>> +{
>> +	const struct arpt_classify *classify = par->targinfo;
>> +
>> +	skb->priority=classify->priority;
>> +
>> +	return XT_CONTINUE;
>> +}
> 
> Why did you not update xt_CLASSIFY instead?

Actually we already register for NFPROTO_UNSPEC, so simply
adding a userspace extension should do the job.
