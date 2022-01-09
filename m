Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6527AC433F5
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 16:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235987AbiAIQLc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Jan 2022 11:11:32 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41376 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbiAIQLb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Jan 2022 11:11:31 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E45E162BD8
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Jan 2022 17:08:41 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 00/14] nf_tables datapath ruleset blob and register tracking
Date:   Sun,  9 Jan 2022 17:11:12 +0100
Message-Id: <20220109161126.83917-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains v3 updates for the datapath ruleset
representation and new infrastructure to skip redundant selector store
to register operations [1].

Changes only to patch 7 and 12.

- Patch 7:  Add more memory checks to the routine that builds the blob,
            as requested by Florian.

- Patch 12: Update nft_bitwise reduce routine to deal with different
            source and destination registers.

[1] https://marc.info/?l=netfilter-devel&m=164168070413344&w=2

Pablo Neira Ayuso (14):
  netfilter: nft_connlimit: move stateful fields out of expression data
  netfilter: nft_last: move stateful fields out of expression data
  netfilter: nft_quota: move stateful fields out of expression data
  netfilter: nft_numgen: move stateful fields out of expression data
  netfilter: nft_limit: rename stateful structure
  netfilter: nft_limit: move stateful fields out of expression data
  netfilter: nf_tables: add rule blob layout
  netfilter: nf_tables: add NFT_REG32_NUM
  netfilter: nf_tables: add register tracking infrastructure
  netfilter: nft_payload: track register operations
  netfilter: nft_meta: track register operations
  netfilter: nft_bitwise: track register operations
  netfilter: nft_payload: cancel register tracking after payload update
  netfilter: nft_meta: cancel register tracking after meta update

 include/net/netfilter/nf_tables.h      |  40 +++++-
 net/bridge/netfilter/nft_meta_bridge.c |  20 +++
 net/netfilter/nf_tables_api.c          | 160 ++++++++++++++++-------
 net/netfilter/nf_tables_core.c         |  41 ++++--
 net/netfilter/nf_tables_trace.c        |   2 +-
 net/netfilter/nft_bitwise.c            |  95 ++++++++++++++
 net/netfilter/nft_connlimit.c          |  26 ++--
 net/netfilter/nft_last.c               |  69 +++++++---
 net/netfilter/nft_limit.c              | 172 +++++++++++++++++--------
 net/netfilter/nft_meta.c               |  48 +++++++
 net/netfilter/nft_numgen.c             |  34 ++++-
 net/netfilter/nft_payload.c            |  51 ++++++++
 net/netfilter/nft_quota.c              |  52 +++++++-
 13 files changed, 654 insertions(+), 156 deletions(-)

--
2.30.2

