From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] limit match does not support invert
Date: Mon, 20 Sep 2004 16:32:52 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040920233252.GA4094@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="9jxsPFA5p3P2qPhR"
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


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Limit match does not support invert, and without loss of backwards
compatibility, it won't anytime soon.  It doesn't help that the
iptables tutorial claims it does.

The userspace code tries to warn users it won't work, but only correctly
deals with one of the two possible invert cases:

# iptables -A foo -m limit --limit ! 1/sec
iptables v1.2.11: Unexpected `!' after --limit
Try `iptables -h' or 'iptables --help' for more information.

but not this one:

# iptables -A foo -m limit ! --limit 1/sec    

The below patch fixes this up, closing bugzilla #95, perhaps to the
chagrin of those who would like to see limit support invert.

Phil




--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-limitinvert

diff -ru ipt-orig/extensions/libipt_limit.c ipt-new/extensions/libipt_limit.c
--- ipt-orig/extensions/libipt_limit.c	2004-06-14 15:02:17.000000000 -0700
+++ ipt-new/extensions/libipt_limit.c	2004-09-20 16:25:00.344128844 -0700
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
 

--9jxsPFA5p3P2qPhR--
