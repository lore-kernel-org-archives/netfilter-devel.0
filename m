From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-nftables PATCH v2] nft: load only the tables of the current family.
Date: Fri, 26 Jul 2013 15:49:02 +0200
Message-ID: <1374846542-29592-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:65486 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab3GZNtT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:49:19 -0400
Received: by mail-wg0-f41.google.com with SMTP id n11so810614wgh.2
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2013 06:49:18 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This changes nft_xtables_config_load() permit to load only
the tables of the current family

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index f124419..4855904 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2841,6 +2841,7 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 	struct nft_chain_list_iter *citer;
 	struct nft_table *table;
 	struct nft_chain *chain;
+	uint32_t table_family, chain_family;
 
 	if (xtables_config_parse(filename, table_list, chain_list) < 0) {
 		if (errno == ENOENT) {
@@ -2858,6 +2859,12 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 	/* Stage 1) create tables */
 	titer = nft_table_list_iter_create(table_list);
 	while ((table = nft_table_list_iter_next(titer)) != NULL) {
+		table_family = nft_table_attr_get_u32(table,
+						      NFT_TABLE_ATTR_FAMILY);
+
+		if (h->family != table_family)
+			continue;
+
 		if (nft_table_add(h, table) < 0) {
 			if (errno == EEXIST) {
 				xtables_config_perror(flags,
@@ -2883,6 +2890,12 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 	/* Stage 2) create chains */
 	citer = nft_chain_list_iter_create(chain_list);
 	while ((chain = nft_chain_list_iter_next(citer)) != NULL) {
+		chain_family = nft_chain_attr_get_u32(chain,
+						      NFT_CHAIN_ATTR_TABLE);
+
+		if (h->family != chain_family)
+			continue;
+
 		if (nft_chain_add(h, chain) < 0) {
 			if (errno == EEXIST) {
 				xtables_config_perror(flags,
-- 
1.7.8.6

