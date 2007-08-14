From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH] libnetfilter_conntrack: Fix getters for big-endian
Date: Tue, 14 Aug 2007 17:18:20 +1000
Message-ID: <46C1573C.7000005@snapgear.com>
Mime-Version: 1.0
Content-Type: text/x-diff;
 name="libnfct-endian.patch"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline;
 filename="libnfct-endian.patch"
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

The getters have to point to the right sized types, otherwise
they don't work on big-endian.

Signed-off-by: Philip Craig <philipc@snapgear.com>

Index: libnetfilter_conntrack/src/conntrack/api.c
===================================================================
--- libnetfilter_conntrack.orig/src/conntrack/api.c	2007-08-14 15:48:07.000000000 +1000
+++ libnetfilter_conntrack/src/conntrack/api.c	2007-08-14 16:00:02.000000000 +1000
@@ -304,7 +304,7 @@
 u_int8_t nfct_get_attr_u8(const struct nf_conntrack *ct,
 			  const enum nf_conntrack_attr type)
 {
-	const int *ret = nfct_get_attr(ct, type);
+	const u_int8_t *ret = nfct_get_attr(ct, type);
 	return ret == NULL ? 0 : *ret;
 }
 
@@ -320,7 +320,7 @@
 u_int16_t nfct_get_attr_u16(const struct nf_conntrack *ct,
 			    const enum nf_conntrack_attr type)
 {
-	const int *ret = nfct_get_attr(ct, type);
+	const u_int16_t *ret = nfct_get_attr(ct, type);
 	return ret == NULL ? 0 : *ret;
 }
 
@@ -336,7 +336,7 @@
 u_int32_t nfct_get_attr_u32(const struct nf_conntrack *ct,
 			    const enum nf_conntrack_attr type)
 {
-	const int *ret = nfct_get_attr(ct, type);
+	const u_int32_t *ret = nfct_get_attr(ct, type);
 	return ret == NULL ? 0 : *ret;
 }
 
Index: libnetfilter_conntrack/src/expect/api.c
===================================================================
--- libnetfilter_conntrack.orig/src/expect/api.c	2007-08-14 15:48:07.000000000 +1000
+++ libnetfilter_conntrack/src/expect/api.c	2007-08-14 16:00:02.000000000 +1000
@@ -264,7 +264,7 @@
 u_int8_t nfexp_get_attr_u8(const struct nf_expect *exp,
 			   const enum nf_expect_attr type)
 {
-	const int *ret = nfexp_get_attr(exp, type);
+	const u_int8_t *ret = nfexp_get_attr(exp, type);
 	return ret == NULL ? 0 : *ret;
 }
 
@@ -280,7 +280,7 @@
 u_int16_t nfexp_get_attr_u16(const struct nf_expect *exp,
 			     const enum nf_expect_attr type)
 {
-	const int *ret = nfexp_get_attr(exp, type);
+	const u_int16_t *ret = nfexp_get_attr(exp, type);
 	return ret == NULL ? 0 : *ret;
 }
 
@@ -296,7 +296,7 @@
 u_int32_t nfexp_get_attr_u32(const struct nf_expect *exp,
 			    const enum nf_expect_attr type)
 {
-	const int *ret = nfexp_get_attr(exp, type);
+	const u_int32_t *ret = nfexp_get_attr(exp, type);
 	return ret == NULL ? 0 : *ret;
 }
 
