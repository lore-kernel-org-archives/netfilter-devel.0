Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B8B2C432BE
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 03:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62DE960F5B
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 03:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbhH1Dch (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Aug 2021 23:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbhH1Dch (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Aug 2021 23:32:37 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD32C0613D9
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 20:31:47 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id r2so7648500pgl.10
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 20:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=0gNK85B9QyAL+omwX3m/JTaXpsiCGt4569mZ3w/Fr9U=;
        b=D6WvzjFZD/DMAng5M/juk9i5a5VmFLB+3Jb7ZzFxac9mkoDH7SOpPk3JWHpJDrGojb
         E4fPKdDWUpCWu51KWtnFCiyt7ugIa+M9PatjlnajMglZPLoq05gP5Ml3tMHhOOAFqLY6
         NH+u+3imv8zr90NL5+bPLv3BzonFpdkgP+OScT+P7QzyYOdiKpbl4Z7xU3XheU60hHNU
         APrY5Vreq64hoBTvl5tKqZP4lbIl6UbABw3tbPbZhm+nJQlo+mbLHLJKbcjWhLc+yiSY
         3z9FcNhQI+8hGuQfadRYe+aIwvVPhS/WEMYhz+8xHU1oRF9qrIHv0IjWd6OUppp1CvvJ
         Ag4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=0gNK85B9QyAL+omwX3m/JTaXpsiCGt4569mZ3w/Fr9U=;
        b=rIewYzX/xOpGJTQLOKY70hMBvjMWFgw37VC8Ia2SseW2+DR7MhSqHy30kxx13ipjX7
         sOwpPVu7F9meX8xCSJOCX4/BTL/Kp3E25G0jjYsVAMnLq6ifke+ozOauNCKITfVP8nZD
         i8ughNTfTLN5wQ5jTFUqO6tP7LCtvNJMsiEh0yIIwjFVv2wv0fMeZtkbKXEK8x7vNOGT
         gEHhlAXN1WSO0ZrVohi2gOb+D6Fd2UP2pJ/VYcM5qZbzzLsvQDbomPJ2iHthqBZWoM+v
         0qGJGhsUbs4boYlq1A6X0ssZ4I+Ns7nqM02o1b+HdEtqEtg8K8jkvEv2iyLSirhdd/nV
         LRcw==
X-Gm-Message-State: AOAM533uYJlgUbBatNASawF2FNGjMIGV/rXn3DJuZEym1F1s1eCGCE5c
        pEzeffjLOt66QP4eWQF7/mxLae19jz4=
X-Google-Smtp-Source: ABdhPJzji60yoJeAy0OwbTkLaUAt7swmazzSCjwPgeezDfxjeIj8MngTMCAUGDci9Ccg118KRlP3Mg==
X-Received: by 2002:a62:cfc4:0:b0:3e1:bd85:9b63 with SMTP id b187-20020a62cfc4000000b003e1bd859b63mr12237279pfg.46.1630121507379;
        Fri, 27 Aug 2021 20:31:47 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id j11sm7575085pfa.10.2021.08.27.20.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 20:31:46 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sat, 28 Aug 2021 13:31:41 +1000
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: libnetfilter_queue: automake portability warning
Message-ID: <YSmuHXXVTYnFm6Yw@slk1.local.net>
Mail-Followup-To: Jeremy Sowden <jeremy@azazel.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <YSlUpg5zfcwNiS50@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSlUpg5zfcwNiS50@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jeremy,

On Fri, Aug 27, 2021 at 10:09:58PM +0100, Jeremy Sowden wrote:
> Running autogen.sh gives the following output when it gets to
> doxygen/Makefile.am:
>
>   doxygen/Makefile.am:3: warning: shell find $(top_srcdir: non-POSIX variable name
>   doxygen/Makefile.am:3: (probably a GNU make extension)
>
> Automake doesn't understand the GNU make $(shell ...) function and tries
> to interpret it as an Automake variable.  The Automake people would
> probably say we shouldn't do that 'cause it's not portable:
>
>   https://www.gnu.org/software/automake/manual/automake.html#Wildcards
>
> However, if we accept that we are targetting GNU make, but we want to
> get rid of the warning, I believe there are two ways to do so.  We can
> tell Automake not to warn about non-portable constructions:
>
>   diff --git a/configure.ac b/configure.ac
>   index 4721eebbab1f..7cd34d079e67 100644
>   --- a/configure.ac
>   +++ b/configure.ac
>   @@ -6,7 +6,7 @@ AC_CANONICAL_HOST
>    AC_CONFIG_MACRO_DIR([m4])
>    AC_CONFIG_HEADERS([config.h])
>
>   -AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
>   +AM_INIT_AUTOMAKE([-Wall -Wno-portability foreign subdir-objects
>           tar-pax no-dist-gzip dist-bzip2 1.6])
>    m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
>
> On the other hand, if we want to suppress the warning for just this one
> GNU-ism, we can hide it from automake:
>
>   diff --git a/configure.ac b/configure.ac
>   index 4721eebbab1f..b2b54d3168ad 100644
>   --- a/configure.ac
>   +++ b/configure.ac
>   @@ -56,6 +56,19 @@ AS_IF([test "x$DOXYGEN" = x], [
>                   with_doxygen=no
>           ])
>    ])
>   +#
>   +# Putting $(shell ... ) directly into the doyxgen Makefile.am confuses automake,
>   +# which tries to interpret it as an automake variable:
>   +#
>   +#   doxygen/Makefile.am:3: warning: shell find $(top_srcdir: non-POSIX variable name
>   +#   doxygen/Makefile.am:3: (probably a GNU make extension)
>   +#
>   +# Instead, we use autoconf to substitute it into place after automake has run.
>   +#
>   +AS_IF([test "x$with_doxygen" != no], [
>   +  AC_SUBST([DOC_SRCS], ['$(shell find $(top_srcdir)/src -name '"'"'*.c'"'"')'])
>   +])
>   +
>    AC_OUTPUT
>
>    echo "
>   diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
>   index f38009b24114..6ed30e21ff75 100644
>   --- a/doxygen/Makefile.am
>   +++ b/doxygen/Makefile.am
>   @@ -1,6 +1,6 @@
>    if HAVE_DOXYGEN
>
>   -doc_srcs = $(shell find $(top_srcdir)/src -name '*.c')
>   +doc_srcs = @DOC_SRCS@
>
>    doxyfile.stamp: $(doc_srcs) Makefile.am
>           rm -rf html man
>
> J.


Thanks for the suggestioms. I strongly prefer adding -Wno-portability to
AM_INIT_AUTOMAKE.

The alternative patch is longer, and IMHO less clear to follow. Also it's
error-prone - consider this line:
> AS_IF([test "x$with_doxygen" != no], [
The test needs to be one of the following:
> [test "x$with_doxygen" != xno]
> [test "$with_doxygen" != no]
> [test "$with_doxygen" = yes]

I'd like to get rid of the warning so will send a v3.

Cheers ... Duncan.
