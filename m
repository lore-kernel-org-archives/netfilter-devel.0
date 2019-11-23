Return-Path: <SRS0=6h+B=ZP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8D7C432C0
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Nov 2019 15:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D654B20706
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Nov 2019 15:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="NwvkP2mK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfKWPWa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Nov 2019 10:22:30 -0500
Received: from mail-vs1-f54.google.com ([209.85.217.54]:40393 "EHLO
        mail-vs1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWPWa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Nov 2019 10:22:30 -0500
Received: by mail-vs1-f54.google.com with SMTP id m9so6970695vsq.7
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Nov 2019 07:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=nvmCNIQlPa7RsRoJdu5Hc4lUdjc6kKevQVGjUUrvQgk=;
        b=NwvkP2mKolpPJz5cmbsEHZJyrb4wHmngWEMV4y44V5mTrX6ok59EFYYtnJCwk8xgak
         ipyjX3JqHro264OirWjKYECNNFLBJyxopvqF1yQlVyKnGV+5kJ+meZHnHf2A1aw8Uh/1
         8t4UyQ092fYP2opKikNp//Akre5AZMcDXGGvGms6Xh3YByb+dvk/bIUMsBObRv1tyweU
         y3iMsad8FP1JYXvmoFm43eXhiwZZ0XqZpjCoyCJ7uEwVZncqWpZNgLA+E6ysCA4XEbiB
         yYAXSjV2Lv2QNaVe/LIMTt2wfAOM5rlhV6pycn86gmZMaEde/9bwoZPqrPT+okoc7RaF
         Myww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=nvmCNIQlPa7RsRoJdu5Hc4lUdjc6kKevQVGjUUrvQgk=;
        b=YggA9geYDpSaKrUYBBV3PfqujYxU5BKkuzxRCCuQJo+44La7x1vp1FFiYn8gpceiq2
         nH2HERvadyBFp2KI/zzLh/rU/vXRySaopCRYjsDkpAns9yDT6cmdRn5c3iw5sWkZCfuv
         4v7xJBt3ojMrA+zLLNpOPP5wJb8DX8xI9PNrJthkygFvQWyf2XCuHotwKfH0rSkeaKIl
         ehiqqXkKNCnU0xfXP9SxnFNeSVmBdCSDN92dW2e+7VtKmMbAEvBaPYBHISOEaBMPZcE8
         LFaeTBR7s8c6j5XjLgZIWChmyBFg316tkSmOHTKT1SyvMNXAosNKdAMWqEscHnzefnmM
         Xpgg==
X-Gm-Message-State: APjAAAURfKiJ2D9nCkGO0PlhSPe6dJuqVmy0llwm+LVlEiEaBVT7lXLc
        3nv6drqmNc+PoOqXyu5SIrf50wU4aKKLm+DIPZelIKqr
X-Google-Smtp-Source: APXvYqyqkloC7bXRCMHuSh6+Islw9q+eOKretjCb3PqTUXSUcycN7e1Z/p4PLGJsJPpQI1Yml2Qmn2ywdlM0tr5gMiI=
X-Received: by 2002:a05:6102:5d1:: with SMTP id v17mr1886417vsf.200.1574522549022;
 Sat, 23 Nov 2019 07:22:29 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>
Date:   Sat, 23 Nov 2019 16:22:18 +0100
Message-ID: <CAJ2a_De8v-284_sBasGd5TvWh=zYM8Z2Rk=2+vjKyx=d6WL=cg@mail.gmail.com>
Subject: Certificate of https://wiki.nftables.org expired
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,
the certificate of https://wiki.nftables.org has expired.
Please renew.
