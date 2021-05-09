Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 565F5C433ED
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 May 2021 10:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 279386140A
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 May 2021 10:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhEIK7n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 May 2021 06:59:43 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:37829 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhEIK7m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 May 2021 06:59:42 -0400
Received: by mail-wm1-f52.google.com with SMTP id b11-20020a7bc24b0000b0290148da0694ffso9544867wmj.2
        for <netfilter-devel@vger.kernel.org>; Sun, 09 May 2021 03:58:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3vx8QD98qcAbIN5mo36nlXddea4MvDXncPH8KmrDiu4=;
        b=aXLr++VVOO7ZGFYL7Tofp3BYBQ1XiGMTJXKmVf5PTiFWJ2kLWl5G7kn+0acpmqAgCi
         il3sccp25VgVA+Rp5RG9b0XtN6Tn/uIJAoiXMDtXyyYJsK2PkIi0Hj5vgUcDdyR+WqgT
         JzO3qmqMEv2h2sSY3qqm8cpk6ql96Mu1AVbeUmqTtyhB05cAQ61ujdGdzUtKP9fugxWG
         nkWFwqCV1896kfoo0lhx02aoZdogtxzg8VS5qWCKkKdaWkhG2QvyE64BlP3rZTV72Vz/
         4JFXk/tz1dqxZZqAFmhkBIDEliBy1K8AbeILwPpgnU1+UU7bhxXIgVdpxLPwo05xCDCH
         kiWg==
X-Gm-Message-State: AOAM532jdDaMWbeQVFtP/ql+0sj3KRcARBn+NN17Rvccx70mVjWeK/VW
        Tex/qt+xAVXCZX1YrEDbD+c4tPNoPtFBXQ==
X-Google-Smtp-Source: ABdhPJzrXYlX4Xmen4945mvI2rhNd226+RuEd51m98kNC+XD+qAixKIvwtzC0Xi6uEg6hZMNDK9yWw==
X-Received: by 2002:a7b:c119:: with SMTP id w25mr20773093wmi.87.1620557918615;
        Sun, 09 May 2021 03:58:38 -0700 (PDT)
Received: from [192.168.1.130] ([213.194.141.17])
        by smtp.gmail.com with ESMTPSA id i11sm17076955wrp.56.2021.05.09.03.58.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 May 2021 03:58:38 -0700 (PDT)
Subject: Re: nft_pipapo_avx2_lookup backtrace in linux 5.10
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <8ff71ad7-7171-c8c7-f31b-d4bd7577cc18@netfilter.org>
 <20210507123636.030e98ef@elisabeth>
 <a044a8bb-e7cd-35e5-9602-0879f872656c@netfilter.org>
 <20210508030046.4ae872f6@redhat.com>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Message-ID: <4d9316cc-b9fe-6ff4-3b4f-15d26517a391@netfilter.org>
Date:   Sun, 9 May 2021 12:58:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210508030046.4ae872f6@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 5/8/21 3:00 AM, Stefano Brivio wrote:
> On Fri, 7 May 2021 13:12:43 +0200
> Arturo Borrero Gonzalez <arturo@netfilter.org> wrote:
> 
>> However, the nft ruleset is quite simple. It should be possible for you to grab
>> a similar arch CPU, introduce the ruleset and generate some traffic to trigger
>> the lookup(), no?
> 
> Unfortunately, this has little to do with the ruleset, it's rather
> about the fact that a kthread using the FPU gets interrupted by
> net_rx_action() which ends up in a call to nft_pipapo_avx2_lookup(),
> which also uses the FPU.
> 
> The amount of luck I'd need to hit this with some ext4 worklaod
> together with packet classification discourages me from even trying. ;)
> But luckily my mistake here looks simple enough to fix.
> 

right
