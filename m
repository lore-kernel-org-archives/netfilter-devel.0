Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC11C63798
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Nov 2020 22:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A935121527
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Nov 2020 22:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389759AbgK1VuF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 28 Nov 2020 16:50:05 -0500
Received: from mail-lf1-f51.google.com ([209.85.167.51]:41777 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730506AbgK0TvY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Nov 2020 14:51:24 -0500
Received: by mail-lf1-f51.google.com with SMTP id r24so8522623lfm.8;
        Fri, 27 Nov 2020 11:51:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=pVY27RlXdSwCmziTRPPFMGA75xoNNNryw43jm/wsTCw=;
        b=YTwju2m6t7hut/zrT4m+zjBHZFE5GFIVxAl8WNE9HVypjgAtHh1X56KM12xhQDj/m4
         pQ2ZTbZM7dXnDE+pz36vFl/XmNtUQqiJOP8V7agCwjI0HVFDY9Zhy4EaZz25Gkhhr9QC
         00nutvs4r0gOlozx5o/T1ChUwr8iRWawSJ2a3gdUpuTzGxg7lyJfZnOxIATSzDI81Bqq
         49SyQLay85jxm/xxaa6lEkFWQWO31x4sx9a+cUTGJe4sRvhbL1bLMtiqrnN78beRu4Ea
         At08KPvj+vX8R2wdp8x+I0FKlMvZ7U9u8K9NJ8hHERGNTauqkyCdHkFMi+ebwnmb69XH
         5tDg==
X-Gm-Message-State: AOAM530+Y5jJoSsbfqJq1fDUZkAiY9ms/0LKUDMjIfZXnzDQDrokIsBM
        Vsi+WCzvif9ifFKvpJHSAZJdVFCrxKWbrQ==
X-Google-Smtp-Source: ABdhPJzXxJcVAXzxcLMRIdgnyS0T79f34vFQiH1BHhhmTmVDgIILkHPxoRyVqBCYZ6CraZoPSVnREQ==
X-Received: by 2002:adf:a551:: with SMTP id j17mr12890547wrb.217.1606505729700;
        Fri, 27 Nov 2020 11:35:29 -0800 (PST)
Received: from [192.168.1.173] ([213.194.141.17])
        by smtp.gmail.com with ESMTPSA id u12sm3078525wmu.28.2020.11.27.11.35.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2020 11:35:29 -0800 (PST)
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Cc:     "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: [FYI] summary of Netfilter workshop 2020 virtual
Message-ID: <a7d4f6d6-0576-2918-0f28-f9804d296a3e@netfilter.org>
Date:   Fri, 27 Nov 2020 20:35:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi there,

I'm sharing here a link to the summary I wrote about the 2020 Netfilter
workshop, which was held in a virtual format this year:

https://ral-arturo.org/2020/11/27/netfilter-virtual-workshop.html

regards.
