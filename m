Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B174DC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Apr 2022 14:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237876AbiDEOJu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Apr 2022 10:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384327AbiDEM1V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Apr 2022 08:27:21 -0400
Received: from mout.web.de (mout.web.de [212.227.15.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3ECB5
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Apr 2022 04:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1649158903;
        bh=zz2GIJLzNB8AeIbGTf7vj/0QeNrDEZ/169SMyAAkqCg=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=SzCdavVSFdEIqgjpclR57by4Djish/05EclqukId3WYOYq3EJqYdPSZrI7n9MjepR
         2iHbV/NovPAvKlzU5I3KhuW8dgksjYXt7UDLk8oAFBYIa1AQVKxlFIQNPI2dvhdWpy
         0NfYisfEbwgW90tRsix7D9XDTzzLO41cLNakYY68=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko ([46.223.151.228]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MElZP-1nnUzc2hEx-00GPjv; Tue, 05
 Apr 2022 13:41:43 +0200
Date:   Tue, 5 Apr 2022 11:41:15 +0000
From:   Lukas Straub <lukasstraub2@web.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: meta time broken
Message-ID: <20220405114115.33c7d5d0@gecko>
In-Reply-To: <20220405111645.GB12048@breakpoint.cc>
References: <20220405011705.1257ac40@gecko>
        <20220405013128.0bb907e2@gecko>
        <20220405111645.GB12048@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/jkeGQqMCqI+YB/T4_q2ahH6";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Provags-ID: V03:K1:Gd4gTP8EAv6Q1/sc27SsXpY8kurB5jIEwNdYMRFEFulciHpnDEX
 brotbCfLEbP9cYKPImr8KW172GI6NOqQzpKk33lsd0MBx3zryC9vbaH1tLjt1/aC4CwpJcH
 yXCFt2DxUZnju95tBHYm69yNZKVesB64+g98ZhoH/MNIAdIaRMWpn1qqOqhhMfy6hw1KGhV
 e9gac4T2vMat+PSQGaIhg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:O6QkJ/EKksI=:PCDkCmkT9cZKsTjdck0zfn
 iP+e4nDunb6U73gaY88AM2wajTkM4N20SSTk02LR2Pyl2O2mEUMhOML/6Sptu2X4FLZHU1iZ3
 v/raxHcUXz39xwbgUfMoaAp0OtlKM3d4JZr/5EGrWN509Xt+2FsZTslBp8qJqndJOw3P0QnOA
 JCqyhMyFxMMqM0mfT3ph3vahLUfJPtGOjuQc6fuVZcF99BuvQm+NZBBT5W8RiR8qkw03BULDk
 MKOApoImo/PDStfx5ung95Q71FrulSSUR1RKAwjtS9/4Bz0j80fK2AC/H2doEU7iYcASkePBY
 S44hf6d1Ps8K/l3LlTVdqYCRZ7p4b6vGt1T33SlWUcECIN5GqvLLIq4Sc6++fWkCC5/BBzFzv
 eo7DzqSHhNLFbIFj5TnG6Qk2YhoiwzPppwq6WVjCdiIwZjrRPcRpxxYbYxr7zPWTDjQqXBlme
 xBxe8afA0w/O1zmfbGzUJtY0DQeQt4bO4xBhZPladJ0qt26rOMHVtZmrKlRQcr+g0BbjCLYSJ
 JVKBW/itk15G+RUGf68Ch0S+xwknkzlXmtRYSJWozF1/JSzk6xbfKPK3W0eqVwZNEJFn4PWis
 snibbZPvVYAxBbgJmiKTJrloSYe6OB4h+AEp7mi1Hx1+XVhSM+WMnb0VIsdnrEyYXff5uoSV5
 4FKmhNuqW2EMIIL90i7HPIrhEc7eOYHYYTMZzVrmH/xb1V0+jpvy0U/d5Yy4m5CbSUw4XLQgt
 z6eN7bhNMMLJgBAmWgVsy9gRCu/TM/3myVwIAbJZfpqOrsR+nrWlWMtKG1ChR5zL0lmj5KzGK
 u7QvxboHNoHnMAHfbERgSqDzTvv5BDnQ160X4i3PB+JVFVgq+XfI8029Mc5bi8PGHzWofJH2h
 kukMUAhxPyEiepL4Fs4IDqB+XrWakbH1dOjxvVhI/pFb7VXIFiF3tyR0T2hHghmY6mLOvCKmR
 XyCz8YB4hQktKi2SqPiuxEvjvmd8xI+jB4qocdt9ii08Wzoym15fOfzDzVKC8LutcYvT4pWFi
 qjhJadS0wHeXOjoQqXwv4tHty6Og4b6VLLK5w7NZfzRuCczh1wOFhzCmxWzdWRpSDs2XYuLqE
 DLOuKlywmoAStY=
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/jkeGQqMCqI+YB/T4_q2ahH6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Apr 2022 13:16:45 +0200
Florian Westphal <fw@strlen.de> wrote:

> Lukas Straub <lukasstraub2@web.de> wrote:
> > Hmm, after staring at the code for a bit. I could imagine it's due to
> > time_t being 32 bit on my platform and nftables trying to stuff a unix
> > timstamp with nanosecond resolution in it... =20
>=20
> Will you send a patch?

Yes, I already sent one. The mailing list seems to be a bit flacky, did
you get it?

Regards,
Lukas Straub

--=20


--Sig_/jkeGQqMCqI+YB/T4_q2ahH6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmJMKtsACgkQNasLKJxd
sljktRAAs/T5PQS/QR6X3OW78kglxuwTX9b3nirM6C/9aHlIrpJ0spDL/Upe8g2Y
c8QzRJaXQmv5Ilq/b9hzFG1lwOPoLuNAoTS2rS84qrGK16zcIPVaX3FytSDnWqKP
e7rzmVJ/6trEgwRNcyzJSaap3rJpF/TpTkpHkMR5sFRHxfdBJ4t+0rsCVB41uSeK
IcVBe95DR64LjWyomkpzX0tL0ZVomY174lwqEWABHAV91o6cBB80nGS8TrgNrMby
9f0FZVUwp+QT8waSpgbJEm6UMpKIfyJ1V5AMjVHnthF7ZHLXVmvTnpab8prYLBi7
LPwBWCSDuzXZho2JXfEeCqNjBRNKxMpicEclBf2DpiCxlUavq96M15+8YzGzfjSF
Nh9ZpZWQc+mOZJzcnFYtUL2NZJy5/z/4oXnE7zCFNloI1yIrSnsAS1tWrVwnFbCF
6xq95HhLOIb5yvd//pE0IIqWrFPCd2c6aHin1BsM+TiDRzJeKd/qgn/tH3AlxjYs
wHAnZmZan/r45bzlbjf4YmSd3zK9/4AZ7lgN8rx30FRJtg6fLHscWpj0h8/PlvLg
dl6/8lbFns7NfoD07Mfzx89QCnGGZ2oEABiQ5g5R2rIyitnnBAXsuU6AimWKCJMV
b/eOvYvu59fP3Vj+la0wuCoeF4l4XeT5HTql0RJS7kBLJKYlI4w=
=znox
-----END PGP SIGNATURE-----

--Sig_/jkeGQqMCqI+YB/T4_q2ahH6--
