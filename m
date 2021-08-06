Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F584C4338F
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Aug 2021 05:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06AED60E52
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Aug 2021 05:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243136AbhHFFfp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Aug 2021 01:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243121AbhHFFfo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Aug 2021 01:35:44 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6BCC061798
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Aug 2021 22:35:29 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id nh14so14587868pjb.2
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Aug 2021 22:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=r05/7kjPCnENO7FhmhqhlOg4oczOfOvz5Irrs3fTc8A=;
        b=fGaUaCTutvEcijlTkEtrB4yJ1OoWsUoLAmvE2yGzIs5bWpxd73WKawDjOdf0y2j8an
         PR0O/JjQsWzc73KSg7/BO8GgH7sY5Q8M4yIu2HvR9eB4cuKgPhn3vLoVUBrJCsf0tv6V
         jl2hT2DvwQa+c6eoZEwz8ZQhQdxL7ZcaDRkKUiLPVgc474bvIe2Ai63lhtcg3MPyo6Vb
         DlTJcyqwb9v46NRZhbakUTKfP3WTWKYlhyG646vCXF8h1GUhfTzu/6QBpThzVKsF/a5n
         Gjfu1v2kGmE0f848/k5yEKLok91IUVCGp3kOc3ml58GYG1npWtp1EpIce+Ya2YDsrdvb
         s40w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=r05/7kjPCnENO7FhmhqhlOg4oczOfOvz5Irrs3fTc8A=;
        b=mSbNDQ9D6bFx4bwELd/9xgywTDsigCRy0Sg1dwo9/3lBw4Q9ihxRMrcD8hmGy3rKz+
         nbmUfrFSYngoPQqFGFtf/BbuY6VdDkQeH5yAWOFtW0eInIg/l4LVlU4/Bs5RzF8vEFy+
         zxz699oqz2BSBUvAJ4OhW+2Ttr+ozC0sV/REjhSB4iyFEfmi2luIu4Ob64a+e0Z5Qbo1
         iCzAGjrmNStYMEUeRoO92bYoBWQefuAhxIvHqHZoNXZIz/4BBmRMHT3JKkH35g0hzJFK
         xX+mQ4kydutGWMb+Dej3CdwaRJDrgTk9V73rCNwcAmEQ6P/GBTLs+gMU3x9zG5XF4oKE
         pWMQ==
X-Gm-Message-State: AOAM531LAx52qfvdFuv+V9AN7cQJ/3VvShdWqoR9MjbdQsp7Q0PmpezG
        wu4FjGrtEJaB4hfxdnK7M38=
X-Google-Smtp-Source: ABdhPJx/V9C21U68ytjIkdTza0atF9MUGEgt2yG8kuc+W7p4LmDRAhfV0ymcbTLO9K4f61mYlRizJA==
X-Received: by 2002:a62:8fd4:0:b029:3af:3fa7:c993 with SMTP id n203-20020a628fd40000b02903af3fa7c993mr8904890pfd.77.1628228129221;
        Thu, 05 Aug 2021 22:35:29 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id 186sm8923790pfg.11.2021.08.05.22.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 22:35:28 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Fri, 6 Aug 2021 15:35:24 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2] src: Stop users from accidentally
 using legacy linux_nfnetlink_queue.h
Message-ID: <YQzKHPitgJVkDmrP@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210806021513.32560-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806021513.32560-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 06, 2021 at 12:15:13PM +1000, Duncan Roe wrote:
> If a user coded
>   #include <libnetfilter_queue/libnetfilter_queue.h>
>   #include <linux/netfilter/nfnetlink_queue.h>
> then instead of nfnetlink_queue.h they would get linux_nfnetlink_queue.h.
> In the library, this only affects libnetfilter_queue.c
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
[...]
Sorry, the v2 comment at this point should have been:

> v2: also update utils/nfqnl_test.c (required for good make distcheck)

Cheers ... Duncan.
