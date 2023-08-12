Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 663E9C001E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Aug 2023 22:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjHLWJE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjHLWJE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Aug 2023 18:09:04 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 468CF1704;
        Sat, 12 Aug 2023 15:09:07 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: [PATCH -stable,4.19 0/2] netfilter stable fixes for 4.19
Date:   Sun, 13 Aug 2023 00:09:01 +0200
Message-Id: <20230812220903.56667-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg, Sasha,

This is a backport of:

  faff4e4ecd28 ("netfilter: nf_tables: bogus EBUSY when deleting flowtable after flush")
  1689f25924ad ("netfilter: nf_tables: report use refcount overflow")

for -stable 4.19.

Please, apply.

Thanks.

Laura Garcia Liebana (1):
  netfilter: nf_tables: bogus EBUSY when deleting flowtable after flush

Pablo Neira Ayuso (1):
  netfilter: nf_tables: report use refcount overflow

 include/net/netfilter/nf_tables.h |  35 +++++-
 net/netfilter/nf_tables_api.c     | 180 ++++++++++++++++++++----------
 net/netfilter/nft_flow_offload.c  |  23 +++-
 net/netfilter/nft_objref.c        |   8 +-
 4 files changed, 177 insertions(+), 69 deletions(-)

-- 
2.30.2

