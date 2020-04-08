Return-Path: <SRS0=8NPN=5Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A27C2BA2B
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Apr 2020 21:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33CAF2078E
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Apr 2020 21:40:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="KWZsyp6k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbgDHVkZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Apr 2020 17:40:25 -0400
Received: from smtp-out.kfki.hu ([148.6.0.45]:48387 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbgDHVkZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Apr 2020 17:40:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 949406740138;
        Wed,  8 Apr 2020 23:40:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1586382021; x=1588196422; bh=8Ssdd1kWIE
        umBsCQYxdHOk0t8aIvKF8CZ1Qu7i5ww2Q=; b=KWZsyp6k5RlxHBWolGyb2E5bOO
        etyGy3Hff42suV/LI535XAQwCd7bsl3drBF9K6VhweR5nBhXgXfsc+T1X1a9xegc
        pfMhPbhH0u7qMW18i2db2HBJw8IL7uM25++sGfzvFA9d5G5xUU270KaHT/KBWHwt
        11Adxc+PaGyyKbKQI=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed,  8 Apr 2020 23:40:21 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 38C80674012C;
        Wed,  8 Apr 2020 23:40:21 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id EE4ED2097A; Wed,  8 Apr 2020 23:40:20 +0200 (CEST)
Date:   Wed, 8 Apr 2020 23:40:20 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Stefano Brivio <sbrivio@redhat.com>
cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Mithil Mhatre <mmhatre@redhat.com>
Subject: Re: [PATCH] ipset: Update byte and packet counters regardless of
 whether they match
In-Reply-To: <20200408222011.2ba3028b@redhat.com>
Message-ID: <alpine.DEB.2.21.2004082333570.23414@blackhole.kfki.hu>
References: <20200225094043.5a78337e@redhat.com>        <alpine.DEB.2.20.2002250954060.26348@blackhole.kfki.hu>        <20200225132235.5204639d@redhat.com>        <alpine.DEB.2.20.2002252113111.29920@blackhole.kfki.hu>        <20200225215322.6fb5ecb0@redhat.com>
        <alpine.DEB.2.20.2002272112360.11901@blackhole.kfki.hu>        <20200228124039.00e5a343@redhat.com>        <alpine.DEB.2.20.2003031020330.3731@blackhole.kfki.hu>        <20200303231646.472e982e@elisabeth>        <alpine.DEB.2.20.2003091059110.6217@blackhole.kfki.hu>
        <20200408160937.GI14051@orbyte.nwl.cc>        <alpine.DEB.2.21.2004082147410.23414@blackhole.kfki.hu> <20200408222011.2ba3028b@redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-598595041-1586382020=:23414"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-598595041-1586382020=:23414
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi Stefano,

On Wed, 8 Apr 2020, Stefano Brivio wrote:

> On Wed, 8 Apr 2020 21:59:11 +0200 (CEST)
> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
>=20
> > The patch in the ipset git tree makes possible to choose :-)
>=20
> J=C3=B3zsef, by the way, let me know what you want to do with the=20
> iptables-extensions man patches I sent. I'm assuming you'd take care of=
=20
> merging them or re-posting them "at the right time". :)

It's not forgotten, I'm waiting for a patch which also extends the set=20
match and I'd better avoid two new revisions. This is the reason I haven't=
=20
sent yet the patch in the ipset git tree to Pablo.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-598595041-1586382020=:23414--
