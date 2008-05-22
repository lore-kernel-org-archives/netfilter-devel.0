From: Eric Leblond <eric@inl.fr>
Subject: Re: nlif_open() - nlif_close() - memory leak?
Date: Thu, 22 May 2008 14:48:01 +0200
Message-ID: <20080522124801.GK7436@bayen.regit.org>
References: <200805221500.35587.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2nTeH+t2PBomgucg"
Cc: Netfilter Mailinglist <netfilter-devel@vger.kernel.org>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:44847 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760256AbYEVMqk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 08:46:40 -0400
Content-Disposition: inline
In-Reply-To: <200805221500.35587.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--2nTeH+t2PBomgucg
Content-Type: multipart/mixed; boundary="svZFHVx8/dhPCe52"
Content-Disposition: inline


--svZFHVx8/dhPCe52
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Thursday, 2008 May 22 at 15:00:35 +0500, Anton wrote:
>=20
> > The attached patch should fix the memory leak issue.
> > Could you test it ?
>=20
> Accordingly to "top", it's still leaking.

Yes, I should not code during conferences ;)

I attach a patch which is working for me.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--svZFHVx8/dhPCe52
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="fix_nlif_memleak.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/src/iftable.c b/src/iftable.c
index 7e6172b..01ccc8c 100644
--- a/src/iftable.c
+++ b/src/iftable.c
@@ -25,6 +25,8 @@
=20
 #define iftb_log(x, ...)
=20
+#define SIZE_IFHASH 16
+
 struct ifindex_map {
 	struct ifindex_map *next;
=20
@@ -37,7 +39,7 @@ struct ifindex_map {
 };
=20
 struct nlif_handle {
-	struct ifindex_map *ifindex_map[16];
+	struct ifindex_map *ifindex_map[SIZE_IFHASH];
 	struct rtnl_handle *rtnl_handle;
 	struct rtnl_handler ifadd_handler;
 	struct rtnl_handler ifdel_handler;
@@ -222,6 +224,7 @@ static int iftable_up(struct nlif_handle *nlif_handle, =
unsigned int index)
 struct nlif_handle *nlif_open(void)
 {
 	struct nlif_handle *h;
+	int i;
=20
 	h =3D calloc(1,  sizeof(struct nlif_handle));
 	if (h =3D=3D NULL)
@@ -255,6 +258,21 @@ err:
 	return NULL;
 }
=20
+static void free_indexmap(struct ifindex_map **indexmap)
+{
+	struct ifindex_map *ima, *imp;
+	int i;
+
+	for (i =3D 0; i < SIZE_IFHASH; i++) {
+		for (ima =3D indexmap[i]; ima !=3D NULL; ima =3D imp) {
+			if (ima) {
+				imp =3D ima->next;
+				free(ima);
+			}
+		}
+	}
+}
+
 /** Destructor of interface table
  *
  * \param nlif_handle A pointer to a ::nlif_handle created=20
@@ -267,6 +285,7 @@ void nlif_close(struct nlif_handle *h)
 	rtnl_handler_unregister(h->rtnl_handle, &h->ifadd_handler);
 	rtnl_handler_unregister(h->rtnl_handle, &h->ifdel_handler);
 	rtnl_close(h->rtnl_handle);
+	free_indexmap(h->ifindex_map);
 	free(h);
 	h =3D NULL; /* bugtrap */
 }

--svZFHVx8/dhPCe52--

--2nTeH+t2PBomgucg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFINWuBnxA7CdMWjzIRAnCfAJ9lIntmXagwILwPF+vdRxcP0g6+6wCdG2Y/
MHMukbyVqsnSURL71P0XIRc=
=f2wQ
-----END PGP SIGNATURE-----

--2nTeH+t2PBomgucg--
