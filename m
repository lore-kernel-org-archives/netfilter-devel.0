From: Harald Welte <laforge@netfilter.org>
Subject: Re: checkentry() and detroy ()  called multiple times
Date: Fri, 23 May 2003 21:54:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030523195443.GP3077@sunbeam.de.gnumonks.org>
References: <3EBFAE08.5050006@linux.org.ar>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlsYxwg8UDQn+EKZ"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: diegows <diegows@linux.org.ar>
Content-Disposition: inline
In-Reply-To: <3EBFAE08.5050006@linux.org.ar>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--UlsYxwg8UDQn+EKZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2003 at 11:22:00AM -0300, diegows wrote:
> I 'm doing a match module and I have i little confusion.
>=20
> If I insert a rule using my match module, I see that checkentry() is=20
> called once. If I insert a rule using my match module again I see that=20
> checkentry() is called twice and destroy is called once, and If i insert=
=20
> a rule for third time I see that checkentry is called tree times and=20
> destroy twice.

because checkentry is called for every rule that is using your match in
this table.  It is supposed to check the *matchinfo data passed on from
userspace.

> Is this the right? why?

yes. see above.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--UlsYxwg8UDQn+EKZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+znyDXaXGVTD0i/8RArezAJ0cMm6cf8AlU9+irqbMT8RfQNSCqQCfTiMk
MsxkweKaV7l0x6Imssc9dRM=
=mI81
-----END PGP SIGNATURE-----

--UlsYxwg8UDQn+EKZ--
