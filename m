Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CDD1C54B2
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Feb 2025 20:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740776384; cv=none; b=GFvp/jo4dnNEbqe/HxdmGmGCNhlWV8c49t1xeGWPBUIYYZO8+Sr36DYwpVrwYSPog8/T59YorgYmbNohFFARM1hAySOYWixWttDM9a10gSZ5NJletoahcJLZZj32C65Xp62VZGPt5dujrZ9o/ZOR0vVsxuv7k+YPbF1e/9lKdFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740776384; c=relaxed/simple;
	bh=53dt8m9DN+zhZyh4AsyD4li2i5ilEjlzG5E3qz2J93w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n1ONUeXNDyjQ7Ak2v/hGTUxcCoanA+T2uE2E6nCKGAArz0gqDuxLc+nbCJT/OtzylOe+YJ7/3ffSltc7NUQ7cdCnwThTL6tTllxHBW8yWOx3oM7+/8Zg7D6D6im4Ie0nvpO7+03tt1rnWRNrBWrQd0SlDzUHTQD08b/qi8kkbzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 65534)
	id 6971F1003E7D5B; Fri, 28 Feb 2025 21:59:36 +0100 (CET)
X-Spam-Level: 
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:202:600a::a4])
	by a3.inai.de (Postfix) with ESMTP id 292CF1003E799A;
	Fri, 28 Feb 2025 21:59:36 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH] tools: add a systemd unit for static rulesets
Date: Fri, 28 Feb 2025 21:59:35 +0100
Message-ID: <20250228205935.59659-1-jengelh@inai.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a customer request (bugreport) for wanting to trivially load a ruleset
from a well-known location on boot, forwarded to me by M. Gerstner. A systemd
service unit is hereby added to provide that functionality. This is based on
various distributions attempting to do same, cf.

https://src.fedoraproject.org/rpms/nftables/tree/rawhide
https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/main/nftables/nftables.initd
https://gitlab.archlinux.org/archlinux/packaging/packages/nftables

Cc: Matthias Gerstner <matthias.gerstner@suse.com>
---
 .gitignore                |  1 +
 Makefile.am               | 16 ++++++++++++----
 configure.ac              | 10 ++++++++++
 files/nftables/main.nft   | 24 ++++++++++++++++++++++++
 tools/nftables.service.8  | 18 ++++++++++++++++++
 tools/nftables.service.in | 21 +++++++++++++++++++++
 6 files changed, 86 insertions(+), 4 deletions(-)
 create mode 100644 files/nftables/main.nft
 create mode 100644 tools/nftables.service.8
 create mode 100644 tools/nftables.service.in

diff --git a/.gitignore b/.gitignore
index a62e31f3..f92187ef 100644
--- a/.gitignore
+++ b/.gitignore
@@ -14,6 +14,7 @@ autom4te.cache
 build-aux/
 libnftables.pc
 libtool
+tools/nftables.service
 
 # cscope files
 /cscope.*
diff --git a/Makefile.am b/Makefile.am
index fb64105d..050991f4 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -375,18 +375,19 @@ dist_pkgdata_DATA = \
 	files/nftables/netdev-ingress.nft \
 	$(NULL)
 
-pkgdocdir = ${docdir}/examples
+exampledir = ${docdir}/examples
 
-dist_pkgdoc_SCRIPTS = \
+dist_example_SCRIPTS = \
 	files/examples/ct_helpers.nft \
 	files/examples/load_balancing.nft \
 	files/examples/secmark.nft \
 	files/examples/sets_and_maps.nft \
 	$(NULL)
 
-pkgsysconfdir = ${sysconfdir}/nftables/osf
+pkgsysconfdir = ${sysconfdir}/${PACKAGE}
+osfdir = ${pkgsysconfdir}/osf
 
-dist_pkgsysconf_DATA = \
+dist_osf_DATA = \
 	files/osf/pf.os \
 	$(NULL)
 
@@ -410,3 +411,10 @@ EXTRA_DIST += \
 
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libnftables.pc
+unit_DATA = tools/nftables.service
+man_MANS = tools/nftables.service.8
+doc_DATA = files/nftables/main.nft
+
+tools/nftables.service: tools/nftables.service.in ${top_builddir}/config.status
+	${AM_V_GEN}${MKDIR_P} tools
+	${AM_V_at}sed -e 's|@''sbindir''@|${sbindir}|g;s|@''pkgsysconfdir''@|${pkgsysconfdir}|g' <${srcdir}/tools/nftables.service.in >$@
diff --git a/configure.ac b/configure.ac
index 80a64813..64a164e5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -114,6 +114,16 @@ AC_CHECK_DECLS([getprotobyname_r, getprotobynumber_r, getservbyport_r], [], [],
 #include <netdb.h>
 ]])
 
+AC_ARG_WITH([unitdir],
+	[AS_HELP_STRING([--with-unitdir=PATH], [Path to systemd service unit directory])],
+	[unitdir="$withval"],
+	[
+		unitdir=$("$PKG_CONFIG" systemd --variable systemdsystemunitdir 2>/dev/null)
+		AS_IF([test -z "$unitdir"], [unitdir='${prefix}/lib/systemd/system'])
+	])
+AC_SUBST([unitdir])
+
+
 AC_CONFIG_FILES([					\
 		Makefile				\
 		libnftables.pc				\
diff --git a/files/nftables/main.nft b/files/nftables/main.nft
new file mode 100644
index 00000000..8e62f9bc
--- /dev/null
+++ b/files/nftables/main.nft
@@ -0,0 +1,24 @@
+#!/usr/sbin/nft -f
+
+# template static firewall configuration file
+#
+# copy this over to /etc/nftables/rules/main.nft as a starting point for
+# configuring a rule set which will be loaded by nftables.service.
+
+flush ruleset
+
+table inet filter {
+	chain input {
+		type filter hook input priority filter;
+	}
+	chain forward {
+		type filter hook forward priority filter;
+	}
+	chain output {
+		type filter hook output priority filter;
+	}
+}
+
+# this can be used to split the rule set into multiple smaller files concerned
+# with specific topics, like forwarding rules
+#include "/etc/nftables/rules/forwarding.nft"
diff --git a/tools/nftables.service.8 b/tools/nftables.service.8
new file mode 100644
index 00000000..4a83b01c
--- /dev/null
+++ b/tools/nftables.service.8
@@ -0,0 +1,18 @@
+.TH nftables.service 8 "" "nftables" "nftables admin reference"
+.SH Name
+nftables.service \(em Static Firewall Configuration with nftables.service
+.SH Description
+An nftables systemd service is provided which allows to setup static firewall
+rulesets based on a configuration file.
+.PP
+To use this service, you need to create the main configuration file in
+/etc/nftables/rules/main.nft. A template for this can be copied from
+/usr/share/doc/nftables/main.nft. The static firewall configuration can be
+split up into multiple files which are included from the main.nft
+configuration file.
+.PP
+Once the desired static firewall configuration is in place, it can be tested by
+running `systemctl start nftables.service`. To enable the service at boot time,
+run `systemctl enable nftables.service`.
+.SH See also
+\fBnft\fP(8)
diff --git a/tools/nftables.service.in b/tools/nftables.service.in
new file mode 100644
index 00000000..8d94e0fc
--- /dev/null
+++ b/tools/nftables.service.in
@@ -0,0 +1,21 @@
+[Unit]
+Description=nftables static rule set
+Documentation=nftables.service(8)
+Wants=network-pre.target
+Before=network-pre.target shutdown.target
+Conflicts=shutdown.target
+DefaultDependencies=no
+ConditionPathExists=@pkgsysconfdir@/rules/main.nft
+
+[Service]
+Type=oneshot
+RemainAfterExit=yes
+StandardInput=null
+ProtectSystem=full
+ProtectHome=true
+ExecStart=@sbindir@/nft -f @pkgsysconfdir@/rules/main.nft
+ExecReload=@sbindir@/nft -f @pkgsysconfdir@/rules/main.nft
+ExecStop=@sbindir@/nft flush ruleset
+
+[Install]
+WantedBy=sysinit.target
-- 
2.48.1

