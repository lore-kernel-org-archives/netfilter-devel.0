Return-Path: <SRS0=JlPR=VE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E04C0650E
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jul 2019 10:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59FD820665
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jul 2019 10:12:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="HIO7PwHs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbfGGKMZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Jul 2019 06:12:25 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32866 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbfGGKMZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jul 2019 06:12:25 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so14016371wru.0
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Jul 2019 03:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LOCM9N+5MmfK5FJsolawWZZfnzR75zQk/QMk266rPmA=;
        b=HIO7PwHsWw5Ee6t7kW3ovpevngTIqiAhTwT6rR4zXRw0P0+kRax1VO3IdlcPL1030M
         5lMJ5H5Jlh4B/AZXZLqISrCBSJstmBHpBsugV+WxyvomZV8/cJJBQ8J8cNNf3+8SH8wy
         gR4yud1ADG/9phGjZ4OFgsjU0RM+xqZJbnESY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LOCM9N+5MmfK5FJsolawWZZfnzR75zQk/QMk266rPmA=;
        b=mHLZJ1nwCq73HoAkgdDbFRLLmjJPspTOsmJyyRmf9tPh/Kcw5gm5p/EhT1/X+fxgT4
         vBJrhGLIeeRqfLDFrq/KS1FUIlnDnhPvBxJJMG04a66JccJ1gtqqT2lUGY/wisgkW0my
         ljukIMmoN6IQNqcUWWy+kWGzOQq+8nPSMQSJ7DFL6nOKfM8cM6iky4vyK9JVGAwhhR1c
         0Q2NOsiyU652E0gCEE+l7y5pHNVM92+juhzdIpYoQiHbUYXRIEDKPAQIniqbzy1oS47u
         BwcKbjRyIsOYMxcu3yXJrVxEGWtYYGoXdY2MuRvM6mfH1lLJSzjLjSD4zEti+r5jEwWc
         +etg==
X-Gm-Message-State: APjAAAWuVDfHFk7rycMLRg5p+VuDHiwm77c9sdXHXEw21kHv1t6C9ZvJ
        /BTP2eDRo28/umv/37B2Q6didg==
X-Google-Smtp-Source: APXvYqya3aETF32GkNwwtkwFF68WRmUxpC3+zv08fmiAr0yRVhpSc3xqOHk4nqR1TXa/fCQZUWmUjg==
X-Received: by 2002:adf:eb51:: with SMTP id u17mr12770345wrn.257.1562494343153;
        Sun, 07 Jul 2019 03:12:23 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id g19sm13791576wrb.52.2019.07.07.03.12.21
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Jul 2019 03:12:22 -0700 (PDT)
Subject: Re: [PATCH nf-next v2] netfilter:nft_meta: add NFT_META_VLAN support
To:     wenxu <wenxu@ucloud.cn>, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <1562332598-17415-1-git-send-email-wenxu@ucloud.cn>
 <1562332598-17415-7-git-send-email-wenxu@ucloud.cn>
 <caaaa242-6bb8-9d5e-af66-a0cd6592f81d@cumulusnetworks.com>
 <83e9506d-8888-f841-f16c-0d038e52b39e@ucloud.cn>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <fd7c6e20-8ecb-b125-fe34-0ee224db300a@cumulusnetworks.com>
Date:   Sun, 7 Jul 2019 13:12:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <83e9506d-8888-f841-f16c-0d038e52b39e@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 06/07/2019 17:29, wenxu wrote:
> 
> 在 2019/7/6 20:02, Nikolay Aleksandrov 写道:
>> On 05/07/2019 16:16, wenxu@ucloud.cn wrote:
>>> From: wenxu <wenxu@ucloud.cn>
>>>
>>> This patch provide a meta vlan to set the vlan tag of the packet.
>>>
>>> for q-in-q outer vlan id 20:
>>> meta vlan set 0x88a8:20
>>>
>>> set the default 0x8100 vlan type with vlan id 20
>>> meta vlan set 20
>>>
>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>>> ---
>>>  include/net/netfilter/nft_meta.h         |  5 ++++-
>>>  include/uapi/linux/netfilter/nf_tables.h |  4 ++++
>>>  net/netfilter/nft_meta.c                 | 25 +++++++++++++++++++++++++
>>>  3 files changed, 33 insertions(+), 1 deletion(-)
>>>
>> The patch looks fine, just a note: you'll only be able to work with the
>> outer tag, so guessing to achieve a double-tagged frame you'll have to
>> add another NFT_META_VLAN_INNER(?) and will have to organize them one
>> after another.
> 
> yes, It's just set/mangle the meta vlan data. 
> I think it's a good idear for stacked tagged with NFT_META_VLAN_INNER, in 
> this case it should check the the proto of vlan tag already on packet
> There are three case:
> 1. packet already contain a vlan header with proto 0x88a8, it should push the inner vlan tag
> 2. there is no outer vlan tag, maybe we should add a inner 0x8100 tag 
> and outer 0x88a8 tag?
> 3.  packet already contain a vlan tag with proto 0x8100, push the vlan tag and add outer 0x88a8 tag ?
> 

I'm more inclined to make it simpler, i.e. always push inner vlan. That way you can arrange them
anyway you like, also skb_vlan_push() already takes care of all that. It'll push the vlan
if hwaccel is present or make it hwaccel if it isn't.

In fact I'd suggest using skb_vlan_push(), so you don't need another NFT_META_VLAN_INNER,
this one can be re-used. If you chain 2 of these you'll get properly double-tagged frame.



