From: Harald Welte <laforge@netfilter.org>
Subject: Re: memory leak problems
Date: Sat, 30 Aug 2003 21:10:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030830191023.GG17715@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0308270250100.12780-100000@mx.nextra.ro>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8Bkcj4NmnZ79d4W7"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Gergely Imre <gimre@nextra.ro>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0308270250100.12780-100000@mx.nextra.ro>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--8Bkcj4NmnZ79d4W7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2003 at 03:10:00AM +0300, Gergely Imre wrote:
>=20
> hi
>=20
> i'm trying to write some traffic-meter program, using the routines from=
=20
> iptables 1.2.8. i have some problems. it looks like there is some memory=
=20
> leak. i've tried the following code:

could you please try iptables version 1.38 from CVS?  There have been
lots of fixes since 1.2.8 was released.  Please see
http://cvs.netfilter.org/netfilter/userspace/libiptc/libiptc.c?rev=3D1.38

Late versions might still be a bit instable, since I've reimplemented
parts of libiptc.   So 1.38 should be the most stable and bugfree
version available.

> now, i looked in the code, and found that iptc_init, and iptc_firs_rule=
=20
> too, is doing some malloc. when/where will be that memory freed?=20
> itc_first_rule is calling a subroutine named populate_cache that is doing=
=20
> some malloc.
> where and how do i suppose to free up that memory after finished working=
=20
> with the handle, and i want a new snapshot of the rules? i was calling=20
> iptc_init once every second on a fairly large chains (around 1000 rules),=
=20
> and after a minute or so, i saw that the program took more and more=20
> memory from the system. what can i do? will this be fixed soon, or just=
=20
> i'm not using the code the right way?

in that old code included in 1.2.8 indeed has memory leaks.  libiptc was
_never meant_ to be used by something other than one-shot executables
like iptables itself.  This is why the original authors chose not to
care about memory usage.

> thanks

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8Bkcj4NmnZ79d4W7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/UPafXaXGVTD0i/8RAvrIAKCKQQsEwiU0trp8vlHKsPduTbxv2QCgqITl
Up6UEZ2paGqGfAo0xngEDdc=
=Ie6I
-----END PGP SIGNATURE-----

--8Bkcj4NmnZ79d4W7--
