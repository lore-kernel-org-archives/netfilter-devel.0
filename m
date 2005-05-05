From: Harald Welte <laforge@netfilter.org>
Subject: Re: PPTP connection tracking and NAT helper
Date: Thu, 5 May 2005 22:10:25 +0200
Message-ID: <20050505201025.GA30482@sunbeam.de.gnumonks.org>
References: <4279291E.2060103@nit.ca>
	<20050505075258.GM30482@sunbeam.de.gnumonks.org>
	<20050505170400.GA20178@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l1Ga9FRlYJwFJxwF"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
Content-Disposition: inline
In-Reply-To: <20050505170400.GA20178@linuxace.com>
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


--l1Ga9FRlYJwFJxwF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 05, 2005 at 10:04:00AM -0700, Phil Oester wrote:
> On Thu, May 05, 2005 at 09:52:58AM +0200, Harald Welte wrote:
> > please read the netfilter-devel archive.  I get asked this question at
> > least ten times a week:
> >=20
> > There is no pptp/gre conntrack and nat helper for 2.6.11+, since this
> > kernel version contains a redesigned infrastructure for such helpers.
>=20
> How bout we make it harder for people to try?  Attached patch adds
> a 'Requires' to pptp in pom, and fixes up broken Requires handling.

oh, I wasn't aware of that.  I've committed your changes, thanks.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--l1Ga9FRlYJwFJxwF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCen2xXaXGVTD0i/8RAqa4AJ9EhrcapY9qf6hTINBK+1H5mor7XQCfa1LB
2V0lfV5h/UL4qbU7P8SwIuc=
=pVhG
-----END PGP SIGNATURE-----

--l1Ga9FRlYJwFJxwF--
