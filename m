Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5687C83F35
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Aug 2023 17:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbjHaR1L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Aug 2023 13:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjHaR1L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Aug 2023 13:27:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8995A107
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Aug 2023 10:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693502780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qkKfK/MKl9VQ2YhV+bvF7HmYMDLeGHKhKVzQbg693/g=;
        b=ITDEPNuOl1l3urtO2eaLr8xvKXoXVFWPr/zkSSFV0ACrxmLVWaNJD+s6n9GBiw4mi0OViH
        vvrhocxEMX5ii4IZQVj7n4QuwykxHnsDx7stDrIPfNxoJfI9xQgM9eea6U6Kc8JPUr+Tpw
        corFT8abKelWC7MYo96Kxt5oACB3mFM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-Wyh347QKOSCrIX7HVNrapw-1; Thu, 31 Aug 2023 13:26:18 -0400
X-MC-Unique: Wyh347QKOSCrIX7HVNrapw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3fe4f8a557dso2924145e9.0
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Aug 2023 10:26:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693502777; x=1694107577;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qkKfK/MKl9VQ2YhV+bvF7HmYMDLeGHKhKVzQbg693/g=;
        b=ka/4M7IYm3HSxqf4hJcOV8GOBQcriiHJSSJnjEglv6x1ra/DFpu6kg/M06TmckHJZe
         8TRcJpIaza5XrnjW9XuowTV4zHSmRIbPiDHCUx/PWD3hIgG4PxGFiDFhiBzM6adx1uPm
         LECmr1YzMtsn1MubUM4t1/UnzNlCR78JgqLx4UsbdxG+8xhu5AKQv0vMml2gIvXwz5DO
         qCTTzzh7VaGZBX7IR//L2jWdYiBpbofIOVSFgy03wcyKZdNbdIyN6zl4yJ4TIRRJkY+j
         2nD0QNganoTbz1LGZsPISceaf01YLtW7QXdu/DPl074AEs4zxh/EzNoe02Sx6KTGt9IE
         SadQ==
X-Gm-Message-State: AOJu0Yzo4lEjgPLXt/P1l0w/Sz6f+L9J58m53zsTiP6SG7NLA9i345sr
        19+YRdK2vxEStG4qxLiOK+wK0PVoJZiS+yLJhUeTUSX2nxcTbVyY+kgGFGJTs+3v7CfYSnJxAfT
        IQ/rE4MedwpFg3NjczLBXnd/IBfNix1lY3eO1
X-Received: by 2002:a05:600c:3b25:b0:3ff:8617:672b with SMTP id m37-20020a05600c3b2500b003ff8617672bmr1133wms.2.1693502777311;
        Thu, 31 Aug 2023 10:26:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpldfi/DcMNWuywfSlj5H2lDZN9nGiNj10HqKubTaKYA7rkZ7spyr/wkCV6tg229XMkp9BlQ==
X-Received: by 2002:a05:600c:3b25:b0:3ff:8617:672b with SMTP id m37-20020a05600c3b2500b003ff8617672bmr1121wms.2.1693502776966;
        Thu, 31 Aug 2023 10:26:16 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id 11-20020a05600c234b00b003fee8793911sm2509249wmq.44.2023.08.31.10.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Aug 2023 10:26:16 -0700 (PDT)
Message-ID: <092e55f0000bee0383f50fd9eea26a4f8dbfc41f.camel@redhat.com>
Subject: Re: [PATCH nft] tests/shell: allow running tests as non-root users
From:   Thomas Haller <thaller@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Thu, 31 Aug 2023 19:26:15 +0200
In-Reply-To: <20230831160838.GG15759@breakpoint.cc>
References: <20230830113153.877968-1-thaller@redhat.com>
         <20230831160838.GG15759@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2023-08-31 at 18:08 +0200, Florian Westphal wrote:
> Thomas Haller <thaller@redhat.com> wrote:
> > Allow to opt-out from the have-real-root check via
> >=20
> > =C2=A0 NFT_TEST_ROOTLESS=3D1 ./run-tests.sh
>=20
> I don't like this.=C2=A0 But its a step in the right direction.
>=20
> To me run-tests.sh has following issues/pain points:
> =C2=A0- test duration is huge (>10m with debug kernels)
> =C2=A0- all tests run in same netns
> =C2=A0- tries to unloads kernel modules after each test
>=20
> The need for uid 0 wasn't big on my problem list so far because
> I mostly run the tests in a VM.=C2=A0 But I agree its an issue for
> auto-build systems / CI and the like.

It also means there is not simple "run-tests" script without setting up
a VM/container. I personally avoid to run `sudo some/script` from the
internet (although, I execute build scripts from the internet are
normal user).

Running a substantial subset of tests as non-root, seems essential to
me.

It may not be essential to everybody, but to some.

>=20
> > For that to be useful, we must also unshare the PID and user
> > namespace
> > and map the root user inside that namespace.
>=20
> Are you sure PIDNS unshare is needed for this?

Probably not, but does it hurt? I think it should be

  unshare -f -p -U -n --mount-proc --map-root-user \
      bash -xc 'whoami; ip link; sleep 1 & ps aux'

>=20
> > Test that don't work without real root should check for
> > [ "$NFT_TEST_HAVE_REALROOT" !=3D 1 ] and skip gracefully.
>=20
> Thats fine, see my recent RFC to add such environment
> variables to check if a particular feature is supported or not.
>=20
> What I don't like here is the NFT_TEST_ROOTLESS environment
> variable to alter behaviour of run-tests.sh behavior, but see below.

If you don't run with real-root, then you are maybe not testing the
full thing and miss something. Hence, you have to opt-in to the new
rootless functionality with NFT_TEST_ROOTLESS=3D1.

The check is to preserve the previous behavior, which failed without
real-root.


> > -if [ "$(id -u)" !=3D "0" ] ; then
> > +if [ "$NFT_TEST_HAVE_REALROOT" =3D "" ] ; then
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# The caller can set NFT_TES=
T_HAVE_REALROOT to indicate us
> > whether we
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# have real root. They usual=
ly don't need, and we detect it
> > now based
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# on `id -u`. Note that we m=
ay unshare below, so the check
> > inside the
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# new namespace won't be con=
clusive. We thus only detect
> > once and export
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# the result.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0export NFT_TEST_HAVE_REALROO=
T=3D"$(test "$(id -u)" =3D "0" &&
> > echo 1 || echo 0)"
> > +fi
> > +
>=20
> Why not get rid of the check?=C2=A0 Just auto-switch to unpriv userns and
> error out if that fails.=C2=A0 You could just print a warning/notice here
> and
> then try userns mode.=C2=A0 And/or print a notice at the together with th=
e
> test summary.

Which check? About NFT_TEST_HAVE_REALROOT?

We need that, to detect real-root before unshare. Since we already need
it internally, it's also documented so that the user could override it.
For example, if you develop inside a

     podman run --privileged -ti fedora:latest

then `id -u` would wrongly indicate that the test has real-root. You
can override that with `export  NFT_TEST_HAVE_REALROOT=3D0` to run in
rootless mode.


>=20
> > +if [ "$NFT_TEST_NO_UNSHARE" =3D 1 ]; then
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# The user opts-out from uns=
hare. Proceed without.
>=20
> Whats the use case?=C2=A0 If there is a good one, then i'd prefer a
> command
> line switch rather than environment.

I think command line switches are inferior. They are cumbersome to
implement (in the script, the order of options surprisingly matters).
They are also more limited in their usage. The script should integrate
with a `make check-xyz` step or be called from others scripts, where
the command line is not directly editable. Also, the name
NFT_TEST_NO_UNSHARE is something unique that you can grep for (unlike
the "-g" command line switch).

The variable NFT_TEST_NO_UNSHARE is there, because the previous code
also expected a failure to `unshare`, then printed a warning and
proceeded without separate namespace. I think that fallback is
undesirable, I would not want to run the test accidentally in the main
namespace.

Now, by default it always tries to unshare, and aborts on failure. The
variable is there to opt-out from that.


>=20
> I think long term all of the following would be good to have:
>=20
> 1. run each test in its own netns
> 2. get rid of the forced 'nft flush ruleset' and the rmmod calls
> 3. Explore parallelisation of tests to reduce total test time
> 4. Add a SKIP return value, that tells that the test did not run
> =C2=A0 (or some other means that allows run-tests.sh to figure out that
> =C2=A0=C2=A0 a particular test did not run because its known to not work =
on
> =C2=A0=C2=A0 current configuration).
>=20
> This would avoid false-positive 'all tests passed' when in reality
> some test had to 'exit 0' because of a missing feature or lack of
> real
> root.
>=20
> Alternatively we could just make these tests fail and leave it to the
> user to figure it out, the normal expectation is for all tests to
> pass,
> its mostly when run-tests.sh is run on older kernel releases when it
> starts acting up.
>=20

These are very good points.

Parallel execution maybe happen by hooking the tests up as individual
make targets.=20


I'd like to integrate tests more into `make check-*`. I'd also like to
add unit tests (that is, both statically and dynamically link with
libnftables and to be able to unit test code specifically). As a
developer, I'd like to type `make check` to run the the unit tests and
have a clear make target for the integration tests.

IMO "[PATCH nft 0/6] no recursive make" should be done to make that
nicer. But I guess that will be controversial. Recursive make seems
very popular, all around.



Thomas

