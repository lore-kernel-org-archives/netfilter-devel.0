Return-Path: <SRS0=S009=3H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A38C33CB1
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 11:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAE9A24690
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 11:21:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="qoBE0IZR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgARLVh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 Jan 2020 06:21:37 -0500
Received: from mx1.riseup.net ([198.252.153.129]:44076 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727068AbgARLVh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Jan 2020 06:21:37 -0500
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 480Fqf14pfzFdXZ;
        Sat, 18 Jan 2020 03:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1579346496; bh=QJEPdK/YGcCfMbPE9IMD5dGTX50/fYxJzN9rjYnYwEU=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=qoBE0IZRM4WsV3VmjjYojC+CmZamMuh+jheTBC1QSuAnJrHKxLw1WJ4htryS2i9Wc
         1GpnzdoMBsFm6eukIS+UHzVkYYzbOYEkzFxE5JUcYNsYxK50gtNCsNSzIIN3AIQWBC
         mhTIUPFltfmDTzmRdpVvsm+imryBw//8JVWZY52s=
X-Riseup-User-ID: 5049827D8377340B9CA21926B3C15D3EEBCDE3A21467627784C82250557A7ED0
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 480Fqd1VR3z8w8Q;
        Sat, 18 Jan 2020 03:21:17 -0800 (PST)
Date:   Sat, 18 Jan 2020 12:21:06 +0100
In-Reply-To: <20200118102725.30600-1-fw@strlen.de>
References: <000000000000d740e5059c65cbd0@google.com> <20200118102725.30600-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH nf] netfilter: nft_osf: add missing check for DREG attribute
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
CC:     syzkaller-bugs@googlegroups.com,
        syzbot+cf23983d697c26c34f60@syzkaller.appspotmail.com
From:   =?ISO-8859-1?Q?Fernando_Fern=E1ndez_Mancera?= 
        <ffmancera@riseup.net>
Message-ID: <284AF1FF-D477-4CD2-B5BE-15FD40B103E1@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

El 18 de enero de 2020 11:27:25 CET, Florian Westphal <fw@strlen=2Ede> escr=
ibi=C3=B3:
>syzbot reports just another NULL deref crash because of missing test
>for presence of the attribute=2E
>
>Reported-by: syzbot+cf23983d697c26c34f60@syzkaller=2Eappspotmail=2Ecom
>Fixes:  b96af92d6eaf9fadd ("netfilter: nf_tables: implement Passive OS
>fingerprint module in nft_osf")
>Signed-off-by: Florian Westphal <fw@strlen=2Ede>
>---
> net/netfilter/nft_osf=2Ec | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/net/netfilter/nft_osf=2Ec b/net/netfilter/nft_osf=2Ec
>index f54d6ae15bb1=2E=2Eb42247aa48a9 100644
>--- a/net/netfilter/nft_osf=2Ec
>+++ b/net/netfilter/nft_osf=2Ec
>@@ -61,6 +61,9 @@ static int nft_osf_init(const struct nft_ctx *ctx,
> 	int err;
> 	u8 ttl;
>=20
>+	if (!tb[NFTA_OSF_DREG])
>+		return -EINVAL;
>+
> 	if (tb[NFTA_OSF_TTL]) {
> 		ttl =3D nla_get_u8(tb[NFTA_OSF_TTL]);
> 		if (ttl > 2)

Oops=2E Sorry about that=2E Thanks Florian!
