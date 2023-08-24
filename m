Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F5FC3DA6F
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Aug 2023 07:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbjHXHpK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 03:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236069AbjHXHol (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 03:44:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E79E1722
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 00:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692863027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mVD40Xh1E5rKvwmW/JRwjDGCvbQiarn31uvOS8o2Bqs=;
        b=XPeYNA9Aw79K6beAanO26HkvaRIkx6qgAzGPP9RcnUSJdN1ol6S+58ez/T9rCQ4JKcCmeM
        vIfY7nGPgUu7FPbFZBCHb2he96Osa+JiX93iEXz/vzk59GkkjDncZAIgCT5CEr7+DaqYVK
        r/ivGPJMQ9arUY+v5AxhTsatLJqWdl0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-Xy-wHdJ_P3aqnYDIIAxyGA-1; Thu, 24 Aug 2023 03:43:45 -0400
X-MC-Unique: Xy-wHdJ_P3aqnYDIIAxyGA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3fe14dc8d7aso14601185e9.1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 00:43:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692863024; x=1693467824;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mVD40Xh1E5rKvwmW/JRwjDGCvbQiarn31uvOS8o2Bqs=;
        b=RrwDyBifHvDG7atVdWR+BQKcj2+mCahfOVrBsPT95TLb4eN1cLD6ulgBUvys/hIGXQ
         Ua4Bk2DhcK+LZuqwXfD3ASqOubZk6bayyIV2m0eZgC7sm19uVB626WMTQ9PBwlslVOqa
         PyYy62vfT7QkMcXEtMgCABSWfMRIwwNJv1RhReq5fEaCw+djrmFdt++WgRE1ht/rjdzk
         iKe8j+E41MSTxMPvYgFOpoR5fLz6za7QNVH65lgyfzJZNh5suaNHbl+XVBw0MEr3bun1
         7//1Il41adIqE9Z8d3I3H3rEHzEUC3SmykCTGigQ86/ZDnj3lxy64K8Y00G7t48QodUB
         nJhA==
X-Gm-Message-State: AOJu0YwInRtOnewJb3ZbAPMfD6xNmozbHgoN99rbo3tluK6ccNwnPgSg
        fgvlBAXO6IVZWL1Qgi+z3oq6zFUTDfdpvruOgvJT4LfSmNr701OaMCw6XRdITKrnHw7ZRRDgzMH
        YJiAWUKxvVs29l/qVzIne9/iHzP7XORXPAqN1
X-Received: by 2002:a7b:c459:0:b0:3fe:5228:b78c with SMTP id l25-20020a7bc459000000b003fe5228b78cmr11776474wmi.1.1692863024229;
        Thu, 24 Aug 2023 00:43:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEaq00Y0qeOo9oDbpYwNGbWy/ZVy5wP2cFO6vkICvVcI42D1XQBNZiHDPtxeC26PNPfSYLKsQ==
X-Received: by 2002:a7b:c459:0:b0:3fe:5228:b78c with SMTP id l25-20020a7bc459000000b003fe5228b78cmr11776459wmi.1.1692863023940;
        Thu, 24 Aug 2023 00:43:43 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id f23-20020a7bc8d7000000b003fbc9d178a8sm1767912wml.4.2023.08.24.00.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 00:43:43 -0700 (PDT)
Message-ID: <1b819d702e02acc20b5119e3f26ca4d3aad0b4f2.camel@redhat.com>
Subject: Re: [nft PATCH] clang-format: add clang-format configuration file
 from Linux kernel
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Thu, 24 Aug 2023 09:43:42 +0200
In-Reply-To: <ZOcBRE869V3ViqDh@calendula>
References: <20230823071134.1573591-1-thaller@redhat.com>
         <ZOcBRE869V3ViqDh@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2023-08-24 at 09:05 +0200, Pablo Neira Ayuso wrote:
> Hi Thomas,
>=20
> On Wed, Aug 23, 2023 at 09:11:31AM +0200, Thomas Haller wrote:
> > Clang-format is useful for developing, even if the code base does
> > not
> > enforce an automated style. With this, I can select a function in
> > the
> > editor, and reformat that portion with clang-format. In particular,
> > it
> > can fix indentation and tabs.
> >=20
> > The style of nftables is close to kernel style, so take the file
> > from
> > Linux v6.4 ([1]). There are no changes, except (manually) adjusting
> > "ForEachMacros".
>=20
> I'd prefer you keep this locally by now.
>=20
> If more developers are relying on this feature, we can revisit later.
>=20


Hi Pablo,

OK.

If anybody is interested, I solved this on my end, by having nftables
checked out in a subdirectory like

  nftables
  =E2=94=9C=E2=94=80=E2=94=80 .clang-format
  =E2=94=94=E2=94=80=E2=94=80 nftables
      =E2=94=9C=E2=94=80=E2=94=80 aclocal.m4
      =E2=94=9C=E2=94=80=E2=94=80 ...



And for the record, these were the patches that introduced the file to
kernel and the documentation in kernel:

 - [PATCH] clang-format: add configuration file
   https://lore.kernel.org/lkml/20180312233952.niz2cuz7psv4fe2s@gmail.com/

 - [PATCH v2] clang-format: add configuration file
   https://lore.kernel.org/lkml/20180318171632.qfkemw3mwbcukth6@gmail.com/

 - Linux Documentation/process
   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain=
/Documentation/process/clang-format.rst?id=3Dv6.4


Thanks,
Thomas

