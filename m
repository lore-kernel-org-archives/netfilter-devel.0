From: Harald Welte <laforge@netfilter.org>
Subject: Re: terminating connections when an interface goes down
Date: Wed, 17 Mar 2004 15:01:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040317140153.GC21899@sunbeam.de.gnumonks.org>
References: <21127330.20040315130231@anime-h.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yVhtmJPUSI46BTXb"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: MaXxX <maxxx@anime-h.com>
Content-Disposition: inline
In-Reply-To: <21127330.20040315130231@anime-h.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 15, 2004 at 01:02:31PM +0100, MaXxX wrote:
> Hello.
>=20
> Having recently switched to a faster ISP but with dynamically assigned
> (and forcibly changed every 24h) IP, I'd like netfilter to TERMINATE
> all active connections when the IP changes. Some programs behave very
> badly when their connections are left to time out, and some services
> ban a user for quite a long time when they detect a double login (and
> that's how a timeout-IPchange-relogin sequence looks to them)... I
> believe that for many dynamic IP users this might be a great addition
> to netfilter, and I'd be willing to code it in, abilities permitting.

Something like this has been proposed in the past (like a REJECT target
sending packets both ways).  However, we agreed that this causes way
more complex problems than it solves.  What if any of your packets are
lost?  What should deal with retransmissions inside the kernel? ...

> Thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--yVhtmJPUSI46BTXb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAWFpRXaXGVTD0i/8RAqusAJwIhmCq2P9QNB4JQJA4xOYyIwnvNwCfaYca
BbMOWcKpiRst42U7gwGn2ag=
=WTQr
-----END PGP SIGNATURE-----

--yVhtmJPUSI46BTXb--
