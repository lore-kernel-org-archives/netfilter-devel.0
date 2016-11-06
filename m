From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nf_tables: fix oops when inserting an element into a verdict map
Date: Sun,  6 Nov 2016 14:40:01 +0800
Message-ID: <1478414401-21488-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, dalegaard@gmail.com,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:57540 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751375AbcKFGlF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 6 Nov 2016 01:41:05 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Dalegaard says:
 The following ruleset, when loaded with 'nft -f bad.txt'
 ----snip----
 flush ruleset
 table ip inlinenat {
   map sourcemap {
     type ipv4_addr : verdict;
   }

   chain postrouting {
     ip saddr vmap @sourcemap accept
   }
 }
 add chain inlinenat test
 add element inlinenat sourcemap { 100.123.10.2 : jump test }
 ----snip----

 results in a kernel oops:
 BUG: unable to handle kernel paging request at 0000000000001344
 IP: [<ffffffffa07bf704>] nf_tables_check_loops+0x114/0x1f0 [nf_tables]
 [...]
 Call Trace:
  [<ffffffffa07c2aae>] ? nft_data_init+0x13e/0x1a0 [nf_tables]
  [<ffffffffa07c1950>] nft_validate_register_store+0x60/0xb0 [nf_tables]
  [<ffffffffa07c74b5>] nft_add_set_elem+0x545/0x5e0 [nf_tables]
  [<ffffffffa07bfdd0>] ? nft_table_lookup+0x30/0x60 [nf_tables]
  [<ffffffff8132c630>] ? nla_strcmp+0x40/0x50
  [<ffffffffa07c766e>] nf_tables_newsetelem+0x11e/0x210 [nf_tables]
  [<ffffffff8132c400>] ? nla_validate+0x60/0x80
  [<ffffffffa030d9b4>] nfnetlink_rcv+0x354/0x5a7 [nfnetlink]

Because we forget to fill the net pointer in bind_ctx, so dereferencing
it may cause kernel crash.

Reported-by: Dalegaard <dalegaard@gmail.com>
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7d6a626..026581b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3568,6 +3568,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		dreg = nft_type_to_reg(set->dtype);
 		list_for_each_entry(binding, &set->bindings, list) {
 			struct nft_ctx bind_ctx = {
+				.net	= ctx->net,
 				.afi	= ctx->afi,
 				.table	= ctx->table,
 				.chain	= (struct nft_chain *)binding->chain,
-- 
2.5.5


