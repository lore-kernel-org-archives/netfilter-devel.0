From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [netfilter-core] [PATCH] add CONFIG_IP_NF_MASQUERADE_LOCAL
Date: Mon, 3 Feb 2003 16:04:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030203150404.GD27870@sunbeam.de.gnumonks.org>
References: <5.2.0.9.2.20030123121528.02219148@post.webmailer.de>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R9b51G30WkD62Ue3"
Cc: coreteam@netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Stefan (metze) Metzmacher" <metze@metzemix.de>
Content-Disposition: inline
In-Reply-To: <5.2.0.9.2.20030123121528.02219148@post.webmailer.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--R9b51G30WkD62Ue3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 23, 2003 at 12:16:24PM +0100, Stefan (metze) Metzmacher wrote:
> Hi *,
>=20
> I have patches witch allow the masuerading of local packets.
> Now support for DNAT of local packets are in the kernel.
>=20
> But somebody (like me) could need masuerading of local packets.

why do you need MASQUERADE?  isn't SNAT enough?  and SNAT of local
connections is supported by the stock linux kernel for a very long time.

DNAT has been added  recently.

=20
> Feedback please!!!:-)
>=20
> thanks
> metze

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--R9b51G30WkD62Ue3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+PoTkXaXGVTD0i/8RAkNDAJ4rb7fGX5AruXwi9JEhNOil7eV+ygCfd9Bj
Wv32VibFADRT4IXWtU+YGsE=
=oHNQ
-----END PGP SIGNATURE-----

--R9b51G30WkD62Ue3--
