Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B25C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Nov 2023 14:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjKFOTL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Nov 2023 09:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjKFOTK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2023 09:19:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D1EB8
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2023 06:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699280300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=dFcBZ6JYO/gB2eQKxLoqdPg++qOCxc+Y+c5h6+aukhI=;
        b=bZCDFW45pJR8FQyeOcSc0OlnJcGobHoS56lYLgBALuI/mvql3PPaRz0orvZGwY4hbT5prk
        ydBCzlUL2vEE+UqegnaHWILP7Yi5AA7ULNDTAxfuTUvjfBDAhJIRsXa8971NTVDR/ZV839
        kJNcdHU5imvczKZi4Pu8dGUeA/PLRA4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-EwkCBPErNWCQW_WDbyb2_g-1; Mon, 06 Nov 2023 09:18:12 -0500
X-MC-Unique: EwkCBPErNWCQW_WDbyb2_g-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-542d011ca7dso672460a12.1
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Nov 2023 06:18:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699280291; x=1699885091;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dFcBZ6JYO/gB2eQKxLoqdPg++qOCxc+Y+c5h6+aukhI=;
        b=r7Uzop0QgM1wLQgDf0vz6Y7/yoMgKjRdCik3ROwy8897Q6Ytv+q+FG3mBdITWr/Mfk
         fxNQ5IcVNDd3Oj/waLFIAPN2MHpDZzoZ3nkggU/nW5H2l9DhzZxnf1eB2T1IB6sRPZrZ
         RhsBAbGZ8selWAVizN6KtzsysVUEJmKTlTov60KCvVbCRZtQpJAhkPtlFLfKfbDjcqWq
         kMiAFCu47QYJlznz+K0QDZkaA6RYRJzYwAgW1GsetS3CvMfURtoHc1G73ZaUGvcGAlwd
         4yYizRFhcrALnZGJNhb2nzmEyShwkcBzw87dIOadzcWCDyDvjq7S0mKu8XAbkIX8aDY6
         KErQ==
X-Gm-Message-State: AOJu0Yw17+adsPlSry6XzOr0SoQnwr7yC49s6PXcsIEJPYCRUuXu1FEq
        ZGlVYywLOr3zNMY+yFTRlW5ZiQjUb1h5/oCXEebenBKugdA375Og8x+Ez7OZnExkL9YNDKotar0
        7AsC5XXeJZazTCgExOe3eSwGV2VGeKWyD2oKh
X-Received: by 2002:a50:c05b:0:b0:543:83a3:f39 with SMTP id u27-20020a50c05b000000b0054383a30f39mr13103344edd.4.1699280290870;
        Mon, 06 Nov 2023 06:18:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHw5s5g2mxoqt3XrclNzSId4N3lScVPnl/oAC5/O5c/2Mhxm56yssxX02sCPOrJfSDjZlJf2w==
X-Received: by 2002:a50:c05b:0:b0:543:83a3:f39 with SMTP id u27-20020a50c05b000000b0054383a30f39mr13103331edd.4.1699280290536;
        Mon, 06 Nov 2023 06:18:10 -0800 (PST)
Received: from [10.0.0.196] ([37.186.169.33])
        by smtp.gmail.com with ESMTPSA id fd20-20020a056402389400b005400dc94f43sm4354634edb.45.2023.11.06.06.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 06:18:10 -0800 (PST)
Message-ID: <66cdcac5d2534a907d9e1b2f6f2f89d98126e4ca.camel@redhat.com>
Subject: Re: [PATCH nft v2 3/6] tests/shell: add JSON dump files
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Date:   Mon, 06 Nov 2023 15:18:09 +0100
In-Reply-To: <ZUjyW5Kx40Z8TUYo@calendula>
References: <20231103182901.3795263-1-thaller@redhat.com>
         <20231103182901.3795263-4-thaller@redhat.com>
         <a26297c51f49e2f8af1c6eb3f2f18a54b5cd347b.camel@redhat.com>
         <ZUjyW5Kx40Z8TUYo@calendula>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.0 (3.50.0-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 2023-11-06 at 15:04 +0100, Pablo Neira Ayuso wrote:
> On Mon, Nov 06, 2023 at 02:56:18PM +0100, Thomas Haller wrote:
> > On Fri, 2023-11-03 at 19:26 +0100, Thomas Haller wrote:
> > > Generate and add ".json-nft" files. These files contain the
> > > output of
> > > `nft -j list ruleset` after the test. Also, "test-wrapper.sh"
> > > will
> > > compare the current ruleset against the ".json-nft" files and
> > > test
> > > them
> > > with "nft -j --check -f $FILE`. These are useful extra tests,
> > > that we
> > > almost get for free.
> > >=20
> > > Note that for some JSON dumps, `nft -f --check` fails (or prints
> > > something). For those tests no *.json-nft file is added. The bugs
> > > needs
> > > to be fixed first.
> > >=20
> > > An example of such an issue is:
> > >=20
> > > =C2=A0=C2=A0=C2=A0 $ DUMPGEN=3Dall ./tests/shell/run-tests.sh
> > > tests/shell/testcases/maps/nat_addr_port
> > >=20
> > > which gives a file "rc-failed-chkdump" with
> > >=20
> > > =C2=A0=C2=A0=C2=A0 Command `./tests/shell/../../src/nft -j --check -f
> > > "tests/shell/testcases/maps/dumps/nat_addr_port.json-nft"` failed
> > > =C2=A0=C2=A0=C2=A0 >>>>
> > > =C2=A0=C2=A0=C2=A0 internal:0:0-0: Error: Invalid map type 'ipv4_addr=
 .
> > > inet_service'.
> > >=20
> > > =C2=A0=C2=A0=C2=A0 internal:0:0-0: Error: Parsing command array at in=
dex 3
> > > failed.
> > >=20
> > > =C2=A0=C2=A0=C2=A0 internal:0:0-0: Error: unqualified type integer sp=
ecified in
> > > map
> > > definition. Try "typeof expression" instead of "type datatype".
> > >=20
> > > =C2=A0=C2=A0=C2=A0 <<<<
> > >=20
> > > Tests like "tests/shell/testcases/nft-f/0012different_defines_0"
> > > and
> > > "tests/shell/testcases/nft-f/0024priority_0" also don't get a
> > > .json-
> > > nft
> > > dump yet, because their output is not stable. That needs fixing
> > > too.
> > >=20
> > > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > > Cc: Florian Westphal <fw@strlen.de>
> > > Signed-off-by: Thomas Haller <thaller@redhat.com>
> > > ---
> > ...
> > > =C2=A0tests/shell/testcases/sets/dumps/0062set_connlimit_0.json-nft=
=C2=A0=C2=A0=C2=A0
> > > |=20
> > ...
> > > tests/shell/testcases/sets/dumps/0062set_connlimit_0.json-nft
> > > =C2=A0create mode 100644
> >=20
> >=20
> > "tests/shell/testcases/sets/dumps/0062set_connlimit_0.json-nft"
> > need to
> > be dropped from this patch.
> >=20
> > Otherwise,
> >=20
> > =C2=A0 make && ./tests/shell/run-tests.sh
> > tests/shell/testcases/sets/0062set_connlimit_0 -V
> >=20
> > fails (in valgrind mode).
>=20
> I have to fix 0062set_connlimit_0, the listing fails because the GC
> is
> fast enough to remove the entry that just got added, because it has
> no
> conntrack entries.
>=20
> Maybe valgrind is just getting things slowier there to trigger what
> I can already reproduce here on a VM?


that sounds very plausible.

By adding a `sleep 1` at the end of
"tests/shell/testcases/sets/0062set_connlimit_0", the dump
"tests/shell/testcases/sets/dumps/0062set_connlimit_0.nft" also no
longer matches.


Thomas

