From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 2/2] src: move new nftnl symbols to new group
Date: Wed, 16 Sep 2015 15:06:52 +0200
Message-ID: <1442408812-28799-3-git-send-email-pablo@netfilter.org>
References: <1442408812-28799-1-git-send-email-pablo@netfilter.org>
Cc: jengelh@inai.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39185 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbbIPNA0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Sep 2015 09:00:26 -0400
In-Reply-To: <1442408812-28799-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add new LIBNFTNL_1.0.5 symbols that use the nftnl_ prefix.

Old symbols prefixed by nft_ will be gone at some point.

Fixes: b7154e52fc41 ("src: introduce nftnl_* aliases for all existing functions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftnl.map |  137 ++++++++++++++++++++++++------------------------------
 1 file changed, 60 insertions(+), 77 deletions(-)

diff --git a/src/libnftnl.map b/src/libnftnl.map
index 0d04c4e..1189005 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -192,10 +192,65 @@ global:
   nft_parse_err_free;
   nft_parse_perror;
 
-#
-# aliases
-#
+local: *;
+};
+
+LIBNFTNL_1.1 {
+  nft_table_attr_set_data;
+  nft_table_attr_get_data;
+  nft_chain_attr_set_data;
+  nft_chain_attr_get_data;
+  nft_rule_attr_set_data;
+  nft_rule_attr_get_data;
+  nft_set_attr_set_data;
+  nft_set_attr_get_data;
+} LIBNFTNL_1.0;
+
+LIBNFTNL_1.2 {
+  nft_set_elems_nlmsg_build_payload_iter;
+  nft_batch_is_supported;
+  nft_batch_begin;
+  nft_batch_end;
+
+  nft_gen_alloc;
+  nft_gen_free;
+  nft_gen_attr_is_set;
+  nft_gen_attr_unset;
+  nft_gen_attr_set_data;
+  nft_gen_attr_set;
+  nft_gen_attr_set_u32;
+  nft_gen_attr_get_data;
+  nft_gen_attr_get;
+  nft_gen_attr_get_u32;
+  nft_gen_nlmsg_parse;
+  nft_gen_snprintf;
+  nft_gen_fprintf;
+} LIBNFTNL_1.1;
+
+LIBNFTNL_1.2.0 {
+  nft_ruleset_ctx_is_set;
+  nft_ruleset_ctx_get;
+  nft_ruleset_ctx_get_u32;
+  nft_ruleset_parse_file_cb;
+  nft_ruleset_parse_buffer_cb;
+  nft_ruleset_ctx_free;
 
+  nft_batch_alloc;
+  nft_batch_update;
+  nft_batch_free;
+  nft_batch_buffer;
+  nft_batch_buffer_len;
+  nft_batch_iovec_len;
+  nft_batch_iovec;
+
+  nft_set_attr_set_u64;
+  nft_set_attr_get_u64;
+  nft_set_elem_attr_set_u64;
+  nft_set_elem_attr_get_u64;
+} LIBNFTNL_1.2;
+
+LIBNFTNL_1.0.5 {
+global:
   nftnl_table_alloc;
   nftnl_table_free;
   nftnl_table_is_set;
@@ -392,24 +447,6 @@ global:
   nftnl_parse_err_free;
   nftnl_parse_perror;
 
-
-local: *;
-};
-
-LIBNFTNL_1.1 {
-  nft_table_attr_set_data;
-  nft_table_attr_get_data;
-  nft_chain_attr_set_data;
-  nft_chain_attr_get_data;
-  nft_rule_attr_set_data;
-  nft_rule_attr_get_data;
-  nft_set_attr_set_data;
-  nft_set_attr_get_data;
-
-#
-# aliases
-#
-
   nftnl_table_set_data;
   nftnl_table_get_data;
   nftnl_chain_set_data;
@@ -419,32 +456,6 @@ LIBNFTNL_1.1 {
   nftnl_set_set_data;
   nftnl_set_get_data;
 
-} LIBNFTNL_1.0;
-
-LIBNFTNL_1.2 {
-  nft_set_elems_nlmsg_build_payload_iter;
-  nft_batch_is_supported;
-  nft_batch_begin;
-  nft_batch_end;
-
-  nft_gen_alloc;
-  nft_gen_free;
-  nft_gen_attr_is_set;
-  nft_gen_attr_unset;
-  nft_gen_attr_set_data;
-  nft_gen_attr_set;
-  nft_gen_attr_set_u32;
-  nft_gen_attr_get_data;
-  nft_gen_attr_get;
-  nft_gen_attr_get_u32;
-  nft_gen_nlmsg_parse;
-  nft_gen_snprintf;
-  nft_gen_fprintf;
-
-#
-# aliases
-#
-
   nftnl_set_elems_nlmsg_build_payload_iter;
   nftnl_batch_is_supported;
   nftnl_batch_begin;
@@ -464,34 +475,6 @@ LIBNFTNL_1.2 {
   nftnl_gen_snprintf;
   nftnl_gen_fprintf;
 
-
-} LIBNFTNL_1.1;
-
-LIBNFTNL_1.2.0 {
-  nft_ruleset_ctx_is_set;
-  nft_ruleset_ctx_get;
-  nft_ruleset_ctx_get_u32;
-  nft_ruleset_parse_file_cb;
-  nft_ruleset_parse_buffer_cb;
-  nft_ruleset_ctx_free;
-
-  nft_batch_alloc;
-  nft_batch_update;
-  nft_batch_free;
-  nft_batch_buffer;
-  nft_batch_buffer_len;
-  nft_batch_iovec_len;
-  nft_batch_iovec;
-
-  nft_set_attr_set_u64;
-  nft_set_attr_get_u64;
-  nft_set_elem_attr_set_u64;
-  nft_set_elem_attr_get_u64;
-
-#
-# aliases
-#
-
   nftnl_ruleset_ctx_is_set;
   nftnl_ruleset_ctx_get;
   nftnl_ruleset_ctx_get_u32;
@@ -506,5 +489,5 @@ LIBNFTNL_1.2.0 {
   nftnl_batch_buffer_len;
   nftnl_batch_iovec_len;
   nftnl_batch_iovec;
-
-} LIBNFTNL_1.2;
+local: *;
+};
-- 
1.7.10.4

