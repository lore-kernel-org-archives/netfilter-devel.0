From: Pierre Chifflier <chifflier@cpe.fr>
Subject: Re: [PATCH] update debian packaging
Date: Thu, 8 Mar 2007 14:13:19 +0100
Message-ID: <20070308131319.GA30211@pollux.no-ip.org>
References: <20070306162557.GB7494@cpe.fr> <45F00A03.30405@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <45F00A03.30405@trash.net>
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

On Thu, Mar 08, 2007 at 02:05:07PM +0100, Patrick McHardy wrote:
> Pierre Chifflier wrote:
> > Hi,
> >=20
> > The following patch fixes 3 problems with the debian files in the svn
> > repository:
> > * the.pc file is not copied during installation
> > * the version is outdated
> > * the version in debian/changelog should reflect the number of the
> > debian packaging, and so lacks a -1
>=20
> Applied, thanks.
>=20

Oops, sorry, the previous patch contained some mistakes. This patch
applies on top of the previous one, to give a correct debian package
(compile and install-tested).

* install .pc file in /usr/lib/pkgconfig, not pkg-config
* update package timestamp

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>

---
Index: debian/changelog
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- debian/changelog	(r=E9vision 6767)
+++ debian/changelog	(copie de travail)
@@ -2,7 +2,7 @@
=20
   * new upstream release
=20
- -- Harald Welte <laforge@netfilter.org>  Tue,  6 Mar 2007 11:07:08 +010=
0
+ -- Harald Welte <laforge@netfilter.org>  Thu,  8 Mar 2007 14:02:37 +010=
0
=20
 libnfnetlink (0.0.14) unstable; urgency=3Dlow
=20
Index: debian/rules
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- debian/rules	(r=E9vision 6767)
+++ debian/rules	(copie de travail)
@@ -13,5 +13,5 @@
 DEB_DH_INSTALL_SOURCEDIR :=3D debian/tmp
=20
 binary-install/libnfnetlink-dev::
-	mkdir -p debian/libnfnetlink-dev/usr/lib/pkg-config/; \
-	install -m 644 libnfnetlink.pc debian/libnfnetlink-dev/usr/lib/pkg-conf=
ig/
+	mkdir -p debian/libnfnetlink-dev/usr/lib/pkgconfig/; \
+	install -m 644 libnfnetlink.pc debian/libnfnetlink-dev/usr/lib/pkgconfi=
g/
