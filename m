Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC80C4338F
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Jul 2021 10:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BABD60E91
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Jul 2021 10:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbhGXJcY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 24 Jul 2021 05:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbhGXJcX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 24 Jul 2021 05:32:23 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7335C061575
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Jul 2021 03:12:55 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m2-20020a17090a71c2b0290175cf22899cso7185554pjs.2
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Jul 2021 03:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=uzjGwEMUgmCn6yNc7i18AbcwP0kdjeNkTnJ95juvQsI=;
        b=a75wYdIrQtDxznSRMm51YJ1+9hFCCr9KFEHmVqETG0CfOCjs1eLHlJG2DAd+C/+mSh
         LqY0GJrOMOYKo2xIGRZYTNzppCdquknhkxxaszaap/FkpOXiBOJS7n3DH1xbSQjVhTxT
         NO2PgIOGjV430ODp4yStUTO01iDG20FUr8xoT711mwHhvvEahO+rSc0zgjz5NCVMzpCx
         duKe9vIwr4os6vfkqI6cP9j8CRoEJyyVRIOgoz/hU3R/TLE7iw/R4Al/dIqHBWjwsTXe
         wRpOC9Dji50u8QCcBuqlhA1To+BeGwg6uBc1WQpjLrsVieYZiWUx5JiZtBCLQaFRM1Ho
         0+mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=uzjGwEMUgmCn6yNc7i18AbcwP0kdjeNkTnJ95juvQsI=;
        b=nZT4aUWKLDjwQogu15gwMacNMKhq2yV1761uANuT0Ih3xPDY1mA4C+PmsIDSpEaxvx
         g1tXSNkzaZ+R5VGuaarmxf2mxnO2aOQvWUvYoLOk9piypka6/qmp9PhUuiwybWHbhax3
         uOl5Ld/qi9GBCwTwoT9+xc9/Cb8KJlPnZlVLHAT7z+dEzN4RtNCEbec/mdrpffUb3ctQ
         wQ28CoEDpXK3iVYahp8KplghBfvaTYH30i7wh5rQX6XkcR+IwLHYC7Va83yhBEMA68P5
         fzBMNIvlItuOgPzEx18gBlxE2MlmOljaQ25iR31r4aK67IH6s6qglyI1yk2EjoJuM7Lc
         QiQg==
X-Gm-Message-State: AOAM53080bPYOc3YlikZbHfGBBzmn3mrZzRxuBt/AOrymfLWxf7Qj9FO
        n8PAQzACMrgAKAPgVSGpLDPfhcWKXBsz/w==
X-Google-Smtp-Source: ABdhPJw6KKbft6dpWx925tfuS5NmbU8kKtuhjTJvyTE3NYtIg4JAxYIDU+wTnoU9kPqX6HrG4V42Fw==
X-Received: by 2002:a17:902:8bc3:b029:124:919f:6213 with SMTP id r3-20020a1709028bc3b0290124919f6213mr7393459plo.51.1627121575552;
        Sat, 24 Jul 2021 03:12:55 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id 21sm34825921pfh.103.2021.07.24.03.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jul 2021 03:12:54 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sat, 24 Jul 2021 20:12:50 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] src: Stop users from accidentally
 using legacy linux_nfnetlink_queue.h
Message-ID: <YPvnouO/uanIZ5qx@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210718051027.25484-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210718051027.25484-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jul 18, 2021 at 03:10:27PM +1000, Duncan Roe wrote:
> If a user coded
>   #include <libnetfilter_queue/libnetfilter_queue.h>
>   #include <linux/netfilter/nfnetlink_queue.h>
> then instead of nfnetlink_queue.h they would get linux_nfnetlink_queue.h.
> Internally, this only affects libnetfilter_queue.c
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  include/libnetfilter_queue/libnetfilter_queue.h | 2 --
>  src/libnetfilter_queue.c                        | 1 +
>  2 files changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
> index a19122f..42a3a45 100644
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
> diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
> index ef3b211..899c765 100644
> --- a/src/libnetfilter_queue.c
> +++ b/src/libnetfilter_queue.c
> @@ -32,6 +32,7 @@
>
>  #include <libnfnetlink/libnfnetlink.h>
>  #include <libnetfilter_queue/libnetfilter_queue.h>
> +#include <libnetfilter_queue/linux_nfnetlink_queue.h>
>  #include "internal.h"
>
>  /**
> --
> 2.17.5
>
Scrub this - will be sending a V2.

Forgot to update utils/nfqnl_test.c,

Cheers ... Duncan.
