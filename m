From: Harald Welte <laforge@netfilter.org>
Subject: Re: condition and 2.6
Date: Sun, 29 Feb 2004 12:07:11 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040229110711.GJ7790@sunbeam.de.gnumonks.org>
References: <200402290210.35962.lists@egidy.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nqkreNcslJAfgyzk"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: gerd@egidy.de
Content-Disposition: inline
In-Reply-To: <200402290210.35962.lists@egidy.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--nqkreNcslJAfgyzk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 29, 2004 at 02:10:35AM +0100, Gerd v. Egidy wrote:
> Hi Harald,
>=20
> I'm currently using the condition match on a lot of 2.4 machines. I use i=
t to=20
> differentiate between primary provider/secondary provider, remote=20
> administration on/off,...=20
> I like it very much because I don't need to change the rules themselves i=
n a=20
> live production environment anymore and can therefore make my scripts muc=
h=20
> more rule-independant.
>=20
> Now I was playing around a bit with 2.6 and found the following comment f=
rom=20
> you in cvs: "made it 2.4.x only, since I don't like it anyway."

This comment is meant as:

"Since nobody provided us with a 2.6.x port yet, and I have very limited
time for such porting, and I personnaly dislike the condition match
anyway, I marked it as 2.4.x only - since the 2.4.x patch doesn't work
for 2.6.x"

> What do you dislike? Is it the idea or the implementation? Do you know of=
 any=20
> bugs or possible problems in the code - especially with 2.6?

The idea of having /proc files control how the ruleset behaves.  This is
an ugly kludge for our less-than-optimal ruleset change performance.
Apart from that I cannot really see why this has to be solved in the
kernel and not by some userspace daemon that updates the ruleset
whenever a change is needed.

> Kind regards,
> Gerd

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--nqkreNcslJAfgyzk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAQcffXaXGVTD0i/8RAjGrAJ99JInYzYgSHRzlm7XAgN30nHoKngCfSgvy
4DDzZEoj9mJfnFv+bleglSA=
=/2i1
-----END PGP SIGNATURE-----

--nqkreNcslJAfgyzk--
