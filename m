From: Harald Welte <laforge@netfilter.org>
Subject: Re: Netfilter Queue
Date: Mon, 2 Feb 2004 16:07:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040202150757.GF24449@obroa-skai.de.gnumonks.org>
References: <200402021208.29583.hess@tkn.tu-berlin.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FoLtEtfbNGMjfgrs"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andreas Hess <hess@tkn.tu-berlin.de>
Content-Disposition: inline
In-Reply-To: <200402021208.29583.hess@tkn.tu-berlin.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--FoLtEtfbNGMjfgrs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 02, 2004 at 12:08:27PM +0100, Andreas Hess wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> Hi,
>=20
> I have written a UDP packet processing kernel module that registers itsel=
f to=20
> the PREROUTING hook of the Netfilter architecture. Now, each UDP packet t=
hat=20
> arrives at this hook is passed  to my module.=20

this is exactly what you wanted to do.  If you register to a hook in the
stack, you will get all packets traversing that point in the stack.

This is what netfilter is all about!!

I think you might have a general misconception about what netfilter is.

> As far as I understand it: there are module-specific queues, in which the=
=20
> packets are inserted?

no, why should there be any queues?

> I would like to realize a means to adapt the queue length respectively th=
e=20
> amount of packets waiting to be processed by a module according the curre=
nt=20
> traffic load. (high traffic load -> short queue length).
>=20
> Is such a thing possible?

no, you are called inline in the network RX softirq.  There is only a
single backlog queue between hardirq and softirq in front of you.

> Andreas

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--FoLtEtfbNGMjfgrs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAHmfNXaXGVTD0i/8RArHLAKCzM/2SOj0FlfAqKlUUGVU9oQ5lNgCePaM6
HGp/gX4GOsjMWi+mF9ORBeI=
=PDCT
-----END PGP SIGNATURE-----

--FoLtEtfbNGMjfgrs--
