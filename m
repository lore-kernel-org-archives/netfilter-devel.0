From: Harald Welte <laforge@netfilter.org>
Subject: Re: pptp conntrack stream timeout
Date: Tue, 21 Jun 2005 00:29:20 +0200
Message-ID: <20050620222920.GB23109@obroa-skai.de.gnumonks.org>
References: <200506201545.14009.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Content-Disposition: inline
In-Reply-To: <200506201545.14009.thomas.jarosch@intra2net.com>
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


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 20, 2005 at 03:45:13PM +0200, Thomas Jarosch wrote:
> Hello Harald,
>=20
> while looking at the source of the PPTP conntrack helper,
> I noticed the "PPTP_GRE_STREAM_TIMEOUT" is set to 5 days.
>=20
> Is there a reason why this timeout is so high?
> 5 days is pretty long for a timeout.

It's set to the same timeout like the TCP ESTABLISHED timeout.

The main reason being that it is impossible to spoof a connection from
one side into that state without appropriate feedback traffic.  The
other reason being that nothing in the respective protocol
specifications prevent a tunnel (or a tcp session) from being completely
idle for an indefinite amount of time before continuing traffic.

5 days is the compromise between now and eternity ;)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCt0NAXaXGVTD0i/8RArCyAJ9JRd8cbiXSDG5QK59RkPmm35j0nwCgrxSZ
pNWIMw91up8u3LuX223KPto=
=hegd
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
