From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2.6] Allow dynamic helper-port assignment
Date: Mon, 14 Feb 2005 12:21:15 +0100
Message-ID: <20050214112115.GE32452@sunbeam.de.gnumonks.org>
References: <20050213165638.GM20269@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.58.0502132315570.10608@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0502132315570.10608@blackhole.kfki.hu>
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


--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 13, 2005 at 11:38:40PM +0100, Jozsef Kadlecsik wrote:
> Hi Harald,
>=20
> Let's imagine a real H.323 helper module, which works reliably (contrary
> to the current one) and thus deployed at sites which use videoconferencing
> heavily. Due to the nature of H.323, the dynamic H.245 helpers are truly
> created dynamically for every single H.225 session, which starts the whole
> H.323 protocol-tree . The currently nicely static helper list (which we
> could thus protect even by RCU locking) would become dynamic and
> could create *potentially* a new bottleneck.

Well, while h323 triggered my work on dynamic helper-port assignment, it
is not really proposed as a solution to the h323 problem.  It merely
solves the h323-oops problem as a side-effect, since it (again, as a
side effect) splits helper registration and port assignment in two
seperate steps.

The helper list could indeed become a bottleneck, but unless you run in
front of a heavily loaded h323 pbx I don't think that's much of an issue
now.

My patch clearly seperates helper lookup from the conntrack core, thus
enabling implementation of faster matching algorithms=20

> Let's assume another protocol, which uses dynamic sub-helpers. How
> could we handle the possible ports clashes of the different
> sub-helpers in your scheme?

That's a totally different problem.  Actually two:

1) helpers register overlapping expectations.
   most likely the helpers are broken, and/or they need nat reservations
   (which we ought to provide)
2) helpers expectations overlap with administrator-assigned ports
   Well, the admin can alway shoot himself in the foot.  No action
   required here.

> Jozsef

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCEImrXaXGVTD0i/8RAhLFAKCtp7IEm9eVWtlFb2OSDPlZ8PKjmgCffa6/
dVXhNylMzg9LdLVm6xW3J00=
=rxi4
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--
