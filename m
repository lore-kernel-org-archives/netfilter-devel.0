Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A503C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jan 2022 22:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiAZWdV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 17:33:21 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58148 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiAZWdV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 17:33:21 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E03C660252
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jan 2022 23:30:15 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables 0/4] optimization updates
Date:   Wed, 26 Jan 2022 23:33:10 +0100
Message-Id: <20220126223314.297735-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft -o/--optimize crashes with verdict maps due to insufficient checks
on the expression type for verdict statements.

This patchset extends -o/--optimize to merge two rules with the same
verdict maps side by side.

This also prepares for allowing to merge raw expressions in
concatenation which is not possible yet due to the use of integer type.

Pablo Neira Ayuso (4):
  optimize: add __expr_cmp()
  optimize: merge verdict maps with same lookup key
  optimize: check for payload base and offset when searching for mergers
  optimize: do not merge raw payload expressions

 src/optimize.c                                | 210 +++++++++++++-----
 .../optimizations/dumps/merge_vmaps.nft       |  12 +
 .../shell/testcases/optimizations/merge_vmaps |  25 +++
 3 files changed, 189 insertions(+), 58 deletions(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_vmaps.nft
 create mode 100755 tests/shell/testcases/optimizations/merge_vmaps

-- 
2.30.2

