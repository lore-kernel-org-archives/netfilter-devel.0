From: Harald Welte <laforge@netfilter.org>
Subject: Re: Using iptables with x86_64 static kernel (module problems)?
Date: Sun, 5 Oct 2003 13:54:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031005115420.GA5758@sunbeam.de.gnumonks.org>
References: <20031001161136.GA13226@cc.jyu.fi> <20031003102156.GV5758@sunbeam.de.gnumonks.org> <20031005001333.GA8589@cc.jyu.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OpjiOMsh+o5vh7q4"
Cc: netfilter@lists.netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jani Averbach <jaa@cc.jyu.fi>
Content-Disposition: inline
In-Reply-To: <20031005001333.GA8589@cc.jyu.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--OpjiOMsh+o5vh7q4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 05, 2003 at 03:13:33AM +0300, Jani Averbach wrote:
> > I don't really understand the problem.  'iptables tries to do various
> > mudules related task' ?
>=20
> Ok, perhaps the culprit is not the module related things, but however
> iptables won't work with x86_64 kernel.=20

I will give it some testing.  My Opteron box only runs 2.6.x kernels,
which seem to work fine with iptables.

> My first idea was that iptables try to use modprobe etc. to probing if
> various netfilter kernel modules are present, and it gets confused
> when this module-stuff won't work with x86_64 kernel.=20

mh. The only idea I have is that you've somehow ended up with a 32bit
iptables (which won't work).  It has to be compiled in the same mode as
the kernel itself - to assure that structure sizes/alignment/... are
consistent.

> BR, Jani

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--OpjiOMsh+o5vh7q4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD4DBQE/gAZsXaXGVTD0i/8RAokiAJ9/WSqtwDkW1mPgDZAthHbxMAOU/wCXb0ZR
WnPmObUwemOmziNO8pdVFg==
=R97g
-----END PGP SIGNATURE-----

--OpjiOMsh+o5vh7q4--
