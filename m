From: Alexander Samad <alex@samad.com.au>
Subject: Usagi IPv6 Conntrack
Date: Wed, 7 Jul 2004 17:31:41 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040707073141.GJ22729@samad.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YrlhzR9YrZtruaFS"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--YrlhzR9YrZtruaFS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

I remember seeing some email before about ipv6 conntracking, is sombody
looking into bring this across into netfilter or the kernel (sorry not
sure of the path it would normally take either usagi -> netfilter ->
kernel or usagi -> kernel).

Does any one have a set of patches or a procedure to merge in the usagi
net/ipv6/netfiler stuff. =20

Can I just replace the one in my kernel tree (using a debian base) with
the usagi directory ?

Thanks
Alex

--YrlhzR9YrZtruaFS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA66bdkZz88chpJ2MRAtLbAKC6+PN2uzODBEEDjAUyEAHSBKzOLQCg8C62
AQ9dcBqTf5I0+1Z6+RdFVDg=
=ULli
-----END PGP SIGNATURE-----

--YrlhzR9YrZtruaFS--
