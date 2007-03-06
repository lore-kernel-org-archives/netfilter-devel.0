From: Pierre Chifflier <chifflier@cpe.fr>
Subject: [PATCH] update debian packaging
Date: Tue, 6 Mar 2007 17:25:57 +0100
Message-ID: <20070306162557.GB7494@cpe.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
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

Hi,

The following patch fixes 3 problems with the debian files in the svn
repository:
* the.pc file is not copied during installation
* the version is outdated
* the version in debian/changelog should reflect the number of the
debian packaging, and so lacks a -1

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>

---
Index: debian/changelog
===================================================================
--- debian/changelog	(revision 6765)
+++ debian/changelog	(working copy)
@@ -1,3 +1,9 @@
+libnfnetlink (0.0.25-1) unstable; urgency=low
+
+  * new upstream release
+
+ -- Harald Welte <laforge@netfilter.org>  Tue,  6 Mar 2007 11:07:08 +0100
+
 libnfnetlink (0.0.14) unstable; urgency=low
 
   * new upstream release
Index: debian/rules
===================================================================
--- debian/rules	(revision 6765)
+++ debian/rules	(working copy)
@@ -11,3 +11,7 @@
 include /usr/share/cdbs/1/class/autotools.mk
 
 DEB_DH_INSTALL_SOURCEDIR := debian/tmp
+
+binary-install/libnfnetlink-dev::
+	mkdir -p debian/libnfnetlink-dev/usr/lib/pkg-config/; \
+	install -m 644 libnfnetlink.pc debian/libnfnetlink-dev/usr/lib/pkg-config/
