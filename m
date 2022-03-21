Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5220FC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Mar 2022 05:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344253AbiCUFNr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241614AbiCUFNq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Mar 2022 01:13:46 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3894B7C78
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Mar 2022 22:12:21 -0700 (PDT)
Message-ID: <0b0a6290-4da5-8a52-1454-2dab60300adb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1647839539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tAW0fo1M0Vz9eVkZ6ituE3MaAmI4p5Imf1+Gcu8Lqko=;
        b=Z7hOf6/vDkUgg8ehC4xJjzRCi7z0xL938yb0+fTbxovlYNOnBXlt96y+RbeBZ6MndRRWzx
        g17E6/YaPUuPeyvSz1H0zhTRB4Ovw++wvphCiUrUPMCOC957gazJXGNmDq6lPaeER1mQPo
        JF12wD7j+IEsalPHEThPVKZ3LbGskQ4=
Date:   Mon, 21 Mar 2022 08:12:18 +0300
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vasily Averin <vasily.averin@linux.dev>
Subject: Re: [PATCH RFC] memcg: Enable accounting for nft objects
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>
Cc:     kernel@openvz.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
References: <81d734aa-7a0f-81b4-34fb-516b17673eac@virtuozzo.com>
 <20220228122429.GC26547@breakpoint.cc>
In-Reply-To: <20220228122429.GC26547@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 2/28/22 15:24, Florian Westphal wrote:
> Vasily Averin <vvs@virtuozzo.com> wrote:
>> nftables replaces iptables but still lacks memcg accounting.

>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> index 5fa16990da95..5e1987ec9715 100644
>> --- a/net/netfilter/nf_tables_api.c
>> +++ b/net/netfilter/nf_tables_api.c
>> @@ -149,7 +149,7 @@ static struct nft_trans *nft_trans_alloc_gfp(const struct nft_ctx *ctx,
>>   {
>>   	struct nft_trans *trans;
>> -	trans = kzalloc(sizeof(struct nft_trans) + size, gfp);
>> +	trans = kzalloc(sizeof(struct nft_trans) + size, gfp | __GFP_ACCOUNT);
> 
> trans_alloc is temporary in nature, they are always free'd by the
> time syscall returns (else, bug).

dropped this hunk in v2

>> @@ -1084,6 +1084,7 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
>>   	struct nft_table *table;
>>   	struct nft_ctx ctx;
>>   	u32 flags = 0;
>> +	gfp_t gfp = GFP_KERNEL_ACCOUNT;
>>   	int err;
>>   	lockdep_assert_held(&nft_net->commit_mutex);
>> @@ -1113,16 +1114,16 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
>>   	}
>>   	err = -ENOMEM;
>> -	table = kzalloc(sizeof(*table), GFP_KERNEL);
>> +	table = kzalloc(sizeof(*table), gfp);
> 
> Why gfp temporary variable?  Readability? The subsititution looks correct.

Out of habit.
Some lines with GFP_KERNEL -> GFP_KERNEL_ACCOUNT changes exceeded 80 symbols,but it isn't required now. I've replaced it in v2.

Thank you,
	Vasily Averin

