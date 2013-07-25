From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC v2 PATCH  16/17] nft: Add a function to reset the counters of an existing rule
Date: Thu, 25 Jul 2013 20:16:36 +0300
Message-ID: <1374772597-20548-17-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13363 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629Ab3GYRRG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:17:06 -0400
In-Reply-To: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
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
index d05f6ae..2b17e37 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2298,6 +2298,41 @@ err:
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
index c904e21..31e1083 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -59,6 +59,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table, in
 int nft_rule_list_save(struct nft_handle *h, const char *chain, const char *table, int rulenum, int counters);
 int nft_rule_save(struct nft_handle *h, const char *table, bool counters);
 int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table);
+int nft_rule_zero_counters(struct nft_handle *h, const char *chain, const char *table, int rulenum);
 
 enum nft_rule_print {
 	NFT_RULE_APPEND,
-- 
1.8.3.2

