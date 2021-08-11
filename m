Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9AEDC4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 19:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B72B160EB9
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 19:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhHKTGm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 15:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhHKTGl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 15:06:41 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7161C061765
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Aug 2021 12:06:17 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id nt11so5077127pjb.2
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Aug 2021 12:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=yReqSek3Rh3by3Otz/LHskrMfPgBAftMEQnYn0h1usM=;
        b=CgMglo++j+nJPr1KERwG6GiM4xAwpFmD3nTBBeIoNDGFGAN7RPExhrujSUsk33uGAj
         JsIDR5lJ5ssMdGFg35vWDWsYfreITSV5muMNBfZYc5db/ycH8XIJuIuQTj9KdKYeL+tb
         EFnszUloBBDJ2trxbqw23/tg7TOzUs68xsQSOm8Fozh9UWZr9EYPdDmca5euA8lWiyG9
         9rue9C+wTsc7DpW5gotpF+1MeuWKMLmFXN3mLJc4AIBTgl+cHL/YXNRZ0q8eEGnbV0Dl
         LQG+B8b5UXz04MquH7elrHQq+rwtuPk515hChHBO/2gDtuPA1VHYe1+TN3VWNFKdsPuq
         lrrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=yReqSek3Rh3by3Otz/LHskrMfPgBAftMEQnYn0h1usM=;
        b=sc39n7FFsUtE0u9/l7Rid0IxsFgnJlQuxngj5EvAV6JIpHTVdLcwXtPcYD2XQw/eMY
         wGpiNm83d9PmGa71c1N04+6fRCsN+YSS10DkMyQ+Dc+Q6SzEzIkAlgYnvA4h7cgISBA3
         7WquwQzLazKyZsPdJjt4VSV2sfDrQHyxQ10Ov/R9W4D4LqdcDacduopL6/QNOf/8EnQb
         NkjRuwT9qyEUwWTcwsc4Bhi9nUvEBvC0cnJWmRc7UinI9E+sBDLmPVoVBDs1pHdL22yd
         ndHVgFaDXryHWi0RQWHeXVmathsKSfdzvs/TAGJD50NK8MGtbhcf3/1YjGM3mJN9W8k7
         EPAw==
X-Gm-Message-State: AOAM533breb1AQjWLGSJo5uPSp7IBEqb+REKTVWzELBYUVh9sYuTORaP
        ZYzaS5eBL0LM4z5EyBlD3+4=
X-Google-Smtp-Source: ABdhPJyGRu1SmSn2kD9lNtlKMAdbrCeB08rRiIPqI/PgmdxQF+IU9CHXHtzo6OAIxsws3TMSc86lWA==
X-Received: by 2002:a17:90a:2942:: with SMTP id x2mr11683618pjf.95.1628708777398;
        Wed, 11 Aug 2021 12:06:17 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id q140sm263621pfc.191.2021.08.11.12.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 12:06:16 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Thu, 12 Aug 2021 05:06:11 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] include: deprecate
 libnetfilter_queue/linux_nfnetlink_queue.h
Message-ID: <YRQfo6YISjO7z6gH@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210810160813.26984-1-pablo@netfilter.org>
 <YRNsdKcEl0z3a2ox@slk1.local.net>
 <20210811090203.GA23374@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811090203.GA23374@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 11, 2021 at 11:02:03AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 11, 2021 at 04:21:40PM +1000, Duncan Roe wrote:
> [...]
> > Suggest you leave include/libnetfilter_queue/libnetfilter_queue.h unaltered.
> >
> > That way, if a user fails to insert linux/netfilter/nfnetlink_queue.h at all, he
> > will get the warning. With the patched libnetfilter_queue.h, he will get
> > compilation errors where previously he did not.
>
> OK, done and pushed it out. Thanks.

You really didn't need all these extra #include lines. The only source that
doesn't compile with "#include <libnetfilter_queue/linux_nfnetlink_queue.h>"
removed from libnetfilter_queue.h is libnetfilter_queue.c.

So, only src/libnetfilter_queue.c needed
"#include <linux/netfilter/nfnetlink_queue.h>". If in the future any of the
others were changed so nfnetlink_queue.h *was* required, the person doing the
change would get the warning and insert the #include then.

Worth a v2?

Cheers ... Duncan.
