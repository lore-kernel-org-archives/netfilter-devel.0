Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE92C433DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Feb 2021 08:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A60664E05
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Feb 2021 08:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbhBWIeu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Feb 2021 03:34:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhBWIeu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Feb 2021 03:34:50 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD8AC061574
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Feb 2021 00:34:09 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id 205C93C80171;
        Tue, 23 Feb 2021 09:34:08 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 23 Feb 2021 09:34:05 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp1.kfki.hu (Postfix) with ESMTP id DB6D53C8016F;
        Tue, 23 Feb 2021 09:34:05 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id C8824340D5D; Tue, 23 Feb 2021 09:34:05 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id C728C340D5C;
        Tue, 23 Feb 2021 09:34:05 +0100 (CET)
Date:   Tue, 23 Feb 2021 09:34:05 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: increasing ip_list_tot in net/netfilter/xt_recent.c for a
 non-modular kernel
In-Reply-To: <4ee34303-8954-108d-5fdb-28c47033a2b5@gmx.de>
Message-ID: <9dbca26a-4dad-a9b5-d389-8493b44c3331@netfilter.org>
References: <df5eb9af-568a-ef0e-bc4f-33b0fbe1307f@gmx.de> <2981762-4fc1-38be-d658-31413e36e4cd@netfilter.org> <4ee34303-8954-108d-5fdb-28c47033a2b5@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-439905531-1614069245=:362"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-439905531-1614069245=:362
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Feb 2021, Toralf F=C3=B6rster wrote:

> > > I'm curious if there's a better solution than local patching like:
> >=20
> > See "modinfo xt_recent": you can tune it via a module parameter.
>=20
> It is a non-modular kernel.

Then you can specify it as a kernel boot parameter:=20
xt_recent.ip_list_tot=3DN

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-439905531-1614069245=:362--
