From: Harald Welte <laforge@netfilter.org>
Subject: Re: Experimental RTSP modules
Date: Sun, 25 May 2003 14:12:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030525121235.GA4273@naboo>
References: <20030406033532.GA23082@home.tig-grr.com> <20030523195843.GQ3077@sunbeam.de.gnumonks.org> <20030524143023.GA31579@home.tig-grr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030524143023.GA31579@home.tig-grr.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 24, 2003 at 07:30:23AM -0700, Tom Marshall wrote:

> Thank you.
>=20
> I am interested in getting the module into the mainline kernel.  I believe
> this is where the majority of users are.  I have not and will not use p-o=
-m.=20
> I will convert the patch to use kernel coding standards if someone would
> sponsor the change to the 2.4 kernel, but any changes necessary to use p-=
o-m
> will need to be done by someone else because I have zero interest.

It is not a change of the actual code, it's just a different formatting
for the patch.  And as you want to get it into the mainline kernel, you
will have to submit it to the netfilter maintainer(s), which is the
netfilter coreteam (us).

And we prefer patch-o-matic format, since this is the opportunity to
have the code being tested for some time, until we conclude that it is
safe to submit it to the mainline kernel.

Of course you are free to submit in any form, it would just make our
work easier if it was p-o-m.  I think we already receive 95% of the
contributions in this format.

> Well, no feedback so far at all so I have left the code alone for the
> moment.  I'm sure you are familiar with the phenomenon.  ;-)

yes, indeed :)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+0LMyXaXGVTD0i/8RAu7kAKCNVXnBTdkspWnhWgDO6JU0mxGZ9ACdGKmY
N6pg+ZRSUQ2Y6BIfDZLYEbc=
=fEXy
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
