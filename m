Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D9DC04A94
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Aug 2023 22:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjHLWHS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbjHLWHO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Aug 2023 18:07:14 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CAF8E1FEE;
        Sat, 12 Aug 2023 15:07:00 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: [PATCH -stable,5.15 0/1] netfilter stable fix for 5.15
Date:   Sun, 13 Aug 2023 00:06:54 +0200
Message-Id: <20230812220655.56382-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg, Sasha,

This is a backport of:

  1689f25924ad ("netfilter: nf_tables: report use refcount overflow")

for -stable 5.15.

Please, apply.

Thanks.

Pablo Neira Ayuso (1):
  netfilter: nf_tables: report use refcount overflow

 include/net/netfilter/nf_tables.h |  31 +++++-
 net/netfilter/nf_tables_api.c     | 164 ++++++++++++++++++------------
 net/netfilter/nft_flow_offload.c  |   6 +-
 net/netfilter/nft_immediate.c     |   8 +-
 net/netfilter/nft_objref.c        |   8 +-
 5 files changed, 141 insertions(+), 76 deletions(-)

--
2.30.2

