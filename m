Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AEDC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 13:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244361AbiEQNI4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 09:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347231AbiEQNIz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 09:08:55 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225AA3526D
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 06:08:50 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id a23-20020a17090acb9700b001df4e9f4870so2191510pju.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 06:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=W/XwwElUY4R+LVTosG4nDGVkKFkcEa93OXUupJjJ/MA=;
        b=TNq6l8kGu8TULvmaquHXxMEmFj2ahRm1XhpdWPF8DJ5CiEgocntstAD9jXc3wENCs6
         AVRaCQiri1taA66m8xB7FuDgXPegLCf7Fs6Zg7SsJQtbrbIWzyB4U1IzQLDGbXntQXY2
         wSdKX5XeXf11jIZgRChPKL5y/o/Z8jwvY1EudOkJyu2ajHtNffzCCTvxy9XC5WI9Vql2
         vUQHgIuw00Lr1Zcr1l5YSOcDXQEIeZYjlpZsIuOJj0KLgEaG6zdfBtHiZceGzA87/DFu
         R8i1FNtPRgYELMRC+B2gM5YCRijTbJocv6eOLgNxkWt/1GD3+UZpP7cqYHSQjsbB5PU7
         Emtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W/XwwElUY4R+LVTosG4nDGVkKFkcEa93OXUupJjJ/MA=;
        b=hy6Kj5HJ8dQPwrWaPg9ti73J9OB6bz7oAVxteaivpsACMxi+ksV9a0vjHZX4VgxtxC
         9KfO5HcjhExb5K87jVtivGNlvZZDgRP33PjU4+tWVA/QO4G7FaoTuJ9dzoFhXSPsz1jA
         fTcLmpaT7s2fYXGuiXKSb60k0NfER3kCR1B1L94/m0Mj3FMDtDqCu4b9t/kAuhuF3VD+
         1PsXb0Qa8e0v6vRyg4IyuLbGKrfWqwduOaPybiSnNoOsI6g0ark0FdHMUZ0SsRgvO2Gy
         x2z2+DVCf5kBfG2Wae+0WcKo8W5TG5uptSCJaE3YtCnfnzOSbc6awv/9UtUGSmgFsxqK
         U3xw==
X-Gm-Message-State: AOAM533ScFJB5kluy4/aQd4Jz+kInuwnwouEkwVacOocEKwZvbkacjCn
        0OMLsm/CBT2dd6bmliTd/5+70jLnxoZ6Zjcg
X-Google-Smtp-Source: ABdhPJw6QkmHw29MFZqkW2vgWU1v5lbUdN9xhvJnfBXgSdNwTB+wA925c8UfWlygSVf0VluIoAd0bQ==
X-Received: by 2002:a17:902:d4ce:b0:15e:90f7:5bf7 with SMTP id o14-20020a170902d4ce00b0015e90f75bf7mr22121626plg.98.1652792929506;
        Tue, 17 May 2022 06:08:49 -0700 (PDT)
Received: from [192.168.2.152] (fpa446b85c.tkyc319.ap.nuro.jp. [164.70.184.92])
        by smtp.gmail.com with ESMTPSA id r15-20020a63ec4f000000b003c14af50610sm8647233pgj.40.2022.05.17.06.08.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 06:08:49 -0700 (PDT)
Message-ID: <415936f0-497a-48eb-2c77-2585c3f5a8a2@gmail.com>
Date:   Tue, 17 May 2022 22:08:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2] netfilter: nf_flowtable: move dst_check to packet path
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20220511122423.556499-1-ritarot634@gmail.com>
 <YoIywy8+ZKN1PlMQ@salvia>
From:   Ritaro Takenaka <ritarot634@gmail.com>
In-Reply-To: <YoIywy8+ZKN1PlMQ@salvia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2022/05/16 20:17, Pablo Neira Ayuso wrote:
> On Wed, May 11, 2022 at 09:24:24PM +0900, Ritaro Takenaka wrote:
>> Fixes sporadic IPv6 packet loss when flow offloading is enabled.
>>
>> IPv6 route GC and flowtable GC are not synchronized.
>> When dst_cache becomes stale and a packet passes through the flow before
>> the flowtable GC teardowns it, the packet can be dropped.
>>
>> So, it is necessary to check dst every time in packet path.
>>
>> Signed-off-by: Ritaro Takenaka <ritarot634@gmail.com>
>> ---
>>  net/netfilter/nf_flow_table_core.c | 23 +----------------------
>>  net/netfilter/nf_flow_table_ip.c   | 17 +++++++++++++++++
>>  2 files changed, 18 insertions(+), 22 deletions(-)
>>
>> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
>> index 3db256da919b..1d99afaf22c1 100644
>> --- a/net/netfilter/nf_flow_table_core.c
>> +++ b/net/netfilter/nf_flow_table_core.c
>> @@ -438,32 +438,11 @@ nf_flow_table_iterate(struct nf_flowtable *flow_table,
>>  	return err;
>>  }
>>  
>> -static bool flow_offload_stale_dst(struct flow_offload_tuple *tuple)
>> -{
>> -	struct dst_entry *dst;
>> -
>> -	if (tuple->xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
>> -	    tuple->xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
>> -		dst = tuple->dst_cache;
>> -		if (!dst_check(dst, tuple->dst_cookie))
>> -			return true;
>> -	}
>> -
>> -	return false;
>> -}
>> -
>> -static bool nf_flow_has_stale_dst(struct flow_offload *flow)
>> -{
>> -	return flow_offload_stale_dst(&flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple) ||
>> -	       flow_offload_stale_dst(&flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple);
>> -}
>> -
>>  static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
>>  				    struct flow_offload *flow, void *data)
>>  {
>>  	if (nf_flow_has_expired(flow) ||
>> -	    nf_ct_is_dying(flow->ct) ||
>> -	    nf_flow_has_stale_dst(flow))
>> +	    nf_ct_is_dying(flow->ct))
>>  		set_bit(NF_FLOW_TEARDOWN, &flow->flags);
>>  
>>  	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
>> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
>> index 32c0eb1b4821..402742dd054c 100644
>> --- a/net/netfilter/nf_flow_table_ip.c
>> +++ b/net/netfilter/nf_flow_table_ip.c
>> @@ -367,6 +367,14 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
>>  	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
>>  		return NF_ACCEPT;
>>  
>> +	if (tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
>> +	    tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
> 
> Probably restore:
> 
> static inline bool nf_flow_dst_check(...)
> {
>         if (tuplehash->tuple.xmit_type != FLOW_OFFLOAD_XMIT_NEIGH &&
>             tuplehash->tuple.xmit_type != FLOW_OFFLOAD_XMIT_XFRM)
>                 return true;
> 
>         return dst_check(...);
> }
> 
> and use it.
> 
> BTW, could you also search for the Fixes: tag?
> 
> Thanks.
> 
>> +		if (!dst_check(tuplehash->tuple.dst_cache, 0)) {
>> +			flow_offload_teardown(flow);
>> +			return NF_ACCEPT;
>> +		}
>> +	}
>> +
>>  	if (skb_try_make_writable(skb, thoff + hdrsize))
>>  		return NF_DROP;
>>  
>> @@ -624,6 +632,15 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>>  	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
>>  		return NF_ACCEPT;
>>  
>> +	if (tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
>> +	    tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
>> +		if (!dst_check(tuplehash->tuple.dst_cache,
>> +			       tuplehash->tuple.dst_cookie)) {
>> +			flow_offload_teardown(flow);
>> +			return NF_ACCEPT;
>> +		}
>> +	}
>> +
>>  	if (skb_try_make_writable(skb, thoff + hdrsize))
>>  		return NF_DROP;
>>  
>> -- 
>> 2.34.1
>>

Got it, I've sent a v3 patch.
