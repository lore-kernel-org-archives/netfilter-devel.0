Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FD8C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 08:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240866AbiDIIcl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 04:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240843AbiDIIci (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 04:32:38 -0400
Received: from mr85p00im-hyfv06021401.me.com (mr85p00im-hyfv06021401.me.com [17.58.23.190])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E1526E1
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 01:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=darbyshire-bryant.me.uk; s=sig1; t=1649493031;
        bh=FjDCnOD835/GyGAjcRZYJ2fOecvtMMKBsLHqn7xnXgA=;
        h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
        b=JyGYIFjU3Nagte7zjDfuuvrlyMnoNJaZHZAZXaCC2oISCCbG3TDF4J12rnFEuHkJd
         qr9YHErHZ4BLI1mZJ2eSNk1ovX/Cizop8vKIFLQP8SAN0SRqWxh1AyWAgX6iLnQyyz
         FKgdXIjyYiS8P0Phnjnj2+BUrCMoacRCVXxODbbITreTzUmFR+n92uXXdPOGtvIdoo
         e8L/LXLc/zBC5+0f3EzXOqtpCu46W5g+wQ2+6xapvtBmgCAq7Vq8mkNwoh7VwT+wbn
         mZahwYSyO0PF+UVETqlZO2+PDpBw4hviIoMt395qpuZPnrifCBcdOKrLcKE7ZszVWu
         PLWRi5AMX6tSg==
Received: from smtpclient.apple (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-hyfv06021401.me.com (Postfix) with ESMTPSA id 5505C30389B7;
        Sat,  9 Apr 2022 08:30:30 +0000 (UTC)
Content-Type: multipart/signed;
        boundary="Apple-Mail=_DCC9F7F1-DD35-4632-8D28-D4A648787F74";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [nft PATCH v4 00/32] Extend values assignable to packet marks and
 payload fields
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
In-Reply-To: <20220404121410.188509-1-jeremy@azazel.net>
Date:   Sat, 9 Apr 2022 09:30:27 +0100
Cc:     Jeremy Sowden <jeremy@azazel.net>
Message-Id: <202C250A-B2C8-42E4-AC3A-C3F79C439E04@darbyshire-bryant.me.uk>
References: <20220404121410.188509-1-jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Jeremy Sowden <jeremy@azazel.net>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.425,18.0.572,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-14=5F01:2022-01-14=5F01,2020-02-14=5F11,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0
 clxscore=1030 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2204090054
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--Apple-Mail=_DCC9F7F1-DD35-4632-8D28-D4A648787F74
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On 4 Apr 2022, at 13:13, Jeremy Sowden <jeremy@azazel.net> wrote:
>=20
> This patch-set extends the types of value which can be assigned to
> packet marks and payload fields.  The original motivation for these
> changes was Kevin Darbyshire-Bryant's wish to be able to set the
> conntrack mark to a bitwise expression derived from a DSCP value:
>=20
>  =
https://lore.kernel.org/netfilter-devel/20191203160652.44396-1-ldir@darbys=
hire-bryant.me.uk/#r
>=20
> For example:
>=20
>  nft add rule t c ct mark set ip dscp lshift 26 or 0x10

And I=E2=80=99d still like to be able to do the same/similar thing :-)

Thank you Jeremy for your continued work on this, so far beyond my =
ability.

Cheers,

Kevin D-B

gpg: 012C ACB2 28C6 C53E 9775  9123 B3A2 389B 9DE2 334A


--Apple-Mail=_DCC9F7F1-DD35-4632-8D28-D4A648787F74
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEASyssijGxT6XdZEjs6I4m53iM0oFAmJRRCMACgkQs6I4m53i
M0q0aA//bmp4+YRWUgf9xQPOEfN+Svvy58Bp3dY3uR5qcASun9j0rErEkcuw1vnI
Xw5bdN++nbFHXpdav/u5d99YHMeL/MTdWzTXmgdlRJocqo7liWuwPVBeAUlco51s
DpS8KTXD3Aas5whLfbtS1q7mUPPk7KqPo2l09ppPUIFgDJKZFnOadgUd/B3DsT5S
Lpv6Vhoqpxd6uTOfA4L7pUbCJtLwat7aa9QdtiyKY6dkuBlZATa+QMcCktw4M1U1
ztiNl/5+dKd1YCR/8XRGM12SU9i0ZQAvOcno820gVqIgjQlKVkFEnAhhktuXNUrm
6mwpIvNMHXufO7LSVm2NSUtEXMSfX19wbJ5qeU+kfm6wSXLK77M7fiC08rfqploj
VnB8D9lu3ZX8sp0e8Hjw43iP6FA3dzlGVlBEaVs9jgZQQl7gB0TQoxE4D/Jqfxj2
W+4mAbpbQb7QFmmr/y7SMIhbZxSJhl/yQ1FFdwcR/6JARlcpsrqJ+GwEVfGH5dCo
/wJvP9DUJkzzpAB5jFrFxLoxhwwAaQoc+gvd8otCA9tcZEFLybc2dU0p+V8J2qMz
e5lZdaw7dQvv8wY7w1PP7adlQe5gkPqSXgf0/RiKdUhgXK+cMzafe08LFkMD/hc9
5qTEhcUNeNrLRkXHI7kKX9dHwqxgSBvZEAhGJ7ufgucZool1Ep8=
=IkhV
-----END PGP SIGNATURE-----

--Apple-Mail=_DCC9F7F1-DD35-4632-8D28-D4A648787F74--
