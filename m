From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 01/13] doc: add package version to all manpages
Date: Wed, 26 Dec 2012 00:11:17 +0100
Message-ID: <1356477089-13241-2-git-send-email-jengelh@inai.de>
References: <1356477089-13241-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38895 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab2LYXLe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Dec 2012 18:11:34 -0500
In-Reply-To: <1356477089-13241-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some manpages already had this - expand it to all of them. This is
useful to determine how old random renditions of these manpages on the
Internet actually are.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/.gitignore               |    5 +--
 iptables/Makefile.am              |   34 ++++++++++++---
 iptables/ip6tables-restore.8      |   52 ----------------------
 iptables/ip6tables-restore.8.in   |   52 ++++++++++++++++++++++
 iptables/ip6tables-save.8         |   53 ----------------------
 iptables/ip6tables-save.8.in      |   53 ++++++++++++++++++++++
 iptables/ip6tables.8.in           |    2 +-
 iptables/iptables-apply.8         |   44 -------------------
 iptables/iptables-apply.8.in      |   44 +++++++++++++++++++
 iptables/iptables-extensions.8.in |    2 +-
 iptables/iptables-restore.8       |   50 ---------------------
 iptables/iptables-restore.8.in    |   50 +++++++++++++++++++++
 iptables/iptables-save.8          |   51 ----------------------
 iptables/iptables-save.8.in       |   51 ++++++++++++++++++++++
 iptables/iptables-xml.1           |   87 -------------------------------------
 iptables/iptables-xml.1.in        |   87 +++++++++++++++++++++++++++++++++++++
 iptables/iptables.8.in            |    2 +-
 17 files changed, 370 insertions(+), 349 deletions(-)
 delete mode 100644 iptables/ip6tables-restore.8
 create mode 100644 iptables/ip6tables-restore.8.in
 delete mode 100644 iptables/ip6tables-save.8
 create mode 100644 iptables/ip6tables-save.8.in
 delete mode 100644 iptables/iptables-apply.8
 create mode 100644 iptables/iptables-apply.8.in
 delete mode 100644 iptables/iptables-restore.8
 create mode 100644 iptables/iptables-restore.8.in
 delete mode 100644 iptables/iptables-save.8
 create mode 100644 iptables/iptables-save.8.in
 delete mode 100644 iptables/iptables-xml.1
 create mode 100644 iptables/iptables-xml.1.in

diff --git a/iptables/.gitignore b/iptables/.gitignore
index 4fc63aa..1141d87 100644
--- a/iptables/.gitignore
+++ b/iptables/.gitignore
@@ -1,11 +1,10 @@
+/*.1
+/*.8
 /ip6tables
-/ip6tables.8
 /ip6tables-save
 /ip6tables-restore
 /ip6tables-static
 /iptables
-/iptables.8
-/iptables-extensions.8
 /iptables-save
 /iptables-restore
 /iptables-static
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 61e78db..0f4c1f6 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -27,8 +27,8 @@ xtables_multi_LDADD   += ../libxtables/libxtables.la -lm
 sbin_PROGRAMS    = xtables-multi
 man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
                    iptables-xml.1 ip6tables.8 ip6tables-restore.8 \
-                   ip6tables-save.8 iptables-extensions.8
-CLEANFILES       = iptables.8 ip6tables.8
+                   ip6tables-save.8 iptables-extensions.8 iptables-apply.8
+CLEANFILES       = ${man_MANS}
 
 vx_bin_links   = iptables-xml
 if ENABLE_IPV4
@@ -38,14 +38,36 @@ if ENABLE_IPV6
 v6_sbin_links  = ip6tables ip6tables-restore ip6tables-save
 endif
 
-iptables.8: ${srcdir}/iptables.8.in
-	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' $< >$@;
+fill_in_date = ${AM_V_GEN} sed -e \
+               's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' \
+               $< >$@;
+
+iptables-xml.1: ${srcdir}/iptables-xml.1.in
+	${fill_in_date}
+
+ip6tables-restore.8: ${srcdir}/ip6tables-restore.8.in
+	${fill_in_date}
+
+ip6tables-save.8: ${srcdir}/ip6tables-save.8.in
+	${fill_in_date}
 
 ip6tables.8: ${srcdir}/ip6tables.8.in
-	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' $< >$@;
+	${fill_in_date}
+
+iptables-apply.8: ${srcdir}/iptables-apply.8.in
+	${fill_in_date}
+
+iptables-restore.8: ${srcdir}/iptables-restore.8.in
+	${fill_in_date}
+
+iptables-save.8: ${srcdir}/iptables-save.8.in
+	${fill_in_date}
+
+iptables.8: ${srcdir}/iptables.8.in
+	${fill_in_date}
 
 iptables-extensions.8: ${srcdir}/iptables-extensions.8.in ../extensions/matches.man ../extensions/targets.man
-	${AM_VERBOSE_GEN} sed -e \
+	${AM_V_GEN} sed -e \
 		's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' \
 		-e '/@MATCH@/ r ../extensions/matches.man' \
 		-e '/@TARGET@/ r ../extensions/targets.man' $< >$@;
diff --git a/iptables/ip6tables-restore.8 b/iptables/ip6tables-restore.8
deleted file mode 100644
index 59a3b2e..0000000
--- a/iptables/ip6tables-restore.8
+++ /dev/null
@@ -1,52 +0,0 @@
-.TH IP6TABLES-RESTORE 8 "Jan 30, 2002" "" ""
-.\"
-.\" Man page written by Harald Welte <laforge@gnumonks.org>
-.\" It is based on the iptables man page.
-.\"
-.\"	This program is free software; you can redistribute it and/or modify
-.\"	it under the terms of the GNU General Public License as published by
-.\"	the Free Software Foundation; either version 2 of the License, or
-.\"	(at your option) any later version.
-.\"
-.\"	This program is distributed in the hope that it will be useful,
-.\"	but WITHOUT ANY WARRANTY; without even the implied warranty of
-.\"	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-.\"	GNU General Public License for more details.
-.\"
-.\"	You should have received a copy of the GNU General Public License
-.\"	along with this program; if not, write to the Free Software
-.\"	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-.\"
-.\"
-.SH NAME
-ip6tables-restore \(em Restore IPv6 Tables
-.SH SYNOPSIS
-\fBip6tables\-restore\fP [\fB\-c\fP] [\fB\-n\fP]
-.SH DESCRIPTION
-.PP
-.B ip6tables-restore
-is used to restore IPv6 Tables from data specified on STDIN. Use 
-I/O redirection provided by your shell to read from a file
-.TP
-\fB\-c\fR, \fB\-\-counters\fR
-restore the values of all packet and byte counters
-.TP
-\fB\-n\fR, \fB\-\-noflush\fR 
-don't flush the previous contents of the table. If not specified, 
-.TP
-\fB\-T\fP, \fB\-\-table\fP \fIname\fP
-Restore only the named table even if the input stream contains other ones.
-.B ip6tables-restore
-flushes (deletes) all previous contents of the respective IPv6 Table.
-.SH BUGS
-None known as of iptables-1.2.1 release
-.SH AUTHORS
-Harald Welte <laforge@gnumonks.org>
-.br
-Andras Kis-Szabo <kisza@sch.bme.hu>
-.SH SEE ALSO
-\fBip6tables\-save\fP(8), \fBip6tables\fP(8)
-.PP
-The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
-which details NAT, and the netfilter-hacking-HOWTO which details the
-internals.
diff --git a/iptables/ip6tables-restore.8.in b/iptables/ip6tables-restore.8.in
new file mode 100644
index 0000000..a9859ae
--- /dev/null
+++ b/iptables/ip6tables-restore.8.in
@@ -0,0 +1,52 @@
+.TH ip6tables-restore 8 "@PACKAGE_AND_VERSION@" "" "@PACKAGE_AND_VERSION@"
+.\"
+.\" Man page written by Harald Welte <laforge@gnumonks.org>
+.\" It is based on the iptables man page.
+.\"
+.\"	This program is free software; you can redistribute it and/or modify
+.\"	it under the terms of the GNU General Public License as published by
+.\"	the Free Software Foundation; either version 2 of the License, or
+.\"	(at your option) any later version.
+.\"
+.\"	This program is distributed in the hope that it will be useful,
+.\"	but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\"	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\"	GNU General Public License for more details.
+.\"
+.\"	You should have received a copy of the GNU General Public License
+.\"	along with this program; if not, write to the Free Software
+.\"	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+.\"
+.\"
+.SH NAME
+ip6tables-restore \(em Restore IPv6 Tables
+.SH SYNOPSIS
+\fBip6tables\-restore\fP [\fB\-c\fP] [\fB\-n\fP]
+.SH DESCRIPTION
+.PP
+.B ip6tables-restore
+is used to restore IPv6 Tables from data specified on STDIN. Use 
+I/O redirection provided by your shell to read from a file
+.TP
+\fB\-c\fR, \fB\-\-counters\fR
+restore the values of all packet and byte counters
+.TP
+\fB\-n\fR, \fB\-\-noflush\fR 
+don't flush the previous contents of the table. If not specified, 
+.TP
+\fB\-T\fP, \fB\-\-table\fP \fIname\fP
+Restore only the named table even if the input stream contains other ones.
+.B ip6tables-restore
+flushes (deletes) all previous contents of the respective IPv6 Table.
+.SH BUGS
+None known as of iptables-1.2.1 release
+.SH AUTHORS
+Harald Welte <laforge@gnumonks.org>
+.br
+Andras Kis-Szabo <kisza@sch.bme.hu>
+.SH SEE ALSO
+\fBip6tables\-save\fP(8), \fBip6tables\fP(8)
+.PP
+The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
+which details NAT, and the netfilter-hacking-HOWTO which details the
+internals.
diff --git a/iptables/ip6tables-save.8 b/iptables/ip6tables-save.8
deleted file mode 100644
index 457be82..0000000
--- a/iptables/ip6tables-save.8
+++ /dev/null
@@ -1,53 +0,0 @@
-.TH IP6TABLES-SAVE 8 "Jan 30, 2002" "" ""
-.\"
-.\" Man page written by Harald Welte <laforge@gnumonks.org>
-.\" It is based on the iptables man page.
-.\"
-.\"	This program is free software; you can redistribute it and/or modify
-.\"	it under the terms of the GNU General Public License as published by
-.\"	the Free Software Foundation; either version 2 of the License, or
-.\"	(at your option) any later version.
-.\"
-.\"	This program is distributed in the hope that it will be useful,
-.\"	but WITHOUT ANY WARRANTY; without even the implied warranty of
-.\"	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-.\"	GNU General Public License for more details.
-.\"
-.\"	You should have received a copy of the GNU General Public License
-.\"	along with this program; if not, write to the Free Software
-.\"	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-.\"
-.\"
-.SH NAME
-ip6tables-save \(em dump iptables rules to stdout
-.SH SYNOPSIS
-\fBip6tables\-save\fP [\fB\-M\fP \fImodprobe\fP] [\fB\-c\fP]
-[\fB\-t\fP \fItable\fP
-.SH DESCRIPTION
-.PP
-.B ip6tables-save
-is used to dump the contents of an IPv6 Table in easily parseable format
-to STDOUT. Use I/O-redirection provided by your shell to write to a file.
-.TP
-\fB\-M\fP \fImodprobe_program\fP
-Specify the path to the modprobe program. By default, iptables-save will
-inspect /proc/sys/kernel/modprobe to determine the executable's path.
-.TP
-\fB\-c\fR, \fB\-\-counters\fR
-include the current values of all packet and byte counters in the output
-.TP
-\fB\-t\fR, \fB\-\-table\fR \fItablename\fP
-restrict output to only one table. If not specified, output includes all
-available tables.
-.SH BUGS
-None known as of iptables-1.2.1 release
-.SH AUTHORS
-Harald Welte <laforge@gnumonks.org>
-.br
-Andras Kis-Szabo <kisza@sch.bme.hu>
-.SH SEE ALSO
-\fBip6tables\-restore\fP(8), \fBip6tables\fP(8)
-.PP
-The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
-which details NAT, and the netfilter-hacking-HOWTO which details the
-internals.
diff --git a/iptables/ip6tables-save.8.in b/iptables/ip6tables-save.8.in
new file mode 100644
index 0000000..f4cd3e0
--- /dev/null
+++ b/iptables/ip6tables-save.8.in
@@ -0,0 +1,53 @@
+.TH ip6tables-save 8 "@PACKAGE_AND_VERSION@" "" "@PACKAGE_AND_VERSION@"
+.\"
+.\" Man page written by Harald Welte <laforge@gnumonks.org>
+.\" It is based on the iptables man page.
+.\"
+.\"	This program is free software; you can redistribute it and/or modify
+.\"	it under the terms of the GNU General Public License as published by
+.\"	the Free Software Foundation; either version 2 of the License, or
+.\"	(at your option) any later version.
+.\"
+.\"	This program is distributed in the hope that it will be useful,
+.\"	but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\"	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\"	GNU General Public License for more details.
+.\"
+.\"	You should have received a copy of the GNU General Public License
+.\"	along with this program; if not, write to the Free Software
+.\"	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+.\"
+.\"
+.SH NAME
+ip6tables-save \(em dump iptables rules to stdout
+.SH SYNOPSIS
+\fBip6tables\-save\fP [\fB\-M\fP \fImodprobe\fP] [\fB\-c\fP]
+[\fB\-t\fP \fItable\fP
+.SH DESCRIPTION
+.PP
+.B ip6tables-save
+is used to dump the contents of an IPv6 Table in easily parseable format
+to STDOUT. Use I/O-redirection provided by your shell to write to a file.
+.TP
+\fB\-M\fP \fImodprobe_program\fP
+Specify the path to the modprobe program. By default, iptables-save will
+inspect /proc/sys/kernel/modprobe to determine the executable's path.
+.TP
+\fB\-c\fR, \fB\-\-counters\fR
+include the current values of all packet and byte counters in the output
+.TP
+\fB\-t\fR, \fB\-\-table\fR \fItablename\fP
+restrict output to only one table. If not specified, output includes all
+available tables.
+.SH BUGS
+None known as of iptables-1.2.1 release
+.SH AUTHORS
+Harald Welte <laforge@gnumonks.org>
+.br
+Andras Kis-Szabo <kisza@sch.bme.hu>
+.SH SEE ALSO
+\fBip6tables\-restore\fP(8), \fBip6tables\fP(8)
+.PP
+The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
+which details NAT, and the netfilter-hacking-HOWTO which details the
+internals.
diff --git a/iptables/ip6tables.8.in b/iptables/ip6tables.8.in
index 078bcac..fd0e61b 100644
--- a/iptables/ip6tables.8.in
+++ b/iptables/ip6tables.8.in
@@ -1,4 +1,4 @@
-.TH IP6TABLES 8 "" "@PACKAGE_AND_VERSION@" "@PACKAGE_AND_VERSION@"
+.TH ip6tables 8 "@PACKAGE_AND_VERSION@" "" "@PACKAGE_AND_VERSION@"
 .\"
 .\" Man page written by Andras Kis-Szabo <kisza@sch.bme.hu>
 .\" It is based on iptables man page.
diff --git a/iptables/iptables-apply.8 b/iptables/iptables-apply.8
deleted file mode 100644
index 66eaf57..0000000
--- a/iptables/iptables-apply.8
+++ /dev/null
@@ -1,44 +0,0 @@
-.\"     Title: iptables-apply
-.\"    Author: Martin F. Krafft
-.\"      Date: Jun 04, 2006
-.\"
-.TH iptables\-apply 8 2006-06-04
-.\" disable hyphenation
-.nh
-.SH NAME
-iptables-apply \- a safer way to update iptables remotely
-.SH SYNOPSIS
-\fBiptables\-apply\fP [\-\fBhV\fP] [\fB-t\fP \fItimeout\fP] \fIruleset\-file\fP
-.SH "DESCRIPTION"
-.PP
-iptables\-apply will try to apply a new ruleset (as output by
-iptables\-save/read by iptables\-restore) to iptables, then prompt the
-user whether the changes are okay. If the new ruleset cut the existing
-connection, the user will not be able to answer affirmatively. In this
-case, the script rolls back to the previous ruleset after the timeout
-expired. The timeout can be set with \fB\-t\fP.
-.PP
-When called as \fBip6tables\-apply\fP, the script will use
-ip6tables\-save/\-restore instead.
-.SH OPTIONS
-.TP
-\fB\-t\fP \fIseconds\fR, \fB\-\-timeout\fP \fIseconds\fR
-Sets the timeout after which the script will roll back to the previous
-ruleset.
-.TP
-\fB\-h\fP, \fB\-\-help\fP
-Display usage information.
-.TP
-\fB\-V\fP, \fB\-\-version\fP
-Display version information.
-.SH "SEE ALSO"
-.PP
-\fBiptables-restore\fP(8), \fBiptables-save\fP(8), \fBiptables\fR(8).
-.SH LEGALESE
-.PP
-iptables\-apply is copyright by Martin F. Krafft.
-.PP
-This manual page was written by Martin F. Krafft <madduck@madduck.net>
-.PP
-Permission is granted to copy, distribute and/or modify this document
-under the terms of the Artistic License 2.0.
diff --git a/iptables/iptables-apply.8.in b/iptables/iptables-apply.8.in
new file mode 100644
index 0000000..4fe14c8
--- /dev/null
+++ b/iptables/iptables-apply.8.in
@@ -0,0 +1,44 @@
+.\"     Title: iptables-apply
+.\"    Author: Martin F. Krafft
+.\"      Date: Jun 04, 2006
+.\"
+.TH iptables\-apply 8 "@PACKAGE_AND_VERSION@" "" "@PACKAGE_AND_VERSION@"
+.\" disable hyphenation
+.nh
+.SH NAME
+iptables-apply \- a safer way to update iptables remotely
+.SH SYNOPSIS
+\fBiptables\-apply\fP [\-\fBhV\fP] [\fB-t\fP \fItimeout\fP] \fIruleset\-file\fP
+.SH "DESCRIPTION"
+.PP
+iptables\-apply will try to apply a new ruleset (as output by
+iptables\-save/read by iptables\-restore) to iptables, then prompt the
+user whether the changes are okay. If the new ruleset cut the existing
+connection, the user will not be able to answer affirmatively. In this
+case, the script rolls back to the previous ruleset after the timeout
+expired. The timeout can be set with \fB\-t\fP.
+.PP
+When called as \fBip6tables\-apply\fP, the script will use
+ip6tables\-save/\-restore instead.
+.SH OPTIONS
+.TP
+\fB\-t\fP \fIseconds\fR, \fB\-\-timeout\fP \fIseconds\fR
+Sets the timeout after which the script will roll back to the previous
+ruleset.
+.TP
+\fB\-h\fP, \fB\-\-help\fP
+Display usage information.
+.TP
+\fB\-V\fP, \fB\-\-version\fP
+Display version information.
+.SH "SEE ALSO"
+.PP
+\fBiptables-restore\fP(8), \fBiptables-save\fP(8), \fBiptables\fR(8).
+.SH LEGALESE
+.PP
+iptables\-apply is copyright by Martin F. Krafft.
+.PP
+This manual page was written by Martin F. Krafft <madduck@madduck.net>
+.PP
+Permission is granted to copy, distribute and/or modify this document
+under the terms of the Artistic License 2.0.
diff --git a/iptables/iptables-extensions.8.in b/iptables/iptables-extensions.8.in
index 9ec3fb0..bbc3e86 100644
--- a/iptables/iptables-extensions.8.in
+++ b/iptables/iptables-extensions.8.in
@@ -1,4 +1,4 @@
-.TH iptables-extensions 8 "" "@PACKAGE_AND_VERSION@" "@PACKAGE_AND_VERSION@"
+.TH iptables-extensions 8 "@PACKAGE_AND_VERSION@" "" "@PACKAGE_AND_VERSION@"
 .SH NAME
 iptables-extensions \(em list of extensions in the standard iptables distribution
 .SH SYNOPSIS
diff --git a/iptables/iptables-restore.8 b/iptables/iptables-restore.8
deleted file mode 100644
index 0dd20cb..0000000
--- a/iptables/iptables-restore.8
+++ /dev/null
@@ -1,50 +0,0 @@
-.TH IPTABLES-RESTORE 8 "Jan 04, 2001" "" ""
-.\"
-.\" Man page written by Harald Welte <laforge@gnumonks.org>
-.\" It is based on the iptables man page.
-.\"
-.\"	This program is free software; you can redistribute it and/or modify
-.\"	it under the terms of the GNU General Public License as published by
-.\"	the Free Software Foundation; either version 2 of the License, or
-.\"	(at your option) any later version.
-.\"
-.\"	This program is distributed in the hope that it will be useful,
-.\"	but WITHOUT ANY WARRANTY; without even the implied warranty of
-.\"	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-.\"	GNU General Public License for more details.
-.\"
-.\"	You should have received a copy of the GNU General Public License
-.\"	along with this program; if not, write to the Free Software
-.\"	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-.\"
-.\"
-.SH NAME
-iptables-restore \(em Restore IP Tables
-.SH SYNOPSIS
-\fBiptables\-restore\fP [\fB\-c\fP] [\fB\-n\fP] [\fB\-T\fP \fIname\fP]
-.SH DESCRIPTION
-.PP
-.B iptables-restore
-is used to restore IP Tables from data specified on STDIN. Use 
-I/O redirection provided by your shell to read from a file
-.TP
-\fB\-c\fR, \fB\-\-counters\fR
-restore the values of all packet and byte counters
-.TP
-\fB\-n\fR, \fB\-\-noflush\fR 
-don't flush the previous contents of the table. If not specified, 
-.B iptables-restore
-flushes (deletes) all previous contents of the respective IP Table.
-.TP
-\fB\-T\fP, \fB\-\-table\fP \fIname\fP
-Restore only the named table even if the input stream contains other ones.
-.SH BUGS
-None known as of iptables-1.2.1 release
-.SH AUTHOR
-Harald Welte <laforge@gnumonks.org>
-.SH SEE ALSO
-\fBiptables\-save\fP(8), \fBiptables\fP(8)
-.PP
-The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
-which details NAT, and the netfilter-hacking-HOWTO which details the
-internals.
diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
new file mode 100644
index 0000000..37faae0
--- /dev/null
+++ b/iptables/iptables-restore.8.in
@@ -0,0 +1,50 @@
+.TH iptables-restore 8 "@PACKAGE_AND_VERSION@" "" "@PACKAGE_AND_VERSION@"
+.\"
+.\" Man page written by Harald Welte <laforge@gnumonks.org>
+.\" It is based on the iptables man page.
+.\"
+.\"	This program is free software; you can redistribute it and/or modify
+.\"	it under the terms of the GNU General Public License as published by
+.\"	the Free Software Foundation; either version 2 of the License, or
+.\"	(at your option) any later version.
+.\"
+.\"	This program is distributed in the hope that it will be useful,
+.\"	but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\"	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\"	GNU General Public License for more details.
+.\"
+.\"	You should have received a copy of the GNU General Public License
+.\"	along with this program; if not, write to the Free Software
+.\"	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+.\"
+.\"
+.SH NAME
+iptables-restore \(em Restore IP Tables
+.SH SYNOPSIS
+\fBiptables\-restore\fP [\fB\-c\fP] [\fB\-n\fP] [\fB\-T\fP \fIname\fP]
+.SH DESCRIPTION
+.PP
+.B iptables-restore
+is used to restore IP Tables from data specified on STDIN. Use 
+I/O redirection provided by your shell to read from a file
+.TP
+\fB\-c\fR, \fB\-\-counters\fR
+restore the values of all packet and byte counters
+.TP
+\fB\-n\fR, \fB\-\-noflush\fR 
+don't flush the previous contents of the table. If not specified, 
+.B iptables-restore
+flushes (deletes) all previous contents of the respective IP Table.
+.TP
+\fB\-T\fP, \fB\-\-table\fP \fIname\fP
+Restore only the named table even if the input stream contains other ones.
+.SH BUGS
+None known as of iptables-1.2.1 release
+.SH AUTHOR
+Harald Welte <laforge@gnumonks.org>
+.SH SEE ALSO
+\fBiptables\-save\fP(8), \fBiptables\fP(8)
+.PP
+The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
+which details NAT, and the netfilter-hacking-HOWTO which details the
+internals.
diff --git a/iptables/iptables-save.8 b/iptables/iptables-save.8
deleted file mode 100644
index c2e0a94..0000000
--- a/iptables/iptables-save.8
+++ /dev/null
@@ -1,51 +0,0 @@
-.TH IPTABLES-SAVE 8 "Jan 04, 2001" "" ""
-.\"
-.\" Man page written by Harald Welte <laforge@gnumonks.org>
-.\" It is based on the iptables man page.
-.\"
-.\"	This program is free software; you can redistribute it and/or modify
-.\"	it under the terms of the GNU General Public License as published by
-.\"	the Free Software Foundation; either version 2 of the License, or
-.\"	(at your option) any later version.
-.\"
-.\"	This program is distributed in the hope that it will be useful,
-.\"	but WITHOUT ANY WARRANTY; without even the implied warranty of
-.\"	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-.\"	GNU General Public License for more details.
-.\"
-.\"	You should have received a copy of the GNU General Public License
-.\"	along with this program; if not, write to the Free Software
-.\"	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-.\"
-.\"
-.SH NAME
-iptables-save \(em dump iptables rules to stdout
-.SH SYNOPSIS
-\fBiptables\-save\fP [\fB\-M\fP \fImodprobe\fP] [\fB\-c\fP]
-[\fB\-t\fP \fItable\fP]
-.SH DESCRIPTION
-.PP
-.B iptables-save
-is used to dump the contents of an IP Table in easily parseable format
-to STDOUT. Use I/O-redirection provided by your shell to write to a file.
-.TP
-\fB\-M\fP \fImodprobe_program\fP
-Specify the path to the modprobe program. By default, iptables-save will
-inspect /proc/sys/kernel/modprobe to determine the executable's path.
-.TP
-\fB\-c\fR, \fB\-\-counters\fR
-include the current values of all packet and byte counters in the output
-.TP
-\fB\-t\fR, \fB\-\-table\fR \fItablename\fP
-restrict output to only one table. If not specified, output includes all
-available tables.
-.SH BUGS
-None known as of iptables-1.2.1 release
-.SH AUTHOR
-Harald Welte <laforge@gnumonks.org>
-.SH SEE ALSO
-\fBiptables\-restore\fP(8), \fBiptables\fP(8)
-.PP
-The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
-which details NAT, and the netfilter-hacking-HOWTO which details the
-internals.
diff --git a/iptables/iptables-save.8.in b/iptables/iptables-save.8.in
new file mode 100644
index 0000000..3d79185
--- /dev/null
+++ b/iptables/iptables-save.8.in
@@ -0,0 +1,51 @@
+.TH iptables-save 8 "@PACKAGE_AND_VERSION@" "" "@PACKAGE_AND_VERSION@"
+.\"
+.\" Man page written by Harald Welte <laforge@gnumonks.org>
+.\" It is based on the iptables man page.
+.\"
+.\"	This program is free software; you can redistribute it and/or modify
+.\"	it under the terms of the GNU General Public License as published by
+.\"	the Free Software Foundation; either version 2 of the License, or
+.\"	(at your option) any later version.
+.\"
+.\"	This program is distributed in the hope that it will be useful,
+.\"	but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\"	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\"	GNU General Public License for more details.
+.\"
+.\"	You should have received a copy of the GNU General Public License
+.\"	along with this program; if not, write to the Free Software
+.\"	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+.\"
+.\"
+.SH NAME
+iptables-save \(em dump iptables rules to stdout
+.SH SYNOPSIS
+\fBiptables\-save\fP [\fB\-M\fP \fImodprobe\fP] [\fB\-c\fP]
+[\fB\-t\fP \fItable\fP]
+.SH DESCRIPTION
+.PP
+.B iptables-save
+is used to dump the contents of an IP Table in easily parseable format
+to STDOUT. Use I/O-redirection provided by your shell to write to a file.
+.TP
+\fB\-M\fP \fImodprobe_program\fP
+Specify the path to the modprobe program. By default, iptables-save will
+inspect /proc/sys/kernel/modprobe to determine the executable's path.
+.TP
+\fB\-c\fR, \fB\-\-counters\fR
+include the current values of all packet and byte counters in the output
+.TP
+\fB\-t\fR, \fB\-\-table\fR \fItablename\fP
+restrict output to only one table. If not specified, output includes all
+available tables.
+.SH BUGS
+None known as of iptables-1.2.1 release
+.SH AUTHOR
+Harald Welte <laforge@gnumonks.org>
+.SH SEE ALSO
+\fBiptables\-restore\fP(8), \fBiptables\fP(8)
+.PP
+The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
+which details NAT, and the netfilter-hacking-HOWTO which details the
+internals.
diff --git a/iptables/iptables-xml.1 b/iptables/iptables-xml.1
deleted file mode 100644
index 048c2cb..0000000
--- a/iptables/iptables-xml.1
+++ /dev/null
@@ -1,87 +0,0 @@
-.TH IPTABLES-XML 8 "Jul 16, 2007" "" ""
-.\"
-.\" Man page written by Sam Liddicott <azez@ufomechanic.net>
-.\" It is based on the iptables-save man page.
-.\"
-.\"	This program is free software; you can redistribute it and/or modify
-.\"	it under the terms of the GNU General Public License as published by
-.\"	the Free Software Foundation; either version 2 of the License, or
-.\"	(at your option) any later version.
-.\"
-.\"	This program is distributed in the hope that it will be useful,
-.\"	but WITHOUT ANY WARRANTY; without even the implied warranty of
-.\"	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-.\"	GNU General Public License for more details.
-.\"
-.\"	You should have received a copy of the GNU General Public License
-.\"	along with this program; if not, write to the Free Software
-.\"	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-.\"
-.\"
-.SH NAME
-iptables-xml \(em Convert iptables-save format to XML
-.SH SYNOPSIS
-\fBiptables\-xml\fP [\fB\-c\fP] [\fB\-v\fP]
-.SH DESCRIPTION
-.PP
-.B iptables-xml
-is used to convert the output of iptables-save into an easily manipulatable
-XML format to STDOUT.  Use I/O-redirection provided by your shell to write to 
-a file.
-.TP
-\fB\-c\fR, \fB\-\-combine\fR
-combine consecutive rules with the same matches but different targets. iptables
-does not currently support more than one target per match, so this simulates 
-that by collecting the targets from consecutive iptables rules into one action
-tag, but only when the rule matches are identical. Terminating actions like
-RETURN, DROP, ACCEPT and QUEUE are not combined with subsequent targets.
-.TP
-\fB\-v\fR, \fB\-\-verbose\fR
-Output xml comments containing the iptables line from which the XML is derived
-
-.PP
-iptables-xml does a mechanistic conversion to a very expressive xml
-format; the only semantic considerations are for \-g and \-j targets in
-order to discriminate between <call> <goto> and <nane-of-target> as it
-helps xml processing scripts if they can tell the difference between a
-target like SNAT and another chain.
-
-Some sample output is:
-
-<iptables-rules>
-  <table name="mangle">
-    <chain name="PREROUTING" policy="ACCEPT" packet-count="63436"
-byte-count="7137573">
-      <rule>
-       <conditions>
-        <match>
-          <p>tcp</p>
-        </match>
-        <tcp>
-          <sport>8443</sport>
-        </tcp>
-       </conditions>
-       <actions>
-        <call>
-          <check_ip/>
-        </call>
-        <ACCEPT/>
-       </actions>
-      </rule>
-    </chain>
-  </table>
-</iptables-rules>
-
-.PP
-Conversion from XML to iptables-save format may be done using the 
-iptables.xslt script and xsltproc, or a custom program using
-libxsltproc or similar; in this fashion:
-
-xsltproc iptables.xslt my-iptables.xml | iptables-restore
-
-.SH BUGS
-None known as of iptables-1.3.7 release
-.SH AUTHOR
-Sam Liddicott <azez@ufomechanic.net>
-.SH SEE ALSO
-\fBiptables\-save\fP(8), \fBiptables\-restore\fP(8), \fBiptables\fP(8)
diff --git a/iptables/iptables-xml.1.in b/iptables/iptables-xml.1.in
new file mode 100644
index 0000000..6b440ff
--- /dev/null
+++ b/iptables/iptables-xml.1.in
@@ -0,0 +1,87 @@
+.TH iptables-xml 8 "@PACKAGE_AND_VERSION@" "" "@PACKAGE_AND_VERSION@"
+.\"
+.\" Man page written by Sam Liddicott <azez@ufomechanic.net>
+.\" It is based on the iptables-save man page.
+.\"
+.\"	This program is free software; you can redistribute it and/or modify
+.\"	it under the terms of the GNU General Public License as published by
+.\"	the Free Software Foundation; either version 2 of the License, or
+.\"	(at your option) any later version.
+.\"
+.\"	This program is distributed in the hope that it will be useful,
+.\"	but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\"	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\"	GNU General Public License for more details.
+.\"
+.\"	You should have received a copy of the GNU General Public License
+.\"	along with this program; if not, write to the Free Software
+.\"	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+.\"
+.\"
+.SH NAME
+iptables-xml \(em Convert iptables-save format to XML
+.SH SYNOPSIS
+\fBiptables\-xml\fP [\fB\-c\fP] [\fB\-v\fP]
+.SH DESCRIPTION
+.PP
+.B iptables-xml
+is used to convert the output of iptables-save into an easily manipulatable
+XML format to STDOUT.  Use I/O-redirection provided by your shell to write to 
+a file.
+.TP
+\fB\-c\fR, \fB\-\-combine\fR
+combine consecutive rules with the same matches but different targets. iptables
+does not currently support more than one target per match, so this simulates 
+that by collecting the targets from consecutive iptables rules into one action
+tag, but only when the rule matches are identical. Terminating actions like
+RETURN, DROP, ACCEPT and QUEUE are not combined with subsequent targets.
+.TP
+\fB\-v\fR, \fB\-\-verbose\fR
+Output xml comments containing the iptables line from which the XML is derived
+
+.PP
+iptables-xml does a mechanistic conversion to a very expressive xml
+format; the only semantic considerations are for \-g and \-j targets in
+order to discriminate between <call> <goto> and <nane-of-target> as it
+helps xml processing scripts if they can tell the difference between a
+target like SNAT and another chain.
+
+Some sample output is:
+
+<iptables-rules>
+  <table name="mangle">
+    <chain name="PREROUTING" policy="ACCEPT" packet-count="63436"
+byte-count="7137573">
+      <rule>
+       <conditions>
+        <match>
+          <p>tcp</p>
+        </match>
+        <tcp>
+          <sport>8443</sport>
+        </tcp>
+       </conditions>
+       <actions>
+        <call>
+          <check_ip/>
+        </call>
+        <ACCEPT/>
+       </actions>
+      </rule>
+    </chain>
+  </table>
+</iptables-rules>
+
+.PP
+Conversion from XML to iptables-save format may be done using the 
+iptables.xslt script and xsltproc, or a custom program using
+libxsltproc or similar; in this fashion:
+
+xsltproc iptables.xslt my-iptables.xml | iptables-restore
+
+.SH BUGS
+None known as of iptables-1.3.7 release
+.SH AUTHOR
+Sam Liddicott <azez@ufomechanic.net>
+.SH SEE ALSO
+\fBiptables\-save\fP(8), \fBiptables\-restore\fP(8), \fBiptables\fP(8)
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index d6b409d..748d00f 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -1,4 +1,4 @@
-.TH IPTABLES 8 "" "@PACKAGE_AND_VERSION@" "@PACKAGE_AND_VERSION@"
+.TH iptables 8 "@PACKAGE_AND_VERSION@" "" "@PACKAGE_AND_VERSION@"
 .\"
 .\" Man page written by Herve Eychenne <rv@wallfire.org> (May 1999)
 .\" It is based on ipchains page.
-- 
1.7.10.4

