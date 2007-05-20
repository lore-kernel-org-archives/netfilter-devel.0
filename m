From: Elimar Riesebieter <riesebie@lxtec.de>
Subject: 2.6.22-rc2 built on ppc
Date: Sun, 20 May 2007 13:18:09 +0200
Message-ID: <20070520111809.GG3253@aragorn.home.lxtec.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JbKQpFqZXJ2T76Sg"
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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


--JbKQpFqZXJ2T76Sg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

FYI, building the kernel with
gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
on my powerbook (PPC) gives:
=2E..
ipc/msg.c: In function 'sys_msgctl':
ipc/msg.c:390: warning: 'setbuf.qbytes' may be used uninitialized in this f=
unction
ipc/msg.c:390: warning: 'setbuf.uid' may be used uninitialized in this func=
tion
ipc/msg.c:390: warning: 'setbuf.gid' may be used uninitialized in this func=
tion
ipc/msg.c:390: warning: 'setbuf.mode' may be used uninitialized in this fun=
ction
ipc/sem.c: In function 'sys_semctl':
ipc/sem.c:861: warning: 'setbuf.uid' may be used uninitialized in this func=
tion
ipc/sem.c:861: warning: 'setbuf.gid' may be used uninitialized in this func=
tion
ipc/sem.c:861: warning: 'setbuf.mode' may be used uninitialized in this fun=
ction
=2E..

If more info is needed, please contact me via PM, as I am not
subscribed.

Thanks for your patience
Elimar

--=20
  Never make anything simple and efficient when a way=20
  can be found to make it complex and wonderful ;-)

--JbKQpFqZXJ2T76Sg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGUC5x3Ig8bsVPf7ARAu98AKCXhdZdXun2LDaY5HddKiB3+lNmkgCfaoEk
lnyU395eFxWgf4xi8XKWQ2c=
=vv3D
-----END PGP SIGNATURE-----

--JbKQpFqZXJ2T76Sg--
