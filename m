Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A36C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 11:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B1C061245
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 11:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbhKFLJc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 07:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhKFLJb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 07:09:31 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936ABC061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 04:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=91dl8jIIORRHsUYB3UtHBEzlpf3/a4Qy4OoAggeGYnI=; b=n5tC1WfSATF9rleZIkbw+hoQZc
        5QTIxM+zpvgDbEwRMENGE8e+JBJeAKiKjVb5/PHq35y7i4anhQOvKX2oYvBIimlbceiPADiaNZo8/
        4ivxygd/uMjkhxJBxbiYiZefMhhrdPwFOWQjtkakQ+kGP7A7BY/WNyuZj/VfucdLXOjBN6L9OX7uQ
        4USH3bzG/605EdMNKfqOMUuj8p28vxiq8Oy0unql2I7IHg2fxG9tD2JneO7Rhbt+1pA6u4P80U8Ka
        /TT4h5GqRCEi6r0dHQCPkTzvo1if5gHF80je5MP4aWbrusLNWGdOSJqe3q5NzCg12l1czrt3sWnKU
        xjj0kHVg==;
Received: from ec2-18-200-185-153.eu-west-1.compute.amazonaws.com ([18.200.185.153] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjJX6-004g86-U0; Sat, 06 Nov 2021 11:06:49 +0000
Date:   Sat, 6 Nov 2021 11:06:44 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 08/13] build: only conditionally enter
 sub-directories containing optional code
Message-ID: <YYZhxJXmbI7CMVAY@azazel.net>
References: <20211030160141.1132819-1-jeremy@azazel.net>
 <20211030160141.1132819-9-jeremy@azazel.net>
 <q66o80p6-878q-15pr-roo7-3po7395878r0@vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eJWfJp6LED/55BeA"
Content-Disposition: inline
In-Reply-To: <q66o80p6-878q-15pr-roo7-3po7395878r0@vanv.qr>
X-SA-Exim-Connect-IP: 18.200.185.153
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--eJWfJp6LED/55BeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-10-30, at 19:15:08 +0200, Jan Engelhardt wrote:
> On Saturday 2021-10-30 18:01, Jeremy Sowden wrote:
> > diff --git a/input/Makefile.am b/input/Makefile.am
> > index 8f2e934fcdfa..668fc2b1444a 100644
> > --- a/input/Makefile.am
> > +++ b/input/Makefile.am
> > @@ -1 +1,9 @@
> > -SUBDIRS = packet flow sum
> > +if BUILD_NFCT
> > +    OPT_SUBDIR_FLOW = flow
> > +endif
> > +
> > +if BUILD_NFACCT
> > +    OPT_SUBDIR_SUM = sum
> > +endif
> > +
> > +SUBDIRS = packet $(OPT_SUBDIR_FLOW) $(OPT_SUBDIR_SUM)
>
> You use += in a previous patch, so why not use it here as well.

Just following the idiom in the documentation.

J.

--eJWfJp6LED/55BeA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmGGYcQACgkQKYasCr3x
BA2/Qw/7B/YZ+NiZyWkJjGe0BAnOMwhS9QZQEyiu6zFIcVJ64UKCwAWRcJdTjQNz
+CVNiJHK2HV6HMsDZWwo5wfQ1lhQuOyFoZXPqYEGKeG51ap3IAd1rOC0uOGdHXbL
EAHJ/pCui7OGMLCVAqgBah0X9f5yH+srL5vu8iTE1LJIL0+fEDjqTycVuFh3Ufe8
njjUatZ5uHDLC/CPUQ9GVfljyXRKwlTfk2iD4YY6Mv0asyv2qPdS7Ev5X4YQ1C5/
UzwzEyoeeA37ViwKbIf4NoxuJPQCTu0pYFG2nc1SYaN3TPeEWQndK1hd1PQ+nRgr
PuGM77AjZIvJUWww5f5Am/ZYyuTdPR8w2OpPc+lBB9bXdS4a0bmstnbTOvZ4upeu
hk9Qc0hRkArbIpVr1jjjNAXt6RLrXTZN/VkcklUYqZhyDWrMSyJVidxgj6Ex7BE7
6/T1k/RvOJ6eSHFnhLcfpwskdyeJAxjoqofgxoSTKqxcxvhd0nrDsLsxJr3FO/jf
6J0OjVw0GmeokL8SPAaKkWUU5dzdNfenjtqdefQEexSL2bG9qlzW8gvsMqdQrepj
vvEEOk6CewbaLka8ClhJ165elQsW9Qs+sMRNlDa8s17+JqOJCjnzEpgmXpLcCiR0
rBe4wTpTRyTS91WPXtH8/d2CERIiPNRXwLFa0G2la20iUuFUOZk=
=9H0Y
-----END PGP SIGNATURE-----

--eJWfJp6LED/55BeA--
