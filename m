Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D711C61DA4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 16:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjBVQWN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 11:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjBVQWM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 11:22:12 -0500
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C725423874
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 08:22:11 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id bp25so10893055lfb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 08:22:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WBW1mHLE1KzcJHrqHcBhO5cSjsVzAN4or/HFcGfx7Qo=;
        b=mDPKsLDZPNvBD2zRxxN1C38t9a4FsH+TojNGX6Bc6pBtHQQkF80dPC6Q9Q1s5actL4
         lpVRSF9Q60t7G1eCqi/KfO3iYjLBZ2fvdJl/aqY5OtPZTaZ6tbNahUs6dDmsU3R9Ignf
         Iu6hLpLul7qZN40KMSCrh+6LN/7G7XsnoGJil8mBToBi4R/L2tw0JzEJpsljpHIPgTMS
         xfRyYv2JkOF4UjReGudOKzQyhx4GgK9dJLKUkEsHCbuv55tRl/W/otuO8ARCx1vVwXJk
         SF8Cv59c5YDc0uhrU+VsIgYGNPi6N0M60t9b7Chps1AYAQFbu30rjQNvYbZhmbbrcsGF
         4ueQ==
X-Gm-Message-State: AO0yUKXeNIO1Mp1rl2hDm9cfi6H6RnAVrpNRTfHAcmgC1kjvHgPS9Yej
        yr2sr8/hlewBtDjiyD/Tx92qOD8aLjgdKoHe
X-Google-Smtp-Source: AK7set/NDdOzP+c09pSyAixHdYkK73fbSI0GSPjMAViEJ4rvgv9qbKSR6lRBj0tWAJ916UC7BRjXmg==
X-Received: by 2002:ac2:59da:0:b0:4c0:2b07:e6e7 with SMTP id x26-20020ac259da000000b004c02b07e6e7mr2947770lfn.58.1677082929850;
        Wed, 22 Feb 2023 08:22:09 -0800 (PST)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id a28-20020ac2521c000000b004d34238ca44sm1080300lfl.214.2023.02.22.08.22.09
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 08:22:09 -0800 (PST)
Received: by mail-lj1-f175.google.com with SMTP id a30so8502166ljr.0
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 08:22:09 -0800 (PST)
X-Received: by 2002:a05:651c:2003:b0:294:764a:32e7 with SMTP id
 s3-20020a05651c200300b00294764a32e7mr2951074ljo.10.1677082929213; Wed, 22 Feb
 2023 08:22:09 -0800 (PST)
MIME-Version: 1.0
References: <20230222072349.509917-1-thomas.devoogdt@barco.com>
 <Y/XouZlrtw/SN/C2@salvia> <Y/YFcwp/gyZY5Pmw@orbyte.nwl.cc>
 <Y/YZC1Feu9gOCdWF@salvia> <Y/Y1efOjGyBo0MAj@orbyte.nwl.cc> <Y/Y62lQorHG1PK2g@orbyte.nwl.cc>
In-Reply-To: <Y/Y62lQorHG1PK2g@orbyte.nwl.cc>
From:   Thomas Devoogdt <thomas@devoogdt.com>
Date:   Wed, 22 Feb 2023 17:21:58 +0100
X-Gmail-Original-Message-ID: <CACXRmJgs2XkwO5ODjNwe9MExaVbNxCr7JqfuN-wSAC4iDFy0-Q@mail.gmail.com>
Message-ID: <CACXRmJgs2XkwO5ODjNwe9MExaVbNxCr7JqfuN-wSAC4iDFy0-Q@mail.gmail.com>
Subject: Re: [PATCH] [iptables] extensions: libxt_LOG.c: fix
 linux/netfilter/xt_LOG.h include on Linux < 3.4
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

HI,

I saw your new commit:
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230222155601.31645-1-phil@nwl.cc/,

Thx in advance.
No further action from my side is required I guess.

Kr,

Thomas

Op wo 22 feb. 2023 om 16:55 schreef Phil Sutter <phil@nwl.cc>:
>
> On Wed, Feb 22, 2023 at 04:32:09PM +0100, Phil Sutter wrote:
> [...]
> > I'll apply Thomas' patch adding a reference to my commit and follow up
> > with bpf header copy (unless someone objects).
>
> Scratch the BPF header copy idea - bpf.h is 260KB and libxt_bpf.c acts
> accordingly if missing (I just missed calling configure when playing
> around).
>
