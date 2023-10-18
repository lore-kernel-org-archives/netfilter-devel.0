Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D49CDB483
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 11:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344378AbjJRLlv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 07:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbjJRLlt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 07:41:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A17133
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Oct 2023 04:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697629246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BElalB6Mqqipqz9U8jI2sNzi8iQZlgXBPQInS+cJlgk=;
        b=Kvm06aQISMj2FinqsZPbmwlg7PVDZDvZftOQ/X8pdSQY7ScGtim1GUMQFXDR+M5s+xe/JT
        r4HQEIyj9HLVbqLEsf8O6CLJ/x8tjNBwe3rtG/3+Flav/gfji57E3hLtCB+HenIvX/FiDM
        GQBfh1fszHqwRPy5cotOSl3GfLh4f/o=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-0_rzAm7LOVm9kBugC9VbLg-1; Wed, 18 Oct 2023 07:40:34 -0400
X-MC-Unique: 0_rzAm7LOVm9kBugC9VbLg-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5386aefc01eso1280342a12.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Oct 2023 04:40:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697629233; x=1698234033;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BElalB6Mqqipqz9U8jI2sNzi8iQZlgXBPQInS+cJlgk=;
        b=EXTr4yfNS7rmSkLMZ9gMLAcLN+Hn87WIU/ThJiimFEvD7Z76ugKwmO/zUr+evEwJ5L
         wwBkgNrSzR0n0Qio1auMIVt7n6OD3Au2OlkPRT/AZ2UEstKCJq3WJCnUW31Y+wRu6sm2
         UGSa6l1yLI3lM+twjhzQqbsPN+JsnrVdAUkFC3W+w3BrxEkm+ctUwKoODinL9osTyvZi
         UPyK2roSBwSsNbIpdq5n+eG8cIKr3jn/NcHV4sMmMK3LZTM/eSkB5sHiv2SiYLz0+o5s
         eISEoLC6VlHDP11J1iN7QkRoyY/SegUe4x7x4T2n5ny4MdzZ6PPZ2xLXgFnRAkxaGt3Q
         iKPA==
X-Gm-Message-State: AOJu0YxbfqCgIzyBFfmU7S9Wbs3fU2B4BQg8rUuuj2z6YW8I3O3QIeOn
        9CzfrqpXsiruKVIY4pvkwOXyrTqAZxsJfJVpponvdvh7gMgiw3VJN4eW/KlAs6idjnwAbz3h90U
        bxOnlTJL5OcN5e2EMdaUPFcxZA64M+8cib94i
X-Received: by 2002:aa7:c151:0:b0:53f:1aeb:868d with SMTP id r17-20020aa7c151000000b0053f1aeb868dmr3047439edp.4.1697629233352;
        Wed, 18 Oct 2023 04:40:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOWJYLQaXOCbVOhkuL9ZHtPbKsb+PKmrOEB5NoCXpLEs7CjL49CBlIoxpESh8a1T2Vro3ZXQ==
X-Received: by 2002:aa7:c151:0:b0:53f:1aeb:868d with SMTP id r17-20020aa7c151000000b0053f1aeb868dmr3047424edp.4.1697629232861;
        Wed, 18 Oct 2023 04:40:32 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.64])
        by smtp.gmail.com with ESMTPSA id eo9-20020a056402530900b0053defc8c15asm2668461edb.51.2023.10.18.04.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 04:40:32 -0700 (PDT)
Message-ID: <651666347a414eecbb11ad97d6a75a0e1a401bf3.camel@redhat.com>
Subject: Re: [PATCH nft 1/1] tests/shell: add NFT_TEST_FAIL_ON_SKIP_EXCEPT
 for allow-list of skipped tests (XFAIL)
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 18 Oct 2023 13:40:31 +0200
In-Reply-To: <ZS+mfyhHzEld2gJ6@calendula>
References: <20231017223450.2613981-1-thaller@redhat.com>
         <ZS+mfyhHzEld2gJ6@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-10-18 at 11:33 +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 18, 2023 at 12:33:29AM +0200, Thomas Haller wrote:
> > Some tests cannot pass, for example due to missing kernel features
> > or
> > kernel bugs. The tests make an educated guess (feature detection),
> > whether the failure is due to that, and marks the test as SKIP
> > (exit
> > 77). The problem is, the test might guess wrong and hide a real
> > issue.
> >=20
> > Add support for a NFT_TEST_FAIL_ON_SKIP_EXCEPT=3D regex to help with
> > this.
> > Together with NFT_TEST_FAIL_ON_SKIP=3Dy is enabled, test names that
> > match
> > the regex are allowed to be skipped. Unexpected skips are treated
> > as
> > fatal. This allows to maintain a list of tests that are known to be
> > skipped.
> >=20
> > You can think of this as some sort of XFAIL/XPASS mechanism. The
> > difference is that usually XFAIL is part of the test. Here the
> > failure
> > happens due to external conditions, as such you need to configure
> > NFT_TEST_FAIL_ON_SKIP_EXCEPT=3D per kernel. Also, usually XFAIL is
> > about
> > failing tests, while this is about tests that are marked to be
> > skipped.
> > But we mark them as skipped due to a heuristic, and those we want
> > to
> > manually keep track off.
> >=20
> > Why is NFT_TEST_FAIL_ON_SKIP_EXCEPT=3D useful and why doesn't it just
> > work
> > automatically? It does work automatically (see use case 1 below).=C2=A0
> > Trust
> > the automatism to the right thing, and don't bother. This is when
> > you
> > don't trust the automatism and you curate a list of tests that are
> > known
> > to be be skipped, but no others (see use case 3 below). In
> > particular,
> > it's for running CI on a downstream kernel, where we expect a
> > static
> > list of skipped tests and where we want to find any changes.
> >=20
> > Consider this: there are three use case for running the tests.

This patch, and the 3 use cases are about how to treat SKIPs (and the
potential that a SKIP might happen due to a wrong reason, and how to
ensure this doesn't hide an actual bug).

Your reply makes me think that you consider this only relevant for the
"eval-exit-code" patches. It's not (although it could nicely work
together and solve some concerns). SKIPs already exist. This patch is
independent of that other patches or whatever the outcome of those is.

Unless you think, that the current SKIP mechanism (feature
detection/probing) in master is 100% reliable, and there is no need to
worry about SKIP hiding a bug. Then just consider yourself to be in
use-case 1 (which means to trust the automatism and not to care).


Use case 3 is enabled by this patch allows with the new=20
NFT_TEST_FAIL_ON_SKIP_EXCEPT option. And it's the result of Florian
saying:

>>> No, its not my use case.
>>>
>>> The use case is to make sure that the frankenkernels that I am in
>>> charge of do not miss any important bug fixes.
>>>
>>> This is the reason for the feature probing, "skip" should tell me=C2=A0
>>> that I can safely ignore it because the feature is not present.
>>>
>>> I could built a list of "expected failures", but that will=C2=A0
>>> mask=C2=A0real actual regressions.



> >=20
> > =C2=A0 1) The contributor, who wants to run the test suite. The tests
> > make a
> > =C2=A0 best effort to pass and when the test detects that the failure i=
s
> > =C2=A0 likely due to the kernel, then it will skip the test. This is th=
e
> > =C2=A0 default.
>=20
> This is not a good default, it is us that are running this tests
> infrastructure, we are the target users.


This is the current default already, and what was introduced with the
recent additions of SKIP. An effort from Florian.


> This contributor should be running latest kernel either from nf.git
> and nf-next.git

It means running the test suite on distro kernels is not a supported
use case. I thought, Florian said that he does exactly that?

It also means, you cannot PASS the test suite on $DISTRO, after you
build the kernel and the corresponding nftables packages.

E.g. Fedora does not enable OSF module. OSF tests cannot pass. They are
consequently SKIP on Fedora. Nothing wrong with running the test suite
against Fedora kernel. Why would I be required to recompile another
kernel, unless I want to test a more recent kernel patch?

>=20
> > =C2=A0 2) The maintainer, who runs latest kernel and expects that all
> > tests are
> > =C2=A0 passing. Any SKIP is likely a bug. This is achieved by setting
> > =C2=A0 NFT_TEST_FAIL_ON_SKIP=3Dy.
>=20
> I don't want to remember to set this on, I am running this in my
> test machines all the time.

echo "export NFT_TEST_FAIL_ON_SKIP=3Dy" >> ~/.bashrc

Also, there are only are reasonably small number of options that the
test suite has. See "tests/shell/run-tests.sh --help". The majority of
users don't need to care, the the default aims to do the thing they
want (use-case 1). Feel free not to care either. Then use-cases 2 and
use-cases 3 are just not yours. This doesn't mean you are not a
"maintainer", it just means you trust the SKIP automatism or keep track
of SKIPs via other means.

I think for a core developer, it would be useful to be aware and use
some of those options. There is quite useful stuff there.


>=20
> > =C2=A0 3) The downstream maintainer, who test a distro kernel that is
> > known to
> > =C2=A0 lack certain features. They know that a selected few tests shoul=
d
> > be
> > =C2=A0 skipped, but most tests should pass. By setting
> > NFT_TEST_FAIL_ON_SKIP=3Dy
> > =C2=A0 and NFT_TEST_FAIL_ON_SKIP_EXCEPT=3D they can specify which are
> > expected to
> > =C2=A0 be skipped. The regex is kernel/environment specific, and must b=
e
> > =C2=A0 actively curated.
>=20
> Such downstream maintainer should be really concerned about the test
> failure and track the issue to make sure the fix gets to their
> downstream kernel.

None of the 3 use cases allow any "failures". Of course failures must
be avoided at all cost, because a failing test suite looses a lot of
it's benefits. There must be only PASS and some SKIP.


- Use case 1 is to not care about SKIPs and trust that they don't hide
a bug.

- Use case 2 is about not allowing any SKIPs at all. All tests must
PASS. NFT_TEST_FAIL_ON_SKIP=3Dy ensures that. You'll probably need to
build your own kernel for this.

- Use case 3 is about allowing only a selected list of SKIPs (and get
an error when the SKIP/PASS state of a test is not as expected).
NFT_TEST_FAIL_ON_SKIP_EXCEPT=3D is the "selected list".




>=20
> > =C2=A0 BONUS) actually, cases 2) and 3) optimally run automated CI
> > tests.
> > =C2=A0 Then the test environment is defined with a particular kernel
> > variant
> > =C2=A0 and changes slowly over time. NFT_TEST_FAIL_ON_SKIP_EXCEPT=3D
> > allows
> > =C2=A0 to pick up any unexpected changes of the skipped/pass behavior o=
f
> > =C2=A0 tests.
> >=20
> > If a test matches the regex but passes, this is also flagged as a
> > failure ([XPASS]). The user is required to maintain an accurate
> > list of
> > XFAIL tests.
> >=20
> > Example:
> >=20
> > =C2=A0 $ NFT_TEST_FAIL_ON_SKIP=3Dy \
> > =C2=A0=C2=A0=C2=A0 NFT_TEST_FAIL_ON_SKIP_EXCEPT=3D'^(tests/shell/testca=
ses/nft-
> > f/0017ct_timeout_obj_0|tests/shell/testcases/listing/0020flowtable_
> > 0)$' \
> > =C2=A0=C2=A0=C2=A0 ./tests/shell/run-tests.sh \
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tests/shell/test=
cases/nft-f/0017ct_timeout_obj_0 \
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tests/shell/test=
cases/cache/0006_cache_table_flush \
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tests/shell/test=
cases/listing/0013objects_0 \
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tests/shell/test=
cases/listing/0020flowtable_0
> > =C2=A0 ...
> > =C2=A0 I: [SKIPPED]=C2=A0=C2=A0=C2=A0=C2=A0 1/4 tests/shell/testcases/n=
ft-
> > f/0017ct_timeout_obj_0
> > =C2=A0 I: [OK]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2/=
4
> > tests/shell/testcases/cache/0006_cache_table_flush
> > =C2=A0 W: [FAIL-SKIP]=C2=A0=C2=A0 3/4 tests/shell/testcases/listing/001=
3objects_0
> > =C2=A0 W: [XPASS]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4/4
> > tests/shell/testcases/listing/0020flowtable_0
> >=20
> > This list of XFAIL tests is maintainable, because on a particular
> > downstream kernel, the number of tests known to be skipped is small
> > and
> > relatively static. Also, you can generate the list easily (followed
> > by
> > manual verification!) via
> >=20
> > =C2=A0 $ NFT_TEST_FAIL_ON_SKIP=3Dn ./tests/shell/run-tests.sh -k
> > =C2=A0 $ export NFT_TEST_FAIL_ON_SKIP_EXCEPT=3D"$(cat /tmp/nft-
> > test.latest.*/skip-if-fail-except)"
> > =C2=A0 $ NFT_TEST_FAIL_ON_SKIP=3Dy ./tests/shell/run-tests.sh
> >=20
> > Signed-off-by: Thomas Haller <thaller@redhat.com>
> > ---
> > Sorry for the overly long commit message. I hope it can be useful
> > and
> > speak in favor of the patch (and not against it).
> >=20
> > This is related to the "eval-exit-code" patch, as it's about how to
> > handle tests that are SKIPed. But it's relevant for any skipped
> > test,
> > and not tied to that work.
> >=20
> > =C2=A0tests/shell/helpers/test-wrapper.sh | 41 +++++++++++++++++++++
> > =C2=A0tests/shell/run-tests.sh=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 55 ++++++++++++++++++++++---
> > ----
> > =C2=A02 files changed, 83 insertions(+), 13 deletions(-)


