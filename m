Return-Path: <SRS0=q8lh=TM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1382C04A6B
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 May 2019 16:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 977C82146F
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 May 2019 16:20:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UpEimMw9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfELQUt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 May 2019 12:20:49 -0400
Received: from mail-ua1-f47.google.com ([209.85.222.47]:46628 "EHLO
        mail-ua1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfELQUs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 May 2019 12:20:48 -0400
Received: by mail-ua1-f47.google.com with SMTP id a95so3887811uaa.13
        for <netfilter-devel@vger.kernel.org>; Sun, 12 May 2019 09:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TAg0r1IQAfB/qkaWwKaz4ZzdPc0xpYFexK7Qz8tEuUU=;
        b=UpEimMw9AA71Z8Edr3RgwVRlZhtrVFYvlfsQFBGuvaS83QhrcntD2SZC1HBwTmcbwl
         m965ghDqaP1MZrN6fw7sKUYgn8wzY8RC1hVyCkJyFDGBYS6esuJ3MnVOYPnB099MM3Z6
         nIl/4qBCAX8MJZCbwAUDjSYNCIScJ5g5Hof3YB5nHDsDbMs5mF7sSP7BOyYcPoCfPuPF
         2ytyxS62Fk8IAZ7FSNEo3VPPR+vihRuVyEKTeASYikb3MvHP5O1UZWGGnPMUPaLMLuqK
         U4iE7ZFp/nF9XwQVbP1V7wat7Pn0250ZAQr4WqsxA/zBY7CFmsb8RD/1XlQzBz3L/Knq
         YzWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TAg0r1IQAfB/qkaWwKaz4ZzdPc0xpYFexK7Qz8tEuUU=;
        b=OHiE8uqk5WneQKIydyCC5nMOpAXUSBSX23AF46O8MG4CW8DSwDYRek7hUaE661RZyB
         ja/25lMlYeLypJVKmrN20viUvtqDUT7gYkVwyw+UVFF4CYp4Sy8JQ5A83h527AIPdTBV
         LH51RTkcRKAqElnqyvZ/6PRRW/QJ+7zxFEPtAZhmRjfcD3Nm+cC2uv2CFz0KSm75Pyqe
         3bha68gEOUHMzqqS7DPwPDF7dzQ+jCSGaopCAFggmTGt/WDNDkoHXSn2HEgFS6bihBWD
         a054ns8e9rL57cfn0YXADvyv9P7iGYc27q00t+6dWLatKN3uAdAawaF63rjenzn7We6T
         QcpQ==
X-Gm-Message-State: APjAAAWA0DnWmPXU+REWbcI0L7C5YbmWeXDTNnvwGhgjw/LC+8Zhbxaj
        7DOPEp4wyCyEoIHdcrepO+wgmkmEMmvgcCKLDJixRA==
X-Google-Smtp-Source: APXvYqxfgSmCBagriElpcdg1aqBvzzXpSw2UQyXlz2sZiW6cXlb54YWpyHjQmgKQaEWsoeADs/p1Jz+SKTLUVeHAfPY=
X-Received: by 2002:ab0:2a53:: with SMTP id p19mr11497680uar.100.1557678047638;
 Sun, 12 May 2019 09:20:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAFs+hh4ghFJqE=b+CXiVL9AguKr1MjZntuDvzYyqmDy5aGJPLw@mail.gmail.com>
 <20190512085624.gdzbjeb4htdp7z45@breakpoint.cc>
In-Reply-To: <20190512085624.gdzbjeb4htdp7z45@breakpoint.cc>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Sun, 12 May 2019 18:20:36 +0200
Message-ID: <CAFs+hh7TXHELQr7aTQXJrkko-jN=C8Nx=s6ZhxQNDyB+KECTnA@mail.gmail.com>
Subject: Re: Undefined reference?
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le dim. 12 mai 2019 =C3=A0 10:56, Florian Westphal <fw@strlen.de> a =C3=A9c=
rit :
>
> > Now, I am trying to modify the nftables userspace tool. I had to set va=
riables:
> > LIBNFTNL_CFLAGS=3D"-g -O2"
> > LIBNFTNL_LIBS=3D$HOME/libnftnl/src/.libs/libnftnl.so ./configure
> > in order for configure to work, but it worked. But at linking time, I
> > get the following error for each nftnl_* function:
> > ld: ./.libs/libnftables.so: undefined reference to `nftnl_trace_free'
> >
> > I tried to set the LD_LIBRARY_PATH to /usr/local/lib but it did not
> > change anything. Do you have an idea of what the problem is?
>
> Try
>
> LIBNFTNL_LIBS=3D"-L$HOME/libnftnl/src/.libs -lnftnl" ./configure

No luck, same result=E2=80=A6 :-(
