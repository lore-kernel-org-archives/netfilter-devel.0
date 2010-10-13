From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 4/4] secmark: export secctx, drop secmark in procfs
Date: Wed, 13 Oct 2010 16:25:00 -0400
Message-ID: <20101013202500.15272.92369.stgit@paris.rdu.redhat.com>
References: <20101013202441.15272.75924.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, paul.moore@hp.com, jmorris@namei.org,
	sds@tycho.nsa.gov, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org, selinux@tycho.nsa.gov
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab0JMU0M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Oct 2010 16:26:12 -0400
In-Reply-To: <20101013202441.15272.75924.stgit@paris.rdu.redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The current secmark code exports a secmark= field which just indicates if
there is special labeling on a packet or not.  We drop this field as it
isn't particularly useful and instead export a new field secctx= which is
the actual human readable text label.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |   28 ++++++++++++++++++--
 net/netfilter/nf_conntrack_standalone.c            |   28 ++++++++++++++++++--
 2 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 244f7cb..37f8adb 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -11,6 +11,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/percpu.h>
+#include <linux/security.h>
 #include <net/net_namespace.h>
 
 #include <linux/netfilter.h>
@@ -87,6 +88,29 @@ static void ct_seq_stop(struct seq_file *s, void *v)
 	rcu_read_unlock();
 }
 
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
+{
+	int ret;
+	u32 len;
+	char *secctx;
+
+	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
+	if (ret)
+		return ret;
+
+	ret = seq_printf(s, "secctx=%s ", secctx);
+
+	security_release_secctx(secctx, len);
+	return ret;
+}
+#else
+static inline int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
+{
+	return 0;
+}
+#endif
+
 static int ct_seq_show(struct seq_file *s, void *v)
 {
 	struct nf_conntrack_tuple_hash *hash = v;
@@ -148,10 +172,8 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		goto release;
 #endif
 
-#ifdef CONFIG_NF_CONNTRACK_SECMARK
-	if (seq_printf(s, "secmark=%u ", ct->secmark))
+	if (ct_show_secctx(s, ct))
 		goto release;
-#endif
 
 	if (seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use)))
 		goto release;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index eb973fc..0fb6570 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -15,6 +15,7 @@
 #include <linux/seq_file.h>
 #include <linux/percpu.h>
 #include <linux/netdevice.h>
+#include <linux/security.h>
 #include <net/net_namespace.h>
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
@@ -108,6 +109,29 @@ static void ct_seq_stop(struct seq_file *s, void *v)
 	rcu_read_unlock();
 }
 
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
+{
+	int ret;
+	u32 len;
+	char *secctx;
+
+	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
+	if (ret)
+		return ret;
+
+	ret = seq_printf(s, "secctx=%s ", secctx);
+
+	security_release_secctx(secctx, len);
+	return ret;
+}
+#else
+static inline int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
+{
+	return 0;
+}
+#endif
+
 /* return 0 on success, 1 in case of error */
 static int ct_seq_show(struct seq_file *s, void *v)
 {
@@ -168,10 +192,8 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		goto release;
 #endif
 
-#ifdef CONFIG_NF_CONNTRACK_SECMARK
-	if (seq_printf(s, "secmark=%u ", ct->secmark))
+	if (ct_show_secctx(s, ct))
 		goto release;
-#endif
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	if (seq_printf(s, "zone=%u ", nf_ct_zone(ct)))

