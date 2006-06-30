From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] libiptc symbols clash
Date: Fri, 30 Jun 2006 14:12:48 -0700
Message-ID: <20060630211248.GB9243@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="p4qYPpj5QlsIQJ0K"
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


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As reported by Dmitry Levin, the TC_NUM_RULES and TC_GET_RULE exports
clash.  His patch below, resolving bug #456

Phil



--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-libiptc-rules

diff -ru ipt-orig/libiptc/libip4tc.c ipt-new/libiptc/libip4tc.c
--- ipt-orig/libiptc/libip4tc.c	2005-06-23 01:51:18.000000000 -0700
+++ ipt-new/libiptc/libip4tc.c	2006-06-30 14:05:11.000000000 -0700
@@ -94,6 +94,8 @@
 #define TC_FREE			iptc_free
 #define TC_COMMIT		iptc_commit
 #define TC_STRERROR		iptc_strerror
+#define TC_NUM_RULES		iptc_num_rules
+#define TC_GET_RULE		iptc_get_rule
 
 #define TC_AF			AF_INET
 #define TC_IPPROTO		IPPROTO_IP
diff -ru ipt-orig/libiptc/libip6tc.c ipt-new/libiptc/libip6tc.c
--- ipt-orig/libiptc/libip6tc.c	2005-06-23 01:51:18.000000000 -0700
+++ ipt-new/libiptc/libip6tc.c	2006-06-30 14:05:30.000000000 -0700
@@ -89,6 +89,8 @@
 #define TC_FREE			ip6tc_free
 #define TC_COMMIT		ip6tc_commit
 #define TC_STRERROR		ip6tc_strerror
+#define TC_NUM_RULES		ip6tc_num_rules
+#define TC_GET_RULE		ip6tc_get_rule
 
 #define TC_AF			AF_INET6
 #define TC_IPPROTO		IPPROTO_IPV6

--p4qYPpj5QlsIQJ0K--
