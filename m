From: Harald Welte <laforge@netfilter.org>
Subject: Re: ULOG / netlink errors
Date: Thu, 16 Dec 2004 14:41:27 +0100
Message-ID: <20041216134127.GI10165@sunbeam.de.gnumonks.org>
References: <20041128113728.GA17226@oasis.frogfoot.net>
	<41AA3723.9070708@eurodev.net> <41AA39FC.1000400@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zOcTNEe3AzgCmdo9"
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>,
	Abraham van der Merwe <abz@frogfoot.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <41AA39FC.1000400@eurodev.net>
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


--zOcTNEe3AzgCmdo9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 28, 2004 at 09:50:04PM +0100, Pablo Neira wrote:
> Pablo Neira wrote:
>=20
> >this is ok, it's always a good idea to reduce the probability of an=20
> >overflow. But I think that you'll have problems anyway with traffers=20
> >rates bigger than ~20 Mbits/s.
>=20
>=20
> well, this is true in ip_queue, don't know in ipt_ULOG, it depends on=20
> three/four parameters.

just to let you know: there are people doing ULOG based acounting on >=3D
100MBit.  So it's not as bad as you think it is ;)

[no, I'm not advertising the use of ulog for accounting.  That's not
what it was menat for].

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--zOcTNEe3AzgCmdo9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBwZCHXaXGVTD0i/8RAmMDAJ9I9iakRinX7ztkXdD9VII4KHx+3wCfedJh
ov04RsRaO2ZHgc5eY2CzqHU=
=zhot
-----END PGP SIGNATURE-----

--zOcTNEe3AzgCmdo9--
