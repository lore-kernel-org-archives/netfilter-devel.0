From: Harald Welte <laforge@gnumonks.org>
Subject: Re: ip_conntrack performance issues - also semantic issues
Date: Fri, 31 Jan 2003 12:35:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030131113516.GR9073@naboo.cybercafe42>
References: <20030118232752.26497.32589.Mailman@kashyyyk> <15914.20503.476455.344137@isis.cs3-inc.com> <20030119075102.GF12401@oknodo.bof.de> <15914.25470.189261.168220@isis.cs3-inc.com> <20030119091656.GG12401@oknodo.bof.de> <1042969247.28675.57.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5FetH82qe0Z6y/zI"
Cc: Patrick Schaaf <bof@bof.de>, Don Cohen <don-netf@isis.cs3-inc.com>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1042969247.28675.57.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--5FetH82qe0Z6y/zI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 19, 2003 at 10:40:47AM +0100, Martin Josefsson wrote:
> On Sun, 2003-01-19 at 10:16, Patrick Schaaf wrote:
>=20
> > >  > 1) that a NEW conntrack need not be allocated in full.
> > > I guess you're saying that the allocation takes a significant amount
> > > of time, entering into hash is another chunk, and the first part is
> > > done at prerouting.
> >=20
> > I'm pretty sure that the allocation is the main cost, putting into
> > the hashes is not performance critical per se (if the lists are short).=
=20
>=20
> My small unscientific tests (performed quite some time ago) say that the
> allocation isn't the most costly operation performed.

It would also surprise me if allocation cost was _that_ high. Remember,
we are already using the slab cache for this.

> The test was a simple SYN-flood (random source ip's and ports) beeing
> forwarded by a router. If I didn't load ip_conntrack at all everything
> was fine and I had lots of cpu left. When I loaded ip_conntrack the cpu
> usage went to 100%. Then I tried blocking the flood in filter/FORWARD
> and that helped _a lot_ and in this case the allocation is still
> happening for each packet. But of course blocking it in raw/PREROUTING
> is even better (before the packets reach ip_conntrack)

yup.  Why don't we have a 'raw' or 'prestate' table in patch-o-matic
yet?  This is a very easy job, can't anybody please add this missing
feature?

> /Martin

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--5FetH82qe0Z6y/zI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Ol90XaXGVTD0i/8RAlopAKCQxxgpAjjCwHDcRuiG3vIJ+pmYaACfTYj6
CEAyHUgEDkVccTLpVD/Vi3o=
=P425
-----END PGP SIGNATURE-----

--5FetH82qe0Z6y/zI--
