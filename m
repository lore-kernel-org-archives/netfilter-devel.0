From: Harald Welte <laforge@gnumonks.org>
Subject: Re: ip_tables.h does not compile when using g++
Date: Sun, 15 Sep 2002 13:20:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020915132007.H3810@sunbeam.de.gnumonks.org>
References: <1032005243.9337.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xm2jbj1ALIzH4cD6"
Cc: netfilter List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott Andrew Baillie <sbaillie@bigpond.net.au>
Content-Disposition: inline
In-Reply-To: <1032005243.9337.19.camel@localhost.localdomain>; from sbaillie@bigpond.net.au on Sat, Sep 14, 2002 at 12:07:22PM +0000
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--xm2jbj1ALIzH4cD6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 14, 2002 at 12:07:22PM +0000, Scott Andrew Baillie wrote:
> The file linux-2.4.19/include/linux/netfilter_ipv4/ip_tables.h is
> included by user space programs as well as the kernel, hence I think
> that it should compile using g++.

You are right.

> This patch makes it compile. Patch is also attached.
>=20
>=20
> diff -ur linux-2.4.19/include/linux/netfilter_ipv4/ip_tables.h
> linux-2.4.19-new/include/linux/netfilter_ipv4/ip_tables.h
> --- linux-2.4.19/include/linux/netfilter_ipv4/ip_tables.h	Mon Feb 25
> 19:38:13 2002
> +++ linux-2.4.19-new/include/linux/netfilter_ipv4/ip_tables.h	Sat Sep 14
> 11:11:01 2002
> @@ -292,7 +292,7 @@
>  static __inline__ struct ipt_entry_target *
>  ipt_get_target(struct ipt_entry *e)
>  {
> -	return (void *)e + e->target_offset;
> +	return ((struct ipt_entry_target *)((char *)e + e->target_offset));

why does it have to be (char *) ? There are no characters involved, hence
it (in the spirit of this gcc extension) should be (void *).

The typecast to struct ipt_entry_target is correct, however.

Does it compile with=20

	return ((struct ipt_entry_target *)((void *)e + e->target_offset));

If yes, I will submit this modified version of  your patch.

> Regards,
> Scott.



--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--xm2jbj1ALIzH4cD6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9hGznXaXGVTD0i/8RAs6tAJ4pBdBJpBiQu6QwxK+LBjSQvA+WsACggjji
oW1DxIFOlF3XrUSxrO4I0Gk=
=SyRb
-----END PGP SIGNATURE-----

--xm2jbj1ALIzH4cD6--
