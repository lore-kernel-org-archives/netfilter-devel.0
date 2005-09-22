From: Harald Welte <laforge@netfilter.org>
Subject: Re: 2.6.14-rc1 ip_conntrack lockup.
Date: Thu, 22 Sep 2005 14:24:39 +0200
Message-ID: <20050922122439.GD26520@sunbeam.de.gnumonks.org>
References: <20050919.231333.74747459.sowhat@amnis.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yoshihiro Kawabe <sowhat@amnis.co.jp>
Content-Disposition: inline
In-Reply-To: <20050919.231333.74747459.sowhat@amnis.co.jp>
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


--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 19, 2005 at 11:13:33PM +0900, Yoshihiro Kawabe wrote:
> Hello folks,
>=20
> I have experinced a `soft lockup' with ip_conntrack.
>=20
> Kernel version: 2.6.14-rc1
>=20
> CONFIG_IP_NF_CONNTRACK=3Dm
> CONFIG_IP_NF_CT_ACCT=3Dy
> CONFIG_IP_NF_CONNTRACK_MARK=3Dy

> CONFIG_IP_NF_CONNTRACK_EVENTS=3Dy

please disable CONNTRACK_EVENTS for now, we're working on a fix.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDMqKHXaXGVTD0i/8RAhUlAKCvFDddbmtJB63lbC2Le1ocVU0xIQCdE76M
SG2Ai59OFmzWjPY3iZLGvVU=
=FNty
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
