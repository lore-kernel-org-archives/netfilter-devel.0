Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D38CA0FE1
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Sep 2023 15:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbjIAPiN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Sep 2023 11:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjIAPiM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2023 11:38:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9C810CF
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2023 08:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693582642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U/t1QMmWeYYZQqC1YGOa4IZUJXq/rq5DSkfulGIflHw=;
        b=UCvyNvKHaFaOPlqqYkRi4jIZvCQJ0XyRWjwUNSj1tLnYs9iB0UBqCY9Jfp33+PXxg9gAS7
        ut/Vf1Dke0/tYWsn2hgyRgVNnj0oxDfkiTp90of6VKv0Vjotlsv02xc1O3Fc1fgMDZP0de
        yOZVfrqIXsxcUNtGXx3mNQsbgYmfF6g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-ThDjfbrcNZKSFY5Td0u3Gg-1; Fri, 01 Sep 2023 11:37:21 -0400
X-MC-Unique: ThDjfbrcNZKSFY5Td0u3Gg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3fe805a8826so5350375e9.0
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Sep 2023 08:37:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693582639; x=1694187439;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U/t1QMmWeYYZQqC1YGOa4IZUJXq/rq5DSkfulGIflHw=;
        b=Su23Y0031SNFgqor9NNwyYf+q0GLA+WTUY7KrJdOgqVNBfZlUEA4Z24Ws3OM3E1MVL
         BmvOvB1ybFKmq282VyTXgefhkRKyTER9+naGB/M7SsKJ1EAleITluKdB66aZyRLrk1bq
         VjRqZUgHblDK8qkvYAxjRdqcDZF+xARERZZ+k2xFZD5Pk7tD+GW7cPRxpiTdI0NThW+y
         8eDl2s3jHhDFgdO2kMZuCZofjPSS0uxLRs/gYxpKY9WDxqOMFipunuBp/F79A0zxJDoK
         pEcNetW6jW3a/u6F82g+firsAlvUI0hVG2/d3x9p+wHw1zqrXzQhVnpCuH/f7cTAHf8B
         +JMw==
X-Gm-Message-State: AOJu0YxWYMgGpEM9lM6wfYxBHBeaKiINqDWddV9+CBsPKJnENMQFRx/x
        bXgEsIuuiqusidmFKZiofeh5zYjHOTFiG7MtIbRJZgEXK0G+vNV7Lsqwvt+1RiU4EqutrtOxi7o
        IHiN1Qp6VVlRqCHfgGndDbv1Cp1Y6vUklsYfB
X-Received: by 2002:adf:de8a:0:b0:317:73e3:cf41 with SMTP id w10-20020adfde8a000000b0031773e3cf41mr2205963wrl.1.1693582639536;
        Fri, 01 Sep 2023 08:37:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlQep9hyMSQsc4GggsqHP645MsNasUa23zGImRItE2111UiuoJ81BsQ9CSrJo1lCv8xEvdZw==
X-Received: by 2002:adf:de8a:0:b0:317:73e3:cf41 with SMTP id w10-20020adfde8a000000b0031773e3cf41mr2205954wrl.1.1693582639180;
        Fri, 01 Sep 2023 08:37:19 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id e5-20020a5d5945000000b003197a4b0f68sm5600894wri.7.2023.09.01.08.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 08:37:18 -0700 (PDT)
Message-ID: <c322af5a87a7a4b31d4c4897fe5c3059e9735b4e.camel@redhat.com>
Subject: Re: [PATCH RFC] tests: add feature probing
From:   Thomas Haller <thaller@redhat.com>
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Date:   Fri, 01 Sep 2023 17:37:18 +0200
In-Reply-To: <20230831135112.30306-1-fw@strlen.de>
References: <20230831135112.30306-1-fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2023-08-31 at 15:51 +0200, Florian Westphal wrote:
> Running selftests on older kernels makes some of them fail very early
> because some tests use features that are not available on older
> kernels, e.g. -stable releases.
>=20
> Known examples:
> - inner header matching
> - anonymous chains
> - elem delete from packet path
>=20
> Also, some test cases might fail because a feature isn't
> compiled in, such as netdev chains for example.
>=20
> This adds a feature-probing to the shell tests.
>=20
> Simply drop a 'nft -f' compatible file with a .nft suffix into
> tests/shell/features.
>=20
> run-tests.sh will load it via --check and will add
>=20
> NFT_TESTS_HAVE_${filename}=3D$?
>=20
> to the environment.
>=20
> The test script can then either elide a part of the test
> or replace it with a supported feature subset.
>=20
> This adds the probing skeleton, a probe file for chain_binding
> and alters 30s-stress to suppress anonon chains when its unuspported.
>=20
> Note that 30s-stress is optionally be run standalone, so this adds
> more code than needed, for tests that always run via run-tests.sh
> its enough to do
>=20
> [ $NFT_HAVE_chain_binding -eq 1 ] && test_chain_binding
>=20
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> =C2=A0Not yet fully tested, so RFC tag.
>=20
> =C2=A0tests/shell/features/chain_binding.nft=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 |=C2=A0 5 ++
> =C2=A0tests/shell/run-tests.sh=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 | 23 ++++++++
> =C2=A0tests/shell/testcases/transactions/30s-stress | 52 ++++++++++++++++=
-
> --
> =C2=A03 files changed, 73 insertions(+), 7 deletions(-)
> =C2=A0create mode 100644 tests/shell/features/chain_binding.nft
>=20
> diff --git a/tests/shell/features/chain_binding.nft
> b/tests/shell/features/chain_binding.nft
> new file mode 100644
> index 000000000000..eac8b941ab5c
> --- /dev/null
> +++ b/tests/shell/features/chain_binding.nft
> @@ -0,0 +1,5 @@
> +table ip t {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0chain c {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0jump { counter; }
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> +}
> diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
> index b66ef4fa4d1f..3855bd9f4768 100755
> --- a/tests/shell/run-tests.sh
> +++ b/tests/shell/run-tests.sh
> @@ -163,6 +163,23 @@ ok=3D0
> =C2=A0failed=3D0
> =C2=A0taint=3D0
> =C2=A0
> +check_features()
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0for ffilename in features/*.nf=
t; do
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0feature=3D${ffilename#*/}
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0feature=3D${feature%*.nft}
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0eval NFT_HAVE_${feature}=3D0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0$NFT -f "$ffilename" 2>/dev/null

is the "--check" option here missing? At least, the commit message says

  "run-tests.sh will load it via --check and will add"


> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0if [ $? -eq 0 ]; then
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0eval NFT_=
HAVE_${feature}=3D1
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0else
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo "WAR=
NING: Disabling feature $feature"
> 1>&2
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0fi
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0export NFT_HAVE_${feature}

I think it should run in a separate netns too.
With "[PATCH nft v2 0/3] tests/shell: allow running tests as non-root"
patch, that would be `"${UNSHARE[@]}" $NFT ...`



> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0done
> +}
> +
> =C2=A0check_taint()
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0read taint_now < /proc/sy=
s/kernel/tainted
> @@ -211,6 +228,7 @@ check_kmemleak()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0fi
> =C2=A0}
> =C2=A0
> +check_features
> =C2=A0check_taint
> =C2=A0
> =C2=A0for testfile in $(find_tests)
> @@ -277,5 +295,10 @@ check_kmemleak_force
> =C2=A0
> =C2=A0msg_info "results: [OK] $ok [FAILED] $failed [TOTAL] $((ok+failed))=
"
> =C2=A0
> +if [ "$VERBOSE" =3D=3D "y" ] ; then
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo "Used Features:"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0env | grep NFT_HAVE_
> +fi


OK, that's nice, to see in the output.

But why this "nft -f" specific detection? Why not just executable
scripts?

Also, why should "run-tests.sh" pre-evaluate those NFT_HAVE_* features?
Just let each tests:

     if ! "$BASEDIR/features/chain-binding" ; then
         echo " defaultchain"
         return
     fi

then the checks are more flexible (arbitrary executables).

Downside, if the check is time consuming (which it shouldn't), then
tests might call it over and over. Workaround for that: have "run-
tests.sh" prepare a temporary directory and export it as
$NFT_TEST_TMPDIR". Then "features/chain-binding" can cache the result
there. "run-tests.sh" would delete the directory afterwards.

If you want to print those features, you can still let run-tests.sh
iterate over "$BASEDIR"/features/* and print the result.



> +
> =C2=A0kernel_cleanup
> =C2=A0[ "$failed" -eq 0 ]
> diff --git a/tests/shell/testcases/transactions/30s-stress
> b/tests/shell/testcases/transactions/30s-stress
> index 4d3317e22b0c..924e7e28f97e 100755
> --- a/tests/shell/testcases/transactions/30s-stress
> +++ b/tests/shell/testcases/transactions/30s-stress
> @@ -16,6 +16,18 @@ if [ x =3D x"$NFT" ] ; then
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0NFT=3Dnft
> =C2=A0fi
> =C2=A0
> +if [ -z $NFT_HAVE_chain_binding ];then
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0NFT_HAVE_chain_binding=3D0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mydir=3D$(dirname $0)

I think run-tests.sh should export the base directory, like "$BASEDIR",
or "$NFT_TEST_BASEDIR". Tests should use it (and rely to have it).



> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0$NFT --check -f $mydir/../../f=
eatures/chain_binding.nft
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if [ $? -eq 0 ];then
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0NFT_HAVE_chain_binding=3D1
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0else
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0echo "Assuming anonymous chains are not supported"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0fi
> +
> +fi

ah, you'd have each tests re-implement the check? So that they can run
without the "run-tests.sh" wrapper?

I think that use-case should be dropped. The "run-tests.sh" wrapper can
provide very useful features, and every test reimplementing that is
wrong. Just accept that test scripts should not be run directly, then
drop this [ -z $NFT_HAVE_chain_binding ] check.

Well, above I argue that "run-tests.sh" should not prepare "$NFT_HAVE_"
variables, instead have features-detections plain shell scripts, that
each test runs as needed.

The point here is, that if the "run-tests.sh" wrapper can provide
something useful, then tests should be able to rely on it (and don't
implement a fallback path).


> +
> =C2=A0testns=3Dtestns-$(mktemp -u "XXXXXXXX")
> =C2=A0tmp=3D""
> =C2=A0
> @@ -31,8 +43,8 @@ failslab_defaults() {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# allow all slabs to fail=
 (if process is tagged).
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0find /sys/kernel/slab/ -w=
holename '*/kmalloc-[0-9]*/failslab'
> -type f -exec sh -c 'echo 1 > {}' \;
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# no limit on the number of fa=
ilures
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo -1 > /sys/kernel/debug/fa=
ilslab/times
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# no limit on the number of fa=
ilures, or clause works around
> old kernels that reject negative integer.
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo -1 > /sys/kernel/debug/fa=
ilslab/times 2>/dev/null ||
> printf '%#x -1' > /sys/kernel/debug/failslab/times
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# Set to 2 for full dmesg=
 traces for each injected error
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo 0 > /sys/kernel/debu=
g/failslab/verbose
> @@ -91,6 +103,15 @@ nft_with_fault_inject()
> =C2=A0trap cleanup EXIT
> =C2=A0tmp=3D$(mktemp)
> =C2=A0
> +jump_or_goto()
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if [ $((RANDOM & 1)) -eq 0 ] ;=
then
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0echo -n "jump"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0else
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0echo -n "goto"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0fi
> +}
> +
> =C2=A0random_verdict()
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0max=3D"$1"
> @@ -102,7 +123,8 @@ random_verdict()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rnd=3D$((RANDOM%max))
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if [ $rnd -gt 0 ];then
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0printf "jump chain%03u" "$((rnd+1))"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0jump_or_goto
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0printf " chain%03u" "$((rnd+1))"
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0fi
> =C2=A0
> @@ -411,6 +433,21 @@ stress_all()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0randmonitor &
> =C2=A0}
> =C2=A0
> +gen_anon_chain_jump()
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo -n "insert rule inet $@ "
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0jump_or_goto
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if [ $NFT_HAVE_chain_binding -=
ne 1 ];then
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0echo " defaultchain"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0fi
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo -n " { "
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0jump_or_goto
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo " defaultchain; counter; =
}"
> +}
> +
> =C2=A0gen_ruleset() {
> =C2=A0echo > "$tmp"
> =C2=A0for table in $tables; do
> @@ -452,12 +489,13 @@ for table in $tables; do
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo "insert rule inet $t=
able $chain ip6 saddr { ::1,
> dead::beef } counter" comment hash >> "$tmp"
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo "insert rule inet $t=
able $chain ip saddr { 1.2.3.4 -
> 5.6.7.8, 127.0.0.1 } comment rbtree" >> "$tmp"
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# bitmap 1byte, with anon=
 chain jump
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo "insert rule inet $table =
$chain ip protocol { 6, 17 }
> jump { jump defaultchain; counter; }" >> "$tmp"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0gen_anon_chain_jump "$table $c=
hain ip protocol { 6, 17 }" >>
> "$tmp"
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# bitmap 2byte
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo "insert rule inet $t=
able $chain tcp dport !=3D { 22, 23,
> 80 } goto defaultchain" >> "$tmp"
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo "insert rule inet $t=
able $chain tcp dport { 1-1024,
> 8000-8080 } jump defaultchain comment rbtree" >> "$tmp"
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# pipapo (concat + set), =
with goto anonymous chain.
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo "insert rule inet $table =
$chain ip saddr . tcp dport {
> 1.2.3.4 . 1-1024, 1.2.3.6 - 1.2.3.10 . 8000-8080, 1.2.3.4 . 8080,
> 1.2.3.6 - 1.2.3.10 . 22 } goto { jump defaultchain; counter; }" >>
> "$tmp"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0gen_anon_chain_jump "$table $c=
hain ip saddr . tcp dport {
> 1.2.3.4 . 1-1024, 1.2.3.6 - 1.2.3.10 . 8000-8080, 1.2.3.4 . 8080,
> 1.2.3.6 - 1.2.3.10 . 22 }" >> "$tmp"
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# add a few anonymous set=
s. rhashtable is convered by named
> sets below.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0c=3D$((RANDOM%$count))
> @@ -466,12 +504,12 @@ for table in $tables; do
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo "insert rule inet $t=
able $chain ip6 saddr { ::1,
> dead::beef } counter" comment hash >> "$tmp"
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo "insert rule inet $t=
able $chain ip saddr { 1.2.3.4 -
> 5.6.7.8, 127.0.0.1 } comment rbtree" >> "$tmp"
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# bitmap 1byte, with anon=
 chain jump
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo "insert rule inet $table =
$chain ip protocol { 6, 17 }
> jump { jump defaultchain; counter; }" >> "$tmp"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0gen_anon_chain_jump "$table $c=
hain ip protocol { 6, 17 }" >>
> "$tmp"
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# bitmap 2byte
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo "insert rule inet $t=
able $chain tcp dport !=3D { 22, 23,
> 80 } goto defaultchain" >> "$tmp"
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo "insert rule inet $t=
able $chain tcp dport { 1-1024,
> 8000-8080 } jump defaultchain comment rbtree" >> "$tmp"
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# pipapo (concat + set), =
with goto anonymous chain.
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo "insert rule inet $table =
$chain ip saddr . tcp dport {
> 1.2.3.4 . 1-1024, 1.2.3.6 - 1.2.3.10 . 8000-8080, 1.2.3.4 . 8080,
> 1.2.3.6 - 1.2.3.10 . 22 } goto { jump defaultchain; counter; }" >>
> "$tmp"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0gen_anon_chain_jump "$table $c=
hain ip saddr . tcp dport {
> 1.2.3.4 . 1-1024, 1.2.3.6 - 1.2.3.10 . 8000-8080, 1.2.3.4 . 8080,
> 1.2.3.6 - 1.2.3.10 . 22 }" >> "$tmp"
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0# add constant/immutable =
sets
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0size=3D$((RANDOM%5120000)=
)

