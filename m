From: Vincent Bernat <vincent@bernat.im>
Subject: [PATCH iptables v2] iptables-restore/save: exit when given an unknown option
Date: Fri, 14 Apr 2017 13:56:21 +0200
Message-ID: <20170414115621.13812-1-vincent@bernat.im>
References: <20170413211627.GA2387@salvia>
Cc: Vincent Bernat <vincent@bernat.im>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bart.luffy.cx ([78.47.78.131]:59882 "EHLO bart.luffy.cx"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750784AbdDNL4y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Apr 2017 07:56:54 -0400
In-Reply-To: <20170413211627.GA2387@salvia>
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
index 8a47f09c9503..b12d7f7f22bd 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -46,8 +46,6 @@ static const struct option options[] = {
 	{NULL},
 };
 
-static void print_usage(const char *name, const char *version) __attribute__((noreturn));
-
 static void print_usage(const char *name, const char *version)
 {
 	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h] [-n] [-w secs] [-W usecs] [-T table] [-M command]\n"
@@ -60,8 +58,6 @@ static void print_usage(const char *name, const char *version)
 			"	   [ --wait-interval=<usecs>\n"
 			"	   [ --table=<TABLE> ]\n"
 			"	   [ --modprobe=<command> ]\n", name);
-
-	exit(1);
 }
 
 static struct xtc_handle *create_handle(const char *tablename)
@@ -230,7 +226,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 			case 'h':
 				print_usage("ip6tables-restore",
 					    IPTABLES_VERSION);
-				break;
+				exit(0);
 			case 'n':
 				noflush = 1;
 				break;
@@ -246,6 +242,10 @@ int ip6tables_restore_main(int argc, char *argv[])
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
index 053413a9dfe2..a6006146e460 100644
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
index 7bb06d84b1bf..246ade05b30d 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -43,8 +43,6 @@ static const struct option options[] = {
 	{NULL},
 };
 
-static void print_usage(const char *name, const char *version) __attribute__((noreturn));
-
 #define prog_name iptables_globals.program_name
 
 static void print_usage(const char *name, const char *version)
@@ -59,8 +57,6 @@ static void print_usage(const char *name, const char *version)
 			"	   [ --wait-interval=<usecs>\n"
 			"	   [ --table=<TABLE> ]\n"
 			"	   [ --modprobe=<command> ]\n", name);
-
-	exit(1);
 }
 
 static struct xtc_handle *create_handle(const char *tablename)
@@ -229,7 +225,7 @@ iptables_restore_main(int argc, char *argv[])
 			case 'h':
 				print_usage("iptables-restore",
 					    IPTABLES_VERSION);
-				break;
+				exit(0);
 			case 'n':
 				noflush = 1;
 				break;
@@ -245,6 +241,10 @@ iptables_restore_main(int argc, char *argv[])
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
index e8ae9c6c4cc9..d2c1ca9ecb2b 100644
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
index a551c8c19f7f..f018e6f454d5 100644
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

