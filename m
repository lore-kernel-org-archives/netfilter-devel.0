Return-Path: <SRS0=LKiS=YY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7382CA9ECB
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 14:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81EDA2080F
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 14:22:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Keyt4krY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfJaOWK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Oct 2019 10:22:10 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44832 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfJaOWK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 10:22:10 -0400
Received: by mail-io1-f68.google.com with SMTP id w12so6885349iol.11
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2019 07:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vW4ENteUBmLOap1qwOSdFQ+y6LtriChtUs/listSVIY=;
        b=Keyt4krYEJ5gdV5K9f4Rw8CqJnol65ZcQioPnW1ScFpvx4wW1YAA81dIPbrdu7Dbzk
         CXM+Lj49Vba4g0lto5dLK8UgVUaVBYWX/y015A3KK2iveme/4CHpqXCZPHNXJ1Ktovpx
         96pIK1Vtn3E5arG0knwZbP8rx+nr6UwTKQd/70tAXt1Wkh7WUSQh8/otAOtS3/lxNcxb
         tvrly2TcmuiHVead8Xy9x9pbvKyYdulNWxTxeo3MfRpOFD2Nfe1NBlvOH6BLXNq6g1Td
         O0GqShhq8rVpM03+LsPI0USetmydqWlcKhzv+E04FJErDj0URD1AvxMELTp+nG0EPKoz
         xxFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vW4ENteUBmLOap1qwOSdFQ+y6LtriChtUs/listSVIY=;
        b=Z6lExw22xt6djQFHicAOvXvk/AwVO3oqwI/0VYceX7nuNu0NJna+z5VFE1yT6yf6RC
         JEUZaLAQ0oiBdB7wxSDMsx3ftNbYcvGImdsAUQbnfBmx1mN8vyTWEnSqT0FIRYvRfT70
         oAB3nVSqmijPud8YuJcZi4/EnDaGL5soQETAYtguSVX6M0lIslgDOMa8MEPpP+CwF0Lr
         aZlenCkEwHAUOjegXFn5SBZJJ8AbCxHk2yypGtyTbABZZnqVqWmyrHCGQHY1g/966FDn
         seLIri3VjsMpwgb68hsk5EZRiqlN3sLDTQF8ctXp7ySuqiiRMybOr1+ZjzmQCrL6GEcw
         J6eQ==
X-Gm-Message-State: APjAAAWFYqse0VIb91Vnku6+l2QymwtPaQxrKnpjQWMkR2DGmHSea4q0
        VONjyAz1PQuTIY3uuaP4jBJa6JXek3m+iV47Lv4=
X-Google-Smtp-Source: APXvYqymBvQt9vMikXRrO5YRQ19g45JiRsnaKNKDFAIFPLUH/DS8u8bx2sduYT//cdCJ6grfyGiMVGdhRt7BkFHxOgY=
X-Received: by 2002:a6b:c701:: with SMTP id x1mr5430277iof.162.1572531729060;
 Thu, 31 Oct 2019 07:22:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190926105354.8301-1-kristian.evensen@gmail.com>
 <alpine.DEB.2.20.1910022039530.21131@blackhole.kfki.hu> <CAKfDRXjgsAbTxgLwBpY+MiYWAyu4n4puJjgTOaBx0oSr+pNzrQ@mail.gmail.com>
 <alpine.DEB.2.20.1910311512440.30748@blackhole.kfki.hu>
In-Reply-To: <alpine.DEB.2.20.1910311512440.30748@blackhole.kfki.hu>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Thu, 31 Oct 2019 15:21:57 +0100
Message-ID: <CAKfDRXjjYXx1XjcaMDFU2nyhb_UG248DGjpKfVDUCBmemVcHEA@mail.gmail.com>
Subject: Re: [PATCH] ipset: Add wildcard support to net,iface
To:     =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jozsef,

On Thu, Oct 31, 2019 at 3:14 PM Kadlecsik J=C3=B3zsef
<kadlec@blackhole.kfki.hu> wrote:
> I have just applied your patch in my ipset git tree. I'm working on a new
> release, hopefully it'll be out at the weekend. Thanks for the patience!

No problem and thanks a lot! Enjoy the rest of the day.

BR,
Kristian
