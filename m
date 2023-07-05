Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 912BCEB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jul 2023 16:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbjGEQ42 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 12:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjGEQ42 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 12:56:28 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5569810EC;
        Wed,  5 Jul 2023 09:56:27 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     sashal@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,4.14 0/3] stable fixes for 4.14
Date:   Wed,  5 Jul 2023 18:56:20 +0200
Message-Id: <20230705165623.50304-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg, Sasha,

The following list shows the backported patches, I am using original
commit IDs for reference:

1) 1240eb93f061 ("netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE")

2) 26b5a5712eb8 ("netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain")

3) 3e70489721b6 ("netfilter: nf_tables: unbind non-anonymous set if rule construction fails")

Please, apply,
Thanks.

Pablo Neira Ayuso (3):
  netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE
  netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain
  netfilter: nf_tables: unbind non-anonymous set if rule construction fails

 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 29 +++++++++++++++++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

-- 
2.30.2

