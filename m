From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 01/13] doc: add package version to all manpages
Date: Wed, 26 Dec 2012 15:34:07 +0100
Message-ID: <20121226143407.GA32053@1984>
References: <1356477089-13241-1-git-send-email-jengelh@inai.de>
 <1356477089-13241-2-git-send-email-jengelh@inai.de>
 <20121226143300.GB31482@1984>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45665 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab2LZOeO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Dec 2012 09:34:14 -0500
Content-Disposition: inline
In-Reply-To: <20121226143300.GB31482@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 26, 2012 at 03:33:00PM +0100, Pablo Neira Ayuso wrote:
[...]
> > +iptables-apply.8: ${srcdir}/iptables-apply.8.in
> > +	${fill_in_date}
> > +
> > +iptables-restore.8: ${srcdir}/iptables-restore.8.in
> > +	${fill_in_date}
> > +
> > +iptables-save.8: ${srcdir}/iptables-save.8.in
> > +	${fill_in_date}
> > +
> > +iptables.8: ${srcdir}/iptables.8.in
> > +	${fill_in_date}
> 
> This belongs more naturally to the ./configure stage, including
> setting the date via AC_SUBST. You should be able to make it with
> little changes in configure.ac.
> 
> For iptables-extensions.8 it will be a special case, it still requires
> part of the magic in the makefile to build the page.

See patch for instance.

--MGYHOYXEY6WxJCY8
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0004-build-add-iptables-manpage-version-during-at-.-confi.patch"

>From 8899a031b9498349aa113146d2eeb3dbccdcc868 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 12 Nov 2012 08:06:14 +0100
Subject: [PATCH] build: add iptables manpage version during at ./configure stage

For both iptables and ip6tables, instead of at make stage.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac            |    3 ++-
 iptables/Makefile.am    |    6 ------
 iptables/ip6tables.8.in |    2 +-
 iptables/iptables.8.in  |    2 +-
 4 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/configure.ac b/configure.ac
index e644308..3e27e02 100644
--- a/configure.ac
+++ b/configure.ac
@@ -127,5 +127,6 @@ AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
 	libiptc/Makefile libiptc/libiptc.pc
 	libiptc/libip4tc.pc libiptc/libip6tc.pc
 	libxtables/Makefile utils/Makefile
-	include/xtables-version.h include/iptables/internal.h])
+	include/xtables-version.h include/iptables/internal.h
+	iptables/iptables.8 iptables/ip6tables.8])
 AC_OUTPUT
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 61e78db..a476171 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -38,12 +38,6 @@ if ENABLE_IPV6
 v6_sbin_links  = ip6tables ip6tables-restore ip6tables-save
 endif
 
-iptables.8: ${srcdir}/iptables.8.in
-	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' $< >$@;
-
-ip6tables.8: ${srcdir}/ip6tables.8.in
-	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' $< >$@;
-
 iptables-extensions.8: ${srcdir}/iptables-extensions.8.in ../extensions/matches.man ../extensions/targets.man
 	${AM_VERBOSE_GEN} sed -e \
 		's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' \
diff --git a/iptables/ip6tables.8.in b/iptables/ip6tables.8.in
index 078bcac..328a0e3 100644
--- a/iptables/ip6tables.8.in
+++ b/iptables/ip6tables.8.in
@@ -1,4 +1,4 @@
-.TH IP6TABLES 8 "" "@PACKAGE_AND_VERSION@" "@PACKAGE_AND_VERSION@"
+.TH IP6TABLES 8 "" "@PACKAGE_NAME@ @PACKAGE_VERSION@" "@PACKAGE_NAME@ @PACKAGE_VERSION@"
 .\"
 .\" Man page written by Andras Kis-Szabo <kisza@sch.bme.hu>
 .\" It is based on iptables man page.
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index d6b409d..596c329 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -1,4 +1,4 @@
-.TH IPTABLES 8 "" "@PACKAGE_AND_VERSION@" "@PACKAGE_AND_VERSION@"
+.TH IPTABLES 8 "" "@PACKAGE_NAME@ @PACKAGE_VERSION@" "@PACKAGE_NAME@ @PACKAGE_VERSION@"
 .\"
 .\" Man page written by Herve Eychenne <rv@wallfire.org> (May 1999)
 .\" It is based on ipchains page.
-- 
1.7.10.4


--MGYHOYXEY6WxJCY8--
