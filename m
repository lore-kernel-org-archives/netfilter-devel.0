From: Harald Welte <laforge@netfilter.org>
Subject: Re: x_tables vs. nf-hipac
Date: Tue, 11 Oct 2005 19:52:05 +0200
Message-ID: <20051011175205.GB13415@rama.de.gnumonks.org>
References: <434A4B11.4030103@gmx.net> <20051010163442.GC5627@rama>
	<1128983497.3377.4.camel@localhost.localdomain>
	<20051011143314.GC4756@rama.de.gnumonks.org>
	<1129049746.3378.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Content-Disposition: inline
In-Reply-To: <1129049746.3378.11.camel@localhost.localdomain>
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


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 11, 2005 at 04:55:46PM +0000, Bart De Schuymer wrote:
> > One rally sad thing is that arp_tables was deprived of matches, so we
> > only have targets.  This means we cannot use any of the x_tables matche=
s=20
> > (such as limit, mark, ...).
>=20
> Yeah, I know. But I don't see why it can't be added, this shouldn't
> break backwards compatibility. The struct arpt_entry has the members
> target_offset and next_offset...

ah, ok. That sounds good.  Maybe someone is willing to add match
support after x_tables is merged.

> > If you would be willing to harmonize here (I think this only affects
> > kernel space data structures that are not shared with userspace, so no
> > compatibility issues), then eb_tables could directly use x_tables
> > matches - if that is desired.
>=20
> It's probably not worth it...

Yes, that's what I figured.
=20
> > However, ebtables matches quite nicely with pkt_tables (some people have
> > suggested renaming it into nf_tables).  This is mainly because of the
> > "watchers".  A pkt_tables rule has=20
> > - any number of matches
> > - any number of targets (that have a "void" function and don't return
> >   anything)
> > - one user-specified verdict.
> >=20
> > so all watchers can be implemented as targets.  So it all boils down on
> > how much time I can find to complete pkt_tables. Maybe at some point
> > early 2006, after we've survived the nf_conntrack merge, and added
> > proper support for userspace conntrack helpers.
>=20
> I'll wait for that then. Hopefully it will allow the RETURN verdict for
> target modules. I'll concentrate on finalising the current ebtables
> version in cvs for now.

As I said, target modules are "void" so they don't return anything.
It's userspace who tells the kernel what verdict to use.   userspace
Target plugins will probably try to choose a reasonable default (e.g.
DROP in the case of REJECT), but the sysadmin can override it. =20

If a target really has to drop a packet (because of whatever problem, we
have the "hotdrop" mechanism.  But that should be the exception, not the
standard case.

Cheers,

btw: did you yet hav a chance to test my ebt_log/ebt_ulog changes?
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDS/vFXaXGVTD0i/8RAuUVAKCjTuECCSOzh40SzNz9j/6GbKjKRwCeNKK6
jM9b15hg2tpKfD33RJxngXI=
=poPR
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--
