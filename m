From: Lennart Poettering <mz6e657466696c746572@itaparica.org>
Subject: fix for ipt_TCPMSS
Date: Sun, 6 Oct 2002 13:53:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021006115312.GA1936@whiskey.dummy.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RIYY1s2vRbPFwWeW"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--RIYY1s2vRbPFwWeW
Content-Type: multipart/mixed; boundary="5I6of5zJg18YgZEa"
Content-Disposition: inline


--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

While looking at the source code of the TCPMSS target I noticed a
simple error: the target makes an expanded copy of the skb if
needed. However, this copy is no longer owned by the original "struct
sock". The attached patch fixes this.

If the skb is copied without this fix the kernel will oops short time
after, when some code tries to access the attached "struct sock", which is
NULL.

The code of TCPMSS isn't perfect anyway since the skb is copied twice
under certain circumstances. This is not needed.

Nobody ever triggered this error, as it seems. Nonetheless, it is an
error.

(At least I think so. I am new to kernel hacking, so it might be I
missed something. However, I tried my very best.)

The patch is against the netfilter sources of 2.4.19.=20

lp

--=20
name { Lennart Poettering } mail { lennart@poettering.de }
icq { 11060553 } www { http://www.poettering.de/lennart/ }
loc { hamburg, germany } pgp { 0x1A015CC4 } hack { .phi. }

--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="tcpmss.patch"
Content-Transfer-Encoding: quoted-printable

--- ipt_TCPMSS.c.dist	Sun Oct  6 13:41:08 2002
+++ ipt_TCPMSS.c	Sun Oct  6 13:42:49 2002
@@ -143,6 +143,9 @@
 			return NF_DROP;
 		}
=20
+        if ((*pskb)->sk)
+            skb_set_owner(newskb, (*pskb)->sk);
+       =20
 		kfree_skb(*pskb);
 		*pskb =3D newskb;
 		iph =3D (*pskb)->nh.iph;

--5I6of5zJg18YgZEa--

--RIYY1s2vRbPFwWeW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.0 (GNU/Linux)

iD8DBQE9oCQoMn8mlRoBXMQRAlu7AKCIY4HoSyjz2T+KjMYXlzdSOywTVwCg34+a
/COSRjG4wV0Hohr8BiVtvsY=
=9DXd
-----END PGP SIGNATURE-----

--RIYY1s2vRbPFwWeW--
