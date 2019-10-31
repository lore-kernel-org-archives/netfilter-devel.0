Return-Path: <SRS0=LKiS=YY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0A9CA9ECB
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 14:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5433620873
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 14:14:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="YbsLFlJF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfJaOO2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Oct 2019 10:14:28 -0400
Received: from smtp-out.kfki.hu ([148.6.0.45]:36549 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727589AbfJaOO1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 10:14:27 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id CD8C467400F7;
        Thu, 31 Oct 2019 15:14:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1572531263; x=1574345664; bh=4xPM+8xf96
        ksPbliDAWG47TBZW3oPZ1QPjGHadFdqpY=; b=YbsLFlJF5ioAa/pAxPqlCcVJIR
        TzLUe4ggz0YIMNo4/Lwk1lkw2F0XWM1NmxbGf1w/LTUq0IV4MfEn/FVQCZEGYzBa
        mDRSNVTFKOYZH2NJXyx15bSrGnHZv0r8ele0rGXxWOkGXUYYgSQvRzr+lxBJ20X6
        3BLS/JH27p/5xo3g0=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 31 Oct 2019 15:14:23 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 8ECC467400FF;
        Thu, 31 Oct 2019 15:14:23 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 8025A20B5D; Thu, 31 Oct 2019 15:14:23 +0100 (CET)
Date:   Thu, 31 Oct 2019 15:14:23 +0100 (CET)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     Kristian Evensen <kristian.evensen@gmail.com>
cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] ipset: Add wildcard support to net,iface
In-Reply-To: <CAKfDRXjgsAbTxgLwBpY+MiYWAyu4n4puJjgTOaBx0oSr+pNzrQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1910311512440.30748@blackhole.kfki.hu>
References: <20190926105354.8301-1-kristian.evensen@gmail.com> <alpine.DEB.2.20.1910022039530.21131@blackhole.kfki.hu> <CAKfDRXjgsAbTxgLwBpY+MiYWAyu4n4puJjgTOaBx0oSr+pNzrQ@mail.gmail.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="110363376-284119315-1572531263=:30748"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-284119315-1572531263=:30748
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi Kristian,

On Thu, 31 Oct 2019, Kristian Evensen wrote:

> On Wed, Oct 2, 2019 at 8:46 PM Kadlecsik J=C3=B3zsef=20
> <kadlec@blackhole.kfki.hu> wrote:
> > Sorry for the long delay - I'm still pondering on the syntax.
>=20
> I hope you are doing fine. I don't mean to be rude or anything by
> nagging, but I was wondering if you have had time to think some more
> about the syntax for wildcard-support?

I have just applied your patch in my ipset git tree. I'm working on a new=
=20
release, hopefully it'll be out at the weekend. Thanks for the patience!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-284119315-1572531263=:30748--
