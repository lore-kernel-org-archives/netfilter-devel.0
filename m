Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D103C61D92
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjKUMKW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbjKUMKV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:10:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B95138
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Nov 2023 04:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1700568617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=ocL8wINrFVIvdVJcGYbWdTrro5itXOx1/IACu+CRJHc=;
        b=V4u/o9Ei8wZO4SxLukQHe4uchQj++02wMI3CM0VAE9LtvRc4vYzQfTQ3mU5i9pRR/iJY+W
        AkC5JHAUR0jOxGdKDnN/04iCwAkPWHkbXJsgQYGcM5z1GgSSdmV1RSkKM9SxamBP9J3Jgv
        XtD3hnZsPB2EBqC5PerBsikfBwjx42k=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-9UhoHiGONcmEePZ9jPuwOw-1; Tue, 21 Nov 2023 07:10:15 -0500
X-MC-Unique: 9UhoHiGONcmEePZ9jPuwOw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-50aa94aeec4so606412e87.1
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Nov 2023 04:10:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700568614; x=1701173414;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ocL8wINrFVIvdVJcGYbWdTrro5itXOx1/IACu+CRJHc=;
        b=PaEPUBJu8ktbZOI5wR/IlIrnUu8X5Okr2iCNg9p1O3VTdw1uakLvrz0LFyR654qruy
         oSe0lTW87FPFEkLls3PjB79uefnjzkt20nYwsWzzq5PuHlsapU5UAOLMqdbbGrSNUHdb
         eNmG6ALou20PK7kk3SpH0kIsWB5EeBJnVzAN9NSW6VtAk7oJyqylWvqnCW8H+p35IRae
         +Nn664FvWuoJ3T1aIlaKkhJi1SmJQJt/7I5kDKQ4w5W2Dv5HS8A2I1kezbnZ1LAmBBdu
         XiPlT1eIQ/RfMGqeMSogjzq/rxAzRvNLMWZjesQUL+ZpqTZktXCBN90NOSftV4HH3rBU
         us3A==
X-Gm-Message-State: AOJu0YxvyHG7cZBLN5cDc05t9KLD567erEq18dssw0Twj3s/ngvIShf2
        2/a7KTCQSKkJnyDmAy03PbYrsEFFH6fohazsTxf9QPl49ZLEN9ApI4tKCmqIP4xZqaMKV3wBFTP
        mexSXUW5KSE9K3Jon+yhO7RPyxddhNu2D2bzP
X-Received: by 2002:ac2:5616:0:b0:507:9701:98dc with SMTP id v22-20020ac25616000000b00507970198dcmr6628943lfd.1.1700568613853;
        Tue, 21 Nov 2023 04:10:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHrKUp/VNjUKxH7C6O7Nugh0I8zLj8Z0UtseNkI+t3PNT3f/o3yjwMSIlsPDYY3bOYeuZKkVA==
X-Received: by 2002:ac2:5616:0:b0:507:9701:98dc with SMTP id v22-20020ac25616000000b00507970198dcmr6628925lfd.1.1700568613367;
        Tue, 21 Nov 2023 04:10:13 -0800 (PST)
Received: from [10.0.0.196] ([37.186.166.196])
        by smtp.gmail.com with ESMTPSA id w3-20020ac25983000000b0050aa51bd5b5sm1198137lfn.136.2023.11.21.04.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Nov 2023 04:10:12 -0800 (PST)
Message-ID: <f4b86e5318556be07a8c86c3fdd551ad5e22a831.camel@redhat.com>
Subject: Re: [PATCH nft 1/1] tests/shell: sanitize "handle" in JSON output
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 21 Nov 2023 13:10:11 +0100
In-Reply-To: <ZVgjLFGvHqoXXvjd@orbyte.nwl.cc>
References: <20231117171948.897229-1-thaller@redhat.com>
         <ZVgjLFGvHqoXXvjd@orbyte.nwl.cc>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.1 (3.50.1-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,


On Sat, 2023-11-18 at 03:36 +0100, Phil Sutter wrote:
> On Fri, Nov 17, 2023 at 06:18:45PM +0100, Thomas Haller wrote:
> > The "handle" in JSON output is not stable. Sanitize/normalizeit to
> > 1216.
> >=20
> > The number is chosen arbitrarily, but it's somewhat unique in the
> > code
> > base. So when you see it, you may guess it originates from
> > sanitization.
>=20
> Valid handles are monotonic starting at 1. Using 0 as a replacement
> is
> too simple?

Changed.

>=20
> > Signed-off-by: Thomas Haller <thaller@redhat.com>
> > ---
> > Note that only a few .json-nft files are adjusted, because
> > otherwise the
> > patch is too large. Before applying, you need to adjust them all,
> > by
> > running `./tests/shell/run-tests.sh -g`.
>=20
> Just put the bulk change into a second patch?

it would require 3 patches to stay below the limit.

Also, it blows up the inbox by everybody on the list by 850K (57k
gzipped). The rest of the patch is generated. Just generate it.

Alternatively,

  git fetch https://gitlab.freedesktop.org/thaller/nftables df984038a33c6da=
5b159e6f6458351c4fa673bf1
  git merge FETCH_HEAD
 =20


>=20
> [...]
> > diff --git a/tests/shell/helpers/json-sanitize-ruleset.sh
> > b/tests/shell/helpers/json-sanitize-ruleset.sh
> > index 270a6107e0aa..3b66adabf055 100755
> > --- a/tests/shell/helpers/json-sanitize-ruleset.sh
> > +++ b/tests/shell/helpers/json-sanitize-ruleset.sh
> > @@ -6,7 +6,14 @@ die() {
> > =C2=A0}
> > =C2=A0
> > =C2=A0do_sed() {
> > -	sed '1s/\({"nftables": \[{"metainfo": {"version": "\)[0-
> > 9.]\+\(", "release_name": "\)[^"]\+\(",
> > "\)/\1VERSION\2RELEASE_NAME\3/' "$@"
> > +	# Normalize the "version"/"release_name", otherwise we
> > have to regenerate the
> > +	# JSON output upon new release.
> > +	#
> > +	# Also, "handle" are not stable. Normalize them to 1216
> > (arbitrarily chosen).
> > +	sed \
> > +		-e '1s/\({"nftables": \[{"metainfo": {"version":
> > "\)[0-9.]\+\(", "release_name": "\)[^"]\+\(",
> > "\)/\1VERSION\2RELEASE_NAME\3/' \
> > +		-e '1s/"handle": [0-9]\+\>/"handle": 1216/g' \
> > +		"$@"
> > =C2=A0}
>=20
> Why not just drop the whole metainfo object? A dedicated test could
> still ensure its existence.

Normalization should only perform the absolute minimal of tampering.


> Also, scoping these replacements to line 1 is funny with single line
> input. Worse is identifying the change in the resulting diff. Maybe
> write a helper in python which lets you more comfortably sanitize
> input,
> sort attributes by key and output pretty-printed?

You mean, to parse and re-encode the JSON? That introduces additional
changes, which seems undesirable. That's why the regex is limited to
the first line (even if we only expect to ever see one line there).

Also, normalization via 2 regex seems simpler than writing some python.

Well, pretty-printing the output with `jq` would have the advantage,
that future diffs might be smaller (changing individual lines, vs.
replace one large line). Still, I think it's better to keep the amount
of post-processing minimal.


>=20
> In general, the long lines in your scripts make them quite hard to
> read.
> Any particular reason why you don't stick to the 80 columns maxim?

I wrapped two lines in the patch.



Thomas

