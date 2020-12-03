Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4041C63777
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 13:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FF4F20758
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 13:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbgLCNPn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Dec 2020 08:15:43 -0500
Received: from mail-wm1-f51.google.com ([209.85.128.51]:34551 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729142AbgLCNPn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 08:15:43 -0500
Received: by mail-wm1-f51.google.com with SMTP id g25so2632540wmh.1
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Dec 2020 05:15:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UkTZuOYKLkDu6cbssKWuldQ2dQfuNXdh/XViByCxums=;
        b=WdCdU0UMCxsJhWU2z1zZYp4n29hT9opiI7JGzfvbE9T/hpdex1QcXTtnydEYNnlm/l
         5YKZF0a4w0ZgTDaDMv41FbreR+8ZJZQiGKagoIR8ChgsDvlJzID2B+d36mxqDaylnI+l
         AtDol7Vdt4Vkv4e1yZpLZN61shEcOOTymQVC8ixjlnTPyaztaneOx021Tu430US/SkPv
         Ie7nvhtaEKrlURVhPXBHcrSPWFlnxi+fXsMVtcM9DYNCw48z6T0Q0mtAWw6Pg5p6UUnL
         Tpr7Fmutr0si6okwPPyfnl9cG2V0CdvqpQ1KV6jIvKiKDA11iYs5zLlCtElUWUhTCaV4
         wNEg==
X-Gm-Message-State: AOAM530cutss98/WLiAp55i/jDI655yWRgeh/MasHkU7Pw4HZDb73zGr
        IK+7GG66Jn7SlZSnxScKE+8ucyHdnXFm1Q==
X-Google-Smtp-Source: ABdhPJxv38+QBgx01+oSpygnn2JJy1VfiDXh6nQU8tgtuAJTdr1BHwewwvuUzuTZmGPQyt8WLcxr0Q==
X-Received: by 2002:a7b:cd90:: with SMTP id y16mr3351994wmj.115.1607001300943;
        Thu, 03 Dec 2020 05:15:00 -0800 (PST)
Received: from [192.168.1.173] ([213.194.141.17])
        by smtp.gmail.com with ESMTPSA id s8sm1719613wrn.33.2020.12.03.05.15.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 05:15:00 -0800 (PST)
Subject: Re: [PATCH nft] src: report EPERM for non-root users
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20201203124423.14137-1-pablo@netfilter.org>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Message-ID: <273eefa3-d1a2-8c21-ba44-61031059cf35@netfilter.org>
Date:   Thu, 3 Dec 2020 14:14:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201203124423.14137-1-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 12/3/20 1:44 PM, Pablo Neira Ayuso wrote:
> $ /usr/sbin/nft list ruleset
> Operation not permitted (you must be root)
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1372
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>   src/libnftables.c | 7 ++++++-
>   src/netlink.c     | 2 +-
>   2 files changed, 7 insertions(+), 2 deletions(-)
> 

Acked-by: Arturo Borrero Gonzalez <arturo@netfilter.org>

