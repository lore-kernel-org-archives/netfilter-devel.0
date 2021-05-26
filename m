Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBF9C47088
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 May 2021 14:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 380CF61028
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 May 2021 14:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbhEZOam (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 May 2021 10:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbhEZOak (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 May 2021 10:30:40 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CE4C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 26 May 2021 07:29:07 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j14so1368902wrq.5
        for <netfilter-devel@vger.kernel.org>; Wed, 26 May 2021 07:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pBCw1Uv+Mkl8aGYfvaMpdnEbz257gSySua8fXm99hIg=;
        b=AuYBb52xFhDYs0i9B/+UpKfwaAdY0wOj1IEINNu4xeyFQEiZFKhMLyhPOvs2/4VA/9
         Yf1htwq136DoziTaTf/M3Iy1qxgWvuIOD12FVH55F4TJMr1cM0xN5wTbJk2asakODrjP
         GVDwTUSRK+Xs83BjMey0LfcFmpsl7SGzup3TmGkUpuCM4xb1JOw1jsFEtYBKuIFWVVmD
         x0LGgV2cLFnQJGCjhBDgqm2ZsaV1JOayAw6n19lcOtsVh9D4UwH3ZjqwfOhENqkv5KBA
         wP+SyWkD6PDja/Hz1ndOBnbp497wDxhSAmUzr1sdyXfAgjf9V3tzM+KnY/7bm+xXU4fX
         SATQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pBCw1Uv+Mkl8aGYfvaMpdnEbz257gSySua8fXm99hIg=;
        b=PppQpkeAB9Tyi5H5kadwuJw87HVYJeb2/+AmwTCmeTjkaaKfH9LP3yOoFT1rlCcpaR
         zP92w5Pl1r26Up2dBPTklW0yjnoZjP2gxl6tAozqQVP7td6K2Le0ZA+GvZG4Xate899C
         MNY0RWmnTnWjNpJoNVWS7eRIJGdIP03OzaAZ+Fy/ij009rdcTqg8UW0mS8T9pRL2iNI2
         u7tBB66/Fh7d3SBlh4aXyBiqHEDbx4oZ74eavipaRzpoz0pYFRsrkr0L8OE+qp5ETS7D
         ap5ffRSCIBkFX5p1HeNrBWBu/kLf4st1szbXeYj61ohsVcFy66H7wdrDLatn2JSeWqGH
         sMGA==
X-Gm-Message-State: AOAM531WDtAxdNB0Ulo+f2cfI/wbHL5Ta2KPOBFPIl9ECJN3+nb/HKFz
        tcIbFvjbfTT0HWbM1yD7S3Vawc1QEHUkZg==
X-Google-Smtp-Source: ABdhPJyebBX3PLOKSF5uPqqucbbHXFGBYXqAS7W4Z73pDXOpae/XT4nn5+2QQNTXuIMqd7kYtlZGPw==
X-Received: by 2002:a5d:5407:: with SMTP id g7mr33534278wrv.207.1622039346305;
        Wed, 26 May 2021 07:29:06 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:907f:22ed:6bd2:e2b9? ([2a01:e0a:410:bb00:907f:22ed:6bd2:e2b9])
        by smtp.gmail.com with ESMTPSA id i1sm14592462wmb.46.2021.05.26.07.29.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 07:29:05 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] netfilter: conntrack: add new sysctl to disable RST check
To:     Ali Abdallah <ali.abdallah@suse.com>,
        netfilter-devel@vger.kernel.org
References: <20210526092444.lca726ghsrli5fpx@Fryzen495>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <e48eac1e-dd8e-52c2-3a15-a9404933d1dd@6wind.com>
Date:   Wed, 26 May 2021 16:29:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210526092444.lca726ghsrli5fpx@Fryzen495>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 26/05/2021 à 11:24, Ali Abdallah a écrit :
> This patch adds a new sysctl tcp_ignore_invalid_rst to disable marking
> out of segments RSTs as INVALID.
> 
> Signed-off-by: Ali Abdallah <aabdallah@suse.de>
> ---
>  Documentation/networking/nf_conntrack-sysctl.rst |  6 ++++++
>  include/net/netns/conntrack.h                    |  1 +
>  net/netfilter/nf_conntrack_proto_tcp.c           |  6 +++++-
>  net/netfilter/nf_conntrack_standalone.c          | 10 ++++++++++
>  4 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
> index 11a9b76786cb..45f5a9690172 100644
> --- a/Documentation/networking/nf_conntrack-sysctl.rst
> +++ b/Documentation/networking/nf_conntrack-sysctl.rst
> @@ -110,6 +110,12 @@ nf_conntrack_tcp_be_liberal - BOOLEAN
>  	Be conservative in what you do, be liberal in what you accept from others.
>  	If it's non-zero, we mark only out of window RST segments as INVALID.
>  
> +nf_conntrack_tcp_ignore_invalid_rst - BOOLEAN
> +	- 0 - disabled (default)
> +	- not 0 - enabled
If I correctly read the patch, the only "not 0" possible value is 1. Why not
using explicitly "1"?

[snip]

> @@ -778,6 +779,14 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>  		.extra1 	= SYSCTL_ZERO,
>  		.extra2 	= SYSCTL_ONE,
>  	},
> +	[NF_SYSCTL_CT_PROTO_TCP_IGNORE_INVALID_RST] = {
> +		.procname	= "nf_conntrack_tcp_ignore_invalid_rst",
> +		.maxlen		= sizeof(u8),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dou8vec_minmax,
> +		.extra1		= SYSCTL_ZERO,
> +		.extra2		= SYSCTL_ONE,
Max == 1.


Regards,
Nicolas
