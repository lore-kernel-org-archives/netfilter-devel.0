Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 389B6C19F29
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Aug 2022 03:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbiHDDaQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Aug 2022 23:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiHDDaP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Aug 2022 23:30:15 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5379BC64
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Aug 2022 20:30:13 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id v16-20020a17090abb9000b001f25244c65dso3984195pjr.2
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Aug 2022 20:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc;
        bh=guLIMUdwuV5GvPy0OAqvFarUkyvMBx3mLzcnUVQtYec=;
        b=Q3wviX2GuNanje9NbUn7YEoalNBVLc6XcTRAuCPx7RoEoCUKfJV9Y6IZZpwmLsyJzR
         yNhU7DlN670dMljYUnxXip70hmE1ZuAW0xEJHHASs7qz5UnPEEOMf34Hv/YNm8l+Aa/W
         sZSV5obxYvqglVjlBcDdYqMh7+QwS4SYpfEt9w41yh7GvozeYYxNtkc1Ko/Xd2mPHOU8
         YAPa5TSUStfXzCvxZnQ8NBZC8LF8JGTuuCNLyFjhvKzEIbdqKKVSYUibpAim3ZiX4ZVp
         NTynpGalaPBVEKwndL1+u1ZQ+W4SEH3MjBhhKYFgaWZ17d4pD18tgBrolNK5xe1U9MN1
         xjCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc;
        bh=guLIMUdwuV5GvPy0OAqvFarUkyvMBx3mLzcnUVQtYec=;
        b=0mUPuvUZtpz/lPBLhvERsThKWM9tJqOdA1u8eHQpfx4lCtnlOZByQx1OligeP8Ls8H
         4nkmHQ8O/U3X0rVJYdwA3EXzv0IEVvI9C9wP8YXKU98OXpGG58yvO3fnhWNt7tpELPJo
         F0BVho4ewikEJHzRUorg4OWY6nT1rlGolTFxum11VDhX7T0OoS09HvCaOEOOrrD+iM0V
         s2ePBq2hQXB1v0qgRk0yGKGzrK6z935r+X/++Dx2NWfm0MD+G8MoeMs95zch8oO43b1o
         7Mq3Hoo9WEcbESkwUwpaaFD2QxmvScPnYZcInNisTzJe0Vobze40DWheWVgRaTxxWVXy
         KXLA==
X-Gm-Message-State: ACgBeo0KwGFoudgCCRD2KIWwqf3/C4BRCK1Wtq8VF6WP3M0qMVQ//bfb
        N55vGaUUCxv7VTuKm5Qi1Bc1UlJV9g0=
X-Google-Smtp-Source: AA6agR7A8fnNSPSPLgUSIRP6imuqGY8W9zUjiLQyPiEyNcgHYq+0S5y781elpFck1xLfsuwBrMtKwg==
X-Received: by 2002:a17:903:283:b0:16e:f604:1408 with SMTP id j3-20020a170903028300b0016ef6041408mr15637506plr.119.1659583812838;
        Wed, 03 Aug 2022 20:30:12 -0700 (PDT)
Received: from slk15.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id j15-20020a170902da8f00b0016db1b67fb9sm2852200plx.224.2022.08.03.20.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 20:30:12 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Thu, 4 Aug 2022 13:30:08 +1000
To:     Mark Mentovai <mark@mentovai.com>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl] build: doc: refer to bash as bash, not /bin/bash
Message-ID: <Yus9QHuk5Xr/29Xy@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Mark Mentovai <mark@mentovai.com>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20220801172620.34547-1-mark@mentovai.com>
 <YuhyM1TE7a/vTjFu@slk15.local.net>
 <2152a8fd-a06f-bad2-fbae-36828e4919a@mentovai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2152a8fd-a06f-bad2-fbae-36828e4919a@mentovai.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 02, 2022 at 02:14:29PM -0400, Mark Mentovai wrote:
[...]
>
> The context here is in OpenWrt,
> https://github.com/openwrt/openwrt/commit/beeb49740bb4. The use of /bin/bash
> is a problem during a cross build of libmnl, with a build system running
> macOS or BSD. /bin/bash on macOS is an unsuitably old version, and the
> OpenWrt build ensures that a recent bash is available in PATH. BSD
> derivatives tend not to have /bin/bash at all, although bash may be present
> elsewhere in PATH. Again, the OpenWrt build ensures this.
>
> I would not expect the same treatment to be strictly necessary for scripts
> like libnetfilter_queue or libnetfilter_log, which run on the target system,
> but the reliance on /bin/bash is a problem for cross builds and in
> particular non-Linux build systems. Considering that these cross builds are
> otherwise perfectly clean given an appropriate toolchain, it seems
> unnecessary to leave them broken for something like this, when a simple
> reliance on locating bash via PATH ought to suffice for everyone.
>
> Mark

Good enough for me - I acked the original patch.

Cheers ... Duncan.
