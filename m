From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: [PATCH nfsim] RFC: quote control and 8bit characters in the
	data portion
Date: Sat, 12 Feb 2005 01:31:57 +0100
Message-ID: <20050212003156.GA16948@zion.homelinux.com>
References: <20050211225628.GA27755@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Cc: netfilter-devel@lists.netfilter.org
To: Max Kellermann <max@duempel.org>
Content-Disposition: inline
In-Reply-To: <20050211225628.GA27755@roonstrasse.net>
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


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Max,

On Fri, Feb 11, 2005 at 11:56:28PM +0100, Max Kellermann told us:
> Any more ideas? What else can be done to improve nfsim's support for
> binary protocols? Maybe unescape everything before checking
> expectations?

one thing I could think about and what would be quite handy IMHO would
be to give packet input to nfsim from tcpdump files. So one could make
some captures of packets on the wire and then feed them to nfsim for
testing. Unfortunately, I didn't have time to think a little bit more
about this...


Sven

>=20
> Max
>=20

--=20
Linux zion 2.6.11-rc2-mm1 #1 Fri Jan 28 18:13:44 CET 2005 i686 athlon i386 =
GNU/Linux
 01:25:16 up 14 days,  7:06,  1 user,  load average: 0.08, 0.02, 0.01

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFCDU58o4FAdB2PneQRAqh+AJ96wgOpfjM5C2ppof5ByS1OVcRfTACdEaYa
30Od2r/qHt5Q6+xEWfR4YVg=
=63By
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
