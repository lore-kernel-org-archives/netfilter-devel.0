From: Harald Welte <laforge@netfilter.org>
Subject: Re: 2.6.12: connection tracking broken?
Date: Mon, 20 Jun 2005 09:19:17 +0200
Message-ID: <20050620071917.GM9491@obroa-skai.de.gnumonks.org>
References: <20050618124359.39052.qmail@web52901.mail.yahoo.com>
	<Pine.LNX.4.61.0506181656250.20828@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7vLGWvOrvbSM0Ba8"
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	Chris Rankin <rankincj@yahoo.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0506181656250.20828@yvahk01.tjqt.qr>
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


--7vLGWvOrvbSM0Ba8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 18, 2005 at 04:57:49PM +0200, Jan Engelhardt wrote:
> You forget about INPUT and OUTPUT. If you drop everything in INPUT, there=
's=20
> nothing to FORWARD.

he was talking about iptables, not ipchains.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--7vLGWvOrvbSM0Ba8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCtm31XaXGVTD0i/8RArpiAKCQ+IEzLA/WSzMyhFcscLqQN6RgQACgjBxA
i9qo/sja6oLo951810LnlCM=
=Aa3m
-----END PGP SIGNATURE-----

--7vLGWvOrvbSM0Ba8--
