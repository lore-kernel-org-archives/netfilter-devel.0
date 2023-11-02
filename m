Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A209C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 16:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbjKBQyo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 12:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjKBQyn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 12:54:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3147D181
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 09:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698944028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=CJmmyhOEeoul9gMx96OYTrpMc+QeZeluJ64D68VFoZk=;
        b=JFbQ78LBP6RG0/fMVCNCDs9dMnjwP7a43YeUkjGC9Qw5orrbDrQpHeRDKIcz+mGdbJvtSH
        ERi24eILzmiaRuOFWEiWItZi+3xEu+XhAx4RualYkEL78X8LxwJ13L19KrnbLmoOwK/oFV
        dy5LFKWGLVvqhd5nlizGM7aQ/YKmTPM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-sjdEVq2-P1OMYWe55Ayd2w-1; Thu, 02 Nov 2023 12:53:47 -0400
X-MC-Unique: sjdEVq2-P1OMYWe55Ayd2w-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9c439446b73so15184666b.0
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Nov 2023 09:53:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698944025; x=1699548825;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CJmmyhOEeoul9gMx96OYTrpMc+QeZeluJ64D68VFoZk=;
        b=EacNoFb45QmW8pZhpqCauqhapD+6W1r6eREUxFa9nC1/xqIbt7e0E0xpqDXUderNIo
         UzQebrKgWkkF6IR6utXPdurvP9FQlad0Az7tMRd3wSjaMa28040vAgS25A3aj+w+1mBs
         uHK6awFmEQYPIgFAfKncZ2YH8TF+SyE7mf1V5maT8saS50vUgKrFJqVX2juHlIL4DUq7
         QqEqyuN8aGuJBQW5p0rgOUIzEPe+fQOrX83e8ASgoyM9yhPUTQG+Rcpz4P+sADsPYpik
         tXMFhp0AKFACJO6ye/cUUIlnsXglAYxjSLXEv3ZtOktniYG48a0QR5D7+Bz54cXlAAGL
         /aiA==
X-Gm-Message-State: AOJu0Yz8VYefUxN7X+a446FhPwp8ZwQvG+4OLl1i/Conry1b+Uxwlier
        qlKKu+hKczIX5jrPq1fCBC1d6G9po9hazegZ2ZmNVs51mdSQReEFubjdfKUiOolYSjEZQnuVhzv
        66ctajsu3IRE4NRb5egFlgJYEWhdHHfYUo8Lt
X-Received: by 2002:a17:907:9706:b0:9bd:cab6:a34b with SMTP id jg6-20020a170907970600b009bdcab6a34bmr2042056ejc.0.1698944025362;
        Thu, 02 Nov 2023 09:53:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9c7hymOl6KfrVd6Ucc8+I8mnzmVwxfMu8IXjTk4xlagKF5u1yeIQLWlGRSQaWfjoFTEh+9g==
X-Received: by 2002:a17:907:9706:b0:9bd:cab6:a34b with SMTP id jg6-20020a170907970600b009bdcab6a34bmr2042040ejc.0.1698944024989;
        Thu, 02 Nov 2023 09:53:44 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.169.33])
        by smtp.gmail.com with ESMTPSA id d10-20020a17090648ca00b009a9fbeb15f2sm1340648ejt.62.2023.11.02.09.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 09:53:44 -0700 (PDT)
Message-ID: <174b4dbc0df7fec4d0fdbe2c9cb96d4fca5ecd5b.camel@redhat.com>
Subject: Re: [PATCH nft v2 4/7] build: no recursive make for
 "files/**/Makefile.am"
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>, fw@strlen.de
Date:   Thu, 02 Nov 2023 17:53:43 +0100
In-Reply-To: <ZUPI2ItCERJy8a+3@calendula>
References: <20231019130057.2719096-1-thaller@redhat.com>
         <20231019130057.2719096-5-thaller@redhat.com> <ZUOEpOU96ai+dmT7@calendula>
         <ZUOIWNT3sjmqd8EM@calendula>
         <db1347b7716868923326a870d87ccaf9d2572633.camel@redhat.com>
         <ZUPI2ItCERJy8a+3@calendula>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.0 (3.50.0-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2023-11-02 at 17:05 +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 02, 2023 at 03:03:42PM +0100, Thomas Haller wrote:
> > On Thu, 2023-11-02 at 12:30 +0100, Pablo Neira Ayuso wrote:
> > > On Thu, Nov 02, 2023 at 12:14:49PM +0100, Pablo Neira Ayuso
> > > wrote:
> > > > On Thu, Oct 19, 2023 at 03:00:03PM +0200, Thomas Haller wrote:
> > > > > diff --git a/Makefile.am b/Makefile.am
> > > > > index 8b8de7bd141a..83f25dd8574b 100644
> > > > > --- a/Makefile.am
> > > > > +++ b/Makefile.am
> > > > > @@ -2,6 +2,8 @@ ACLOCAL_AMFLAGS =3D -I m4
> > > > > =C2=A0
> > > > > =C2=A0EXTRA_DIST =3D
> > > > > =C2=A0
> > > > > +############################################################
> > > > > ####
> > > > > ###############
> > > >=20
> > > > This marker shows that this Makefile.am is really getting too
> > > > big.
> > > >=20
> > > > Can we find a middle point?
> > > >=20
> > > > I understand that a single Makefile for something as little as
> > > > examples/Makefile.am is probably too much.
> > > >=20
> > > > No revert please, something incremental, otherwise this looks
> > > > like
> > > > iptables' Makefile.
> > >=20
> > > Correction: Actually iptables' Makefiles show a better balance in
> > > how
> > > things are split accross Makefiles, with some possibilities to
> > > consolidate things but it looks much better these days.
> > >=20
> >=20
> > Basically, what I said in the commit message of [1]. Do you
> > disagree
> > with anything specifically (or all of it?).
> >=20
> > [1]
> > https://git.netfilter.org/nftables/commit/?id=3D686d987706bf643f2fa75c1=
993a5720ad55e6df1
> >=20
> > It's a matter of opinion entirely, but I disagree that the
> > iptables'
> > Makefiles are a positive example.
> >=20
> > ---
> >=20
> >=20
> > The ### line is only a visual aid.
>=20
> Yes, because it is too large and you needed this visual aid.
>=20
> > `wc -l` seems the better indication for when the file gets too big.
> > A too big file, can be an indication that it's hard to maintain.
> > After all, it's about maintainability, being understandable and
> > correctness. But is it now really harder to understand, and would
> > splitting it into multiple files make it better?
> >=20
> > - see how you would add a new .c/.h file. Can you find it easily
> > with
> > the large Makefile?
> >=20
> > - see how libnftables.la is build. Can you find it?
> >=20
> > - see who uses libnftables.la. Can you find it?
> >=20
> > - which dependencies has libnftables.la? Which CFLAGS?
>=20
> We __rarely__ need to look at all these things at once.
>=20
> I do not even remember when it was last time I needed to look into
> these Makefiles, well now after this churning^H^H^H^H^H^H^H update :-
> )
>=20
> > Don't try to understand the file at once. Look what you want to do
> > or
> > look at a single aspect you'd like to understand, and how hard that
> > is
> > now (I claim, it became simpler!).
> >=20
> > I mean, previously you could read "examples/Makefile.am" at once.
> > But
> > when you type `make -C examples` then the dependencies were wrong
> > and
> > parallel build doesn't work (across directories). Look how it's
> > now.
> > Can you find how examples are build in the large Makefile.am?
> >=20
> > It's all in one file, open in your editor and easy to jump around.
>=20
> Yes, it is as long as this email :-)

Sorry about that. I figured, when the long commit message didn't
convince you, a long mail should :)

>=20
> > --
> >=20
> > Another example: "src/expression.c" is 5k+. See how most
> > include/*.h
> > include each other, meaning that most source files end up with all
> > headers included. Overall, the cohesion/coupling of the code
> > doesn't
> > seem great. Maybe it needs to be that way and couldn't be better.
> > The
> > point is: 5k+ LOC may be a problem, but it's not as simple as "just
> > split it" or "just move functions ~arbitrarily~ into more files". I
> > say
> > "arbitrarily" unless you find independent pieces that can be
> > meaningfully split.
>=20
> No, some .c files are really asking for split, and I have patches to
> start doing so.

Cool.

>=20
> > Likewise, Makefile.am contains the build configuration of the
> > project.
> > It's strongly coupled and to some degree, you need to see it as a
> > whole. At least, `make` needs to see it as a whole, which SUBDIRS=3D
> > does
> > not. This will be more relevant, when actually adding unit tests
> > and
> > integrating tests into `make check`.
>=20
> Yes, it is great, really.
>=20
> But this is completely inconsistent with what we have in other
> existing
> Netfilter trees.

That would also be fixable, by adjusting those trees (I'd volunteer).=C2=A0

The question is what's better, and not what the projects copy-pasted
since 1995 do.


>=20
> > The lack of not integrating tests in `make` (and not having unit
> > tests)
> > is IMO bad and should be addressed. I claim, with one make file,
> > that
> > will fit beautifully together (maintainable). The unit tests will
> > be in
> > another directories, which requires correct dependencies between
> > tests/unit/ and src/. With recursive make (SUBDIRS=3D) it's only
> > "everything under src/ must build first", which hampers parallel
> > make
> > and does not express dependencies correctly.
>=20
> No please, do not follow that path.
>=20
> I have to run `make distcheck` to create tarballs, and I do not have
> to wait to run all tests to do so.

>=20
> Please do not couple tests with make process.


On the branch, those tests work and it's convenient to run them and
reasonably fast! `make -j distcheck` takes 59 seconds on my machine.

When doing a release, one(!) minute should be invested to run all tests
again. And when tests fail, that should block the release.

On the other hand, the tests could be easily excluded during `make
distcheck`. So that's not really an argument. But not running tests is
IMO not favorable.



Anyway. Please play around with what's on current master. I still hope
you come to like it.


Thomas

