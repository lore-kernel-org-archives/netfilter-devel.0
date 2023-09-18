Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1BD7CD13DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 12:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241749AbjIRMHd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 08:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241963AbjIRMHS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 08:07:18 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59576F7;
        Mon, 18 Sep 2023 05:07:01 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: [PATCH -stable,4.19 0/2] netfilter stable fixes for 4.19
Date:   Mon, 18 Sep 2023 14:06:54 +0200
Message-Id: <20230918120656.218135-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg, Sasha,

This batch contains a fixes for 4.19:

1) Missing fix in 4.19, you can cherry-pick it from
   8ca79606cdfd ("netfilter: nft_flow_offload: fix underflow in flowtable reference counter")

2) Oneliner that includes missing chunk in 4.19 backport.
   Fixes: 1df28fde1270 ("netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain") in 4.19
   This patch you have to manually apply it.

Thanks.

Pablo Neira Ayuso (1):
  netfilter: nf_tables: missing NFT_TRANS_PREPARE_ERROR in flowtable deactivatation

wenxu (1):
  netfilter: nft_flow_offload: fix underflow in flowtable reference counter

 net/netfilter/nf_tables_api.c    | 1 +
 net/netfilter/nft_flow_offload.c | 3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

-- 
2.30.2

