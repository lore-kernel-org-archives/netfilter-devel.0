From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] ipv6 limit match does not support invert
Date: Mon, 20 Sep 2004 16:57:48 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040920235748.GC4094@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="KDt/GgjP6HVcx58l"
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


--KDt/GgjP6HVcx58l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Should have included this in earlier ipv4 version, but here is the
ipv6 version which clarifies that invert is not supported by limit.

Phil



--KDt/GgjP6HVcx58l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ipv6limit

diff -ru ipt-orig/extensions/libip6t_limit.c ipt-new/extensions/libip6t_limit.c
--- ipt-orig/extensions/libip6t_limit.c	2004-06-14 15:02:16.000000000 -0700
+++ ipt-new/extensions/libip6t_limit.c	2004-09-20 16:55:14.752980888 -0700
@@ -104,19 +104,14 @@
 
 	switch(c) {
 	case '%':
-		if (check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --limit");
+		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!parse_rate(optarg, &r->avg))
 			exit_error(PARAMETER_PROBLEM,
 				   "bad rate `%s'", optarg);
 		break;
 
 	case '$':
-		if (check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --limit-burst");
-
+		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (string_to_number(optarg, 0, 10000, &num) == -1)
 			exit_error(PARAMETER_PROBLEM,
 				   "bad --limit-burst `%s'", optarg);
@@ -127,6 +122,10 @@
 		return 0;
 	}
 
+	if (invert)
+		exit_error(PARAMETER_PROBLEM,
+			   "limit does not support invert");
+
 	return 1;
 }
 

--KDt/GgjP6HVcx58l--
