From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH] nftables: fix length of set name
Date: Fri, 21 Mar 2014 18:39:01 +0100
Message-ID: <1395423541-5098-2-git-send-email-giuseppelng@gmail.com>
References: <1395423541-5098-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47084 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760979AbaCURjZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:39:25 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so2072194eei.19
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2014 10:39:23 -0700 (PDT)
In-Reply-To: <1395423541-5098-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch permits to copy the last char of the set name
that's currently excluded.

nft add table ip test
nft add chain ip test filter {type filter hook input priority 0 \; }
nft add set ip test thisnamewith0016 { type ipv4_address\;}
nft list table ip test
table ip test {
        set thisnamewith0016 {
                type ipv4_address
        }

        chain filter {
                 type filter hook input priority 0;
        }
}

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index adce01e..a0da542 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2018,7 +2018,7 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 		free_page((unsigned long)inuse);
 	}
 
-	snprintf(set->name, sizeof(set->name), name, n);
+	snprintf(set->name, sizeof(set->name)+1, name, n);
 	list_for_each_entry(i, &ctx->table->sets, list) {
 		if (!strcmp(set->name, i->name))
 			return -ENFILE;
@@ -2399,7 +2399,7 @@ static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
 	if (set == NULL)
 		goto err1;
 
-	nla_strlcpy(name, nla[NFTA_SET_NAME], sizeof(set->name));
+	nla_strlcpy(name, nla[NFTA_SET_NAME], sizeof(set->name)+1);
 	err = nf_tables_set_alloc_name(&ctx, set, name);
 	if (err < 0)
 		goto err2;
-- 
1.8.3.2

