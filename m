Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28035C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Nov 2023 09:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjKAJ4O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Nov 2023 05:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbjKAJ4O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Nov 2023 05:56:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9AEED
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Nov 2023 02:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698832521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tLjSb8YXPu0N74D3TXifEmocbCFTGXhIHzqI3mWOeDs=;
        b=VCq1FH79HpObAwB27bu2Me9U7o1/nfaPW3MvTLo+Nvmv2psI1NO9D3tzshyJy6H6uY3njb
        Z+C00rBJNkbvSfcl7NzzW4/1Abji/T9Nj8h0kUTiK4+ow0pf057h7SVdUg0BnC6THNSv0u
        kt5hKd99RNlVM9lQuE3AyggECb0uvhw=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-PF7DaIJkOPukBvhFHDq83g-1; Wed, 01 Nov 2023 05:55:20 -0400
X-MC-Unique: PF7DaIJkOPukBvhFHDq83g-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2c50cf8cf25so13804601fa.0
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Nov 2023 02:55:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698832518; x=1699437318;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tLjSb8YXPu0N74D3TXifEmocbCFTGXhIHzqI3mWOeDs=;
        b=TuNGppzAFQU+h5Rl3q7jCA8W+qZEqaYIWySXXp4pfdVr4v4r7BG4ZN58Ikx6Ks95MA
         ZlGoZF5UsL9VpRWWqXF2pNTYLPibOUVUXnDQ2G4bcpvEme5Zcf6o4+w2eBv55FAB6wC+
         wMiaBEcA6OckMUp+xUG166JxoHeEeuzBkJP6HmitpP+sjdYZKximVrHFPRi+WNKYFWs2
         DFrxayXVBL0LJ36j+lAcRKkyZz0VEzLeozKIDDCBliGYiZv4vSddaAGOc4tYFfJJc7PF
         DYQrZA5w26tBb4k8C+4yCOJu5EbDE5pFbDEfcYRHMsCclT6j/oBVHb4dgFtvpdP1hPdl
         Y6oA==
X-Gm-Message-State: AOJu0YwTEnEB6jtRIhRHi72FcSNL5CSKl8LLbtA1df2pZo3z9UPTJhdj
        bs+WYtn3SQJWeBOsM1ecxZEG7JRxU2b0bmR9Bin4pfrhFZYJGLYkrrGS+ZlPW+nXqi5neohYxHJ
        JOiVdqGdNy68AMbjy8PgMysQhLUTAlFUJKmtA
X-Received: by 2002:a05:6512:3196:b0:502:af44:21c2 with SMTP id i22-20020a056512319600b00502af4421c2mr11239947lfe.5.1698832518563;
        Wed, 01 Nov 2023 02:55:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNe5ZNstl4jtbfk1hkC72a/rx2zS72YyAAExW4PFGg/Ld78pM6dQ1lCmcT0JiAnC2+xXatPQ==
X-Received: by 2002:a05:6512:3196:b0:502:af44:21c2 with SMTP id i22-20020a056512319600b00502af4421c2mr11239938lfe.5.1698832518205;
        Wed, 01 Nov 2023 02:55:18 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.169.33])
        by smtp.gmail.com with ESMTPSA id v10-20020aa7dbca000000b0052ffc2e82f1sm858747edt.4.2023.11.01.02.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Nov 2023 02:55:17 -0700 (PDT)
Message-ID: <f611d0639d30cf1e7e77e39792cb2e6ce7bbe7a9.camel@redhat.com>
Subject: Re: [PATCH nft 0/7] add and check dump files for JSON in tests/shell
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 01 Nov 2023 10:55:16 +0100
In-Reply-To: <ZUIMHmWxbhhTt/MM@calendula>
References: <20231031185449.1033380-1-thaller@redhat.com>
         <f9955dba2dba9965ad2a540482cdd66ab674cd83.camel@redhat.com>
         <ZUIMHmWxbhhTt/MM@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-11-01 at 09:28 +0100, Pablo Neira Ayuso wrote:
> On Tue, Oct 31, 2023 at 08:17:24PM +0100, Thomas Haller wrote:
> > On Tue, 2023-10-31 at 19:53 +0100, Thomas Haller wrote:
> > > Like we have .nft dump files to compare the expected result, add
> > > .json-nft files that compare the JSON output.
> > >=20
> > > Thomas Haller (7):
> > > =C2=A0 json: fix use after free in table_flags_json()
> > > =C2=A0 json: drop messages "warning: stmt ops chain have no json
> > > callback"
> > > =C2=A0 tests/shell: check and generate JSON dump files
> > > =C2=A0 tests/shell: add JSON dump files
> > > =C2=A0 tools: simplify error handling in "check-tree.sh" by adding
> > > =C2=A0=C2=A0=C2=A0 msg_err()/msg_warn()
> > > =C2=A0 tools: check more strictly for bash shebang in "check-tree.sh"
> > > =C2=A0 tools: check for consistency of .json-nft dumps in "check-
> > > tree.sh"
>=20
> If this is improving json support coverage without imposing any extra
> restriction other than adding a .nft-json file, then this is very
> good
> to have.
>=20
> I believe I switfly read on a commit message that this is skipped if
> nft is compiled without json support, correct?

Yes, that's how it's supposed to work (and tests correctly for me).

>=20
> > Hm. Patch 4/7 bounced (too large).
> >=20
> > Will see how to resend, after there is some feedback.
>=20
> I suggest you Cc: me so I can apply this.


You could also run

  git fetch https://gitlab.freedesktop.org/thaller/nftables.git 6545b310800=
36e8525be5c80c0103a1509e698e4 ; git cherry-pick 6545b31080036e8525be5c80c01=
03a1509e698e4


Anyway. I will CC you on the patch as soon as I get to it!

>=20
> > The patch is also here:
> > https://gitlab.freedesktop.org/thaller/nftables/-/commit/6545b31080036e=
8525be5c80c0103a1509e698e4
>=20
> You said:
>=20
> "Note that for some JSON dumps, `nft -f --check` fails (or prints
> something). For those tests no *.json-nft file is added. The bugs
> needs
> to be fixed first."

>=20
> Do you have a list of tests that are failing? Or maybe include this
> list in the commit description? To keep them in the radar, we can
> incrementally fix them.


You can find them by running ./tools/check-tree.sh, it will print
warnings about the tests that lack the .json-nft file. It's exactly
those.

It prints for example:

 WARN: "tests/shell/testcases/cache/0010_implicit_chain_0" has a dump file =
"tests/shell/testcases/cache/dumps/0010_implicit_chain_0.nft" but lacks a J=
SON dump "tests/shell/testcases/cache/dumps/0010_implicit_chain_0.json-nft"


Thomas

