From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2.4] fix ipt_REJECT when used in OUTPUT
Date: Mon, 22 Sep 2003 10:53:26 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030922085326.GF31401@sunbeam.de.gnumonks.org>
References: <20030921144013.GA22223@sunbeam.de.gnumonks.org> <3F6EAFF2.9080303@isfera.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="brEuL7wsLY8+TuWz"
Cc: David Miller <davem@redhat.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Diadon <diadon@isfera.ru>
Content-Disposition: inline
In-Reply-To: <3F6EAFF2.9080303@isfera.ru>
List-Id: netfilter-devel.vger.kernel.org


--brEuL7wsLY8+TuWz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 22, 2003 at 12:16:50PM +0400, Diadon wrote:
> That patch is not work, after patching the kernel problem is not=20
> disappeared!
>=20
> Patch by Patrick is working fine and fix this problem

David, pleas defer applying that patch until further testing is done.

Sorry for the confusion.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--brEuL7wsLY8+TuWz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/briGXaXGVTD0i/8RApMXAJ99Gyk0hjytb1waoRD7GIL3w3NzwgCfZs5e
z47nBbNVEDScmvY3zhetI/g=
=4WFX
-----END PGP SIGNATURE-----

--brEuL7wsLY8+TuWz--
