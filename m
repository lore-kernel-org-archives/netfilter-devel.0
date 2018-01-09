From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH nf-next v3] netfilter: nf_defrag: Skip defrag if NOTRACK
 is set
Date: Mon, 08 Jan 2018 22:34:07 -0700
Message-ID: <cb22f295786e536559cb57339a050eff@codeaurora.org>
References: <1515039887-25798-1-git-send-email-subashab@codeaurora.org>
 <20180108133206.2uvpgoxa5qdywrzp@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        kadlec@blackhole.kfki.hu
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45876 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753160AbeAIFeI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jan 2018 00:34:08 -0500
In-Reply-To: <20180108133206.2uvpgoxa5qdywrzp@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2018-01-08 06:32, Pablo Neira Ayuso wrote:
> Hi Subash,
> 
> One more concern before this gets upstream.
> 
> Do you think we can turn this into an on/off knob instead?
> 
> I mean, I think it's good if you add a new
> NF_IP_PRI_RAW_BEFORE_DEFRAG and we place it into uapi.
> 
> I'm just worried about follow up patches from people asking to making
> this flexible in all other existing tables, I would like this does not
> happen :-).
> 
>> +
>> +static struct xt_table packet_raw = {
>>  	.name = "raw",
>>  	.valid_hooks =  RAW_VALID_HOOKS,
>>  	.me = THIS_MODULE,
>> @@ -70,6 +74,14 @@ static int __init iptable_raw_init(void)
>>  {
>>  	int ret;
>> 
>> +	if (priority < NF_IP_PRI_CONNTRACK_DEFRAG &&
>> +	    priority > NF_IP_PRI_FIRST) {
>> +		packet_raw.priority = priority;
>> +
>> +		pr_info("iptable_raw: Using custom rule priority=%d\n",
>                          ^^^^^^^^^^^^
> 
> Probably better if you add:
> 
>         #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> in this patch while on this.
> 
> Thanks for your patience, we're almost there.

Hi Pablo

Sure, I can update these.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
