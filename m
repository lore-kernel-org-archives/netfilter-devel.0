Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD39C48BC2
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Jun 2021 16:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A02C61164
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Jun 2021 16:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhFUQRD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Jun 2021 12:17:03 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:43647 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhFUQRB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Jun 2021 12:17:01 -0400
Received: by mail-wm1-f48.google.com with SMTP id p8-20020a7bcc880000b02901dbb595a9f1so372304wma.2
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Jun 2021 09:14:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6cTsum5I4Yg9wRwl1A01ASMQdGllNsf1WB/W37wnVec=;
        b=jvXjVXZyw6iAvRXFItICAiIQGecdheExdylrwaDfwXCsoTfcxSTT48qoxMAntND6T/
         x68ASdFvZ7vAGX5gBPUaXuWZD5wu++klYDrwq6oqcbxophqUrQx4sdM/0IsXmjhb/Xdg
         nogvFY6jp63VN1MHq1xAJAK9XRTvQItRr9/7cC8iGM/vrEcGHZAMKiqotKfWNyCe8zeI
         A6Osk6LNyQpRM16P78jeTRayWfEv5lPhdU2wewjBQqrcIA+CW9kZs5BJxRqGU8fmm8qh
         DlhT4S0j2m+DSBw7xC+m/mZMEzTQiK/U05OljedW3b6y8rNLcqpYoLS7e3kQRYEvjv2F
         E+5Q==
X-Gm-Message-State: AOAM532rzeeeb3pDsKBsOHTjLs8EZyY2h5XhD0peKxdqDQYvmB8Ri4/s
        yHVH04tY/qd1OKhGTKkP/yQ=
X-Google-Smtp-Source: ABdhPJzxYUbR6Xb5X4AfF9SxJ/Fpjx7LzsN1K6ms3pRgxm1A519JxWhxNYuTNOcV+P29zdVYJ43gEQ==
X-Received: by 2002:a05:600c:1552:: with SMTP id f18mr22895393wmg.184.1624292086456;
        Mon, 21 Jun 2021 09:14:46 -0700 (PDT)
Received: from [192.168.1.130] ([213.194.132.177])
        by smtp.gmail.com with ESMTPSA id z5sm18130491wrp.92.2021.06.21.09.14.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 09:14:45 -0700 (PDT)
To:     Oz Shlomo <ozsh@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Paul Blakey <paulb@nvidia.com>, netfilter-devel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20210617065006.5893-1-ozsh@nvidia.com>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [PATCH nf-next] docs: networking: Update connection tracking
 offload sysctl parameters
Message-ID: <04c84d18-5707-6423-5736-a70114df0f15@netfilter.org>
Date:   Mon, 21 Jun 2021 18:14:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210617065006.5893-1-ozsh@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 6/17/21 8:50 AM, Oz Shlomo wrote:
> Document the following connection offload configuration parameters:
> - nf_flowtable_tcp_timeout
> - nf_flowtable_tcp_pickup
> - nf_flowtable_udp_timeout
> - nf_flowtable_udp_pickup
> 
> Signed-off-by: Oz Shlomo<ozsh@nvidia.com>

Sorry for the late feedback.

In my experience the kernel docs have rather poor documents for netfilter sysctl 
parameters. I often find myself reading the source code for a deeper 
understanding of what is going on.

The docs included in this patch are too short in my opinion, example:

+nf_flowtable_tcp_pickup - INTEGER (seconds)
+        default 120
+
+        TCP connection timeout after being aged from nf flow table offload.


Here, having an example of the sequence of events going on with the conntrack 
entry and how this sysctl key affects it would be great. Some explanation of the 
behavior that may be observed when tuning this value would be nice as well.

Given the patch was merged already, you can feel free to ignore this anyway :-)
