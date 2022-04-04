Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D56BC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbiDDMIZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236944AbiDDMIZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:08:25 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F81F3DA77
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/ylHBm+M8aI7+7urIquQk58AOObQG+u5eo3FpMLO9Ig=; b=gRmc12JwoWGL4yIRkgC/RJ1ffm
        evHdyX6x5MjpTy95GqBYaa9HsH9ax2zA3cdtdP883ZXuByLje22G4MvdbDdh0IGF0ee0GYH5dReiK
        0/k+s3F+xlQAdRP5PCPAkwkPpn6u5tJIiJl5kfXhRXDyBItl8LB+uA8JDI6HKX+PrOhk+waFEhJAg
        0Q/RTznf7ZRYPUXzJJzGoxJlBiTSjs8FddyzwFDNfMQ7pvLrXTtau8KgKIwMKizikesBagSYG7u3N
        tWMXq8RpAeelDz8eQE98z04Ud7bDN5lcxmaAt4oSnox0h3ibe557XuGUj/oetWbo7J8pM82EXP8g8
        NszuWHYg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLTX-007FNA-Fp
        for netfilter-devel@vger.kernel.org; Mon, 04 Apr 2022 13:06:27 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnftnl PATCH v2 0/9] bitwise: support for boolean operations with variable RHS operands
Date:   Mon,  4 Apr 2022 13:06:14 +0100
Message-Id: <20220404120623.188439-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hitherto, the kernel has required that AND, OR and XOR operations be
converted in user space to mask-and-xor operations on one register and
two immediate values.  Now, however, it has support for performing these
operations directly on one register and an immediate value, or on two
registers.  Support has also been added for keeping track of the
bit-length of boolean expressions since this can be useful to user space
during delinearization.  This patch-set makes this new functionality
available to user space.

* Patch 1 updates kernel UAPI header to 5.17-rc7.
* Patches 2 & 3 add support for keeping track of the bit-length of
  boolean expressions.
* Patches 4-7 implement the new operations.
* Patches 8 & 9 refactor the existing bitwise tests and add new ones.

Changes since v1

  * Patches 1-3 are new.
  * In v1, boolean operations were still converted to mask-and-xor form,
    but the mask and xor values were allowed to be passed in registers.

Jeremy Sowden (9):
  include: update nf_tables.h
  include: add new bitwise bit-length attribute to nf_tables.h
  expr: bitwise: pass bit-length to and from the kernel
  include: add new bitwise boolean attributes to nf_tables.h
  expr: bitwise: fix a couple of white-space mistakes
  expr: bitwise: rename some boolean operation functions
  expr: bitwise: add support for kernel space AND, OR and XOR operations
  tests: bitwise: refactor shift tests
  tests: bitwise: add tests for new boolean operations

 include/libnftnl/expr.h             |   2 +
 include/linux/netfilter/nf_tables.h |  27 +++-
 src/expr/bitwise.c                  |  86 ++++++++++-
 tests/nft-expr_bitwise-test.c       | 230 +++++++++++++++++-----------
 4 files changed, 244 insertions(+), 101 deletions(-)

-- 
2.35.1

