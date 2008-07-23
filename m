From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 0/4] Hardware header parsing in NFLOG and ULOG
Date: Wed, 23 Jul 2008 23:31:10 +0200
Message-ID: <20080723213110.GG31572@bayen.regit.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cQXOx3fnlpmgJsTP"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks301150.kimsufi.com ([91.121.73.151]:57628 "EHLO
	ks301150.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbYGWVbO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:31:14 -0400
Received: from bayen.regit.org ([81.57.69.189])
	by ks301150.kimsufi.com with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <eric@inl.fr>)
	id 1KLlvU-0006c1-Qu
	for netfilter-devel@vger.kernel.org; Wed, 23 Jul 2008 23:31:13 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--cQXOx3fnlpmgJsTP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

This patchset is aiming at:
 * solving the conflict between ULOG and NFLOG=20
 * using the latest NFLOG capability relatively to hardware header

First patch modifies the NFLOG plugin to add raw.mac and raw.type (hardware
type) to output keys.
Second patch introduces a new plugin which has to be used to parse the
packet hardware header and extract source and destination hardware
address.
Third patch updates the MAC2STR plugin to convert to string the hardware
related fields.
Finally, last patch adds support for this new fields in mysql and pgsql.

Patchset statistics:
 configure.in                      |    4 +-
 doc/mysql-ulogd2.sql              |   68 +++++++++---
 doc/pgsql-ulogd2.sql              |   49 ++++++++-
 filter/Makefile.am                |    6 +-
 filter/ulogd_filter_MAC2STR.c     |   92 +++++++++++++----
 filter/ulogd_filter_RAWMAC.c      |  214
 +++++++++++++++++++++++++++++++++++++
 input/packet/ulogd_inppkt_NFLOG.c |   43 +++++++-
 7 files changed, 427 insertions(+), 49 deletions(-)

PS: I run git-send-email without --compose and send the patchset before
the introduction mail. Sorry for that.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--cQXOx3fnlpmgJsTP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIh6MenxA7CdMWjzIRApQ9AJ9//MqDHRIkdgsgOgAEH1l1YlJNtACeNXcQ
oOKgpceOxOYBj5Zh20DMxK0=
=s0Rj
-----END PGP SIGNATURE-----

--cQXOx3fnlpmgJsTP--
