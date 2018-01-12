From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH nf-next] netfilter: ipv6: nf_defrag: Always pass on
 packets to stack
Date: Fri, 12 Jan 2018 00:55:27 -0700
Message-ID: <26438ce451e2e86d926fd9ebe2f9b43e@codeaurora.org>
References: <1515737073-32344-1-git-send-email-subashab@codeaurora.org>
 <1515737073-32344-2-git-send-email-subashab@codeaurora.org>
 <20180112063552.GA27085@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41920 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932874AbeALHz2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Jan 2018 02:55:28 -0500
In-Reply-To: <20180112063552.GA27085@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2018-01-11 23:35, Florian Westphal wrote:
> Subash Abhinov Kasiviswanathan <subashab@codeaurora.org> wrote:
>> diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c 
>> b/net/ipv6/netfilter/nf_conntrack_reasm.c
>> index 977d890..a44c8b2 100644
>> --- a/net/ipv6/netfilter/nf_conntrack_reasm.c
>> +++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
>> @@ -574,17 +574,26 @@ int nf_ct_frag6_gather(struct net *net, struct 
>> sk_buff *skb, u32 user)
>>  	struct ipv6hdr *hdr;
>>  	u8 prevhdr;
>> 
>> +	skb = skb_clone(skb, GFP_ATOMIC);
>> +	if (!skb)
>> +		return -ENOMEM;
>> +
>>  	/* Jumbo payload inhibits frag. header */
>>  	if (ipv6_hdr(skb)->payload_len == 0) {
>>  		pr_debug("payload len = 0\n");
>> +		kfree(skb);
> 
> kfree_skb ?

Hi Florian

Yes, it should have been kfree_skb(skb) in all the instances.
I will update it in v2.
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
