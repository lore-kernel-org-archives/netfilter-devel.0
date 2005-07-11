From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] alternative to conntrack ID
Date: Mon, 11 Jul 2005 07:41:07 +0200
Message-ID: <20050711054107.GB14851@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.58.0506061017330.16223@blackhole.kfki.hu>
	<42A83B96.4050302@eurodev.net> <42A83D72.1000106@eurodev.net>
	<Pine.LNX.4.58.0506091519580.7610@blackhole.kfki.hu>
	<42A9698F.30909@eurodev.net>
	<Pine.LNX.4.62.0506140433070.4718@kaber.coreworks.de>
	<42B6E918.5080603@ufomechanic.net> <42B6EADF.9040002@trash.net>
	<42B92AE2.3070004@ufomechanic.net> <42B99E88.8090604@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42B99E88.8090604@trash.net>
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


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 22, 2005 at 07:23:20PM +0200, Patrick McHardy wrote:
> Amin Azez wrote:
> > Err... the current problem is that the conntrack id _may_ be re-used
> > within milli-seconds?
> > I was trying to find a safe conntrack id.
>=20
> No, it is 64 bit wide and does not wrap for a long time.

I'm still not convinced that the ID is a good idea (or that it is needed
in most cases).  However,

However, flow based accounting is basically finished, all that it lacks
is nfnetlink/ctnetlink.  So I want to submit them pretty soon for
mainline inclusion.

If you have decided onto which form of ID, please try to merge those patches
(if any) soon and tell me when I can finalize ctnetlink/nfnetlink for
submission.
=20
Thanks!

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC0gZzXaXGVTD0i/8RAqZaAKCVWRaMLIidab7nHAeIyI631LxnIgCgip6w
e8QargdLi6DLLdR6A9d72bg=
=IJDj
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
