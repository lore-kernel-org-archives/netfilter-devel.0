From: netfilter@interlinx.bc.ca
Subject: Re: [PATCH] Amanda conntrack/nat module update
Date: Sat, 2 Nov 2002 09:35:20 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021102143520.GF16306@pc.ilinx>
References: <20021101232337.GD16306@pc.ilinx> <1036244727.28830.66.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bg2esWel0ueIH/G/"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <1036244727.28830.66.camel@tux>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Bg2esWel0ueIH/G/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 02, 2002 at 02:45:27PM +0100, Martin Josefsson wrote:
> On Sat, 2002-11-02 at 00:23, netfilter@interlinx.bc.ca wrote:
> >=20
> > Please find attached an update patch to patch-o-matic for my Amanda
> > protocol conntrack/nat helper.  This patch corrects a minor error in
> > the Config.in indentation as well as, and more importantly, lengthens
> > the timeout for the master Amanda connection from the default UDP
> > stream timeout (normally 180 seconds) to 300 seconds.

So, I am assuming that the theory and my implementation of a
conntracker extending the timeout for it's own master connection
beyond the default is/was correct?

> Applied,

Thanx!!

b.

--=20
Brian J. Murrell

--Bg2esWel0ueIH/G/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9w+Kol3EQlGLyuXARAi+nAKDWCUUNq3LtOhHWsWL7nEkygHLdzQCcDVYd
hzL59Ej9UDN9esJgvKZff1Q=
=aZDZ
-----END PGP SIGNATURE-----

--Bg2esWel0ueIH/G/--
