From: Harald Welte <laforge@netfilter.org>
Subject: Re: performance
Date: Wed, 11 Jun 2003 14:16:11 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030611121611.GM32593@sunbeam.de.gnumonks.org>
References: <3EE4B1EB.9090305@draigBrady.com> <3EE4B2E3.2070700@draigBrady.com> <723210746.20030609212730@lf.lv> <3EE59BB2.1070009@draigBrady.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRtZRu2mMGBZ6YQ7"
Cc: Peteris Krumins <newsgroups@lf.lv>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: P@draigBrady.com
Content-Disposition: inline
In-Reply-To: <3EE59BB2.1070009@draigBrady.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wRtZRu2mMGBZ6YQ7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 10, 2003 at 09:49:54AM +0100, P@draigBrady.com wrote:
=20
> yes true. I was making assumptions.
> The following suggests the average cycles:instruction
> ratio is 1.68 I think:
> http://www.cs.berkeley.edu/~pattrsn/252S01/Lec18-dynamic3.pdf
>=20
> Looking again at the system it's actually 2 x 1.4GHz
> So the instructions per match are about:
> ((2.8*10^9)/1.68)/(85000*125) =3D 156
>=20
> With the overhead associated with SMP/kernel/...
> this suggests a figure closer to 120?
> I'm very impressed.

I don't know what kind of weird calculation that would be.  First of
all, why the hack are you adding up the clock rates of your CPU's?  Do
you have any idea how SMP systems work?=20

And then, why do you multiply the pps rate with the size of the packets?
do you think we process every byte of a packet individually?

Let's make a simple calculation for the UP case:

average clock ticks per processed packet:
1.4*10^9/85000 =3D 16470

In order to get any idea about how those clock ticks are distributed
among the various pars of kernel networking, you need to use some means
of profiling.

I advise you to dig into profiling, and exploit all general kernel
networking optimizations (like NAPI, ...) before starting to think about
optimizing iptables.

> So to scale I would have to organise the rules
> into chains that could be bypassed. I wonder is
> there any projects to do this automatically? hmm..

no.

> P=E1draig.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wRtZRu2mMGBZ6YQ7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+5x2LXaXGVTD0i/8RAvrJAJ4/blPzjdQBf7vg5mZIqfrEOi2AWgCfVPNb
dkxn+6bT7ad6kU8NvmcT/+Q=
=PnYx
-----END PGP SIGNATURE-----

--wRtZRu2mMGBZ6YQ7--
