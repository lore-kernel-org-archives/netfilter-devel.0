From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink questions
Date: Sat, 14 Feb 2004 21:03:26 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040214200326.GQ7756@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.33.0310200909590.12485-100000@blackhole.kfki.hu> <Pine.LNX.4.44.0310201107510.23768-100000@filer.marasystems.com> <20040206185242.GM2312@obroa-skai.de.gnumonks.org> <4028D0E5.8000003@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hSZb4FHl1C2xfsUy"
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4028D0E5.8000003@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--hSZb4FHl1C2xfsUy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 10, 2004 at 01:39:01PM +0100, Patrick McHardy wrote:
> I can make my peace with not having a unique identity for each conntrack
> over time,=20

Thanks :)

> but the other use for IDs was to continue an interrupted
> dump at the right place, how can we solve this ? The problematic case
> is when a single hash-chain doesn't fit into an skb. We need to remember
> the last one dumped somehow, and be able to continue at the next one
> not dumped even when the last one dumped is gone when the dump
> continues.

We'd have to ensure that a single hash chain is not longer than what we
could put into one skb.  This can be done by limiting the maximum number
of entries in a bucket (and then rehash).  Also, we should increase the
default number of hash buckets to reduce the probability that this might
happen.

Also, Jozsef proposed a flip/flop bit mechanism that would solve that
problem.  What do you say to his proposal?

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

--hSZb4FHl1C2xfsUy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFALn8OXaXGVTD0i/8RAg2YAJwLrkjCoVonEYUkpgZV36Sizsp2bQCfZhha
7H0DpdQlHGlmNjUjVEbVv/I=
=oVn/
-----END PGP SIGNATURE-----

--hSZb4FHl1C2xfsUy--
