From: Harald Welte <laforge@netfilter.org>
Subject: Re: Netfilter support for Sharp Zaurus
Date: Thu, 2 Oct 2003 22:07:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002200705.GE5758@sunbeam.de.gnumonks.org>
References: <10345.1064847089@www17.gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sK3tnqsryejqK5ko"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jaume Ribot Caner <jaumerc@gmx.net>
Content-Disposition: inline
In-Reply-To: <10345.1064847089@www17.gmx.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--sK3tnqsryejqK5ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2003 at 04:51:29PM +0200, Jaume Ribot Caner wrote:
> Hi all,
>=20
> I have some trouble trying to add netfilter modules to the PDA Sharp Zaur=
us
> 5500. I have the linux kernel version linux-2.4.6-rmk1-np2-embedix, the o=
ne
> used in the Zaurus. I have compiled the kernel (without errors) including=
 the
> corresponding netfilter support (all as modules). Then, I compiled the
> modules (make modules) and then installed (make modules_install).=20

The error messages you are reading look like you have a kernel (probably
still an old one) with no CONFIG_NETFILTER enabled and are then trying
to load netfilter modules later on.


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--sK3tnqsryejqK5ko
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fIVoXaXGVTD0i/8RAnb+AJ4hMh2q2uNaQ7tc4q6tuJJMU2sQewCgopZc
fMfLxTjNqrBA2JOo1rC69Aw=
=yBJV
-----END PGP SIGNATURE-----

--sK3tnqsryejqK5ko--
