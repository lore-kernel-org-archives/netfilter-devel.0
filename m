From: Eric Leblond <eric@regit.org>
Subject: Libipq and invalid packet_id
Date: 26 Jun 2003 01:00:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056582020.32621.11.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YFBmYxSIDC7x6igjfNUQ"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-YFBmYxSIDC7x6igjfNUQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I'm starting to code an application using libipq.

I saw that, if I give an invalid packet_id to  ipq_set_verdict, I'm not
able to receive any packet afterward. So I've got two questions :
	- Is this a wanted feature ?
	- If Yes, then Why ? ;-)

BR,
--=20
Eric Leblond <eric@regit.org>

--=-YFBmYxSIDC7x6igjfNUQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA++imEnxA7CdMWjzIRAnquAKCDE88bSFMIFX1pDjH+U4dRHESjuACfWHh5
3cgQJAazp83DueauWaJlp0I=
=r+Ht
-----END PGP SIGNATURE-----

--=-YFBmYxSIDC7x6igjfNUQ--
