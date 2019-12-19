Return-Path: <SRS0=pcvh=2J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D08C43603
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 16:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98BF024650
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 16:47:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gDlzgYQ7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfLSQrB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 11:47:01 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35226 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbfLSQrB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 11:47:01 -0500
Received: by mail-qk1-f196.google.com with SMTP id z76so5534864qka.2
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Dec 2019 08:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UK44fxGyHqJQBh6m2DQQaQGEBMPkdn2Q5wOvBoXCsEU=;
        b=gDlzgYQ7ffGFPSDFK1inkSRJbMeVqrxg/kV+AF2giJhNQPlVcRkExBun6aJRYqrfJU
         QBQ4i3YPa4VV/sqTr6F8ZUXUXa5nadxtJvv/9PFvzRjuOOFIKHmA2EqCUCzAUqCLobOh
         u1TSYzWH6fgdwyLItYcP2CJBzVfpmJGts3kVZm8Q2ADoIq4KeAZt52n0fERoLxmCzWcv
         tjzIYfoiZI2O6d1jZBS/XTHz/QsLWJwCz029l9sxm2++ZiPl5whcYjrAno2LsS4i40XT
         fB8n9b81k0RrqkhbhbBMFL+pQK65Bbq9NHheihcuSzXjlerxgvxU453N//BuaknWIHN/
         HTSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UK44fxGyHqJQBh6m2DQQaQGEBMPkdn2Q5wOvBoXCsEU=;
        b=bLid5sijkNfu88Ji5eg6GqcHlVJLDZ7w5zBxyP335lz2gZhw9jl2fxINzEHGnfGM9f
         1SmjzC1wp3MIooyQvM7L8cU51K7U3ZgE8cAJW/U3Ae/RjKZoXt6d9WUdBmprFO69i7H8
         lRWgy/PB59xvLFzUtAqeWjo6saeJNtheRGmCMnGlxnhJm8e/HfKTOP/hLeiUCnhW/JG4
         Q5LyFXe9mprGkDGcF2WSRiEfSdap+tWOEUFohKnG7YRhgG0oz6H1sPyCnpoLYee4+7y6
         HBWlViFVrL1SDMswPrN0z0Y2y68S01QDxe9JtI0GXlK2APS+yRdQxcAp0AUmd1JrKL/7
         PBQw==
X-Gm-Message-State: APjAAAXJFDzBrd+dDzmuevWq9ymn2it6om7sI/eBfgNvDaevVLLZm9Du
        r/6h9oXhiMbXyOmCoUF1ogYeVyrhDwc=
X-Google-Smtp-Source: APXvYqz8rBtK/tR/iXE2AShGe1/czoCahrHJxBtzIB9ZSOVj05jI9VNOIDm5dbZEDlNB0+SYtRTpTQ==
X-Received: by 2002:a37:ad17:: with SMTP id f23mr8988371qkm.24.1576774020243;
        Thu, 19 Dec 2019 08:47:00 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:1121:dee9:5145:4f54? ([2601:282:800:fd80:1121:dee9:5145:4f54])
        by smtp.googlemail.com with ESMTPSA id x6sm1860640qkh.20.2019.12.19.08.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2019 08:46:59 -0800 (PST)
Subject: Re: [PATCH nf-next 9/9] netfilter: nft_meta: add support for slave
 device ifindex matching
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     Martin Willi <martin@strongswan.org>,
        David Ahern <dsahern@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Benjamin Poirier <bpoirier@cumulusnetworks.com>
References: <20191218110521.14048-1-fw@strlen.de>
 <20191218110521.14048-10-fw@strlen.de>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ce5758ce-7541-3b6b-d61c-ae59219ef898@gmail.com>
Date:   Thu, 19 Dec 2019 09:46:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191218110521.14048-10-fw@strlen.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 12/18/19 4:05 AM, Florian Westphal wrote:
> Allow to match on vrf slave ifindex or name.
> 
> In case there was no slave interface involved, store 0 in the
> destination register just like existing iif/oif matching.
> 
> sdif(name) is restricted to the ipv4/ipv6 input and forward hooks,
> as it depends on ip(6) stack parsing/storing info in skb->cb[].
> 
> Cc: Martin Willi <martin@strongswan.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Shrijeet Mukherjee <shrijeet@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  4 ++
>  net/netfilter/nft_meta.c                 | 76 +++++++++++++++++++++---
>  2 files changed, 73 insertions(+), 7 deletions(-)
> 

do you have an example that you can share?
