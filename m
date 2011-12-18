From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] doc: clarification on the meaning of -p 0
Date: Sun, 18 Dec 2011 03:06:47 +0100
Message-ID: <1324174009-1559-3-git-send-email-jengelh@medozas.de>
References: <1324174009-1559-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:55613 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab1LRCIO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 21:08:14 -0500
In-Reply-To: <1324174009-1559-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/ip6tables.8.in |   16 ++++++++++++----
 iptables/iptables.8.in  |   10 +++++++---
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/iptables/ip6tables.8.in b/iptables/ip6tables.8.in
index 748cebb..65f3864 100644
--- a/iptables/ip6tables.8.in
+++ b/iptables/ip6tables.8.in
@@ -250,7 +250,11 @@ But IPv6 extension headers except \fBesp\fP are not allowed.
 \fBesp\fP and \fBipv6\-nonext\fP
 can be used with Kernel version 2.6.11 or later.
 A "!" argument before the protocol inverts the
-test.  The number zero is equivalent to \fBall\fP. "\fBall\fP"
+test.  The number zero is equivalent to \fBall\fP, which means that you cannot
+test the protocol field for the value 0 directly. To match on a HBH header,
+even if it were the last, you cannot use \fB\-p 0\fP, but always need
+\fB\-m hbh\fP.
+"\fBall\fP"
 will match with all protocols and is taken as default when this
 option is omitted.
 .TP
@@ -357,15 +361,19 @@ corresponding to that rule's position in the chain.
 When adding or inserting rules into a chain, use \fIcommand\fP
 to load any necessary modules (targets, match extensions, etc).
 .SH MATCH EXTENSIONS
-ip6tables can use extended packet matching modules.  These are loaded
-in two ways: implicitly, when \fB\-p\fP or \fB\-\-protocol\fP
-is specified, or with the \fB\-m\fP or \fB\-\-match\fP
+.PP
+ip6tables can use extended packet matching modules
+with the \fB\-m\fP or \fB\-\-match\fP
 options, followed by the matching module name; after these, various
 extra command line options become available, depending on the specific
 module.  You can specify multiple extended match modules in one line,
 and you can use the \fB\-h\fP or \fB\-\-help\fP
 options after the module has been specified to receive help specific
 to that module.
+.PP
+If the \fB\-p\fP or \fB\-\-protocol\fP was specified and if and only if an
+unknown option is encountered, ip6tables will try load a match module of the
+same name as the protocol, to try making the option available.
 .\" @MATCH@
 .SH TARGET EXTENSIONS
 ip6tables can use extended target modules: the following are included
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 24618b7..59d6e04 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -356,15 +356,19 @@ corresponding to that rule's position in the chain.
 When adding or inserting rules into a chain, use \fIcommand\fP
 to load any necessary modules (targets, match extensions, etc).
 .SH MATCH EXTENSIONS
-iptables can use extended packet matching modules.  These are loaded
-in two ways: implicitly, when \fB\-p\fP or \fB\-\-protocol\fP
-is specified, or with the \fB\-m\fP or \fB\-\-match\fP
+.PP
+iptables can use extended packet matching modules
+with the \fB\-m\fP or \fB\-\-match\fP
 options, followed by the matching module name; after these, various
 extra command line options become available, depending on the specific
 module.  You can specify multiple extended match modules in one line,
 and you can use the \fB\-h\fP or \fB\-\-help\fP
 options after the module has been specified to receive help specific
 to that module.
+.PP
+If the \fB\-p\fP or \fB\-\-protocol\fP was specified and if and only if an
+unknown option is encountered, iptables will try load a match module of the
+same name as the protocol, to try making the option available.
 .\" @MATCH@
 .SH TARGET EXTENSIONS
 iptables can use extended target modules: the following are included
-- 
1.7.3.4

