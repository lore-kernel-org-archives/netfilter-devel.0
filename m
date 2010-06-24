From: Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH 1/3] netfilter: Expose connection tracking accounting toggles
Date: Thu, 24 Jun 2010 09:27:35 -0600
Message-ID: <1277393257-15281-2-git-send-email-tim.gardner@canonical.com>
References: <1277393257-15281-1-git-send-email-tim.gardner@canonical.com>
Cc: netfilter-devel@vger.kernel.org,
	Tim Gardner <tim.gardner@canonical.com>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2880 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab0FXP2M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:28:12 -0400
In-Reply-To: <1277393257-15281-1-git-send-email-tim.gardner@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_ct_acct_enabled() - Get CT accounting state.
nf_ct_set_acct() - Enable/disable CT accountuing.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 include/net/netfilter/nf_conntrack_acct.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
index 03e218f..31f5cd3 100644
--- a/include/net/netfilter/nf_conntrack_acct.h
+++ b/include/net/netfilter/nf_conntrack_acct.h
@@ -45,6 +45,18 @@ struct nf_conn_counter *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp)
 extern unsigned int
 seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir);
 
+/* Check if connection tracking accounting is enabled */
+static inline bool nf_ct_acct_enabled(const struct xt_mtchk_param *par)
+{
+	return par->net->ct.sysctl_acct == 0 ? false : true;
+}
+
+/* Enable/disable connection tracking accounting */
+static inline void nf_ct_set_acct(const struct xt_mtchk_param *par, bool enable)
+{
+	par->net->ct.sysctl_acct = enable == true ? 1 : 0;
+}
+
 extern int nf_conntrack_acct_init(struct net *net);
 extern void nf_conntrack_acct_fini(struct net *net);
 
-- 
1.7.0.4

