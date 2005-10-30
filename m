From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables & new CONNMARK 32bit marks
Date: Sun, 30 Oct 2005 10:43:49 +0100
Message-ID: <20051030094349.GZ4479@sunbeam.de.gnumonks.org>
References: <435D0456.60405@fliegl.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MoTbte+PTqanp4Nm"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Deti Fliegl <deti@fliegl.de>
Content-Disposition: inline
In-Reply-To: <435D0456.60405@fliegl.de>
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


--MoTbte+PTqanp4Nm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 24, 2005 at 05:57:10PM +0200, Deti Fliegl wrote:
> Hello *,
>=20
> when using kernel 2.6.14rc5 the mark values have become 32bit but
> latest iptables code still uses 64bit values.=20

It sends a 64bit value to the kernel, there's nothing wrong with that.
The kernel is able to parse that.

> This causes the kernel module to say "CONNMARK: Only supports 32bit
> mark"=20

This should only happen if you actually specify a mark that is bigger
than 0xffffffff. =20

Please post the specific rules in case of any doubt.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--MoTbte+PTqanp4Nm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDZJXVXaXGVTD0i/8RAsXLAJ41yWeQRvZoPZxD5FqdAHI6CsM3BACgqwDc
cMMhtaf77KZD1isYJMj/sE4=
=vp37
-----END PGP SIGNATURE-----

--MoTbte+PTqanp4Nm--
