From: pablo@netfilter.org
Subject: [PATCH] netfilter: nf_conntrack: fix explicit helper attachment and NAT
Date: Thu,  3 May 2012 14:17:45 +0200
Message-ID: <1336047465-1562-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40868 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab2ECMSO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 May 2012 08:18:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Explicit helper attachment via the CT target is broken with NAT.
Basically, nf_conntrack_alter_reply asks for looking the helper
up again. Unfortunately, we don't have the conntrack template
at that point anymore.

Since we don't want to rely on the automatic helper assignment,
we can skip the second look-up and rely on the helper that was
attached by iptables. Since now the user is in full control of
helper attachment, we can assume he/she is making consistent
configurations.

Interestingly, this bug was hidden by the automatic helper look-up
code. But it can be easily trigger if you attach the helper in
a non-standard port, eg.

iptables -I PREROUTING -t raw -p tcp --dport 8888 \
	-j CT --helper ftp

Without this patch, if NAT is in use, this will not work.

I added the IPS_HELPER_BIT that allows us to differenciate between
a helper that has been explicitly attached and those that have been
automatically assigned. I didn't come up with a better solution.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_common.h |    4 ++++
 net/netfilter/nf_conntrack_helper.c           |   13 ++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 0d3dd66..d146872 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -83,6 +83,10 @@ enum ip_conntrack_status {
 	/* Conntrack is a fake untracked entry */
 	IPS_UNTRACKED_BIT = 12,
 	IPS_UNTRACKED = (1 << IPS_UNTRACKED_BIT),
+
+	/* Conntrack got a helper explicitly attached via CT target. */
+	IPS_HELPER_BIT = 13,
+	IPS_HELPER = (1 << IPS_HELPER_BIT),
 };
 
 /* Connection tracking event types */
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index f76481e..b851333 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -188,10 +188,21 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 	struct net *net = nf_ct_net(ct);
 	int ret = 0;
 
+	/* We already got a helper explicitly attached. The function
+	 * nf_conntrack_alter_reply - in case NAT is in use - asks for looking
+	 * the helper up again. Since now the user is in full control of
+	 * making consistent helper configurations, skip this automatic
+	 * re-lookup, otherwise we'll lose the helper.
+	 */
+	if (test_bit(IPS_HELPER_BIT, &ct->status))
+		return 0;
+
 	if (tmpl != NULL) {
 		help = nfct_help(tmpl);
-		if (help != NULL)
+		if (help != NULL) {
 			helper = help->helper;
+			set_bit(IPS_HELPER_BIT, &ct->status);
+		}
 	}
 
 	help = nfct_help(ct);
-- 
1.7.9.5

