From: Alexander Samad <alex@samad.com.au>
Subject: Re: MARK-Operations problems
Date: Thu, 8 Jul 2004 12:18:02 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040708021802.GL6161@samad.com.au>
References: <20040707115753.GA22265@samad.com.au> <Pine.LNX.4.44.0407080210100.9492-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YQEH9CATo+4lan7A"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0407080210100.9492-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--YQEH9CATo+4lan7A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 08, 2004 at 02:10:40AM +0200, Henrik Nordstrom wrote:
> On Wed, 7 Jul 2004, Alexander Samad wrote:
>=20
> > I build a static linked iptables for testing but when I attempt to run
> > this command=20
> >=20
> > iptables -t mangle -I PREROUTING 1  -j MARK  --or-mark 0x1
> > I get iptables: Target problem
> > and this is dmesg MARK: targinfosize 8 !=3D 4
>=20
> Looks to me like you are running a patched iptables userspace command on
> an unpatched kernel...

Double checked this and I am pretty sure its pacthed all the right
modules are there (the ones that are created with the patch), the
strange bit is even a working command -j MARK --set-mark 0x01 fails with
the same error, but the unpatched iptables doesn't on the same patches
kernel

>=20
> Regards
> Henrik
>=20
>=20

--YQEH9CATo+4lan7A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA7K7akZz88chpJ2MRAsqQAKCh7ckGB4nFJAWMnsnr/AyVcKQQyACeO/Qe
ZLpUSMZ7oLgeVz3YnqLnlIo=
=PQcD
-----END PGP SIGNATURE-----

--YQEH9CATo+4lan7A--
