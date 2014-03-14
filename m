From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 2/2] iptables: save: actually parse -M/--modprobe option
Date: Fri, 14 Mar 2014 12:52:48 +0100
Message-ID: <1394797968-9525-2-git-send-email-jpopelka@redhat.com>
References: <1394797968-9525-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbaCNLxB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Mar 2014 07:53:01 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2EBr0GV009109
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Mar 2014 07:53:00 -0400
In-Reply-To: <1394797968-9525-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 iptables/ip6tables-save.c   | 2 +-
 iptables/iptables-save.8.in | 2 +-
 iptables/iptables-save.c    | 2 +-
 iptables/xtables-save.c     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index 16821da..56e5afb 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -137,7 +137,7 @@ int ip6tables_save_main(int argc, char *argv[])
 	init_extensions6();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcdt:M:", options, NULL)) != -1) {
 		switch (c) {
 		case 'b':
 			fprintf(stderr, "-b/--binary option is not implemented\n");
diff --git a/iptables/iptables-save.8.in b/iptables/iptables-save.8.in
index 6128280..7f99d8a 100644
--- a/iptables/iptables-save.8.in
+++ b/iptables/iptables-save.8.in
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
index 2c25b71..bcf88ae 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -136,7 +136,7 @@ iptables_save_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcdt:M:", options, NULL)) != -1) {
 		switch (c) {
 		case 'b':
 			fprintf(stderr, "-b/--binary option is not implemented\n");
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index fe77283..d51cdcf 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -104,7 +104,7 @@ xtables_save_main(int family, const char *progname, int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	while ((c = getopt_long(argc, argv, "bcdt:46", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcdt:M:46", options, NULL)) != -1) {
 		switch (c) {
 		case 'b':
 			fprintf(stderr, "-b/--binary option is not implemented\n");
-- 
1.8.5.3

