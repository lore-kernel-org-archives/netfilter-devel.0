From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/4] conntrack: export lsm context rather than internal secid
	via netlink
Date: Wed, 13 Oct 2010 16:24:54 -0400
Message-ID: <20101013202454.15272.72074.stgit@paris.rdu.redhat.com>
References: <20101013202441.15272.75924.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, paul.moore@hp.com, jmorris@namei.org,
	sds@tycho.nsa.gov, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org, selinux@tycho.nsa.gov
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036Ab0JMU0A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Oct 2010 16:26:00 -0400
In-Reply-To: <20101013202441.15272.75924.stgit@paris.rdu.redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The conntrack code can export the internal secid to userspace.  These are
dynamic, can change on lsm changes, and have no meaning in userspace.  We
should instead be sending lsm contexts to userspace instead.  This patch sends
the secctx (rather than secid) to userspace over the netlink socket.  We use a
new field CTA_SECCTX and stop using the the old CTA_SECMARK field since it did
not send particularly useful information.

Signed-off-by: Eric Paris <eparis@redhat.com>
Reviewed-by: Paul Moore <paul.moore@hp.com>
---

 include/linux/netfilter/nfnetlink_conntrack.h |   10 +++++
 net/netfilter/nf_conntrack_netlink.c          |   46 ++++++++++++++++++++-----
 2 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index 9ed534c..70cd060 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -39,8 +39,9 @@ enum ctattr_type {
 	CTA_TUPLE_MASTER,
 	CTA_NAT_SEQ_ADJ_ORIG,
 	CTA_NAT_SEQ_ADJ_REPLY,
-	CTA_SECMARK,
+	CTA_SECMARK,		/* obsolete */
 	CTA_ZONE,
+	CTA_SECCTX,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
@@ -172,4 +173,11 @@ enum ctattr_help {
 };
 #define CTA_HELP_MAX (__CTA_HELP_MAX - 1)
 
+enum ctattr_secctx {
+	CTA_SECCTX_UNSPEC,
+	CTA_SECCTX_NAME,
+	__CTA_SECCTX_MAX
+};
+#define CTA_SECCTX_MAX (__CTA_SECCTX_MAX - 1)
+
 #endif /* _IPCONNTRACK_NETLINK_H */
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 5bae1cd..b3c6285 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -22,6 +22,7 @@
 #include <linux/rculist_nulls.h>
 #include <linux/types.h>
 #include <linux/timer.h>
+#include <linux/security.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
 #include <linux/netlink.h>
@@ -245,16 +246,31 @@ nla_put_failure:
 
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 static inline int
-ctnetlink_dump_secmark(struct sk_buff *skb, const struct nf_conn *ct)
+ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	NLA_PUT_BE32(skb, CTA_SECMARK, htonl(ct->secmark));
-	return 0;
+	struct nlattr *nest_secctx;
+	int len, ret;
+	char *secctx;
+
+	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
+	if (ret)
+		return ret;
+
+	ret = -1;
+	nest_secctx = nla_nest_start(skb, CTA_SECCTX | NLA_F_NESTED);
+	if (!nest_secctx)
+		goto nla_put_failure;
 
+	NLA_PUT_STRING(skb, CTA_SECCTX_NAME, secctx);
+	nla_nest_end(skb, nest_secctx);
+
+	ret = 0;
 nla_put_failure:
-	return -1;
+	security_release_secctx(secctx, len);
+	return ret;
 }
 #else
-#define ctnetlink_dump_secmark(a, b) (0)
+#define ctnetlink_dump_secctx(a, b) (0)
 #endif
 
 #define master_tuple(ct) &(ct->master->tuplehash[IP_CT_DIR_ORIGINAL].tuple)
@@ -391,7 +407,7 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	    ctnetlink_dump_protoinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_mark(skb, ct) < 0 ||
-	    ctnetlink_dump_secmark(skb, ct) < 0 ||
+	    ctnetlink_dump_secctx(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
 	    ctnetlink_dump_master(skb, ct) < 0 ||
@@ -437,6 +453,17 @@ ctnetlink_counters_size(const struct nf_conn *ct)
 	       ;
 }
 
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+static int ctnetlink_nlmsg_secctx_size(const struct nf_conn *ct)
+{
+	int len;
+
+	security_secid_to_secctx(ct->secmark, NULL, &len);
+
+	return sizeof(char) * len;
+}
+#endif
+
 static inline size_t
 ctnetlink_nlmsg_size(const struct nf_conn *ct)
 {
@@ -453,7 +480,8 @@ ctnetlink_nlmsg_size(const struct nf_conn *ct)
 	       + nla_total_size(0) /* CTA_HELP */
 	       + nla_total_size(NF_CT_HELPER_NAME_LEN) /* CTA_HELP_NAME */
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
-	       + nla_total_size(sizeof(u_int32_t)) /* CTA_SECMARK */
+	       + nla_total_size(0) /* CTA_SECCTX */
+	       + nla_total_size(ctnetlink_nlmsg_secctx_size(ct)) /* CTA_SECCTX_NAME */
 #endif
 #ifdef CONFIG_NF_NAT_NEEDED
 	       + 2 * nla_total_size(0) /* CTA_NAT_SEQ_ADJ_ORIG|REPL */
@@ -554,11 +582,9 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 		    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 			goto nla_put_failure;
 
-#ifdef CONFIG_NF_CONNTRACK_SECMARK
 		if ((events & (1 << IPCT_SECMARK) || ct->secmark)
-		    && ctnetlink_dump_secmark(skb, ct) < 0)
+		    && ctnetlink_dump_secctx(skb, ct) < 0)
 			goto nla_put_failure;
-#endif
 
 		if (events & (1 << IPCT_RELATED) &&
 		    ctnetlink_dump_master(skb, ct) < 0)

