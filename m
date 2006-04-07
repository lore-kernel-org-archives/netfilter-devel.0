From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 2/3] [libnetfilter_conntrack] fixed duration connection
Date: Fri, 07 Apr 2006 23:59:18 +0200
Message-ID: <4436E0B6.9040602@inl.fr>
References: <1144139619.5186.24.camel@localhost.localdomain>
	<4433CCBF.6060103@trash.net> <4436DF6B.4060208@inl.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010306090804030803060402"
Cc: Patrick McHardy <kaber@trash.net>, nufw-devel@nongnu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <4436DF6B.4060208@inl.fr>
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

This is a multi-part message in MIME format.
--------------010306090804030803060402
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi,

This patch add support for the IPS_FIXED_TIMEOUT state.

BR,
--
Regit

--------------010306090804030803060402
Content-Type: text/x-patch;
	name="libnetfilter_conntrack_fixed_timeout-flag.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
	filename="libnetfilter_conntrack_fixed_timeout-flag.patch"

Index: include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
===================================================================
--- include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h	(révision 6576)
+++ include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h	(copie de travail)
@@ -29,6 +29,7 @@
 	CTA_HELP,
 	CTA_NAT,
 	CTA_TIMEOUT,
+	CTA_FIXED_TIMEOUT,
 	CTA_MARK,
 	CTA_COUNTERS_ORIG,
 	CTA_COUNTERS_REPLY,
Index: include/libnetfilter_conntrack/libnetfilter_conntrack.h
===================================================================
--- include/libnetfilter_conntrack/libnetfilter_conntrack.h	(révision 6576)
+++ include/libnetfilter_conntrack/libnetfilter_conntrack.h	(copie de travail)
@@ -89,6 +89,7 @@
 	struct nfct_tuple tuple[NFCT_DIR_MAX];
 	
 	u_int32_t 	timeout;
+	u_int32_t 	fixed_timeout;
 	u_int32_t	mark;
 	u_int32_t 	status;
 	u_int32_t	use;
@@ -125,19 +126,22 @@
 	NFCT_TIMEOUT_BIT = 2,
 	NFCT_TIMEOUT = (1 << NFCT_TIMEOUT_BIT),
 
-	NFCT_MARK_BIT = 3,
+        NFCT_FIXED_TIMEOUT_BIT = 3,
+	NFCT_FIXED_TIMEOUT = (1 << NFCT_FIXED_TIMEOUT_BIT),
+
+	NFCT_MARK_BIT = 4,
 	NFCT_MARK = (1 << NFCT_MARK_BIT),
 
-	NFCT_COUNTERS_ORIG_BIT = 4,
+	NFCT_COUNTERS_ORIG_BIT = 5,
 	NFCT_COUNTERS_ORIG = (1 << NFCT_COUNTERS_ORIG_BIT),
 
-	NFCT_COUNTERS_RPLY_BIT = 5,
+	NFCT_COUNTERS_RPLY_BIT = 6,
 	NFCT_COUNTERS_RPLY = (1 << NFCT_COUNTERS_RPLY_BIT),
 
-	NFCT_USE_BIT = 6,
+	NFCT_USE_BIT = 7,
 	NFCT_USE = (1 << NFCT_USE_BIT),
 
-	NFCT_ID_BIT = 7,
+	NFCT_ID_BIT = 8,
 	NFCT_ID = (1 << NFCT_ID_BIT)
 };
 
Index: src/libnetfilter_conntrack.c
===================================================================
--- src/libnetfilter_conntrack.c	(révision 6576)
+++ src/libnetfilter_conntrack.c	(copie de travail)
@@ -548,6 +548,11 @@
 		flags |= NFCT_TIMEOUT;
 	}
 	
+        if (cda[CTA_FIXED_TIMEOUT-1]) {
+		ct.fixed_timeout = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_FIXED_TIMEOUT-1]));
+		flags |= NFCT_FIXED_TIMEOUT;
+	}
+
 	if (cda[CTA_MARK-1]) {
 		ct.mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
 		flags |= NFCT_MARK;
@@ -596,6 +601,13 @@
 	return sprintf(buf, "%u ", ct->timeout);
 }
 
+int nfct_sprintf_fixed_timeout(char *buf, struct nfct_conntrack *ct)
+{
+	return sprintf(buf, "%u ", ct->fixed_timeout);
+}
+
+
+
 int nfct_sprintf_protoinfo(char *buf, struct nfct_conntrack *ct)
 {
 	int size = 0;
@@ -664,7 +676,10 @@
 	if (flags & NFCT_TIMEOUT)
 		size += nfct_sprintf_timeout(buf+size, ct);
 
-        if (flags & NFCT_PROTOINFO)
+	if (flags & NFCT_FIXED_TIMEOUT)
+		size += nfct_sprintf_fixed_timeout(buf+size, ct);
+
+    if (flags & NFCT_PROTOINFO)
 		size += nfct_sprintf_protoinfo(buf+size, ct);
 
 	size += nfct_sprintf_address(buf+size, &ct->tuple[NFCT_DIR_ORIGINAL]);
@@ -954,6 +969,7 @@
 	char buf[NFCT_BUFSIZE];
 	u_int32_t status = htonl(ct->status | IPS_CONFIRMED);
 	u_int32_t timeout = htonl(ct->timeout);
+	u_int32_t fixed_timeout = htonl(ct->fixed_timeout);
 	u_int32_t mark = htonl(ct->mark);
 	u_int8_t l3num = ct->tuple[NFCT_DIR_ORIGINAL].l3protonum;
 
@@ -975,6 +991,10 @@
 
 	nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_TIMEOUT, &timeout, 
 		       sizeof(u_int32_t));
+
+        if (fixed_timeout)
+	        nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_FIXED_TIMEOUT, &fixed_timeout, 
+		               sizeof(u_int32_t));
 	
 	if (ct->mark != 0)
 		nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_MARK, &mark,
@@ -993,6 +1013,7 @@
 	char buf[NFCT_BUFSIZE];
 	u_int32_t status = htonl(ct->status | IPS_CONFIRMED);
 	u_int32_t timeout = htonl(ct->timeout);
+	u_int32_t fixed_timeout = htonl(ct->fixed_timeout);
 	u_int32_t id = htonl(ct->id);
 	u_int32_t mark = htonl(ct->mark);
 	u_int8_t l3num = ct->tuple[NFCT_DIR_ORIGINAL].l3protonum;
@@ -1015,7 +1036,12 @@
 	if (ct->timeout != 0)
 		nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_TIMEOUT, &timeout, 
 			       sizeof(u_int32_t));
+
+        if (ct->fixed_timeout != 0)
+		nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_FIXED_TIMEOUT, &fixed_timeout, 
+			       sizeof(u_int32_t));
 	
+	
 	if (ct->mark != 0)
 		nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_MARK, &mark,
 			       sizeof(u_int32_t));

--------------010306090804030803060402--
