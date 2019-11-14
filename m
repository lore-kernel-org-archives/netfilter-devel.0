Return-Path: <SRS0=/b89=ZG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5712C432C3
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Nov 2019 12:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88963206E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Nov 2019 12:53:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="ngfgZR38"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfKNMxE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Nov 2019 07:53:04 -0500
Received: from smtp-out.kfki.hu ([148.6.0.48]:55919 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfKNMxE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 07:53:04 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id C78C3CC00FF;
        Thu, 14 Nov 2019 13:53:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1573735980; x=1575550381; bh=hDs0RBQ/Ca
        /cZ68bLf8iEhRxcoTY9GJHPaaEfDc8RA8=; b=ngfgZR38LNFzaxlgXXOMSRqis4
        zzklA5rdFNvqtJuW9uV+oMxefCf0sDYpvw7T4BYSTuPnsQTI1OXrqEF+yPzTSonx
        VZPQtllAX+lsv/VxlTuzFIy0XHsdC5G5jo2HgRkoEDP/iAwM1vfDyQnJn2bHK0uX
        G5tLpOUc9ry1Q1Bgs=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 14 Nov 2019 13:53:00 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 7E550CC00FD;
        Thu, 14 Nov 2019 13:53:00 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 5A37B20FCF; Thu, 14 Nov 2019 13:53:00 +0100 (CET)
Date:   Thu, 14 Nov 2019 13:53:00 +0100 (CET)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.metu@gmail.com>
cc:     A L <mail@lechevalier.se>,
        "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: ipset bitmap:port question
In-Reply-To: <CAK6Qs9k7MD++kEHiZ+ZEunz7SyCNGeEqB3r2iZFTh_hZUQT6tQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1911141344360.7498@blackhole.kfki.hu>
References: <ba4fb013-93a0-3f63-0fd6-a4ee557893af@lechevalier.se> <CAK6Qs9k7MD++kEHiZ+ZEunz7SyCNGeEqB3r2iZFTh_hZUQT6tQ@mail.gmail.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="110363376-1783608823-1573735980=:7498"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-1783608823-1573735980=:7498
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi,

On Thu, 14 Nov 2019, =C4=B0brahim Ercan wrote:

> I'm also wondering why port numbers are not interpreted with protocol on=
=20
> bitmap:port while hash kind sets are. I'd would glad to hear from a=20
> netfilter developer.

The bitmap family is the earliest and the types kept their original=20
functionality (apart from the extensions). In the case of the hash types=20
it was easy to add the protocol number to the port while in the bitmap=20
case it'd be not so simple.

Best regards,
Jozsef

> On Thu, Nov 14, 2019 at 4:25 AM A L <mail@lechevalier.se> wrote:
> >
> > Hello,
> >
> > I'm trying to understand if ipset "bitmap:port" should support protocol
> > or not. Based on the name"bitmap:port" it should only store one value
> > per row, and not tuple like "bitmap:ip,mac" does. However the examples
> > in the manual suggests it should?
> >
> >  ...
>=20

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-1783608823-1573735980=:7498--
