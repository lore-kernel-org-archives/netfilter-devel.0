Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B126C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Feb 2022 14:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbiBBO1A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Feb 2022 09:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344931AbiBBO07 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Feb 2022 09:26:59 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CC7C061714
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Feb 2022 06:26:58 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id c9so18380744plg.11
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Feb 2022 06:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=PNADjNKpKOp1Ij24tjnbRg7qMdTP0z4nfVE69M9Yk6Q=;
        b=i1ndN7oA7UKcYgQA3u4bfkIyahXN98XzJPXAfynJ31M7x1n8d1eJKfMz9YxfyUVnQM
         03MDuQK0hCBm7Bbo+8MKds9FS0do8YAySkT9dLqd22+jxT+YOVTvCWpnaRW9iYDx54Bx
         Ts7cJUMogQy6ktR/nsDTfkuWiorE+uiI26f1I3x9Uv5sX9NnrgkF0C4qf2+seuV3Ww6n
         mZTdiPSQdd+sayd9FB8thzamw8Y4bcNaybpyEPDCj41AAKhzOabKWQ5YBJIV0dBMDGws
         1BM4t7++NHaedzCgM0VBaIMcxfH/I6knuCh77MU9dbfMUE+Ts4GhXBy5zVDcFtbEVMJV
         KNtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=PNADjNKpKOp1Ij24tjnbRg7qMdTP0z4nfVE69M9Yk6Q=;
        b=Le1EjFSFqp5znoQ8C97DhIYNAHg0pSX/jheHIPEkCBvaf6Ej3KSAY+V2tb/4zf4IP3
         tmDvY6qNLnLEcslpxPxCTS3Dl33lXPwpKd2PmFD4WJO5rWRT8jn6BuoRDEahPrrSC3KI
         1aNQvdbrDYUPHOoRypaohuyoe/Ya0d/Mv18Y4xrEVXSTrCi8UCUDzq9MHIxmaxq3qFR+
         wjYu23xY0TTD7drFMudYfJ90V1kZPKFHRslwgbp4rLjqyVVbzT4P7d49ZSJUoNp9Zn8f
         4wwcuvjaNOHQFwe+s9ONx7bWR0Ia9AM17WbQc7yN/ej/Pgv+W3GlPRpgB2lk12x67CDp
         E9Bw==
X-Gm-Message-State: AOAM5312I1S2mw/SxUpzNIGgYWbCn2GPTeDiXUHIFld8kUVvJma7S2Ek
        3maJCk1lD4ATF/g9/5cl8AJg+SwBjTDt5zk7VxS73jgbBqk=
X-Google-Smtp-Source: ABdhPJy8qyLC0gz8qprPvBn3A2bBjDmTlHYiPNdo7QuIeRplw5U08wCRmL+63e93oYeIGAUMoJI9DEF+tXz3ExBBEJc=
X-Received: by 2002:a17:902:8490:: with SMTP id c16mr30577831plo.129.1643812018176;
 Wed, 02 Feb 2022 06:26:58 -0800 (PST)
MIME-Version: 1.0
From:   Vimal Agrawal <avimalin@gmail.com>
Date:   Wed, 2 Feb 2022 19:56:47 +0530
Message-ID: <CALkUMdS9sYb6fuBbmnS+u1M_Eh39Or5iwGcOK5ikqX930ibOYA@mail.gmail.com>
Subject: commit a504b703bb1da526a01593da0e4be2af9d9f5fa8 missing from 4.x LTS
To:     netfilter-devel@vger.kernel.org, fw@strlen.de, pablo@netfilter.org
Cc:     kadlec@blackhole.kfki.hu, Vimal Agrawal <vimal.agrawal@sophos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian/ Pablo,

We are hitting https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/net/netfilter?h=v5.4.172&id=a504b703bb1da526a01593da0e4be2af9d9f5fa8
in 4.x LTS and I see it is not back ported.

We have MASQ/NAT enabled with 64000+ active connections and hence hitting it.

I am wondering if there is a good reason why it is not back ported to
4.x LTS that I should be aware of. I tried back porting it locally on
4.14.173 and it seems to be working fine.

Thanks,
Vimal
