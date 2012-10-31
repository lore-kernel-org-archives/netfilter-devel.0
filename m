From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 5/5] iptables: nft: Add support for -R option
Date: Wed, 31 Oct 2012 11:31:08 +0200
Message-ID: <1351675868-14302-6-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1351675868-14302-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33152 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190Ab2JaJbV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:31:21 -0400
In-Reply-To: <1351675868-14302-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c     | 28 ++++++++++++++++++----------
 iptables/nft.h     |  2 +-
 iptables/xtables.c |  3 ++-
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 5dfacd8..de2a456 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -639,7 +639,8 @@ static void add_counters(struct nft_rule *r, uint64_t packets, uint64_t bytes)
 
 int
 nft_rule_add(struct nft_handle *h, const char *chain, const char *table,
-	     struct iptables_command_state *cs, bool append, bool verbose)
+	     struct iptables_command_state *cs,
+	     bool append, uint16_t handle, bool verbose)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
@@ -764,8 +765,16 @@ nft_rule_add(struct nft_handle *h, const char *chain, const char *table,
 	}
 
 	/* NLM_F_CREATE autoloads the built-in table if it does not exists */
-	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET,
-					NLM_F_ACK|NLM_F_CREATE|flags, h->seq);
+	flags |= NLM_F_ACK|NLM_F_CREATE;
+
+	if (handle > 0) {
+		nft_rule_attr_set(r, NFT_RULE_ATTR_HANDLE, &handle);
+		flags |= NLM_F_REPLACE;
+	}
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE,
+				       AF_INET, flags, h->seq);
+
 	nft_rule_nlmsg_build_payload(nlh, r);
 
 	nft_rule_print_debug(r, nlh);
@@ -2321,17 +2330,16 @@ int nft_rule_replace(struct nft_handle *h, const char *chain,
 		     const char *table, struct iptables_command_state *cs,
 		     int rulenum, bool verbose)
 {
-	int ret;
+	int handle;
 
 	nft_fn = nft_rule_replace;
 
-	ret = __nft_rule_check(h, chain, table,
-			       NULL, false, true, rulenum, verbose);
-	if (ret < 0)
-		return ret;
+	handle = __nft_rule_check(h, chain, table,
+				  NULL, false, true, rulenum, verbose);
+	if (handle < 0)
+		return handle;
 
-	/* XXX needs to be inserted in position, this is appending */
-	return nft_rule_add(h, chain, table, cs, true, verbose);
+	return nft_rule_add(h, chain, table, cs, true, handle, verbose);
 }
 
 /*
diff --git a/iptables/nft.h b/iptables/nft.h
index f5a9efb..474e652 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -39,7 +39,7 @@ int nft_chain_user_rename(struct nft_handle *h, const char *chain, const char *t
  */
 struct nft_rule;
 
-int nft_rule_add(struct nft_handle *h, const char *chain, const char *table, struct iptables_command_state *cmd, bool append, bool verbose);
+int nft_rule_add(struct nft_handle *h, const char *chain, const char *table, struct iptables_command_state *cmd, bool append, uint16_t handle, bool verbose);
 int nft_rule_check(struct nft_handle *h, const char *chain, const char *table, struct iptables_command_state *cmd, bool verbose);
 int nft_rule_delete(struct nft_handle *h, const char *chain, const char *table, struct iptables_command_state *cmd, bool verbose);
 int nft_rule_delete_num(struct nft_handle *h, const char *chain, const char *table, int rulenum, bool verbose);
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 0203b69..0f8826c 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -448,7 +448,8 @@ add_entry(const char *chain,
 			cs->fw.ip.dst.s_addr = daddrs[j].s_addr;
 			cs->fw.ip.dmsk.s_addr = dmasks[j].s_addr;
 
-			ret = nft_rule_add(h, chain, table, cs, append, verbose);
+			ret = nft_rule_add(h, chain, table,
+					   cs, append, 0, verbose);
 		}
 	}
 
-- 
1.7.12.4

