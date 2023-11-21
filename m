Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CCEC61D92
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 14:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbjKUOfz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 09:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbjKUOfx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 09:35:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEE61A3
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Nov 2023 06:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1700577348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=uI9Vhstq2dQEyF8zRzQGPDVV4OwrDvDx7b9b7Lm0EDs=;
        b=cVsYR0XayOvzUAEPQdXut+V5XyNbGzK84k9Hq90juFWBhHUiFwLxnLML9j2AHD4CE7mIzF
        wVvykuNZTNPU5db62bHAamtuI9r+KCnH0arrukMvCyZsRf6zWsTfrFSfAc9rxqyiZjJbD7
        6kb4c17AvlVv7CSPDCYh4k6lmwCuvBI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-j9G58Qo3MYGHUEZ3SFKubw-1; Tue, 21 Nov 2023 09:35:46 -0500
X-MC-Unique: j9G58Qo3MYGHUEZ3SFKubw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-332c60c132dso471367f8f.1
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Nov 2023 06:35:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700577344; x=1701182144;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uI9Vhstq2dQEyF8zRzQGPDVV4OwrDvDx7b9b7Lm0EDs=;
        b=tE7oebMgG6h3MMyyYiLdIgkEZPIgIYo8o1NZxTiUYAeBwYuvEzVRH8CEYnzL8tEWBs
         H2lEOEnAarGMp+pbNi7XX0Ms9mOKPTy/LTRxVST31o0omFVHwNHpVtNCW24cNWBdMkbi
         jfGnuvjeDPhx/7soCAsb4brRAL+fBGqu8sIp9aevHkscaxkbOja8zZfrXDurnajW85xb
         AuutFbjf37caelMWc9+XSZs/YDJQm6j1sH2n9hkLgvPkGLekOO3zgJI32vmsoDzmDmDz
         k4L9FAKqCHffO0srp82BuAdVIyhovEUadsK6DwVe3bcPUhQH930rovi5cTKVFu3qRqeA
         JDbg==
X-Gm-Message-State: AOJu0YxsKwkwg4Bi74dOGWEPqHERTarHY6Fi6fBQb9TvVW9/Ne5GhcFj
        JpwONurBEmHez3sZB5tqYrK/5RDcj0q1doh7NWHRgGUmA3LjCKf9VGjf6IBYcKtZ78vNy+wwBY0
        lj5FeeZ5N+I3QhGSfp+FTKcMqTXz7bWG8I0a9
X-Received: by 2002:a5d:5587:0:b0:32d:e445:a663 with SMTP id i7-20020a5d5587000000b0032de445a663mr7161719wrv.2.1700577344394;
        Tue, 21 Nov 2023 06:35:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE2QS5/jXBTwRVeHl/e4usdrID/G50VvpyvtMJnm7HOEtuoLzAU22yQiBh7RufkwNjYv5umQQ==
X-Received: by 2002:a5d:5587:0:b0:32d:e445:a663 with SMTP id i7-20020a5d5587000000b0032de445a663mr7161708wrv.2.1700577344054;
        Tue, 21 Nov 2023 06:35:44 -0800 (PST)
Received: from [10.0.0.196] ([37.186.166.196])
        by smtp.gmail.com with ESMTPSA id e8-20020adfe7c8000000b00332cc24a59bsm3477712wrn.109.2023.11.21.06.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Nov 2023 06:35:43 -0800 (PST)
Message-ID: <eea04a610f3ad380a6791eeaa8beae0bbb9678f8.camel@redhat.com>
Subject: Re: [PATCH nft 1/1] tests/shell: sanitize "handle" in JSON output
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 21 Nov 2023 15:35:43 +0100
In-Reply-To: <ZVyzVhmX9TNiwqP/@orbyte.nwl.cc>
References: <20231117171948.897229-1-thaller@redhat.com>
         <ZVgjLFGvHqoXXvjd@orbyte.nwl.cc>
         <f4b86e5318556be07a8c86c3fdd551ad5e22a831.camel@redhat.com>
         <ZVylBpvC+IK4RIyH@orbyte.nwl.cc>
         <31ff0aceab627a9838b94fc3fa58c271bc0a6023.camel@redhat.com>
         <ZVyzVhmX9TNiwqP/@orbyte.nwl.cc>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.1 (3.50.1-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-11-21 at 14:40 +0100, Phil Sutter wrote:
> On Tue, Nov 21, 2023 at 01:58:41PM +0100, Thomas Haller wrote:
> > On Tue, 2023-11-21 at 13:39 +0100, Phil Sutter wrote:
> > > On Tue, Nov 21, 2023 at 01:10:11PM +0100, Thomas Haller wrote:
> > > > On Sat, 2023-11-18 at 03:36 +0100, Phil Sutter wrote:
> > > [...]
> > > > > Also, scoping these replacements to line 1 is funny with
> > > > > single
> > > > > line
> > > > > input. Worse is identifying the change in the resulting diff.
> > > > > Maybe
> > > > > write a helper in python which lets you more comfortably
> > > > > sanitize
> > > > > input,
> > > > > sort attributes by key and output pretty-printed?
> > > >=20
> > > > You mean, to parse and re-encode the JSON? That introduces
> > > > additional
> > > > changes, which seems undesirable. That's why the regex is
> > > > limited
> > > > to
> > > > the first line (even if we only expect to ever see one line
> > > > there).
> > > >=20
> > > > Also, normalization via 2 regex seems simpler than writing some
> > > > python.
> > > >=20
> > > > Well, pretty-printing the output with `jq` would have the
> > > > advantage,
> > > > that future diffs might be smaller (changing individual lines,
> > > > vs.
> > > > replace one large line). Still, I think it's better to keep the
> > > > amount
> > > > of post-processing minimal.
> > >=20
> > > The testsuite relies upon Python and respective modules already,
> > > using
> > > jq introduces a new dependency. Hence why I suggested to write a
> > > script.
> > >=20
> > > JSON object attributes are not bound to any ordering, the code
> > > may
> > > change it.
> >=20
> > Don't have .nft dumps the same concern?
>=20
> Not as far as I can tell: Objects are sorted by name, rule ordering
> is
> inherently relevant.

If sorting is necessary to get stable output, then JSON handling should
do the same.

It is a desirable property, that the output of a command is stable.

>=20
> > In JSON the order of things certainly matters. libjansson has
> > JSON_PRESERVE_ORDER, which is used by libnftables. Also,
> > JSON_PRESERVE_ORDER is deprecated since 2016 and order is always
> > preserved.
>=20
> The reason why JSON_PRESERVE_ORDER exists is just because ordering
> does
> not matter per se.


> For a proper JSON parser,
> > {"a": 1, "b": 2}
> and
> > {"b": 2, "a": 1}
> are semantically identical.


Whitespace in JSON is even more irrelevant for "semantically
identical".

From that, it doesn't follow that `nft -j list ruleset` should change
the output (regarding order or whitespace) arbitrarily. The tool should
make an effort to not change the output.



> > If the order changes, that should be visible (in form of a test
> > failure).
>=20
> Why? If we change e.g. the ordering of array elements by adding them
> in
> reverse, isn't this a legal change and any testsuite complaints about
> it
> just noise?


If there are good reasons to change something, it can be done.=20

It is a "legal" change, but not accidental or inconsequential.
Adjusting tests int that case is a good (and easy) thing.

>=20
> > > When analyzing testsuite failures, a diff of two overlong lines
> > > is
> > > inconvenient to the point that one may pipe both through json_pp
> > > and
> > > then diff again. The testsuite may do just that in case of
> > > offending
> > > output, but the problem of reordered attributes remains.
> > >=20
> > > I'd really appreciate if testsuite changes prioritized usability.
> > > I
> > > rather focus on fixing bugs instead of parsing the testsuite
> > > results.
> >=20
> > The test suite prioritizes usability. No need to suggest otherwise.
>=20
> Then why not store JSON dumps pretty printed to make diffs more
> readable?

That's still on the table.

Though, I would much rather do an absolute minimum of post-processing
("json-sanitize-ruleset.sh") to not accidentally hiding a bug.

Yes, that may be more inconvenient. But IMO only negligibly so.

>=20
> > To make debugging easier, the test suite can additionally show a
> > prettified diff. It does not determine how the .json-nft file is
> > stored
> > in git.=20
>=20
> Is this "can" in a pending patch? Because I don't see that
> "prettified
> diff" option in tests/shell/helpers/test-wrapper.sh.

No. I said "can". You just brought this (good) idea up.

Could be something like:

     fi
     if [ "$NFT_TEST_HAVE_json" !=3D n -a -f "$JDUMPFILE" ] ; then
          if ! $DIFF -u "$JDUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after.js=
on" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" ; then
+              "$NFT_TEST_BASEDIR/helpers/json-diff-pretty.sh" \
+                   "$JDUMPFILE" \
+                   "$NFT_TEST_TESTTMPDIR/ruleset-after.json" \
+                    > "$NFT_TEST_TESTTMPDIR/ruleset-diff-json-pretty"
               show_file "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" "Failed \=
`$DIFF -u \"$JDUMPFILE\" \"$NFT_TEST_TESTTMPDIR/ruleset-after.json\"\`" >> =
"$NFT_TEST_TESTTMPDIR/rc-failed-dump"
               rc_dump=3D1
          else

Having such a "json-diff-pretty" script in the toolbox might be handy
for debugging anyway. I guess, it's somewhere under tests/py already?



Thomas

