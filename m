Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A3EC43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 15:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B52F20684
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 15:56:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VotUtxNd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbfBYP4A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 10:56:00 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:34760 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbfBYPz7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 10:55:59 -0500
Received: by mail-yw1-f66.google.com with SMTP id u205so3842268ywe.1
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Feb 2019 07:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=JuHzxIzA4nno7qZ8p5YjSNnIR1+HjLxz1iwSU0b00FQ=;
        b=VotUtxNdPkuvhkwT9EwlnM9hNY8XWBzMUvH2Aqqg26BqCGVsyNHu+ZMStw2dVd+F9S
         Uyh5dIF8d7pfHrkQYAgH6ZYZ+xJ30yFLzsDY1LkufyQPoik3lfj6jQMA+A/eyYSPe/u+
         rGwTcok2AlbJgafQ/twr28jEjTFSCZYvMNyZEJA71YYmitkIXVVjCQk8gd/Qv0fBnKYe
         NX9w6bgXRj0YLfZkgCOKSBlLkj/qliW9kpN2A4Vq6x8nep0IQjk56hlisNGLP6su4Y5c
         JIHAGbtxuidNj4Wj37bJRAFHxtgZfEbp0D0NJoLtvkJTFio8T3rwwVZuHqUszeb90Oa1
         aySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JuHzxIzA4nno7qZ8p5YjSNnIR1+HjLxz1iwSU0b00FQ=;
        b=lKyRjz25witoYmhafxM9UPmfliesyvmdqlxNPUQAC00gF0zMAJs0ci8nZg4K18StdN
         j6Xy73NQ++k21IkPNBCNr27M7uBWaEi2+F6o2dcrq7+9eXJ1sZgO/eu3u5sHBxU29+SU
         6vxGfDCcmnTqdz6eldFEJJBPEzaNbrUtSoXj+wTVNhM7fHBpz9bVju9s+NRMU73/4oIn
         1pNsjpBHA0mEl5SpqquqS1ifYGwtmmdMHg5G4NO4+up5qM/evkFFUfAMnPTz4aiEerp9
         93KY5mq4SL7PQi5aFRNg6cVGda/bCqnYltIWtgjarMpNlfZbXFKeLzUMBQu/k+h1ve0W
         LJQQ==
X-Gm-Message-State: AHQUAuYoogDzhoA3tMAN1GSIoEOE+seXMHeVMkb4MBc2aFSpYHzM2j/y
        PPyO21chiZRzctU0eOCRZCnqX96I
X-Google-Smtp-Source: AHgI3IaACA2QgaeNiNpOpxQvajyKyDEg20iGySBH5ZhrLkLb5CQOyN5Aopj/W3lyfFn28iu5BHLemA==
X-Received: by 2002:a81:3a0b:: with SMTP id h11mr3569856ywa.325.1551110158588;
        Mon, 25 Feb 2019 07:55:58 -0800 (PST)
Received: from [192.168.88.60] (216.sub-166-144-35.myvzw.com. [166.144.35.216])
        by smtp.gmail.com with ESMTPSA id y204sm3512429ywg.66.2019.02.25.07.55.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 07:55:57 -0800 (PST)
Subject: =?UTF-8?B?UmU6IOetlOWkjTog562U5aSNOiBbUEFUQ0hdIG5ldGZpbHRlcjogZm9y?=
 =?UTF-8?Q?ce_access_of_RCU_protected_data_in_nft=5fupdate=5fchain=5fstats?=
To:     "Li,Rongqing" <lirongqing@baidu.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <1551059920-14120-1-git-send-email-lirongqing@baidu.com>
 <4818220f-1c66-df00-e397-4efbeba82665@gmail.com>
 <b8ca2a794fdf4406a52ee4ecb78ef54b@baidu.com>
 <cc982bdc-3639-490d-36a7-df32316313e2@gmail.com>
 <3614110dd296453db887938bb07f3aa6@baidu.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <071a3554-442b-59cd-74ff-7bbc21c7a9e1@gmail.com>
Date:   Mon, 25 Feb 2019 07:55:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <3614110dd296453db887938bb07f3aa6@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 02/24/2019 10:00 PM, Li,Rongqing wrote:
> 
> 
>> -----邮件原件-----
>> 发件人: Eric Dumazet [mailto:eric.dumazet@gmail.com]
>> 发送时间: 2019年2月25日 12:11
>> 收件人: Li,Rongqing <lirongqing@baidu.com>; netfilter-devel@vger.kernel.org
>> 主题: Re: 答复: [PATCH] netfilter: force access of RCU protected data in
>> nft_update_chain_stats
>>
>>
>>
>> On 02/24/2019 08:03 PM, Li,Rongqing wrote:
>>>
>>>
>>>> -----邮件原件-----
>>>> 发件人: Eric Dumazet [mailto:eric.dumazet@gmail.com]
>>>> 发送时间: 2019年2月25日 11:50
>>>> 收件人: Li,Rongqing <lirongqing@baidu.com>;
>>>> netfilter-devel@vger.kernel.org
>>>> 主题: Re: [PATCH] netfilter: force access of RCU protected data in
>>>> nft_update_chain_stats
>>>>
>>>>
>>>>
>>>> On 02/24/2019 05:58 PM, Li RongQing wrote:
>>>>> basechain->stats is rcu protected data, cannot assure that
>>>>> twice accesses have the same result, so dereference it once.
>>>>>
>>>>> basechain->stats is allocated by percpu allocater, if it is not
>>>>> basechain->NULL,
>>>>> its percpu variable does not need to be checked with NULL
>>>>>
>>>>> Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
>>>>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>>>>> ---
>>>>>  net/netfilter/nf_tables_core.c | 18 +++++++++---------
>>>>>  1 file changed, 9 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/net/netfilter/nf_tables_core.c
>>>>> b/net/netfilter/nf_tables_core.c index 2a00aef7b6d4..9be622c76a62
>>>>> 100644
>>>>> --- a/net/netfilter/nf_tables_core.c
>>>>> +++ b/net/netfilter/nf_tables_core.c
>>>>> @@ -98,20 +98,20 @@ static noinline void
>>>>> nft_update_chain_stats(const
>>>> struct nft_chain *chain,
>>>>>  					    const struct nft_pktinfo *pkt)  {
>>>>>  	struct nft_base_chain *base_chain;
>>>>> -	struct nft_stats *stats;
>>>>> +	struct nft_stats *stats, *pstat;
>>>>>
>>>>>  	base_chain = nft_base_chain(chain);
>>>>> -	if (!rcu_access_pointer(base_chain->stats))
>>>>> +
>>>>> +	stats = rcu_dereference(base_chain->stats);
>>>>
>>>> This looks bogus to me.
>>>>
>>>> Where is the needed rcu_read_lock() before rcu_dereference() ?
>>>>
>>>
>>> Ok, I will check it carefully.
>>>
>>>> This rcu_access_pointer() test is fine, and avoids a
>>>> local_bh_disable()/local_bh_enable()
>>>> if they are not needed.
>>>
>>>
>>>
>>> But it can not assure that rcu_dereference(base_chain->stats) returns NULL
>> since nft_chain_stats_replace, should we check it again, other than check the
>> returning of this_cpu_ptr?
>>>
>>
>> Sorry I do not understand your concern.
> 
> 
>     [RFC] netfilter: check the result of dereferencing base_chain->stats
>     
>     check the result of dereferencing base_chain->stats, instead of
>     result of this_cpu_ptr
>     
>     base_chain->stats maybe change to NULL when a chain is updated,
>     a NULL counter can be attached
>     
>     and we do not need to check returning of this_cpu_ptr since
>     base_chain->stats is allocated by percpu allocator if it is
>     non-NULL, this_cpu_ptr returns a valid value
> 
> diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
> index 2a00aef7b6d4..ed8a382d1012 100644
> --- a/net/netfilter/nf_tables_core.c
> +++ b/net/netfilter/nf_tables_core.c
> @@ -98,15 +98,16 @@ static noinline void nft_update_chain_stats(const struct nft_chain *chain,
>                                             const struct nft_pktinfo *pkt)
>  {
>         struct nft_base_chain *base_chain;
> -       struct nft_stats *stats;
> +       struct nft_stats *stats, *pstats;

OK but then make sure to add proper sparse annotations  ( aka __percpu )

>  
>         base_chain = nft_base_chain(chain);
>         if (!rcu_access_pointer(base_chain->stats))
>                 return;
>  
>         local_bh_disable();
> -       stats = this_cpu_ptr(rcu_dereference(base_chain->stats));
> -       if (stats) {
> +       pstats = rcu_dereference(base_chain->stats);
> +       if (pstats) {

if (likely(pstats)) {

> +               stats = this_cpu_ptr(pstats);
>                 u64_stats_update_begin(&stats->syncp);
>                 stats->pkts++;
>                 stats->bytes += pkt->skb->len;
> 
