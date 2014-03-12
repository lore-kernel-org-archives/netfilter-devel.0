From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH] iptables: make 'iptables-save -M' actually work
Date: Wed, 12 Mar 2014 14:16:09 +0100
Message-ID: <1394630169-21124-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364AbaCLNQZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:16:25 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2CDGMJB022976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2014 09:16:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

also add missing bracket in iptables-save(8)
---
 iptables/ip6tables-save.c   | 2 +-
 iptables/iptables-save.8.in | 4 ++--
 iptables/iptables-save.c    | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index a86a64a..cf56c63 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -137,7 +137,7 @@ int ip6tables_save_main(int argc, char *argv[])
 	init_extensions6();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "cdt:M:", options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			show_counters = 1;
diff --git a/iptables/iptables-save.8.in b/iptables/iptables-save.8.in
index 5e939b1..7f99d8a 100644
--- a/iptables/iptables-save.8.in
+++ b/iptables/iptables-save.8.in
@@ -27,7 +27,7 @@ ip6tables-save \(em dump iptables rules to stdout
 [\fB\-t\fP \fItable\fP]
 .P
 \fBip6tables\-save\fP [\fB\-M\fP \fImodprobe\fP] [\fB\-c\fP]
-[\fB\-t\fP \fItable\fP
+[\fB\-t\fP \fItable\fP]
 .SH DESCRIPTION
 .PP
 .B iptables-save
@@ -36,7 +36,7 @@ and
 are used to dump the contents of IP or IPv6 Table in easily parseable format
 to STDOUT. Use I/O-redirection provided by your shell to write to a file.
 .TP
-\fB\-M\fP \fImodprobe_program\fP
+\fB\-M\fR, \fB\-\-modprobe\fR \fImodprobe_program\fP
 Specify the path to the modprobe program. By default, iptables-save will
 inspect /proc/sys/kernel/modprobe to determine the executable's path.
 .TP
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index 2999c7f..ed81dfd 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -136,7 +136,7 @@ iptables_save_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "cdt:M:", options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			show_counters = 1;
-- 
1.8.5.3

