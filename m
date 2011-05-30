From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] doc: iptables-xml should be in manpage section 1
Date: Mon, 30 May 2011 12:18:05 +0200
Message-ID: <1306750686-11595-6-git-send-email-jengelh@medozas.de>
References: <1306750686-11595-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:49396 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab1E3KSP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2011 06:18:15 -0400
In-Reply-To: <1306750686-11595-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://bugs.debian.org/623112
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am    |    2 +-
 iptables-xml.1 |   87 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 iptables-xml.8 |   87 --------------------------------------------------------
 3 files changed, 88 insertions(+), 88 deletions(-)
 create mode 100644 iptables-xml.1
 delete mode 100644 iptables-xml.8

diff --git a/Makefile.am b/Makefile.am
index cc2b83b..ae7923f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -61,7 +61,7 @@ xtables_multi_LDADD   += libxtables.la -lm
 
 sbin_PROGRAMS    = xtables-multi
 man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
-                   iptables-xml.8 ip6tables.8 ip6tables-restore.8 \
+                   iptables-xml.1 ip6tables.8 ip6tables-restore.8 \
                    ip6tables-save.8
 CLEANFILES       = iptables.8 ip6tables.8
 
diff --git a/iptables-xml.1 b/iptables-xml.1
new file mode 100644
index 0000000..048c2cb
--- /dev/null
+++ b/iptables-xml.1
@@ -0,0 +1,87 @@
+.TH IPTABLES-XML 8 "Jul 16, 2007" "" ""
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
diff --git a/iptables-xml.8 b/iptables-xml.8
deleted file mode 100644
index 048c2cb..0000000
--- a/iptables-xml.8
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
-- 
1.7.3.4

