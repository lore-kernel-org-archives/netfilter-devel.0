From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] dstlimit does not support invert
Date: Mon, 20 Sep 2004 16:52:38 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040920235238.GB4094@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="SkvwRMAIpAhPCcCJ"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Like limit match, userspace only partially handled invert case.  Patch
below handles the other one.

Phil




--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-dstlimit

diff -ru ipt-orig/extensions/libipt_dstlimit.c ipt-new/extensions/libipt_dstlimit.c
--- ipt-orig/extensions/libipt_dstlimit.c	2004-02-23 03:10:55.000000000 -0800
+++ ipt-new/extensions/libipt_dstlimit.c	2004-09-20 16:45:19.587967284 -0700
@@ -132,9 +132,7 @@
 
 	switch(c) {
 	case '%':
-		if (check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --dstlimit");
+		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!parse_rate(optarg, &r->cfg.avg))
 			exit_error(PARAMETER_PROBLEM,
 				   "bad rate `%s'", optarg);
@@ -142,10 +140,7 @@
 		break;
 
 	case '$':
-		if (check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --dstlimit-burst");
-
+		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (string_to_number(optarg, 0, 10000, &num) == -1)
 			exit_error(PARAMETER_PROBLEM,
 				   "bad --dstlimit-burst `%s'", optarg);
@@ -153,10 +148,7 @@
 		*flags |= PARAM_BURST;
 		break;
 	case '&':
-		if (check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
-				"Unexpected `!' after --dstlimit-htable-size");
-
+		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (string_to_number(optarg, 0, 0xffffffff, &num) == -1)
 			exit_error(PARAMETER_PROBLEM,
 				"bad --dstlimit-htable-size: `%s'", optarg);
@@ -164,9 +156,7 @@
 		*flags |= PARAM_SIZE;
 		break;
 	case '*':
-		if (check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
-				"Unexpected `!' after --dstlimit-htable-max");
+		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (string_to_number(optarg, 0, 0xffffffff, &num) == -1)
 			exit_error(PARAMETER_PROBLEM,
 				"bad --dstlimit-htable-max: `%s'", optarg);
@@ -174,9 +164,7 @@
 		*flags |= PARAM_MAX;
 		break;
 	case '(':
-		if (check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM, "Unexpected `!' after "
-					"--dstlimit-htable-gcinterval");
+		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (string_to_number(optarg, 0, 0xffffffff, &num) == -1)
 			exit_error(PARAMETER_PROBLEM,
 				"bad --dstlimit-htable-gcinterval: `%s'", 
@@ -186,9 +174,7 @@
 		*flags |= PARAM_GCINTERVAL;
 		break;
 	case ')':
-		if (check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM, "Unexpected `!' after " 
-					"--dstlimit-htable-expire");
+		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (string_to_number(optarg, 0, 0xffffffff, &num) == -1)
 			exit_error(PARAMETER_PROBLEM,
 				"bad --dstlimit-htable-expire: `%s'", optarg);
@@ -197,9 +183,7 @@
 		*flags |= PARAM_EXPIRE;
 		break;
 	case '_':
-		if (check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM, "Unexpected `!' after "
-					"--dstlimit-mode");
+		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!strcmp(optarg, "dstip"))
 			r->cfg.mode = IPT_DSTLIMIT_HASH_DIP;
 		else if (!strcmp(optarg, "dstip-destport") ||
@@ -216,9 +200,7 @@
 		*flags |= PARAM_MODE;
 		break;
 	case '"':
-		if (check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM, "Unexpected `!' after "
-					"--dstlimit-name");
+		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (strlen(optarg) == 0)
 			exit_error(PARAMETER_PROBLEM, "Zero-length name?");
 		strncpy(r->name, optarg, sizeof(r->name));
@@ -228,6 +210,10 @@
 		return 0;
 	}
 
+	if (invert)
+		exit_error(PARAMETER_PROBLEM,
+			   "dstlimit does not support invert");
+
 	return 1;
 }
 

--SkvwRMAIpAhPCcCJ--
