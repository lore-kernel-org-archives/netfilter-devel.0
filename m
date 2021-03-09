Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16115C433DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 09:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D377C6525F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 09:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhCIJv4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 04:51:56 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:44040 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhCIJvX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 04:51:23 -0500
Received: by mail-wr1-f48.google.com with SMTP id h98so14446626wrh.11
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Mar 2021 01:51:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qbSjGDNzHacjfP3hyO6fmJFsiQJ8dhjnmnWemu2NR08=;
        b=JxBYO7Jxsb6cKT3wCF7ncedXeHyVNU45wDOUwYfhpm3VgwRSkvLsyUQeKWDW/ym7DT
         m/JZR4x2BIGYL4gltNTN3bynoI/LHoC1+CJTRqkqse3HVY7Bhk1dqx/LXY0MmMG+5VJf
         aXPYuFovhUYzAiA3DoTEeSAqfwD9oRwB70JDai7izxD/3q+53pqqRV9n4E6l0h2jSoXu
         Y4BvEpcwcf36/yS22S48smpYyU2gObA4e+xHpliUtmRnbvT89iMH2F97D9kQ+ZQYq0Ot
         KUO0dYlzX0PuMM0UEqoUM2pBSwVkkprY5lDtTiPOZkLOBVEVXhBnYj6sPxM5mi9JDAMx
         v4mQ==
X-Gm-Message-State: AOAM5308b5x8SH7tE5c0LXyxLLKMdrH+jcFf1xK0XqHbRHtzx0DPv3L+
        4oTDhcX2C84jABc7p+TpQW1BMYECpPf+RpY+
X-Google-Smtp-Source: ABdhPJz5AZa4GYk9AU3DjXXwZ1KHYS1BaqESd5fJxEQwS8B/jygH7+tRmw/3joWRACAkUQS0wic4rg==
X-Received: by 2002:adf:ea8d:: with SMTP id s13mr26828374wrm.32.1615283482188;
        Tue, 09 Mar 2021 01:51:22 -0800 (PST)
Received: from [10.239.43.214] (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id s11sm3374746wme.22.2021.03.09.01.51.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 01:51:21 -0800 (PST)
Subject: Re: [PATCH conntrack-tools] conntrackd: set default hashtable buckets
 and max entries if not specified
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20210308153254.15678-1-pablo@netfilter.org>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Message-ID: <c85d5bbc-0f47-1f78-7eb5-8468bf56e78f@netfilter.org>
Date:   Tue, 9 Mar 2021 10:51:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210308153254.15678-1-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 3/8/21 4:32 PM, Pablo Neira Ayuso wrote:
> Fall back to 65536 buckets and 262144 entries.
> 
> It would be probably good to add code to autoadjust by reading
> /proc/sys/net/netfilter/nf_conntrack_buckets and
> /proc/sys/net/nf_conntrack_max.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1491
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>   src/read_config_yy.y | 6 ++++++
>   1 file changed, 6 insertions(+)
> 

Thanks for the patch!

Would it make sense to have all this logic in evaluate() in src/run.c?

