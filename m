From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 11/18] Netfilter:  iptables revision getsockopt
Date: Wed, 05 Jan 2005 14:34:14 +1100
Message-ID: <1104896054.20582.75.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Linus Torvalds <torvalds@osdl.org>
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

Name: iptables revision getsockopt
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

This adds a new getsockopt to iptables, which allows userspace to
query the revision number of extensions.  iptables 1.3.0 (to be
released soon) already has support for this.

Index: linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_tables.c
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/net/ipv4/netfilter/ip_tables.c	2004-12-31 21:30:54.000000000 +1100
+++ linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_tables.c	2005-01-01 10:51:37.363095768 +1100
@@ -488,6 +488,65 @@
 	return ERR_PTR(-EPROTOTYPE);
 }
 
+static int match_revfn(const char *name, u8 revision, int *bestp)
+{
+	struct ipt_match *m;
+	int have_rev = 0;
+
+	list_for_each_entry(m, &ipt_match, list) {
+		if (strcmp(m->name, name) == 0) {
+			if (m->revision > *bestp)
+				*bestp = m->revision;
+			if (m->revision == revision)
+				have_rev = 1;
+		}
+	}
+	return have_rev;
+}
+
+static int target_revfn(const char *name, u8 revision, int *bestp)
+{
+	struct ipt_target *t;
+	int have_rev = 0;
+
+	list_for_each_entry(t, &ipt_target, list) {
+		if (strcmp(t->name, name) == 0) {
+			if (t->revision > *bestp)
+				*bestp = t->revision;
+			if (t->revision == revision)
+				have_rev = 1;
+		}
+	}
+	return have_rev;
+}
+
+/* Returns true or false (if no such extension at all) */
+static inline int find_revision(const char *name, u8 revision,
+				int (*revfn)(const char *, u8, int *),
+				int *err)
+{
+	int have_rev, best = -1;
+
+	if (down_interruptible(&ipt_mutex) != 0) {
+		*err = -EINTR;
+		return 1;
+	}
+	have_rev = revfn(name, revision, &best);
+	up(&ipt_mutex);
+
+	/* Nothing at all?  Return 0 to try loading module. */
+	if (best == -1) {
+		*err = -ENOENT;
+		return 0;
+	}
+
+	*err = best;
+	if (!have_rev)
+		*err = -EPROTONOSUPPORT;
+	return 1;
+}
+
+
 /* All zeroes == unconditional rule. */
 static inline int
 unconditional(const struct ipt_ip *ip)
@@ -1316,6 +1375,31 @@
 		break;
 	}
 
+	case IPT_SO_GET_REVISION_MATCH:
+	case IPT_SO_GET_REVISION_TARGET: {
+		struct ipt_get_revision rev;
+		int (*revfn)(const char *, u8, int *);
+
+		if (*len != sizeof(rev)) {
+			ret = -EINVAL;
+			break;
+		}
+		if (copy_from_user(&rev, user, sizeof(rev)) != 0) {
+			ret = -EFAULT;
+			break;
+		}
+
+		if (cmd == IPT_SO_GET_REVISION_TARGET)
+			revfn = target_revfn;
+		else
+			revfn = match_revfn;
+
+		try_then_request_module(find_revision(rev.name, rev.revision,
+						      revfn, &ret),
+					"ipt_%s", rev.name);
+		break;
+	}
+
 	default:
 		duprintf("do_ipt_get_ctl: unknown request %i\n", cmd);
 		ret = -EINVAL;
Index: linux-2.6.10-bk1-Netfilter/include/linux/netfilter_ipv4/ip_tables.h
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/include/linux/netfilter_ipv4/ip_tables.h	2004-12-31 21:30:54.000000000 +1100
+++ linux-2.6.10-bk1-Netfilter/include/linux/netfilter_ipv4/ip_tables.h	2004-12-31 21:31:06.000000000 +1100
@@ -156,9 +156,11 @@
 #define IPT_SO_SET_ADD_COUNTERS	(IPT_BASE_CTL + 1)
 #define IPT_SO_SET_MAX		IPT_SO_SET_ADD_COUNTERS
 
-#define IPT_SO_GET_INFO		(IPT_BASE_CTL)
-#define IPT_SO_GET_ENTRIES	(IPT_BASE_CTL + 1)
-#define IPT_SO_GET_MAX		IPT_SO_GET_ENTRIES
+#define IPT_SO_GET_INFO			(IPT_BASE_CTL)
+#define IPT_SO_GET_ENTRIES		(IPT_BASE_CTL + 1)
+#define IPT_SO_GET_REVISION_MATCH	(IPT_BASE_CTL + 2)
+#define IPT_SO_GET_REVISION_TARGET	(IPT_BASE_CTL + 3)
+#define IPT_SO_GET_MAX			IPT_SO_GET_REVISION_TARGET
 
 /* CONTINUE verdict for targets */
 #define IPT_CONTINUE 0xFFFFFFFF
@@ -288,6 +290,15 @@
 	struct ipt_entry entrytable[0];
 };
 
+/* The argument to IPT_SO_GET_REVISION_*.  Returns highest revision
+ * kernel supports, if >= revision. */
+struct ipt_get_revision
+{
+	char name[IPT_FUNCTION_MAXNAMELEN-1];
+
+	u_int8_t revision;
+};
+
 /* Standard return verdict, or do jump. */
 #define IPT_STANDARD_TARGET ""
 /* Error verdict. */
