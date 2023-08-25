Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43CC1EE49A0
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 03:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbjHYDfe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 23:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238681AbjHYDfe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 23:35:34 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD84E54
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 20:35:32 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id a1e0cc1a2514c-794b8fe8cc4so946423241.0
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 20:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692934531; x=1693539331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZeKXsR5i+3t7A7RQz6wv4NhKrRHghpFsyUaMj80SHmY=;
        b=WR2EAU6w0c+k79PfFrAizWik7OaqMHYbdqG7lT30MVQtD+oNJ9OjPk++fLr5PLxOoc
         eY9tYy+4Ow1Gcv8tieuh167jypZalL8vwoWYVIL3rjBK8+5LswGL8VcEGTC+HWioA9Pm
         yKh+eEUsOZ2a/8aiKZz1YC5ip/NAf6BMwwYU79s2cMB0veasRecc52fsUiXZwkQY6u8t
         2vmZZm2iOvGpB/NQjLd1dVrMgx3Xi+rFZV1FJHpGd8qklz6M+Ps+Hki2HOPBfCpgBGXs
         W3XRRCKoyDnjv3NxqefT5x3UlFOHr/UmI7F5MmrGpdNCKZblL3+DDJchaSCt6curHXyN
         mq2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692934531; x=1693539331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZeKXsR5i+3t7A7RQz6wv4NhKrRHghpFsyUaMj80SHmY=;
        b=arFh4cbujqYYrJ4Nadekjs6EjGN0rhxgPLgTnsx+7QqDNjHeoeg8XQjXAX+FSqZ7nE
         Rve3YQ3p4F32xVgIpNBcwytannl28rEXGl/FF1YmO6KPFUwvyJdPJy8yNgpn4Rt7EkQn
         6mnDu1tEvk4p0KuEu6KNlQuizOrGoXMRNjH2I/WTe/8CIKQ+wV5emjKhH8x1OMDQFlp9
         fAig9t6hgGDY++NiDqzWpF0H2YPKgJ3Zh9k1hpxA3FOOOiCoC/NrrwQ6I8SQl+KlUrP1
         jdkGYoOnRN410C+yiUkhfF8Y62O9H7i7QDZYHRPHrMNsqHNPrK3K/zbn0TqDYaWpLdxs
         oAVA==
X-Gm-Message-State: AOJu0YxEqotJpDY9rmBczsZJVjkpwRRSK+yudR2cHVRP+J2HjxffVYdH
        etnyNL5jaftjZxtEdZBViKvhCdO7aLDtE7AI3dfjkJxav9M=
X-Google-Smtp-Source: AGHT+IH4lAJSiSruTgYuAFoDdHFg3JIkWpT0MMRKUyPHx0S+EDXmh0sG9MtB+Wx9fJBBeDSvQOgFr2jMNZr/0PmR9tg=
X-Received: by 2002:a67:f8d5:0:b0:44d:51e4:a000 with SMTP id
 c21-20020a67f8d5000000b0044d51e4a000mr6454748vsp.3.1692934531174; Thu, 24 Aug
 2023 20:35:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230825021432.6053-1-shaw.leon@gmail.com> <20230825031110.GA9265@breakpoint.cc>
In-Reply-To: <20230825031110.GA9265@breakpoint.cc>
From:   Xiao Liang <shaw.leon@gmail.com>
Date:   Fri, 25 Aug 2023 11:34:54 +0800
Message-ID: <CABAhCOTbKPmzg_5L7EkS+eivNNH=9hjG=q_aCGewB+H4QQgg=A@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_exthdr: Fix non-linear header modification
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 25, 2023 at 11:11=E2=80=AFAM Florian Westphal <fw@strlen.de> wr=
ote:
> > -             tcph =3D nft_tcp_header_pointer(pkt, sizeof(buff), buff,
> > -                                           &tcphdr_len);
> > -             if (!tcph)
> > -                     goto err;
> > +             tcph =3D (struct tcphdr *)(pkt->skb->data + nft_thoff(pkt=
));
> > +             opt =3D (u8 *)tcph;
>
> This modification is not related to the bug?
>
> If you think this is better, then please say that the 'do not use
> nft_tcp_header_pointer' is an unrelated cleanup in the commit message.
>
> But I would prefer to not mix functional and non-functional changes.
> Also, the use of the nft_tcp_header_pointer() helper is the reason why
> this doesn't result in memory corruption.

I think this makes it explicit that
    "we are modifying the original packet"
rather than
    "we are modifying the packet because above skb_ensure_writable() is eno=
ugh"

>
> > @@ -325,9 +324,9 @@ static void nft_exthdr_tcp_strip_eval(const struct =
nft_expr *expr,
> >       if (skb_ensure_writable(pkt->skb, nft_thoff(pkt) + tcphdr_len))
>
> Just use the above in nft_exthdr_tcp_set_eval and place it before the loo=
p?

In this case, all TCP headers will be pulled even if they don't have
the target option.
