Return-Path: <SRS0=aMTL=TF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C054C004C9
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 15:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1CBC208C2
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 15:39:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rwec6rVC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfEEPjG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 May 2019 11:39:06 -0400
Received: from mail-vs1-f50.google.com ([209.85.217.50]:37278 "EHLO
        mail-vs1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEEPjG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 May 2019 11:39:06 -0400
Received: by mail-vs1-f50.google.com with SMTP id w13so6671432vsc.4
        for <netfilter-devel@vger.kernel.org>; Sun, 05 May 2019 08:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=0AN5PeOeBFN6FLfd8AhIv4BLk9UqSYn0xtENZkUnddc=;
        b=rwec6rVCmb8KQ0OwYIPOVa0XW15d+8SAbl1uo4qEQnuv/gA8KjyuPojYDMX3qriF1I
         7inZBU38pIlyL67iWtOkRDfpS9FeTu9yAud436Oq8Hh9cYuWOvK9uw1UNQLLB3bsk4Eb
         L2aVVwLoJOgJ4KHjPQFvJCiOah8b6Urq1IB/ieUNawIc1aKhI9mALbCVNs2dPQFZk6zK
         UZmUQkoUlLLP/Td++pmqnRd42u48DvYCGJU27OMwedTyxI1TXv2pp/1nPU6OdAmu8hbL
         SllEj/t3o2uOm145hUhMlO9FwwuZqbLofw7+QVEbVkt3FNd/gKHlDQi+S0Nm0YKn3Xbj
         fRAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=0AN5PeOeBFN6FLfd8AhIv4BLk9UqSYn0xtENZkUnddc=;
        b=USbqPJRcTTWajghJaIMua1LsOvREUeP3QD8HlwTXJsqLSCQWO3/CQnZ21tVCcYhtiY
         t+RlxZlds/ouGcaUvZaEQ5qXkEVa8ccO83E1PVvQNmdy4DbUqAGst3Dn0ZNvHGaHH/3e
         KqmNEYZid0ckWzqgttNiMYrNyRQNe0rxOBNoYqOr0Pc4nTv+qRImAGAMCrlRfCAjo6xr
         6wWHxfT3wFMboBzX3PDHn7QCchweYu9vBK/kgx5fLILxfrz+PERPyNyZoRhNL3QIFHx6
         JVksnJB6xbP0jNi4fhiamuLxDKlvsh99hP8MxpwkPg4mhlF0vjg3PoZKiFPncWGiWuPR
         JGGQ==
X-Gm-Message-State: APjAAAVXmENa8PEjqettBth6pQXOVwOR7Mw8oKVVynfu5/7jx9pmsjM4
        PLlGFcWaVVvZuj0UIFabf3OW9+IYfo/65h4HZ8uT5Q==
X-Google-Smtp-Source: APXvYqwSjzXM+TEfBUP+PMhtEJ7gAiFjrjk3ZOS7vZQhaB8U0ath+QgAplTgZZzhA3eMkM0zlfNDItNZ2nlBZE2wjQs=
X-Received: by 2002:a67:14c6:: with SMTP id 189mr11013535vsu.203.1557070744882;
 Sun, 05 May 2019 08:39:04 -0700 (PDT)
MIME-Version: 1.0
References: <107c7e2d-dd8a-38d3-7386-f4ea56082edd@gmail.com> <20190505132403.GC4383@azazel.net>
In-Reply-To: <20190505132403.GC4383@azazel.net>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Sun, 5 May 2019 17:38:53 +0200
Message-ID: <CAFs+hh5NJCbmLRuL170W6+3N+5Op3vOskRkSu6KMJCh=E=UMrA@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nft_ct: add ct expectations support
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le dim. 5 mai 2019 =C3=A0 15:24, Jeremy Sowden <jeremy@azazel.net> a =C3=A9=
crit :
> Your patch has been mangled.

Thank you for warning me. A problem with git and GMail which seem not
to be good friend, but I think I managed to configure everything
correctly now. I will send it again in a few minutes.

St=C3=A9phane.
