Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F775C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 14:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbjKBOEj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 10:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjKBOEi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 10:04:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3714912E
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 07:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698933828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=qJtihuWDDHeW4qtnD6c3trFWejSV7QO0greX7OWQWfg=;
        b=WY7kpkxn//5r4rhgy10ayHdizQ9PrzmBHmVq4PA0FZCn0g1rZP7bvXIVgu6y4JEcibyz75
        QeRgPBaKSB5FSyZCc9WvwQLDhsz5IhQmbjDDDxRMqB4gQN0+Q/KGc/wW4fXbz+ZeVEZWF8
        Glygjae+oIIWgLnCsU9OFmXizn7p9oI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-9BAtiyQsN7mgc9OHWQHNtA-1; Thu, 02 Nov 2023 10:03:47 -0400
X-MC-Unique: 9BAtiyQsN7mgc9OHWQHNtA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4083e371a18so1130955e9.0
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Nov 2023 07:03:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698933824; x=1699538624;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qJtihuWDDHeW4qtnD6c3trFWejSV7QO0greX7OWQWfg=;
        b=bRBJu300zR22TBlC2Zk8CUbO3rzpdFnWl9FjF/bfo0YzxBsGzsBsOT23FbmZPE3mEA
         YquVoT+006dfmcQz9Cup5rJ+QIAOBwTd0B63/CGzvIlkIl2VQS3LuitS1GQAYEWl+KAN
         3y4UC1iIWzJfXNZRP7GzaRovVSdrlyMVvFw6HxfU/9+OpaYI4i/R3hY06NZGgpMd+7N3
         rpOipZn0rDzfll2cS8FOWHaaa3/lp+ztaIbXgUBgHsEJbS+qFfJTU55KLl0+FlePy/Lk
         NZUM4Rsz2Ha3YymS5zhsJMa8nT3QtKSD4s4nHWl2YYGl0ZPAiMUcZwSjzt6TlUxj9l6T
         74Tg==
X-Gm-Message-State: AOJu0YzUBu7Bk4UxtW4zh5qcCbxHjaEh1FZdO73i1Gr4SsaSF/l9dell
        p17w5jyPPTGdfBe+2Ava9oiST65PUSM2zCCDKt8vIxh56+zUszIk4gsTDCgGO+YqUV+NH/09GaP
        E0qqeP1E/syDzcpwI65ZmdTtBiTEBap1JATBV
X-Received: by 2002:a05:600c:3d95:b0:408:3ea2:1220 with SMTP id bi21-20020a05600c3d9500b004083ea21220mr15104308wmb.1.1698933824026;
        Thu, 02 Nov 2023 07:03:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGTabmeeVk4tzDxqz8Axu+5rj3SpbM76NwHnrO7iLi5BTJ1M6K1fZHdXPYwaU8M9KUHSFK2fg==
X-Received: by 2002:a05:600c:3d95:b0:408:3ea2:1220 with SMTP id bi21-20020a05600c3d9500b004083ea21220mr15104285wmb.1.1698933823587;
        Thu, 02 Nov 2023 07:03:43 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.169.33])
        by smtp.gmail.com with ESMTPSA id fb14-20020a05600c520e00b004064741f855sm2868645wmb.47.2023.11.02.07.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 07:03:43 -0700 (PDT)
Message-ID: <db1347b7716868923326a870d87ccaf9d2572633.camel@redhat.com>
Subject: Re: [PATCH nft v2 4/7] build: no recursive make for
 "files/**/Makefile.am"
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>, fw@strlen.de
Date:   Thu, 02 Nov 2023 15:03:42 +0100
In-Reply-To: <ZUOIWNT3sjmqd8EM@calendula>
References: <20231019130057.2719096-1-thaller@redhat.com>
         <20231019130057.2719096-5-thaller@redhat.com> <ZUOEpOU96ai+dmT7@calendula>
         <ZUOIWNT3sjmqd8EM@calendula>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.0 (3.50.0-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2023-11-02 at 12:30 +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 02, 2023 at 12:14:49PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Oct 19, 2023 at 03:00:03PM +0200, Thomas Haller wrote:
> > > diff --git a/Makefile.am b/Makefile.am
> > > index 8b8de7bd141a..83f25dd8574b 100644
> > > --- a/Makefile.am
> > > +++ b/Makefile.am
> > > @@ -2,6 +2,8 @@ ACLOCAL_AMFLAGS =3D -I m4
> > > =C2=A0
> > > =C2=A0EXTRA_DIST =3D
> > > =C2=A0
> > > +################################################################
> > > ###############
> >=20
> > This marker shows that this Makefile.am is really getting too big.
> >=20
> > Can we find a middle point?
> >=20
> > I understand that a single Makefile for something as little as
> > examples/Makefile.am is probably too much.
> >=20
> > No revert please, something incremental, otherwise this looks like
> > iptables' Makefile.
>=20
> Correction: Actually iptables' Makefiles show a better balance in how
> things are split accross Makefiles, with some possibilities to
> consolidate things but it looks much better these days.
>=20

Basically, what I said in the commit message of [1]. Do you disagree
with anything specifically (or all of it?).

[1] https://git.netfilter.org/nftables/commit/?id=3D686d987706bf643f2fa75c1=
993a5720ad55e6df1

It's a matter of opinion entirely, but I disagree that the iptables'
Makefiles are a positive example.

---


The ### line is only a visual aid. `wc -l` seems the better indication
for when the file gets too big. A too big file, can be an indication
that it's hard to maintain. After all, it's about maintainability,
being understandable and correctness. But is it now really harder to
understand, and would splitting it into multiple files make it better?

- see how you would add a new .c/.h file. Can you find it easily with
the large Makefile?

- see how libnftables.la is build. Can you find it?

- see who uses libnftables.la. Can you find it?

- which dependencies has libnftables.la? Which CFLAGS?

Don't try to understand the file at once. Look what you want to do or
look at a single aspect you'd like to understand, and how hard that is
now (I claim, it became simpler!).

I mean, previously you could read "examples/Makefile.am" at once. But
when you type `make -C examples` then the dependencies were wrong and
parallel build doesn't work (across directories). Look how it's now.
Can you find how examples are build in the large Makefile.am?

It's all in one file, open in your editor and easy to jump around.


--

Another example: "src/expression.c" is 5k+. See how most include/*.h
include each other, meaning that most source files end up with all
headers included. Overall, the cohesion/coupling of the code doesn't
seem great. Maybe it needs to be that way and couldn't be better. The
point is: 5k+ LOC may be a problem, but it's not as simple as "just
split it" or "just move functions ~arbitrarily~ into more files". I say
"arbitrarily" unless you find independent pieces that can be
meaningfully split.

Likewise, Makefile.am contains the build configuration of the project.
It's strongly coupled and to some degree, you need to see it as a
whole. At least, `make` needs to see it as a whole, which SUBDIRS=3D does
not. This will be more relevant, when actually adding unit tests and
integrating tests into `make check`.

The lack of not integrating tests in `make` (and not having unit tests)
is IMO bad and should be addressed. I claim, with one make file, that
will fit beautifully together (maintainable). The unit tests will be in
another directories, which requires correct dependencies between
tests/unit/ and src/. With recursive make (SUBDIRS=3D) it's only
"everything under src/ must build first", which hampers parallel make
and does not express dependencies correctly.

Branch [2] shows how this would look with unit tests.

[2] https://gitlab.freedesktop.org/thaller/nftables/-/commits/th/no-recursi=
ve-make


Thomas

