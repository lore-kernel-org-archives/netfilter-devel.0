From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] multiport does not support invert
Date: Fri, 17 Sep 2004 15:10:15 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040917221015.GA3228@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
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


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

A few weeks back I submitted a patch to document the invert option
of multiport, without noticing that it doesn't actually support invert.
I've looked at it, and it is a compatibility nightmare to try to add
support for it while still supporting old kernel/userspace.

So, here's a patch to throw an error on this:

    iptables -A FORWARD -m multiport -p tcp ! --dport 1,2,3 -j DROP

instead of silently accepting it and potentially causing issues.

Phil




--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-mportinvert

diff -ru ipt-orig/extensions/libip6t_multiport.c ipt-new/extensions/libip6t_multiport.c
--- ipt-orig/extensions/libip6t_multiport.c	2003-07-14 13:01:29.000000000 -0700
+++ ipt-new/extensions/libip6t_multiport.c	2004-09-17 14:55:12.742905519 -0700
@@ -115,6 +115,7 @@
 		proto = check_proto(entry);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
+		check_inverse(optarg, &invert, &optind, 0);
 		multiinfo->flags = IP6T_MULTIPORT_SOURCE;
 		*nfcache |= NFC_IP6_SRC_PT;
 		break;
@@ -123,6 +124,7 @@
 		proto = check_proto(entry);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
+		check_inverse(optarg, &invert, &optind, 0);
 		multiinfo->flags = IP6T_MULTIPORT_DESTINATION;
 		*nfcache |= NFC_IP6_DST_PT;
 		break;
@@ -131,6 +133,7 @@
 		proto = check_proto(entry);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
+		check_inverse(optarg, &invert, &optind, 0);
 		multiinfo->flags = IP6T_MULTIPORT_EITHER;
 		*nfcache |= NFC_IP6_SRC_PT | NFC_IP6_DST_PT;
 		break;
@@ -139,6 +142,10 @@
 		return 0;
 	}
 
+	if (invert)
+		exit_error(PARAMETER_PROBLEM,
+			   "multiport does not support invert");
+
 	if (*flags)
 		exit_error(PARAMETER_PROBLEM,
 			   "multiport can only have one option");
diff -ru ipt-orig/extensions/libipt_mport.c ipt-new/extensions/libipt_mport.c
--- ipt-orig/extensions/libipt_mport.c	2003-07-14 13:01:29.000000000 -0700
+++ ipt-new/extensions/libipt_mport.c	2004-09-17 14:56:23.797364198 -0700
@@ -139,6 +139,7 @@
 		proto = check_proto(entry);
 		parse_multi_ports(argv[optind-1], minfo, proto);
 		minfo->flags = IPT_MPORT_SOURCE;
+		check_inverse(optarg, &invert, &optind, 0);
 		*nfcache |= NFC_IP_SRC_PT;
 		break;
 
@@ -146,6 +147,7 @@
 		proto = check_proto(entry);
 		parse_multi_ports(argv[optind-1], minfo, proto);
 		minfo->flags = IPT_MPORT_DESTINATION;
+		check_inverse(optarg, &invert, &optind, 0);
 		*nfcache |= NFC_IP_DST_PT;
 		break;
 
@@ -153,6 +155,7 @@
 		proto = check_proto(entry);
 		parse_multi_ports(argv[optind-1], minfo, proto);
 		minfo->flags = IPT_MPORT_EITHER;
+		check_inverse(optarg, &invert, &optind, 0);
 		*nfcache |= NFC_IP_SRC_PT | NFC_IP_DST_PT;
 		break;
 
@@ -160,6 +163,10 @@
 		return 0;
 	}
 
+	if (invert)
+		exit_error(PARAMETER_PROBLEM,
+			   "multiport does not support invert");
+
 	if (*flags)
 		exit_error(PARAMETER_PROBLEM,
 			   "multiport can only have one option");
diff -ru ipt-orig/extensions/libipt_multiport.c ipt-new/extensions/libipt_multiport.c
--- ipt-orig/extensions/libipt_multiport.c	2003-07-14 13:01:29.000000000 -0700
+++ ipt-new/extensions/libipt_multiport.c	2004-09-17 14:51:55.374634873 -0700
@@ -115,6 +115,7 @@
 		proto = check_proto(entry);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
+		check_inverse(optarg, &invert, &optind, 0);
 		multiinfo->flags = IPT_MULTIPORT_SOURCE;
 		*nfcache |= NFC_IP_SRC_PT;
 		break;
@@ -123,6 +124,7 @@
 		proto = check_proto(entry);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
+		check_inverse(optarg, &invert, &optind, 0);
 		multiinfo->flags = IPT_MULTIPORT_DESTINATION;
 		*nfcache |= NFC_IP_DST_PT;
 		break;
@@ -131,6 +133,7 @@
 		proto = check_proto(entry);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
+		check_inverse(optarg, &invert, &optind, 0);
 		multiinfo->flags = IPT_MULTIPORT_EITHER;
 		*nfcache |= NFC_IP_SRC_PT | NFC_IP_DST_PT;
 		break;
@@ -139,6 +142,10 @@
 		return 0;
 	}
 
+	if (invert)
+		exit_error(PARAMETER_PROBLEM,
+			   "multiport does not support invert");
+
 	if (*flags)
 		exit_error(PARAMETER_PROBLEM,
 			   "multiport can only have one option");

--nFreZHaLTZJo0R7j--
