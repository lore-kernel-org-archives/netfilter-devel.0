From: Harald Welte <laforge@gnumonks.org>
Subject: Re: How to add nat rules by another loadable kernel module
Date: Wed, 30 Oct 2002 09:47:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021030094744.P8635@sunbeam.de.gnumonks.org>
References: <F17677bieLYCT4aJ6pk00000164@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9axOBMfiLLqytT81"
Cc: netfilter-devel@lists.samba.org, andrekleibeuker@hotmail.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "andre achternaam" <andreiscmeel@hotmail.com>
Content-Disposition: inline
In-Reply-To: <F17677bieLYCT4aJ6pk00000164@hotmail.com>; from andreiscmeel@hotmail.com on Thu, Oct 24, 2002 at 09:26:49AM +0000
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--9axOBMfiLLqytT81
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2002 at 09:26:49AM +0000, andre achternaam wrote:
> I'm aware this is a userspace methode to do it, and i like to know how to=
 do=20
> this in kernel space. I have looked hours in all kind of netfilter files =
but=20
> i don't have any hint how to do it.
>=20
The answer will not satisfy you:

You don't do this in kernel space.   There is no API for doing this, and no
code inside the kernel which can actually create ip_tables. Everything is
in libiptc in userspace.

> Andre Kleibeuker
=20

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--9axOBMfiLLqytT81
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9v5yvXaXGVTD0i/8RAks9AKCLslVQgT/LezTEAgzklFQJiSDyiACgqWzd
OJ/2y8HdDwGKeWDnHkZ4zUQ=
=ZEaj
-----END PGP SIGNATURE-----

--9axOBMfiLLqytT81--
