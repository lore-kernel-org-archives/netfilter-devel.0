Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E4CC433ED
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 May 2021 11:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 170746145A
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 May 2021 11:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhEGLNq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 May 2021 07:13:46 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:37730 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbhEGLNq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 May 2021 07:13:46 -0400
Received: by mail-wm1-f50.google.com with SMTP id b11-20020a7bc24b0000b0290148da0694ffso6928574wmj.2
        for <netfilter-devel@vger.kernel.org>; Fri, 07 May 2021 04:12:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ywi5077VnGoX+cvj9VOO9Y448POmPRUDheb6qt5fG5Q=;
        b=DJwX25Q0ySwIZK9zfKGWdXWHNkJoxZ/kTUU+B1kCoElQem5OgObRVYdtyPCeYVFIS4
         M5tMY2c6C3G/htINAOKLmXsyIyfgDSekyOjVsNsqSsEvqghmrUSFjQm8TDvtRQRjtf5A
         a4JdKtBIYmkeXiw8YVRiI9w8BIbkZDCbHRfPsOmMSVzK3yffpEMXGHoAy6cCcSAeOxpD
         +EIQCyHrW2tWnJ+KtZy7+OJhyvEQg5n+6qWi5NQIXtSCD7Zkl7luvkYO1tTKnwnJnlZZ
         q8p40eEuOJKqJxWDYLLkpHde0aQxEZo31nCe4OCKeGciAceLVPmDvJBmLwLerNlQcQOc
         hFcA==
X-Gm-Message-State: AOAM533+i0u+yTNvTTHttlorwl/0UydOr4D5+/Ctz74+yNC3kyDwzvg8
        oe4NOH0RKA6EqqOI7G9r5UsSsAJpSTpDEQ==
X-Google-Smtp-Source: ABdhPJz65MesLxPZBztks4wJdCmVmZqhldy7pH0tmaAzY3mR8ijt+p/7rJPOBVVglf0WqupvJOnzWg==
X-Received: by 2002:a1c:f20f:: with SMTP id s15mr20925373wmc.61.1620385965615;
        Fri, 07 May 2021 04:12:45 -0700 (PDT)
Received: from [10.239.43.214] (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id t10sm13674147wmf.16.2021.05.07.04.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 04:12:44 -0700 (PDT)
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <8ff71ad7-7171-c8c7-f31b-d4bd7577cc18@netfilter.org>
 <20210507123636.030e98ef@elisabeth>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: nft_pipapo_avx2_lookup backtrace in linux 5.10
Message-ID: <a044a8bb-e7cd-35e5-9602-0879f872656c@netfilter.org>
Date:   Fri, 7 May 2021 13:12:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210507123636.030e98ef@elisabeth>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 5/7/21 12:36 PM, Stefano Brivio wrote:
> 
> Can you reproduce this reliably? That would be helpful.
> 

No :-( this is a live production system. The backtrace was triggered by real 
life traffic. Even worse, I can't hack the kernel with a patch ... We should 
stick to debian kernel builds for production systems per our internal policy.

However, the nft ruleset is quite simple. It should be possible for you to grab 
a similar arch CPU, introduce the ruleset and generate some traffic to trigger 
the lookup(), no?

Thanks for your prompt response, also Florian for the patch proposal!
