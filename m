From: Harald Welte <laforge@netfilter.org>
Subject: Re: Linux 2.6 support for "rope" match module
Date: Fri, 6 Jan 2006 15:49:21 +0100
Message-ID: <20060106144921.GG4898@sunbeam.de.gnumonks.org>
References: <43BA5CCB.6050207@lowth.com>
	<Pine.LNX.4.61.0601051117590.21555@yvahk01.tjqt.qr>
	<43BCFE09.9070303@lowth.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mESvsTwIEF2q5u1f"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Chris Lowth <chris@lowth.com>
Content-Disposition: inline
In-Reply-To: <43BCFE09.9070303@lowth.com>
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


--mESvsTwIEF2q5u1f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 05, 2006 at 11:07:53AM +0000, Chris Lowth wrote:
> Jan Engelhardt wrote
>=20
> >That almost feels like doing floating-point in kernelspace.
> >=20
> In what sense?

Chris, see, you might be new to this, so I give you some hints:

A number of people (in)frequently attempt to do a couple of things that
just ring all the alarm bells of kernel hackers.  Some of those are:

1) c++ in the kernel
2) bytecode interpreters (e.g. forth) in the kernel
3) floating point in the kernel

So while your rope module might solve your problems, you will have a
hard time finding anyone who thinks it is the right solution, and that
is independent of whatever the problem might be.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--mESvsTwIEF2q5u1f
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDvoNxXaXGVTD0i/8RAliHAJ9fryTO4LrljI0V1bq2GCKJA3KJKACaAkmq
NLR60eXPb2Nxi9/cSl9ZUFU=
=t09o
-----END PGP SIGNATURE-----

--mESvsTwIEF2q5u1f--
