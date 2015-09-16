From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 1/2] src: move new set and set_elem symbols to new group
Date: Wed, 16 Sep 2015 15:06:51 +0200
Message-ID: <1442408812-28799-2-git-send-email-pablo@netfilter.org>
References: <1442408812-28799-1-git-send-email-pablo@netfilter.org>
Cc: jengelh@inai.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39164 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbbIPNAX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Sep 2015 09:00:23 -0400
In-Reply-To: <1442408812-28799-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The LIBNFTNL_1.2.0 group was created during the 1.0.4 development cycle, so
move these new set and set_elem symbols there.

Fixes: b1e6bc9cbffd ("set: add support for set timeouts")
Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftnl.map |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/src/libnftnl.map b/src/libnftnl.map
index 14ec88c..0d04c4e 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -123,12 +123,10 @@ global:
   nft_set_attr_is_set;
   nft_set_attr_set;
   nft_set_attr_set_u32;
-  nft_set_attr_set_u64;
   nft_set_attr_set_str;
   nft_set_attr_get;
   nft_set_attr_get_str;
   nft_set_attr_get_u32;
-  nft_set_attr_get_u64;
   nft_set_nlmsg_build_payload;
   nft_set_nlmsg_parse;
   nft_set_parse;
@@ -157,12 +155,10 @@ global:
   nft_set_elem_attr_unset;
   nft_set_elem_attr_set;
   nft_set_elem_attr_set_u32;
-  nft_set_elem_attr_set_u64;
   nft_set_elem_attr_set_str;
   nft_set_elem_attr_get;
   nft_set_elem_attr_get_str;
   nft_set_elem_attr_get_u32;
-  nft_set_elem_attr_get_u64;
   nft_set_elem_nlmsg_build_payload;
   nft_set_elem_parse;
   nft_set_elem_parse_file;
@@ -487,6 +483,11 @@ LIBNFTNL_1.2.0 {
   nft_batch_iovec_len;
   nft_batch_iovec;
 
+  nft_set_attr_set_u64;
+  nft_set_attr_get_u64;
+  nft_set_elem_attr_set_u64;
+  nft_set_elem_attr_get_u64;
+
 #
 # aliases
 #
-- 
1.7.10.4

