From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] datatype: add DTYPE_F_CLONE flag
Date: Sat, 25 Feb 2017 13:17:28 +0100
Message-ID: <1488025049-13184-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47812 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751282AbdBYMSB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Feb 2017 07:18:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2537C96EC2
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 13:17:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 176ACDA729
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 13:17:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA973DA729
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 13:17:49 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This flag allows us to identify datatypes that are instances from
original datatypes.

This fixes a possible double free when attaching a concatenation
datatype to set->keytype while being also referenced from concatenation
expressions.

ip6/flowtable.t: ERROR: line 5: src/nft add rule --debug=netlink ip6 test-ip6 input flow table acct_out { meta iif . ip6 saddr timeout 600s counter }: This rule should not have failed.
*** Error in `src/nft': double free or corruption (fasttop): 0x000000000117ce70 ***

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h | 2 ++
 src/datatype.c     | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 68fb2a6c2431..3ce3a888f063 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -109,10 +109,12 @@ struct expr;
  *
  * @DTYPE_F_ALLOC:		datatype is dynamically allocated
  * @DTYPE_F_PREFIX:		preferred representation for ranges is a prefix
+ * @DTYPE_F_CLONE:		this is an instance from original datatype
  */
 enum datatype_flags {
 	DTYPE_F_ALLOC		= (1 << 0),
 	DTYPE_F_PREFIX		= (1 << 1),
+	DTYPE_F_CLONE		= (1 << 2),
 };
 
 /**
diff --git a/src/datatype.c b/src/datatype.c
index bfc8817c2b83..64b8b8845b10 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -973,7 +973,7 @@ static struct datatype *dtype_clone(const struct datatype *orig_dtype)
 	*dtype = *orig_dtype;
 	dtype->name = xstrdup(orig_dtype->name);
 	dtype->desc = xstrdup(orig_dtype->desc);
-	dtype->flags = DTYPE_F_ALLOC;
+	dtype->flags = DTYPE_F_ALLOC | DTYPE_F_CLONE;
 
 	return dtype;
 }
@@ -1046,7 +1046,8 @@ const struct datatype *set_keytype_alloc(const struct datatype *orig_dtype,
 
 void set_keytype_destroy(const struct datatype *dtype)
 {
-	dtype_free(dtype);
+	if (dtype->flags & DTYPE_F_CLONE)
+		dtype_free(dtype);
 }
 
 static struct error_record *time_unit_parse(const struct location *loc,
-- 
2.1.4

