From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [ANNOUNCE] nfsim - netfilter simulation environment
Date: Thu, 08 Jan 2004 00:19:31 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1073517570.31821.119.camel@tux.rsn.bth.se>
References: <200401071044.18059.jeremy@redfishsoftware.com.au>
	 <1073505244.31821.101.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AReuLnX8/Nm3cNhIwc8I"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jeremy Kerr <jeremy@redfishsoftware.com.au>
In-Reply-To: <1073505244.31821.101.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-AReuLnX8/Nm3cNhIwc8I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2004-01-07 at 20:54, Martin Josefsson wrote:

> > Contributions & comments are most welcome.
>=20
> Will give it a testspin.

Hi again, now I've given it a small initial testdrive and I've found a
small bug.

Here's a small patch to fix select() handling in
core/message.c:wait_for_message()

The fdset is undefined when select() returns -1.
Rerun select() when that happens and errno is something retryable.

Without this all iptables commands that uses sockets hang the simulator
when message_client_connection() is called for sockfd but there isn't
any data available.

--- nfsim/core/message.c.orig	2004-01-08 00:01:17.000000000 +0100
+++ nfsim/core/message.c	2004-01-08 00:01:45.000000000 +0100
@@ -184,6 +184,7 @@
 void wait_for_message(int extra_fd)
 {
 	fd_set fdset;
+	int retry =3D 0;
=20
 	do {
 		int maxfd, sret;
@@ -194,8 +195,14 @@
=20
 		maxfd =3D max(extra_fd, sockfd);
 		sret =3D select(maxfd + 1, &fdset, NULL, NULL, NULL);
-		if (sret < 0 && errno !=3D EINTR)
+		if (sret < 0) {
+			if (errno =3D=3D EINTR || errno =3D=3D EAGAIN) {
+				if (++retry > 3)
+					barf_perror("too many retries");
+				continue;
+			}
 			barf_perror("select");
+		}
=20
 		if (FD_ISSET(sockfd, &fdset))
 			message_client_connection(sockfd);

--=20
/Martin

--=-AReuLnX8/Nm3cNhIwc8I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQA//JQCWm2vlfa207ERAkRZAJ43sACBd4dvxvdVSoRWtGu1BhjhEgCdFwO7
Yy9EzUI2gkINTV2T/X7pXKU=
=Vqbd
-----END PGP SIGNATURE-----

--=-AReuLnX8/Nm3cNhIwc8I--
