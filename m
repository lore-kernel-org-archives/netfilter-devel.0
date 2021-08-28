Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A4FC432BE
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 19:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F74C60EBC
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 19:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhH1Tq1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 28 Aug 2021 15:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbhH1Tq0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Aug 2021 15:46:26 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08179C061756
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Aug 2021 12:45:36 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id z24-20020a17090acb1800b0018e87a24300so7347281pjt.0
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Aug 2021 12:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=9RoHMWpwoFssFUtKh90rwx4mZJH8zeQLNRRUtRNHe4Y=;
        b=Oxn4sHlRdP20AejXKxMlTQiaWkF94hyQHcUaiuUzUUKP6PzlOiiamP6RLrP/PGLgne
         sw2YM6+NW0g299Abo5qPfr0kTVcABoWFB2S3qQuqsCE6rxdMTLd5aM+d5oVM5SyXqgJc
         vfiTSdVoVF5PTSw9XcegWqBPM01Ov3QrGBG1WaZF5fMfqm+NFyDYDUdG+6ug9UN9P5FA
         Q/hd5kknO0VXODL2InZAF/wy90qLVJme+yQBNLw7QnPCoZ5FGSKfLRA4Utc+KVtTrcKc
         zPTWHZrv+iCynrrcqN4cm8DyZgaAUxjm7fa5fZXQIsclKLh3/e8BO1NJUOsdL3GZmkgg
         /AzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=9RoHMWpwoFssFUtKh90rwx4mZJH8zeQLNRRUtRNHe4Y=;
        b=NqgW5meMmCRzUL6wKSE6A2hecEAKVmdjPjcjLCkIoqc0uFAUJhIqbJMhNprMvPrmax
         Zp8UxyzszHq65HcQxhJ8B+06/EKdPaBSqoJiaXZ5XDGmTDqXE68R6YtPVIp3fEI9pvcS
         RWHmaaH3YDSrjr/xlIUuHIdA6lSYIBaRNEOvfTAWZl/9zOb0LN1bVenjhGTbfrAYnRTJ
         97+A1WUEZmzzO28svfx/h4HHL1aGe/2mojfPIG0O//Cw81TmkEEtshHLJ3Y4e+T/Zq/v
         y8oGa5/YgEwXV4pgiLCxjvJAp96dA2NHfKz8hvjedptLT7IIiRJOwgCMqGft3pD58uIr
         zSDg==
X-Gm-Message-State: AOAM530uZaWTd3yp/xJ/vlR3tBNgdK/IuFcaHYRp881rakWm0W2yMFkf
        4KnnDRjekZnVRMxqnHgr+obWlh6dKQI=
X-Google-Smtp-Source: ABdhPJxT/4wSJI+RGs6jEGMYDt0Hhq2AnNvGzGPmWXfu8Cf6rRLa/jZKk7DU2e6iYF4OHv5EtwFGlw==
X-Received: by 2002:a17:90a:4409:: with SMTP id s9mr18005865pjg.125.1630179935383;
        Sat, 28 Aug 2021 12:45:35 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id v23sm9938021pff.155.2021.08.28.12.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 12:45:34 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sun, 29 Aug 2021 05:45:29 +1000
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: libnetfilter_queue: automake portability warning
Message-ID: <YSqSWaXwzRhhwCk9@slk1.local.net>
Mail-Followup-To: Jan Engelhardt <jengelh@inai.de>,
        Jeremy Sowden <jeremy@azazel.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <YSlUpg5zfcwNiS50@azazel.net>
 <7n261qsp-or96-6559-5orp-srp285p4p6q@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7n261qsp-or96-6559-5orp-srp285p4p6q@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 28, 2021 at 03:39:38PM +0200, Jan Engelhardt wrote:
>
> On Friday 2021-08-27 23:09, Jeremy Sowden wrote:
>
> >Running autogen.sh gives the following output when it gets to
> >doxygen/Makefile.am:
> >
> >  doxygen/Makefile.am:3: warning: shell find $(top_srcdir: non-POSIX variable name
> >  doxygen/Makefile.am:3: (probably a GNU make extension)
> >
> >Automake doesn't understand the GNU make $(shell ...) [...]
>
> Or, third option, ditch the wildcarding and just name the sources. If going for
> a single Makefile (ditching recursive make), that will also be beneficial for
> parallel building, and the repo is not too large for such undertaking to be
> infeasible.
>
Certainly naming the sources would work.

But, with wildcarding, Makefile.am works unmodified in other projects, such as
libmnl. Indeed I was planning to have libmnl/autogen.sh fetch both
doxygen/Makefile.am and doxygen/build_man.sh

If the project ends up with a single Makefile, it could `include` nearly all of
the existing doxygen/Makefile.am, and autogen.sh could fetch that in other
projects.

In any case, is wildcarding incompatible with having a single Makefile?

Cheers ... Duncan.
