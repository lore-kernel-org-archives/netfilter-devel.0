Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F93C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Jan 2022 22:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbiAHW0p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Jan 2022 17:26:45 -0500
Received: from mail.netfilter.org ([217.70.188.207]:40112 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiAHW0p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Jan 2022 17:26:45 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9B53164287
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Jan 2022 23:23:55 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 00/14] nf_tables datapath ruleset blob and register tracking
Date:   Sat,  8 Jan 2022 23:26:24 +0100
Message-Id: <20220108222638.36037-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains v2 updates for the datapath ruleset
representation and new infrastructure to skip redundant selector store
to register operations. Patch from 1 to 7 are not updated in this v2 series.

- Patch 1 to 6, allocate stateful information via kmalloc() to prepare
  for the ruleset blob layout.

- Patch 7, adds datapath blob ruleset per chain representation, generated
  from the commit phase. This blob contains read-only ruleset data:

      size (unsigned long)
        struct nft_rule_dp
          struct nft_expr
          ...
        struct nft_rule_dp
          struct nft_expr
          ...
        struct nft_rule_dp (is_last=1)

  The new structure nft_rule_dp represents the rule in a more compact way
  (smaller memory footprint) compared to the control-plane nft_rule
  structure.

  The ruleset blob is a read-only data structure. The first field contains
  the blob size, then the rules containing expressions. There is a trailing
  rule which is used by the tracing infrastructure which is equivalent to
  the NULL rule marker in the previous representation. The blob size field
  does not include the size of this trailing rule marker.

- Patch 8, add NFT_REG32_NUM and use it (new in this series).

- Patch 9 to 12, adds register tracking infrastructure to skip redundant
  selector store operations on registers which allows to recycle existing
  data. This results in a x2 boost in performance in pure linear rulesets,
  but it also helps a bit in rulesets already heavily relying in maps.
  This infra supports for dynamic ruleset updates since the ruleset blob
  is generated from the kernel on updates.

  [ I have reworked payload+bitwise and meta+bitwise reductions to make
    them less confusing. I have also fixed a few bugs triggering an
    incorrect reduction ]

- Patch 13 and 14 cancel the register tracking for payload/meta set
  operations (new in this series).

Userspace update is needed to maximize register utilization, to allow
the nf_tables kernel side to recycle register data.

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
 net/netfilter/nf_tables_api.c          | 132 ++++++++++++-------
 net/netfilter/nf_tables_core.c         |  41 ++++--
 net/netfilter/nf_tables_trace.c        |   2 +-
 net/netfilter/nft_bitwise.c            |  93 +++++++++++++
 net/netfilter/nft_connlimit.c          |  26 ++--
 net/netfilter/nft_last.c               |  69 +++++++---
 net/netfilter/nft_limit.c              | 172 +++++++++++++++++--------
 net/netfilter/nft_meta.c               |  48 +++++++
 net/netfilter/nft_numgen.c             |  34 ++++-
 net/netfilter/nft_payload.c            |  51 ++++++++
 net/netfilter/nft_quota.c              |  52 +++++++-
 13 files changed, 626 insertions(+), 154 deletions(-)

-- 
2.30.2

