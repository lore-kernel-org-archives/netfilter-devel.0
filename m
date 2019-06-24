Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43268C43613
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 12:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1037F205F4
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 12:35:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RJFzuAqk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730283AbfFXMfS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 08:35:18 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:35618 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfFXMfS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 08:35:18 -0400
Received: by mail-io1-f41.google.com with SMTP id m24so1278228ioo.2;
        Mon, 24 Jun 2019 05:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ha8jOAvPyFHQG05j77z3/er9i1p/VxWzamC1x2MmWhM=;
        b=RJFzuAqke7bGFJLkURhXZiEjBbehf/xNGIb+5xvquAK/VxH5feqpPVblj4MiYnco/Z
         Z6k1JYf7y6OwLgy7ggrVFWOGpyTfc2w6WGKbGHcvJx9sv5UWjAA7CohHSay2vnt5d/T0
         4OGNQwo2H9geBEKTqsPrDkiQFkY0ghg9//Y0zB1yLOAan/4s2N3YbmxdXGSffBuOy70V
         S+aBCSm6tqwb3BlWXqReAv1c3jSKBa9hpXScF1T8lZPyaWKwbArV17d6Nt03PMcrAok0
         9h/XXjnpnr2vTEl4zQHCuF+zwnIvswyk1Xx8LeFb1MipjpFu8pJYfTuyiRxUxWK2q1V/
         /bdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ha8jOAvPyFHQG05j77z3/er9i1p/VxWzamC1x2MmWhM=;
        b=FIMIzNqGHKQA0OzCKq3qNMbEvVARuZ7Sy+acJD++AXU/5vwEkBirF6B0mvr1gLy23a
         wa/q2ZaLVRupgfu3Ie/+StO3BJUAkBTHwDVl3dTEFYJSxSKqYl6xfdnshhJGqQkZu1fx
         f35MukiXo2/jtbuJvaEt17Lz+gDHWtG7uxFHtVX9JquXjyYH70EzNbva27gzGkeGphH4
         tLIDA9OZhnwEpfg73i2peGjKkiZbZthcbDMc904051gLduR+k/v2SzlFDZaPrpn/iqzn
         +Y6VpMgJwqs5vP8Lno6bDj6mlp3eQuxBNHGgTyoCOmsv4eaPic3HqNkJk4ZV5clpzYrf
         izvA==
X-Gm-Message-State: APjAAAXZUpZgE6BnZUF6iI6SLzZTIQZhTfLeR9/2g5cfJK/H4zAUlOGw
        Q0o+chwO/5fyK47ZFp8mvgqiT1jDu692WM9+3Tt3+OgH
X-Google-Smtp-Source: APXvYqwX/dijPPh+IBKyh1U+aIfr28/QOZy+Z0kHPhlqRgYCXv5cDT1yGbxzWQB/mphkmIKtkLk+2p6rE36LY6VtpI0=
X-Received: by 2002:a6b:2bcd:: with SMTP id r196mr16617324ior.73.1561379717321;
 Mon, 24 Jun 2019 05:35:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAK6Qs9mam2U6JdeBnkzX9sfdeWWkLx_+ZgHOTmYjSC2wKfg0cQ@mail.gmail.com>
 <20190618104041.unuonhmuvgnlty3l@breakpoint.cc> <CAK6Qs9kmxqOaCjgcBefPR-NKEdGKTcfKUL_tu09CQYp3OT5krA@mail.gmail.com>
 <20190618115905.6kd2hqg2hlbs5frc@breakpoint.cc> <CAK6Qs9mTkAaH9+RqzmtrbNps1=NtW4c8wtJy7Kjay=r7VSJwsQ@mail.gmail.com>
 <20190618124026.4kvpdkbstdgaluij@breakpoint.cc> <CAK6Qs9nak4Aes9BXGsHC8SGGXmWGGrhPwAPQY5brFXtUzLkd-A@mail.gmail.com>
 <CAK6Qs9=E9r_hPB6QX+P5Dx+fGetM5pcgxBsrDt+XJBeZhUcimQ@mail.gmail.com>
 <20190621111021.2nqtvdq3qq2gbfqy@breakpoint.cc> <CAK6Qs9m88cgpFPaVp2qfQsepgtoa02vap1wzkdkgaSuTMm_ELw@mail.gmail.com>
 <20190624102006.t27x6ptnl647mcji@breakpoint.cc>
In-Reply-To: <20190624102006.t27x6ptnl647mcji@breakpoint.cc>
From:   =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.metu@gmail.com>
Date:   Mon, 24 Jun 2019 15:35:06 +0300
Message-ID: <CAK6Qs9mYTbynefS-AT7N+FPo-hbFFGxEncrU_dvO6Yjc6OFG1g@mail.gmail.com>
Subject: Re: Is this possible SYN Proxy bug?
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 24, 2019 at 1:20 PM Florian Westphal <fw@strlen.de> wrote:
>
> =C4=B0brahim Ercan <ibrahim.metu@gmail.com> wrote:
> > We tested fixed code on real environment and we are still getting some
> > errors.
>
> Can you submit your patch officially?
> The MSS fix is needed in any case.

I submitted. This is my first patch attempt. Sorry for any inconvenience.

>
> > When I examine traffic from pcap file, I saw connections opens
> > successfully but somehow something goes wrong after then.
>
> Do you have an example pcap of a connection stalling?

I will ready and send it to you soon. Can I send a file to this mail
list? Or should I send it directly your personal email?
