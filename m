From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] ct_sync 0.15 (corrected)
Date: Tue, 24 Aug 2004 20:37:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040824183752.GM26877@sunbeam.de.gnumonks.org>
References: <1092407190.2402.120.camel@nienna.balabit> <20040819110646.GJ3921@sunbeam.de.gnumonks.org> <20040822204326.GA25567@sch.bme.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vYzPTKoKRdF40tnF"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	jamal <hadi@cyberus.ca>
Content-Disposition: inline
In-Reply-To: <20040822204326.GA25567@sch.bme.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--vYzPTKoKRdF40tnF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 22, 2004 at 10:43:26PM +0200, KOVACS Krisztian wrote:
>=20
>   Hi,
>=20
> On Thu, Aug 19, 2004 at 01:06:46PM +0200, Harald Welte wrote:
> > >         So, do anyone know of anything which could be used by ct_sync?
> > >         (It has to be a semi-reliable, connectionless multicast proto=
col
> > >         with a _very_ low overhead.)
> >=20
> > everything I've seen so far about reliable multicast is inherently
> > complex.
>=20
>   Oops, I've just found TIPC. Does anyone know enough details of TIPC to
> judge if its reliable multicast service would be useful for us? I've just
> downloaded the IETF draft, and it seems to me that the reliable multicast
> service provided by TIPC may be useful (section 2.9 of the draft). Any
> ideas?

Unfortunately I did only learn about TIPC recently.  But looking at the
IETF draft and the current implementation, I think it is probably too
expensive.  Another argument is to not base ct_sync on something big
outside of the official kernel tree that is not under our control..

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--vYzPTKoKRdF40tnF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBK4sAXaXGVTD0i/8RAt/zAKCp+PPSZPNC3J1Dqo9zhu3yMfhjxwCgrl/V
0gRzPVmgQNAly+1TIQEBDEk=
=2Fft
-----END PGP SIGNATURE-----

--vYzPTKoKRdF40tnF--
