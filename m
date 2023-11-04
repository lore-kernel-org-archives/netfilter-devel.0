Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15718C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Nov 2023 06:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjKDGW4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Nov 2023 02:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjKDGWz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Nov 2023 02:22:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52565D45
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 23:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699078924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=CaMvEKIs/d+la5HPqt8RZCge3jiyjz/cxsER+Ek+8j0=;
        b=JbGjatq24Jdz2cxVnGjuCiHaHmXi8hgQbT7PpkAGOs0sCLbv/XABoKVOKqOvImW+lLI3lp
        Do2LKq5zJiFxqWVgGZc+Nb2ZlBmxJSDbK5LRMc217wwQffJ+EgtX56N7LioXTKnKaSa2lB
        R/C+URA3rNuv0MY07sg2s3wcUwjJwlY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-xN3t382MNbO_WEylZntovg-1; Sat, 04 Nov 2023 02:22:00 -0400
X-MC-Unique: xN3t382MNbO_WEylZntovg-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9c45a6a8832so38771266b.1
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Nov 2023 23:22:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699078919; x=1699683719;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CaMvEKIs/d+la5HPqt8RZCge3jiyjz/cxsER+Ek+8j0=;
        b=vNc8stIaFFKtDLnYa+HEXevrIKE8f3PtpMEszUmus4MyT+87SSKGwlrxdI0RuWNUzN
         bLpVQWl7IzaNo60XQPFXe7vMvdscOsOhguSqno8rGMa7WOyDk+2LqN1d6oc2wEtbpd3f
         6LQBeYU7svdKEl9rr5sMDGJULi3V66APXACjcOEKK9NEXdb+BZNU15TTgThBaN42Fm3g
         YpYYaCyK0R9Prf0NoMEsN+gSrn8ppvG64V1tObuRjjj6M7zyNBQqU0EqZogIDUBBKig8
         8RV5G8viZZ2w4ky3DJ7z/WfL1V4bHIfNfbV4MlhcYpoIqTN6aiXDr+2Q5CiQCdcfrSqC
         l19A==
X-Gm-Message-State: AOJu0YzXWUOvkLxaFXBTsuHmrhVbrvevtzcQXyWKyuNCAbOdKAmpgZcW
        5y/Zw/W/3MjXJ9i3tJfnyAIQO01Qgm1C709gVEhgN5qXgXejms9R0wJdqnD2s61N9OnvNr/QVC2
        fb18Pb8OuXsFA8G76kUrsDCoLCooyshL3b/WT
X-Received: by 2002:a17:907:9705:b0:9be:f78a:d438 with SMTP id jg5-20020a170907970500b009bef78ad438mr16455515ejc.5.1699078919197;
        Fri, 03 Nov 2023 23:21:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZclvZZtxQj1wVmwVAwMsywf3y9k+4DiZ3/TJHWHNkLn7YqcS5/4BHb2haX7FytxNzRS6/4Q==
X-Received: by 2002:a17:907:9705:b0:9be:f78a:d438 with SMTP id jg5-20020a170907970500b009bef78ad438mr16455510ejc.5.1699078918868;
        Fri, 03 Nov 2023 23:21:58 -0700 (PDT)
Received: from [10.0.0.168] ([37.186.169.33])
        by smtp.gmail.com with ESMTPSA id a1-20020a170906368100b0099bd453357esm1630561ejc.41.2023.11.03.23.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Nov 2023 23:21:58 -0700 (PDT)
Message-ID: <fd628d3f44e56920c09d17c91b4dd4f9403ff6ae.camel@redhat.com>
Subject: Re: [PATCH nft v3 2/2] json: drop warning on stderr for missing
 json() hook in stmt_print_json()
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Sat, 04 Nov 2023 07:21:57 +0100
In-Reply-To: <ZUVqhFgp4KJy8bqI@orbyte.nwl.cc>
References: <20231103162937.3352069-1-thaller@redhat.com>
         <20231103162937.3352069-3-thaller@redhat.com>
         <ZUVqhFgp4KJy8bqI@orbyte.nwl.cc>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.0 (3.50.0-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2023-11-03 at 22:47 +0100, Phil Sutter wrote:
> On Fri, Nov 03, 2023 at 05:25:14PM +0100, Thomas Haller wrote:
> > All "struct stmt_ops" really must have a json hook set, to handle
> > the
> > statement. And almost all of them do, except "struct
> > chain_stmt_ops".
> >=20
> > Soon a unit test will be added, to check that all stmt_ops have a
> > json()
> > hook. Also, the missing hook in "struct chain_stmt_ops" is a bug,
> > that
> > is now understood and shall be fixed soon/later.
> >=20
> > Note that we can already hit the bug, if we would call `nft -j list
> > ruleset` at the end of test "tests/shell/testcases/nft-f/sample-
> > ruleset":
> >=20
> > =C2=A0=C2=A0=C2=A0 warning: stmt ops chain have no json callback
> >=20
> > Soon tests will be added, that hit this condition. Printing a
> > message to
> > stderr breaks those tests, and blocks adding the tests.
>=20
> Why not make the tests tolerate messages on stderr instead?

Right. That's what the v2 of the patchset does:

+	$NFT -j list ruleset > "$NFT_TEST_TESTTMPDIR/ruleset-after.json" 2> "$NFT=
_TEST_TESTTMPDIR/chkdump" || rc=3D$?
+
+	# Workaround known bug in stmt_print_json(), due to
+	# "chain_stmt_ops.json" being NULL. This spams stderr.
+	sed -i '/^warning: stmt ops chain have no json callback$/d' "$NFT_TEST_TE=
STTMPDIR/chkdump"

I'd prefer not to add the workaround at other places, but at what the
problem is. But both works!


>=20
> > Drop this warning on stderr, so we can add those other tests
> > sooner, as
> > those tests are useful for testing JSON code in general. The
> > warning
> > stderr was useful for finding the problem, but the problem is now
> > understood and will be addressed separately. Drop the message to
> > unblock
> > adding those tests.
>=20
> What do you mean with "the problem is now understood"?

I mean,

It's understood that "chain_stmt_ops.json" has this problem and needs
fixing. It should be planned for doing that (a bugzilla?).

Other potential future issues in this regard (accidentally forgetting
"json" hook in a chain_stmt_ops) will be prevented by a unit test and
more tests (automatically run `nft -j list ruleset`). Those tests are
on the way.

That makes the area of code handled ("understood").

>=20
> > Signed-off-by: Thomas Haller <thaller@redhat.com>
> > ---
> > =C2=A0src/json.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 10 ++++++++--
> > =C2=A0src/statement.c |=C2=A0 1 +
> > =C2=A02 files changed, 9 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/src/json.c b/src/json.c
> > index 25e349155394..8fff401dfb3e 100644
> > --- a/src/json.c
> > +++ b/src/json.c
> > @@ -83,8 +83,14 @@ static json_t *stmt_print_json(const struct stmt
> > *stmt, struct output_ctx *octx)
> > =C2=A0	if (stmt->ops->json)
> > =C2=A0		return stmt->ops->json(stmt, octx);
> > =C2=A0
> > -	fprintf(stderr, "warning: stmt ops %s have no json
> > callback\n",
> > -		stmt->ops->name);
>=20
> Converting this to using octx->error_fp does not help?
>=20
> > +	/* In general, all "struct stmt_ops" must implement json()
> > hook. Otherwise
> > +	 * we have a bug, and a unit test should check that all
> > ops are correct.
> > +	 *
> > +	 * Currently, "chain_stmt_ops.json" is known to be NULL.
> > That is a bug that
> > +	 * needs fixing.
> > +	 *
> > +	 * After the bug is fixed, and the unit test in place,
> > this fallback code
> > +	 * can be dropped. */
>=20
> How will those unit tests cover new statements added at a later time?
> We
> don't have a registration process, are you planning to discover them
> based on enum stmt_types or something like that?

Good point! Some extra effort will be necessary to register/find the
stmt_ops.

I would propose=20
https://gitlab.freedesktop.org/thaller/nftables/-/commit/6ac04f812948ee6df4=
9ad90a0507b62ed877ead7#118691ec02f9e8625350a91de8a6490b82a51928_262_285

which requires one extra line per ops.

The test checks that all stmt_types are found, so you almost cannot
forget the registration.


Thomas

