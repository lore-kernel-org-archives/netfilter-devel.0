Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91613EB64DA
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jul 2023 10:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjGRKbx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jul 2023 06:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjGRKbw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2023 06:31:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7DBE4F
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 03:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689676266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ObEXh8L0QyBNJtRf6haqMrPu1Qa2iuT88jmKz3X9m4E=;
        b=YwYfbTK7M/75QepVDzTxBNgaJxs5ZaDYlMNbaNNPFceSoQIS8lzGNtYMalzZu95k3cRHln
        Ggvefv7c4H0ZXOBoWB77B7r4bBtBDi03JsoSpaA08oiaWN6Spnoi4EJi2JnxqKrKJ8x+Io
        1uhtB4G2F4muQfGjWl0LjRiood2MAbI=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-500-jQZW3oq5MXmiEQamTU6l5g-1; Tue, 18 Jul 2023 06:31:05 -0400
X-MC-Unique: jQZW3oq5MXmiEQamTU6l5g-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4fbf2724a51so926537e87.0
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 03:31:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689676264; x=1690281064;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ObEXh8L0QyBNJtRf6haqMrPu1Qa2iuT88jmKz3X9m4E=;
        b=KmA/ASLpvX5pEFDoDvemTI2gcEb28g7UFnwyB5+5XoDh/8jlBbierUA7zB+sg4Ya+d
         N/h1zqAeCjAFU7Ib3KqrYsHMmhpqkxiEoHNWdIKL4r39/X5ucF4nvSF9sRiQldgHLlXy
         uSme1hqTBWLIzco8b0EJ8bNOTzyLrRAnZvVS1WpYHVfxKTqgS2dEaL6Vw43zSb9yee6X
         l1mRIZRZKv/P5kUTRMQsqzqXplB7ioyJGO7zOuxLuDSIzMRxMWN9T8/H3prOFtIPHXWb
         sDndquEjqqsfQtdVl/HCDxruRh0kccdLnwkl0Wl5oQGVtrDnjUYXYQOjt0AXqFsvNPgJ
         su0A==
X-Gm-Message-State: ABy/qLZM/A0XQIMJyPcA5lx1dXiiYI4sSH4rVLlSnEPV3TdZNCvjD4qh
        t5fd3RZvpCvqv3nJbgwopod6kN2mBUf2s/wWXjqM5Mjh53+5PexU/JLLVMDKQ9B6BQqNFdIhDLm
        5HNpA7sJxj4hMQT+4XRiVAiUTpYDP
X-Received: by 2002:a05:6512:4859:b0:4fa:73ea:aa2d with SMTP id ep25-20020a056512485900b004fa73eaaa2dmr4787795lfb.4.1689676264074;
        Tue, 18 Jul 2023 03:31:04 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGPWqlwFmOMvE7NP7YRr6Rej6lgiob+/2oosVos1RgO/dS0A0Qj4sKDlj0RcZotISOwPDdEzg==
X-Received: by 2002:a05:6512:4859:b0:4fa:73ea:aa2d with SMTP id ep25-20020a056512485900b004fa73eaaa2dmr4787782lfb.4.1689676263751;
        Tue, 18 Jul 2023 03:31:03 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.189.9])
        by smtp.gmail.com with ESMTPSA id s10-20020aa7cb0a000000b0051bfc7763c2sm1003882edt.25.2023.07.18.03.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 03:31:03 -0700 (PDT)
Message-ID: <df678cf06fc32f5487e8f89e0089ff7895d2c733.camel@redhat.com>
Subject: Re: [nft v2 PATCH 1/3] nftables: add input flags for nft_ctx
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue, 18 Jul 2023 12:31:02 +0200
In-Reply-To: <ZLZcepeCgDVLQLKG@orbyte.nwl.cc>
References: <ZKxG23yJzlRRPpsO@calendula>
         <20230714084943.1080757-1-thaller@redhat.com>
         <ZLEgaNIH/ZD4hnf3@orbyte.nwl.cc>
         <98298234d31a02f10cfd022ce59140db80ca8750.camel@redhat.com>
         <ZLZcepeCgDVLQLKG@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-07-18 at 11:33 +0200, Phil Sutter wrote:
> On Tue, Jul 18, 2023 at 11:05:45AM +0200, Thomas Haller wrote:
> > On Fri, 2023-07-14 at 12:16 +0200, Phil Sutter wrote:
> > > On Fri, Jul 14, 2023 at 10:48:51AM +0200, Thomas Haller wrote:
> > > [...]
> > > > +=3D=3D=3D nft_ctx_input_get_flags() and nft_ctx_input_set_flags()
> > > > +The flags setting controls the input format.
> > >=20
> > > Note how we turn on JSON input parsing if JSON output is enabled.
> > >=20
> > > I think we could tidy things up by introducing NFT_CTX_INPUT_JSON
> > > and
> > > flip it from nft_ctx_output_set_flags() to match
> > > NFT_CTX_OUTPUT_JSON
> > > for
> > > compatibility?
> >=20
> > The doc says:
> >=20
> > doc/libnftables.adoc:NFT_CTX_OUTPUT_JSON::
> > doc/libnftables.adoc-=C2=A0=C2=A0=C2=A0 If enabled at compile-time, lib=
nftables
> > accepts input in JSON format and is able to print output in JSON
> > format as well.
> > doc/libnftables.adoc-=C2=A0=C2=A0=C2=A0 See *libnftables-json*(5) for a
> > description of the supported schema.
> > doc/libnftables.adoc-=C2=A0=C2=A0=C2=A0 This flag controls JSON output =
format,
> > input is auto-detected.
> >=20
> > which is a bit inaccurate, as JSON is auto-detect if-and-only-if
> > NFT_CTX_OUTPUT_JSON is set.
>=20
> Yes, I'd even call it incorrect. :)
>=20
> > src/libnftables.c:=C2=A0 if (nft_output_json(&nft->output))
> > src/libnftables.c-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D nft_parse=
_json_buffer(nft, nlbuf,
> > &msgs, &cmds);
> > src/libnftables.c-=C2=A0 if (rc =3D=3D -EINVAL)
> > src/libnftables.c-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D nft_parse=
_bison_buffer(nft, nlbuf,
> > &msgs, &cmds,
> > src/libnftables.c-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 &indesc_cmdline);
> >=20
> >=20
> > I think, that toggling the input flag when setting an output flag
> > should not be done. It's confusing to behave differently depending
> > on
> > the order in which nft_ctx_output_set_flags() and
> > nft_ctx_input_set_flags() are called. And it's confusing that
> > setting
> > output flags would mangle input flags.
>=20
> That's a valid point, indeed.
>=20
> > And for the sake of backwards compatibility, the current behavior
> > must
> > be kept anyway. So there is only a place for overruling the current
> > automatism via some NFT_CTX_INPUT_NO_JSON (aka
> > NFT_CTX_INOUT_FORCE_BISON) or NFT_CTX_INPUT_FORCE_JSON flags, like
> >=20
> > =C2=A0=C2=A0=C2=A0 try_json =3D TRUE;
> > =C2=A0=C2=A0=C2=A0 try_bison =3D TRUE;
> > =C2=A0=C2=A0=C2=A0 if (nft_ctx_input_get_flags(ctx) & NFT_CTX_INPUT_NO_=
JSON)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 try_json =3D FALSE;
> > =C2=A0=C2=A0=C2=A0 else if (nft_ctx_input_get_flags(ctx) &
> > NFT_CTX_INPUT_FORCE_JSON)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 try_bison =3D FALSE;
> > =C2=A0=C2=A0=C2=A0 else if (nft_output_json(&ctx->output)) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* try both, JSON first */
> > =C2=A0=C2=A0=C2=A0 } else
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 try_json =3D FALSE;
> >=20
> > =C2=A0=C2=A0=C2=A0 if (try_json)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D nft_parse_json_buffer=
(nft, nlbuf, &msgs, &cmds);
> > =C2=A0=C2=A0=C2=A0 if (try_bison && (!try_json || rc =3D=3D -EINVAL))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D nft_parse_bison_buffe=
r(nft, nlbuf, ...);
> >=20
> >=20
> > This would not require to mangle input flags during
> > nft_ctx_output_set_flags().
> >=20
> > =C2=A0
> > But I find those two flags unnecessary. Both can be added any time
> > later when needed. The addition of nft_ctx_input_set_flags() does
> > not
> > force a resolution now.
> >=20
> >=20
> > Also, depending on the semantics, I don't understand how
> > NFT_CTX_INPUT_JSON extends the current behavior in a backward
> > compatible way. The default would be to not have that flag set,
> > which
> > already means to enable JSON parsing depending on
> > NFT_CTX_OUTPUT_JSON.
> > If NFT_CTX_INPUT_JSON merely means to explicitly enable JSON input,
> > then that is already fully configurable today. Having this flag
> > does
> > not provide something new (unlike NO_JSON/FORCE_BISON or FORCE_JSON
> > flags would).
>=20
> The use-case I had in mind was to enable JSON parsing while keeping
> standard output. This was possible with setting NFT_CTX_INPUT_JSON
> and
> keeping NFT_CTX_OUTPUT_JSON unset.

you are right. A NFT_CTX_INPUT_JSON (or TRY_JSON?) flag makes sense
beside NO_JSON/FORCE_BISON and FORCE_JSON/ALWAYS_JSON to enable to try
both.

>=20
> The reason for libnftables' odd behaviour probably stems from nft
> using
> just a single flag ('-j') to control JSON "mode" and I wanted to
> still
> support non-JSON input - I tend to (mis-)use it as JSON-translator in
> the testsuite and personally. ;)
>=20
> You're right, we may just leave JSON input/output toggles alone for
> now.
> I also didn't intend to block the patches - giving it a thought (as
> you
> did) is fine from my side.


makes sense. But doesn't block the addition of
nft_ctx_input_set_flags(), because I would not try to automatically add
the NFT_CTX_INPUT_JSON flag (based on the output flag). Setting the
input flag should still be an explicit user action, so the flag can be
added any time later.


Thomas

