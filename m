From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/4] secmark: make secmark object handling generic
Date: Wed, 13 Oct 2010 16:24:41 -0400
Message-ID: <20101013202441.15272.75924.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, paul.moore@hp.com, jmorris@namei.org,
	sds@tycho.nsa.gov, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org, selinux@tycho.nsa.gov
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab0JMU0L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Oct 2010 16:26:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Right now secmark has lots of direct selinux calls.  Use all LSM calls and
remove all SELinux specific knowledge.  The only SELinux specific knowledge
we leave is the mode.  The only point is to make sure that other LSMs at
least test this generic code before they assume it works.  (They may also
have to make changes if they do not represent labels as strings)

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Paul Moore <paul.moore@hp.com>
---

 include/linux/netfilter/xt_SECMARK.h |   12 ++----
 include/linux/security.h             |   25 +++++++++++++
 include/linux/selinux.h              |   63 ----------------------------------
 net/netfilter/xt_CT.c                |    1 -
 net/netfilter/xt_SECMARK.c           |   35 +++++++++----------
 security/capability.c                |   17 +++++++++
 security/security.c                  |   18 ++++++++++
 security/selinux/exports.c           |   49 --------------------------
 security/selinux/hooks.c             |   24 +++++++++++++
 security/selinux/include/security.h  |    1 +
 10 files changed, 104 insertions(+), 141 deletions(-)

diff --git a/include/linux/netfilter/xt_SECMARK.h b/include/linux/netfilter/xt_SECMARK.h
index 6fcd344..989092b 100644
--- a/include/linux/netfilter/xt_SECMARK.h
+++ b/include/linux/netfilter/xt_SECMARK.h
@@ -11,18 +11,12 @@
  * packets are being marked for.
  */
 #define SECMARK_MODE_SEL	0x01		/* SELinux */
-#define SECMARK_SELCTX_MAX	256
-
-struct xt_secmark_target_selinux_info {
-	__u32 selsid;
-	char selctx[SECMARK_SELCTX_MAX];
-};
+#define SECMARK_SECCTX_MAX	256
 
 struct xt_secmark_target_info {
 	__u8 mode;
-	union {
-		struct xt_secmark_target_selinux_info sel;
-	} u;
+	__u32 secid;
+	char secctx[SECMARK_SECCTX_MAX];
 };
 
 #endif /*_XT_SECMARK_H_target */
diff --git a/include/linux/security.h b/include/linux/security.h
index 43771c8..f050119 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -960,6 +960,12 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	Sets the new child socket's sid to the openreq sid.
  * @inet_conn_established:
  *	Sets the connection's peersid to the secmark on skb.
+ * @secmark_relabel_packet:
+ *	check if the process should be allowed to relabel packets to the given secid
+ * @security_secmark_refcount_inc
+ *	tells the LSM to increment the number of secmark labeling rules loaded
+ * @security_secmark_refcount_dec
+ *	tells the LSM to decrement the number of secmark labeling rules loaded
  * @req_classify_flow:
  *	Sets the flow's sid to the openreq sid.
  * @tun_dev_create:
@@ -1596,6 +1602,9 @@ struct security_operations {
 				  struct request_sock *req);
 	void (*inet_csk_clone) (struct sock *newsk, const struct request_sock *req);
 	void (*inet_conn_established) (struct sock *sk, struct sk_buff *skb);
+	int (*secmark_relabel_packet) (u32 secid);
+	void (*secmark_refcount_inc) (void);
+	void (*secmark_refcount_dec) (void);
 	void (*req_classify_flow) (const struct request_sock *req, struct flowi *fl);
 	int (*tun_dev_create)(void);
 	void (*tun_dev_post_create)(struct sock *sk);
@@ -2556,6 +2565,9 @@ void security_inet_csk_clone(struct sock *newsk,
 			const struct request_sock *req);
 void security_inet_conn_established(struct sock *sk,
 			struct sk_buff *skb);
+int security_secmark_relabel_packet(u32 secid);
+void security_secmark_refcount_inc(void);
+void security_secmark_refcount_dec(void);
 int security_tun_dev_create(void);
 void security_tun_dev_post_create(struct sock *sk);
 int security_tun_dev_attach(struct sock *sk);
@@ -2710,6 +2722,19 @@ static inline void security_inet_conn_established(struct sock *sk,
 {
 }
 
+static inline int security_secmark_relabel_packet(u32 secid)
+{
+	return 0;
+}
+
+static inline void security_secmark_refcount_inc(void)
+{
+}
+
+static inline void security_secmark_refcount_dec(void)
+{
+}
+
 static inline int security_tun_dev_create(void)
 {
 	return 0;
diff --git a/include/linux/selinux.h b/include/linux/selinux.h
index 82e0f26..44f4596 100644
--- a/include/linux/selinux.h
+++ b/include/linux/selinux.h
@@ -21,74 +21,11 @@ struct kern_ipc_perm;
 #ifdef CONFIG_SECURITY_SELINUX
 
 /**
- *     selinux_string_to_sid - map a security context string to a security ID
- *     @str: the security context string to be mapped
- *     @sid: ID value returned via this.
- *
- *     Returns 0 if successful, with the SID stored in sid.  A value
- *     of zero for sid indicates no SID could be determined (but no error
- *     occurred).
- */
-int selinux_string_to_sid(char *str, u32 *sid);
-
-/**
- *     selinux_secmark_relabel_packet_permission - secmark permission check
- *     @sid: SECMARK ID value to be applied to network packet
- *
- *     Returns 0 if the current task is allowed to set the SECMARK label of
- *     packets with the supplied security ID.  Note that it is implicit that
- *     the packet is always being relabeled from the default unlabeled value,
- *     and that the access control decision is made in the AVC.
- */
-int selinux_secmark_relabel_packet_permission(u32 sid);
-
-/**
- *     selinux_secmark_refcount_inc - increments the secmark use counter
- *
- *     SELinux keeps track of the current SECMARK targets in use so it knows
- *     when to apply SECMARK label access checks to network packets.  This
- *     function incements this reference count to indicate that a new SECMARK
- *     target has been configured.
- */
-void selinux_secmark_refcount_inc(void);
-
-/**
- *     selinux_secmark_refcount_dec - decrements the secmark use counter
- *
- *     SELinux keeps track of the current SECMARK targets in use so it knows
- *     when to apply SECMARK label access checks to network packets.  This
- *     function decements this reference count to indicate that one of the
- *     existing SECMARK targets has been removed/flushed.
- */
-void selinux_secmark_refcount_dec(void);
-
-/**
  * selinux_is_enabled - is SELinux enabled?
  */
 bool selinux_is_enabled(void);
 #else
 
-static inline int selinux_string_to_sid(const char *str, u32 *sid)
-{
-       *sid = 0;
-       return 0;
-}
-
-static inline int selinux_secmark_relabel_packet_permission(u32 sid)
-{
-	return 0;
-}
-
-static inline void selinux_secmark_refcount_inc(void)
-{
-	return;
-}
-
-static inline void selinux_secmark_refcount_dec(void)
-{
-	return;
-}
-
 static inline bool selinux_is_enabled(void)
 {
 	return false;
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 0cb6053..782e519 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 #include <linux/gfp.h>
 #include <linux/skbuff.h>
-#include <linux/selinux.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/x_tables.h>
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 364ad16..9faf5e0 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -14,8 +14,8 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
+#include <linux/security.h>
 #include <linux/skbuff.h>
-#include <linux/selinux.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_SECMARK.h>
 
@@ -39,9 +39,8 @@ secmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 
 	switch (mode) {
 	case SECMARK_MODE_SEL:
-		secmark = info->u.sel.selsid;
+		secmark = info->secid;
 		break;
-
 	default:
 		BUG();
 	}
@@ -50,33 +49,33 @@ secmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	return XT_CONTINUE;
 }
 
-static int checkentry_selinux(struct xt_secmark_target_info *info)
+static int checkentry_lsm(struct xt_secmark_target_info *info)
 {
 	int err;
-	struct xt_secmark_target_selinux_info *sel = &info->u.sel;
 
-	sel->selctx[SECMARK_SELCTX_MAX - 1] = '\0';
+	info->secctx[SECMARK_SECCTX_MAX - 1] = '\0';
+	info->secid = 0;
 
-	err = selinux_string_to_sid(sel->selctx, &sel->selsid);
+	err = security_secctx_to_secid(info->secctx, strlen(info->secctx),
+				       &info->secid);
 	if (err) {
 		if (err == -EINVAL)
-			pr_info("invalid SELinux context \'%s\'\n",
-				sel->selctx);
+			pr_info("invalid security context \'%s\'\n", info->secctx);
 		return err;
 	}
 
-	if (!sel->selsid) {
-		pr_info("unable to map SELinux context \'%s\'\n", sel->selctx);
+	if (!info->secid) {
+		pr_info("unable to map security context \'%s\'\n", info->secctx);
 		return -ENOENT;
 	}
 
-	err = selinux_secmark_relabel_packet_permission(sel->selsid);
+	err = security_secmark_relabel_packet(info->secid);
 	if (err) {
 		pr_info("unable to obtain relabeling permission\n");
 		return err;
 	}
 
-	selinux_secmark_refcount_inc();
+	security_secmark_refcount_inc();
 	return 0;
 }
 
@@ -100,16 +99,16 @@ static int secmark_tg_check(const struct xt_tgchk_param *par)
 
 	switch (info->mode) {
 	case SECMARK_MODE_SEL:
-		err = checkentry_selinux(info);
-		if (err)
-			return err;
 		break;
-
 	default:
 		pr_info("invalid mode: %hu\n", info->mode);
 		return -EINVAL;
 	}
 
+	err = checkentry_lsm(info);
+	if (err)
+		return err;
+
 	if (!mode)
 		mode = info->mode;
 	return 0;
@@ -119,7 +118,7 @@ static void secmark_tg_destroy(const struct xt_tgdtor_param *par)
 {
 	switch (mode) {
 	case SECMARK_MODE_SEL:
-		selinux_secmark_refcount_dec();
+		security_secmark_refcount_dec();
 	}
 }
 
diff --git a/security/capability.c b/security/capability.c
index 1e26299..806061b 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -681,7 +681,18 @@ static void cap_inet_conn_established(struct sock *sk, struct sk_buff *skb)
 {
 }
 
+static int cap_secmark_relabel_packet(u32 secid)
+{
+	return 0;
+}
 
+static void cap_secmark_refcount_inc(void)
+{
+}
+
+static void cap_secmark_refcount_dec(void)
+{
+}
 
 static void cap_req_classify_flow(const struct request_sock *req,
 				  struct flowi *fl)
@@ -781,7 +792,8 @@ static int cap_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 
 static int cap_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
 {
-	return -EOPNOTSUPP;
+	*secid = 0;
+	return 0;
 }
 
 static void cap_release_secctx(char *secdata, u32 seclen)
@@ -1023,6 +1035,9 @@ void __init security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, inet_conn_request);
 	set_to_cap_if_null(ops, inet_csk_clone);
 	set_to_cap_if_null(ops, inet_conn_established);
+	set_to_cap_if_null(ops, secmark_relabel_packet);
+	set_to_cap_if_null(ops, secmark_refcount_inc);
+	set_to_cap_if_null(ops, secmark_refcount_dec);
 	set_to_cap_if_null(ops, req_classify_flow);
 	set_to_cap_if_null(ops, tun_dev_create);
 	set_to_cap_if_null(ops, tun_dev_post_create);
diff --git a/security/security.c b/security/security.c
index fe2da98..a8aa414 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1143,6 +1143,24 @@ void security_inet_conn_established(struct sock *sk,
 	security_ops->inet_conn_established(sk, skb);
 }
 
+int security_secmark_relabel_packet(u32 secid)
+{
+	return security_ops->secmark_relabel_packet(secid);
+}
+EXPORT_SYMBOL(security_secmark_relabel_packet);
+
+void security_secmark_refcount_inc(void)
+{
+	security_ops->secmark_refcount_inc();
+}
+EXPORT_SYMBOL(security_secmark_refcount_inc);
+
+void security_secmark_refcount_dec(void)
+{
+	security_ops->secmark_refcount_dec();
+}
+EXPORT_SYMBOL(security_secmark_refcount_dec);
+
 int security_tun_dev_create(void)
 {
 	return security_ops->tun_dev_create();
diff --git a/security/selinux/exports.c b/security/selinux/exports.c
index c0a454a..9066438 100644
--- a/security/selinux/exports.c
+++ b/security/selinux/exports.c
@@ -11,58 +11,9 @@
  * it under the terms of the GNU General Public License version 2,
  * as published by the Free Software Foundation.
  */
-#include <linux/types.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/selinux.h>
-#include <linux/fs.h>
-#include <linux/ipc.h>
-#include <asm/atomic.h>
 
 #include "security.h"
-#include "objsec.h"
-
-/* SECMARK reference count */
-extern atomic_t selinux_secmark_refcount;
-
-int selinux_string_to_sid(char *str, u32 *sid)
-{
-	if (selinux_enabled)
-		return security_context_to_sid(str, strlen(str), sid);
-	else {
-		*sid = 0;
-		return 0;
-	}
-}
-EXPORT_SYMBOL_GPL(selinux_string_to_sid);
-
-int selinux_secmark_relabel_packet_permission(u32 sid)
-{
-	if (selinux_enabled) {
-		const struct task_security_struct *__tsec;
-		u32 tsid;
-
-		__tsec = current_security();
-		tsid = __tsec->sid;
-
-		return avc_has_perm(tsid, sid, SECCLASS_PACKET,
-				    PACKET__RELABELTO, NULL);
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(selinux_secmark_relabel_packet_permission);
-
-void selinux_secmark_refcount_inc(void)
-{
-	atomic_inc(&selinux_secmark_refcount);
-}
-EXPORT_SYMBOL_GPL(selinux_secmark_refcount_inc);
-
-void selinux_secmark_refcount_dec(void)
-{
-	atomic_dec(&selinux_secmark_refcount);
-}
-EXPORT_SYMBOL_GPL(selinux_secmark_refcount_dec);
 
 bool selinux_is_enabled(void)
 {
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f31b0a3..a6c063b 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4290,6 +4290,27 @@ static void selinux_inet_conn_established(struct sock *sk, struct sk_buff *skb)
 	selinux_skb_peerlbl_sid(skb, family, &sksec->peer_sid);
 }
 
+static int selinux_secmark_relabel_packet(u32 sid)
+{
+	const struct task_security_struct *__tsec;
+	u32 tsid;
+
+	__tsec = current_security();
+	tsid = __tsec->sid;
+
+	return avc_has_perm(tsid, sid, SECCLASS_PACKET, PACKET__RELABELTO, NULL);
+}
+
+static void selinux_secmark_refcount_inc(void)
+{
+	atomic_inc(&selinux_secmark_refcount);
+}
+
+static void selinux_secmark_refcount_dec(void)
+{
+	atomic_dec(&selinux_secmark_refcount);
+}
+
 static void selinux_req_classify_flow(const struct request_sock *req,
 				      struct flowi *fl)
 {
@@ -5545,6 +5566,9 @@ static struct security_operations selinux_ops = {
 	.inet_conn_request =		selinux_inet_conn_request,
 	.inet_csk_clone =		selinux_inet_csk_clone,
 	.inet_conn_established =	selinux_inet_conn_established,
+	.secmark_relabel_packet =	selinux_secmark_relabel_packet,
+	.secmark_refcount_inc =		selinux_secmark_refcount_inc,
+	.secmark_refcount_dec =		selinux_secmark_refcount_dec,
 	.req_classify_flow =		selinux_req_classify_flow,
 	.tun_dev_create =		selinux_tun_dev_create,
 	.tun_dev_post_create = 		selinux_tun_dev_post_create,
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 79df4a2..671273e 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -9,6 +9,7 @@
 #define _SELINUX_SECURITY_H_
 
 #include <linux/magic.h>
+#include <linux/types.h>
 #include "flask.h"
 
 #define SECSID_NULL			0x00000000 /* unspecified SID */

