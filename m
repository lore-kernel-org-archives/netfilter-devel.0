From: Roman Kubiak <r.kubiak@samsung.com>
Subject: Re: [PATCH v2] nfnetlink_queue: add security context information
Date: Tue, 26 May 2015 14:29:37 +0200
Message-ID: <55646731.9040803@samsung.com>
References: <5562F661.5000503@samsung.com> <20150525131319.GA3529@salvia>
 <55634935.4020100@samsung.com> <20150525205210.GG3629@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?B?UmFmYcWCIEtyeXBh?= <r.krypa@samsung.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33271 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbbEZNmo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 May 2015 09:42:44 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NOY00J0HIPFEC30@mailout3.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Tue, 26 May 2015 13:29:39 +0100 (BST)
In-reply-to: <20150525205210.GG3629@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I was wondering, assuming i remove the NULL termination and SMACK sends a piece of data that's not null terminated,
how, on the userland side, can i find out about that size ?

Please notice that i send a libnetfilter_queue patch:
[PATCH] libnetfitler_queue: receive security context info

it uses
*secdata = (unsigned char *)nfnl_get_pointer_to_data(nfad->data, NFQA_SECCTX, char);
to get the security context data, but there is no info about the size, where can i find that not to go over bounds and read beyond what i should ?

I already have the patch prepared with the NULL termination removed but i'd like to make sure it will be ok.

best regards
On 05/25/2015 10:52 PM, Florian Westphal wrote:
> Roman Kubiak <r.kubiak@samsung.com> wrote:
>> [sidenote]
>> The additional NULL at the end of the security context is there because SMACK does not add this
>> to it's labels while SELinux does. So in order to avoid checking i just add it always.
>> This additional byte is also represented when calculating the size.
>> I did that because we are not transmitting the size of the context and there is no specified
>> max length so it has to be NULL terminated (at least it seemed like a valid solution)
> 
> The netlink header contains the size of the attribute.
> I'd prefer to not have the kernel deal with NULL termination.
> 
>> +static u32 nfqnl_get_sk_secctx(struct sock *sk, char **secdata)
>> +{
>> +	u32 secid = 0;
>> +	u32 seclen = 0;
>> +	int ret = -1;
>> +
>> +	if (!sk || !sk_fullsock(sk))
>> +		return ret;
> 
> return 0/return seclen?
> 
>> +	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
>> +		seclen = nfqnl_get_sk_secctx(entskb->sk, &secdata);
>> +			if (seclen > 0)
>> +				size += nla_total_size(seclen) + 1;
> 
> Wrong intent level for if (seclen > 0)
> 
> Other than this, it looks ok to me.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
--------------
 Roman Kubiak
--------------
