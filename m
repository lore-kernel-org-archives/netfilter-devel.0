Return-Path: <SRS0=tNyb=UE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E92AC282DE
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 05:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12FC52075B
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 05:54:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AcGL0wK4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfFEFy6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jun 2019 01:54:58 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:46708 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfFEFy6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 01:54:58 -0400
Received: by mail-vs1-f65.google.com with SMTP id l125so14969071vsl.13
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Jun 2019 22:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=LKoZuQ3dNK2fDxRZPZ8QaCaHUjlG3SvUae3M3xAnVm0=;
        b=AcGL0wK47Oy2YPmJNP8WqzfsN44D2uEutUbJGpoEhI1B2qp0JnBnqxCR5DlPIQ4HBj
         zGTXbABMjNceKgKthSv36NqdFtra0N9aqd4hn5k6btGozVUv1Wp4yH8FqgkGiQqPlr+1
         PA6pBxtZDaGTPmQkXzZp4Pw+j3vInnJYRBHxf7rG/0/6Yn+WTl6yboI5sGznEJ2fbdea
         WAyEsU9zVNIyPzS/J6OGjn3O6sLPS2mn/sdyn991FjuK3atdztG6nLLh3D6bHnEZxzci
         pMOUq8cHyKFtvKRZMJkGlEMjf24lFVh7yQ1CkUAyYhxIgECmyrRilbVVrkc6SWj02Xg7
         I1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=LKoZuQ3dNK2fDxRZPZ8QaCaHUjlG3SvUae3M3xAnVm0=;
        b=Pbgr5xVrar311CU5WvYgTz5IE84KBCVVccBsUyb/pLjg1TEOJYBXWtVFWce8Tpqe44
         o7SbQguxhPyLMjzDILEp+1S0uIe10zJeI2Br6tvPZ7BAKu1obEutQkg/4I/Q13HZJhJP
         yj6CvR+ffSk8VF2wlD/lSo+lStCNAzRiV5txUOWQYxLM1JToD3izBN6a6RJK5yQiNH8T
         hOLiEsOTvazwi/P18++pEsH2pCtXPpJiojxErxSEU0MADhSR7TyvlLv5yqRObH/EovGt
         2T7kyZR5gSmtcEQDQcyzMRmUH0+28LKog0yL3MjfioNnuyh+8wxA3ki4pWBTr5FTwdkU
         X79g==
X-Gm-Message-State: APjAAAUV3k1VWFE+qJsrbidYa5u8btkWlCH3gbZz+j0qbSS4wzcfhi3l
        YajtU+Bb/DFysbS4QMGLu/4FeqpY84v4sY98QCQbDg==
X-Google-Smtp-Source: APXvYqzgZ97eOLIi4Wq2iog3WFdmt4A7PQ4GBPG3EJ1DPtTLlB67NIjbcdXLAHDaEi6UPlbBOaKOb4N/RPZHAEvbY3E=
X-Received: by 2002:a67:7a0a:: with SMTP id v10mr8796790vsc.203.1559714097551;
 Tue, 04 Jun 2019 22:54:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190531165145.12123-1-sveyret@gmail.com>
In-Reply-To: <20190531165145.12123-1-sveyret@gmail.com>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Wed, 5 Jun 2019 07:54:46 +0200
Message-ID: <CAFs+hh4n3nY5WSFyChinVcGw7PNM6CghwWOdqxJuiM-xOTk0xw@mail.gmail.com>
Subject: Re: [PATCH libnftnl v4 0/2] add ct expectation support
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Is this enough for you to test the =E2=80=9Cnetfilter: nft_ct: add ct
expectations support=E2=80=9D patch or would you like me to also send the n=
ft
patch ?

Le ven. 31 mai 2019 =C3=A0 18:53, St=C3=A9phane Veyret <sveyret@gmail.com> =
a =C3=A9crit :
>
> Please find here the second part of the ct expectation support.
> When needed, please ask me for the third part: nft patch.
>
> St=C3=A9phane Veyret (2):
>   src: add ct expectation support
>   examples: add ct expectation examples
>
>  examples/Makefile.am                   |  16 ++
>  examples/nft-ct-expectation-add.c      | 153 ++++++++++++++++++
>  examples/nft-ct-expectation-del.c      | 126 +++++++++++++++
>  examples/nft-ct-expectation-get.c      | 142 +++++++++++++++++
>  examples/nft-rule-ct-expectation-add.c | 163 +++++++++++++++++++
>  include/libnftnl/object.h              |   8 +
>  include/linux/netfilter/nf_tables.h    |  14 +-
>  include/obj.h                          |   8 +
>  src/Makefile.am                        |   1 +
>  src/obj/ct_expect.c                    | 213 +++++++++++++++++++++++++
>  src/object.c                           |   1 +
>  11 files changed, 844 insertions(+), 1 deletion(-)
>  create mode 100644 examples/nft-ct-expectation-add.c
>  create mode 100644 examples/nft-ct-expectation-del.c
>  create mode 100644 examples/nft-ct-expectation-get.c
>  create mode 100644 examples/nft-rule-ct-expectation-add.c
>  create mode 100644 src/obj/ct_expect.c
>
> --
> 2.21.0
>

St=C3=A9phane Veyret
