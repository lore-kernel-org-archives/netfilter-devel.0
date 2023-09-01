Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCF5CA0FE5
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Sep 2023 14:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344708AbjIAO50 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Sep 2023 10:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbjIAO5Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2023 10:57:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5567E10E5
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2023 07:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693580204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=laabnPoy27kfJLT1K59HgMwQw9CZYSO66jH0Bc9qbYU=;
        b=VrE9LZteRSb+OBkdup0JHvPFxqtLmDGkLjL0EGoMyukbg9ORAh8CUYi3fryCXUfEOHiQTx
        qDlQccZz5hs8j3Vbty1z+BW3BQXbw354ywPvFeEHPKpr0ZGuD+NswXAVn/EeCSMCa2JsJm
        NlhdtZ9aW8FJgKQI2J1XlT2r6WWOy1Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-B5Xe6LZkOA-ndzOv4h2Q2Q-1; Fri, 01 Sep 2023 10:56:43 -0400
X-MC-Unique: B5Xe6LZkOA-ndzOv4h2Q2Q-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-31de5f9d843so145806f8f.1
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Sep 2023 07:56:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693580201; x=1694185001;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=laabnPoy27kfJLT1K59HgMwQw9CZYSO66jH0Bc9qbYU=;
        b=QFvGAgSMKfUwhSht7qmCQOmCpD2kYEaThDgxYqW5n3/IuQEVBswtrDlYt/vrsHWc++
         +y3emenhz2xswqyws67lNua6uhHhGYvfYbI9mD8sfZEYpgy8/Xeh63yWzX0u5MpPbRq/
         QNnK9Ppyu+Yi8Qv+mPfv9GJUzHtgfiZL/1IJoc+ivg2dtiy/P3fSuNtNNRBRzul91/c8
         uRefw44+ExGKLOpVG8NjYBDk7mbqr2VNvMtfnunZ5fkTcAtJfdRdpaRdSUWG2Xq62E5m
         +8Ih/qaEgPEMgGDFdijwOm10Goz5FySOr7CFdo+HbH6r5KwJi4M0ZdktnZWlqYhXd9EO
         0BTw==
X-Gm-Message-State: AOJu0YxG7R0KkdN/t+de6gEhYyLuuPyZnQqjJ1rd2vg8+wflo5vhqy+4
        Y4VBwrXgg00e9qz/bxdLzEdpxDWMvjxL8b3Ehqbe75I3anRHVDxlDfqCCzlt4AYRCS01TCOKLr8
        zAlDf5P5/CA/afcUaC0LGDLg3Q3fIRMFJGHdu
X-Received: by 2002:a5d:6084:0:b0:31d:1833:4141 with SMTP id w4-20020a5d6084000000b0031d18334141mr2166523wrt.6.1693580201530;
        Fri, 01 Sep 2023 07:56:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEP2AFrVQQeqZQJnLt+KJ8JsJde4l9YjdyRIVpRWUSbbMc028sM2a1Zb0vBOLFLw3rNnOhojQ==
X-Received: by 2002:a5d:6084:0:b0:31d:1833:4141 with SMTP id w4-20020a5d6084000000b0031d18334141mr2166505wrt.6.1693580201171;
        Fri, 01 Sep 2023 07:56:41 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id n10-20020adffe0a000000b003140f47224csm5440315wrr.15.2023.09.01.07.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 07:56:40 -0700 (PDT)
Message-ID: <7bb81ec48b63edca43cf3d3eae1728e6c26860cd.camel@redhat.com>
Subject: Re: [PATCH nft] tests/shell: allow running tests as non-root users
From:   Thomas Haller <thaller@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Fri, 01 Sep 2023 16:56:40 +0200
In-Reply-To: <20230831181821.GH15759@breakpoint.cc>
References: <20230830113153.877968-1-thaller@redhat.com>
         <20230831160838.GG15759@breakpoint.cc>
         <092e55f0000bee0383f50fd9eea26a4f8dbfc41f.camel@redhat.com>
         <20230831181821.GH15759@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2023-08-31 at 20:18 +0200, Florian Westphal wrote:
> Thomas Haller <thaller@redhat.com> wrote:
> > On Thu, 2023-08-31 at 18:08 +0200, Florian Westphal wrote:
> > > > For that to be useful, we must also unshare the PID and user
> > > > namespace
> > > > and map the root user inside that namespace.
> > >=20
> > > Are you sure PIDNS unshare is needed for this?
> >=20
> > Probably not, but does it hurt? I think it should be
> >=20
> > =C2=A0 unshare -f -p -U -n --mount-proc --map-root-user \
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bash -xc 'whoami; ip link; sleep 1 & ps =
aux'
>=20
> Its an extra kernel option that needs to be enabled for this to work.
> Probably on for all distro kernels by now but whats the added
> benefit?

I think we should isolate more, if we can. In v2, there is a test an
fallback to without "-P". How about that?

>=20
> > > > Test that don't work without real root should check for
> > > > [ "$NFT_TEST_HAVE_REALROOT" !=3D 1 ] and skip gracefully.
> > >=20
> > > Thats fine, see my recent RFC to add such environment
> > > variables to check if a particular feature is supported or not.
> > >=20
> > > What I don't like here is the NFT_TEST_ROOTLESS environment
> > > variable to alter behaviour of run-tests.sh behavior, but see
> > > below.
> >=20
> > If you don't run with real-root, then you are maybe not testing the
> > full thing and miss something. Hence, you have to opt-in to the new
> > rootless functionality with NFT_TEST_ROOTLESS=3D1.
>=20
> I disagree, I think a notice is fine, this disclaimer could be
> repeated after test summary.

In v2, NFT_TEST_ROOTLESS is dropped and a notice added.

>=20
> Especially if we start skipping tests we should also have
> an indication that not all tests were run (ideally, we'd see which
> ones and how many...).
>=20
> > The check is to preserve the previous behavior, which failed
> > without
> > real-root.
>=20
> If you absolutely insist then fine.

I don't. Dropped in v2.


>=20
> > > Why not get rid of the check?=C2=A0 Just auto-switch to unpriv userns
> > > and
> > > error out if that fails.=C2=A0 You could just print a warning/notice
> > > here
> > > and
> > > then try userns mode.=C2=A0 And/or print a notice at the together wit=
h
> > > the
> > > test summary.
> >=20
> > Which check? About NFT_TEST_HAVE_REALROOT?
>=20
> I meant $(id) -eq 0 || barf
>=20
> I think the best is to:
> ./run-tests.sh called with uid 0=C2=A0=C2=A0 -> no changes
> ./run-tests.sh called with uid > 0 -> try unpriv netns and set
> NFT_TEST_HAVE_USERNS=3D1 in the environment to allow test cases to
> adjust
> if needed (e.g. bail out early).

Addressed in v2 (with some variations).

>=20
> > =C2=A0=C2=A0=C2=A0=C2=A0 podman run --privileged -ti fedora:latest
> >=20
> > then `id -u` would wrongly indicate that the test has real-root.
> > You
> > can override that with `export=C2=A0 NFT_TEST_HAVE_REALROOT=3D0` to run=
 in
> > rootless mode.
>=20
> Ah.=C2=A0 Well, with my proposal above you can still set
> NFT_TEST_HAVE_USERNS=3D1 manually before ./run-tests.sh if uid 0 isn't
> really uid 0.
>=20
> > > > +if [ "$NFT_TEST_NO_UNSHARE" =3D 1 ]; then
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# The user opts-out from=
 unshare. Proceed without.
> > >=20
> > > Whats the use case?=C2=A0 If there is a good one, then i'd prefer a
> > > command
> > > line switch rather than environment.
> >=20
> > I think command line switches are inferior. They are cumbersome to
> > implement (in the script, the order of options surprisingly
> > matters).
> > They are also more limited in their usage. The script should
> > integrate
> > with a `make check-xyz` step or be called from others scripts,
> > where
> > the command line is not directly editable. Also, the name
> > NFT_TEST_NO_UNSHARE is something unique that you can grep for
> > (unlike
> > the "-g" command line switch.
>=20
> Yuck.=C2=A0 Do we need a totally different script then?

No. run-tests.sh is currently *the* runner script for running tests.
It must always be useful to call directly.

But it *might* be useful to call it from a wrapper script (like a make
target).

>=20
> ./run-tests.sh is for humans, not machines. I want sane defaults.

> > also expected a failure to `unshare`, then printed a warning and
> > proceeded without separate namespace. I think that fallback is
> > undesirable, I would not want to run the test accidentally in the
> > main
> > namespace.
>=20
> Then add a warning?=C2=A0 I very much dislike these environment variables=
,
> developers will add them to their bash init scripts and then there is
> big surprise why someone reports unexpected results/behaviours.
>=20
> Command line options are typically known, environment not.
> Don't get me wrong, environment variables are good, I have no
> objections
> to setting NFT_TEST_HAVE_USERNS or the like for the individual tests
> to
> consume.

Already before, the script supports various command line options, but
those options were also settable via an environment variable. E.g.
"VERBOSE=3Dy" vs. "-v".

I followed that style in v2. How about that?

>=20
> > Now, by default it always tries to unshare, and aborts on failure.
> > The
> > variable is there to opt-out from that.
>=20
> Can't we have a sane default without a need for new command line
> options
> or enviroment variables?

The only unsane default was NFT_TEST_ROOTLESS to opt-in to make
something work. It now works by default.


>=20
> > I'd like to integrate tests more into `make check-*`. I'd also like
> > to
> > add unit tests (that is, both statically and dynamically link with
> > libnftables and to be able to unit test code specifically). As a
> > developer, I'd like to type `make check` to run the the unit tests
> > and
> > have a clear make target for the integration tests.
>=20
> Thats a good thing.=C2=A0 I do not care if I have to call ./run-tests.sh
> or 'make tests', but please, sane defaults without code path
> explosion.
>=20


Thomas

