From: Harald Welte <laforge@netfilter.org>
Subject: Re: Problem with apply patch connlimit to 2.6.10 (debian 2.6.10-6)
Date: Fri, 1 Apr 2005 08:47:51 +0200
Message-ID: <20050401064751.GN19835@sunbeam.de.gnumonks.org>
References: <20050325234332.GD10616@samad.com.au>
	<20050326001504.GE10616@samad.com.au>
	<20050326011742.GA4239@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rBVNTu5JXDAWzN2S"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
Content-Disposition: inline
In-Reply-To: <20050326011742.GA4239@linuxace.com>
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


--rBVNTu5JXDAWzN2S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 25, 2005 at 05:17:42PM -0800, Phil Oester wrote:
> On Sat, Mar 26, 2005 at 11:15:04AM +1100, Alexander Samad wrote:
> > > I have had a look in include/linux/netfilter_ipv4/ip_conntrack.h  and=
 it
> > > seems like the structure has gone  and I am not sure what else I need=
 to
> > > apply to make it compile.
> >=20
> > I noticed on bugszilla there is an open bug about connlimit not
> > compiling on 2.6.11 (Bugzilla Bug 317) and the patch seems to remove any
> > access to infos !  Should i be using the patch attached to this bugzilla
>=20
> Yes, although 317 is a dupe of 268.  The fix is already applied to the=20
> 2.6.11 branch of POM-NG.
>=20
> Which raises the question (Harald?) - can we now make the 2.6.11 branch
> the primary one?

no, we add '2.6.11' directories to the main branch. In fact, 'connlimit'
has such a directory now.  Am I right that the problem is fixed in
pom-trunk?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--rBVNTu5JXDAWzN2S
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCTO6XXaXGVTD0i/8RAp47AJ9moNTHBj4vFq2ksk2zumytg90AuQCgml1J
zEx2gv5oowjctuc9ILQysTY=
=ZGCI
-----END PGP SIGNATURE-----

--rBVNTu5JXDAWzN2S--
