From: Harald Welte <laforge@netfilter.org>
Subject: Re: PATCH: extra conntrack stats
Date: Sun, 27 Apr 2003 22:42:18 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427204218.GT990@sunbeam.de.gnumonks.org>
References: <200304192142.h3JLg1S03466@fokkensr.vertis.nl> <20030427124835.GA990@sunbeam.de.gnumonks.org> <200304271523.h3RFNZk05880@fokkensr.vertis.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UTgPAcoWnJ37G5eg"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rolf Fokkens <fokkensr@fokkensr.vertis.nl>
Content-Disposition: inline
In-Reply-To: <200304271523.h3RFNZk05880@fokkensr.vertis.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--UTgPAcoWnJ37G5eg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 27, 2003 at 05:23:30PM +0200, Rolf Fokkens wrote:
> On Sunday 27 April 2003 02:48 pm, Harald Welte wrote:
> > This is inacceptable, the only way to implement this is via per-cpu
> > counters that are added at the time you read them out (like the iptables
> > per-cpu local counters)
>=20
> Oh boy! It's even worse! Even without this patch we have a concurrency=20
> problem: the timout! It's updated frequently I guess, and it's also prote=
cted=20
> by the same lock: ip_conntrack_lock!

Oh yes, sorry.  This issue never was fixed, although I seem to remember
some patches implementing a solution where the timeout was not updated
for every packet.

> Should a lock per contrack entry be considered? This increases the=20
> concurrency for different connections anyhow.

Rusty has written some patches about this quite some time ago,
unfortunately they seem to be discontinued.  IIRC Martin Josefsson
wanted to look into them again.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--UTgPAcoWnJ37G5eg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+rECqXaXGVTD0i/8RAg5NAJ9p4CoFYAq1pvlRFdRo3wXjuztxxQCfQXBj
tXscrTRgLrRFxthGab04qZ8=
=NtXB
-----END PGP SIGNATURE-----

--UTgPAcoWnJ37G5eg--
