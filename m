Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E173C61D94
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbjKUM6w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbjKUM6v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:58:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AFA131
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Nov 2023 04:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1700571527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=/GNVdQXR99KsVCN+iN/8lJELzR6vCOht7vL6F8H8BQw=;
        b=bylUVUnSm5bhLtwdnT/nQ75LBUMSaGZZvKyQbwL3BhFPxZ6iL1m2MY10zV6+4c8zjd+xLe
        2IbD5WW3L2Zc1YKYAAg36AKHYm7cyh1lCOQ9F/Uq8o+Jl/I44Hv12fMliI2ECBL+ejjDei
        yi7RxE+IjZuL0uK6IBF4v4TxANAcIus=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-v9HGOs4NN36K0oHM0tQSIg-1; Tue, 21 Nov 2023 07:58:44 -0500
X-MC-Unique: v9HGOs4NN36K0oHM0tQSIg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-32f78dc3fcbso480096f8f.0
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Nov 2023 04:58:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700571523; x=1701176323;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/GNVdQXR99KsVCN+iN/8lJELzR6vCOht7vL6F8H8BQw=;
        b=SB2y2LRRNpUdHp5iRNkdNydzZw+jqLP9LvRV1+g1TYsuLGmY5LSUC8aWs+TY4yhaie
         FQhV0xdRgN2h03gzSfzeBKa4KF7My+prrMWmatddeC9X45PViz/Zz4HlprD+RhMQ7dYr
         x+z6ymFWHPHk1v6o4XpXjqWY6qeyeAKzc0GLh7QM7d+/5muYvX9cX7VnpmgcSraIlDL2
         93h4xdc5rBlJkegAdXmI/b4FzBJbvJZrvvlZN5XffO0R6Wu3cW0ZMLs3CNh20IhcUmbY
         DYn7N05GjKm8M5pmFw1wCa2nmFxuyHvxEFEzybSMTsxB8qPvQCRM/5Skv+BjMheB0cqi
         IMZg==
X-Gm-Message-State: AOJu0YxRrMFq/+PXGGMfb1pICap9Ndo9nlqpJkD2K3EId5RIyIQIqr31
        ikm+oQDI8sBTJpbx8XBz4qfnAnC4FHqAXJx62BUe0I4M9JM8hfJSAnsHUoLm6zZrNBtXJng9qhv
        C3mu2Ps9kfJ9n60fSlG5q7EDXji3QMZcSqhQ0
X-Received: by 2002:adf:f74b:0:b0:332:cfe9:9491 with SMTP id z11-20020adff74b000000b00332cfe99491mr493482wrp.0.1700571523224;
        Tue, 21 Nov 2023 04:58:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG0F4+zc5hVtaNundC3MEexKiI+K5fm3HPezelYNJRbEc48yU9z3u6+vzekqdPvToGWajaqgA==
X-Received: by 2002:adf:f74b:0:b0:332:cfe9:9491 with SMTP id z11-20020adff74b000000b00332cfe99491mr493471wrp.0.1700571522854;
        Tue, 21 Nov 2023 04:58:42 -0800 (PST)
Received: from [10.0.0.196] ([37.186.166.196])
        by smtp.gmail.com with ESMTPSA id d16-20020adfe2d0000000b003316a2aedadsm13987932wrj.36.2023.11.21.04.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Nov 2023 04:58:42 -0800 (PST)
Message-ID: <31ff0aceab627a9838b94fc3fa58c271bc0a6023.camel@redhat.com>
Subject: Re: [PATCH nft 1/1] tests/shell: sanitize "handle" in JSON output
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 21 Nov 2023 13:58:41 +0100
In-Reply-To: <ZVylBpvC+IK4RIyH@orbyte.nwl.cc>
References: <20231117171948.897229-1-thaller@redhat.com>
         <ZVgjLFGvHqoXXvjd@orbyte.nwl.cc>
         <f4b86e5318556be07a8c86c3fdd551ad5e22a831.camel@redhat.com>
         <ZVylBpvC+IK4RIyH@orbyte.nwl.cc>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.1 (3.50.1-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-11-21 at 13:39 +0100, Phil Sutter wrote:
> On Tue, Nov 21, 2023 at 01:10:11PM +0100, Thomas Haller wrote:
> > On Sat, 2023-11-18 at 03:36 +0100, Phil Sutter wrote:
> [...]
> > > Also, scoping these replacements to line 1 is funny with single
> > > line
> > > input. Worse is identifying the change in the resulting diff.
> > > Maybe
> > > write a helper in python which lets you more comfortably sanitize
> > > input,
> > > sort attributes by key and output pretty-printed?
> >=20
> > You mean, to parse and re-encode the JSON? That introduces
> > additional
> > changes, which seems undesirable. That's why the regex is limited
> > to
> > the first line (even if we only expect to ever see one line there).
> >=20
> > Also, normalization via 2 regex seems simpler than writing some
> > python.
> >=20
> > Well, pretty-printing the output with `jq` would have the
> > advantage,
> > that future diffs might be smaller (changing individual lines, vs.
> > replace one large line). Still, I think it's better to keep the
> > amount
> > of post-processing minimal.
>=20
> The testsuite relies upon Python and respective modules already,
> using
> jq introduces a new dependency. Hence why I suggested to write a
> script.
>=20
> JSON object attributes are not bound to any ordering, the code may
> change it.

Don't have .nft dumps the same concern?

In JSON the order of things certainly matters. libjansson has
JSON_PRESERVE_ORDER, which is used by libnftables. Also,
JSON_PRESERVE_ORDER is deprecated since 2016 and order is always
preserved.

If the order changes, that should be visible (in form of a test
failure).

>=20
> When analyzing testsuite failures, a diff of two overlong lines is
> inconvenient to the point that one may pipe both through json_pp and
> then diff again. The testsuite may do just that in case of offending
> output, but the problem of reordered attributes remains.
>=20
> I'd really appreciate if testsuite changes prioritized usability. I
> rather focus on fixing bugs instead of parsing the testsuite results.

The test suite prioritizes usability. No need to suggest otherwise.

To make debugging easier, the test suite can additionally show a
prettified diff. It does not determine how the .json-nft file is stored
in git.=20


Thomas

