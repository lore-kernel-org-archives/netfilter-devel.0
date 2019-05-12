Return-Path: <SRS0=q8lh=TM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99615C04A6B
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 May 2019 16:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CADC2133D
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 May 2019 16:41:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qr/ZoFmt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfELQld (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 May 2019 12:41:33 -0400
Received: from mail-vs1-f42.google.com ([209.85.217.42]:39212 "EHLO
        mail-vs1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbfELQld (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 May 2019 12:41:33 -0400
Received: by mail-vs1-f42.google.com with SMTP id g127so6575665vsd.6
        for <netfilter-devel@vger.kernel.org>; Sun, 12 May 2019 09:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8Rb1MfGlGYpexCIGQUkFdHwCgDOpQ5a0B7YeYMXJ0xs=;
        b=Qr/ZoFmtxpo4S5vWIei+z6sTkL3WKpVJwyz/tSFOS0/DmF8BQjfOUUeqO7AyuJrTB/
         RS217DDcwZHMOPAxIqFyeYAXyJ+jd4F7wRzjADvjysZ1rOb9fnu4WOxvErVjqyunyT4a
         7IJ8x5iOAwOEHITa5XNg8XIjz/nyS8wS3WsIetkSaJfSGOdfjSNXMb2mtQj0bO8fM15K
         AT18alx3zaZ9g3Sqw3gBFZxVUThkqypXhFDKI1dCGK+7dr85r+IGqncUrElYmjcrMzAq
         iQjH5sCvqmpYtdxmNGREGbWnW5LgioBM9qxpnUXhYW9HyBX+RTmQSLzxyHh5V9GL+LvE
         tkog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8Rb1MfGlGYpexCIGQUkFdHwCgDOpQ5a0B7YeYMXJ0xs=;
        b=h0z1OMclyJanvJvQgsPIB87NYYlrdqVbLrq7iyfdjrZ05lkZDjku6Y4rF0WHqn4AXp
         Y0DqEVsCTr3eCDKDZgt6brnwGTnlyp1snjweSKa3pvvr2rQBIFN7Pu6JhoX6lsmmuklz
         pMjHj7Uag4ojHC91PuglhvidcXyi2W6uy7Smouj0v8txFJZb1MbBsFKFtkNWyqELY2Us
         LJzhwnT5Uu0yLPU1Gj669W/cqzPFL8rvS2hx3SGNcWP1ZOYYHk889iwld3lnC0B3Ktx3
         qqfgysARFQQu7W1As+mABtZUTGx+haY35eVdbr34aKGNUmVzcvvJsr9ohlqHZt+fhTrb
         x9gA==
X-Gm-Message-State: APjAAAXTSac0kcrQQYoGswIwlRWFSq1dYPwklgNUkGBJ9olxyXUAuuye
        ioJoTRtW5MRZUCypCegzcnj1qupjS9i+FMWoxIPfmg==
X-Google-Smtp-Source: APXvYqxydVFOsKViKWJF2XHKZnyQUGDe3Nit5em1fzBjlEcNl3LZbcaRRmpqNb0+jomFGKPhY/BC9qEOEZNhZ32Csy8=
X-Received: by 2002:a67:ba11:: with SMTP id l17mr11462705vsn.166.1557679292543;
 Sun, 12 May 2019 09:41:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAFs+hh4ghFJqE=b+CXiVL9AguKr1MjZntuDvzYyqmDy5aGJPLw@mail.gmail.com>
 <20190512085624.gdzbjeb4htdp7z45@breakpoint.cc> <CAFs+hh7TXHELQr7aTQXJrkko-jN=C8Nx=s6ZhxQNDyB+KECTnA@mail.gmail.com>
 <5eb8284f-6d22-224d-1f52-011c5bf79a4a@riseup.net>
In-Reply-To: <5eb8284f-6d22-224d-1f52-011c5bf79a4a@riseup.net>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Sun, 12 May 2019 18:41:21 +0200
Message-ID: <CAFs+hh6EZdvb3su-9Uv0uHVEzQx2n3oh+aQj394fMpdKn+rCvw@mail.gmail.com>
Subject: Re: Undefined reference?
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le dim. 12 mai 2019 =C3=A0 18:28, Fernando Fernandez Mancera
<ffmancera@riseup.net> a =C3=A9crit :
>
> I faced a similar problem a long time ago, I solved it by resetting the
> linker cache. Try this.
>
> # rm /etc/ld.so.cache
> # ldconfig

Thank you for your suggestion, but it is still not working. I think
that your suggested action is done by make install with the library,
anyway.
