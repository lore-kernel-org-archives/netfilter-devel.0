Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 439D6CDB474
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 11:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbjJQLPZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 07:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbjJQLPY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 07:15:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A462A2
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 04:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697541277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FeQszbA93K1BeHsUg0ZKs+VTHIoLN1fieID/kVO1uDE=;
        b=VR6udO6ZnXSpVPh7gzuipbWbqizq+x7kYmhrUyWHm1P2tAyeJ0hw4GgHErqUramVDARuct
        vIDRaE6EtW6aqS3ci+WRiM/jK+Zf5ElZ4ZoWGXnWuLzwNMp/bLPXuUGySTiWEJi6U7r6lQ
        eXXZneOUep7yHwIz4Os13ugIouK7Nn8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-aJjzNhUzOx6abAGjJHRGEQ-1; Tue, 17 Oct 2023 07:14:30 -0400
X-MC-Unique: aJjzNhUzOx6abAGjJHRGEQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9c45a6a8832so38228566b.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 04:14:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697541269; x=1698146069;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FeQszbA93K1BeHsUg0ZKs+VTHIoLN1fieID/kVO1uDE=;
        b=ZLNoXU3UMNrnWE+bgJu9tSzWIwXkrgEugA5mVtBqyzeOlTgjGQC60fiLUdsnAc74sb
         TbvEzGs0eSicHWBZ7DtK1lRnKyAM/vO36spcVNW5og2wFW8kuubRW1CmhFQjBOhIxwd3
         9J7Ke97rZZ9mHCaLp7suhdsL0wl4mdxszJkQnVjzLECCB/AdIgIgj2XFNeqCoL8fpBX/
         wvi59rVSiockJiGWaMGiKXcVtH3bt3kxkmQYxE+wrz3OOhy3xUPAP5nTc6dPrxcTpQLB
         7VCBhZ1FSbO1lXa72FmWSySscvQ+0e6DI0esVwlH3V4mqGlKebIm87XpekC2IPuAJCnK
         eZcw==
X-Gm-Message-State: AOJu0YzBgIb1FflZlV2NW4MF3nQ/FY7wtGZjyi4GVHUZFc/BkZjA0HFI
        9uAqFz/S/A+ycn2yCIP2ZNUDc37pLolTuKmA7EP0ChtD2ndntz7iORb3Egszrxh0pnN1ea3znPf
        rq/wf1zjZ5gKeY+UsPGJXnG7qWXjB2bpZTIZW
X-Received: by 2002:a17:906:74c8:b0:9be:5ab2:73c3 with SMTP id z8-20020a17090674c800b009be5ab273c3mr1175906ejl.6.1697541269433;
        Tue, 17 Oct 2023 04:14:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEycQbGic8aiDzP2N7nOLqjGtJgbux2mnCXKy2XwZ2ec2ZInmTdwLoUKyBAtQ4HXtYsWb5RYw==
X-Received: by 2002:a17:906:74c8:b0:9be:5ab2:73c3 with SMTP id z8-20020a17090674c800b009be5ab273c3mr1175898ejl.6.1697541269003;
        Tue, 17 Oct 2023 04:14:29 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.64])
        by smtp.gmail.com with ESMTPSA id s17-20020a1709062ed100b009b9977867fbsm1055601eji.109.2023.10.17.04.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 04:14:28 -0700 (PDT)
Message-ID: <9179367fc2f8eaaad8fcc21d1bb724d4ad67e5c6.camel@redhat.com>
Subject: Re: [PATCH nft 1/3] tests/shell: skip "table_onoff" test if kernel
 patch is missing
From:   Thomas Haller <thaller@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 17 Oct 2023 13:14:27 +0200
In-Reply-To: <20231017093228.GB10901@breakpoint.cc>
References: <20231016131209.1127298-1-thaller@redhat.com>
         <ZS2bKZVAN5d5dax-@strlen.de>
         <a64bccda9ab11f18f13d0512001985d1bf9f04ff.camel@redhat.com>
         <20231017093228.GB10901@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-10-17 at 11:32 +0200, Florian Westphal wrote:
> Thomas Haller <thaller@redhat.com> wrote:
> > As you probably run a self-built kernel, wouldn't you just `export
> > NFT_TEST_FAIL_ON_SKIP=3Dy` and reject all skips as failures? What's
> > the
> > problem with that? That exists exactly for your use case.
>=20
> No, its not my use case.
>=20
> The use case is to make sure that the frankenkernels that I am in
> charge
> of do not miss any important bug fixes.
>=20
> This is the reason for the feature probing, "skip" should tell me
> that
> I can safely ignore it because the feature is not present.
>=20
> I could built a list of "expected failures", but that will mask real
> actual regressions.

How did you handle that, before the recent addition of the skip
functionality? Did you just have a list of known failures, and manually
ignored them?


Anyway, the "eval-exit-code" in v2 can easily honor an environment
variable, to always fail hard. The only question is how exactly it
should work.

I propse that NFT_TEST_FAIL_ON_SKIP=3Dy should honor a variable
"NFT_TEST_FAIL_ON_SKIP_EXCEPT=3D", which takes a regex of test names, for
which a skip is *not* fatal (you opt-in the tests that are allowed to
fail). If you maintain c9s, the list of known skipped tests is small
and relatively static. You can maintain a per-kernel-variant regex in
that case.

If we want, we can even parse /etc/os-release and uname and code a
default list of regexes.



> > > This is a bug, and it tells me that I might have to do something
> > > about it.
> >=20
> > OK, do you intend to fix this bug in a very timely manner on Fedora
> > 38
> > (and other popular kernels)? Then maybe hold back the test until
> > that
> > happend? (or let it skip for now, and in a few weeks, upgrade to
> > hard
> > failure -- the only problem is not to forget about that).
>=20
> I did keep the test back until I saw that -stable had picked it up.
>=20
> I can wait longer, sure.

I think it is good to merge tests soon. There just needs to be a
reasonable+convenient way to handle the problem.

Having a policy that requires you to wait is broken. Especially, since
it's unclear how long to wait. You are not waiting for yourself, but
for any unknown user who is affected.


> > Ah right. "tests/shell/testcases/transactions/table_onoff" is fixed
> > on
> > 6.5.6-200.fc38.x86_64. There still is a general problem. For
> > example
> > what about tests/shell/testcases/packetpath/vlan_8021ad_tag ?
>=20
> Its also a bug that needs to be fixed in the kernel.
> I applied it after stable had picked it up for 6.5.7.
>=20
> > 1) the test would exit 78 instead of 77. And run-test.sh would
> > treat 78
> > either as failure or as skip, based on NFT_TEST_FAIL_ON_SKIP
> >=20
> > 2) the test itself could look at NFT_TEST_FAIL_ON_SKIP and decide
> > whether to exit with 77 or 1.
> >=20
> >=20
> > Or how about adding a mechanism, that compares the kernel version
> > and
> > decides whether to skip? For example
>=20
> I don't think that kernel versions work or are something that we can
> realistically handle.=C2=A0 Even just RHEL would be a nightmare if one
> considers all the different release streams.
>=20
> I think even just handling upstream -stable is too much work.

I think the kernel versions work reasonably well for upstream and
Fedora kernels (which is something already!).

I guess, there could be a smarter

  "$NFT_TEST_BASEDIR/helpers/eval-exit-code" kernel  upstream-6.6  upstream=
-6.5.6  c9s-5.14.0-373

that also can cover different "streams" (e.g. the uname from a centos).
But I like a NFT_TEST_FAIL_ON_SKIP_EXCEPT=3D better.

Also, at worst on the Frankenkernel you get a SKIP, when it should have
been a FAIL. For the non-expert user who writes a patch to fix a type
the SKIP is better during `make check`.

On upstream/Fedora kernels, you also don't need anything, and "eval-
exit-code" will end up doing the right thing automatically.

And if you maintain CentOS9Stream, then set NFT_TEST_FAIL_ON_SKIP=3Dy and
NFT_TEST_FAIL_ON_SKIP_EXCEPT=3D<REGEX> and keep track of the tests that
are known to fail. You know your kernel, and the tests that are known
to be skipped.

How about that?

>=20
> That said, I hope that these kinds of tests will happen less
> frequently
> over time.
>=20

I like the optimism :)


Thomas

