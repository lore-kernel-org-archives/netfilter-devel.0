From: Harald Welte <laforge@gnumonks.org>
Subject: Re: About a patch to unclean module.
Date: Sat, 22 Jun 2002 18:44:32 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020622184432.C31606@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.21.0206212050210.23485-100000@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IpbVkmxF4tDyP/Kb"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.21.0206212050210.23485-100000@dns.toxicfilms.tv>; from solt@dns.toxicfilms.tv on Fri, Jun 21, 2002 at 09:00:04PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--IpbVkmxF4tDyP/Kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2002 at 09:00:04PM +0200, Maciej Soltysiak wrote:
> Hello,
>=20
> I may say now, that I have finished writing the module, updating the
> lipipt_unclean.c, I have created the patches to the netfilter tree.
>=20
> But, suppose, Harald applies the patch. It will change libipt_unclean.c
> in a way, that withougt running patch-o-matic it will not compile, because
> it uses an include file
> KERNEL_DIR/include/linux/netfilter_ipv4/ipt_unclean.h which will be only
> available after patching the kernel tree.
>=20
> So how do we solve that?

this is a comon problem, and it's always solved the same way: Put the
kernel include file into userspace/include/linux/netfilter_ipv4/.

> Maciej Soltysiak

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

--IpbVkmxF4tDyP/Kb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9FKlwXaXGVTD0i/8RAo8nAKCkbVT9vea/ObeE+OPBuCgQwGjxNQCdGIci
/yLEdT9BUPEHl6ZLG1m6+nM=
=mX7a
-----END PGP SIGNATURE-----

--IpbVkmxF4tDyP/Kb--
