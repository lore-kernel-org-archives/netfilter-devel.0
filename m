From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Disallow newlines in LOG target --log-prefix
Date: Fri, 1 Apr 2005 09:03:38 +0200
Message-ID: <20050401070338.GS19835@sunbeam.de.gnumonks.org>
References: <20050329193422.GA12848@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9Hhx61DPNOHVwUu9"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
Content-Disposition: inline
In-Reply-To: <20050329193422.GA12848@linuxace.com>
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


--9Hhx61DPNOHVwUu9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thanks again, Phil.

On Tue, Mar 29, 2005 at 11:34:22AM -0800, Phil Oester wrote:
> As reported in bugzilla, iptables currently does not complain about
> the following:
>=20
> # iptables -A foo -j LOG --log-prefix 'asdfasdfa
> asdf'
>=20
> Patch below makes it complain, and closes bugzilla #312.

Sending        extensions/libip6t_LOG.c
Sending        extensions/libipt_LOG.c
Transmitting file data ..
Committed revision 3819.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--9Hhx61DPNOHVwUu9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCTPJKXaXGVTD0i/8RAgDFAJsGACQDTT5E7Y3Yz82jwrZ7l1BVSQCdEPEt
/GQ7X58laZwXD8rLS9yRaP0=
=OJnr
-----END PGP SIGNATURE-----

--9Hhx61DPNOHVwUu9--
