From: netfilter@interlinx.bc.ca
Subject: Re: [NF-HIPAC] Performance test results available
Date: Thu, 24 Oct 2002 19:26:35 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021024232634.GF23228@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H4SyuGOnfnj3aJqJ"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
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


--H4SyuGOnfnj3aJqJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Can a conntrack/nat helper alter the timeout of the master connection?
In my case it's a UDP connection and the reply to the UDP request can
be as long as 5 minutes in replying.  The protocol I am working with
requires a helper to set up related connections, but I am wondering if
I can also extend the timeout of the master connection in the helper.

Thanx,
b.

--=20
Brian J. Murrell

--H4SyuGOnfnj3aJqJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9uIGql3EQlGLyuXARAv93AKDqIuHHw89SMYfcgYZ4WYk6Njz6twCeKlEo
3xP9Hp1cm6xDMdBuSVhm63o=
=e9tL
-----END PGP SIGNATURE-----

--H4SyuGOnfnj3aJqJ--
