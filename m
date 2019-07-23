Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CABA5C76186
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 20:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DB5D21841
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 20:18:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="GOFeV1mX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730924AbfGWUSr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 16:18:47 -0400
Received: from mx1.riseup.net ([198.252.153.129]:32900 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728389AbfGWUSr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 16:18:47 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 6F0A41A4724;
        Tue, 23 Jul 2019 13:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563913126; bh=3AnuxXIrMSFawN2XgcPmFAmAuPsQ5dAipyqh1/UuvZk=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=GOFeV1mXEKxqTE6g+zdiaY6jswfK5VcdrUbpzEhOnxWAuYNvfZ9iDDimHxcFjeWKr
         poBvlYPk8Lww8cFpmieFCcX6Z4QYVG2v1nWDwaxt6cgB+w1J7x5KH73jvVsrCnRNxv
         q8vttDzpRpqLcYNuFWXq92WraHgQspA0YxVTAb2s=
X-Riseup-User-ID: BFEAAF73AC053E8557356F7A1893DEF24334AD2509C89484B862384AFAE004C1
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 9D6412229DD;
        Tue, 23 Jul 2019 13:18:45 -0700 (PDT)
Date:   Tue, 23 Jul 2019 22:18:38 +0200
In-Reply-To: <20190723192643.fgebvf5wdbs4zzvx@salvia>
References: <20190721192415.12204-1-ffmancera@riseup.net> <20190723192643.fgebvf5wdbs4zzvx@salvia>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH iptables] nfnl_osf: fix snprintf -Wformat-truncation warning
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     netfilter-devel@vger.kernel.org
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Message-ID: <E13539DD-460E-4F48-AB6F-FEBCB6CC30E7@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

El 23 de julio de 2019 21:26:43 CEST, Pablo Neira Ayuso <pablo@netfilter=2E=
org> escribi=C3=B3:
>On Sun, Jul 21, 2019 at 09:24:15PM +0200, Fernando Fernandez Mancera
>wrote:
>> Fedora 30 uses very recent gcc (version 9=2E1=2E1 20190503 (Red Hat
>9=2E1=2E1-1)),
>> osf produces following warnings:
>>=20
>> -Wformat-truncation warning have been introduced in the version 7=2E1
>of gcc=2E
>> Also, remove a unneeded address check of "tmp + 1" in
>nf_osf_strchr()=2E
>
>nfnl_osf=2Ec: In function =E2=80=98osf_load_line=E2=80=99:
>nfnl_osf=2Ec:372:14: error: =E2=80=98subtype=E2=80=99 undeclared (first u=
se in this
>function)
>  372 |   i =3D sizeof(subtype);
>      |              ^~~~~~~
>
>Hitting this here after this patch=2E

I am sorry, this is a typo=2E It should be "f=2Esubtype"=2E I am going to =
send a v2=2E Sorry for the inconveniences=2E
