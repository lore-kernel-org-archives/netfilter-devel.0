Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A63C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Nov 2023 19:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjKET7g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Nov 2023 14:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjKET7f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Nov 2023 14:59:35 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8734DD
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Nov 2023 11:59:31 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-40837124e1cso59725e9.0
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Nov 2023 11:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699214370; x=1699819170; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tFIPYnVdamLKhFflgsxmJ79fD0yXj+XAKLnTfE6bT4E=;
        b=XWpfQs1Q2bILvQCuj/N1O4YB40ZvD1BourJMl2eSjtiXMxC5BzJsahaTVKuZ8yCOp8
         CNAgeAs9/Ws6KnPgSMTPOX2H3DVlPWkZZGaAwH9iGxoFfA/6SvRL/X8fS4oTZ5vWTbLt
         pDqgiim9iqQGywxJLAvNTR0WEvchboTaG9jX0WNH8vJJes+XY3szQeUzxKwMvxi30aYj
         4iX9rrXzB61yutbdD3FoAMVuVHZ0CnZh0onjx4roNghPPSY0lhl9cFDjqLh1ERdclm8p
         +Qe7kboAJ+sGxv+C5mtCfv6PydPg5Hvt3wz+06qyy5N2lY3wcnZrNghuCr1zbEHUtZnj
         /8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699214370; x=1699819170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tFIPYnVdamLKhFflgsxmJ79fD0yXj+XAKLnTfE6bT4E=;
        b=Lk0xS9C1IXcdhNE1QZhZoVawU7C2lZbdrgSmne/TTGjfd3QJChEqgloU7evva/K9s3
         MUh4cYgee4/Piniu/DwZBhYNq9Jtm3r3E2vZ+pdubBgZ9g5qVQb+nn/9NYOcuK47qud1
         50JS2QJoylv+LGye4z8EAZ6npdvi+QFkjrPLvFvnx1wew/c1Iexx//VXAa+aN465nyIr
         nmqlRfA/k//Xo3mbhmbjVTs/QEDiTeMhUVQqBgSEtlKIuBT0YjKIZKDW+SGFg8DnhK7z
         hrJv9zJsfPlVyNGKqkziEj4P6kIDtQyvPqbgdNsQx3lkpizMyHOP3xXRCnZPfO505Kg5
         kr2A==
X-Gm-Message-State: AOJu0YwPB6qsB+bTyB9kTY1UGqOF6DrMTR9323h5BWZmqusgfmvzrAtE
        zD1joAey2v9bBc1X/ZGDqZh4jkvTatlR0eg51Iwc77rLkbG2WDh4qS9GMw==
X-Google-Smtp-Source: AGHT+IG6h8cw+Mxa4Zm6/AqXHuovmIrUlnPfE2l9vGfthCt4OLZDPeV0ZQErMwjrgllfTniJBenjIlc3pQmGStLYI+Q=
X-Received: by 2002:a05:600c:1c8f:b0:3fe:eb42:7ec with SMTP id
 k15-20020a05600c1c8f00b003feeb4207ecmr69404wms.1.1699214369933; Sun, 05 Nov
 2023 11:59:29 -0800 (PST)
MIME-Version: 1.0
References: <20231104210053.343149-1-maze@google.com> <1654342n-nn1q-959p-s6r0-3846psss5on6@vanv.qr>
In-Reply-To: <1654342n-nn1q-959p-s6r0-3846psss5on6@vanv.qr>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Sun, 5 Nov 2023 11:59:18 -0800
Message-ID: <CANP3RGdCQ6REeZV9hE2HjaAN0gMtT8nuBhwQ-CQxVPTD1=k_zg@mail.gmail.com>
Subject: Re: [PATCH net] net: xt_recent: fix (increase) ipv6 literal buffer length
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Patrick McHardy <kaber@trash.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Nov 5, 2023 at 12:08=E2=80=AFAM Jan Engelhardt <jengelh@inai.de> wr=
ote:
>
>
> On Saturday 2023-11-04 22:00, Maciej =C5=BBenczykowski wrote:
> >
> >IPv4 in IPv6 is supported by in6_pton [...]
> >but the provided buffer is too short:
>
> If in6_pton were to support tunnel traffic.. wait that sounds
> unusual, and would require dst to be at least 20 bytes, which the
> function documentation contradicts.
>
> As the RFCs make no precise name proposition
>
>         (IPv6 Text Representation, third alternative,
>         IPv4 "decimal value" of the "four low-order 8-bit pieces")
>
> so let's just call it
>
>         "low-32-bit dot-decimal representation"
>
> which should avoid the tunnel term.

Resent [ https://patchwork.kernel.org/project/netdevbpf/patch/2023110519560=
0.522779-1-maze@google.com/
], hopefully this is better.
Also:
- used your (Jan's) new email in the CC.
- changed net to netfilter in the commit title
(but as it is such a trivial bug fix, it does still feel like it
should go straight into net/main... rather than via netfilter repos)

Cheers,
Maciej
