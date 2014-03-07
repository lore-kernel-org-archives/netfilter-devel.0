From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] netfilter: nf_tables: handle more than 8 * PAGE_SIZE set name allocations
Date: Fri,  7 Mar 2014 12:34:05 +0100
Message-ID: <1394192045-9039-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36958 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaCGLeM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:34:12 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We currently have a limit of 8 * PAGE_SIZE anonymous sets. Lift that limit
by continuing the scan if the entire page is exhausted.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f25d011..89d7ec4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2004,7 +2004,7 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 	const struct nft_set *i;
 	const char *p;
 	unsigned long *inuse;
-	unsigned int n = 0;
+	unsigned int n = 0, min = 0;
 
 	p = strnchr(name, IFNAMSIZ, '%');
 	if (p != NULL) {
@@ -2014,23 +2014,28 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 		inuse = (unsigned long *)get_zeroed_page(GFP_KERNEL);
 		if (inuse == NULL)
 			return -ENOMEM;
-
+cont:
 		list_for_each_entry(i, &ctx->table->sets, list) {
 			int tmp;
 
 			if (!sscanf(i->name, name, &tmp))
 				continue;
-			if (tmp < 0 || tmp >= BITS_PER_BYTE * PAGE_SIZE)
+			if (tmp < min || tmp >= min + BITS_PER_BYTE * PAGE_SIZE)
 				continue;
 
-			set_bit(tmp, inuse);
+			set_bit(tmp - min, inuse);
 		}
 
 		n = find_first_zero_bit(inuse, BITS_PER_BYTE * PAGE_SIZE);
+		if (n >= BITS_PER_BYTE * PAGE_SIZE) {
+			min += BITS_PER_BYTE * PAGE_SIZE;
+			memset(inuse, 0, PAGE_SIZE);
+			goto cont;
+		}
 		free_page((unsigned long)inuse);
 	}
 
-	snprintf(set->name, sizeof(set->name), name, n);
+	snprintf(set->name, sizeof(set->name), name, min + n);
 	list_for_each_entry(i, &ctx->table->sets, list) {
 		if (!strcmp(set->name, i->name))
 			return -ENFILE;
-- 
1.8.5.3

