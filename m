Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CB6C43381
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Jan 2021 17:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8924823433
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Jan 2021 17:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbhAVQ4o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Jan 2021 11:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729415AbhAVQOk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Jan 2021 11:14:40 -0500
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC3CC0613D6
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2021 08:14:00 -0800 (PST)
Received: by mail-vs1-xe2f.google.com with SMTP id v19so2851232vsf.9
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2021 08:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h8+g/NRfnVZLGFcDvx8fAHELJk187RHrW8PWSNrlAnk=;
        b=WSNVo6+0oBK2cG3IjqGcQfv7+Csg2Rems3GNcds6v0PCg2X3V13M8qPfjwYQHc+3VQ
         CzB5MgRh4tqLusti9t05XHIOHMZoOjsRXL5rpUtOt5TGwU/EakqZQzzoA2slfkbAyZP+
         fdnd2EDTbGcIonZkXmqzhDQVKuUQDougJYnh6sZ/OFBL1NMD0lsJmQomyhYzvi2s4RIo
         Gps6J3K/c5pSQpce8U5xq33KC6+tTVJUWjZnc9oymht+I6LIqmdQZrYvG0uEu4xYN+Uq
         PxJhbPSmu2BVaQXWFyVSMPBfVEFc4KPcq9t3kzSi2PnMPqN+XkgjPb7hGm+eDb/cjZzo
         agfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h8+g/NRfnVZLGFcDvx8fAHELJk187RHrW8PWSNrlAnk=;
        b=Ckc+btkEkXECFCZpynvzBKT4aRXOO0FpDW8FpziP7mPILG0mMdmfDCO7vhvnWkBeIe
         dzcoXmq8G3mHCx8gKIW5JlMVRnpUV7YDCZPlEXDRKIPQ5jibgScFesjFncr/G/OqRadu
         WySH+V17rCVfyuYgp/JGDIoXxa30gEoOYdFybKeYTJtGRH7qVDKnvDkyn7fAMiODDA7+
         TnUIxBTokFD2ZUqi+r2TamxcgeenTo9IbgIgO0GJKUEJvwbcUMCn7NNTd4pUi0ac7ff8
         Ia4aRZPbL4odf+e76U1Ea3smG0pc9dWV5lGLxzk2fn3Hae6W1TlSwaUNmmbDIQKwJ87B
         b6sA==
X-Gm-Message-State: AOAM533ALgzaEK8zsKzFaHhh+as3KAx8hJW6EuZU56wm3Rl0DKvQ1qbG
        ZcsqqsNq5eC1OGoaYKuVU20XzNTpye8=
X-Google-Smtp-Source: ABdhPJynHUBZEN50ENeCLfP8mPFe1Fb7RNJmByDxmz7F61Ootf8I2gsCzGjTAGeZeZ96/Ask2J05tw==
X-Received: by 2002:a67:f910:: with SMTP id t16mr1465903vsq.50.1611332038736;
        Fri, 22 Jan 2021 08:13:58 -0800 (PST)
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com. [209.85.217.44])
        by smtp.gmail.com with ESMTPSA id x186sm1277846vke.32.2021.01.22.08.13.56
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 08:13:56 -0800 (PST)
Received: by mail-vs1-f44.google.com with SMTP id 186so3256815vsz.13
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2021 08:13:56 -0800 (PST)
X-Received: by 2002:a67:a41:: with SMTP id 62mr1273885vsk.51.1611332035582;
 Fri, 22 Jan 2021 08:13:55 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611304190.git.lukas@wunner.de> <012e6863d0103d8dda1932d56427d1b5ba2b9619.1611304190.git.lukas@wunner.de>
In-Reply-To: <012e6863d0103d8dda1932d56427d1b5ba2b9619.1611304190.git.lukas@wunner.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 22 Jan 2021 11:13:19 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfuLfh3H45HnvtJPocxj+E7maGwzkgYsfktna2+cJi9zQ@mail.gmail.com>
Message-ID: <CA+FuTSfuLfh3H45HnvtJPocxj+E7maGwzkgYsfktna2+cJi9zQ@mail.gmail.com>
Subject: Re: [PATCH nf-next v4 5/5] af_packet: Introduce egress hook
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 22, 2021 at 4:44 AM Lukas Wunner <lukas@wunner.de> wrote:
>
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>
> Add egress hook for AF_PACKET sockets that have the PACKET_QDISC_BYPASS
> socket option set to on, which allows packets to escape without being
> filtered in the egress path.
>
> This patch only updates the AF_PACKET path, it does not update
> dev_direct_xmit() so the XDP infrastructure has a chance to bypass
> Netfilter.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> [lukas: acquire rcu_read_lock, fix typos, rebase]
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Isn't the point of PACKET_QDISC_BYPASS to skip steps like this?
