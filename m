From: Harald Welte <laforge@netfilter.org>
Subject: Re: [nf-failover] NAT support for peer-to-peer games
Date: Sat, 25 Sep 2004 09:54:22 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040925075421.GR3236@sunbeam.de.gnumonks.org>
References: <00d901c49fb3$2dea51f0$e310f43e@manowar>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="22aa2PWZKnsI44rM"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Serguei I. Ivantsov" <manowar@gsc-game.kiev.ua>
Content-Disposition: inline
In-Reply-To: <00d901c49fb3$2dea51f0$e310f43e@manowar>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--22aa2PWZKnsI44rM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 21, 2004 at 11:15:38AM +0300, Serguei I. Ivantsov wrote:
> Hello!
>=20
> I just interesting - whether something changes in Netfilter to support
> peer-to-peer games.

You're definitely on the wrong mailinglist.  Please re-post to
netfilter-devel.

> How to implement the scheme described below using netfilter?

netfilter implements draft-ford-natp2p-00, which should address your
problem.

> http://www.hasenstein.com/HyperNews/get/linux-ip-nat/97.html

yes, this is the draft that iptable_nat aims to implement.

>  Serguei I. Ivantsov

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--22aa2PWZKnsI44rM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBVSQtXaXGVTD0i/8RAg7KAJ93XkxOZBtVbVdwg9KhwKLLO7pckQCcDQ8D
Kv4vhIldBMrHGh+8nxZtGfc=
=Kdu4
-----END PGP SIGNATURE-----

--22aa2PWZKnsI44rM--
