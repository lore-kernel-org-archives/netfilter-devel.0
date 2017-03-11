From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft] src: fix crash when inputting an incomplete set add command
Date: Sat, 11 Mar 2017 12:20:11 +0800
Message-ID: <1489206011-43843-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:46675 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755175AbdCKEVf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2017 23:21:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

After inputting the following nft command, set->keytype is not initialized
but we try to destroy it, so NULL pointer dereference will happen:
  # nft add set t s
  Segmentation fault (core dumped)
  #0  dtype_free (dtype=0x0) at datatype.c:1049
  #1  set_datatype_destroy (dtype=0x0) at datatype.c:1051
  #2  0x0000000000407f1a in set_free (set=0x838790) at rule.c:213
  #3  0x000000000042ff70 in nft_parse (scanner=scanner@entry=0x8386a0,
    state=state@entry=0x7ffc313ea670) at parser_bison.c:9355
  #4  0x000000000040727d in nft_run (scanner=scanner@entry=0x8386a0,
    state=state@entry=0x7ffc313ea670, msgs=msgs@entry=0x7ffc313ea660)
    at main.c:237
  #5  0x0000000000406e4a in main (argc=<optimized out>, argv=<optimized
    out>) at main.c:376

Fixes: b9b6092304ae ("evaluate: store byteorder for set keys")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 src/datatype.c | 2 +-
 src/rule.c     | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index c61c424..06a045b 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1047,7 +1047,7 @@ const struct datatype *set_datatype_alloc(const struct datatype *orig_dtype,
 
 void set_datatype_destroy(const struct datatype *dtype)
 {
-	if (dtype->flags & DTYPE_F_CLONE)
+	if (dtype && dtype->flags & DTYPE_F_CLONE)
 		dtype_free(dtype);
 }
 
diff --git a/src/rule.c b/src/rule.c
index f5ff110..056d5ce 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -211,8 +211,7 @@ void set_free(struct set *set)
 		expr_free(set->init);
 	handle_free(&set->handle);
 	set_datatype_destroy(set->keytype);
-	if (set->datatype)
-		set_datatype_destroy(set->datatype);
+	set_datatype_destroy(set->datatype);
 	xfree(set);
 }
 
-- 
2.5.5


