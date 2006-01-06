From: Harald Welte <laforge@netfilter.org>
Subject: Re: TCPMSS is not restricted to mangle table
Date: Fri, 6 Jan 2006 15:32:20 +0100
Message-ID: <20060106143220.GB4898@sunbeam.de.gnumonks.org>
References: <4393895D.1020106@trash.net> <20051205004548.GC5617@eychenne.org>
	<439393C9.5020001@trash.net> <439513E1.3060407@milivojevic.org>
	<43951DBF.8050001@trash.net>
	<Pine.LNX.4.61.0601030804260.23554@yvahk01.tjqt.qr>
	<43BA5C79.9060304@trash.net>
	<Pine.LNX.4.61.0601031238420.28743@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t1V/6vyDgJ44qiBN"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0601031238420.28743@yvahk01.tjqt.qr>
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


--t1V/6vyDgJ44qiBN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 03, 2006 at 12:38:54PM +0100, Jan Engelhardt wrote:
>=20
> >> On the way to restrict TCPMSS to -t mangle, the -m state
> >> could also be obsoleted in favor of -m conntrack.
> >
> > I'm not going to restrict TCPMSS to mangle - but I'm
> > considering adding a warning. I also don't see a reason
> > to deprecate the state match, its totally trivial code
> > and needs a lot less memory than the conntrack match.
> >
> But it's duplicate code, in terms of functionality.

if you're really so worried about the duplicate code, you could create a
single module (with a MODULE_ALIAS) that registers two matches, one
called "state", the other called "conntrack".

That sounds like the cleanest possible solution without breaking anything.

btw: if you seriously consider implementing my suggestion, please use
the "x_tables" local branch of my git tree - othrewise your patch will
clash with x_tables that is to be submitted any day now.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--t1V/6vyDgJ44qiBN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDvn90XaXGVTD0i/8RAkaZAJ9upSXIVPnvsnKnj4MN1bDf3huzzACgkxkD
Z9NWBX15l+NT4w7XaPx6dOE=
=rcyK
-----END PGP SIGNATURE-----

--t1V/6vyDgJ44qiBN--
