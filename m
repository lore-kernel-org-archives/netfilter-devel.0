From: Florian Lohoff <flo@rfc822.org>
Subject: Re: REJECT target / need-fragment ?
Date: Tue, 12 Apr 2005 00:31:44 +0200
Message-ID: <20050411223144.GA13620@paradigm.rfc822.org>
References: <20050314125747.GA18233@paradigm.rfc822.org>
	<42373578.8060806@trash.net>
	<20050406113859.GA5335@paradigm.rfc822.org>
	<20050410203008.GP9155@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20050410203008.GP9155@sunbeam.de.gnumonks.org>
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


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 10, 2005 at 10:30:08PM +0200, Harald Welte wrote:
>=20
> thanks, looks fine to me.  I've applied the userspace part and put the
> kernel part into my list of pending patches.
>=20

The kernel part needs an intialization in _v1 for the pmtu value -
Otherwise we leak the short pmtu as it gets used uninitialized.
Probably 1500 is a good value.

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
                        Heisenberg may have been here.

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCWvrQUaz2rXW+gJcRAm4yAJ983Fjsi2qZHQHEusARXbYoiYwITACgvgrt
zMbiFjsgcS5jCBpDK3tFs6o=
=YRGV
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
