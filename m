From: Phil Dibowitz <phil@ipom.com>
Subject: libnetfilter_conntrack.h missing struct nf_conntrack definition
Date: Wed, 14 Mar 2007 15:21:30 -0700
Message-ID: <20070314222130.GB31683@ipom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

None of the libnetfilter_conntrack's "public" headers include the full
definition of struct nf_conntrack.

It's not a 'private' structure (__*), thought it uses private structures
within it...  This means I can't do things like memcpy() them, sizeof() the=
m,
or even build an STL vector of them (yeah, I know, ew, yuck, c++).

Since nf_conntrack structs are passed around to the applications using nfct,
it seems reasonable to desire to do things with them.

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming


--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF+HVqN5XoxaHnMrsRAlzMAJ9ZkcDq/CWO3dLrqkIPX8xT7g9PEACbBSbJ
PdftBvU437KVD7zv6ugNaMY=
=2roy
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
