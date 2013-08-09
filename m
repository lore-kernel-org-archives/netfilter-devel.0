From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC v3 PATCH 15/16] nft: Add a function to reset the counters of an existing rule
Date: Fri,  9 Aug 2013 16:31:29 +0300
Message-ID: <1376055090-26551-16-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967822Ab3HINcD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:32:03 -0400
In-Reply-To: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that we parse properly, in one place and at once, the rule back into a
command structure, it's now easier to reset its counters from that command
structure which we can pass again to nft_rule_append. (Thus the rule will
be replaced since we provide it's handle.)

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 35 +++++++++++++++++++++++++++++++++++
 iptables/nft.h |  1 +
 2 files changed, 36 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index 7ec3762..ad999a0 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2109,6 +2109,41 @@ err:
 	return ret;
 }
 
+int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
+			   const char *table, int rulenum)
+{
+	struct iptables_command_state cs = {};
+	struct nft_rule_list *list;
+	struct nft_rule *r;
+	int ret = 0;
+
+	nft_fn = nft_rule_delete;
+
+	list = nft_rule_list_create(h);
+	if (list == NULL)
+		return 0;
+
+	r = nft_rule_find(list, chain, table, NULL, rulenum);
+	if (r == NULL) {
+		errno = ENOENT;
+		ret = 1;
+
+		goto error;
+	}
+
+	nft_rule_to_iptables_command_state(r, &cs);
+
+	cs.counters.pcnt = cs.counters.bcnt = 0;
+
+	ret =  nft_rule_append(h, chain, table, &cs,
+			nft_rule_attr_get_u64(r, NFT_RULE_ATTR_HANDLE), false);
+
+error:
+	nft_rule_list_destroy(list);
+
+	return ret;
+}
+
 static int nft_action(struct nft_handle *h, int type)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
diff --git a/iptables/nft.h b/iptables/nft.h
index 006c031..fe1b9c8 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -81,6 +81,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table, in
 int nft_rule_list_save(struct nft_handle *h, const char *chain, const char *table, int rulenum, int counters);
 int nft_rule_save(struct nft_handle *h, const char *table, bool counters);
 int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table);
+int nft_rule_zero_counters(struct nft_handle *h, const char *chain, const char *table, int rulenum);
 
 enum nft_rule_print {
 	NFT_RULE_APPEND,
-- 
1.8.3.2

