Return-Path: <SRS0=JlPR=VE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9B0C0650E
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jul 2019 10:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD3272070D
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jul 2019 10:13:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="OeNOwE6L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfGGKNv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Jul 2019 06:13:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39012 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbfGGKNv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jul 2019 06:13:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so13588606wma.4
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Jul 2019 03:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TMGrYoCKbz9Eq4MPF1hFS5D+cdg65WHk7TtzBcNDAnk=;
        b=OeNOwE6LPLyelBtShMPRHIvJf7b7BCkt3Q18OXI0lNznYSMw/yUr1zoB1V2rfUm6jW
         2GBLmtvfhwqpWPV6omTMvAsTkVxOlfc8ItFI9pg3OAlRkQemhoCqvuU4SI3FJG+elOir
         bor+u81qw7sTolmI243LOaMJFj7Y1/nHQ3XhM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TMGrYoCKbz9Eq4MPF1hFS5D+cdg65WHk7TtzBcNDAnk=;
        b=Uc1PMxLD/ZR10xUG2SKhX9G/VjaQrPfUyKmVIEy3Dsz9ZvHLtkfT5xAbKn7DYA1MNN
         OFH3ohaY+ZR3Oo+cjD2rPKdNy5rqPw4hv5ffvJV2UBweBD5BVT3Zi0hWpB3WneWTnJ6c
         kwww7Aiwb0umZ9ubMfu3U8V1DSnG1Qued5XF1rA1vkU1/L4q2cZLMcu6828OsRMPTTKG
         DvdvItPPekGnYxPplktYQ/A4FHtmQThjVuauYeU89OqR/Y/YWv46rG/Aa5f7Ez1KNevw
         czwCDkJuOm17Xi6/TizARXa9oAuZBsk0uqaoWq3vUegUwyaNrWrvi8PuVwkv9jOREGoV
         dVGQ==
X-Gm-Message-State: APjAAAWaMUU5ux4KT72wt3PpPqkTH5bfuf4AL+j1dUbUEojapZ8XwD5X
        wEY0tUHdcNtUC8KruIESvYIBlA==
X-Google-Smtp-Source: APXvYqwR/wSBji61obO3cLaYNGMn1Lf6epXv+id4187lj056CznbRq1+IQgQPjXpbXCPoCFyVzcXQQ==
X-Received: by 2002:a1c:a101:: with SMTP id k1mr12236107wme.98.1562494429663;
        Sun, 07 Jul 2019 03:13:49 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id r16sm38340729wrr.42.2019.07.07.03.13.48
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Jul 2019 03:13:48 -0700 (PDT)
Subject: Re: [PATCH nf-next v2] netfilter:nft_meta: add NFT_META_VLAN support
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     wenxu <wenxu@ucloud.cn>, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <1562332598-17415-1-git-send-email-wenxu@ucloud.cn>
 <1562332598-17415-7-git-send-email-wenxu@ucloud.cn>
 <caaaa242-6bb8-9d5e-af66-a0cd6592f81d@cumulusnetworks.com>
 <83e9506d-8888-f841-f16c-0d038e52b39e@ucloud.cn>
 <fd7c6e20-8ecb-b125-fe34-0ee224db300a@cumulusnetworks.com>
Message-ID: <43dc9579-0d39-ca7b-a602-bfe0142478b8@cumulusnetworks.com>
Date:   Sun, 7 Jul 2019 13:13:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <fd7c6e20-8ecb-b125-fe34-0ee224db300a@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 07/07/2019 13:12, Nikolay Aleksandrov wrote:
> On 06/07/2019 17:29, wenxu wrote:
>>
>> 在 2019/7/6 20:02, Nikolay Aleksandrov 写道:
>>> On 05/07/2019 16:16, wenxu@ucloud.cn wrote:
>>>> From: wenxu <wenxu@ucloud.cn>
>>>>
>>>> This patch provide a meta vlan to set the vlan tag of the packet.
>>>>
>>>> for q-in-q outer vlan id 20:
>>>> meta vlan set 0x88a8:20
>>>>
>>>> set the default 0x8100 vlan type with vlan id 20
>>>> meta vlan set 20
>>>>
>>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>>>> ---
>>>>  include/net/netfilter/nft_meta.h         |  5 ++++-
>>>>  include/uapi/linux/netfilter/nf_tables.h |  4 ++++
>>>>  net/netfilter/nft_meta.c                 | 25 +++++++++++++++++++++++++
>>>>  3 files changed, 33 insertions(+), 1 deletion(-)
>>>>
>>> The patch looks fine, just a note: you'll only be able to work with the
>>> outer tag, so guessing to achieve a double-tagged frame you'll have to
>>> add another NFT_META_VLAN_INNER(?) and will have to organize them one
>>> after another.
>>
>> yes, It's just set/mangle the meta vlan data. 
>> I think it's a good idear for stacked tagged with NFT_META_VLAN_INNER, in 
>> this case it should check the the proto of vlan tag already on packet
>> There are three case:
>> 1. packet already contain a vlan header with proto 0x88a8, it should push the inner vlan tag
>> 2. there is no outer vlan tag, maybe we should add a inner 0x8100 tag 
>> and outer 0x88a8 tag?
>> 3.  packet already contain a vlan tag with proto 0x8100, push the vlan tag and add outer 0x88a8 tag ?
>>
> 
> I'm more inclined to make it simpler, i.e. always push inner vlan. That way you can arrange them
> anyway you like, also skb_vlan_push() already takes care of all that. It'll push the vlan
> if hwaccel is present or make it hwaccel if it isn't.
> 
> In fact I'd suggest using skb_vlan_push(), so you don't need another NFT_META_VLAN_INNER,
> this one can be re-used. If you chain 2 of these you'll get properly double-tagged frame.
> 

You just need to be careful because skb_vlan_push expects skb->data to be at the mac header.

