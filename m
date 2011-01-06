From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: fix export secctx error handling
Date: Thu, 06 Jan 2011 02:56:33 +0100
Message-ID: <20110106015633.10207.39405.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54608 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231Ab1AFB4k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jan 2011 20:56:40 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In 1ae4de0cdf855305765592647025bde55e85e451, the secctx was exported
via the /proc/net/netfilter/nf_conntrack and ctnetlink interfaces
instead of the secmark.

That patch introduced the use of security_secid_to_secctx() which may
return a non-zero value on error.

In one of my setups, I have NF_CONNTRACK_SECMARK enabled but no
security modules. Thus, security_secid_to_secctx() returns a negative
value that results in the breakage of the /proc and `conntrack -L'
outputs. To fix this, we skip the inclusion of secctx if the
aforementioned function fails.

This patch also fixes the dynamic netlink message size calculation
if security_secid_to_secctx() returns an error, since its logic is
also wrong.

This problem exists in Linux kernel >= 2.6.37.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    2 +-
 net/netfilter/nf_conntrack_netlink.c               |   25 +++++++++++---------
 net/netfilter/nf_conntrack_standalone.c            |    2 +-
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 37f8adb..63f60fc 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -97,7 +97,7 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 
 	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
 	if (ret)
-		return ret;
+		return 0;
 
 	ret = seq_printf(s, "secctx=%s ", secctx);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b77b24d..559d40d 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -282,7 +282,7 @@ ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 
 	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
 	if (ret)
-		return ret;
+		return 0;
 
 	ret = -1;
 	nest_secctx = nla_nest_start(skb, CTA_SECCTX | NLA_F_NESTED);
@@ -482,16 +482,22 @@ ctnetlink_counters_size(const struct nf_conn *ct)
 	       ;
 }
 
-#ifdef CONFIG_NF_CONNTRACK_SECMARK
-static int ctnetlink_nlmsg_secctx_size(const struct nf_conn *ct)
+static inline int
+ctnetlink_secctx_size(const struct nf_conn *ct)
 {
-	int len;
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+	int len, ret;
 
-	security_secid_to_secctx(ct->secmark, NULL, &len);
+	ret = security_secid_to_secctx(ct->secmark, NULL, &len);
+	if (ret)
+		return 0;
 
-	return sizeof(char) * len;
-}
+	return nla_total_size(0) /* CTA_SECCTX */
+	       + nla_total_size(sizeof(char) * len); /* CTA_SECCTX_NAME */
+#else
+	return 0;
 #endif
+}
 
 static inline size_t
 ctnetlink_timestamp_size(const struct nf_conn *ct)
@@ -517,10 +523,7 @@ ctnetlink_nlmsg_size(const struct nf_conn *ct)
 	       + nla_total_size(0) /* CTA_PROTOINFO */
 	       + nla_total_size(0) /* CTA_HELP */
 	       + nla_total_size(NF_CT_HELPER_NAME_LEN) /* CTA_HELP_NAME */
-#ifdef CONFIG_NF_CONNTRACK_SECMARK
-	       + nla_total_size(0) /* CTA_SECCTX */
-	       + nla_total_size(ctnetlink_nlmsg_secctx_size(ct)) /* CTA_SECCTX_NAME */
-#endif
+	       + ctnetlink_secctx_size(ct)
 #ifdef CONFIG_NF_NAT_NEEDED
 	       + 2 * nla_total_size(0) /* CTA_NAT_SEQ_ADJ_ORIG|REPL */
 	       + 6 * nla_total_size(sizeof(u_int32_t)) /* CTA_NAT_SEQ_OFFSET */
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 0fb6570..b4d7f0f 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -118,7 +118,7 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 
 	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
 	if (ret)
-		return ret;
+		return 0;
 
 	ret = seq_printf(s, "secctx=%s ", secctx);
 

