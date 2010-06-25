From: Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH V4 1/2] netfilter: xt_connbytes: Force CT accounting to be enabled
Date: Fri, 25 Jun 2010 06:31:31 -0600
Message-ID: <1277469092-6247-2-git-send-email-tim.gardner@canonical.com>
References: <1277469092-6247-1-git-send-email-tim.gardner@canonical.com>
Cc: netfilter-devel@vger.kernel.org,
	Tim Gardner <tim.gardner@canonical.com>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2445 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab0FYMcE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:32:04 -0400
In-Reply-To: <1277469092-6247-1-git-send-email-tim.gardner@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Check at rule install time that CT accounting is enabled. Force it
to be enabled if not while also emitting a warning since this is not
the default state.

This is in preparation for deprecating CONFIG_NF_CT_ACCT upon which
CONFIG_NETFILTER_XT_MATCH_CONNBYTES depended being set.

Added 2 CT accounting support functions:

nf_ct_acct_enabled() - Get CT accounting state.
nf_ct_set_acct() - Enable/disable CT accountuing.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Acked-by: Jan Engelhardt <jengelh@medozas.de>

---
 include/net/netfilter/nf_conntrack_acct.h |   12 ++++++++++++
 net/netfilter/xt_connbytes.c              |   10 ++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
index 03e218f..4e9c63a 100644
--- a/include/net/netfilter/nf_conntrack_acct.h
+++ b/include/net/netfilter/nf_conntrack_acct.h
@@ -45,6 +45,18 @@ struct nf_conn_counter *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp)
 extern unsigned int
 seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir);
 
+/* Check if connection tracking accounting is enabled */
+static inline bool nf_ct_acct_enabled(struct net *net)
+{
+	return net->ct.sysctl_acct != 0;
+}
+
+/* Enable/disable connection tracking accounting */
+static inline void nf_ct_set_acct(struct net *net, bool enable)
+{
+	net->ct.sysctl_acct = enable;
+}
+
 extern int nf_conntrack_acct_init(struct net *net);
 extern void nf_conntrack_acct_fini(struct net *net);
 
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 7351783..5b13850 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -112,6 +112,16 @@ static int connbytes_mt_check(const struct xt_mtchk_param *par)
 	if (ret < 0)
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
+
+	/*
+	 * This filter cannot function correctly unless connection tracking
+	 * accounting is enabled, so complain in the hope that someone notices.
+	 */
+	if (!nf_ct_acct_enabled(par->net)) {
+		pr_warning("Forcing CT accounting to be enabled\n");
+		nf_ct_set_acct(par->net, true);
+	}
+
 	return ret;
 }
 
-- 
1.7.0.4

