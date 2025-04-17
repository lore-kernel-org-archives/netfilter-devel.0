Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2702517A6
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Apr 2025 14:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744901468; cv=none; b=oaUkTdS/RnhbT9HdoRsEqZUJJzCCEW2opWKotCWHoieWO1qlMB7qHQrxJWtwyg2gKssEWAYGbPhqnAnZkwPJTppnrURXEQqtIrLhW/7mgBp5alRfXG8j9TCq2KDtFfoOUh3hqPFGhGOiCWrgHxktyYNJ89ROGVQ9p54JpL9KU50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744901468; c=relaxed/simple;
	bh=UgxklNseYo4ROEin8LZh+3yAuh4yvBdVEz218Cj6sgM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Am5b95FjwM1MRzkDAdAy0VpXoRE0wzjx5epyB1JVBFwYmeYzxUYaaLBgTfDfwisq+y5h7XXvqUk/4ehg+PpmTH2rcitepQuK209j3jlFDo0m0U6oQgK9edgLmYc2dK8Z0GD2ZA09fae7fLoxKzZwkyBlJcvmtwbv/rI0PPKtaeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 65534)
	id 8285510044E06F; Thu, 17 Apr 2025 16:50:56 +0200 (CEST)
X-Spam-Level: 
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:202:600a::a4])
	by a3.inai.de (Postfix) with ESMTP id 3D32310042AFB2;
	Thu, 17 Apr 2025 16:50:56 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	phil@nwl.cc,
	eric@garver.life
Subject: [nftables PATCH v3] tools: add a systemd unit for static rulesets
Date: Thu, 17 Apr 2025 16:48:33 +0200
Message-ID: <20250417145055.2700920-1-jengelh@inai.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There is a customer request (bugreport) for wanting to trivially load a ruleset
from a well-known location on boot, forwarded to me by M. Gerstner. A systemd
service unit is hereby added to provide that functionality. This is based on
various distributions attempting to do same, for example,

https://src.fedoraproject.org/rpms/nftables/tree/rawhide
https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/main/nftables/nftables.initd
https://gitlab.archlinux.org/archlinux/packaging/packages/nftables

---
v2->v3:
 * ExecStart uses `nft flush ruleset`
 * flush command thus no longer needed in the .nft file,
   which allows for just redirecting `nft list` output
 * Manpage mentions `nft list ... >main.nft`

 INSTALL                   |  6 ++++++
 Makefile.am               | 16 ++++++++++++----
 configure.ac              | 10 ++++++++++
 files/nftables/main.nft   | 22 ++++++++++++++++++++++
 tools/nftables.service.8  | 17 +++++++++++++++++
 tools/nftables.service.in | 21 +++++++++++++++++++++
 6 files changed, 88 insertions(+), 4 deletions(-)
 create mode 100644 files/nftables/main.nft
 create mode 100644 tools/nftables.service.8
 create mode 100644 tools/nftables.service.in

diff --git a/INSTALL b/INSTALL
index 5d45ec98..0c48c989 100644
--- a/INSTALL
+++ b/INSTALL
@@ -42,6 +42,12 @@ Installation instructions for nftables
 	The base directory for arch-independent files. Defaults to
 	$prefix/share.
 
+ --with-unitdir=
+
+	Directory for systemd unit files. Defaults to the value obtained from
+	pkg-config for systemd.pc, and ${prefix}/lib/systemd/system as a
+	fallback.
+
  --disable-debug
 
 	Disable debugging
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
index a4552df7..805af74a 100644
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
index 00000000..d3171fd3
--- /dev/null
+++ b/files/nftables/main.nft
@@ -0,0 +1,22 @@
+#!/usr/sbin/nft -f
+
+# template static firewall configuration file
+#
+# copy this over to /etc/nftables/rules/main.nft as a starting point for
+# configuring a rule set which will be loaded by nftables.service.
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
index 00000000..bb88dc46
--- /dev/null
+++ b/tools/nftables.service.8
@@ -0,0 +1,17 @@
+.TH nftables.service 8 "" "nftables" "nftables admin reference"
+.SH Name
+nftables.service \(em Static Firewall Configuration with nftables.service
+.SH Description
+An nftables systemd service is provided which allows to setup static firewall
+rulesets based on a configuration file.
+.PP
+To use this service, you need to create the main configuration file in
+/etc/nftables/rules/main.nft. A template for this can be copied from
+/usr/share/doc/nftables/main.nft. Alternatively, `nft list ruleset >main.nft`
+could be used to save the active configuration (if any) to the file.
+.PP
+Once the desired static firewall configuration is in place, it can be tested by
+running `systemctl start nftables.service`. To enable the service at boot time,
+run `systemctl enable nftables.service`.
+.SH See also
+\fBnft\fP(8)
diff --git a/tools/nftables.service.in b/tools/nftables.service.in
new file mode 100644
index 00000000..2ac7e6fd
--- /dev/null
+++ b/tools/nftables.service.in
@@ -0,0 +1,21 @@
+[Unit]
+Description=nftables static rule set
+Documentation=man:nftables.service(8)
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
+ExecStart=@sbindir@/nft 'flush ruleset; include "@pkgsysconfdir@/rules/main.nft"'
+ExecReload=@sbindir@/nft 'flush ruleset; include "@pkgsysconfdir@/rules/main.nft"'
+ExecStop=@sbindir@/nft flush ruleset
+
+[Install]
+WantedBy=sysinit.target
-- 
2.49.0

