Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40481C7EE29
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 13:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjE1N4W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 09:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjE1N4R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 09:56:17 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC870C7
        for <netfilter-devel@vger.kernel.org>; Sun, 28 May 2023 06:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d0cEglJ3bROqYIqS1u99IQr34evQz/H4HE7Zhywajws=; b=IBAEF9cUWx7g2Bn2FD9YMgxJxC
        Va4O2MJoj4/lOf2RbcOeacH7FBn4wuCM4AAI2x3Zk8pqRGzfC4rr6wBvUi8mN+x2R5xYAfrfgLiy9
        CoKAuoHL0mD5PqZDX2dqC3Yw8rpiNuInaf7oXfCQLIye8LpPWdfCrq6O4Z52U5roI/DkB/MLbYBOV
        j9E6sZZmE0Lcfk2NdHz7s1KILQFtw8UV3juvQ6gp0up1t32fIZ5zX6mxpuO1qSWGpNLcNlP8jUdsk
        ELrHj/8T3R8lICPKOnbZRafzSNusTTGYLtgs/Qp5yXfafLmvmjbU1WrQe7Ap3NSZqaWbjZunvk5Mn
        bhTtEMOw==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q3GsY-008We9-8W
        for netfilter-devel@vger.kernel.org; Sun, 28 May 2023 14:56:14 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl v3 0/5] bitwise: support for boolean operations with variable RHS operands
Date:   Sun, 28 May 2023 14:55:56 +0100
Message-Id: <20230528135601.1218337-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hitherto, the kernel has required that AND, OR and XOR operations be
converted in user space to mask-and-xor operations on one register and
two immediate values.  Now, however, it has support for performing these
operations directly on one register and an immediate value, or on two
registers.  This patch-set makes this new functionality available to
user space.

* Patches 1-3 implement the new operations.
* Patches 4-5 refactor the existing bitwise tests and add new ones.

Changes since v2

  * The patches adding support for keeping track of the bit-length of
    boolean expressions in the kernel are no longer needed and have been
    dropped.

Changes since v1

  * Patches were added support for keeping track of the bit-length of
    boolean expressions in the kernel.
  * In v1, boolean operations were still converted to mask-and-xor form,
    but the mask and xor values were allowed to be passed in registers.

Jeremy Sowden (5):
  include: add new bitwise boolean attributes to nf_tables.h
  expr: bitwise: rename some boolean operation functions
  expr: bitwise: add support for kernel space AND, OR and XOR operations
  tests: bitwise: refactor shift tests
  tests: bitwise: add tests for new boolean operations

 include/libnftnl/expr.h             |   1 +
 include/linux/netfilter/nf_tables.h |  19 ++-
 src/expr/bitwise.c                  |  69 ++++++++-
 tests/nft-expr_bitwise-test.c       | 220 ++++++++++++++++------------
 4 files changed, 210 insertions(+), 99 deletions(-)

-- 
2.39.2

