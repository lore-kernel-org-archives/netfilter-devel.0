Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BADFCC0015E
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Jul 2023 08:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbjGMItA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Jul 2023 04:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbjGMIs2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Jul 2023 04:48:28 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C03512689;
        Thu, 13 Jul 2023 01:48:01 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: [PATCH -stable,5.15 v2 0/2] netfilter stable fixes for 5.15
Date:   Thu, 13 Jul 2023 10:47:48 +0200
Message-Id: <20230713084750.71456-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg, Sasha,

[ this is v2, using "Upstream commit tag XYZ" as suggested by Salvatore Bonaccorso,
  only this comestic change in this batch. ]

The following list shows the backported patches, I am using original
commit IDs for reference:

1) 628bd3e49cba ("netfilter: nf_tables: drop map element references from preparation phase")

2) 3e70489721b6 ("netfilter: nf_tables: unbind non-anonymous set if rule construction fails")

Please, apply.
Thanks.

Pablo Neira Ayuso (2):
  netfilter: nf_tables: drop map element references from preparation phase
  netfilter: nf_tables: unbind non-anonymous set if rule construction fails

 include/net/netfilter/nf_tables.h |   5 +-
 net/netfilter/nf_tables_api.c     | 147 ++++++++++++++++++++++++++----
 net/netfilter/nft_set_bitmap.c    |   5 +-
 net/netfilter/nft_set_hash.c      |  23 ++++-
 net/netfilter/nft_set_pipapo.c    |  14 ++-
 net/netfilter/nft_set_rbtree.c    |   5 +-
 6 files changed, 168 insertions(+), 31 deletions(-)

-- 
2.30.2

