Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7554FC04FF3
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 22:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C2F9613D9
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 22:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhEUWoi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 May 2021 18:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhEUWoh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 May 2021 18:44:37 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D627C0613ED
        for <netfilter-devel@vger.kernel.org>; Fri, 21 May 2021 15:43:13 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id c12so4365931pfl.3
        for <netfilter-devel@vger.kernel.org>; Fri, 21 May 2021 15:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=hx/V4z8kFuIPZv6ySkF7UmhkXzRe71sGpkVBLtvcpbE=;
        b=RS+JlUASlOXmddBCwYwUtyS69eOpfYko1OU/H0MyRRDPS4sgJC5bY74OZZBmCDGRyk
         A/q2EOdKUjQv97yBVdo3LQNm8kAv8CP6YG4BVnJLW3Xh9l/ZIgjicNrck0fEbq1EZISu
         j5G7TV0n3MAXvCTgrhwlR+JEfG13F+hr48VHJb+6KiJJ1h6VxDc7M0qdEQ/sAdr1st2m
         U3EWwTMft9L5uqo6Fl4qpWn6hdi3hfBGwmr+aK9NLayuneQyMXRO7qFRXZ8bHeGNZmH3
         uciO/79WXuozLETcCznrMoSdc5m1V8xHjKLYOopzTLBGjhfYBz9p33FmXmF4DWoI9kX6
         en+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=hx/V4z8kFuIPZv6ySkF7UmhkXzRe71sGpkVBLtvcpbE=;
        b=hrzvly8sXq/su3QYA3PRw2DwKph97zAc3iUlSz893cCF75hesJKeCb8HpDQ71jWDb7
         g6icDve8rsPbnMZFthJW/JbLa6sLATRboQPc0b/9rzSTe4M5eAs6wmx1SAFSAXSQjjDa
         1i4fe4mOWaqZuwSEAh3hFSb7xOGHyFELuIpNWiP0Lh4yNqf9lzxKvKSbR5ozfdEyK2wC
         eSWcy8I4lOJPe2vY59A9y6EFypwb8ub2mTpW4N4byVabNy91OBpHlpEmiyiTEhfM22ur
         2c5nPTLtMsAHyO++BJTRQMuDofW5O9AmTeyX94zDgvkNzqU968Qc6Ob0f8t67UjlcsOp
         51zw==
X-Gm-Message-State: AOAM531KVj9omqvqW5SGtsHmsHGDnZEsKllsh+iNzAiqpGtkFOa1WJIj
        EiFSu1I++HkzAs7UzcaTvTWhyWBWLuUC2A==
X-Google-Smtp-Source: ABdhPJx+kKI8uOoRtlzFkOfvLB7ZHOvGfQqUnGVLs6JSVY/7JXLh3+GrT3bzCQaAUfqgKfIeAMQxjA==
X-Received: by 2002:a63:3686:: with SMTP id d128mr981195pga.305.1621636992181;
        Fri, 21 May 2021 15:43:12 -0700 (PDT)
Received: from slk1.local.net (n49-192-89-29.sun3.vic.optusnet.com.au. [49.192.89.29])
        by smtp.gmail.com with ESMTPSA id b20sm4198304pfo.34.2021.05.21.15.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 15:43:11 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sat, 22 May 2021 08:43:06 +1000
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 3/3] doc: add LISTING section
Message-ID: <YKg3ekC4fZVbEd0N@slk1.local.net>
Mail-Followup-To: netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
References: <20210521120846.1140-1-fw@strlen.de>
 <20210521120846.1140-4-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521120846.1140-4-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 21, 2021 at 02:08:46PM +0200, Florian Westphal wrote:
> mention various 'nft list' options, such as secmarks, flow tables, and
> so on.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  doc/nft.txt | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/doc/nft.txt b/doc/nft.txt
> index a4333d9d55f3..245406fb1335 100644
> --- a/doc/nft.txt
> +++ b/doc/nft.txt
> @@ -684,6 +684,18 @@ and subtraction can be used to set relative priority, e.g. filter + 5 equals to
>  *list*:: List all flowtables.
>
>
> +LISTING
> +-------
> +[verse]
> +*list { secmarks | synproxys | flow tables | meters | hooks }* ['family']
> +*list { secmarks | synproxys | flow tables | meters | hooks } table* ['family'] 'table'
> +*list ct { timeout | expectation | helper | helpers } table* ['family'] 'table'
> +
> +Inspect configured objects.
> +*list hooks* shows the full hook pipeline, including those registered by
> +kernel modules, such as nf_conntrack.
> +
> +
>  STATEFUL OBJECTS
>  ----------------
>  [verse]
> @@ -691,6 +703,7 @@ STATEFUL OBJECTS
>  *delete* 'type' ['family'] 'table' *handle* 'handle'
>  *list counters* ['family']
>  *list quotas* ['family']
> +*list limits* ['family']
>
>  Stateful objects are attached to tables and are identified by an unique name.
>  They group stateful information from rules, to reference them in rules the
> --
> 2.26.3
>

Tiny nit: suggest "by a unique" instead of "by an unique".
"a" reads better to this native en-GB speaker at least.

Cheers ... Duncan.
