From: Harald Welte <laforge@netfilter.org>
Subject: Re: Multiple programs for QUEUE target
Date: Wed, 5 Apr 2006 17:24:09 +0200
Message-ID: <20060405152409.GH20558@sunbeam.de.gnumonks.org>
References: <859616420604040655h6312ac86g3c8661c29bf4c7e5@mail.gmail.com>
	<859616420604040702g1e74bcacr2115fb36e0e7298e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bi5JUZtvcfApsciF"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Vogt <beunlovable@gmail.com>
Content-Disposition: inline
In-Reply-To: <859616420604040702g1e74bcacr2115fb36e0e7298e@mail.gmail.com>
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


--bi5JUZtvcfApsciF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04, 2006 at 04:02:41PM +0200, David Vogt wrote:
> 2006/4/4, David Vogt <beunlovable@gmail.com>:
> > I am sure I read something about a "dispachter"-like program,
> > but I can't find it.
>=20
> Of course I found it right after posting to the list. ipqmpd it is
> called, however, it requires rewriting the program to some extend.
> Since this is not possible for the closed source program, any advice
> on how a solution to that problem might look like are highly
> appreciated.

Please don't use any of that old 'crap' (I'm the author, so I can call
it that).  These days, you use NFQUEUE, nf_queue, nfnetlink_queue,
libnetfilter_queue, and you get up to 65535 distinct queues for
different userespace processes.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--bi5JUZtvcfApsciF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFEM+EZXaXGVTD0i/8RAjdEAJwMLpV85PBA1fOA5RMFvZBVcSYyqwCgrT96
UdTPigj3NbmLYeqicUwM8CE=
=qwUE
-----END PGP SIGNATURE-----

--bi5JUZtvcfApsciF--
