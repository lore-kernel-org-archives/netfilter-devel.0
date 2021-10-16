Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D5EAC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Oct 2021 07:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 143E961101
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Oct 2021 07:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239770AbhJPHaJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Oct 2021 03:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbhJPHaJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Oct 2021 03:30:09 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B309EC061570
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Oct 2021 00:28:01 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so9016138pjb.0
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Oct 2021 00:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=C5N7jPrEL4k555xoi4F/66bdo6CBNmypUIIuoQgOBHk=;
        b=kNhF+m8Obk4JVWdUfIUuCHFva2LbrSiclNS5r7jEXzeDouN98Jek5+yCWM4sUVnoi+
         4g3psYk2B6WwlWh0Yb6i/kWFJRpVz5flCeyO1WLZlKo/pK9J/FIiSVxqTDOQ2QrUY8Mu
         8isVY8cfyJlRltztmMOipFzKrHTaVE9UaNfmMPgT0qenGakuhj6EXYOdlFnyWypD66fX
         J4qlqplZsI7XrxGp7S6f1VTeo9KeO3cOzAat1VS9Qgd8ZQrY0M/Zi3/eryvx/HPM0oXs
         YTj9qcAmwQmPVdCSb9ybgRrMCozCboCjBI+O/gTXPL0n1IfnkX3LZlzDiwjUKt8NjzAb
         HRyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=C5N7jPrEL4k555xoi4F/66bdo6CBNmypUIIuoQgOBHk=;
        b=HLTIEAYE2Uz2u1OGKAQXLmJex+qPkPsuoUO73iwz2mc/rR/K/Y6qIelyBL7GKiCCXo
         D2fa4mdL3RVEy3dYih+rdIkSm35ZlssfxygwLiogTtoQYN7+Cdr2h0vpewMIvDKWmkRm
         k//d7vs+zwJfRDfB+RWDNQ8oJzlnt8O1wiLL2NUcjbubUrarN/DudRs1s5PIF8FQ0MEr
         yQEdKesb4XSkFF2JyxWq53SqEgefnqKtlF87I9xidjbljkKe3RjsL4h59EGGkIsKr9Dw
         quNslwobYKaFcf93T6WkFRgu2JU/tkwv98ZJoEUcbPAuAjCK4/OG2BKDdJ1l4F29bQ3u
         JHqA==
X-Gm-Message-State: AOAM533bB7MYj09Ub8WOnrZCpT5pSuZMl8wPLEpGlwXSKOn4v5UdX9Pa
        rCIcHqfobjjsQk7V7t/3enh93swT8tw=
X-Google-Smtp-Source: ABdhPJywIVy2q/JDJIh3HDLIxmwEj5DYJ/FmW2YXFlR+oWeSsmpf/wwDkLXOtGuA4jyEzUkUjaa+/Q==
X-Received: by 2002:a17:902:e843:b0:13f:2212:d64c with SMTP id t3-20020a170902e84300b0013f2212d64cmr15323069plg.16.1634369281131;
        Sat, 16 Oct 2021 00:28:01 -0700 (PDT)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id y22sm13071804pjj.33.2021.10.16.00.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Oct 2021 00:28:00 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sat, 16 Oct 2021 18:27:56 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_log v5] build: doc: Allow to specify whether
 to produce man pages, html, neither or both
Message-ID: <YWp+/MO6jhvgUdGM@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20211016043948.2422-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211016043948.2422-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Oct 16, 2021 at 03:39:48PM +1100, Duncan Roe wrote:
> - configure --help lists non-default documentation options.
>   Looking around the web, this seemed to me to be what most projects do.
>   Listed options are --enable-html-doc & --disable-man-pages.
> - --with-doxygen is removed: --disable-man-pages also disables doxygen unless
>   --enable-html-doc is asserted.
> If html is requested, `make install` installs it in htmldir.
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
> v2: broken out from 0001-build-doc-Fix-man-pages.patch
> v3: no change (still part of a series)
> v4: remove --without-doxygen since -disable-man-pages does that
> v5: - update .gitignore for clean `git status` after in-tree build
>     - in configure.ac:
>       - ensure all variables are always set (avoid leakage from environment)
>       - provide helpful warning if HTML enabled but dot not found
[...]
Sorry Pablo, this is for libnetfilter_queue.
I don't see it in patchwork - did you get rid of it already?
Will re-send with correct Sj.

Cheers ... Duncan.
