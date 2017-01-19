From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nf_tables: report error if stateful obj's name is truncated
Date: Thu, 19 Jan 2017 22:00:20 +0800
Message-ID: <1484834420-55121-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:40579 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752783AbdASOst (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Jan 2017 09:48:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Currently, if the user add a stateful object with the name size exceed
NFT_OBJ_MAXNAMELEN - 1 (i.e. 31), we truncate it down to 31 silently.
This is not friendly, furthermore, this will cause duplicated stateful
objects when the first 31 characters of the name is same. So limit the
stateful object's name size to NFT_OBJ_MAXNAMELEN - 1.

After apply this patch, error message will be printed out like this:
  # name_32=$(printf "%0.sQ" {1..32})
  # nft add counter filter $name_32
  <cmdline>:1:1-52: Error: Could not process rule: Numerical result out
  of range
  add counter filter QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Fixes: e50092404c1b ("netfilter: nf_tables: add stateful objects")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 091d2dc..9112ca9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4033,7 +4033,8 @@ EXPORT_SYMBOL_GPL(nf_tables_obj_lookup);
 
 static const struct nla_policy nft_obj_policy[NFTA_OBJ_MAX + 1] = {
 	[NFTA_OBJ_TABLE]	= { .type = NLA_STRING },
-	[NFTA_OBJ_NAME]		= { .type = NLA_STRING },
+	[NFTA_OBJ_NAME]		= { .type = NLA_STRING,
+				    .len = NFT_OBJ_MAXNAMELEN - 1 },
 	[NFTA_OBJ_TYPE]		= { .type = NLA_U32 },
 	[NFTA_OBJ_DATA]		= { .type = NLA_NESTED },
 };
-- 
2.5.5


