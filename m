From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Introducing the Change API
Date: Fri, 17 Dec 2004 09:08:55 +0100
Message-ID: <20041217080854.GC11436@sunbeam.de.gnumonks.org>
References: <41B236F6.9090405@eurodev.net> <41B36E59.5020800@trash.net>
	<20041216124049.GF10165@sunbeam.de.gnumonks.org>
	<41C26E97.8000805@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8X7/QrJGcKSMr1RN"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <41C26E97.8000805@trash.net>
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


--8X7/QrJGcKSMr1RN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 17, 2004 at 06:28:55AM +0100, Patrick McHardy wrote:
> >Actually I only want to do some nf_conntrack vs. ip_conntrack
> >benchmarking, which I never got aroun doing up to now :(  With a little
> >luck, I can do this over the weekend.  If the results are acceptable,
> >nf_conntrack will be submitted maybe as soon as 2.6.11.=20
> >=20
> I would like to give it some cleanup first. Since it doesn't need to
> deal with ipchains compatibility there is a lot possible cleanup.
> I will probably do this in the next couple of weeks.

What kind of cleanup are you planning?  the provisions in conntrack are
not that big for the compat stuff... it's more the provisions in nat
(which we don't have yet for nf_conntrack).

I'm willing to put some effort into this.  The question is:  Do we
really need this cleanup before the merge, or can we do it afterwards?

I mean, it seems to be stable - and it's not any more unclean than the
current ip_conntrack code.  And we'll mark it as EXPERIMENTAL first
anyway, so we have more freedom to play with it ;)

> Regards
> Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8X7/QrJGcKSMr1RN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBwpQWXaXGVTD0i/8RAo/vAJ4rQHqPNLAgN0JBGXnEVexIK8HJTwCePbGJ
VtPGbDrvbVR/58Rj63aOIx0=
=OI+Q
-----END PGP SIGNATURE-----

--8X7/QrJGcKSMr1RN--
