Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598A4C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 01:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41ACB60F25
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 01:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhHYBW1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Aug 2021 21:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbhHYBW0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Aug 2021 21:22:26 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016D7C061757
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Aug 2021 18:21:42 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a21so19888318pfh.5
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Aug 2021 18:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=npa9/1IaIp7C7kekdycz1l+E9CvQ/hDmdbtPxdf48Hc=;
        b=j1GpbhuApqDXwYE0gWbfz3aVvSfTTQNhsm3LZwoaCKBBwbx+yWDX7Hc3FLEvYmqDUo
         nuCxpKzylcS0W6s3/ixiHHXSQJbFt5lG222tFiX3yZ4paqjh3CyrC+1/Uo9EVZBTqpVx
         VT+pTdPX0QOeRrpahFMpdBwJByHrGN53s3/CS6sr7JgjMS3WOzXexU1SMZEv/RYY9D/u
         vcHrV9yu9osLcLgUIZXVKPlEChepexGJO7kYpmQ0aH47faV7O2Zt7FfMBLF8mTSVvfxP
         cs7Aw0ehVMoCBVGFJtdnREAEjr8Y2sPlusoBeF2BoIg2DisClOCWyRhonWruwPrRQZLu
         XUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=npa9/1IaIp7C7kekdycz1l+E9CvQ/hDmdbtPxdf48Hc=;
        b=sQBnUo7+OOCN3lm1ldojR9EN9t4D7G4rlgPLb8GmOr46ju4oG4ee23zYyyV8E1mIYz
         g0rVpbMeUKm7K5xjx5ClmaASLndAcXW25akC41W9iFAsGFCOlRZRH4P3uBnJMblouYeC
         5YQOc9jZ9kaOCG8MKKSiNXfD/nbNEtjIte9r4ruovJj3jkI7Kp99TbalJi2CEwVG8g6F
         rsv0KCISRDYOo4IjRr3CM81CPAx0QE6s3YsdMPbVyYsDsOJOTv8EE10SE52b3EVwOjGR
         OSSQH8A41g2nIo8jJ5utrzTTu6eW5tStn9JwBz8KH3+Wb/TPI4nkPnX56FnZa1cODsPa
         rLNQ==
X-Gm-Message-State: AOAM530dBMuId/iemgEt+q+kERBrI7mmUnBv/pc0jbNPup1rMXPz3mUP
        lK68mym2d/tCIq1E4xt4rPE=
X-Google-Smtp-Source: ABdhPJxyuGPXUxTZK0UhwltU5vpbd+eqEqYRoIi7PzZ45E3/ji+FL1aBqcKoCgI/RnZBMsVaFEbLbw==
X-Received: by 2002:a63:b950:: with SMTP id v16mr39818551pgo.328.1629854501569;
        Tue, 24 Aug 2021 18:21:41 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id r8sm22876313pgp.30.2021.08.24.18.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 18:21:41 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Wed, 25 Aug 2021 11:21:36 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v4 2/4] build: doc: can choose what to
 build and install
Message-ID: <YSWbIAulHPwgcnep@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210822041442.8394-1-duncan_roe@optusnet.com.au>
 <20210822041442.8394-2-duncan_roe@optusnet.com.au>
 <20210824103001.GB30322@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824103001.GB30322@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 24, 2021 at 12:30:01PM +0200, Pablo Neira Ayuso wrote:
> On Sun, Aug 22, 2021 at 02:14:40PM +1000, Duncan Roe wrote:
> > Update doxygen/Makefile.am to build and install man pages and html documentation
> > conditionally. Involves configure.ac and doxygen.cfg.in, see below.
[...]
> > diff --git a/configure.ac b/configure.ac
> > index 0fe754c..376d4ff 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -10,9 +10,42 @@ AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
> >  	tar-pax no-dist-gzip dist-bzip2 1.6])
> >  m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
> >
> > +case "$host" in
> > +*-*-linux* | *-*-uclinux*) ;;
> > +*) AC_MSG_ERROR([Linux only, dude!]);;
> > +esac
>
> This update is unnecessary, please avoid unnecessary changes in your
> updates, it makes it harder to review.
>
My thinking was that we should check for running under Linux before we assume
that `test` is sane and accepts modern constructs.

Cheers ... Duncan.
