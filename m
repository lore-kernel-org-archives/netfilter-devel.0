Return-Path: <SRS0=w/jS=XG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29965ECDE20
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Sep 2019 07:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDC0E20CC7
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Sep 2019 07:34:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TpP2o7Fb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfIKHeQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Sep 2019 03:34:16 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38556 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbfIKHeQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Sep 2019 03:34:16 -0400
Received: by mail-yw1-f68.google.com with SMTP id f187so7471412ywa.5
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Sep 2019 00:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=mPJRcjILWuRh38r+TonVa8/b5dgY7i1apvX13EsC4Gs=;
        b=TpP2o7FbJhg//ODBGqj/BpLwFPBm+tmP2j7GNRzTREBEEmyyMmyG1Gepz2jDtOMmMg
         e2eaKl4K06QKs90Zfq30v4Dp607arLThRjAy+vg0L5hxdxE0n8jUo7ZMQ/PuOW/g9VdG
         2YXcczfOl5uopkh0c/F5Fv2lQz90+GVVApbBcpJk6vz0xkS4Xyz8Gmtzyf+bSDJsnzrd
         klt5rBLkYt6pqCgF72P1F9JNX45QrCKgyrLBDTN6ZDZkAUMAcZI5zi69atKXqYKow4hM
         qOttNJY4Qj0wd2uMuE7qif+gadw7M0t8+ROdAGF1xv0F7EqCHA3bce+oh0/Bjxg++hU7
         lNgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=mPJRcjILWuRh38r+TonVa8/b5dgY7i1apvX13EsC4Gs=;
        b=Lr4UQ/VH2aHjnzshM02I7u6I0MlwoM4yKjgCljyCCxIC5dJjBETmmDGF0/pahm4keE
         exTWg1ZPdA5Bi54eAsAEYiFsjIGQyeWuu5KhGEjRkTv9jsbJXwlbYh7xRYGGzYL5gTu6
         Temhr6D56HTj8PizoVnFYu5zLKUA3fYqpfECakl0wcmb68VibFNGf1Y8p1m0uS2mkEV8
         iwX5UcyGpSrkgX53ibqVjJBXT1SSLElXUpYhAlF/nYx/xDWDmiQ5V/cV+yU65qY/ngtZ
         RJTCqVHZOAiKI/xfvwe7aYU3L6RHNRmzmZMMPVgxgpLhmQKLIRn+PfZJQ7hff7bSjDDz
         Cazw==
X-Gm-Message-State: APjAAAUpjko8MFEQJTwJD8pZO1q+knDz52AE2ESLaZp+7rU9JfroveCk
        4oPd41BXzC1RxQEvrjLnPoiqYRIvEEVl6x0TWtNl5COjWKQ=
X-Google-Smtp-Source: APXvYqzhIEmliOLXhoqvFt7aWtivdAIquSUmDqF7uYEpdx3VM/PylgS3mfE4IwGKfT5Y0FTAbNzqrGbQmKd7TtzMCQY=
X-Received: by 2002:a0d:d507:: with SMTP id x7mr23950736ywd.509.1568187255304;
 Wed, 11 Sep 2019 00:34:15 -0700 (PDT)
MIME-Version: 1.0
References: <CA+fnjVBoZ4k4K0VXVAAjiVknts0=RJADEJ-dB1Xbdq6MVG9eQQ@mail.gmail.com>
In-Reply-To: <CA+fnjVBoZ4k4K0VXVAAjiVknts0=RJADEJ-dB1Xbdq6MVG9eQQ@mail.gmail.com>
From:   Fabio Pedretti <pedretti.fabio@gmail.com>
Date:   Wed, 11 Sep 2019 09:33:39 +0200
Message-ID: <CA+fnjVA6whur_m8jcCmCpQfWUhETXyz72zt4M829Btnrqyw__w@mail.gmail.com>
Subject: Re: iptables release
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Debian also has some patches that may be applicable upstream:
https://salsa.debian.org/pkg-netfilter-team/pkg-iptables/tree/master/debian/patches

Il giorno mar 10 set 2019 alle ore 20:47 Fabio Pedretti
<pedretti.fabio@gmail.com> ha scritto:
>
> Hi, is there a plan to push a new release of iptables?
> It has some fixes which are routinely reported in distros having
> latest stable release 1.8.3.
> Thanks
