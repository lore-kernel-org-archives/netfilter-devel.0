From: Harald Welte <laforge@netfilter.org>
Subject: Re: latest nf_conntrack version
Date: Wed, 3 Aug 2005 16:27:08 +0200
Message-ID: <20050803142708.GA9456@rama.de.gnumonks.org>
References: <42EDF5D1.5020703@trash.net>
	<20050801201646.GE4156@rama.de.gnumonks.org>
	<200508021533.j72FXlIq005061@toshiba.co.jp>
	<200508021633.j72GX9Ea016932@toshiba.co.jp>
	<42EFEA57.5010406@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42EFEA57.5010406@trash.net>
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


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 02, 2005 at 11:49:11PM +0200, Patrick McHardy wrote:
> Yasuyuki KOZAKAI wrote:
> > Hi Patrick,
> >=20
> > Well, it's may be silly question,
>=20
> Not at all, git can be confusing :) It took me 2 hours to figure out how
> to use git-ssh-push (the remote repository already needs to be
> initialized).

mh, I'm just calling plain 'rsync' on the .git directory for the
netfilter-2.6 tree on people.netfilter.org/laforge.

I've now also merged your nf_conntrack tree into my netfilter-2.6 tree
as local "nf_conntrack" branch.

rsync://people.netfilter.org/users/laforge/scm/netfilter-2.6.14.git#nf_conn=
track

should therefore be the full url to that branch.  I've done the nfcache
removal and the nf_log_packet() api changes. it compiles and builds fine
(no unresolved symbols), but I didn't have time to test it further.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC8NQ7XaXGVTD0i/8RAgO7AKCGQIF0XF2yvjCXNsXgPLNJvhn+lACfbKo1
rvKf0Gdge//dX1ge8QcL9Ow=
=U1bl
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
