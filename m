From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: Having trouble building a new connection tracker helper module
Date: Wed, 9 Mar 2005 00:01:34 +0100
Message-ID: <20050308230134.GA9661@zion.homelinux.com>
References: <8B888AAAAB0FD31189590008C79184432644807B@zbl6c002.corpeast.baynetworks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Cc: netfilter-devel@lists.netfilter.org
To: Chad Goss <chgoss@nortel.com>
Content-Disposition: inline
In-Reply-To: <8B888AAAAB0FD31189590008C79184432644807B@zbl6c002.corpeast.baynetworks.com>
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


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Chad,

On Tue, Mar 08, 2005 at 05:38:39PM -0500, Chad Goss told us:
> Hi folks,
>=20
> I am trying to compile a new connection tracker helper module, I have
> 1) downloaded 2.6.10 kernel source=20
>=20
> 2) built a fresh kernel from that source
>=20
> 3) created a new file "ip_conntrack_cftp.c" in
> $KERNEL_DIR/net/ipv4/netfilter/
>   (basically just copied the file ip_conntrack_tftp.c and changed all of
> "tftp" text to "cftp", "TFTP" to "CFTP"
>=20
> 4) created a new file "ip_conntrack_cftp.h" in
> $KERNEL_DIR/include/linux/netfilter_ipv4,=20
>   (copied ip_conntrack_tftp.h to ip_conntrack_cftp.h and made the
> adjustments to the text strings)
>=20
> 5) updated the $KERNEL_DIR/net/ipv4/netfilter/Makefile adding a line
> 	# connection tracking helpers
> 	obj-$(CONFIG_IP_NF_CFTP) +=3D ip_conntrack_cftp.o
> =09

probably missing:

5a) copy the config IP_NF_TFTP entry and the lines following it in file
    $KERNEL_DIR/net/ipv4/netfilter/Kconfig
    and adjust TFTP to CFTP in the copy

5b) make menuconfig in $KERNEL_DIR, select the new CFTP entry

>=20
> 6) attempted to make that directory "make -C $KERNEL_DIR  M=3D`pwd`
> 	(executed from $KERNEL_DIR/net/ipv4/netfilter/ )

don't know if it might be better just to call make from $KERNELDIR


HTH

Sven

>=20
>=20
> But, I don't see any .ko, or .o or .mod.c files getting created... What s=
tep
> am I missing?
>=20
> Thanks in advance
> -chad
>=20
>=20
>=20
>=20

--=20
Linux zion 2.6.11-mm1 #1 Sat Mar 5 13:54:40 CET 2005 i686 athlon i386 GNU/L=
inux
 23:57:01 up 3 days,  3:02,  2 users,  load average: 0.01, 0.05, 0.06

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFCLi7Oo4FAdB2PneQRAtifAJ9lITmyMQW6oiJ0MVwrIi0Yc8l9zwCdHgrx
rSt5QeGeGtizUX6QfoTqJCk=
=zsDr
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
