From: Nigel Kukard <nkukard@lbsd.net>
Subject: netlink sockets
Date: Mon, 16 Jun 2003 11:37:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030616093726.GI2103@lbsd.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HkMjoL2LAeBLhbFV"
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


--HkMjoL2LAeBLhbFV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

are netlink sockets full duplex?

For 2 threads reading and setting verdicts on the same handle i get=20
alot of "Unknown Errors" set by ipq_error and "Interrupted System=20
Call" set by errno.


Regards
Nigel



--HkMjoL2LAeBLhbFV
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+7Y/WKoUGSidwLE4RAkQZAJ9R7S0H1+XoQqpcjuOB/UeP33pe1ACeJ4lk
DznbcYEF3/3T98fMUcUwP+s=
=B6Ts
-----END PGP SIGNATURE-----

--HkMjoL2LAeBLhbFV--
