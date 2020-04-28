Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CDD5C83002
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 00:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0877A2072A
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 00:27:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a4hslxXu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgD1A1B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Apr 2020 20:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726343AbgD1A1A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Apr 2020 20:27:00 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCB8C03C1A8
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2020 17:26:58 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id s5so19575044uad.4
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2020 17:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aVm1gpcpFStUCDT+oKx9coiaG2gmHKxfnSyXwD+SiSQ=;
        b=a4hslxXuL4ce61msEBElNdxikXyDLQs7aDv/kdiO2ux4/wiZ51BLcbqNKYFRdB6PZA
         EVbRnRyy0J7VlBFMIV+C3VAmF4MavBSEfir6Wzk5eiB7APVTY2CtmdYdgfNtM/PdOBY7
         6kx7bbRF6kZK3mumQIngza1fVbweWU8irlzhoabuGNHNK6nIOFTXdFhMiQuE+CxEwNey
         4xybzZUeWQw1dZM3AsunF1EpKhN9mPBCfx7E1TAfD0IFkO/CLSAO6IgL4L5mqvEd4N7X
         3Cb6+2x4vvB+u8df43BGjFAldnmMluqrvW5dOf5bnsxbDQSdiEYODbcZF7eu6CIbsKQo
         kVMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aVm1gpcpFStUCDT+oKx9coiaG2gmHKxfnSyXwD+SiSQ=;
        b=eEM16jqsiconHQ5o5tBJk1MIGN5aG9x3JU3PRWAAfGmeQrozSUKW9ri7i6Oj3j26GM
         G0xtDq+rQ2x5Ap8nlMp5MPY3/+b5QaY3lyVo81gkovLjqIGxO5ON/EX3r4Kd4E1Eon1E
         0+AvYwpED+HMZmiv+LMD9Pb7/7+dxecQNXuXdPJO5YxSDfZMboa9r+6iFC8OaWYIMDxE
         jopZZ7UavaB2MsE4PqalomaacL5xODNmUfkmnyv1oVWxoXPfkZ6WDCJeiDZxwh6vApF0
         JTmmM5wBSuaCwaNjZjxFj3iSZj5Pj9qLWlqio4gwfdrKZcbG2pkSVbp8danvIOJlzY6f
         nJdw==
X-Gm-Message-State: AGi0PuZXUODuqJJyo/5MSsasYPkmOui6fPHkPWUkh9ZyEKfaftx8RvK/
        7jgC5T+oqZRzRtM8BCdyyyGvaP97O7RD2oMVny9KsQ==
X-Google-Smtp-Source: APiQypL+lHJ1K3hpOM0nwpSINXljZgoVMSpJUBp8tOJXvqTx3PtuUHGBvcqbTIp3cD15BJfxix5QVFwPhhqVlsF61cc=
X-Received: by 2002:ab0:4162:: with SMTP id j89mr19390916uad.23.1588033617357;
 Mon, 27 Apr 2020 17:26:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200421081549.108375-1-zenczykowski@gmail.com> <20200428000640.GE24002@salvia>
In-Reply-To: <20200428000640.GE24002@salvia>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Mon, 27 Apr 2020 17:26:44 -0700
Message-ID: <CANP3RGewkX54pqZtironHRCrEYdMF2FZLdKzJz=4GU2CgC=1Mg@mail.gmail.com>
Subject: Re: [PATCH] do not typedef socklen_t on Android
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I don't know all that much about it.  Mostly it just seems to work.

I'm quoting from: https://en.wikipedia.org/wiki/Bionic_(software) ;-)

Bionic is basically a BSD licensed C library for use with Linux.
This differs from other BSD C libraries which require a BSD kernel,
and from the GNU C Library (glibc) which uses the GNU Lesser General
Public License.

For the most part it's supposed to be drop-in compatible I think,
and the kernel headers (uapi) come from some recent version of Linux.

The license and smaller size are AFAIK the main benefits.

---

Got me curious and:

I'm not actually sure what defines __ANDROID__, maybe __BIONIC__ would
be a better guard?

That seems to be defined in bionic/libc/include/sys/cdefs.h

https://android.googlesource.com/platform/bionic/+/master/libc/include/sys/cdefs.h#43

And the docs here:

https://android.googlesource.com/platform/bionic/+/master/docs/defines.md

do seem to suggest that __BIONIC__ is more equivalent to __GLIBC__
