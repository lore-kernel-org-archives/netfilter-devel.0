Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630CAC43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 04:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D5582084D
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 04:10:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TbSDaXDq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbfBYEKv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Feb 2019 23:10:51 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39527 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728434AbfBYEKv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Feb 2019 23:10:51 -0500
Received: by mail-pl1-f196.google.com with SMTP id b65so814699plb.6
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Feb 2019 20:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0Z86nBH0vT5F3Fy4eA2TqyjG1bWoyZXiBKRu4VLLmyA=;
        b=TbSDaXDqdTvf1QuOFBVZg1I2cP2Kr0sTmGlG73UuHkoWpGichuo+oJCRjpN5ifGw7+
         WbpxYHLzPpzUvNO7GMXr57fCeZ2iSUMYadg5WWRUv2IX0DpAjnY0iS0MZFGVZYsE6jqm
         ZDoipaHe5PRq/CyYVvq1C7BVzKmARU43fGlYVFnb7gCzHoAZzbYQd4d51Lr/0d6VGZDY
         1ek2OVCVk7EyjCtlZVORtUbYdsBD2VBXwTvNdgqIMblpFtcu75xlrZVED3i3D0GB/0KB
         EzDHNCYKLlDGZW1zzSEnBAOmmbuvXB+QUBgNphv3i4aHZT8JZsPz2dEkL8tRHCnsRFem
         0l5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Z86nBH0vT5F3Fy4eA2TqyjG1bWoyZXiBKRu4VLLmyA=;
        b=lW+eU7P0yH/u9bi4Y5jMiOOvool/ZlUmb9gwTd0CWXS+8435LF/wp2+rxxYOYeuN0J
         RYKYZdHPbp+8FKj9Z0dMGQKzAQNUu600zS3U9r7DM9Yan64T07nKFbasxc8S0JliKnoA
         lVT8IEw2hhxGosnV+EWTV9pZrlQRVTT0YTj64GMnmPw39s74Wqt7VCzIs7TEtNepF1KZ
         PrfVBOd24NNMRMX4I/zMLU7aU7+yNuUpTkRnrHu1h68B9YzFn/kYtOLOTYOKhPPRvqRc
         zQ2Z4jSaBnj0m6O/X0YaMLRtDZnrWBa6/rl1tyHqdJcc14HNYppOCrFTREd6uqQYLkcI
         +knw==
X-Gm-Message-State: AHQUAuZBeGxA0R5x840gSLCZup0Pn6Q4f2aR4yXF+FdBSpttiWyRwRod
        Q8h1vEAXDWOyGeqDrh8nc/t9ZzzW
X-Google-Smtp-Source: AHgI3IbnUt9UibieJFpkV2L1PtEJQK5oKJKJ23XFWsicEp0MjHE08YVLlKVHcehhDbrgMxFm6sf0Qg==
X-Received: by 2002:a17:902:b101:: with SMTP id q1mr18400213plr.296.1551067850605;
        Sun, 24 Feb 2019 20:10:50 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id n1sm19131922pfi.123.2019.02.24.20.10.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 20:10:49 -0800 (PST)
Subject: =?UTF-8?Q?Re:_=e7=ad=94=e5=a4=8d:_[PATCH]_netfilter:_force_access_o?=
 =?UTF-8?Q?f_RCU_protected_data_in_nft=5fupdate=5fchain=5fstats?=
To:     "Li,Rongqing" <lirongqing@baidu.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <1551059920-14120-1-git-send-email-lirongqing@baidu.com>
 <4818220f-1c66-df00-e397-4efbeba82665@gmail.com>
 <b8ca2a794fdf4406a52ee4ecb78ef54b@baidu.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <cc982bdc-3639-490d-36a7-df32316313e2@gmail.com>
Date:   Sun, 24 Feb 2019 20:10:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <b8ca2a794fdf4406a52ee4ecb78ef54b@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 02/24/2019 08:03 PM, Li,Rongqing wrote:
> 
> 
>> -----邮件原件-----
>> 发件人: Eric Dumazet [mailto:eric.dumazet@gmail.com]
>> 发送时间: 2019年2月25日 11:50
>> 收件人: Li,Rongqing <lirongqing@baidu.com>; netfilter-devel@vger.kernel.org
>> 主题: Re: [PATCH] netfilter: force access of RCU protected data in
>> nft_update_chain_stats
>>
>>
>>
>> On 02/24/2019 05:58 PM, Li RongQing wrote:
>>> basechain->stats is rcu protected data, cannot assure that
>>> twice accesses have the same result, so dereference it once.
>>>
>>> basechain->stats is allocated by percpu allocater, if it is not NULL,
>>> its percpu variable does not need to be checked with NULL
>>>
>>> Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
>>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>>> ---
>>>  net/netfilter/nf_tables_core.c | 18 +++++++++---------
>>>  1 file changed, 9 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/net/netfilter/nf_tables_core.c
>>> b/net/netfilter/nf_tables_core.c index 2a00aef7b6d4..9be622c76a62
>>> 100644
>>> --- a/net/netfilter/nf_tables_core.c
>>> +++ b/net/netfilter/nf_tables_core.c
>>> @@ -98,20 +98,20 @@ static noinline void nft_update_chain_stats(const
>> struct nft_chain *chain,
>>>  					    const struct nft_pktinfo *pkt)  {
>>>  	struct nft_base_chain *base_chain;
>>> -	struct nft_stats *stats;
>>> +	struct nft_stats *stats, *pstat;
>>>
>>>  	base_chain = nft_base_chain(chain);
>>> -	if (!rcu_access_pointer(base_chain->stats))
>>> +
>>> +	stats = rcu_dereference(base_chain->stats);
>>
>> This looks bogus to me.
>>
>> Where is the needed rcu_read_lock() before rcu_dereference() ?
>>
> 
> Ok, I will check it carefully.
> 
>> This rcu_access_pointer() test is fine, and avoids a
>> local_bh_disable()/local_bh_enable()
>> if they are not needed.
> 
> 
> 
> But it can not assure that rcu_dereference(base_chain->stats) returns NULL since nft_chain_stats_replace, should we check it again, other than check the returning of this_cpu_ptr?
> 

Sorry I do not understand your concern.

