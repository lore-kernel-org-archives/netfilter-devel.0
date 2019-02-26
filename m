Return-Path: <SRS0=SqQQ=RB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD0BC43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 03:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E1B6217F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 03:16:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ONoeNW8t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbfBZDQv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 22:16:51 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46303 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfBZDQv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 22:16:51 -0500
Received: by mail-pl1-f193.google.com with SMTP id c17so2322781plz.13
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Feb 2019 19:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=M7NIyFJgXm+UsQrdyQGWYL6+bKyCADG4P46auJiB4DI=;
        b=ONoeNW8tAzMC6BFI532iJP4mwttZkdq3dfg4ZhczGVHWpfr2pVQmEHWhjGKavxl140
         QhD4ZdRrULii369iMhsXriEc75Q61fbU/bIgYhCxlFAg4l++xTGt5Lun2jYNt2W/JPTC
         YyvN/ggZ8PwCNLcFxEoNsOXvlMt5UVtlwrc2UHrlD5e+hBydcKeUZwlgG2hurucYdx4c
         L3kSXvqCSWvr/+rx35orn8aPmwy+kTNx30j5HN5cO4Ff7b2dys8AoqAaI218ocEEtS5p
         7d4lWQ9BYSvvPBtOBDeTjlnnVd+1fNxW+zPtmx3mqBVRPhisXnL42QgmyhIr+1DqUNwL
         1oPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M7NIyFJgXm+UsQrdyQGWYL6+bKyCADG4P46auJiB4DI=;
        b=tfnr3k90DbpzvOEgJ9ZAk5nnUzF9UjtyPrjzd3mKNMmMddLn0gWTsNJ/IgcDfTo+nl
         MMWW7CWgE8KN58YnlUpJl2O3xLBGopwi7lM8yvgKy5fQDi4lo2+ERe0uywm/Ql9iq1Zv
         uVLqq2NKmWvvYq9AB3D80hT0axz66u2J/6JFdwRWl5sNDX2RL4S/lpnt7epmtd8D7gih
         l6ehVE3AN9mFKyGWeXTx4u7z4ZS4tC/NNbL4Z8Hdd+0OptIQPbaR8fXBC6KPAR45asZ6
         GB+EXUKV8ncsDXDQYHfUyND9zlgLpNNzzXDKaHWgIiFuUwV0a5oJc5p4TlFRPc+vNFA1
         g2UQ==
X-Gm-Message-State: AHQUAuZdD5u8Z8b3JBnP8JlmtSm2i4HHjWwHubY4rpj4BB2yCQXdXPPi
        mFAKEt/0kvEKQs80sj3Xl4Oz6IHi
X-Google-Smtp-Source: AHgI3IY5Q0Dcayk24lAGBcXSv4O17+n2MDuiTOe69qMYX2MGhj+sUbojzLJdFCnD9JXXRF9h8QbtXA==
X-Received: by 2002:a17:902:9a4a:: with SMTP id x10mr23018179plv.93.1551151009818;
        Mon, 25 Feb 2019 19:16:49 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id i13sm10705695pfo.106.2019.02.25.19.16.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 19:16:48 -0800 (PST)
Subject: =?UTF-8?B?UmU6IOetlOWkjTog562U5aSNOiDnrZTlpI06IFtQQVRDSF0gbmV0Zmls?=
 =?UTF-8?Q?ter:_force_access_of_RCU_protected_data_in_nft=5fupdate=5fchain?=
 =?UTF-8?Q?=5fstats?=
To:     "Li,Rongqing" <lirongqing@baidu.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <1551059920-14120-1-git-send-email-lirongqing@baidu.com>
 <4818220f-1c66-df00-e397-4efbeba82665@gmail.com>
 <b8ca2a794fdf4406a52ee4ecb78ef54b@baidu.com>
 <cc982bdc-3639-490d-36a7-df32316313e2@gmail.com>
 <3614110dd296453db887938bb07f3aa6@baidu.com>
 <071a3554-442b-59cd-74ff-7bbc21c7a9e1@gmail.com>
 <b2dc0099c04949e2b07eabe2ce084b8d@baidu.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <dab7a168-984e-4e58-573d-5f95ed102846@gmail.com>
Date:   Mon, 25 Feb 2019 19:16:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <b2dc0099c04949e2b07eabe2ce084b8d@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 02/25/2019 06:53 PM, Li,Rongqing wrote:
> 
> 
>> -----邮件原件-----
>> 发件人: Eric Dumazet [mailto:eric.dumazet@gmail.com]
>> 发送时间: 2019年2月25日 23:56
>> 收件人: Li,Rongqing <lirongqing@baidu.com>; netfilter-devel@vger.kernel.org
>> 主题: Re: 答复: 答复: [PATCH] netfilter: force access of RCU protected data in
>> nft_update_chain_stats
>>
>>
>>
>> On 02/24/2019 10:00 PM, Li,Rongqing wrote:
>>>
>>>
>>>> -----邮件原件-----
>>>> 发件人: Eric Dumazet [mailto:eric.dumazet@gmail.com]
>>>> 发送时间: 2019年2月25日 12:11
>>>> 收件人: Li,Rongqing <lirongqing@baidu.com>;
>>>> netfilter-devel@vger.kernel.org
>>>> 主题: Re: 答复: [PATCH] netfilter: force access of RCU protected data in
>>>> nft_update_chain_stats
>>>>
>>>>
>>>>
>>>> On 02/24/2019 08:03 PM, Li,Rongqing wrote:
>>>>>
>>>>>
>>>>>> -----邮件原件-----
>>>>>> 发件人: Eric Dumazet [mailto:eric.dumazet@gmail.com]
>>>>>> 发送时间: 2019年2月25日 11:50
>>>>>> 收件人: Li,Rongqing <lirongqing@baidu.com>;
>>>>>> netfilter-devel@vger.kernel.org
>>>>>> 主题: Re: [PATCH] netfilter: force access of RCU protected data in
>>>>>> nft_update_chain_stats
>>>>>>
>>>>>>
>>>>>>
>>>
>>>
>>>     [RFC] netfilter: check the result of dereferencing
>>> base_chain->stats
>>>
>>>     check the result of dereferencing base_chain->stats, instead of
>>>     result of this_cpu_ptr
>>>
>>>     base_chain->stats maybe change to NULL when a chain is updated,
>>>     a NULL counter can be attached
>>>
>>>     and we do not need to check returning of this_cpu_ptr since
>>>     base_chain->stats is allocated by percpu allocator if it is
>>>     non-NULL, this_cpu_ptr returns a valid value
>>>
>>> diff --git a/net/netfilter/nf_tables_core.c
>>> b/net/netfilter/nf_tables_core.c index 2a00aef7b6d4..ed8a382d1012
>>> 100644
>>> --- a/net/netfilter/nf_tables_core.c
>>> +++ b/net/netfilter/nf_tables_core.c
>>> @@ -98,15 +98,16 @@ static noinline void nft_update_chain_stats(const
>> struct nft_chain *chain,
>>>                                             const struct
>> nft_pktinfo
>>> *pkt)  {
>>>         struct nft_base_chain *base_chain;
>>> -       struct nft_stats *stats;
>>> +       struct nft_stats *stats, *pstats;
>>
>> OK but then make sure to add proper sparse annotations  ( aka __percpu )
>>
> 
> I test this and found , there is always sparse error whether add __percpu or not
> 
> Like: 
> struct nft_stats __percpu *pstats;


> 
> pstats = rcu_dereference(base_chain->stats);



I would suggest :

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 2a00aef7b6d4aaabfc538f24b0c36b50f76ce2b4..c29a8ce2c6bcdd683400f0b03dcc0c4440ab8fc8 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -98,21 +98,22 @@ static noinline void nft_update_chain_stats(const struct nft_chain *chain,
                                            const struct nft_pktinfo *pkt)
 {
        struct nft_base_chain *base_chain;
+       struct nft_stats __percpu *pstats;
        struct nft_stats *stats;
 
        base_chain = nft_base_chain(chain);
-       if (!rcu_access_pointer(base_chain->stats))
-               return;
-
-       local_bh_disable();
-       stats = this_cpu_ptr(rcu_dereference(base_chain->stats));
-       if (stats) {
+       rcu_read_lock();
+       pstats = READ_ONCE(base_chain->stats);
+       if (pstats) {
+               local_bh_disable();
+               stats = this_cpu_ptr(pstats);
                u64_stats_update_begin(&stats->syncp);
                stats->pkts++;
                stats->bytes += pkt->skb->len;
                u64_stats_update_end(&stats->syncp);
+               local_bh_enable();
        }
-       local_bh_enable();
+       rcu_read_unlock();
 }
 
 struct nft_jumpstack {

