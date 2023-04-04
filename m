Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F63C77B60
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Apr 2023 14:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbjDDOeu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Apr 2023 10:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235062AbjDDOeq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Apr 2023 10:34:46 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4149810EA
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Apr 2023 07:34:44 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/4] revisit NAT redirect support
Date:   Tue,  4 Apr 2023 16:34:33 +0200
Message-Id: <20230404143437.133493-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This is a batch to revisit NAT redirect support:

Patch #1 add a few assert() to src/optimize.c related to NAT support.

Patch #2 relax check for explicit transport protocol match if NAT
	 expression implicitly refers to transport protocol match.

Patch #3 remove workaround required before patch #2

Patch #4 add -o/--optimize support for NAT redirect (and masquerade).

Pablo Neira Ayuso (4):
  optimize: assert nat type on nat statement helper
  evaluate: bogus missing transport protocol
  netlink_delinearize: do not reset protocol context for nat protocol expression
  optimize: support for redirect and masquerade

 src/evaluate.c                                |  11 +-
 src/netlink_delinearize.c                     |   4 +-
 src/optimize.c                                | 140 +++++++++++++-----
 .../optimizations/dumps/merge_nat.nft         |   4 +
 tests/shell/testcases/optimizations/merge_nat |   7 +
 5 files changed, 127 insertions(+), 39 deletions(-)

-- 
2.30.2

