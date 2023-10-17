Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20180CDB474
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 06:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbjJQGXg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 02:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjJQGXf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 02:23:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24A18F
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 23:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697523773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W0bEk7SY8Xjz6IJPdE3DgwMTVkMBNcTeou93v3yvcp4=;
        b=e3XjA7pmY+Qot4BE0QgyH0AyHZoFAA6X8PmwdbYxPKXt1VI3gRRrPLR3x+ikQD181ZG3Xv
        SVZ9n76dgW+aH47WT2JMUY9oYvYoCFzyzgtzpO6q7jst7nVAjqcP1vm0ofA31p3crhqR70
        2wjXUbFu5W28EIU3AdVK3CKqTA8Me5c=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-MU5tF4HQM8GWqhhvAC-WVQ-1; Tue, 17 Oct 2023 02:22:51 -0400
X-MC-Unique: MU5tF4HQM8GWqhhvAC-WVQ-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-534838150afso634965a12.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 23:22:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697523770; x=1698128570;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W0bEk7SY8Xjz6IJPdE3DgwMTVkMBNcTeou93v3yvcp4=;
        b=Mxu8K8jcrusLBQ4FAOWuqby+ZcPeJudl4EgUGgIT3cQE+4xLaK8lbH+vzInc4ceFr9
         Mp5Hw5JIeV9b4SZkm9ts+0mYmpqEWBs3iBBOqu3MX4BIKJs6IWU139zeq7llXSlGmj5K
         CXCSTFrnMf7J7f5vCt1K6ArG4XyGrtTEalArTGnrsJ33NmGlW1XM4RIJRrdR5ium5YRu
         GX7WICkyqldPKvKnNjnNv+3/o26CQKgDArqjiYwI+Xoyb7K79Wt1xQzUlpv65n8oFNuc
         R2fiJuz2fvoiyqXcALGfaQjetGIQxvJlW/A2yl5zQQTi3imAROIaOntKaRchqUTs8A7T
         l4tQ==
X-Gm-Message-State: AOJu0Yy7GhGN6YSevl0PBl2KV9Q03/VLDF/0EFkeRBzk17tqYQAHB5If
        wer1Fv6hCPV9/Q84r9xb+rR+FbfWYE1JuY8TDebBZo5bCtupwAGCp2UecpV2uJbLum1308G/4ZW
        At8TYRBtYFlSFYEvac4yVul2ZuTYG7f27gMNv
X-Received: by 2002:a50:f60d:0:b0:521:66b4:13b4 with SMTP id c13-20020a50f60d000000b0052166b413b4mr929347edn.0.1697523770486;
        Mon, 16 Oct 2023 23:22:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFK+u/JtUASuUOKIdUb0thTMaOqw2DdXVQzRfjtOQ+s/ZkRDfqbYpLNPTuBorSlyNduNAvA3w==
X-Received: by 2002:a50:f60d:0:b0:521:66b4:13b4 with SMTP id c13-20020a50f60d000000b0052166b413b4mr929340edn.0.1697523770120;
        Mon, 16 Oct 2023 23:22:50 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.64])
        by smtp.gmail.com with ESMTPSA id eh15-20020a0564020f8f00b0053e775e428csm559339edb.83.2023.10.16.23.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 23:22:49 -0700 (PDT)
Message-ID: <a64bccda9ab11f18f13d0512001985d1bf9f04ff.camel@redhat.com>
Subject: Re: [PATCH nft 1/3] tests/shell: skip "table_onoff" test if kernel
 patch is missing
From:   Thomas Haller <thaller@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 17 Oct 2023 08:22:48 +0200
In-Reply-To: <ZS2bKZVAN5d5dax-@strlen.de>
References: <20231016131209.1127298-1-thaller@redhat.com>
         <ZS2bKZVAN5d5dax-@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,


On Mon, 2023-10-16 at 22:20 +0200, Florian Westphal wrote:
> Thomas Haller <thaller@redhat.com> wrote:
> > Passing the test suite must not require latest kernel patches.=C2=A0 If
> > test
> > "table_onoff" appears to not work due to a missing kernel patch,
> > skip
> > it.
> >=20
> > If you run a special kernel and expect that all test pass, set
> > NFT_TEST_FAIL_ON_SKIP=3Dy to catch unexpected skips.
>=20
> This makes the test suite and all feature probing moot for my use
> cases.
> If I see SKIP, I assume that the feature is missing.

As you probably run a self-built kernel, wouldn't you just `export
NFT_TEST_FAIL_ON_SKIP=3Dy` and reject all skips as failures? What's the
problem with that? That exists exactly for your use case.

The test suite should be usable on some recent + popular distro kernels
(like Fedora 38). That will also be rather important, once the tests
are invoked by `make check` (I have patches for that, it's very simple
and rather nice!).


>=20
> This is a bug, and it tells me that I might have to do something
> about it.

OK, do you intend to fix this bug in a very timely manner on Fedora 38
(and other popular kernels)? Then maybe hold back the test until that
happend? (or let it skip for now, and in a few weeks, upgrade to hard
failure -- the only problem is not to forget about that).

>=20
> If you absolutely cannot have a failure because of this, then
> please add another error state for this, so that I can see that
> something is wrong.
>=20
> This is NOT the same as a skip because some distro kernel lacks
> anonymous chain support.
>=20
> That said, I would STRONLGY perfer failure here.
> Distros will ship updates that eventually also include this bug fix.

>=20
> This fix is included in 6.5.6 for example.
>=20

Ah right. "tests/shell/testcases/transactions/table_onoff" is fixed on
6.5.6-200.fc38.x86_64. There still is a general problem. For example
what about tests/shell/testcases/packetpath/vlan_8021ad_tag ?



Maybe there could be two levels of NFT_TEST_FAIL_ON_SKIP. Maybe
"always" or "bugs-only". Then either:

1) the test would exit 78 instead of 77. And run-test.sh would treat 78
either as failure or as skip, based on NFT_TEST_FAIL_ON_SKIP

2) the test itself could look at NFT_TEST_FAIL_ON_SKIP and decide
whether to exit with 77 or 1.


Or how about adding a mechanism, that compares the kernel version and
decides whether to skip? For example


if ! printf "%s" "$OUT" | grep -q 'counter packets 1 bytes 84' ; then
    echo "Filter did not match. Assume kernel lacks fix https://git.kernel.=
org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3Daf84f9e447a65b=
4b9f79e7e5d69e19039b431c56"
    "$NFT_TEST_BASEDIR/helpers/eval-exit-code" kernel 6.5.6 || exit $?
fi


where "eval-exit-code" will either exit with 1 or 77 and log a message
(about the result of the comparison).

The "kernel" arguments indicates to compare the `uname` output in some
useful >=3D way.



How about "eval-exit-code"?


Thomas

