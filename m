From: Harald Welte <laforge@netfilter.org>
Subject: Re: UDP-conntrack/nat question
Date: Fri, 3 Oct 2003 12:53:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031003105322.GF5758@sunbeam.de.gnumonks.org>
References: <27575.1064481980@www45.gmx.net>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Etoca9nXhLMPgAOd"
Cc: netfilter@lists.netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: n_dahlem@gmx.net
Content-Disposition: inline
In-Reply-To: <27575.1064481980@www45.gmx.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Etoca9nXhLMPgAOd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This is a development question, please move this discussion to
netfilter-devel.  At least if you want to receive some reasonable
answers ;)

On Thu, Sep 25, 2003 at 11:26:20AM +0200, n_dahlem@gmx.net wrote:

> /proc/net/ip_conntrack lists both connections (answer&reply) as unreplied.
> Can someone explain to me why the reply is seen as a new connection ? And
> how I can get NAT to expect answers from randomly selected high ports ?

this sounds like the connection is not symmetrically.  The conntrack
core assumes that connections are always symmetrically:

request:
(srcip x, scrport a)  -> (dstip y, dstport b)

reply:
(srcip y, srcport b) -> (dstip x, dstport a)

If this is not the case, you are in serious trouble.

> regards
> Nikolai Dahlem
>=20
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Etoca9nXhLMPgAOd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fVUiXaXGVTD0i/8RAuZyAJ4hMbQ6af+nAj9wN5OW9IBtSLA34QCfQiQY
o1iaeZ7EwpkE/X7n5bRfdKE=
=pS+I
-----END PGP SIGNATURE-----

--Etoca9nXhLMPgAOd--
