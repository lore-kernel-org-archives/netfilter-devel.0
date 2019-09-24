Return-Path: <SRS0=Dg9R=XT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F643C432C2
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 12:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51B522146E
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 12:11:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="XrZkKR+Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504890AbfIXMLd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Sep 2019 08:11:33 -0400
Received: from kadath.azazel.net ([81.187.231.250]:39542 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387414AbfIXMLc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Sep 2019 08:11:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cPKuLRvt92qEwZH0XWo71YgX9gr3ltnW9OBLc0ZSW8E=; b=XrZkKR+YhhHAQCb5/SB5c1XIOf
        DZss8aD4gGlIwqn+6B4XlEKWgFlXC7Bogvy3Kyhzfj9+W/U/oeV2QH/Vv3TeeArflJRrsXCxzgxWw
        Mhs+sae/8T02/kHB+hkLd+CG7JGiPpM0YqH4MLvNRWj27WVrwp53PA1bhY0rw2/UajH2oDVw4YcQc
        kuRV271ZaR791pnBFcALClUs+O8CX7fxHH6wCp7eFQkbqe34Fue8wrKlBlfR1+PftIZQGVFOAkekX
        DRrdCGEWMtM4GET6UOSWD6yfJqCi0DiznVvrp0kJdWOKT/QokajV7LTrO/osUY1QMnfXgh7IoOaDh
        gViBMtlA==;
Received: from pnakotus.dreamlands ([192.168.96.5] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iCjfF-0007ZH-Hq; Tue, 24 Sep 2019 13:11:29 +0100
Date:   Tue, 24 Sep 2019 13:11:29 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] src: Enable clang build
Message-ID: <20190924121129.GA32094@azazel.net>
References: <20190922001031.30848-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <20190922001031.30848-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.5
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-09-22, at 10:10:31 +1000, Duncan Roe wrote:
> Unlike gcc, clang insists to have EXPORT_SYMBOL(x) come before the definition
> of x. So move all EXPORT_SYMBOL lines to just after the last #include line.
>
> pktbuff.c was missing its associated header, so correct that as well.
>
> gcc & clang produce different warnings. gcc warns that nfq_set_verdict_mark is
> deprecated while clang warns of invalid conversion specifier 'Z' at
> src/extra/ipv6.c:138 (should that be lower-case?)

It should, yes.

J.

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl2KB+QACgkQ0Z7UzfnX
9sP7NRAAvF1jlIzi2DYvrg+qxQiqHmuJFIX4w4+vpDQQdDG22AkN0r9/37YPeYXf
MaL/qrjdhDAti2kn6a5NJ7HBiwjKi7AhXuR2Iv91sACkSbK2H2UbBbReYJn0GxMq
mCCynXaSFOBCkFSEC5TVH/ExlK0CXYGYWXBsvyuJsaW7C78yqUNwvQvlGODUY6wb
2FPjcYftO1XFO02go2X7ieG44GW8750iIF1O//0PmpSNaOEI94msD7MwKFon8I7Y
0iV/vUcIceA4T4P2wscabcPW5NtkkspLPKGPcfngpaah22D9sejGol3cQW3HC+v6
tHbf5sfxpKp1xXyhSztYRz8bs3RseR4ZuxVZybVGNthNQuWGvDe/VjVMJolc0yla
uVMDX/CKwb6ZEu6zmjwtBIi0lq5LBpv5kvOxtudz3f1GfnO0t7j1f8SW7AICwAYa
nCxMk7dQTODerolBAz9aCt0A+4dqnme1BGkGHle8grFaRmcpLH6d78ViEuFOCW+N
nZ1xUh0o1pGGM1jPqDf4PII031XqvAhIqUMlWWipRz5k6N4yBuqfh61xXRa9DKrt
G56HQqMxS9eFjIOxh10R6KHjWOuainpjlb39vMZa3Pxn7e1pLIf6lwRYG+xg4gHx
C3OAWupnerJIj4ymgo2RTE8gbKv6uhScColRc0DfvaaZE3WlPKY=
=abUk
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
