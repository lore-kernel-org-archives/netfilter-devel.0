From: Harald Welte <laforge@netfilter.org>
Subject: New Version (1.13) of PPTP conntrack/nat helper
Date: Mon, 22 Sep 2003 22:30:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030922203033.GD31401@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wwU9tsYnHnYeRAKj"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wwU9tsYnHnYeRAKj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I've just released the long-awaited new version of the PPTP
conntrack/NAT helper.  It can be found in the current patch-o-matic CVS,
or in the CVS snapshot that is going to be created tonight
(patch-o-matic-20030922).

It has been working in my test network with four PPTP clients, in mixed
DNAT, SNAT and local (i.e. terminated on a PPTPD on the NAT gw itself)
connection setup - both with and without CONFIG_IP_NF_NAT_LOCAL.

Please feel free to test this new patch and report any bugs/errors back
to me.

Thanks to everybody who has contibuted to the PPTP helper in the past,
and thanks for your patience in waiting for this release.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wwU9tsYnHnYeRAKj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/b1vpXaXGVTD0i/8RAlarAKCXZbAFe91ukWH32bRmZjg0WH0rJQCfcUS5
T4MOt9j8cmWewEOP66bnQhw=
=0VTL
-----END PGP SIGNATURE-----

--wwU9tsYnHnYeRAKj--
