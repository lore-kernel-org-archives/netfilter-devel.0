From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink questions
Date: Fri, 6 Feb 2004 19:52:42 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040206185242.GM2312@obroa-skai.de.gnumonks.org>
References: <Pine.LNX.4.33.0310200909590.12485-100000@blackhole.kfki.hu> <Pine.LNX.4.44.0310201107510.23768-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kK1uqZGE6pgsGNyR"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0310201107510.23768-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--kK1uqZGE6pgsGNyR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I have to follow up on this old discussion, since I want to get
ctnetlink into a submission-ready state.

On Mon, Oct 20, 2003 at 11:29:46AM +0200, Henrik Nordstrom wrote:
> On Mon, 20 Oct 2003, Jozsef Kadlecsik wrote:
>=20
> > I still don't see why can't we simply use the tuple as unique id, as
> > Harald suggested. That's truly unique and does not require additional
> > fields in the ip_conntrack structure.
>=20
> Because it is not long-term unique. With the tuple approach the
> administrator risks hitting another connection if the originally intended
> connection has already been destroyed and replaced by a new connection
> with the same address details.

well, but if the tuple is again the same tuple, chances are high the
administrator actually wants to remove that new connection as much as
the previous one.  In fact, apart from a short difference in time, they
_are_ pretty much the same connection.

So from my point of view, the tuple is still sufficient.  Tuple can be
used by userspace to identify a connection, tuple is used for
replication messages in ct_sync.

We can also guarantee, that all entries that
	- existed before the dump started
	- and still exist when the dump ended
are actually dumped.

We don't make any guarantees about connections that either started
within that timeframe, or have been terminated within that timeframe.

I would really like to see the ordered list and id disappear.

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kK1uqZGE6pgsGNyR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAI+J6XaXGVTD0i/8RAv7IAJ0bqGS11uf+UVXNlYp83Vzw225P3ACfbYOj
Qa4p/m15Hed91DflfP5FY7A=
=ahQE
-----END PGP SIGNATURE-----

--kK1uqZGE6pgsGNyR--
