From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/5] netfilter: xt extensions: use pr_<level> (2)
Date: Thu, 25 Mar 2010 14:20:21 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003251414350.30248@obet.zrqbmnf.qr>
References: <1269521809-29393-1-git-send-email-jengelh@medozas.de> <1269521809-29393-3-git-send-email-jengelh@medozas.de> <4BAB604A.2090808@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51317 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab0CYNUW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:20:22 -0400
In-Reply-To: <4BAB604A.2090808@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-03-25 14:08, Patrick McHardy wrote:
>
>Why don't you remove the now unused PRINTR macro?
>
Oversight, thanks for catching.

>> @@ -294,7 +294,8 @@ clusterip_tg(struct sk_buff *skb, const struct xt_target_param *par)
>>  
>>  	ct = nf_ct_get(skb, &ctinfo);
>>  	if (ct == NULL) {
>> -		printk(KERN_ERR "CLUSTERIP: no conntrack!\n");
>> +		if (net_ratelimit())
>> +			pr_info("no conntrack!\n");
>
>There are a few changes in log level in this file and other files
>that need more explanation in the changelog than "supplement to ...".
>
>> -		printk(KERN_WARNING "CLUSTERIP: unknown mode `%u'\n",
>> -			cipinfo->hash_mode);
>> +		pr_info("unknown mode %u\n", cipinfo->hash_mode);
>
>pr_err() actually seems more appropriate, if we'd use it consistenly
>to report error conditions.

I felt that EINVAL parameter problems are not enough of an error
condition to warrant the error level. It's not critical (as in:
printer on fire), error I would associate with sda rejecting I/O,
warning that an NFS server is slow to respond, notice that disk space
is getting below 5% (not that the kernel does that, but that would be
my judgment). The messages printed by checkentry functions is IMO
just an additional information to the -EINVAL that's returned. Of course
we can always change it anyway.

#define KERN_EMERG      "<0>"   /* system is unusable                   */
#define KERN_ALERT      "<1>"   /* action must be taken immediately     */
#define KERN_CRIT       "<2>"   /* critical conditions                  */
#define KERN_ERR        "<3>"   /* error conditions                     */
#define KERN_WARNING    "<4>"   /* warning conditions                   */
#define KERN_NOTICE     "<5>"   /* normal but significant condition     */
#define KERN_INFO       "<6>"   /* informational                        */
