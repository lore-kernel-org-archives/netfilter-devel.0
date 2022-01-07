Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08D1C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jan 2022 00:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344394AbiAGA5C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 19:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiAGA5C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 19:57:02 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6ED4C061245
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jan 2022 16:57:01 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id ie13so3859889pjb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Jan 2022 16:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=HB0/gysX4bJht0YzqkNU9uBNK4vTsPDzVkq0iihTmHE=;
        b=Z97aKyZJVOsm3f4r53wvFFif/dOf/sq6zjluwvrPxdRndPwPi+4pOkiIspMrYv6TNl
         wIQvtvWRXLpMCTH0r7s6EA123bfJWFe6+q3lUKcAx/6gyKyStqV2sVSAXToT6ehqYdRg
         2eCY1eqmw57I+2ZYH+kk7qQAlUtnqltbnDyZYxV0R9eSTGlH7/r6VYiIziFOPSc/8j9l
         kn1ZsCSSjC5M2/z1K1H/5HnOxiBp87aybfo0XbDP86t9OrOSGTsMsokClWmfbFMcDcMp
         neiEuGXl/R0PQAGZ1a+XJlxtGZQdMRcV+Bw9sh1iT4T+k5rNZG0GgqZ5hYNNL3/1fzpp
         sAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=HB0/gysX4bJht0YzqkNU9uBNK4vTsPDzVkq0iihTmHE=;
        b=qwES0m8fSMFBGYU88Kfj2/D6E7hJgR9gCvZHZEsOsLkvVPXSvhGJzMQLRyX1q8t7/1
         3UCTDuRq5GnBdXrTQmu1ek/Ibq71FdfktKjsAVFZqc534FCpb2A+orRvxLyZdztW63wh
         7rVBEMqiuM6jtEwzxBPMATutLTKLs994LmmMQljYiZctCnDxgldvRZjzeGFVnf7vSbQm
         Pkl5FZkwvGn0HN3wgrtuZc3NLpe3xo1jJ2Z9viutSHjGoXUNrtK+2Qn9ZVu7zOthm7eA
         Hsfgktu9Ie03F3OsF/f1ydnVx4DGzekOskRGIjH7VhbYKongZjCaMcb/1YFDHcObnIdK
         nloA==
X-Gm-Message-State: AOAM533mvUafePgGDER7H3Atw8+IFLjURt6bdbK92ny5W9zCGMHWyRGl
        bire2pHPc77JMl6svMfp4BWgkPPdRb0=
X-Google-Smtp-Source: ABdhPJxvjdZLhOJlLoGLSdGJ6ah0dRaHRXPkQv5A9+nPGQEfRSq/HoOHeMRcDO81edn7SxgMl1cnWg==
X-Received: by 2002:a17:90b:4f86:: with SMTP id qe6mr12907907pjb.120.1641517021481;
        Thu, 06 Jan 2022 16:57:01 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id h15sm3852209pfc.134.2022.01.06.16.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 16:57:00 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Fri, 7 Jan 2022 11:56:56 +1100
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 03/10] build: use pkg-config or upstream M4 for
 mysql
Message-ID: <YdeP2OVfXUE5o4u3@slk1.local.net>
Mail-Followup-To: Jan Engelhardt <jengelh@inai.de>,
        Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20220106210937.1676554-1-jeremy@azazel.net>
 <20220106210937.1676554-4-jeremy@azazel.net>
 <q6p24q-47r9-p184-69s7-165p7264o123@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <q6p24q-47r9-p184-69s7-165p7264o123@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 06, 2022 at 11:15:31PM +0100, Jan Engelhardt wrote:
>
> On Thursday 2022-01-06 22:09, Jeremy Sowden wrote:
>
> >Recent versions of mariadb and mysql have supported pkg-config.
>
> (This made me read up on Stackexchange about exact rules for present
> perfect, only to find it is not neatly delineated.) IMO better to
> just use present. They (still) support pkg-config.
>
+  dnl Recent versions of MySQL and MariaDB include pkg-config support.
>
>
Suggest imperfect past tense, to match "recent versions" suggestion.

+  dnl Older versions included a mysql.m4 file which provided macros to
>
> "had included", as I don't see that m4 file anymore on my (mariadb) systems.
> (There are a few mysql-related m4 files in autoconf-archive,
> but that's not the same package as mysql/mariadb, I suppose.)
>
> >+    dnl The [MYSQL_CLIENT] macro calls [_MYSQL_CONFIG] to locate mysql_config.
> >+
> >+    _MYSQL_CONFIG
>
> One caveat of m4 macros is that they may be left unexpanded if not found,
> and it is up to the tarball producer to ensure the m4 macro is expanded.
> Over the years, I built the opinion that this is not always a nice experience
> to have.
>
> I would do away with _MYSQL_CONFIG and just attempt to run `mysql_config` out
> the blue. sh failing to execute mysql_config, or a compiler failing to find
> mysql.h as part of AC_CHECK_HEADER is a nicer experience than _MYSQL_CONFIG
> being left accidentally unexpanded.
>
> >+      dnl Some distro's don't put mysql_config in the same package as the
>
> distros
>
