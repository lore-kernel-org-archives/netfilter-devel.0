Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23596CCA489
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Jul 2022 23:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiGTXIL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Jul 2022 19:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbiGTXIF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Jul 2022 19:08:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B932275E6;
        Wed, 20 Jul 2022 16:08:04 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH nf-next 08/18] netfilter: nft_set_bitmap: Fix spelling mistake
Date:   Thu, 21 Jul 2022 01:07:44 +0200
Message-Id: <20220720230754.209053-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220720230754.209053-1-pablo@netfilter.org>
References: <20220720230754.209053-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Zhang Jiaming <jiaming@nfschina.com>

Change 'succesful' to 'successful'.
Change 'transation' to 'transaction'.

Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_bitmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index e7ae5914971e..96081ac8d2b4 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -21,7 +21,7 @@ struct nft_bitmap_elem {
  * the element state in the current and the future generation.
  *
  * An element can be in three states. The generation cursor is represented using
- * the ^ character, note that this cursor shifts on every succesful transaction.
+ * the ^ character, note that this cursor shifts on every successful transaction.
  * If no transaction is going on, we observe all elements are in the following
  * state:
  *
@@ -39,7 +39,7 @@ struct nft_bitmap_elem {
  * 10 = this element is active in the current generation and it becomes inactive
  * ^    in the next one. This happens when the element is deactivated but commit
  *      path has not yet been executed yet, so removal is still pending. On
- *      transation abortion, the next generation bit is reset to go back to
+ *      transaction abortion, the next generation bit is reset to go back to
  *      restore its previous state.
  */
 struct nft_bitmap {
-- 
2.30.2

