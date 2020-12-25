Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 541CBC433DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Dec 2020 20:01:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A306E221F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Dec 2020 20:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgLYUAx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Dec 2020 15:00:53 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:37732 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgLYUAx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Dec 2020 15:00:53 -0500
Received: by mail-wr1-f42.google.com with SMTP id i9so4952677wrc.4
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2020 12:00:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g6RJXTenl4YEfZiHR9oe1oBbVvtGD5Sdbafu8Q2Yb44=;
        b=Xqb3jlYKNUwMaiA2Owl5tf1KxXDcztFjI04h02VfHaOpXYKIv4vtaSAby3EV9rvNcq
         6v7mz3YuoB9HrrRFUWzSz5scLJvWvAzcKYIdDQldqRxMqORrKsCUztoScIMEUCZwgzmf
         2+9JA1eZ4N/8XUdByT3NI16sDBaWnAUDntdFZhpHwQb6zpe7h1MzjRihqwmcMbxHVL5g
         CK8LToM/t0Axo/ged0TW6kABVcDnsCZ/55OmXYfEEYOxffJ0hUpWuqa2IngGJmsYEFWY
         iqbxotlW5VZLFG0QKvpb6i/Vv+Y/8ZuIAxqHiB1aiO9uSAwdiwPRvfvoSHUTPsG1YCQQ
         gi0Q==
X-Gm-Message-State: AOAM531nl8yCvlwDHO/HaxKyLX5GynuXvmD57r08MBdpY4VS1qLNGCTq
        TBxHX9LUaPa/pHDHAsoy95qB7Py42XDVFQ==
X-Google-Smtp-Source: ABdhPJxJNKVm9wDagq0KuotgwEo1IZwzc4V9vnGjK+u360uPAG/EX7b3oxyjArkM0XTdQBiTFn8PHg==
X-Received: by 2002:adf:e688:: with SMTP id r8mr39310972wrm.20.1608926411792;
        Fri, 25 Dec 2020 12:00:11 -0800 (PST)
Received: from [192.168.1.173] ([213.194.141.17])
        by smtp.gmail.com with ESMTPSA id r7sm8962890wmh.2.2020.12.25.12.00.10
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Dec 2020 12:00:11 -0800 (PST)
Subject: Re: [PATCH conntrack-tools] conntrackd: add ip netns test script
To:     netfilter-devel@vger.kernel.org
References: <20201224130713.17517-1-pablo@netfilter.org>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Message-ID: <5a5f2bd5-6069-ad2c-3a63-c23e0a40991d@netfilter.org>
Date:   Fri, 25 Dec 2020 21:00:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201224130713.17517-1-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 12/24/20 2:07 PM, Pablo Neira Ayuso wrote:
> This patch adds a script that creates a ip netns testbed. The network
> topology looks like this:
> 

You can probably drop all those comments in the config file.

