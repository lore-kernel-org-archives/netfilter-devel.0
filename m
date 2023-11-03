Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37E9C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 13:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376633AbjKCNJR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 09:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376554AbjKCNJQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 09:09:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9D483
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 06:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699016904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=HhOzXPaZene3iWjejkMgue4w/jVaGmDbiqz2n/mCgMQ=;
        b=EZoExf2GIGBkV2rCg+CA5f0L+NEnfBtQSPDTAOwukemhwPpSpOFs3T8WGkmJycwKxRd8/q
        3oLrEBQM6CtOCGomId+D+bj8iD4v4qk/GkRZYZ28X3YcGW02i/rqST+IS3HM884FG/5a7C
        yL7aq9z3Wj8Reorqt/hgMcbRjOoG6go=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-oPEpqiIoMOe8cHJsccohhw-1; Fri, 03 Nov 2023 09:08:20 -0400
X-MC-Unique: oPEpqiIoMOe8cHJsccohhw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40778b52dbaso3345435e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Nov 2023 06:08:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699016899; x=1699621699;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HhOzXPaZene3iWjejkMgue4w/jVaGmDbiqz2n/mCgMQ=;
        b=qVBRB/dUTCs6Pwxy1ra2tED6n01Wk7DjRQkPhv9GGasmjjAmUwDQQ+cRnSa16sBhEh
         E6yhaRQMvB/cIg1hCH52R/p2IlS8/Cm79KXxAZGTl5OHlolDot9e3NEAZ6vXPCVO3c4G
         yL+fRUMI6Syaa3ZC4Ws2hSRIkJ6Hy57x5MIuOoxhnraNdMHXcBlqsqeBtWfXIKwVJBXv
         BNQRwxki84qTiW3Qee+3ZGP1jCpg25KwTD8CLm/llDHmZ9CPuwbEl45CYmn19Lx4LGuU
         MurpggKQoSpJ8v2/Vp3nzOCDvaY6m50ZuvLems4RcU9rXLjHWKj/ItwnaA5HVAQbDl+F
         /Dvw==
X-Gm-Message-State: AOJu0YzIPjn7mA08aalGUDmEOrb5a06RJ/qjxeNTDEPntgBpZiT0505q
        52n5iubLKJNNPLDHuOt0QA4VMvdfJqcluodfGK+x2zHMmyloTDcAqGohtHpmL/CtFM3uhpMjm+c
        3RGjD9ScBV63XdU0fJJtp+yvrpdsgUzT5VJ2H
X-Received: by 2002:a05:600c:5128:b0:401:c07f:72bd with SMTP id o40-20020a05600c512800b00401c07f72bdmr17529769wms.4.1699016899269;
        Fri, 03 Nov 2023 06:08:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEujVxryIWlOE6nt/cxqBvEvcQcbBrvuWvh7EQzhKjX9Rekocx4Yq1LlFgJwUzQdtLBm3+yag==
X-Received: by 2002:a05:600c:5128:b0:401:c07f:72bd with SMTP id o40-20020a05600c512800b00401c07f72bdmr17529750wms.4.1699016898883;
        Fri, 03 Nov 2023 06:08:18 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.169.33])
        by smtp.gmail.com with ESMTPSA id q6-20020a05600c2e4600b003feae747ff2sm2376024wmf.35.2023.11.03.06.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Nov 2023 06:08:18 -0700 (PDT)
Message-ID: <62276e014e13568699f4d61f4ba123adb0c8430d.camel@redhat.com>
Subject: Re: [PATCH nft 0/6] add infrastructure for unit tests
From:   Thomas Haller <thaller@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Fri, 03 Nov 2023 14:08:17 +0100
In-Reply-To: <20231103122641.GC8035@breakpoint.cc>
References: <20231103111102.2801624-1-thaller@redhat.com>
         <20231103122641.GC8035@breakpoint.cc>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.0 (3.50.0-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2023-11-03 at 13:26 +0100, Florian Westphal wrote:
> Thomas Haller <thaller@redhat.com> wrote:
>=20
> Thanks for sending an initial empty skeleton.
>=20
> > There are new new make targets:
> >=20
> > =C2=A0 - "build-all"
> > =C2=A0 - "check" (runs "normal" tests, like unit tests and "tools/check=
-
> > tree.sh").
> > =C2=A0 - "check-more" (runs extra tests, like "tests/build")
> > =C2=A0 - "check-all" (runs "check" + "check-more")
> > =C2=A0 - "check-local" (a subset of "check")
> > =C2=A0 - "check-TESTS" (the unit tests)
>=20
> "check-unit" perhaps?=C2=A0 TESTS isn't very descriptive.=C2=A0 Also,
> why CAPS? If this is some pre-established standard, then maybe just
> document that in the commit changelog.

"TESTS" is an autotools/automake thing. "check-TESTS" runs the tests
that are setup via "TESTS=3D".

AFAIU, with autotools, `make check` basically runs the targets `make
check-local` and `make check-TESTS`.


Anyway, I can just alias it via:

  check-unit: check-TESTS



Note that other targets are currently called

  `make check-tests-build`
  `make check-tests-shell` (patch not yet send).

It reminds of the directories "tests/{build,shell,unit}" and would lead
to a name `make check-tests-unit`.

But reconsidering, in v2 I will drop this "check-tests-" prefix then
and call them just "check-{unit,build,shell}".

>=20
> Please don't do anything yet and wait for more comments, but
> I would prefer 'make check' to run all tests that we have.

currently `make check-more` only entails `make check-tests-build` (i.e.
`tests/build/run-tests.sh`). Note that

 - `tests/build/run-tests.sh` calls `make distcheck`
 - `make distcheck` runs `make check`.

I don't think it would make sense, to include the build check in `make
check`.

So I think there is a (small) place for "check-more" (and thus "check-
all"). But yes, probably most other tests should be included by the
common `make check`!



>=20
> I would suggest
> - "check" (run all tests)
> - "check-unit" (the unit tests only)
> - "check-shell" (shell tests only)
> - "check-py" (python based tests only)
> - "check-json" (python based tests in json mode and json_echo)
>=20
> ...=C2=A0 and so on.
>=20

ACK. Will send in v2.

