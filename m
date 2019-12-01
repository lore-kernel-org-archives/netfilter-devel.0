Return-Path: <SRS0=J9ih=ZX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2ADDC432C0
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Dec 2019 14:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4570820748
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Dec 2019 14:00:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Q+8DWOGy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfLAOAl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Dec 2019 09:00:41 -0500
Received: from kadath.azazel.net ([81.187.231.250]:41702 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbfLAOAl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Dec 2019 09:00:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tc9ZLS6vKNiSTwiwLcXEmDNxGjmNCsOsXnfWqs7oHkM=; b=Q+8DWOGyIBkznqqSlP9SnCFORv
        wHJr4NjuQkT+WaKzuft5I7O1e4ltLrvCmghCzoOlZ0mD5FZLSCaYl8AzD/aq+ab7PdZiEaTIF8Y3d
        Oo509pftKDxFXtc4bp5xUYYesXarQwG2hmg2u9jZ6Dov73XV31bPfe0M51CK+nx/KS9g7M5u7CuLI
        cXjLOafB6XwoN+iUGTLRRDKzzWdMj3agNUacImB1tGDj0yP/Rg29qhvSrrOIju5brw88QRBK/WG7n
        suq5PvZi9Q/pWTrEcmwrLmTLNp4SW7PbjVbV1F1yUQ5x2wWVWlsR/wWD2Jjbww6u2eqkKiRNAIx7x
        rdd/HNMg==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ibPm9-0003fw-MD; Sun, 01 Dec 2019 14:00:37 +0000
Date:   Sun, 1 Dec 2019 14:00:45 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        "Thomas B . Clark" <kernel@clark.bz>
Subject: Re: [PATCH xtables-addons v2 0/3] xt_geoip: ipv6 fixes
Message-ID: <20191201140045.GD133447@azazel.net>
References: <3971b408-51e6-d90e-f291-7a43e46e84c1@ferree-clark.org>
 <20191130175845.369240-1-jeremy@azazel.net>
 <nycvar.YFH.7.76.1912011134260.10057@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="BRE3mIcgqKzpedwo"
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1912011134260.10057@n3.vanv.qr>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--BRE3mIcgqKzpedwo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-12-01, at 11:34:50 +0100, Jan Engelhardt wrote:
> On Saturday 2019-11-30 18:58, Jeremy Sowden wrote:
> > Thomas Clark reported that geoip matching didn't work for ipv6.  This
> > series fixes that and a couple of other minor issues.
>
> Applied 1, 3, with little fixes/additions to the messages.

Thanks.

J.

--BRE3mIcgqKzpedwo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl3jx34ACgkQ0Z7UzfnX
9sPEvg//c0lEC0XjQI+mX/q7FpkH4oLSgCgrBTF3uJqWsKpdPSo+RYO8upDlrMZk
4HA0CanbSkiOjm+k+FXXBh44KO6/d3mxJOxQvGZ7KEX33WSAKt+dF/3BlD+NwP7S
LpJFO/RThCs2IM+zeeyhY68Gcs2Q/KVYyYNx0oSbCSdsxxdJNckJSwgMZdqMxwmx
oufrrM5YxSRYSMUKZuST04pSLjLSkRAJaxYwFYLzdVKBCJWFhdxFJWFPjttr3lM4
59/ZZfsAPg6wwvxyApXXEnF7nsGHekFWsj+tDGNAujii5rlbyj/+SCWuo4jCHI97
Ylal3Oh+b7myx3A3fyFTYd7HXm+R4q4n/awyMFuL1VkSZXgeTnTQBmqqy1F6gQTb
XKs1AwnKb0SF+NCzDl3gfEMwy9iPlmDATntpooGx/ZvseLQ4I7Fa/nKSodMoIaSJ
L8m/F+tD4xWMyG8u8gDOTF68/JmijEeFfn/gHJiX53wTR2IsHM/ukOtR+EoOywVZ
lkifOM7poSmNMxYEkkwhiW1eriwQzW7Azy71stUaWhCXYdD1Q9sHhsUqwaYhYZpo
UD6mCbmJQ5F+QPkdRshGQODKVkrt8ozj4LxnSdC4bQjVh9fB1Uvtp24LpC5PppzU
UnwstwKeRsF4XPtka9v9dlOYCkChxFNbdaNv6ZCL433QUl40bEk=
=/Bou
-----END PGP SIGNATURE-----

--BRE3mIcgqKzpedwo--
