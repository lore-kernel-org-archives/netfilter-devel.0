From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH] libnetfilter_conntrack: Packet/byte counters are 64 bit
Date: Tue, 14 Aug 2007 17:19:22 +1000
Message-ID: <46C1577A.1010308@snapgear.com>
Mime-Version: 1.0
Content-Type: text/x-diff;
 name="libnfct-counter64.patch"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline;
 filename="libnfct-counter64.patch"
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

The counters in struct nf_conntrack are 64 bit, so the getter/setter
have to access them as such.

Signed-off-by: Philip Craig <philipc@snapgear.com>

Index: libnetfilter_conntrack/src/conntrack/api.c
===================================================================
--- libnetfilter_conntrack.orig/src/conntrack/api.c	2007-08-14 16:00:51.000000000 +1000
+++ libnetfilter_conntrack/src/conntrack/api.c	2007-08-14 16:04:21.000000000 +1000
@@ -267,6 +267,19 @@
 }
 
 /**
+ * nfct_set_attr_u64 - set the value of a certain conntrack attribute
+ * @ct: pointer to a valid conntrack
+ * @type: attribute type
+ * @value: unsigned 64 bits attribute value
+ */
+void nfct_set_attr_u64(struct nf_conntrack *ct,
+		       const enum nf_conntrack_attr type,
+		       u_int64_t value)
+{
+	nfct_set_attr(ct, type, &value);
+}
+
+/**
  * nfct_get_attr - get a conntrack attribute
  * ct: pointer to a valid conntrack
  * @type: attribute type
@@ -341,6 +354,22 @@
 }
 
 /**
+ * nfct_get_attr_u64 - get attribute of unsigned 64-bits long
+ * @ct: pointer to a valid conntrack
+ * @type: attribute type
+ *
+ * Returns the value of the requested attribute, if the attribute is not
+ * set, 0 is returned. In order to check if the attribute is set or not,
+ * use nfct_attr_is_set.
+ */
+u_int64_t nfct_get_attr_u64(const struct nf_conntrack *ct,
+			    const enum nf_conntrack_attr type)
+{
+	const u_int64_t *ret = nfct_get_attr(ct, type);
+	return ret == NULL ? 0 : *ret;
+}
+
+/**
  * nfct_attr_is_set - check if a certain attribute is set
  * @ct: pointer to a valid conntrack object
  * @type: attribute type
Index: libnetfilter_conntrack/include/libnetfilter_conntrack/libnetfilter_conntrack.h
===================================================================
--- libnetfilter_conntrack.orig/include/libnetfilter_conntrack/libnetfilter_conntrack.h	2007-08-14 16:03:14.000000000 +1000
+++ libnetfilter_conntrack/include/libnetfilter_conntrack/libnetfilter_conntrack.h	2007-08-14 16:03:32.000000000 +1000
@@ -91,10 +91,10 @@
 	ATTR_DNAT_PORT,				/* u16 bits */
 	ATTR_TIMEOUT = 24,			/* u32 bits */
 	ATTR_MARK,				/* u32 bits */
-	ATTR_ORIG_COUNTER_PACKETS,		/* u32 bits */
-	ATTR_REPL_COUNTER_PACKETS,		/* u32 bits */
-	ATTR_ORIG_COUNTER_BYTES = 28,		/* u32 bits */
-	ATTR_REPL_COUNTER_BYTES,		/* u32 bits */
+	ATTR_ORIG_COUNTER_PACKETS,		/* u64 bits */
+	ATTR_REPL_COUNTER_PACKETS,		/* u64 bits */
+	ATTR_ORIG_COUNTER_BYTES = 28,		/* u64 bits */
+	ATTR_REPL_COUNTER_BYTES,		/* u64 bits */
 	ATTR_USE,				/* u32 bits */
 	ATTR_ID,				/* u32 bits */
 	ATTR_STATUS = 32,			/* u32 bits  */
@@ -194,6 +194,10 @@
 			      const enum nf_conntrack_attr type,
 			      u_int32_t value);
 
+extern void nfct_set_attr_u64(struct nf_conntrack *ct,
+			      const enum nf_conntrack_attr type,
+			      u_int64_t value);
+
 /* getter */
 extern const void *nfct_get_attr(const struct nf_conntrack *ct,
 				 const enum nf_conntrack_attr type);
@@ -207,6 +211,9 @@
 extern u_int32_t nfct_get_attr_u32(const struct nf_conntrack *ct,
 				   const enum nf_conntrack_attr type);
 
+extern u_int64_t nfct_get_attr_u64(const struct nf_conntrack *ct,
+				   const enum nf_conntrack_attr type);
+
 /* checker */
 extern int nfct_attr_is_set(const struct nf_conntrack *ct,
 			    const enum nf_conntrack_attr type);
