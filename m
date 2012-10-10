From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/9] doc: add package version to all manpages
Date: Wed, 10 Oct 2012 14:26:25 +0200
Message-ID: <1349871992-31115-3-git-send-email-jengelh@inai.de>
References: <1349871992-31115-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:57552 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab2JJM0i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:26:38 -0400
In-Reply-To: <1349871992-31115-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some manpages already had this - expand it to all of them. This is
useful to determine how old random renditions of these manpages on the
Internet actually are.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/.gitignore              |    4 +--
 iptables/Makefile.am             |    2 +-
 iptables/ip6tables-restore.8     |   52 -------------------------------------
 iptables/ip6tables-restore.8in   |   52 +++++++++++++++++++++++++++++++++++++
 iptables/ip6tables-save.8        |   53 --------------------------------------
 iptables/ip6tables-save.8in      |   53 ++++++++++++++++++++++++++++++++++++++
 iptables/ip6tables.8in           |    2 +-
 iptables/iptables-apply.8        |   44 -------------------------------
 iptables/iptables-apply.8in      |   44 +++++++++++++++++++++++++++++++
 iptables/iptables-extensions.8in |    2 +-
 iptables/iptables-restore.8      |   50 -----------------------------------
 iptables/iptables-restore.8in    |   50 +++++++++++++++++++++++++++++++++++
 iptables/iptables-save.8         |   51 ------------------------------------
 iptables/iptables-save.8in       |   51 ++++++++++++++++++++++++++++++++++++
 iptables/iptables.8in            |    2 +-
 15 files changed, 255 insertions(+), 257 deletions(-)
 delete mode 100644 iptables/ip6tables-restore.8
 create mode 100644 iptables/ip6tables-restore.8in
 delete mode 100644 iptables/ip6tables-save.8
 create mode 100644 iptables/ip6tables-save.8in
 delete mode 100644 iptables/iptables-apply.8
 create mode 100644 iptables/iptables-apply.8in
 delete mode 100644 iptables/iptables-restore.8
 create mode 100644 iptables/iptables-restore.8in
 delete mode 100644 iptables/iptables-save.8
 create mode 100644 iptables/iptables-save.8in

diff --git a/iptables/.gitignore b/iptables/.gitignore
index 4fc63aa..8d7e987 100644
--- a/iptables/.gitignore
+++ b/iptables/.gitignore
@@ -1,11 +1,9 @@
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
index 65776a3..ecd6115 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -27,7 +27,7 @@ xtables_multi_LDADD   += ../libxtables/libxtables.la -lm
 sbin_PROGRAMS    = xtables-multi
 man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
                    iptables-xml.1 ip6tables.8 ip6tables-restore.8 \
-                   ip6tables-save.8 iptables-extensions.8
+                   ip6tables-save.8 iptables-extensions.8 iptables-apply.8
 CLEANFILES       = iptables.8 ip6tables.8
 
 vx_bin_links   = iptables-xml
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
diff --git a/iptables/ip6tables-restore.8in b/iptables/ip6tables-restore.8in
new file mode 100644
index 0000000..a9859ae
--- /dev/null
+++ b/iptables/ip6tables-restore.8in
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
diff --git a/iptables/ip6tables-save.8in b/iptables/ip6tables-save.8in
new file mode 100644
index 0000000..f4cd3e0
--- /dev/null
+++ b/iptables/ip6tables-save.8in
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
diff --git a/iptables/ip6tables.8in b/iptables/ip6tables.8in
index 078bcac..fd0e61b 100644
--- a/iptables/ip6tables.8in
+++ b/iptables/ip6tables.8in
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
diff --git a/iptables/iptables-apply.8in b/iptables/iptables-apply.8in
new file mode 100644
index 0000000..4fe14c8
--- /dev/null
+++ b/iptables/iptables-apply.8in
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
diff --git a/iptables/iptables-extensions.8in b/iptables/iptables-extensions.8in
index e02c81f..293a21d 100644
--- a/iptables/iptables-extensions.8in
+++ b/iptables/iptables-extensions.8in
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
diff --git a/iptables/iptables-restore.8in b/iptables/iptables-restore.8in
new file mode 100644
index 0000000..37faae0
--- /dev/null
+++ b/iptables/iptables-restore.8in
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
diff --git a/iptables/iptables-save.8in b/iptables/iptables-save.8in
new file mode 100644
index 0000000..3d79185
--- /dev/null
+++ b/iptables/iptables-save.8in
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
diff --git a/iptables/iptables.8in b/iptables/iptables.8in
index d6b409d..748d00f 100644
--- a/iptables/iptables.8in
+++ b/iptables/iptables.8in
@@ -1,4 +1,4 @@
-.TH IPTABLES 8 "" "@PACKAGE_AND_VERSION@" "@PACKAGE_AND_VERSION@"
+.TH iptables 8 "@PACKAGE_AND_VERSION@" "" "@PACKAGE_AND_VERSION@"
 .\"
 .\" Man page written by Herve Eychenne <rv@wallfire.org> (May 1999)
 .\" It is based on ipchains page.
-- 
1.7.10.4

