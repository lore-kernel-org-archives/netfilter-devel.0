From: Brian Haley <brian.haley@hpe.com>
Subject: [PATCH v2 iptables] iptables-restore: add missing arguments to usage
 message
Date: Tue, 23 Aug 2016 10:14:47 -0400
Message-ID: <6deca21e-1daf-269a-da51-4673f911d58a@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bn3nam01on0098.outbound.protection.outlook.com ([104.47.33.98]:58343
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932989AbcHWOs5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Aug 2016 10:48:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


iptables-restore was missing -n, -T and -M from the
usage message, added them to match the man page.
Cleaned-up other *restore files as well.

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
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index cb60cce..a551c8c 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -46,14 +46,16 @@ static void print_usage(const char *name, const char *version) __attribute__((no
 
 static void print_usage(const char *name, const char *version)
 {
-	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h]\n"
+	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h] [-n] [-T table] [-M command] [-4] [-6]\n"
 			"	   [ --counters ]\n"
 			"	   [ --verbose ]\n"
 			"	   [ --test ]\n"
 			"	   [ --help ]\n"
 			"	   [ --noflush ]\n"
 			"	   [ --table=<TABLE> ]\n"
-			"          [ --modprobe=<command>]\n", name);
+			"          [ --modprobe=<command> ]\n"
+			"	   [ --ipv4 ]\n"
+			"	   [ --ipv6 ]\n", name);
 
 	exit(1);
 }
