From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 07/10] src: rename datatype name from tc_handle to classid
Date: Wed, 17 Aug 2016 15:29:58 +0200
Message-ID: <1471440601-5327-8-git-send-email-pablo@netfilter.org>
References: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44044 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbcHQNaP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 09:30:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 838B9E9779
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 708387E077
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3D2BCFF134
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:11 +0200 (CEST)
In-Reply-To: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h | 4 ++--
 src/meta.c         | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 3eb686e..12ec46b 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -27,7 +27,7 @@
  * @TYPE_IFINDEX:	interface index (integer subtype)
  * @TYPE_ARPHRD:	interface type (integer subtype)
  * @TYPE_REALM:		routing realm (integer subtype)
- * @TYPE_TC_HANDLE:	TC handle (integer subtype)
+ * @TYPE_CLASSID:	TC classid (integer subtype)
  * @TYPE_UID:		user ID (integer subtype)
  * @TYPE_GID:		group ID (integer subtype)
  * @TYPE_CT_STATE:	conntrack state (bitmask subtype)
@@ -66,7 +66,7 @@ enum datatypes {
 	TYPE_IFINDEX,
 	TYPE_ARPHRD,
 	TYPE_REALM,
-	TYPE_TC_HANDLE,
+	TYPE_CLASSID,
 	TYPE_UID,
 	TYPE_GID,
 	TYPE_CT_STATE,
diff --git a/src/meta.c b/src/meta.c
index 94263f9..c7967b0 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -127,9 +127,9 @@ err:
 }
 
 static const struct datatype tchandle_type = {
-	.type		= TYPE_TC_HANDLE,
-	.name		= "tc_handle",
-	.desc		= "TC handle",
+	.type		= TYPE_CLASSID,
+	.name		= "classid",
+	.desc		= "TC classid",
 	.byteorder	= BYTEORDER_HOST_ENDIAN,
 	.size		= 4 * BITS_PER_BYTE,
 	.basetype	= &integer_type,
-- 
2.1.4

