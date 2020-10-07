Return-Path: <SRS0=fUKQ=DO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06DF6C4727F
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Oct 2020 06:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A02A208C7
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Oct 2020 06:28:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JHSnXSr7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgJGG2Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Oct 2020 02:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbgJGG2O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 02:28:14 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB89C061755
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2020 23:28:13 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id g7so1132184iov.13
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Oct 2020 23:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u223+82v0+23KsIel4VnqhFRMivPDkIby33C7AFFGxU=;
        b=JHSnXSr7wEHCUGwdvioJCokfDUyzk9fDDdXZGod7tH0NiB7m4Q8m5x6YZrLz5UbSUU
         JT2VVJk2bXG0wiJiw/DR4n9+ehpKvtj1NI1YSNh38nWYV8FPqizu7Tj8pBl6Uax4TILv
         bqPhtxWspLxx1sSloJr9r3weMu50JK9L0jdHWoYQUi7W1rEihHaM+uMWdCvGn26DswyR
         Di2+/GhOIir0k7mDIK4lb0CY/88aXtuVH4QfhqCtvOZG1nTBOdXGcvIhEtQM8W0kxAx2
         xqHt5sXWI93/cbC7aiSTAOn5touK9xyyT4PzqvhM5XV9IwEu5nEFTRBWKuEXQg1/0i1X
         NFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u223+82v0+23KsIel4VnqhFRMivPDkIby33C7AFFGxU=;
        b=loT7ytvakXd073HojV6WJiwRSwuwdtdswGoM0Z7S8bnZ8IB4HGI08hlmolqy+Av4vj
         SN3ycOUmsULwtabbsb08/VVrloREqDuHwbH/5ewE8A+rtpvGyj4iDXoBE7fylOez2urD
         Wx/LkN9qYlJdRvecFmra0keGXpTOJVDthaHL+p3mLbCjxVycBK58lW1TRqk/znmHa6Fe
         Unk3ru2a9eEgjT7UhJT9VSqUNnNu3vrownpxEBujIqmsRq7628URrX2FRHDJfBIvk1sH
         sf7er8LveMnZPUpI289pQcXahMAElAc/h7QE3rBDM4PcANypOumpO+qYK6R9Z47999hC
         mk8g==
X-Gm-Message-State: AOAM533M7yYbB3RnpMMIrQRODOsFojRRb5FyhU7FWKNwENQ6AYm24yp/
        F9tKjwYGs0MADxjwwzYqU3aXW+KCGMifO6cUU1M=
X-Google-Smtp-Source: ABdhPJy36DO4L5mi/HLdxAWQ/PHX1N6mfg6/Fz46p0J5NWS0XrQbeZA4+60F1gMyYF8JDIKqBGIAz+/n0TQo9eE/C0g=
X-Received: by 2002:a05:6638:210f:: with SMTP id n15mr1534705jaj.41.1602052092281;
 Tue, 06 Oct 2020 23:28:12 -0700 (PDT)
MIME-Version: 1.0
References: <20201003125841.5138-1-gopunop@gmail.com> <2c604efb-39a3-41de-f0a6-a44c703a20df@riseup.net>
 <CAAUOv8iAPJm1mTPjFamEVQAOh1y-ahExN_+4Pk2rPkELwyxBEw@mail.gmail.com> <b9e9fb11-1bb4-065b-4e64-f10665820606@riseup.net>
In-Reply-To: <b9e9fb11-1bb4-065b-4e64-f10665820606@riseup.net>
From:   Gopal Yadav <gopunop@gmail.com>
Date:   Wed, 7 Oct 2020 11:58:01 +0530
Message-ID: <CAAUOv8gV4CZ9PZiRSkdg+acY1r7CPofpjUjZ72f6XdWfeiAd3w@mail.gmail.com>
Subject: Re: [PATCH 1/1] Solves Bug 1462 - `nft -j list set` does not show counters
To:     "Jose M. Guisado" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 6, 2020 at 7:15 PM Jose M. Guisado <guigom@riseup.net> wrote:
>
> On 6/10/20 14:42, Gopal Yadav wrote:
> > Should I always run ASAN before submitting patches as a regular practice?
>
> I usually check for leaks when submitting patches, using either ASAN or
> Valgrind.
>
> > json_object_update_missing_new() was raising a warning so I have used
> > json_object_update_missing() in the updated patch.
>
> I've been unable to reproduce said warning when using
> json_object_update_missing_new.
>
> You need to use the *_new function, because it will call json_decref on
> tmp for you. If not the reference to tmp is leaked.

Since on using *_new() build fails, should I call json_decref(tmp)
explicitly after json_object_update_missing()?

I couldn't get ASAN to run, but I ran valgrind by doing `valgrind nft
list ruleset` on both versions, with & without json_decref(tmp). Both
of them produce the same output which says no leaks:

==5967== Memcheck, a memory error detector
==5967== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
==5967== Using Valgrind-3.13.0 and LibVEX; rerun with -h for copyright info
==5967== Command: nft list ruleset
==5967==
table inet dev {
    set ports_udp {
        type inet_service
        size 65536
        flags dynamic,timeout
        timeout 30d
        elements = { 53 expires 29d6h14m26s268ms counter packets 0 bytes 0 }
    }
}
==5967==
==5967== HEAP SUMMARY:
==5967==     in use at exit: 0 bytes in 0 blocks
==5967==   total heap usage: 78 allocs, 78 frees, 390,728 bytes allocated
==5967==
==5967== All heap blocks were freed -- no leaks are possible
==5967==
==5967== For counts of detected and suppressed errors, rerun with: -v
==5967== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
