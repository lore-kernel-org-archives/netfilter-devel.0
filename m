Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD716C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 11:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91EAC61352
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 11:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239278AbhKHLkw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 06:40:52 -0500
Received: from mail.netfilter.org ([217.70.188.207]:47200 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239279AbhKHLkv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 06:40:51 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 47E73606AE
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Nov 2021 12:36:08 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools] conntrackd: do not include conntrack ID in hashtable cmp
Date:   Mon,  8 Nov 2021 12:37:58 +0100
Message-Id: <20211108113758.112916-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Depending on your conntrackd configuration, events might get lost,
leaving stuck entries in the cache forever. Skip checking the conntrack
ID to allow for lazy cleanup by when a new entry that represented by the
same tuple.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache-ct.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/src/cache-ct.c b/src/cache-ct.c
index fe01e165516c..f56e450e6cf2 100644
--- a/src/cache-ct.c
+++ b/src/cache-ct.c
@@ -90,21 +90,12 @@ cache_ct_hash(const void *data, const struct hashtable *table)
 	return ret;
 }
 
-/* master conntrack of expectations have no ID */
-static inline int
-cache_ct_cmp_id(const struct nf_conntrack *ct1, const struct nf_conntrack *ct2)
-{
-	return nfct_attr_is_set(ct2, ATTR_ID) ?
-	       nfct_get_attr_u32(ct1, ATTR_ID) == nfct_get_attr_u32(ct2, ATTR_ID) : 1;
-}
-
 static int cache_ct_cmp(const void *data1, const void *data2)
 {
 	const struct cache_object *obj = data1;
 	const struct nf_conntrack *ct = data2;
 
-	return nfct_cmp(obj->ptr, ct, NFCT_CMP_ORIG) &&
-	       cache_ct_cmp_id(obj->ptr, ct);
+	return nfct_cmp(obj->ptr, ct, NFCT_CMP_ORIG);
 }
 
 static void *cache_ct_alloc(void)
-- 
2.30.2

