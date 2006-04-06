From: Harald Welte <laforge@netfilter.org>
Subject: Re: Multiple programs for QUEUE target
Date: Thu, 6 Apr 2006 15:13:06 +0200
Message-ID: <20060406131306.GS20558@sunbeam.de.gnumonks.org>
References: <859616420604040655h6312ac86g3c8661c29bf4c7e5@mail.gmail.com>
	<859616420604040702g1e74bcacr2115fb36e0e7298e@mail.gmail.com>
	<20060405152409.GH20558@sunbeam.de.gnumonks.org>
	<859616420604060350q379873b4j5b7e27c71958b93b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RHdRtM27np9fZUoh"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Vogt <beunlovable@gmail.com>
Content-Disposition: inline
In-Reply-To: <859616420604060350q379873b4j5b7e27c71958b93b@mail.gmail.com>
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


--RHdRtM27np9fZUoh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 06, 2006 at 12:50:05PM +0200, David Vogt wrote:
> 2006/4/5, Harald Welte <laforge@netfilter.org>:
> > On Tue, Apr 04, 2006 at 04:02:41PM +0200, David Vogt wrote:
> > Please don't use any of that old 'crap' (I'm the author, so I can call
> > it that).  These days, you use NFQUEUE, nf_queue, nfnetlink_queue,
> > libnetfilter_queue, and you get up to 65535 distinct queues for
> > different userespace processes.
>=20
> Is it possible to run libnetfilter_queue and libipq (for old
> applications) in parallel? I did some testing and it doesn't seem to
> work.

you can run the libraries in parallel, but not the kernel code.

Why would you want to do that anyway?  libnetfilter_queue provides a
backwards compatibility API for libipq apps.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--RHdRtM27np9fZUoh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFENRPiXaXGVTD0i/8RAtewAJ4ve3jTk/oplsa5Qu4EZpdm7QhurwCeOg78
ZJtmTwSI2x83qA+54xOZyxo=
=D4l4
-----END PGP SIGNATURE-----

--RHdRtM27np9fZUoh--
