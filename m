Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59092C83F11
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 16:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjH1QZt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 12:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbjH1QZT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 12:25:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E5DD9
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 09:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693239870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JUAFfYSOHl/8cLFHuBaoRLuaCFO2nMYFH1e4rb4Yq1E=;
        b=JbuS8YpQ8xAFFE8v2WEV0lvnKTq+2OFprFwxxTDvXsxeDdn6AVc9IwiS96LqXUOu8D1X8g
        OT0irw2WSIF0tQrjdTFeY/9SR56yIoZcmD9+EFESNVNTHy1j1bHBTU5tQwRA1QRzuGP/lr
        mFfIa2xNlWnDBwl10RhfO1K8H2kHvN4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-NVjAylBbMoCNliqzy2WjZw-1; Mon, 28 Aug 2023 12:24:28 -0400
X-MC-Unique: NVjAylBbMoCNliqzy2WjZw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3fee6743e50so3980525e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 09:24:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693239867; x=1693844667;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JUAFfYSOHl/8cLFHuBaoRLuaCFO2nMYFH1e4rb4Yq1E=;
        b=I0tUZhcerc7OeDWhcazHze/KOqhTTWRsHyVF6KysghrYszozCY1ydrBpiToUycQjw5
         XuPQrPiFRugFJd2N5CekY2Yqq8oBD7+n9y3Ny+bbsaNlw1SkoHiWO2VerG4w+6709qG7
         mMaaITyDcKhGNWWdVcd316HU+xPCbQv7huRP+gC8NvIKGWYwV2KYHIwyM7XM7fym+1sD
         bSCtjvQf0YZ+HCohZyHmsPCEmuTeweSfY2IcV0/2UyHJHW/5vSbL7RG0bUu2oZsmWlmD
         CUvZaNXS7wYhkD/uYYTOkRCK1+6lr+lPwg9mbBVqDla6UAscO+OSV8iNZfuFKW5QwSGm
         yotg==
X-Gm-Message-State: AOJu0YzdBjAI4SM41cvNilsWyaKwHt4dM/jXPkqWiMpmWnlPliqLjHaf
        jzcysj+glzu+XGuUFGbvKqzChUAM3KDBdOnz0ite0Xf8G4NJLpRfwoyTGOaFhPbkw6DgDdN5Tm0
        YLdLfKaCufb2EOkVZUSndgTvAkBKfxS/KEN3f
X-Received: by 2002:a05:600c:3d1a:b0:3fe:4d2d:f79b with SMTP id bh26-20020a05600c3d1a00b003fe4d2df79bmr20752743wmb.4.1693239867027;
        Mon, 28 Aug 2023 09:24:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAO8eFtxkO/IVWnnbelEmCHbasu6Bpb/XjAaVbHTbeNmldak1NIV/0Ia8NTaE19XIj0cNRNA==
X-Received: by 2002:a05:600c:3d1a:b0:3fe:4d2d:f79b with SMTP id bh26-20020a05600c3d1a00b003fe4d2df79bmr20752737wmb.4.1693239866750;
        Mon, 28 Aug 2023 09:24:26 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id z19-20020a05600c221300b003fee9cdf55esm11132189wml.14.2023.08.28.09.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Aug 2023 09:24:26 -0700 (PDT)
Message-ID: <272f8c10d8e7ac9265c4af23e8d7ae3860438266.camel@redhat.com>
Subject: Re: [PATCH nft 8/8] datatype: suppress "-Wformat-nonliteral"
 warning in integer_type_print()
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Mon, 28 Aug 2023 18:24:25 +0200
In-Reply-To: <ZOzDNFqXdftWgtTF@calendula>
References: <20230828144441.3303222-1-thaller@redhat.com>
         <20230828144441.3303222-9-thaller@redhat.com> <ZOy4VvjT/vxpR5iR@calendula>
         <dd5bf8c204447fa7dda1b5bfb87a830f07a55c04.camel@redhat.com>
         <ZOzDNFqXdftWgtTF@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 2023-08-28 at 17:54 +0200, Pablo Neira Ayuso wrote:
> On Mon, Aug 28, 2023 at 05:33:01PM +0200, Thomas Haller wrote:
> > On Mon, 2023-08-28 at 17:08 +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Aug 28, 2023 at 04:43:58PM +0200, Thomas Haller wrote:
> > > >=20
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0_NFT_PRAGMA_WARNING_DISA=
BLE("-Wformat-nonliteral")
> > >=20
> > > Maybe simply -Wno-format-nonliteral turn off in Clang so there is
> > > no
> > > need for this PRAGMA in order to simplify things.
> >=20
> > "-Wformat-nonliteral" seems a useful warning. I would rather not
> > disable it at a larger scale.
> >=20
> > Gcc also supports "-Wformat-nonliteral" warning, but for some
> > reason it
> > does not warn here (also not, when I pass "-Wformat=3D2"). I don't
> > understand why that is.
>=20
> Can you see any other way to fix this clang compilation eror without
> this pragma? What makes clang unhappy with this code?
>=20


the compiler warning happens, because the argument isn't a string
literal. But the deeper cause is something else entirely (and the
patches wrong).


Those "%Zu" format strings aren't intended for libc's printf. Instead,
it's intended for gmp_vfprintf(), which implements a different meaning
for "Z".

The patch "src: use "%zx" format instead of "%Zx"" should be dropped.
Likewise, "datatype: suppress "-Wformat-nonliteral" warning in
integer_type_print()".


Instead, the format attribute from

int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...)
       __attribute__((format(printf, 2, 0)));

needs to be dropped. This is not the "printf" format.


Will do in v2.


Thomas

