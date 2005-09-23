From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom] h323-conntrack-nat: port to Linux 2.6.13+,
	update descriptions
Date: Fri, 23 Sep 2005 09:45:46 +0200
Message-ID: <20050923074546.GA4150@roonstrasse.net>
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
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

h323-port_to_linux_2.6.13.patch
- port to the new API in Linux 2.6.13 and 2.6.14
- prerequisite:
  svn copy patchlets/h323-conntrack-nat/linux-2.6.12 \
    patchlets/h323-conntrack-nat/linux-2.6.13

h323-update_descriptions.patch
- update descriptions, mention "Voice over IP" and "gnomemeeting"
  rather than only "netmeeting"


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="h323-port_to_linux_2.6.13.patch"

Wed Sep 21 21:16:53 CEST 2005  max@duempel.org
  * port to linux 2.6.13
diff -rN -u old-h323-0/patchlets/h323-conntrack-nat/linux-2.6.13/net/ipv4/netfilter/ip_conntrack_h323_h225.c new-h323-0/patchlets/h323-conntrack-nat/linux-2.6.13/net/ipv4/netfilter/ip_conntrack_h323_h225.c
--- old-h323-0/patchlets/h323-conntrack-nat/linux-2.6.13/net/ipv4/netfilter/ip_conntrack_h323_h225.c	2005-09-23 09:42:05.000000000 +0200
+++ new-h323-0/patchlets/h323-conntrack-nat/linux-2.6.13/net/ipv4/netfilter/ip_conntrack_h323_h225.c	2005-09-23 09:02:16.000000000 +0200
@@ -108,7 +108,7 @@
 		}
 		if (ret && ip == ct->tuplehash[dir].tuple.src.ip) {
 			/* match found: create an expectation */
-			exp = ip_conntrack_expect_alloc();
+			exp = ip_conntrack_expect_alloc(ct);
 			if (exp == NULL)
 				return NF_ACCEPT;
 
@@ -127,17 +127,20 @@
 
 			/* call NAT hook and register expectation */
 			if (ip_nat_h225_hook != NULL) {
-				return ip_nat_h225_hook(pskb, ctinfo, i,
-							exp);
+				ret = ip_nat_h225_hook(pskb, ctinfo, i,
+						       exp);
 			} else {
 				/* Can't expect this?  Best to drop packet now. */
 				if (ip_conntrack_expect_related(exp) != 0) {
-					ip_conntrack_expect_free(exp);
-					return NF_DROP;
+					ret = NF_DROP;
 				} else {
-					return NF_ACCEPT;
+					ret = NF_ACCEPT;
 				}
 			}
+
+			ip_conntrack_expect_put(exp);
+
+			return ret;
 		}
 	}
 
diff -rN -u old-h323-0/patchlets/h323-conntrack-nat/linux-2.6.13/net/ipv4/netfilter/ip_conntrack_h323_h245.c new-h323-0/patchlets/h323-conntrack-nat/linux-2.6.13/net/ipv4/netfilter/ip_conntrack_h323_h245.c
--- old-h323-0/patchlets/h323-conntrack-nat/linux-2.6.13/net/ipv4/netfilter/ip_conntrack_h323_h245.c	2005-09-23 09:42:05.000000000 +0200
+++ new-h323-0/patchlets/h323-conntrack-nat/linux-2.6.13/net/ipv4/netfilter/ip_conntrack_h323_h245.c	2005-09-23 09:02:16.000000000 +0200
@@ -296,7 +296,7 @@
 			       NIPQUAD(ip), ntohs(port));
 		if (ret && ip == ct->tuplehash[dir].tuple.src.ip) {
 			/* match found: create an expectation */
-			exp = ip_conntrack_expect_alloc();
+			exp = ip_conntrack_expect_alloc(ct);
 			if (exp == NULL)
 				return NF_ACCEPT;
 
@@ -314,17 +314,20 @@
 
 			/* call NAT hook and register expectation */
 			if (ip_nat_h245_hook != NULL) {
-				return ip_nat_h245_hook(pskb, ctinfo, i,
-							exp);
+				ret = ip_nat_h245_hook(pskb, ctinfo, i, exp);
 			} else {
 				/* Can't expect this?  Best to drop packet now. */
 				if (ip_conntrack_expect_related(exp) != 0) {
-					ip_conntrack_expect_free(exp);
-					return NF_DROP;
+					ret = NF_DROP;
 				} else {
-					return NF_ACCEPT;
+					ret = NF_ACCEPT;
 				}
 			}
+
+			ip_conntrack_expect_put(exp);
+
+			if (ret != NF_ACCEPT)
+				return ret;
 		}
 	}
 
@@ -348,7 +351,7 @@
 			       NIPQUAD(ip), ntohs(port));
 		if (ret && ip == ct->tuplehash[dir].tuple.src.ip) {
 			/* match found: create an expectation */
-			exp = ip_conntrack_expect_alloc();
+			exp = ip_conntrack_expect_alloc(ct);
 			if (exp == NULL)
 				return NF_ACCEPT;
 
@@ -366,17 +369,20 @@
 
 			/* call NAT hook and register expectation */
 			if (ip_nat_h245_hook != NULL) {
-				return ip_nat_h245_hook(pskb, ctinfo, i,
-							exp);
+				ret = ip_nat_h245_hook(pskb, ctinfo, i, exp);
 			} else {
 				/* Can't expect this?  Best to drop packet now. */
 				if (ip_conntrack_expect_related(exp) != 0) {
-					ip_conntrack_expect_free(exp);
-					return NF_DROP;
+					ret = NF_DROP;
 				} else {
-					return NF_ACCEPT;
+					ret = NF_ACCEPT;
 				}
 			}
+
+			ip_conntrack_expect_put(exp);
+
+			if (ret != NF_ACCEPT)
+				return ret;
 		}
 	}
 
@@ -616,7 +622,7 @@
 		       ret, i, ip, port);
 		if (ret && ip == ct->tuplehash[dir].tuple.src.ip) {
 			/* match found: create an expectation */
-			exp = ip_conntrack_expect_alloc();
+			exp = ip_conntrack_expect_alloc(ct);
 			if (exp == NULL)
 				return NF_ACCEPT;
 
@@ -635,17 +641,19 @@
 			/* call NAT hook and register expectation */
 			if (ip_nat_h245_hook != NULL) {
 				ret = ip_nat_h245_hook(pskb, ctinfo, i, exp);
-				if (ret != NF_ACCEPT)
-					return ret;
 			} else {
 				/* Can't expect this?  Best to drop packet now. */
 				if (ip_conntrack_expect_related(exp) != 0) {
-					ip_conntrack_expect_free(exp);
-					return NF_DROP;
+					ret = NF_DROP;
 				} else {
-					return NF_ACCEPT;
+					ret = NF_ACCEPT;
 				}
 			}
+
+			ip_conntrack_expect_put(exp);
+
+			if (ret != NF_ACCEPT)
+				return ret;
 		}
 	}
 
@@ -663,7 +671,7 @@
 		       ret, i, ip, port);
 		if (ret && ip == ct->tuplehash[dir].tuple.src.ip) {
 			/* match found: create an expectation */
-			exp = ip_conntrack_expect_alloc();
+			exp = ip_conntrack_expect_alloc(ct);
 			if (exp == NULL)
 				return NF_ACCEPT;
 
@@ -682,17 +690,19 @@
 			/* call NAT hook and register expectation */
 			if (ip_nat_h245_hook != NULL) {
 				ret = ip_nat_h245_hook(pskb, ctinfo, i, exp);
-				if (ret != NF_ACCEPT)
-					return ret;
 			} else {
 				/* Can't expect this?  Best to drop packet now. */
 				if (ip_conntrack_expect_related(exp) != 0) {
-					ip_conntrack_expect_free(exp);
-					return NF_DROP;
+					ret = NF_DROP;
 				} else {
-					return NF_ACCEPT;
+					ret = NF_ACCEPT;
 				}
 			}
+
+			ip_conntrack_expect_put(exp);
+
+			if (ret != NF_ACCEPT)
+				return ret;
 		}
 	}
 
diff -rN -u old-h323-0/patchlets/h323-conntrack-nat/linux-2.6.13/net/ipv4/netfilter/ip_nat_h323.c new-h323-0/patchlets/h323-conntrack-nat/linux-2.6.13/net/ipv4/netfilter/ip_nat_h323.c
--- old-h323-0/patchlets/h323-conntrack-nat/linux-2.6.13/net/ipv4/netfilter/ip_nat_h323.c	2005-09-23 09:42:05.000000000 +0200
+++ new-h323-0/patchlets/h323-conntrack-nat/linux-2.6.13/net/ipv4/netfilter/ip_nat_h323.c	2005-09-23 09:02:16.000000000 +0200
@@ -108,7 +108,7 @@
 	}
 
 	if (port == 0) {
-		ip_conntrack_expect_free(exp);
+		ip_conntrack_expect_put(exp);
 		return NF_DROP;
 	}
 
@@ -156,7 +156,7 @@
 	}
 
 	if (port == 0) {
-		ip_conntrack_expect_free(exp);
+		ip_conntrack_expect_put(exp);
 		return NF_DROP;
 	}
 


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="h323-update_descriptions.patch"

Wed Sep 21 22:19:04 CEST 2005  max@duempel.org
  * mention gnomemeeting; replace "netmeeting" with "voice over IP"
diff -rN -u old-h323-0/patchlets/h323-conntrack-nat/help new-h323-0/patchlets/h323-conntrack-nat/help
--- old-h323-0/patchlets/h323-conntrack-nat/help	2005-09-23 09:42:16.000000000 +0200
+++ new-h323-0/patchlets/h323-conntrack-nat/help	2005-09-23 09:02:16.000000000 +0200
@@ -1,6 +1,7 @@
 
-This adds CONFIG_IP_NF_H323: H.323/netmeeting support module for netfilter
-connection tracking and NAT. H.323 uses/relies on the following data streams:
+This adds CONFIG_IP_NF_H323: H.323 (voice over IP) support module for
+netfilter connection tracking and NAT. H.323 uses/relies on the
+following data streams:
 
 	Port		Description
 	389 		Internet Locator Server (TCP)
@@ -16,9 +17,11 @@
 search/replace hack from the ip_masq_h323.c module for the 2.2 kernel
 series.
 
-At the very minimum, H.323/netmeeting (video/audio) is functional by letting 
+At the very minimum, H.323 (video/audio) is functional by letting
 trough the 1720 port and loading these H.323 module(s).
 
+This has been tested with Microsoft NetMeeting, gnomemeeting, ohphone.
+
 The H.323 conntrack/NAT modules do not support
 
 - H.245 tunnelling
diff -rN -u old-h323-0/patchlets/h323-conntrack-nat/linux-2.6.13/net/ipv4/netfilter/Kconfig.ladd new-h323-0/patchlets/h323-conntrack-nat/linux-2.6.13/net/ipv4/netfilter/Kconfig.ladd
--- old-h323-0/patchlets/h323-conntrack-nat/linux-2.6.13/net/ipv4/netfilter/Kconfig.ladd	2005-09-23 09:42:16.000000000 +0200
+++ new-h323-0/patchlets/h323-conntrack-nat/linux-2.6.13/net/ipv4/netfilter/Kconfig.ladd	2005-09-23 09:02:16.000000000 +0200
@@ -5,11 +5,11 @@
 	default m if IP_NF_H323=m
 
 config IP_NF_H323
-	tristate  'H.323 (netmeeting) support'
+	tristate  'H.323 (voice over IP) support'
 	depends on IP_NF_CONNTRACK
 	help
 	  H.323 is a standard signalling protocol used by teleconferencing
-	  softwares like netmeeting. With the ip_conntrack_h323 and
+	  software like netmeeting or gnomemeeting. With the ip_conntrack_h323 and
 	  the ip_nat_h323 modules you can support the protocol on a connection
 	  tracking/NATing firewall.
 	


--nFreZHaLTZJo0R7j--
