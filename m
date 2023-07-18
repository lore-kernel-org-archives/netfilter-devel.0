Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C388FEB64DA
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jul 2023 09:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjGRJGm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jul 2023 05:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjGRJGl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2023 05:06:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADB0B5
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 02:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689671149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6g7iG9SuE2gHA2TfT7Vb3d0kPy9UkN1J9TWMsHs+9HU=;
        b=MuVnklzHdEct8pqz8hmQTVajGBQx8WwoPS9oBS0g5eLAa7/YrYt3veYf8IdTTEjhmmt/u4
        CPhYPtCp4Erh5KThuzkDr7WESTeydYyPPHjmZnwb8LRGfqq3GAAyhKAm89jZ02OVywXDQJ
        VziY70WsmxFuR1slwHYnuUEzf8Q41CQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-EC20Jh2YOhWumudL3IXYqg-1; Tue, 18 Jul 2023 05:05:48 -0400
X-MC-Unique: EC20Jh2YOhWumudL3IXYqg-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5126fda879cso1040832a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 02:05:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689671147; x=1690275947;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6g7iG9SuE2gHA2TfT7Vb3d0kPy9UkN1J9TWMsHs+9HU=;
        b=GxLL846Azz9m/FSt5GzTBEoo1m/woOGsxB06cqCFN1zocgeKxbeEi7C6+wbKDmezTA
         s96NTn9svTFDYJGHq+/rBSd2Z3RyTWY68iCzmAxJJvoKz33cDX1AxKD3fmPnSwsRbv+3
         ICd+k4V+ZzW7aZTbZPI/oSgSumM7IzoYAfZEjMTUI0e4DHbJiy8EQqxSfpLB4x7rZ2xJ
         h7ZM2WkuTEWBo+Jnlb7mpK6/g9HnWTLTKcX2x96f2tMj0J5SkxCnz1FI4Nq5IIxKu/jr
         OWgmPNWOK7e0xSbQ/ys10x0tLTyzM0PfWfSYc7lOToAz23t77T1JBXlDUd6UQ6CIjy6X
         CA0A==
X-Gm-Message-State: ABy/qLb6Ugw6JoRGyO6ogI2ELwYtamq3LYdIQzw2mYF5syidcQpC7UKZ
        QmXqkHIuPS3vVItFIN2W21FGGzzJvAybNH1X4TEOvGGiA7tCwZ3kaaR+kX3VOiD3NBmJu6fNrLk
        8dcTdLERXDKGRXvAeP/bc8ghjONJv
X-Received: by 2002:a05:6402:268b:b0:521:66b4:13b9 with SMTP id w11-20020a056402268b00b0052166b413b9mr10382289edd.0.1689671147303;
        Tue, 18 Jul 2023 02:05:47 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHksbups99m9kSZHGcnGix017b+qW3UXJsTmRymtU8Bt3UmG69saJFoNpQUWBrsibY7W3O2tA==
X-Received: by 2002:a05:6402:268b:b0:521:66b4:13b9 with SMTP id w11-20020a056402268b00b0052166b413b9mr10382278edd.0.1689671146980;
        Tue, 18 Jul 2023 02:05:46 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.189.9])
        by smtp.gmail.com with ESMTPSA id d15-20020a50fe8f000000b0051df6c2bb7asm899435edt.38.2023.07.18.02.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 02:05:46 -0700 (PDT)
Message-ID: <98298234d31a02f10cfd022ce59140db80ca8750.camel@redhat.com>
Subject: Re: [nft v2 PATCH 1/3] nftables: add input flags for nft_ctx
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue, 18 Jul 2023 11:05:45 +0200
In-Reply-To: <ZLEgaNIH/ZD4hnf3@orbyte.nwl.cc>
References: <ZKxG23yJzlRRPpsO@calendula>
         <20230714084943.1080757-1-thaller@redhat.com>
         <ZLEgaNIH/ZD4hnf3@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2023-07-14 at 12:16 +0200, Phil Sutter wrote:
> On Fri, Jul 14, 2023 at 10:48:51AM +0200, Thomas Haller wrote:
> [...]
> > +=3D=3D=3D nft_ctx_input_get_flags() and nft_ctx_input_set_flags()
> > +The flags setting controls the input format.
>=20
> Note how we turn on JSON input parsing if JSON output is enabled.
>=20
> I think we could tidy things up by introducing NFT_CTX_INPUT_JSON and
> flip it from nft_ctx_output_set_flags() to match NFT_CTX_OUTPUT_JSON
> for
> compatibility?


Hi Phil,


The doc says:

doc/libnftables.adoc:NFT_CTX_OUTPUT_JSON::
doc/libnftables.adoc-    If enabled at compile-time, libnftables accepts in=
put in JSON format and is able to print output in JSON format as well.
doc/libnftables.adoc-    See *libnftables-json*(5) for a description of the=
 supported schema.
doc/libnftables.adoc-    This flag controls JSON output format, input is au=
to-detected.

which is a bit inaccurate, as JSON is auto-detect if-and-only-if
NFT_CTX_OUTPUT_JSON is set.


src/libnftables.c:  if (nft_output_json(&nft->output))
src/libnftables.c-       rc =3D nft_parse_json_buffer(nft, nlbuf, &msgs, &c=
mds);
src/libnftables.c-  if (rc =3D=3D -EINVAL)
src/libnftables.c-       rc =3D nft_parse_bison_buffer(nft, nlbuf, &msgs, &=
cmds,
src/libnftables.c-                          &indesc_cmdline);


I think, that toggling the input flag when setting an output flag
should not be done. It's confusing to behave differently depending on
the order in which nft_ctx_output_set_flags() and
nft_ctx_input_set_flags() are called. And it's confusing that setting
output flags would mangle input flags.

And for the sake of backwards compatibility, the current behavior must
be kept anyway. So there is only a place for overruling the current
automatism via some NFT_CTX_INPUT_NO_JSON (aka
NFT_CTX_INOUT_FORCE_BISON) or NFT_CTX_INPUT_FORCE_JSON flags, like

    try_json =3D TRUE;
    try_bison =3D TRUE;
    if (nft_ctx_input_get_flags(ctx) & NFT_CTX_INPUT_NO_JSON)
        try_json =3D FALSE;
    else if (nft_ctx_input_get_flags(ctx) & NFT_CTX_INPUT_FORCE_JSON)
        try_bison =3D FALSE;
    else if (nft_output_json(&ctx->output)) {
        /* try both, JSON first */
    } else
        try_json =3D FALSE;

    if (try_json)
        rc =3D nft_parse_json_buffer(nft, nlbuf, &msgs, &cmds);
    if (try_bison && (!try_json || rc =3D=3D -EINVAL))
        rc =3D nft_parse_bison_buffer(nft, nlbuf, ...);


This would not require to mangle input flags during
nft_ctx_output_set_flags().

=20
But I find those two flags unnecessary. Both can be added any time
later when needed. The addition of nft_ctx_input_set_flags() does not
force a resolution now.


Also, depending on the semantics, I don't understand how
NFT_CTX_INPUT_JSON extends the current behavior in a backward
compatible way. The default would be to not have that flag set, which
already means to enable JSON parsing depending on NFT_CTX_OUTPUT_JSON.
If NFT_CTX_INPUT_JSON merely means to explicitly enable JSON input,
then that is already fully configurable today. Having this flag does
not provide something new (unlike NO_JSON/FORCE_BISON or FORCE_JSON
flags would).



Thomas

