From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 02/17] doc: deduplicate extension descriptions into a new manpage
Date: Sun, 30 Sep 2012 12:22:05 +0200
Message-ID: <1349000540-17508-3-git-send-email-jengelh@inai.de>
References: <1349000540-17508-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38808 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab2I3KW0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:22:26 -0400
In-Reply-To: <1349000540-17508-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

iptables.8 and ip6tables.8 had pretty much the same content, with a few
protocol-specific deviations here and there. Not only did that bloat the
manpages, but it also made it harder to spot differences. Separate out
the extension descriptions into a new manpage, which conveniently
features differences next to one another (cf. REJECT).

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/.gitignore             |    4 ++--
 extensions/GNUmakefile.in         |   35 +++++++++++++++--------------------
 iptables/.gitignore               |    1 +
 iptables/Makefile.am              |   16 +++++++++++-----
 iptables/ip6tables.8.in           |   20 +++-----------------
 iptables/iptables-extensions.8.in |   27 +++++++++++++++++++++++++++
 iptables/iptables.8.in            |   22 ++++------------------
 7 files changed, 63 insertions(+), 62 deletions(-)
 create mode 100644 iptables/iptables-extensions.8.in

diff --git a/extensions/.gitignore b/extensions/.gitignore
index 2e74faf..b1260f0 100644
--- a/extensions/.gitignore
+++ b/extensions/.gitignore
@@ -5,5 +5,5 @@
 /GNUmakefile
 /initext.c
 /initext?.c
-/matches?.man
-/targets?.man
+/matches.man
+/targets.man
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 0e7907e..2e0921e 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -56,9 +56,7 @@ pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
 #
 # Building blocks
 #
-targets := libext.a libext4.a libext6.a \
-           matches4.man matches6.man \
-           targets4.man targets6.man
+targets := libext.a libext4.a libext6.a matches.man targets.man
 targets_install :=
 @ENABLE_STATIC_TRUE@ libext_objs := ${pfx_objs}
 @ENABLE_STATIC_TRUE@ libext4_objs := ${pf4_objs}
@@ -77,7 +75,7 @@ install: ${targets_install}
 	if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}${xtlibdir}/"; fi;
 
 clean:
-	rm -f *.o *.oo *.so *.a {matches,targets}[46].man initext.c initext4.c initext6.c;
+	rm -f *.o *.oo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c;
 
 distclean: clean
 	rm -f .*.d .*.dd;
@@ -202,30 +200,27 @@ man_run    = \
 	${AM_VERBOSE_GEN} \
 	for ext in $(sort ${1}); do \
 		f="${srcdir}/libxt_$$ext.man"; \
-		cf="${srcdir}/libxt_$$ext.c"; \
-		if [ -f "$$f" ] && grep -Eq "$(3)|NFPROTO_UNSPEC" "$$cf"; then \
+		if [ -f "$$f" ]; then \
 			echo -e "\t+ $$f" >&2; \
 			echo ".SS $$ext"; \
 			cat "$$f" || exit $$?; \
-			continue; \
 		fi; \
-		f="${srcdir}/lib$(2)t_$$ext.man"; \
+		f="${srcdir}/libip6t_$$ext.man"; \
 		if [ -f "$$f" ]; then \
 			echo -e "\t+ $$f" >&2; \
-			echo ".SS $$ext"; \
+			echo ".SS $$ext (IPv6-specific)"; \
+			cat "$$f" || exit $$?; \
+		fi; \
+		f="${srcdir}/libipt_$$ext.man"; \
+		if [ -f "$$f" ]; then \
+			echo -e "\t+ $$f" >&2; \
+			echo ".SS $$ext (IPv4-specific)"; \
 			cat "$$f" || exit $$?; \
-			continue; \
 		fi; \
 	done >$@;
 
-matches4.man: .initext.dd .initext4.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod}),ip,NFPROTO_IPV4)
-
-matches6.man: .initext.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf6_build_mod}),ip6,NFPROTO_IPV6)
-
-targets4.man: .initext.dd .initext4.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod}),ip,NFPROTO_IPV4)
+matches.man: .initext.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
+	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod} ${pf6_build_mod}))
 
-targets6.man: .initext.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf6_build_mod}),ip6,NFPROTO_IPV6)
+targets.man: .initext.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
+	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod} ${pf6_build_mod}))
diff --git a/iptables/.gitignore b/iptables/.gitignore
index 5a08937..4fc63aa 100644
--- a/iptables/.gitignore
+++ b/iptables/.gitignore
@@ -5,6 +5,7 @@
 /ip6tables-static
 /iptables
 /iptables.8
+/iptables-extensions.8
 /iptables-save
 /iptables-restore
 /iptables-static
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index bdd4da1..61e78db 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -27,7 +27,7 @@ xtables_multi_LDADD   += ../libxtables/libxtables.la -lm
 sbin_PROGRAMS    = xtables-multi
 man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
                    iptables-xml.1 ip6tables.8 ip6tables-restore.8 \
-                   ip6tables-save.8
+                   ip6tables-save.8 iptables-extensions.8
 CLEANFILES       = iptables.8 ip6tables.8
 
 vx_bin_links   = iptables-xml
@@ -38,11 +38,17 @@ if ENABLE_IPV6
 v6_sbin_links  = ip6tables ip6tables-restore ip6tables-save
 endif
 
-iptables.8: ${srcdir}/iptables.8.in ../extensions/matches4.man ../extensions/targets4.man
-	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' -e '/@MATCH@/ r ../extensions/matches4.man' -e '/@TARGET@/ r ../extensions/targets4.man' $< >$@;
+iptables.8: ${srcdir}/iptables.8.in
+	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' $< >$@;
 
-ip6tables.8: ${srcdir}/ip6tables.8.in ../extensions/matches6.man ../extensions/targets6.man
-	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' -e '/@MATCH@/ r ../extensions/matches6.man' -e '/@TARGET@/ r ../extensions/targets6.man' $< >$@;
+ip6tables.8: ${srcdir}/ip6tables.8.in
+	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' $< >$@;
+
+iptables-extensions.8: ${srcdir}/iptables-extensions.8.in ../extensions/matches.man ../extensions/targets.man
+	${AM_VERBOSE_GEN} sed -e \
+		's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' \
+		-e '/@MATCH@/ r ../extensions/matches.man' \
+		-e '/@TARGET@/ r ../extensions/targets.man' $< >$@;
 
 pkgconfig_DATA = xtables.pc
 
diff --git a/iptables/ip6tables.8.in b/iptables/ip6tables.8.in
index 65f3864..edd092d 100644
--- a/iptables/ip6tables.8.in
+++ b/iptables/ip6tables.8.in
@@ -362,23 +362,8 @@ When adding or inserting rules into a chain, use \fIcommand\fP
 to load any necessary modules (targets, match extensions, etc).
 .SH MATCH EXTENSIONS
 .PP
-ip6tables can use extended packet matching modules
-with the \fB\-m\fP or \fB\-\-match\fP
-options, followed by the matching module name; after these, various
-extra command line options become available, depending on the specific
-module.  You can specify multiple extended match modules in one line,
-and you can use the \fB\-h\fP or \fB\-\-help\fP
-options after the module has been specified to receive help specific
-to that module.
-.PP
-If the \fB\-p\fP or \fB\-\-protocol\fP was specified and if and only if an
-unknown option is encountered, ip6tables will try load a match module of the
-same name as the protocol, to try making the option available.
-.\" @MATCH@
-.SH TARGET EXTENSIONS
-ip6tables can use extended target modules: the following are included
-in the standard distribution.
-.\" @TARGET@
+iptables can use extended packet matching and target modules.
+A list of these is available in the \fBiptables\-extensions\fP(8) manpage.
 .SH DIAGNOSTICS
 Various error messages are printed to standard error.  The exit code
 is 0 for correct functioning.  Errors which appear to be caused by
@@ -405,6 +390,7 @@ There are several other changes in ip6tables.
 \fBip6tables\-save\fP(8),
 \fBip6tables\-restore\fP(8),
 \fBiptables\fP(8),
+\fBiptables\-extensions\fP(8),
 \fBiptables\-save\fP(8),
 \fBiptables\-restore\fP(8),
 \fBlibipq\fP(3).
diff --git a/iptables/iptables-extensions.8.in b/iptables/iptables-extensions.8.in
new file mode 100644
index 0000000..e02c81f
--- /dev/null
+++ b/iptables/iptables-extensions.8.in
@@ -0,0 +1,27 @@
+.TH iptables-extensions 8 "" "@PACKAGE_AND_VERSION@" "@PACKAGE_AND_VERSION@"
+.SH NAME
+iptables-extensions \(em list of extensions in the standard iptables distribution
+.SH SYNOPSIS
+\fBip6tables\fP [\fB\-m\fP \fIname\fP [\fImodule-options\fP...]]
+[\fB\-j\fP \fItarget-name\fP [\fItarget-options\fP...]
+.PP
+\fBiptables\fP [\fB\-m\fP \fIname\fP [\fImodule-options\fP...]]
+[\fB\-j\fP \fItarget-name\fP [\fItarget-options\fP...]
+.SH MATCH EXTENSIONS
+iptables can use extended packet matching modules
+with the \fB\-m\fP or \fB\-\-match\fP
+options, followed by the matching module name; after these, various
+extra command line options become available, depending on the specific
+module.  You can specify multiple extended match modules in one line,
+and you can use the \fB\-h\fP or \fB\-\-help\fP
+options after the module has been specified to receive help specific
+to that module.
+.PP
+If the \fB\-p\fP or \fB\-\-protocol\fP was specified and if and only if an
+unknown option is encountered, iptables will try load a match module of the
+same name as the protocol, to try making the option available.
+.\" @MATCH@
+.SH TARGET EXTENSIONS
+iptables can use extended target modules: the following are included
+in the standard distribution.
+.\" @TARGET@
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 59d6e04..48eb2fa 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -355,25 +355,10 @@ corresponding to that rule's position in the chain.
 \fB\-\-modprobe=\fP\fIcommand\fP
 When adding or inserting rules into a chain, use \fIcommand\fP
 to load any necessary modules (targets, match extensions, etc).
-.SH MATCH EXTENSIONS
+.SH MATCH AND TARGET EXTENSIONS
 .PP
-iptables can use extended packet matching modules
-with the \fB\-m\fP or \fB\-\-match\fP
-options, followed by the matching module name; after these, various
-extra command line options become available, depending on the specific
-module.  You can specify multiple extended match modules in one line,
-and you can use the \fB\-h\fP or \fB\-\-help\fP
-options after the module has been specified to receive help specific
-to that module.
-.PP
-If the \fB\-p\fP or \fB\-\-protocol\fP was specified and if and only if an
-unknown option is encountered, iptables will try load a match module of the
-same name as the protocol, to try making the option available.
-.\" @MATCH@
-.SH TARGET EXTENSIONS
-iptables can use extended target modules: the following are included
-in the standard distribution.
-.\" @TARGET@
+iptables can use extended packet matching and target modules.
+A list of these is available in the \fBiptables\-extensions\fP(8) manpage.
 .SH DIAGNOSTICS
 Various error messages are printed to standard error.  The exit code
 is 0 for correct functioning.  Errors which appear to be caused by
@@ -410,6 +395,7 @@ There are several other changes in iptables.
 .SH SEE ALSO
 \fBiptables\-save\fP(8),
 \fBiptables\-restore\fP(8),
+\fBiptables\-extensions\fP(8),
 \fBip6tables\fP(8),
 \fBip6tables\-save\fP(8),
 \fBip6tables\-restore\fP(8),
-- 
1.7.10.4

