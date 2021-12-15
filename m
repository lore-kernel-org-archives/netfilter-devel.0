Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C12C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 19:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhLOT4V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 14:56:21 -0500
Received: from mail.netfilter.org ([217.70.188.207]:55872 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhLOT4V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 14:56:21 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 02B38625CF
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Dec 2021 20:53:51 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/3] ruleset optimization infrastructure
Date:   Wed, 15 Dec 2021 20:56:12 +0100
Message-Id: <20211215195615.139902-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset adds a new -o/--optimize option to enable ruleset
optimization.

The ruleset optimization first loads the ruleset in "dry run" mode to
validate that the original ruleset is correct. Then, on a second pass it
performs the ruleset optimization before adding the rules into the
kernel.

This infrastructure collects the statements that are used in rules. Then,
it builds a matrix of rules vs. statements. Then, it looks for common
statements in consecutive rules that are candidate to be merged. Finally,
it merges rules.

From libnftables perspective, there is a new API to enable this feature:

  bool nft_ctx_get_optimize(struct nft_ctx *ctx);
  void nft_ctx_set_optimize(struct nft_ctx *ctx, bool optimize);

This patchset adds support for three optimizations:

1) Collapse rules matching on a single selector into a set, which
   transforms:

  ip daddr 192.168.0.1 counter accept
  ip daddr 192.168.0.2 counter accept
  ip daddr 192.168.0.3 counter accept

  into:

  ip daddr { 192.168.0.1, 192.168.0.2, 192.168.0.3 } counter packets 0 bytes 0 accept

2) Collapse rules with the same selectors into a concatenation, which
   transforms:

   meta iifname eth1 ip saddr 1.1.1.1 ip daddr 2.2.2.3 accept
   meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.2.5 accept
   meta iifname eth2 ip saddr 1.1.1.3 ip daddr 2.2.2.6 accept

   into:

   meta iifname . ip saddr . ip daddr { eth1 . 1.1.1.1 . 2.2.2.6, eth1 . 1.1.1.2 . 2.2.2.5 , eth1 . 1.1.1.3 . 2.2.2.6 } accept

3) Collapse rules with same selector but different verdic into verdict map,
   which transforms:

   ct state invalid drop
   ct state established,related accept

   into:

   ct state vmap { established : accept, related : accept, invalid : drop }

Comments welcome,
Thanks.

Pablo Neira Ayuso (3):
  src: add ruleset optimization infrastructure
  optimize: merge rules with same selectors into a concatenation
  optimize: merge same selector with different verdict into verdict map

 include/nftables.h             |   4 +
 include/nftables/libnftables.h |   5 +
 src/Makefile.am                |   1 +
 src/libnftables.c              |  41 ++-
 src/libnftables.map            |   5 +
 src/main.c                     |   9 +-
 src/optimize.c                 | 524 +++++++++++++++++++++++++++++++++
 7 files changed, 586 insertions(+), 3 deletions(-)
 create mode 100644 src/optimize.c

-- 
2.30.2

