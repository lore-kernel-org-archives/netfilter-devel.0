From: Harald Welte <laforge@netfilter.org>
Subject: Re: x_tables vs. nf-hipac
Date: Tue, 11 Oct 2005 16:33:14 +0200
Message-ID: <20051011143314.GC4756@rama.de.gnumonks.org>
References: <434A4B11.4030103@gmx.net> <20051010163442.GC5627@rama>
	<1128983497.3377.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Content-Disposition: inline
In-Reply-To: <1128983497.3377.4.camel@localhost.localdomain>
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


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2005 at 10:31:37PM +0000, Bart De Schuymer wrote:
> Op ma, 10-10-2005 te 18:34 +0200, schreef Harald Welte:
> > On Mon, Oct 10, 2005 at 01:05:53PM +0200, Carl-Daniel Hailfinger wrote:
> > > Hi Harald,
> > >=20
> > > you said that there is already some code for x_tables (is that
> > > pkttables, and if so, doesn't the new name collide with a spreadsheet
> > > layout program?).=20
> >=20
> > No, x_tables is not pkttables.  However, x_tables matches/targets will
> > be incrementally changed in order to be used from
> > {arp,ip,ip6,pkt}_tables _and_ nf-hipac at the same time.
>=20
> Nice to see this move forward. If you want to put the arptables
> userspace tool into the netfilter tree, then be my guest.

At the moment, I'm still busy in consolidation of kernelspace.  I'm not
sure how easy this will get for the userspace side.  Once I've done the
userspace counterpart (consolidation of libipt_FOO / libipXt_FOO), I'll
look at the arptables userspace code and see if we can integrate that
somehow.

One rally sad thing is that arp_tables was deprived of matches, so we
only have targets.  This means we cannot use any of the x_tables matches=20
(such as limit, mark, ...).

> I guess we'll have to consider talking about merging ebtables into this
> scheme some day...

ebtables and x_tables has quite some 'impedance mismatch', mainly
because of lots of small subtle differences:

- FUNCTION_NAME_LENGTH is 32, not 30 (thus ebt_match/ebt_target have a
  different structure layout)
- different count of arguments for match(), target() and checkfn().

If you would be willing to harmonize here (I think this only affects
kernel space data structures that are not shared with userspace, so no
compatibility issues), then eb_tables could directly use x_tables
matches - if that is desired.


However, ebtables matches quite nicely with pkt_tables (some people have
suggested renaming it into nf_tables).  This is mainly because of the
"watchers".  A pkt_tables rule has=20
- any number of matches
- any number of targets (that have a "void" function and don't return
  anything)
- one user-specified verdict.

so all watchers can be implemented as targets.  So it all boils down on
how much time I can find to complete pkt_tables. Maybe at some point
early 2006, after we've survived the nf_conntrack merge, and added
proper support for userspace conntrack helpers.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDS80qXaXGVTD0i/8RAn5OAKCThKfolvqkebMIfHHK/F34cAKLHQCeIBjV
nJK3Sv27mo5/Zo6bYOB9hSY=
=ZWMo
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
