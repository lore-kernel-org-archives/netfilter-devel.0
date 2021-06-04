Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2911C47097
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 01:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACD3E6120F
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 01:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhFDBJV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Jun 2021 21:09:21 -0400
Received: from mail.netfilter.org ([217.70.188.207]:46018 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhFDBJU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 21:09:20 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0F79764207;
        Fri,  4 Jun 2021 03:06:26 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     syzbot+ce96ca2b1d0b37c6422d@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: nf_tables: initialize set before expression setup
Date:   Fri,  4 Jun 2021 03:07:28 +0200
Message-Id: <20210604010728.57968-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_set_elem_expr_alloc() needs an initialized set if expression sets on
the NFT_EXPR_GC flag. Move set fields initialization before expression
setup.

[4512935.019450] ==================================================================
[4512935.019456] BUG: KASAN: null-ptr-deref in nft_set_elem_expr_alloc+0x84/0xd0 [nf_tables]
[4512935.019487] Read of size 8 at addr 0000000000000070 by task nft/23532
[4512935.019494] CPU: 1 PID: 23532 Comm: nft Not tainted 5.12.0-rc4+ #48
[...]
[4512935.019502] Call Trace:
[4512935.019505]  dump_stack+0x89/0xb4
[4512935.019512]  ? nft_set_elem_expr_alloc+0x84/0xd0 [nf_tables]
[4512935.019536]  ? nft_set_elem_expr_alloc+0x84/0xd0 [nf_tables]
[4512935.019560]  kasan_report.cold.12+0x5f/0xd8
[4512935.019566]  ? nft_set_elem_expr_alloc+0x84/0xd0 [nf_tables]
[4512935.019590]  nft_set_elem_expr_alloc+0x84/0xd0 [nf_tables]
[4512935.019615]  nf_tables_newset+0xc7f/0x1460 [nf_tables]

Reported-by: syzbot+ce96ca2b1d0b37c6422d@syzkaller.appspotmail.com
Fixes: 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 85 ++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 42 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 72bc759179ef..bf4d6ec9fc55 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4364,13 +4364,45 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	err = nf_tables_set_alloc_name(&ctx, set, name);
 	kfree(name);
 	if (err < 0)
-		goto err_set_alloc_name;
+		goto err_set_name;
+
+	udata = NULL;
+	if (udlen) {
+		udata = set->data + size;
+		nla_memcpy(udata, nla[NFTA_SET_USERDATA], udlen);
+	}
+
+	INIT_LIST_HEAD(&set->bindings);
+	INIT_LIST_HEAD(&set->catchall_list);
+	set->table = table;
+	write_pnet(&set->net, net);
+	set->ops = ops;
+	set->ktype = ktype;
+	set->klen = desc.klen;
+	set->dtype = dtype;
+	set->objtype = objtype;
+	set->dlen = desc.dlen;
+	set->flags = flags;
+	set->size = desc.size;
+	set->policy = policy;
+	set->udlen = udlen;
+	set->udata = udata;
+	set->timeout = timeout;
+	set->gc_int = gc_int;
+
+	set->field_count = desc.field_count;
+	for (i = 0; i < desc.field_count; i++)
+		set->field_len[i] = desc.field_len[i];
+
+	err = ops->init(set, &desc, nla);
+	if (err < 0)
+		goto err_set_init;
 
 	if (nla[NFTA_SET_EXPR]) {
 		expr = nft_set_elem_expr_alloc(&ctx, set, nla[NFTA_SET_EXPR]);
 		if (IS_ERR(expr)) {
 			err = PTR_ERR(expr);
-			goto err_set_alloc_name;
+			goto err_set_expr_alloc;
 		}
 		set->exprs[0] = expr;
 		set->num_exprs++;
@@ -4381,75 +4413,44 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 
 		if (!(flags & NFT_SET_EXPR)) {
 			err = -EINVAL;
-			goto err_set_alloc_name;
+			goto err_set_expr_alloc;
 		}
 		i = 0;
 		nla_for_each_nested(tmp, nla[NFTA_SET_EXPRESSIONS], left) {
 			if (i == NFT_SET_EXPR_MAX) {
 				err = -E2BIG;
-				goto err_set_init;
+				goto err_set_expr_alloc;
 			}
 			if (nla_type(tmp) != NFTA_LIST_ELEM) {
 				err = -EINVAL;
-				goto err_set_init;
+				goto err_set_expr_alloc;
 			}
 			expr = nft_set_elem_expr_alloc(&ctx, set, tmp);
 			if (IS_ERR(expr)) {
 				err = PTR_ERR(expr);
-				goto err_set_init;
+				goto err_set_expr_alloc;
 			}
 			set->exprs[i++] = expr;
 			set->num_exprs++;
 		}
 	}
 
-	udata = NULL;
-	if (udlen) {
-		udata = set->data + size;
-		nla_memcpy(udata, nla[NFTA_SET_USERDATA], udlen);
-	}
-
-	INIT_LIST_HEAD(&set->bindings);
-	INIT_LIST_HEAD(&set->catchall_list);
-	set->table = table;
-	write_pnet(&set->net, net);
-	set->ops   = ops;
-	set->ktype = ktype;
-	set->klen  = desc.klen;
-	set->dtype = dtype;
-	set->objtype = objtype;
-	set->dlen  = desc.dlen;
-	set->flags = flags;
-	set->size  = desc.size;
-	set->policy = policy;
-	set->udlen  = udlen;
-	set->udata  = udata;
-	set->timeout = timeout;
-	set->gc_int = gc_int;
 	set->handle = nf_tables_alloc_handle(table);
 
-	set->field_count = desc.field_count;
-	for (i = 0; i < desc.field_count; i++)
-		set->field_len[i] = desc.field_len[i];
-
-	err = ops->init(set, &desc, nla);
-	if (err < 0)
-		goto err_set_init;
-
 	err = nft_trans_set_add(&ctx, NFT_MSG_NEWSET, set);
 	if (err < 0)
-		goto err_set_trans;
+		goto err_set_expr_alloc;
 
 	list_add_tail_rcu(&set->list, &table->sets);
 	table->use++;
 	return 0;
 
-err_set_trans:
-	ops->destroy(set);
-err_set_init:
+err_set_expr_alloc:
 	for (i = 0; i < set->num_exprs; i++)
 		nft_expr_destroy(&ctx, set->exprs[i]);
-err_set_alloc_name:
+
+	ops->destroy(set);
+err_set_init:
 	kfree(set->name);
 err_set_name:
 	kvfree(set);
-- 
2.30.2

