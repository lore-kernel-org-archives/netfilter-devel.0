From: Harald Welte <laforge@gnumonks.org>
Subject: Re: About a patch to unclean module.
Date: Sat, 22 Jun 2002 18:43:25 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020622184325.B31606@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.21.0206212050210.23485-100000@dns.toxicfilms.tv> <200206222251.10087.fabrice@celestix.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Cc: Maciej Soltysiak <solt@dns.toxicfilms.tv>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Fabrice MARIE <fabrice@celestix.com>
Content-Disposition: inline
In-Reply-To: <200206222251.10087.fabrice@celestix.com>; from fabrice@celestix.com on Sat, Jun 22, 2002 at 10:51:10PM +0800
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 22, 2002 at 10:51:10PM +0800, Fabrice MARIE wrote:
>=20
> Hello Maciej,
>=20
> On Saturday 22 June 2002 03:00, Maciej Soltysiak wrote:
> > Hello,
> > I may say now, that I have finished writing the module, updating the
> > lipipt_unclean.c, I have created the patches to the netfilter tree.
> > But, suppose, Harald applies the patch. It will change libipt_unclean.c
> > in a way, that withougt running patch-o-matic it will not compile, beca=
use
> > it uses an include file
> > KERNEL_DIR/include/linux/netfilter_ipv4/ipt_unclean.h which will be only
> > available after patching the kernel tree.
> > So how do we solve that?
>=20
> The easiest way is to use the userspace patching facility of patch-o-mati=
c.

GNAH!  As soon as somebody is using this evil confusing hack without it
being absolutely necessarry, I'll start flaming him.

See my other mail in this thread.

> Fabrice.

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

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9FKksXaXGVTD0i/8RAgRhAJ4lkCB6Wn9JuEkFjII3Z8jqLu3GgwCdHYCm
rcv6EKFXh2l3/9qo68CtwGk=
=hdHr
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
