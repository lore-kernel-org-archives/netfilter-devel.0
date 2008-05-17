From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD 1/4] rework NFCT to use a generic hashtable [was Re:
	[ULOGD   1/4]  improve netlink overrun handling of NFCT]
Date: Sun, 18 May 2008 01:40:42 +0200
Message-ID: <20080517234042.GA14902@bayen.regit.org>
References: <482C3E63.80006@netfilter.org> <482C3F36.4050907@netfilter.org> <20080515202458.GA22245@bayen.regit.org> <482D6776.8000502@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:56762 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807AbYEQXkF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 May 2008 19:40:05 -0400
Content-Disposition: inline
In-Reply-To: <482D6776.8000502@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Bn2rw/3z4jIqBvZU
Content-Type: multipart/mixed; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Friday, 2008 May 16 at 12:52:38 +0200, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > Hello,
> >=20
> > On Thursday, 2008 May 15 at 15:48:38 +0200, Pablo Neira Ayuso wrote:
>=20
> Missing chunks. Sorry. Attached a new patch.

Ok, that's better but the latest subversion^W git version of
libnetfilter_conntrack is needed to compile.

I've got some remaark regarding the patch:

>  struct ct_timestamp {
> -	struct llist_head list;
>  	struct timeval time[__TIME_MAX];
> -	int id;
> -};

Why do we get completly get rid of the ID ? It will be available in the
upcoming kernel version and it will be more efficient to use it if the
kernel has support for it.

> -	if (type =3D=3D NFCT_MSG_NEW) {
> -		if (usehash_ce(upi->config_kset).u.value !=3D 0) {
> -			ct_hash_add(cpi->ct_active, nfct_get_attr_u32(ct, ATTR_ID));
> -			return 0;
> +	if (usehash_ce(upi->config_kset).u.value =3D=3D 0)
> +		return NFCT_CB_CONTINUE;

This one is really rude ! it is equivalent to no logging at all if we
don't use the hash system.

I've encounter an other problem which is that hash.c is not compiled
because it has not been included in a Makefile.am (at least it is not in
the patch).

I will send soon a rework of my patch about timestamp issue with a modifica=
tion
of this behaviour (in testing phase for now).

I attach the makefile.am modification to the mail.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--sm4nu43k4a2Rpi4c
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0005-Add-forgotten-file-hash.c.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 652727c21c498d6a3746a849497fc439ce64ab1a Mon Sep 17 00:00:00 2001
=46rom: Eric Leblond <eric@inl.fr>
Date: Sun, 18 May 2008 01:19:10 +0200
Subject: [PATCH] Add forgotten file hash.c.

This patch adds hash.c to src/Makefile.am.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/Makefile.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 67f404e..360701f 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -5,5 +5,5 @@ AM_CPPFLAGS =3D $(all_includes) -I$(top_srcdir)/include \
=20
 sbin_PROGRAMS =3D ulogd
=20
-ulogd_SOURCES =3D ulogd.c select.c timer.c rbtree.c conffile.c
+ulogd_SOURCES =3D ulogd.c select.c timer.c rbtree.c hash.c conffile.c
 ulogd_LDFLAGS =3D -export-dynamic
--=20
1.5.4.3


--sm4nu43k4a2Rpi4c--

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIL2z6nxA7CdMWjzIRAoC2AJ96HrcLeFiZeJA5O+nYusgtpYVrzQCfYLNn
Kxpyvyar9Ai2hIsDmUTbhgo=
=bUsU
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
