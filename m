From: Brian Haley <brian.haley@hpe.com>
Subject: [PATCH iptables] iptables-restore: add missing arguments to usage
 message
Date: Mon, 22 Aug 2016 14:47:15 -0400
Message-ID: <7d2cbd95-2442-a2c2-4faa-e2da7f2f0507@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-by2nam03on0097.outbound.protection.outlook.com ([104.47.42.97]:37255
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752325AbcHVUTs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 16:19:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


iptables-restore was missing -n, -T and -M from the
usage message, added them to match the man page.

Signed-off-by: Brian Haley <brian.haley@hpe.com>

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 9393924..dc0acb0 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -43,13 +43,14 @@ static void print_usage(const char *name, const char *version) __attribute__((no
 
 static void print_usage(const char *name, const char *version)
 {
-	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h]\n"
+	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h] [-n] [-T table] [-M command]\n"
 			"	   [ --counters ]\n"
 			"	   [ --verbose ]\n"
 			"	   [ --test ]\n"
 			"	   [ --help ]\n"
 			"	   [ --noflush ]\n"
-			"          [ --modprobe=<command>]\n", name);
+			"	   [ --table=<TABLE> ]\n"
+			"          [ --modprobe=<command> ]\n", name);
 
 	exit(1);
 }
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 638b171..2f1522d 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -42,14 +42,14 @@ static void print_usage(const char *name, const char *version) __attribute__((no
 
 static void print_usage(const char *name, const char *version)
 {
-	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h]\n"
+	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h] [-n] [-T table] [-M command]\n"
 			"	   [ --counters ]\n"
 			"	   [ --verbose ]\n"
 			"	   [ --test ]\n"
 			"	   [ --help ]\n"
 			"	   [ --noflush ]\n"
 			"	   [ --table=<TABLE> ]\n"
-			"          [ --modprobe=<command>]\n", name);
+			"          [ --modprobe=<command> ]\n", name);
 
 	exit(1);
 }
