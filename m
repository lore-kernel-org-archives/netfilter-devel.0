From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 0/3] cleanups for matches
Date: Fri, 20 Jan 2006 12:21:26 +0100
Message-ID: <20060120112126.GB4603@sunbeam.de.gnumonks.org>
References: <200601160936.k0G9aXWH026971@toshiba.co.jp>
	<200601200225.k0K2PAn2005682@toshiba.co.jp>
	<20060120081151.GV4603@sunbeam.de.gnumonks.org>
	<200601200955.k0K9tSnM001413@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jyWdsH1tvGESd50Z"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200601200955.k0K9tSnM001413@toshiba.co.jp>
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


--jyWdsH1tvGESd50Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 20, 2006 at 06:55:27PM +0900, Yasuyuki KOZAKAI wrote:

> > > Hmm.. we cannot do that without breaking compatibility of ip6t_esp.
> > > Because this forces us to add '-p esp' to ip6tables command. The curr=
ent
> > > ip6t_esp doesn't require it.
> >=20
> > We shouldn't require ourselves to be compatible to bugs.  There is no
> > point in matching ESP SPI when the protocol !=3D esp.  So any ruleset t=
hat
> > would no longer work with the new xt_esp was most likely invalid anyway.
>=20
> good point. OK, let's prevent users from such misconfiguration rather than
> taking care about compatibility this time.
>=20
> But please note that 'ip6tables -p esp' with kernel before 13 month didn't
> match ESP header. That was the policy of initial implementator, not bug.
> I imagine he treated ESP as extention header. Then users used
> 'ip6tables -m esp ...' without '-p esp'.

ah, yes. thanks for the reminder. ipv6 extension headers are indeed
[again] causing problems ;)

Anyway, I still think that we can ignore that issue.  Please patch the
manpage with a corresponding notice, one that explicitly states which
kernel version behaves how.

I wish we had started a list of 'netfilter/iptables semantic changes' in
2000 which we would always keep up to date.  Now there are a number of
subtle differences (like this) which almost nobody recalls :(

btw: is it feasible to do the same kind of merge for AH ?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--jyWdsH1tvGESd50Z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD0Me2XaXGVTD0i/8RAq2RAJwOL9weYIOSfuRvzDSmhnFWRQfx1wCfYL6O
+wdjI5jyN3cTAKK5RrR66qs=
=a77w
-----END PGP SIGNATURE-----

--jyWdsH1tvGESd50Z--
