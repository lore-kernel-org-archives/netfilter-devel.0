From: Vincent Bernat <vincent@bernat.im>
Subject: [PATCH iptables v3] iptables-restore/save: exit when given an unknown option
Date: Sat, 15 Apr 2017 12:16:47 +0200
Message-ID: <20170415101647.20650-1-vincent@bernat.im>
References: <20170414115621.13812-1-vincent@bernat.im>
Cc: Vincent Bernat <vincent@bernat.im>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bart.luffy.cx ([78.47.78.131]:37150 "EHLO bart.luffy.cx"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752091AbdDOKRM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 06:17:12 -0400
In-Reply-To: <20170414115621.13812-1-vincent@bernat.im>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When an unknown option is given, iptables-restore should exit instead of
continue its operation. For example, if `--table` was misspelled, this
could lead to an unwanted change. Moreover, exit with a status code of
1. Make the same change for iptables-save.

OTOH, exit with a status code of 0 when requesting help.

Signed-off-by: Vincent Bernat <vincent@bernat.im>
---
 iptables/ip6tables-restore.c | 10 +++++-----
 iptables/ip6tables-save.c    |  4 ++++
 iptables/iptables-restore.c  | 10 +++++-----
 iptables/iptables-save.c     |  4 ++++
 iptables/xtables-restore.c   | 10 +++++-----
 iptables/xtables-save.c      |  4 ++++
 6 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 419a2b0e89cc..39a881dfcee0 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -47,8 +47,6 @@ static const struct option options[] = {
 	{NULL},
 };
 
-static void print_usage(const char *name, const char *version) __attribute__((noreturn));
-
 #define prog_name ip6tables_globals.program_name
 #define prog_vers ip6tables_globals.program_version
 
@@ -65,8 +63,6 @@ static void print_usage(const char *name, const char *version)
 			"	   [ --wait-interval=<usecs>\n"
 			"	   [ --table=<TABLE> ]\n"
 			"	   [ --modprobe=<command> ]\n", name);
-
-	exit(1);
 }
 
 static struct xtc_handle *create_handle(const char *tablename)
@@ -237,7 +233,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 			case 'h':
 				print_usage("ip6tables-restore",
 					    IPTABLES_VERSION);
-				break;
+				exit(0);
 			case 'n':
 				noflush = 1;
 				break;
@@ -253,6 +249,10 @@ int ip6tables_restore_main(int argc, char *argv[])
 			case 'T':
 				tablename = optarg;
 				break;
+			default:
+				fprintf(stderr,
+					"Try `ip6tables-restore -h' for more information.\n");
+				exit(1);
 		}
 	}
 
diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index c2495d20feb9..250ca20492b6 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -162,6 +162,10 @@ int ip6tables_save_main(int argc, char *argv[])
 		case 'd':
 			do_output(tablename);
 			exit(0);
+		default:
+			fprintf(stderr,
+				"Look at manual page `ip6tables-save.8' for more information.\n");
+			exit(1);
 		}
 	}
 
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index cb06559b1906..876fe06d7fa6 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -44,8 +44,6 @@ static const struct option options[] = {
 	{NULL},
 };
 
-static void print_usage(const char *name, const char *version) __attribute__((noreturn));
-
 #define prog_name iptables_globals.program_name
 #define prog_vers iptables_globals.program_version
 
@@ -62,8 +60,6 @@ static void print_usage(const char *name, const char *version)
 			"	   [ --wait-interval=<usecs>\n"
 			"	   [ --table=<TABLE> ]\n"
 			"	   [ --modprobe=<command> ]\n", name);
-
-	exit(1);
 }
 
 static struct xtc_handle *create_handle(const char *tablename)
@@ -235,7 +231,7 @@ iptables_restore_main(int argc, char *argv[])
 			case 'h':
 				print_usage("iptables-restore",
 					    IPTABLES_VERSION);
-				break;
+				exit(0);
 			case 'n':
 				noflush = 1;
 				break;
@@ -251,6 +247,10 @@ iptables_restore_main(int argc, char *argv[])
 			case 'T':
 				tablename = optarg;
 				break;
+			default:
+				fprintf(stderr,
+					"Try `iptables-restore -h' for more information.\n");
+				exit(1);
 		}
 	}
 
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index fbc605932c09..52929b0996e9 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -161,6 +161,10 @@ iptables_save_main(int argc, char *argv[])
 		case 'd':
 			do_output(tablename);
 			exit(0);
+		default:
+			fprintf(stderr,
+				"Look at manual page `iptables-save.8' for more information.\n");
+			exit(1);
 		}
 	}
 
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 6afa0d0ec5b1..15824f0f40b5 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -40,8 +40,6 @@ static const struct option options[] = {
 	{NULL},
 };
 
-static void print_usage(const char *name, const char *version) __attribute__((noreturn));
-
 #define prog_name xtables_globals.program_name
 
 static void print_usage(const char *name, const char *version)
@@ -56,8 +54,6 @@ static void print_usage(const char *name, const char *version)
 			"          [ --modprobe=<command> ]\n"
 			"	   [ --ipv4 ]\n"
 			"	   [ --ipv6 ]\n", name);
-
-	exit(1);
 }
 
 static int parse_counters(char *string, struct xt_counters *ctr)
@@ -486,7 +482,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 			case 'h':
 				print_usage("xtables-restore",
 					    IPTABLES_VERSION);
-				break;
+				exit(0);
 			case 'n':
 				noflush = 1;
 				break;
@@ -503,6 +499,10 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 				h.family = AF_INET6;
 				xtables_set_nfproto(AF_INET6);
 				break;
+			default:
+				fprintf(stderr,
+					"Try `xtables-restore -h' for more information.\n");
+				exit(1);
 		}
 	}
 
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index f30867cf62bb..abd840af6607 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -130,6 +130,10 @@ xtables_save_main(int family, const char *progname, int argc, char *argv[])
 			h.family = AF_INET6;
 			xtables_set_nfproto(AF_INET6);
 			break;
+		default:
+			fprintf(stderr,
+				"Look at manual page `xtables-save.8' for more information.\n");
+			exit(1);
 		}
 	}
 
-- 
2.11.0

