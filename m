From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables (nft-compat) PATCH 3/5] nft: Initialize a table only once
Date: Tue, 11 Feb 2014 18:36:44 +0200
Message-ID: <1392136606-10339-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1392136606-10339-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62651 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbaBKQg6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:36:58 -0500
In-Reply-To: <1392136606-10339-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This helps to remove some runtime overhead, especially when running
xtables-restore.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 10 ++++++++++
 iptables/nft.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index 7031ede..ac1afa4 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -436,6 +436,9 @@ nft_table_builtin_add(struct nft_handle *h, struct builtin_table *_t,
 	struct nft_table *t;
 	int ret;
 
+	if (_t->initialized)
+		return 0;
+
 	t = nft_table_alloc();
 	if (t == NULL)
 		return -1;
@@ -464,6 +467,10 @@ nft_table_builtin_add(struct nft_handle *h, struct builtin_table *_t,
 		if (errno != EEXIST)
 			perror("mnl-talk:nft_table_init_one");
 	}
+
+	if (ret == 0 || errno == EEXIST)
+		_t->initialized = true;
+
 	return ret;
 }
 
@@ -2441,6 +2448,9 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 	uint32_t table_family, chain_family;
 	bool found = false;
 
+	if (h->restore)
+		return 0;
+
 	if (xtables_config_parse(filename, table_list, chain_list) < 0) {
 		if (errno == ENOENT) {
 			xtables_config_perror(flags,
diff --git a/iptables/nft.h b/iptables/nft.h
index 8b64f8b..204a23f 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -22,6 +22,7 @@ struct builtin_chain {
 struct builtin_table {
 	const char *name;
 	struct builtin_chain chains[NF_INET_NUMHOOKS];
+	bool initialized;
 };
 
 struct nft_handle {
-- 
1.8.3.2

