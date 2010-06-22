From: tim.gardner@canonical.com
Subject: [PATCH 1/3] netfilter: Expose connection tracking accounting toggles
Date: Tue, 22 Jun 2010 10:44:33 -0600
Message-ID: <1277225075-30428-2-git-send-email-tim.gardner@canonical.com>
References: <1277225075-30428-1-git-send-email-tim.gardner@canonical.com>
Cc: netfilter-devel@vger.kernel.org, ole@ans.pl,
	Tim Gardner <tim.gardner@canonical.com>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2228 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab0FVQpn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:45:43 -0400
In-Reply-To: <1277225075-30428-1-git-send-email-tim.gardner@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Tim Gardner <tim.gardner@canonical.com>

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 include/net/netfilter/nf_conntrack.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index e624dae..2326754 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -232,6 +232,18 @@ static inline void nf_ct_refresh(struct nf_conn *ct,
 	__nf_ct_refresh_acct(ct, 0, skb, extra_jiffies, 0);
 }
 
+/* Check if connection tracking accounting is enabled */
+static inline bool nf_ct_acct_enabled(struct nf_conn *ct)
+{
+		return ct->ct_net->ct.sysctl_acct == 0 ? false : true;
+}
+
+/* Enable/disable connection tracking accounting */
+static inline void nf_ct_set_acct(struct nf_conn *ct, bool enable)
+{
+		ct->ct_net->ct.sysctl_acct = enable == true ? 1 : 0;
+}
+
 extern bool __nf_ct_kill_acct(struct nf_conn *ct,
 			      enum ip_conntrack_info ctinfo,
 			      const struct sk_buff *skb,
-- 
1.7.0.4

