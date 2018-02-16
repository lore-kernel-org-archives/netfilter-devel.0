From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nf-next] net: netfilter: nf_tables_api: Use id allocation.
Date: Sat, 17 Feb 2018 00:19:18 +0530
Message-ID: <20180216184918.9781-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:41522 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752638AbeBPSty (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Feb 2018 13:49:54 -0500
Received: by mail-pg0-f66.google.com with SMTP id t4so3088712pgp.8
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Feb 2018 10:49:54 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In nf_tables_set_alloc_name function, remove get_zeroed_page
find_first_zero_bit and set_bit functions. Instead use ida_simple_get
function as it simplifies the code.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 net/netfilter/nf_tables_api.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0791813a1e7d..08fbb5ffab3a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2653,18 +2653,14 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 {
 	const struct nft_set *i;
 	const char *p;
-	unsigned long *inuse;
-	unsigned int n = 0, min = 0;
+	int n = 0;
+	DEFINE_IDA(inuse);
 
 	p = strchr(name, '%');
 	if (p != NULL) {
 		if (p[1] != 'd' || strchr(p + 2, '%'))
 			return -EINVAL;
 
-		inuse = (unsigned long *)get_zeroed_page(GFP_KERNEL);
-		if (inuse == NULL)
-			return -ENOMEM;
-cont:
 		list_for_each_entry(i, &ctx->table->sets, list) {
 			int tmp;
 
@@ -2672,22 +2668,21 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 				continue;
 			if (!sscanf(i->name, name, &tmp))
 				continue;
-			if (tmp < min || tmp >= min + BITS_PER_BYTE * PAGE_SIZE)
+			if (tmp < 0 || tmp >= BITS_PER_BYTE * PAGE_SIZE)
 				continue;
 
-			set_bit(tmp - min, inuse);
+			n = ida_simple_get(&inuse, tmp, BITS_PER_BYTE * PAGE_SIZE, GFP_KERNEL);
+			if (n < 0)
+				return n;
 		}
+		n = ida_simple_get(&inuse, 0, BITS_PER_BYTE * PAGE_SIZE, GFP_KERNEL);
+		if (n < 0)
+			return n;
 
-		n = find_first_zero_bit(inuse, BITS_PER_BYTE * PAGE_SIZE);
-		if (n >= BITS_PER_BYTE * PAGE_SIZE) {
-			min += BITS_PER_BYTE * PAGE_SIZE;
-			memset(inuse, 0, PAGE_SIZE);
-			goto cont;
-		}
-		free_page((unsigned long)inuse);
+		ida_destroy(&inuse);
 	}
 
-	set->name = kasprintf(GFP_KERNEL, name, min + n);
+	set->name = kasprintf(GFP_KERNEL, name, n);
 	if (!set->name)
 		return -ENOMEM;
 
-- 
2.14.3

