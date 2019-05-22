Return-Path: <SRS0=iiCe=TW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4597FC072A4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 06:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A90620863
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 06:36:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vfIEykjd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbfEVGgM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 May 2019 02:36:12 -0400
Received: from mail-vs1-f45.google.com ([209.85.217.45]:37954 "EHLO
        mail-vs1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728533AbfEVGgM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 May 2019 02:36:12 -0400
Received: by mail-vs1-f45.google.com with SMTP id x184so737365vsb.5
        for <netfilter-devel@vger.kernel.org>; Tue, 21 May 2019 23:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KzYdcPVKSgwUXP3Z5oUEf0CWMm3paPTEssKQiTKCOro=;
        b=vfIEykjdCV15nQqu77ubNecSFgTB/seVe9R0s51swdOiV3weSd6QcvqXB3SzL978uZ
         03gVKSQ2hR0SpBP6+RI6J+Idc6vzMjwXTe/PuLbGvS2EDuIPDI/NzGjE5vRp5u+GBPE8
         GwPMRlFlVO+eFEfqwWMMRRHhI2O0B4CwzwqsvZ1ektDHus8Ub8u1VHyK4lB0fx9TGTuj
         B2eZ5QZBjMbQQWwv2ZuKpeZbQGtLOBkVkpsrDr7QJGiNW194OhgqCXPdrdAE9EPr8TTj
         yBgKHKENy8jNLWr+HQahl1IJyKEyDspa+a+oYtH5Nic7lATRzUWTorPinxMd4tQXGVqQ
         14ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KzYdcPVKSgwUXP3Z5oUEf0CWMm3paPTEssKQiTKCOro=;
        b=B7i0OPO5pwxMfAuIzUWxBp0W82Gmd2honYSGCH7+flYPx1wT0blsKedO5SweTdk51s
         jo5obhb4Wkr4OVzjHx1hAkTyxs2VCb+QXTB0bwq8gXW8wrPrxWqC+qBIJ9UWz1p5UtdR
         SnlMDuA2cwqjMaOF+W5jhupLzodor6JaMukQ4spXVFEwuclj+M1VrBfVWAv3R31VXDmL
         4F+OwWdD/FKjqor0EM1pbVIT6ydb6xongZp8g7So8BGDa9oHC57LoVdO1hjp3En8dXeC
         OYSLlUD62YGKmmzkMsylnVG6E+6YO7l0xlRxLK+SZBmcBnJaYdKTp+tGGTnLN6EicL9Y
         LOpQ==
X-Gm-Message-State: APjAAAXhMYhy1Lx7bxAZdXYCUePV7bJ0JO2IvQ3/HmYL3PM+6IB2dISN
        VKi/EaJ/ZdvyaxCUuyEqagNW0ztUlz1oEEtthug2Ww==
X-Google-Smtp-Source: APXvYqx1aCB0qpaAfea3kITGkdjvHg2HD5tp2dtKet0YN1ok4+nyRBjKxUK1s2M6MAa0ACZegGw7RhpSMetQJxqbimo=
X-Received: by 2002:a67:7a0a:: with SMTP id v10mr9582349vsc.203.1558506971247;
 Tue, 21 May 2019 23:36:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAFs+hh7TAWAG9T9kgB2SS8m-xcQQWD4ormR8VT98RXe84MQREg@mail.gmail.com>
 <20190519201440.sb4ajpd6nuuczrkr@breakpoint.cc>
In-Reply-To: <20190519201440.sb4ajpd6nuuczrkr@breakpoint.cc>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Wed, 22 May 2019 08:36:00 +0200
Message-ID: <CAFs+hh6D5nj7UNBfXt+KPO4vOsWOZHkRY1Lpd1UxwiQJ=5Y-dA@mail.gmail.com>
Subject: Re: Expectations
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le dim. 19 mai 2019 =C3=A0 22:14, Florian Westphal <fw@strlen.de> a =C3=A9c=
rit :
> RTSP looks rather complex, wouldn't it be better/simpler to use
> a proxy?

RTSP does not seem that complex to me. It is a bit like FTP: the
client sends a first connection in order to define the ports to use,
then the server initiates the connection on those ports.
I saw some examples of RTSP helper libraries written for old versions
of the kernel (focused on iptables), so I think it would not be very
complicated to port to newest versions.

> We have TPROXY so we can intercept udp and tcp connections; we have
> ctnetlink so the proxy could even inject expectations to keep the real
> data in the kernel forwarding plane.

It would mean we would need to open/expect a very wide range of ports,
if we don't look into the first message to grab the real used port=E2=80=A6

By the way, as I had no feedback for the moment regarding expectation
patch I sent (yes, I know it needs time to code review), I just
wondered if I sent them correctly and if they arrived to the mailing
list. They are 4 mails sent on May 17th at about 18:40 CEST. If
someone could just confirm reception, that would be good.

Thank you

St=C3=A9phane
