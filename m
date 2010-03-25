From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/5] netfilter: xt extensions: use pr_<level> (2)
Date: Thu, 25 Mar 2010 14:27:45 +0100
Message-ID: <4BAB64D1.2070404@trash.net>
References: <1269521809-29393-1-git-send-email-jengelh@medozas.de> <1269521809-29393-3-git-send-email-jengelh@medozas.de> <4BAB604A.2090808@trash.net> <alpine.LSU.2.01.1003251414350.30248@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51971 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab0CYN1q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:27:46 -0400
In-Reply-To: <alpine.LSU.2.01.1003251414350.30248@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2010-03-25 14:08, Patrick McHardy wrote:
>> Why don't you remove the now unused PRINTR macro?
>>
> Oversight, thanks for catching.
> 
>>> @@ -294,7 +294,8 @@ clusterip_tg(struct sk_buff *skb, const struct xt_target_param *par)
>>>  
>>>  	ct = nf_ct_get(skb, &ctinfo);
>>>  	if (ct == NULL) {
>>> -		printk(KERN_ERR "CLUSTERIP: no conntrack!\n");
>>> +		if (net_ratelimit())
>>> +			pr_info("no conntrack!\n");
>> There are a few changes in log level in this file and other files
>> that need more explanation in the changelog than "supplement to ...".
>>
>>> -		printk(KERN_WARNING "CLUSTERIP: unknown mode `%u'\n",
>>> -			cipinfo->hash_mode);
>>> +		pr_info("unknown mode %u\n", cipinfo->hash_mode);
>> pr_err() actually seems more appropriate, if we'd use it consistenly
>> to report error conditions.
> 
> I felt that EINVAL parameter problems are not enough of an error
> condition to warrant the error level. It's not critical (as in:
> printer on fire), error I would associate with sda rejecting I/O,
> warning that an NFS server is slow to respond, notice that disk space
> is getting below 5% (not that the kernel does that, but that would be
> my judgment). The messages printed by checkentry functions is IMO
> just an additional information to the -EINVAL that's returned. Of course
> we can always change it anyway.

Fair enough, but some consistency among modules would be great. There
are a few instances of pr_err/warning used for memory allocation errors
or invalid parameters in this patch.
