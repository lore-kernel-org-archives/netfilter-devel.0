From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]  libipt_condition.c and libip6t_condition.c
Date: Sun, 27 Apr 2003 14:57:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427125706.GF990@sunbeam.de.gnumonks.org>
References: <3EA4C5E4.6010808@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B3XPdYri2NuANWBV"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephane Ouellette <ouellettes@videotron.ca>
Content-Disposition: inline
In-Reply-To: <3EA4C5E4.6010808@videotron.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--B3XPdYri2NuANWBV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2003 at 12:32:36AM -0400, Stephane Ouellette wrote:
> Harald,
>=20
>   the following two patches move the call to check_inverse() to a saner=
=20
> place and surround the condition name by double-quotes in save().
>=20
>   Please apply.

applied to cvs, thanks.

> Stephane.


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--B3XPdYri2NuANWBV
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q9OiXaXGVTD0i/8RAiXmAJ9qNOXTSTQhpUBpW8JzWvVKJy5OlACglh+V
eSxr4LvacxejobOL13B5AYs=
=9UZs
-----END PGP SIGNATURE-----

--B3XPdYri2NuANWBV--
