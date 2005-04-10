From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH pom-ng] H.225 parser for h323-conntrack-nat
Date: Sun, 10 Apr 2005 22:41:21 +0200
Message-ID: <20050410204121.GQ9155@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.58.0504040852460.12853@blackhole.kfki.hu>
	<20050404091035.GB28490@roonstrasse.net>
	<20050404215535.022F.LARK@linux.net.cn>
	<20050404140639.GA31341@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U/R2oelL0JVaeI5e"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
Content-Disposition: inline
In-Reply-To: <20050404140639.GA31341@roonstrasse.net>
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


--U/R2oelL0JVaeI5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 04, 2005 at 04:06:39PM +0200, Max Kellermann wrote:
> On 2005/04/04 16:01, Wang Jian <lark@linux.net.cn> wrote:
> [...]
> > I want to make it works under 2.6.11 or 2.6.12. I really need your help
> > to finish it in time.
> >=20
> > I will spend a day (ideally) to look into the new conntrack
> > infrastructure, and then I will spend time on every conntrack involved.
> > If the old code works, I think it is not very hard to port them to new
> > infrastructure. provided that new infrastruture is stable and good.
>=20
> I already ported h323-conntrack-nat to 2.6.11, but my port is hidden
> in an obsolete branch in the pom-ng svn repository. Please grab my
> patch from my home page:
>=20
>  http://max.kellermann.name/projects/netfilter/h323.html

hm, seems we now have your and my (unfinished) port.   I should have
read netfilter-devel more often, it seems.

I've now merged your code in svn trunk, please verify if everything
works allright.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--U/R2oelL0JVaeI5e
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCWY9xXaXGVTD0i/8RApbRAJ4gEjk3tu2aIvEULDkBdqN3hwUMfACfQGIa
lyFv1zl6J9B8j2tFtL5Eo24=
=iWXz
-----END PGP SIGNATURE-----

--U/R2oelL0JVaeI5e--
