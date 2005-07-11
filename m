From: Harald Welte <laforge@netfilter.org>
Subject: Re: SO_ORIGINAL_DST does not work in nat/OUTPUT anymore
Date: Mon, 11 Jul 2005 13:58:10 +0200
Message-ID: <20050711115810.GI16728@sunbeam.de.gnumonks.org>
References: <42D12E28.7020707@hoelldampf.net>
	<20050710153234.GM20465@sunbeam.de.gnumonks.org>
	<42D14A6D.4000900@trash.net>
	<Pine.LNX.4.61.0507101822200.9759@filer.marasystems.com>
	<42D1608C.7040909@trash.net>
	<20050710202359.GA6874@sunbeam.de.gnumonks.org>
	<42D18912.7030306@trash.net>
	<Pine.LNX.4.61.0507111305360.20556@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xQR6quUbZ63TTuTU"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0507111305360.20556@yvahk01.tjqt.qr>
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


--xQR6quUbZ63TTuTU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 11, 2005 at 01:06:19PM +0200, Jan Engelhardt wrote:
> >> Yes, I'm also in favour of reverting the patch.  The number of functio=
nal bugs
> >> it has caused by far outweigh the gain of save 'rmmod' without loops.
> >
> >Agreed, unfortunately. If we can't get module unload to work reliably we
> >should introduce another way to flush the conntrack table however. I'm
> >thinking of something easy like a /proc file.
>=20
> But in the time that passes between echo 1 >/proc/flushme and rmmod new=
=20
> entries could show up, if it's "just" a flush and not a flush-and-disable=
=20
> operation.

I think you misunderstood Patrkick.  The /proc file would be to flush
the table and therefore making the rmmod-insmod cycle if ip_conntrack no
longer necessarry.

If we could easily get rid of all conntracks [and their references], we
wouldn't need the /proc file, but could do it in the modules fini()
function.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--xQR6quUbZ63TTuTU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC0l7SXaXGVTD0i/8RAu7GAJ92LtWUaRCTBJa+Zlt2cx4rsvZnqACfZC0j
pELE4LtLsZ5Y1tfymsx2uXE=
=JAJ5
-----END PGP SIGNATURE-----

--xQR6quUbZ63TTuTU--
