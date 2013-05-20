From: Andy Spencer <andy753421@gmail.com>
Subject: [PATCH] iptables: use autoconf to process .in man pages
Date: Mon, 20 May 2013 03:01:06 +0000
Message-ID: <20130520030106.GA15853@pileus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:53868 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab3ETDCP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 May 2013 23:02:15 -0400
Received: by mail-oa0-f47.google.com with SMTP id m1so7038117oag.6
        for <netfilter-devel@vger.kernel.org>; Sun, 19 May 2013 20:02:15 -0700 (PDT)
Received: from mail.pileus.org (76-219-180-192.lightspeed.irvnca.sbcglobal.net. [76.219.180.192])
        by mx.google.com with ESMTPSA id ri8sm19230667oeb.0.2013.05.19.20.02.12
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 19 May 2013 20:02:13 -0700 (PDT)
Received: from andy by mail.pileus.org with local (Exim 4.80.1)
	(envelope-from <andy@pileus.org>)
	id 1UeGLS-000497-QM
	for netfilter-devel@vger.kernel.org; Mon, 20 May 2013 03:01:06 +0000
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fixes a bug in iptables.8 and ip6tables.8 where @PACKAGE_VERSION@
was not processed in the VERSION section. It also simplifies the
Makefile by avoiding some sed commands.
---
Yea, I don't know how I feel about having a .in.in, but it seems to work
well enough.

 configure.ac                                                     | 2 ++
 iptables/.gitignore                                              | 1 +
 iptables/Makefile.am                                             | 9 +--------
 iptables/ip6tables.8.in                                          | 2 +-
 .../{iptables-extensions.8.in => iptables-extensions.8.in.in}    | 2 +-
 iptables/iptables.8.in                                           | 2 +-
 6 files changed, 7 insertions(+), 11 deletions(-)
 rename iptables/{iptables-extensions.8.in => iptables-extensions.8.in.in} (94%)

diff --git a/configure.ac b/configure.ac
index 0620466..7066ad2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -127,6 +127,8 @@ AC_SUBST([libxtables_vmajor])
 
 AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
 	iptables/Makefile iptables/xtables.pc
+	iptables/iptables.8 iptables/ip6tables.8
+	iptables/iptables-extensions.8.in
 	libipq/Makefile libipq/libipq.pc
 	libiptc/Makefile libiptc/libiptc.pc
 	libiptc/libip4tc.pc libiptc/libip6tc.pc
diff --git a/iptables/.gitignore b/iptables/.gitignore
index 4fc63aa..23d4a12 100644
--- a/iptables/.gitignore
+++ b/iptables/.gitignore
@@ -6,6 +6,7 @@
 /iptables
 /iptables.8
 /iptables-extensions.8
+/iptables-extensions.8.in
 /iptables-save
 /iptables-restore
 /iptables-static
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 61e78db..20b8942 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -38,15 +38,8 @@ if ENABLE_IPV6
 v6_sbin_links  = ip6tables ip6tables-restore ip6tables-save
 endif
 
-iptables.8: ${srcdir}/iptables.8.in
-	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' $< >$@;
-
-ip6tables.8: ${srcdir}/ip6tables.8.in
-	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' $< >$@;
-
 iptables-extensions.8: ${srcdir}/iptables-extensions.8.in ../extensions/matches.man ../extensions/targets.man
-	${AM_VERBOSE_GEN} sed -e \
-		's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' \
+	${AM_VERBOSE_GEN} sed \
 		-e '/@MATCH@/ r ../extensions/matches.man' \
 		-e '/@TARGET@/ r ../extensions/targets.man' $< >$@;
 
diff --git a/iptables/ip6tables.8.in b/iptables/ip6tables.8.in
index 8634854..05e0d0f 100644
--- a/iptables/ip6tables.8.in
+++ b/iptables/ip6tables.8.in
@@ -1,4 +1,4 @@
-.TH IP6TABLES 8 "" "@PACKAGE_AND_VERSION@" "@PACKAGE_AND_VERSION@"
+.TH IP6TABLES 8 "" "@PACKAGE_STRING@" "@PACKAGE_STRING@"
 .\"
 .\" Man page written by Andras Kis-Szabo <kisza@sch.bme.hu>
 .\" It is based on iptables man page.
diff --git a/iptables/iptables-extensions.8.in b/iptables/iptables-extensions.8.in.in
similarity index 94%
rename from iptables/iptables-extensions.8.in
rename to iptables/iptables-extensions.8.in.in
index 9ec3fb0..99d89a1 100644
--- a/iptables/iptables-extensions.8.in
+++ b/iptables/iptables-extensions.8.in.in
@@ -1,4 +1,4 @@
-.TH iptables-extensions 8 "" "@PACKAGE_AND_VERSION@" "@PACKAGE_AND_VERSION@"
+.TH iptables-extensions 8 "" "@PACKAGE_STRING@" "@PACKAGE_STRING@"
 .SH NAME
 iptables-extensions \(em list of extensions in the standard iptables distribution
 .SH SYNOPSIS
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 9643705..0fba603 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -1,4 +1,4 @@
-.TH IPTABLES 8 "" "@PACKAGE_AND_VERSION@" "@PACKAGE_AND_VERSION@"
+.TH IPTABLES 8 "" "@PACKAGE_STRING@" "@PACKAGE_STRING@"
 .\"
 .\" Man page written by Herve Eychenne <rv@wallfire.org> (May 1999)
 .\" It is based on ipchains page.
-- 
1.8.1.5

