Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03ECC4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 06:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5CB860D07
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 06:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbhHKGWJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 02:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbhHKGWJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 02:22:09 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAE8C061765
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Aug 2021 23:21:46 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id k2so1293640plk.13
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Aug 2021 23:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=h2i2vQm6hxzrMVTA2SoAW1w2yZS22mzZvMlIzXNEZ8g=;
        b=LLXjE11BUj6ww9AbpNWwAVNnnFUrL+stYS0s1dX7gmVbpkjYqGQwFoO7XUHZKG2xEn
         WVwB44iKSdaKuZ+sg1d2CkoH5lxfNwzFC1cDjYQOTM0KBhh8oO5WeJj7bQqSTbwtR10A
         qM+SpP4aA0o6zRfQzNZLXjR33Q4N0C/ziu6BxN8Gut6KngcxUZnWkS4kfo5Dzmy6+4hh
         A2GW8BHbgBEXOWM+yLzZ7+Q78pQU0s4Z9H4emPDzJ9el65whRDLPK7PXsPEnD7/0bK9L
         R+5Npm8YP6nVamcd8krD4PUKXSgzWHLYwF7w2OUtcyxX2n7/yknfoOXI6TvRpSd3zAsa
         fX5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=h2i2vQm6hxzrMVTA2SoAW1w2yZS22mzZvMlIzXNEZ8g=;
        b=mg3Q3xjiyXrzJZnARSOEtWOQuzeYGjSEd30/gBp36H2yt2PKPRK0I37mbS9fPnPB29
         ZE2gY0mg9RYqrbRHpnonKFzCP3x4CZL6c40aolHJOh/cc+Z9nkA0X7jcLJFvieSKyUWR
         CVHORFAwDr0s/cjPjZZepdLL3mYaE5MqgZmIoES78iv4frYjJbcDOCBFTCB1/ky0Oxl8
         URvFucAQHXZpRtbtrSRPcPJ43orLOrXvI4RzbEbhVzQsXfM1w5cwczH2MpxzMQ+P0pbi
         k1Zv7aveOnqCo0Fs1ZG71aDN1y9qQP9dUmnL09JzVFfhMXNq/Ht7WZBa4HtadJFi4+eb
         wwBw==
X-Gm-Message-State: AOAM5316PoWDwuhtCZmtW+EnJErpL7fdZXx6OIwb1eTZ5+M7k2oEMWII
        0axlmSO/1F8LtjiHbhCORB0+MqeitRwz2A==
X-Google-Smtp-Source: ABdhPJwfPC1lgv1297nvRKN+YwMfpgp2lveSNhNyZfEqW+LO0IKw7ptXMm5v1+dXgR9dpKWtBy4nSQ==
X-Received: by 2002:a17:90a:9f93:: with SMTP id o19mr628919pjp.166.1628662905758;
        Tue, 10 Aug 2021 23:21:45 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id p53sm26329682pfw.143.2021.08.10.23.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 23:21:45 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Wed, 11 Aug 2021 16:21:40 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] include: deprecate
 libnetfilter_queue/linux_nfnetlink_queue.h
Message-ID: <YRNsdKcEl0z3a2ox@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210810160813.26984-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810160813.26984-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Aug 10, 2021 at 06:08:13PM +0200, Pablo Neira Ayuso wrote:
> Emit a warning to notify users that this file is deprecated.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/libnetfilter_queue/libnetfilter_queue.h    | 2 --
>  include/libnetfilter_queue/linux_nfnetlink_queue.h | 2 ++
>  src/libnetfilter_queue.c                           | 1 +
>  utils/nfqnl_test.c                                 | 1 +
>  4 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
> index a19122f10ec6..42a3a45f27e1 100644
> --- a/include/libnetfilter_queue/libnetfilter_queue.h
> +++ b/include/libnetfilter_queue/libnetfilter_queue.h
> @@ -16,8 +16,6 @@
>  #include <sys/time.h>
>  #include <libnfnetlink/libnfnetlink.h>
>
> -#include <libnetfilter_queue/linux_nfnetlink_queue.h>
> -
>  #ifdef __cplusplus
>  extern "C" {
>  #endif
> diff --git a/include/libnetfilter_queue/linux_nfnetlink_queue.h b/include/libnetfilter_queue/linux_nfnetlink_queue.h
> index caa67884482c..84f5d96c0a7b 100644
> --- a/include/libnetfilter_queue/linux_nfnetlink_queue.h
> +++ b/include/libnetfilter_queue/linux_nfnetlink_queue.h
> @@ -1,6 +1,8 @@
>  #ifndef _NFNETLINK_QUEUE_H
>  #define _NFNETLINK_QUEUE_H
>
> +#warning "#include <libnetfilter_queue/linux_nfnetlink_queue.h> is deprecated, use #include <linux/netfilter/nfnetlink_queue.h> instead."
> +
>  #ifndef aligned_u64
>  #define aligned_u64 unsigned long long __attribute__((aligned(8)))
>  #endif
> diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
> index ef3b21101998..11a4e7c51cc0 100644
> --- a/src/libnetfilter_queue.c
> +++ b/src/libnetfilter_queue.c
> @@ -29,6 +29,7 @@
>  #include <errno.h>
>  #include <netinet/in.h>
>  #include <sys/socket.h>
> +#include <linux/netfilter/nfnetlink_queue.h>
>
>  #include <libnfnetlink/libnfnetlink.h>
>  #include <libnetfilter_queue/libnetfilter_queue.h>
> diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
> index 5e76ffe48cc7..682f3d79d45a 100644
> --- a/utils/nfqnl_test.c
> +++ b/utils/nfqnl_test.c
> @@ -5,6 +5,7 @@
>  #include <netinet/in.h>
>  #include <linux/types.h>
>  #include <linux/netfilter.h>		/* for NF_ACCEPT */
> +#include <linux/netfilter/nfnetlink_queue.h>
>  #include <errno.h>
>
>  #include <libnetfilter_queue/libnetfilter_queue.h>
> --
> 2.20.1
>
Suggest you leave include/libnetfilter_queue/libnetfilter_queue.h unaltered.

That way, if a user fails to insert linux/netfilter/nfnetlink_queue.h at all, he
will get the warning. With the patched libnetfilter_queue.h, he will get
compilation errors where previously he did not.

Otherwise all good.

BTW if a user doesn't have kernel headers he's in for a hard time anyway: the
verdict helpers need linux/netfilter.h for NF_ACCEPT &c.

Cheers ... Duncan.
