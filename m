From: Eric Leblond <eric@regit.org>
Subject: [Ulogd2 PATCH 2/4] Update man page.
Date: Fri, 22 Feb 2013 11:25:56 +0100
Message-ID: <1361528758-16674-3-git-send-email-eric@regit.org>
References: <1361528758-16674-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:39921 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab3BVK0e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:26:34 -0500
In-Reply-To: <1361528758-16674-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Eric Leblond <eric@regit.org>
---
 ulogd.8 |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/ulogd.8 b/ulogd.8
index fc8db15..ad82290 100644
--- a/ulogd.8
+++ b/ulogd.8
@@ -2,7 +2,7 @@
 .\" First parameter, NAME, should be all caps
 .\" Second parameter, SECTION, should be 1-8, maybe w/ subsection
 .\" other parameters are allowed: see man(7), man(1)
-.TH ULOGD 8 "September 11, 2008" "Linux Netfilter"
+.TH ULOGD 8 "February 20, 2013" "Linux Netfilter"
 .\" Please adjust this date whenever revising the manpage.
 .\"
 .\" Some roff macros, for reference:
@@ -22,14 +22,15 @@ ulogd \- netfilter/iptables logging daemon
 .SH DESCRIPTION
 .B ulogd
 is a logging daemon that reads event messages coming from the Netfilter 
-connection tracking and the Netfilter packet logging subsystem. You have
-to enable support for connection tracking event delivery; ctnetlink and
-the NFLOG target in your Linux kernel 2.6.x or load their respective modules.
-The deprecated ULOG target (which has been superseded by NFLOG) is also
+connection tracking, the Netfilter packet logging subsystem and from
+the Netfilter accounting subsystem. You have to enable support for
+connection tracking event delivery; ctnetlink and the NFLOG target in
+your Linux kernel 2.6.x or load their respective modules. The deprecated
+ULOG target (which has been superseded by NFLOG) is also
 supported.
 .PP
-The received messages can be logged into files or into a mySQL or
-PostgreSQL database.
+The received messages can be logged into files or into a mySQL, sqlite3 
+or PostgreSQL database. IPFIX and Graphite output are also supported.
 .SH OPTIONS
 .TP
 .B -d, --daemon
@@ -45,6 +46,12 @@ show usage information
 .B -V, --version
 show version information and copyright
 .TP
+.B -v, --verbose
+verbose output on stdout when not running as daemon
+.TP
+.B -l, --loglevel <level>
+set log level to <level>: debug(1), info(3), notice(5), error(7) or fatal(8) (default 5)
+.TP
 .B -u <UID>, --uid <UID>
 change UID/GID
 .TP
-- 
1.7.10.4

