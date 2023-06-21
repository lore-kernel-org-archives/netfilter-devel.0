Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E983EB64D7
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Jun 2023 20:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjFUUPx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Jun 2023 16:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjFUUPu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2023 16:15:50 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6141019A3
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2023 13:15:49 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-3ff25ca795eso38921cf.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2023 13:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687378548; x=1689970548;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=otb9mWh63Y8sqBsg0grRp44WNGjwqCjeQHKMdpQifmk=;
        b=PMsJN9o7P+1pPrUVr+yWZ5pZMOSF4O1KAfin1dkvtAV2uIV3BXGecunusJP/6zScyM
         fR/cAXGL4RodfXdFTx9VB4tZ13v1EdYe5i3UkIUGkyqJqGJ04Trl+K9SYhanr6AEZzaw
         fvqxnotkETMZN32cqnlrFZI63JDdheOVTSlT3I1Obpf+IE4xxWinRlVZxYWYjZaFM/bp
         ZY86RAWWo4IHxPIF1R+9GG3OxFJWMI9kE7GIRR08wgnVyIxbg/KKJTlzhIUWZY6qw9J8
         R+i5COVHnQUFQztDmu5evD51VbQf5fw3zsxIrjfhWT8lTaJthAYwkEZRsyYKSuvplBj6
         P7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687378548; x=1689970548;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=otb9mWh63Y8sqBsg0grRp44WNGjwqCjeQHKMdpQifmk=;
        b=keGpptf55eMjPwtgs6AI6dAg/1gA9b/nkXzF2yUnKeYmCFfW+K3xlHqGf9dTsNi0x1
         v/7Rch1BDPtXXIVIP9jF3cSqdPPUgDkjsTb1cMTIxUnr1vBmHA56hu4/AqgqndQzJzoX
         929UjwBDWTSaH8fyHRU9SAbkvk8Y+rRrs5KdQv7In+Ikzz37kNpjrr0k7XctL913YVbR
         PcjefW5PRxZ/J0j6TKe0Uv+xkvX8UYkRL+lqLqMKHRYpMNQ+p/iP9q6aQo8CgDtiHMij
         IdHugSwn426qttoyBi7PSiO9q8PnLuc93oQgJy3O4B2v3QiqLMLQK3QAztfH/yXFEvfF
         JqpQ==
X-Gm-Message-State: AC+VfDwUV8ko7wGTScHfNPG/Fm7vFq1jBFfpPAeCbn6ZU4TvQmy0HWmv
        BoH4WITtMd13ZYF40OLqc4JUSYgpgfaeKX0vQ/Zio1MEoGfFuK8qZkA=
X-Google-Smtp-Source: ACHHUZ5PdL+jJhhV6wyJJp9mQiMh7px97kova23eRaRpXlev0zFZg3D+f2C+XFFzjK4CrFRLNBsi+hNEkGrub+noNTg=
X-Received: by 2002:a05:622a:1447:b0:3f0:af20:1a37 with SMTP id
 v7-20020a05622a144700b003f0af201a37mr1324191qtx.15.1687378548249; Wed, 21 Jun
 2023 13:15:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230621155653.11078-1-fw@strlen.de>
In-Reply-To: <20230621155653.11078-1-fw@strlen.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 21 Jun 2023 22:15:37 +0200
Message-ID: <CANn89iJu-4WNKh4Ah28gYTCFFr+DxqT35NG36zHbkBc7TDO9mQ@mail.gmail.com>
Subject: Re: [PATCH nf v2] netfilter: conntrack: dccp: copy entire header to
 stack buffer, not just basic one
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 21, 2023 at 5:56=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Eric Dumazet says:
>   nf_conntrack_dccp_packet() has an unique:
>
>   dh =3D skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
>
>   And nothing more is 'pulled' from the packet, depending on the content.
>   dh->dccph_doff, and/or dh->dccph_x ...)
>   So dccp_ack_seq() is happily reading stuff past the _dh buffer.
>
> BUG: KASAN: stack-out-of-bounds in nf_conntrack_dccp_packet+0x1134/0x11c0
> Read of size 4 at addr ffff000128f66e0c by task syz-executor.2/29371
> [..]
>
> Fix this by increasing the stack buffer to also include room for
> the extra sequence numbers and all the known dccp packet type headers,
> then pull again after the initial validation of the basic header.
>
> While at it, mark packets invalid that lack 48bit sequence bit but
> where RFC says the type MUST use them.
>
> Compile tested only.
>
> v2: first skb_header_pointer() now needs to adjust the size to
>     only pull the generic header. (Eric)
>
> Heads-up: I intend to remove dccp conntrack support later this year.
>
> Fixes: 2bc780499aa3 ("[NETFILTER]: nf_conntrack: add DCCP protocol suppor=
t")
> Reported-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks Florian.
