Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864ABC0015E
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Aug 2023 22:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbjHIWrR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 18:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbjHIWrQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 18:47:16 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1462D2
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Aug 2023 15:47:15 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-51d95aed33aso282050a12.3
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Aug 2023 15:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691621234; x=1692226034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tXDTEd22XEqIMZo661qqSWECrCERN1pJR45ox7HG1tQ=;
        b=kTZCX1e5w9R2+jLRXd8Et3IBei6pd6I7sr/aC4lJuKhouUR+vCMJjm8dZ6/yiS5R7D
         4xbQMT4zwW3pkfWU5au0PLLsw8pU0OvWmwq+bfjlvX2QjumO43Vx4VUvW1dKsqPHc2ZL
         EaiIhoLbwRwn7mfxZUPZErCKjDv8LumWIc3gbtkk3sBEqKLOwqzw2wkkTXPGbEfEUKkD
         L2OqUKYegZsusDqQOLl0OO352Vak0mP7yjBxoE5TXBuz/bP95XtNYB4EdtggB8rQWmw4
         5NOCTozzWKDHM5jOa9yuKjA60NjG68D3knSTrYWy90mR9nJ6IwWxCXBC2Ix/PVqJvXOb
         nzZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691621234; x=1692226034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tXDTEd22XEqIMZo661qqSWECrCERN1pJR45ox7HG1tQ=;
        b=f3/o9S5F/5MwI02nWSWFGHVsdP6R1H7HCOFwUYQ7iLtVq2x9P8NSBD5eiH99WYYdaa
         jDaRG1WGvbDhEDwfBWTg+hhjhHVkjmiFMwhWSMFHPaAQzG6yAzQUHsiH578gmq224gA8
         HMRCpzd1ryWYhxXuTmeSXWSmSLimTs/zMg7kckGkm036cFerKarQuEsxWbrPZsHqagCC
         m6lPeU2QYaERic88xRVr7+wksbENGHSAVz93Nc55IHp/OCrmf8yrTsDHKv0LWsp8fCRP
         uD4Uge92JPmVLmwVz42M91TfaP/EiiR+YLFM2e1MxMN4LLgLtTIvNkVtjOo9i1xdJLLY
         4U+w==
X-Gm-Message-State: AOJu0YzUSfqyBuksHJZfbgzAktm1WFWc7/KwLfPUd7SNq1Yuck2VW/U7
        NjG2KfcMG4m9Pn2DXCrPUdsJ5HJQvXzPWkZH8c7FMw==
X-Google-Smtp-Source: AGHT+IFIuo+MXyeoVh4pXrORyqAYRV4fSc2uKFtsz6XX14Xjj1TlLU4KZdw3MywV+/6iy0M23VJ3Vq8NEKB4qDR+zyo=
X-Received: by 2002:a17:907:2713:b0:99c:53f:1dc7 with SMTP id
 w19-20020a170907271300b0099c053f1dc7mr310500ejk.54.1691621234083; Wed, 09 Aug
 2023 15:47:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230809-net-netfilter-v2-0-5847d707ec0a@google.com>
 <20230809-net-netfilter-v2-1-5847d707ec0a@google.com> <20230809201926.GA3325@breakpoint.cc>
 <CAFhGd8oNsGEAmSYs4H3ppm1t2DrD8Br5wwg+VuNtwfoOA_-64A@mail.gmail.com> <20230809215846.GE3325@breakpoint.cc>
In-Reply-To: <20230809215846.GE3325@breakpoint.cc>
From:   Justin Stitt <justinstitt@google.com>
Date:   Wed, 9 Aug 2023 15:47:02 -0700
Message-ID: <CAFhGd8r4uCZHBgNG+Cws7GFZ511VEu8Q=KBiq7jU0PJHW6Z9ng@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] netfilter: ipset: refactor deprecated strncpy
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 9, 2023 at 2:58=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Justin Stitt <justinstitt@google.com> wrote:
> > On Wed, Aug 9, 2023 at 1:19=E2=80=AFPM Florian Westphal <fw@strlen.de> =
wrote:
> > >
> > > Justin Stitt <justinstitt@google.com> wrote:
> > > > Use `strscpy_pad` instead of `strncpy`.
> > >
> > > I don't think that any of these need zero-padding.
> > It's a more consistent change with the rest of the series and I don't
> > believe it has much different behavior to `strncpy` (other than
> > NUL-termination) as that will continue to pad to `n` as well.
> >
> > Do you think the `_pad` for 1/7, 6/7 and 7/7 should be changed back to
> > `strscpy` in a v3? I really am shooting in the dark as it is quite
> > hard to tell whether or not a buffer is expected to be NUL-padded or
> > not.
>
> No, you can keep it as-is.  Which tree are you targetting with this?
Not sure, I let ./getmaintainer auto-add the mailing lists. Perhaps
netdev or netfilter next trees?
