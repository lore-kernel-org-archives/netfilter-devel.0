From: Harald Welte <laforge@netfilter.org>
Subject: Re: ip_conntrack CLOSE_WAIT issue.
Date: Wed, 28 Jan 2004 10:01:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040128090152.GN11761@sunbeam.de.gnumonks.org>
References: <4016D6DE.4040801@metavize.com> <4016DA5E.5020505@metavize.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8+odlFQADydc3R4z"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Dirk Morris <dmorris@metavize.com>
Content-Disposition: inline
In-Reply-To: <4016DA5E.5020505@metavize.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--8+odlFQADydc3R4z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2004 at 01:38:38PM -0800, Dirk Morris wrote:
> My apologies,
>=20
> I believe this is related to an experimental patch that I am using, and=
=20
> is not conntrack related.
> Conntrack nevers sees the first FIN, which would explain this behavior.

It has to be.  ip_conntrack_proto_tcp uses:

unsigned long ip_ct_tcp_timeout_fin_wait =3D      2 MINS;
unsigned long ip_ct_tcp_timeout_close_wait =3D   60 SECS;
unsigned long ip_ct_tcp_timeout_last_ack =3D     30 SECS;
unsigned long ip_ct_tcp_timeout_time_wait =3D     2 MINS;
unsigned long ip_ct_tcp_timeout_close =3D        10 SECS;

So I see no way you could end up with this:

> >tcp      6 257147 CLOSE_WAIT src=3D10.0.0.44 dst=3D10.0.0.187 sport=3D43=
035=20
> >dport=3D7000 src=3D10.0.0.187 dst=3D10.0.0.44 sport=3D7000 dport=3D43035
> >[ASSURED] use=3D1

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8+odlFQADydc3R4z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAF3qAXaXGVTD0i/8RAjypAJ0SbjumOYWtyhrDQ5yXVQ86QH4A5gCfUnla
NQvq/X/7u/sStuTPTvSy838=
=W2B/
-----END PGP SIGNATURE-----

--8+odlFQADydc3R4z--
