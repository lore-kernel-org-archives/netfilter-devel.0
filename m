From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] build: bump library versioning
Date: Wed, 16 Sep 2015 19:12:47 +0200
Message-ID: <1442423567-12120-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:58383 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbbIPRMt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Sep 2015 13:12:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit libnftnl-1.0.3-31-g5ea54b2 removed a symbol. Such requires a
bumped to n+1:0:0. The symbol groups can be merged again to save time
processing them as the groups are relative to a particular SONAME
(of which we have a new one).

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
This essentially supersedes "[PATCH libnftnl 0/2] map fixes".
The use of LIBNFTNL_4 as a symbol name is modeled upon the LIBVERSION
number. Doing this instead of _x.y is a (more) sensible choice,
because the next modification to the symbol map (LIBNFTNL_5) needs to
be accompanied by LIBVERSION=5:0:something in any case.


 src/libnftnl.map | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/src/libnftnl.map b/src/libnftnl.map
index 14ec88c..991fe9d 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -1,4 +1,4 @@
-LIBNFTNL_1.0 {
+LIBNFTNL_4 {
 global:
   nft_table_alloc;
   nft_table_free;
@@ -397,10 +397,6 @@ global:
   nftnl_parse_perror;
 
 
-local: *;
-};
-
-LIBNFTNL_1.1 {
   nft_table_attr_set_data;
   nft_table_attr_get_data;
   nft_chain_attr_set_data;
@@ -423,9 +419,6 @@ LIBNFTNL_1.1 {
   nftnl_set_set_data;
   nftnl_set_get_data;
 
-} LIBNFTNL_1.0;
-
-LIBNFTNL_1.2 {
   nft_set_elems_nlmsg_build_payload_iter;
   nft_batch_is_supported;
   nft_batch_begin;
@@ -469,9 +462,6 @@ LIBNFTNL_1.2 {
   nftnl_gen_fprintf;
 
 
-} LIBNFTNL_1.1;
-
-LIBNFTNL_1.2.0 {
   nft_ruleset_ctx_is_set;
   nft_ruleset_ctx_get;
   nft_ruleset_ctx_get_u32;
@@ -506,4 +496,4 @@ LIBNFTNL_1.2.0 {
   nftnl_batch_iovec_len;
   nftnl_batch_iovec;
 
-} LIBNFTNL_1.2;
+};
-- 
2.4.3

