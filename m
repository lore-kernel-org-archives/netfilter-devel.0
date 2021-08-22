Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3912C4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 04:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A950611F2
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 04:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhHVEA5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 00:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhHVEA5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 00:00:57 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50BDC061575
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Aug 2021 21:00:16 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id mw10-20020a17090b4d0a00b0017b59213831so4621986pjb.0
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Aug 2021 21:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=fLAVcqyQGVOcBR2cEvV/QaHLMdHwGTvUU9FFewTaVec=;
        b=Cyb9DOvYF7zNeDNiyWX0wGZFreApUW7ktF4JlEiKsq+EvmK3j7BKYPYMtYnL8tFqcR
         Z1immJOT39Wty+43zp4UXug5xIsLECdFP3i5I7NCw5eaCRk5ASTdRmb6YdqZrZ4T0P8P
         WSn0me24oOxZ7qXgyVkHZ6o+DFHXAlw0CIfO+2v27+h6vsWNqniE/z1pcA4LwqDQCSc0
         tlJ/5hZ3BhvkZ7O8UH5l1kVqYfYZYq3rJexPtoqVOhQJ/qrlyoRJxSQLM/Llf8qFrcQ4
         fEBkgLa1SpzF5i+3p+AD6WEoghO3SnIxZOz7BmCOFdc7iseCF2nUXD8fnmzutVaLDMTX
         Kskg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=fLAVcqyQGVOcBR2cEvV/QaHLMdHwGTvUU9FFewTaVec=;
        b=AeYgMGekJOa7RNDRjxH/VB7gvI5kUV7yHjd0W2e5axR/6VbCCJnWtAkpT0H19x1T63
         X1NUKke/pX87PXyy14cMiyq2xK5TNJUZgHm7onf6wvUitSrC9qcBRK29nkmuh2tXmtMf
         qepbhpEPrkudJT/rHMS2QGLoUv7m2JMf7ClTVDMnAMFA1HDvN6qOlQl/IXszDVA/xhCr
         rYXI7EKsaOQBMx4OUqHdrtvRupjizgrHbDSPnPPAC1KZn5eh0XKAkAQ0uyejgbtwPk+f
         m9gnDOU8TdBP0jJXrrU4rL9c0HjQsKFDCnHXQAAlyRULT1oYneGNrXNY397S6i2R3XGP
         oEHA==
X-Gm-Message-State: AOAM532K9yZAPIyw+1/gl5AewHiwXCwNFQi6CoU5HBPOpm1Kk4W08cql
        TneFn/MCHkhQvAXFXEw5whpgEyaNglxFKg==
X-Google-Smtp-Source: ABdhPJy0tVyCv7TsRgEsX9qA+9wtUewSvucgHMVXy7bgDyIk3eAzc+qyMuEDmFa7zGI8VglQCVvZvw==
X-Received: by 2002:a17:902:e889:b0:12d:a686:394a with SMTP id w9-20020a170902e88900b0012da686394amr22743923plg.57.1629604816121;
        Sat, 21 Aug 2021 21:00:16 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id g20sm11525253pfo.20.2021.08.21.21.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 21:00:15 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sun, 22 Aug 2021 14:00:10 +1000
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1/3] build: doc: Fix NAME entry in
 man pages
Message-ID: <YSHLymK2B06e6fEa@slk1.local.net>
Mail-Followup-To: Jeremy Sowden <jeremy@azazel.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210821053805.6371-1-duncan_roe@optusnet.com.au>
 <YSDNkNFOfdyOKXh2@azazel.net>
 <YSHFbmTDw1wb4Wvq@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSHFbmTDw1wb4Wvq@slk1.local.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi again Jeremy,

On Sun, Aug 22, 2021 at 01:33:02PM +1000, Duncan Roe wrote:
[...]
>
> Remarkably, the resulting tarball includes doxygen/build_man.sh even though
> there is no EXTRA_DIST entry for it in Makefile.am.
>
Just noticed - you put EXTRA_DIST in doxygen/Makefile.am

Cheers ... Duncan.
