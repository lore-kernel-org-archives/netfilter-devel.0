Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4B7C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Sep 2021 14:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6586A61209
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Sep 2021 14:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237745AbhIOO4q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Sep 2021 10:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbhIOO4q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Sep 2021 10:56:46 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA15C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Sep 2021 07:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QN7TAXMRrZgodQ9ZZBk+LJwN+v4uyVnazvveZG1cJ44=; b=K9IZKvphjvzYnj+uF1IA/A04OC
        adTYMKXJdTmF0fnp7zRBgRmuFzKoiceuGXfCMlqd12GE7a0Lnfpo/GC5nZTwUTC+Txha0HSrOgMJ7
        1Lq8ToVher4BCNQplOeFFGsSa7I/+CTsMueR1KftEXj1hqQntFMuCHTCoAJi+ipc5sB120gHeMBKh
        K8qSO5AaL6eF1e2is5HHyepJOMSg9ZylL4Imv4nlMlAKmfbMWIUeZwYS5aE0gxEjhbLVsDd0LWlYv
        B5YrE3HJOvx7U3u2WHl0SmxAzp0PVrurtwbF5LJitTIamKkYbbim81PYLOErNytu+Sltg4DpUp0MT
        oCv5CLnQ==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mQWJp-001CvA-08; Wed, 15 Sep 2021 15:55:25 +0100
Date:   Wed, 15 Sep 2021 15:55:23 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     kaskada@email.cz
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Jan Engelhardt <jengelh@inai.de>
Subject: Re: [xtables-addons] xt_ipp2p: add ipv6 module alias
Message-ID: <YUIJW3DPDsmmjYPA@azazel.net>
References: <20210914140934.190397-1-jeremy@azazel.net>
 <33D.aVMp.3L4gqjighB0.1XGFsS@seznam.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vagtVBA0kGpdbQ1S"
Content-Disposition: inline
In-Reply-To: <33D.aVMp.3L4gqjighB0.1XGFsS@seznam.cz>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--vagtVBA0kGpdbQ1S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-09-14, at 21:53:00 +0200, kaskada@email.cz wrote:
> Thank you for your new patch. I re-downloaded new xtables sources from
> git and run these commands as usual: (I did check that your latest
> patch is really in the downloaded sources - and it is)

> ./autogen.sh
> ./configure
> make
> make install
> depmod -a
>
> But this command:
> $ ip6tables -t mangle -A PREROUTING -m ipp2p --dc -j ACCEPT
> ip6tables v1.8.4 (legacy): Couldn't load match `ipp2p':No such file or
> directory
> Try `ip6tables -h' or 'ip6tables --help' for more information.
>
> ... is still complaining for something, I`m sorry.

I've just built, installed and tested the latest source in a clean
Buster VM and everything worked as expected.  Therefore, I suspect you
needed to `modprobe -r xt_ipp2p` first.

J.

--vagtVBA0kGpdbQ1S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmFCCVQACgkQKYasCr3x
BA0XMBAAsZPOi6oImthgH8N+9pW42JOop3em1zE/Nd2cbEnTqSZJR6apecOVTIUk
KhdzsEDQF8XZEvjF1besn+7LxcK1w+/pPJxG12LK2bLZwhWB0R6KFL5/GfXU8tnI
VPNtHh714j8eCSENIdSunY2nXyaFW+fbTwBLUTpdDRmf/Ti8Fw7okhH1pYtc0J6b
w65FWyXLfoMv3xD7UAC8e3iMb5vjNwYreLot9+00fOfCRWnmwLHjyhgp9VFGpUal
06SVFQhIKKd+zQGrdDvuTWpgOdXMgK6t+Sc+QwVIVfS3D0kvUQ3IO4oeEC8FBKoi
rBrZVouHNmIXI6CwB6yb2Z1F8txcmPFm6PkyVb143kbtenDFM3riqSHyzuVG14ji
HaO2uOIVMJ448vpz9x6I7bfrOkq6huDRQYDk7BtRG/v3331/+K7W+KTpe97hchs2
8jUfHWlZIH0rIWDMNztv4q81MHppjBDY6aW0vWKsXDxLGnbZyqZbV/4DcYTsNDeY
/2tfL4ZtmpJVQArZGiZbQaaciB86k8b6UMr/EnsvKLKBwsk9c5MRcswSB0rQXAo5
yplVj5JpKyU6rpW3vuGPSpKV4iH7CFGYQKSLTu3IutVopm605En85Xg+BVABDmbk
LKEHlksZeq/CZ/+0XuUv+2U4OFqhpm4TyVzNlScg25+ys8SL0gA=
=j8Zd
-----END PGP SIGNATURE-----

--vagtVBA0kGpdbQ1S--
