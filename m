Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8C2C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Feb 2022 14:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiBOOMk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Feb 2022 09:12:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiBOOMk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Feb 2022 09:12:40 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC7FDBF51
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Feb 2022 06:12:28 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id B9FE9601BB
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Feb 2022 15:11:53 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] segtree: memleak get element command
Date:   Tue, 15 Feb 2022 15:12:20 +0100
Message-Id: <20220215141220.775027-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Release removed interval expressions before get_set_interval_find()
fails. The memleak can be triggered through:

 testcases/sets/0034get_element_0

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/segtree.c b/src/segtree.c
index f721954f76eb..a61ea3d2854a 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -788,6 +788,8 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 			mpz_sub_ui(i->key->value, i->key->value, 1);
 			range = get_set_interval_find(cache_set, left, i);
 			if (!range) {
+				expr_free(left);
+				expr_free(i);
 				expr_free(new_init);
 				errno = ENOENT;
 				return -1;
-- 
2.30.2

