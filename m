Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A8CC282E3
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 13:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36F7B21530
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 13:57:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="O0gwBRLE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfE1N5n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 09:57:43 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35865 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727564AbfE1N5m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 09:57:42 -0400
Received: by mail-wr1-f66.google.com with SMTP id s17so20359696wru.3
        for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2019 06:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RDHAz/uNRTlAuvbMTky/K+5WAqU95asj2GuckNTPrPw=;
        b=O0gwBRLE2bvLTTBgVqV1t6bfn+gpJBngDtl+jkFjACXdyByR9CYsKsTs0CAlRupFvj
         nttTyi6t/YyF4vDKCPEl7IQ1zD6uJwNfcehXxhaYFqwVJ1q55KTyEO0gaZmYv34b9vfx
         Tr9f3h9ysbRZphO/W83Xmcj0upIXOHrd71r+dnEYtV75ZXTDhTh6zFIcfUNtW7yq2tUP
         BDdLGXTFKA8voqgPy0iFH6JhSU88eCV/xHpeP1bD7+LmJwClUBX3VkerJweI2gN+q8tp
         fctvEG/dur8IP3xU3bN4xo5Blz7SimoEz8Go0pIN1HFE8CSrxhz0f8pQVfr6wF+bw+Oq
         QAqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RDHAz/uNRTlAuvbMTky/K+5WAqU95asj2GuckNTPrPw=;
        b=CgKQeHjgNtdE6aKFNA8uHkjfMcd4qEBShbafqQoa9iTBESY2iMgVfGwysbNGlHRPkO
         m5eWCtF6jxUQlsGWll4+2mIWcUgbPlw6YybzyV/3NNN5Xpt/Z25cfD+bdasOPs+TeYO9
         zGHILOXN5sNfQOqLL4Bfdoj1gE2wEfJMRRSdvz/SLhYj9Mw5AZlQhQ6Zv7atyyBDm4Y0
         lCyIgKdq/LADVrwAWIJCAE5Gb3MwtQz/C95/HqYi17phHfobyISh/c/UKeN+j8UUHeg4
         qaBU4QKwLqcIbHV3MG+UZ6RakL8fv+TFJyEiLAFnUTYhvkU/qyl6ymZiO6VW7p4LUEb5
         WkPw==
X-Gm-Message-State: APjAAAXEnsIy+lo/kybyoiuP5jkPfoL434XO/Uof7Oth5XO/Nx8vXYBR
        iqP/h2tCWg7nY6InjLpVYdNvhAQhlbo=
X-Google-Smtp-Source: APXvYqzCRfQOGvbLesnlwSBxQtBXBVcya0Sa9gKp2gOr2HzpoKcdhNtfsct3zZ/Vfwq/Pxu7K+3PkA==
X-Received: by 2002:adf:c601:: with SMTP id n1mr73203219wrg.49.1559051859805;
        Tue, 28 May 2019 06:57:39 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:d562:72eb:4113:d5e7? ([2a01:e35:8b63:dc30:d562:72eb:4113:d5e7])
        by smtp.gmail.com with ESMTPSA id a124sm4034922wmh.3.2019.05.28.06.57.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 06:57:38 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] netfilter: ctnetlink: Resolve conntrack L3-protocol flush
 regression
To:     stable <stable@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
References: <20190503154007.32495-1-kristian.evensen@gmail.com>
 <20190505223229.3ujqpwmuefd3wh7b@salvia>
 <4ecbebbb-0a7f-6d45-c2c0-00dee746e573@6wind.com>
 <20190506131605.kapyns6gkyphbea2@salvia>
 <6dea0101-9267-ae20-d317-649f1f550089@6wind.com>
 <20190524092249.7gatc643noc27qzp@salvia>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <6ad87483-711a-f205-8986-2217dab828d0@6wind.com>
Date:   Tue, 28 May 2019 15:57:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524092249.7gatc643noc27qzp@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 24/05/2019 à 11:22, Pablo Neira Ayuso a écrit :
> On Mon, May 20, 2019 at 10:35:07AM +0200, Nicolas Dichtel wrote:
>> Le 06/05/2019 à 15:16, Pablo Neira Ayuso a écrit :
>>> On Mon, May 06, 2019 at 10:49:52AM +0200, Nicolas Dichtel wrote:
>> [snip]
>>>> Is it possible to queue this for stable?
>>>
>>> Sure, as soon as this hits Linus' tree.
>>>
>> FYI, it's now in Linus tree:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f8e608982022
> 
> Please, send an email requesting this to stable@vger.kernel.org and
> keep me on CC.
This is a request to backport the upstream commit f8e608982022 ("netfilter:
ctnetlink: Resolve conntrack L3-protocol flush regression") in stable trees.


Thank you,
Nicolas

> 
> I'll ACK it.
> 
> Thanks.
> 
