From: Harald Welte <laforge@netfilter.org>
Subject: Re: Sample iptables commands page
Date: Sat, 14 Feb 2004 21:27:08 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040214202708.GW7756@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0402112347290.2555-100000@sparrow>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nbjgUHX6eyHhY7pW"
Cc: ML-netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: William Stearns <wstearns@pobox.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0402112347290.2555-100000@sparrow>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--nbjgUHX6eyHhY7pW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 11, 2004 at 11:51:32PM -0500, William Stearns wrote:
> Good day, all,
> 	I've put together a page with sample iptables firewall rules using=20
> a number of different modules:
>=20
> http://www.stearns.org/modwall/sample/sample-rules.html

thanks a lot!

> 	I'm writing in because at one point there was a placeholder on the=20
> Netfilter web site for examples, which to the best of my memory was never=
=20
> populated.

yes, unfortunately.

> 	Could I interest the core team members in having either a) a
> pointer sent off to one of the above links under examples on the netfilter
> web site, or b) allowing me to provide all the files in that directory for
> direct placement on the netfilter web?

I would love to give you access to CVS to be able to upload your example
pages.

However, what I would even like more:  To integrate your samples with
the netfilter-extensions howto.   Maybe rename that howto to something
totally different, but I think there should be one place where we have a
detailed description (including exaples) for almost any of our
matches/targets.

If all this would be put together (and maybe even augmented by including
auto-generated syntax reference from iptables -m foo --help), _AND_ it
would in the end generate either docbook XML or docbook-website XML,=20
you would be my personal hero.

Interested?

> 	Cheers,
> 	- Bill
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--nbjgUHX6eyHhY7pW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFALoScXaXGVTD0i/8RAqL6AJ9F7ZiKdt5HRJSsPJgY/BCGpyp2ugCePCK2
o+YB1i70Xg3ZLFGBe8UZj+U=
=kWOk
-----END PGP SIGNATURE-----

--nbjgUHX6eyHhY7pW--
