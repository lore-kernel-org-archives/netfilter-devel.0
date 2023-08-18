Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3374C001DE
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 09:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343819AbjHRJrL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 05:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346482AbjHRJqj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 05:46:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2002684
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 02:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692351955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xu9gXbFFlv3JWPBDXHSz0r4IxMquUv3L3hZx2YIL1DI=;
        b=ESDjmCj0o/QZ0szU8Y8o3wuCt59YM753SH5XIVynroBkbQzqM9jw9RDFTxqb0Rnv4SSHib
        idMbxHZLrAlXGENzpRgUH9KCXRzs84i8saEjXjWEKGX3LWxakcqpP0xyEAAQZf2Pqe+cit
        ZsCvDmLWVAboYVJwo/4Hdk6vW3cVWno=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-0zCJAeZ5P6KRqKGkQF3kDg-1; Fri, 18 Aug 2023 05:45:52 -0400
X-MC-Unique: 0zCJAeZ5P6KRqKGkQF3kDg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3fe12bf2db4so1156535e9.0
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 02:45:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692351951; x=1692956751;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xu9gXbFFlv3JWPBDXHSz0r4IxMquUv3L3hZx2YIL1DI=;
        b=QYjvJCk2dKX9jG60Z3PO8iBw4nZw5mKMxFeBVhXFjFCjIx1or1Vlf/EzpX54A7BoJy
         iZhYWqCe9A997qXiq9dJngoRNz2oAvHOAp2SPDQCl/Cme7pMDiYpulGnhvPo1KFB1SB5
         b6EMA/fBrA17LSjAqQ0mVfQzDTBkNxPbYScqdTtyiiBAS1G81bv5DJDiAOKSC34itpyh
         nAU3u3C4tcXQ8U/SkocKgTpbwvxkEWZ4KB3W+1Noc8eaY2e4JSI64bkZ3KQRI5HJFRUQ
         nO8TqUYGZu5jBo/g0HdC/CJQDVRsRnYEPRPvCshSYNUaoLRfY25msUDjpWp4xOUDlw3t
         Tdtw==
X-Gm-Message-State: AOJu0YyIn47wgNsTmjRUsDDFONPCW/tctIq3b6i9jRKPJ2AvwnE0Hu6k
        PATWwueok8baXYkgJ5v3Z3Yl0PQpbIGvP9MRo3qaq8uOp+WsFaveFXnnG82+j4CAquKeD3VIw/7
        51vDwfnq5MX0EcFpqYKiK//O4Xysu
X-Received: by 2002:a05:600c:3b0f:b0:3fa:97b1:b12d with SMTP id m15-20020a05600c3b0f00b003fa97b1b12dmr1767207wms.2.1692351951072;
        Fri, 18 Aug 2023 02:45:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHX+7XohHJHqWpEW9KRFujKffBjC7ya7DqyBkwwYxhgnWLPodpNN1ZEUSOZmSNN1pZPYPdAw==
X-Received: by 2002:a05:600c:3b0f:b0:3fa:97b1:b12d with SMTP id m15-20020a05600c3b0f00b003fa97b1b12dmr1767203wms.2.1692351950806;
        Fri, 18 Aug 2023 02:45:50 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id p14-20020a7bcc8e000000b003fe1cac37d8sm5719361wma.11.2023.08.18.02.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 02:45:50 -0700 (PDT)
Message-ID: <79a7170508e209263241654f7195cd4cd31abbae.camel@redhat.com>
Subject: Re: [nft PATCH v4 6/6] py: add Nftables.{get,set}_input() API
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Fri, 18 Aug 2023 11:45:49 +0200
In-Reply-To: <ZNz0+hTYXVqvozX+@orbyte.nwl.cc>
References: <20230803193940.1105287-1-thaller@redhat.com>
         <20230803193940.1105287-13-thaller@redhat.com>
         <ZNz0+hTYXVqvozX+@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-08-16 at 18:10 +0200, Phil Sutter wrote:
> On Thu, Aug 03, 2023 at 09:35:24PM +0200, Thomas Haller wrote:
> > Similar to the existing Nftables.{get,set}_debug() API.
> >=20
> > Only notable (internal) difference is that
> > nft_ctx_input_set_flags()
> > returns the old value already, so we don't need to call
> > Nftables.get_input() first.
> >=20
> > The benefit of this API, is that it follows the existing API for
> > debug
> > flags. Also, when future flags are added it requires few changes to
> > the
> > python code.
> >=20
> > The disadvantage is that it looks different from the underlying C
> > API,
> > which is confusing when reading the C API. Also, it's a bit
> > cumbersome
> > to reset only one flag. For example:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0 def _drop_flag_foo(flag):
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if isinstance(flag, int):
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 retu=
rn flag & ~FOO_NUM
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if flag =3D=3D 'foo':
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 retu=
rn 0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return flag
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0 ctx.set_input(_drop_flag_foo(v) for v in ctx.g=
et_input())
>=20
> IMO the name is too short. While I find it works with debug
> ("set_debug"
> as in "enable_debugging") but with input I expect something to
> follow.
> So I suggest renaming to (get|set)_input_flags(), similar to
> __(get|set)_output_flag() (which get/set a single flag instead of
> multiple).


Hi Phil,

changed in v5.

thank you!
Thomas

