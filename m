Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6456C43613
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 07:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A04D22083D
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 07:55:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZPbHMvhH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfFXHzU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 03:55:20 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:47012 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfFXHzU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 03:55:20 -0400
Received: by mail-io1-f47.google.com with SMTP id i10so209375iol.13;
        Mon, 24 Jun 2019 00:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NcGPD7WGZob7Z0F2AuiL/J621nCYUfaj4RNcnY6DcZk=;
        b=ZPbHMvhH0oARpHV0CzpTxecXKPbYZ0DtWqryzHW+zzV6Pw66eikTWYh5wWLDmjMpUD
         bNyFJjoUmM6z15Y+g0beeW29tew/KCe7aG36n/EB+2AOlIyxVzhs45lUh5NqHNHHOmuE
         zl4sGJ1qTsQPtq+3AFhgFBNkmRHfqSDuilhXmdWKL4fMbJJVHpCQIIfXXrcSTwLdTotY
         kDMbVvw73Mjp9hgDuGiqeZMsHnTtDxHuQJLTwSTc8OLpauqxVDl5Q/K54DUx61satVyU
         4K1ZQVe8mVXVAMeTKoYeVVB43ppVz9xUGRCCW5sw4KunyYMYmjpfL6jchZmBNGN4j0nX
         Aq3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NcGPD7WGZob7Z0F2AuiL/J621nCYUfaj4RNcnY6DcZk=;
        b=i3zrHf13OCCGvn68tIvPwTOZJ/mS40XbGIq7MACf+CWNRLqmpTAeHmENuQx15957b5
         7H9fkAaK/7vnjoHAwjhZuOPxmvDZxKEcD5TEzSpomvyQg8aCSIzuYqx9dA1tp2LEDnCM
         830tp6RxISvif4AZhT38DxiFvX4GYYWTh5dXhGe+pAZgh+ZHtZqJGLQDokZSL3I66zsL
         g+HhLcEwgDMWI58eiasgkBl4TNDenxrIFr3g9rDNEhhT1DAm/Pr3iIYEHozmuVV6WY1Z
         NHMCLefojey7E9xOWTr3WMwu77HeUMOsFl6PO5midYBMwGkV5oYZRA7e2zoJuKkM2Xc1
         tRBw==
X-Gm-Message-State: APjAAAWtYHShNwGEUs38CBp7kOrfUvIzPIynfvBKNX4dRS+f6P0071gM
        HqvKGdMDn8e+oCo76c++CrKvFhMr0DyGmDHKb4LqydzE
X-Google-Smtp-Source: APXvYqzRGXiEbeg73p64ubto9GUV0xwbBhGFevo1WCEwWVKgxVVWcDjFReLKqXviaeDhrc+7//jJf3bBtCKEle5fX6g=
X-Received: by 2002:a6b:9257:: with SMTP id u84mr35640246iod.278.1561362919069;
 Mon, 24 Jun 2019 00:55:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAK6Qs9mam2U6JdeBnkzX9sfdeWWkLx_+ZgHOTmYjSC2wKfg0cQ@mail.gmail.com>
 <20190618104041.unuonhmuvgnlty3l@breakpoint.cc> <CAK6Qs9kmxqOaCjgcBefPR-NKEdGKTcfKUL_tu09CQYp3OT5krA@mail.gmail.com>
 <20190618115905.6kd2hqg2hlbs5frc@breakpoint.cc> <CAK6Qs9mTkAaH9+RqzmtrbNps1=NtW4c8wtJy7Kjay=r7VSJwsQ@mail.gmail.com>
 <20190618124026.4kvpdkbstdgaluij@breakpoint.cc> <CAK6Qs9nak4Aes9BXGsHC8SGGXmWGGrhPwAPQY5brFXtUzLkd-A@mail.gmail.com>
 <CAK6Qs9=E9r_hPB6QX+P5Dx+fGetM5pcgxBsrDt+XJBeZhUcimQ@mail.gmail.com> <20190621111021.2nqtvdq3qq2gbfqy@breakpoint.cc>
In-Reply-To: <20190621111021.2nqtvdq3qq2gbfqy@breakpoint.cc>
From:   =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.metu@gmail.com>
Date:   Mon, 24 Jun 2019 10:55:07 +0300
Message-ID: <CAK6Qs9m88cgpFPaVp2qfQsepgtoa02vap1wzkdkgaSuTMm_ELw@mail.gmail.com>
Subject: Re: Is this possible SYN Proxy bug?
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 21, 2019 at 2:10 PM Florian Westphal <fw@strlen.de> wrote:
>
> Yes, something like this is needed, i.e. we need to pass two
> mss values -- one from info->mss ("server") that we need to
> place in the tcp options sent to client and one containing
> the clients mss that we should encode into the cookie.
>
> I think you can pass "u16 client_mssinfo" instead of u16* pointer.

Hi Florian.

We tested fixed code on real environment and we are still getting some
errors. We have a customer using syn proxy in front of a point of sale
(POS) application and they reported that about %0.4 of connections are
erroneous.
When I examine traffic from pcap file, I saw connections opens
successfully but somehow something goes wrong after then.
If we deactivates syn proxy, problem goes away. So we are sure it is
caused by syn proxy.
How can I debug syn proxy further? Do you have any suggestion?

Regards.
