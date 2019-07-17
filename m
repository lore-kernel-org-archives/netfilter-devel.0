Return-Path: <SRS0=WNzP=VO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C8F0C76186
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jul 2019 14:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0174820818
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jul 2019 14:17:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VXUanums"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfGQORl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 10:17:41 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:35938 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfGQORl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 10:17:41 -0400
Received: by mail-ua1-f65.google.com with SMTP id v20so9700510uao.3
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jul 2019 07:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3xX6NrcjVy4U1U3R+dlJ8dkz43Y7eejo0L1pGvkcTd4=;
        b=VXUanums9j6g0/pgA0fzIhygTGmCwqe4+M5KvYeEkUmv9Yv5/SxPZ4ruPWC04m0jS4
         67u6LFD+0/ct/eJWlkaoUYNKHgXbGQjyU8s+QOzz46xVfyQaGr0XLumqhje4cho1nYvu
         bg5fdCsc7gIYJZ/rnpeF1MDf6V8tAcD52B2lXjnd5h5PyKtFEOKoLpLfRTilgBKjMCfc
         zf9ewCb4l2BCYN4eBFV2SylOK9mJayQSNDGIp0siydDmAnySFiZuZpTJRgBwhkuYirxy
         Dy3V/RkGMymBnKQLg0WvpKYSl+fZ3bvitNwdmUgqI9fiU6xtJkPRlHuW0nPSzTcUdq0K
         WIBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3xX6NrcjVy4U1U3R+dlJ8dkz43Y7eejo0L1pGvkcTd4=;
        b=CIk/oykGtqvFU54yTw0vilB6DW9tcL6Z2NT2Qhr+seLKH3ETWtukbz331bBFb0T5cC
         LfpztJKBqXuJMJwvWUtZw6L1yrrWZit0ksB17dh90+6Me2Vtm90+z8KGMY/U8DBvq3dX
         ggcyCG8TrY16CedeRLfjmlZVC2+Iguj6ca0zda7PzcBRooOS2tAWqDOqBfz0SxTCVDGr
         ahwrk2kRwu1CF/imae/Lu23cFT3dpR+QLyqkIbKusCE3uRyF/ngz7DJanUvveFRn2SLS
         Tfq7xKjQvoLTHNR6sRBhx60NyN432GhMmb3cH3HMsxsbNbq8Bw2JQIazvA5jWtC5L8Rs
         IooA==
X-Gm-Message-State: APjAAAXI53boHSIFrR+cPhD29gy+xH1Bp+kIm5q++ncIRAfgU8Idi7WI
        vcz3t24OWXyJqs8Ikk3EJc100BpBj6i88uLa3uKR7w==
X-Google-Smtp-Source: APXvYqwcZU65PtAgQWpg+J8PM2H2OmwVYmOANfg/KHgmY2jPgQytfvlkCZX6CtzBkb6ddGS2huS95HAgtn038ebzxM8=
X-Received: by 2002:ab0:2994:: with SMTP id u20mr22287181uap.114.1563373059973;
 Wed, 17 Jul 2019 07:17:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190709130209.24639-1-sveyret@gmail.com> <20190709130209.24639-2-sveyret@gmail.com>
 <20190716191935.j62mlzahtupzoji6@salvia> <20190716192924.tdjzbvwpdovli7kk@salvia>
 <CAFs+hh49ezQJZf5y2_TSpkDiXinPqay_1OFBNk-=k3QY2bZ4vQ@mail.gmail.com> <20190717113603.ugmtkzfsa5nhaljl@salvia>
In-Reply-To: <20190717113603.ugmtkzfsa5nhaljl@salvia>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Wed, 17 Jul 2019 16:17:28 +0200
Message-ID: <CAFs+hh6kxWLTr_YCuZVLSQVYUjEVAgTtNkNM-tP2DHj-GC7CaQ@mail.gmail.com>
Subject: Re: [PATCH nftables v5 1/1] add ct expectations support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le mer. 17 juil. 2019 =C3=A0 13:36, Pablo Neira Ayuso <pablo@netfilter.org>=
 a =C3=A9crit :
> Are you running nft-tests.py with -j options.
>
> Did you enable --with-json in ./configure ?

Yes to both questions.

St=C3=A9phane
