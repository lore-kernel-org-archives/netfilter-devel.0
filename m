From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] nftables: delete debian/
Date: Thu, 14 Nov 2013 16:44:38 +0100
Message-ID: <20131114154438.9679.72477.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:45636 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753626Ab3KNPoq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:44:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The data there is quite old (2008-2009) and seem unmaintained.
Some files like 'control' and 'rules' are inaccurate or completely wrong.

Also, the debian/ dir makes harder for Debian folks to build a package
for this tool. I think its better to give them the job.

As the very first release of nftables seems to be nearer than ever, lets do
some house-cleaning.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 debian/.gitignore       |    4 ----
 debian/changelog        |    6 ------
 debian/compat           |    1 -
 debian/control          |   13 -------------
 debian/copyright        |    4 ----
 debian/nftables.install |    1 -
 debian/rules            |   20 --------------------
 7 files changed, 49 deletions(-)
 delete mode 100644 debian/.gitignore
 delete mode 100644 debian/changelog
 delete mode 100644 debian/compat
 delete mode 100644 debian/control
 delete mode 100644 debian/copyright
 delete mode 100644 debian/nftables.install
 delete mode 100755 debian/rules

diff --git a/debian/.gitignore b/debian/.gitignore
deleted file mode 100644
index b1e1dfb..0000000
--- a/debian/.gitignore
+++ /dev/null
@@ -1,4 +0,0 @@
-debhelper.log
-nftables.debhelper.log
-nftables/
-tmp/
diff --git a/debian/changelog b/debian/changelog
deleted file mode 100644
index 32b17fa..0000000
--- a/debian/changelog
+++ /dev/null
@@ -1,6 +0,0 @@
-nftables (0.01-alpha1) unstable; urgency=low
-
-  * initial alpha version
-
- -- Patrick McHardy <kaber@trash.net>  Wed,  3 Dec 2008 14:00:00 +0100
-
diff --git a/debian/compat b/debian/compat
deleted file mode 100644
index 7f8f011..0000000
--- a/debian/compat
+++ /dev/null
@@ -1 +0,0 @@
-7
diff --git a/debian/control b/debian/control
deleted file mode 100644
index e006278..0000000
--- a/debian/control
+++ /dev/null
@@ -1,13 +0,0 @@
-Source: nftables
-Section: net
-Priority: optional
-Maintainer: Patrick McHardy <kaber@trash.net>
-Build-Depends: libnl-dev (>= 2.0)
-Standards-Version: 3.8.0
-
-Package: nftables
-Architecture: any
-Priority: optional
-Section: net
-Depends: ${shlibs:Depends}
-Description: Program to control packet filtering rules
diff --git a/debian/copyright b/debian/copyright
deleted file mode 100644
index d6e4857..0000000
--- a/debian/copyright
+++ /dev/null
@@ -1,4 +0,0 @@
-The GNU General Public License version 2 applies to the upstream
-sources.  On Debian systems, the complete text of the GNU General
-Public License version 2 can be found in the
-/usr/share/common-licenses/GPL-2 file.
diff --git a/debian/nftables.install b/debian/nftables.install
deleted file mode 100644
index 92e31e9..0000000
--- a/debian/nftables.install
+++ /dev/null
@@ -1 +0,0 @@
-src/nft /sbin
diff --git a/debian/rules b/debian/rules
deleted file mode 100755
index 11988d5..0000000
--- a/debian/rules
+++ /dev/null
@@ -1,20 +0,0 @@
-#! /usr/bin/make -f
-
-configure_opts	:= --prefix=/ --datarootdir=/usr
-install_opts	:=
-
-%:
-	dh $@
-
-build:	build-stamp
-build-stamp:
-	dh build --before dh_auto_configure
-	autoreconf
-	dh_auto_configure -- $(configure_opts)
-	dh build --after dh_auto_configure
-	touch $@
-
-install: build
-	dh_install $(install_opts)
-
-binary: install

