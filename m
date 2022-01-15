Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A46B4C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jan 2022 18:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiAOS1x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 13:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiAOS1v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 13:27:51 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A2CC061574
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jan 2022 10:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=catLj1lM6X59I+D+i6J8Wy1zXvNobe8UNdg9kRbKU9I=; b=Q1m1Hi71PCtkAzRbk+XmarVQzd
        1/PoUE6ZQwXPcQELtZd6z8WyBojhN2suU67rxdfOnzGplQkIx+XAmB0EDIVRCZVW6Qj4yVkXRoQ4Y
        zczgU3xHVuiZJcwSPvRjYUx/oNsKtVuS40p5IYx9FLFNENaQc5uXp/GLsy/JKyob+IlvaHrKT193G
        MGwAAUnG2Izsku3zULqVVFlwHjDrvBHqmbXHxU11yMg21+LnyXS6zo+p9YyE22oav6Ev34mITaXaa
        YMBOLaJ/aZLMJHEE38wCSbyv01Jo5xv1gemel8LaMKAqp5vQ1txJzPTxRDqKZh0bn9g9EBKr1DYRP
        SaAHC+9A==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n8nmG-008OQb-NA; Sat, 15 Jan 2022 18:27:49 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH v2 0/5] Store multiple payload dependencies
Date:   Sat, 15 Jan 2022 18:27:04 +0000
Message-Id: <20220115182709.1999424-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The purpose of this patch-set is to eliminate more redundant
payload-dependencies.

Here's the netlink dump for a test where such a dependency is not
eliminated.

  [ meta load nfproto => reg 1 ]
  [ cmp eq reg 1 0x00000002 ]
  [ meta load l4proto => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 4b @ network header + 12 => reg 1 ]
  [ payload load 4b @ network header + 16 => reg 9 ]
  [ payload load 2b @ transport header + 2 => reg 10 ]
  [ lookup reg 1 set set3 ]
  [ immediate reg 0 accept ]

The reason the `meta nfproto` match is not eliminated is that it is
overwritten in the dependency context by the `meta l4proto` match before
we get to the `ip saddr` and `ip daddr` expressions which would have
caused it to be eliminated.  By contrast, the `meta l4proto` match _is_
eliminated because it is still present in the context we get to the `tcp
dport` expression.  Therefore, this patch-set extends the payload-
dependency context to store not just a single dependency, but one per
protocol layer.

Patch 1 fixes a mistake in a Python test-case.  Patch 2 makes some
preliminary changes.  Patch 3 adds the extra dependencies.  Patches 4 &
5 remove redundant protocol matches which are now eliminated from
test-cases.

At the end of this series all tests pass.

Changes since v1.

  * The first seven v1 patches have been merged.  The remaining four
    form patches 2-5 in this series.
  * Patch 1 is new: it fixes a test-case that was supposed to be fixed
    by patch 2 in v1.
  * The helper added by patch 2 has been changed to return the
    expression from the payload dependency statement, not the statement
    itself.  The removal of the redundant `ctx->pbase` check is new.

Jeremy Sowden (5):
  tests: py: fix inet/ip.t bridge payload
  src: add a helper that returns a payload dependency for a particular
    base
  src: store more than one payload dependency
  tests: py: remove redundant payload expressions
  tests: shell: remove redundant payload expressions

 include/payload.h                             | 15 ++--
 src/netlink_delinearize.c                     | 18 +++--
 src/payload.c                                 | 72 ++++++++++++++-----
 tests/py/inet/icmpX.t                         |  2 +-
 tests/py/inet/icmpX.t.json.output             |  9 ---
 tests/py/inet/ip.t.payload.bridge             |  2 +-
 tests/py/inet/sets.t.json                     | 11 ---
 .../testcases/maps/dumps/0010concat_map_0.nft |  2 +-
 .../testcases/maps/dumps/nat_addr_port.nft    |  8 +--
 9 files changed, 79 insertions(+), 60 deletions(-)

-- 
2.34.1

