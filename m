Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA65C7EE23
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 14:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjE1OBe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 10:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjE1OBd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 10:01:33 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FBABD
        for <netfilter-devel@vger.kernel.org>; Sun, 28 May 2023 07:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XiX+qmPQBmO3Z8lK+vmlkyPvsCMtMUha4qHR1QmjZhM=; b=h+NyjW8sNl/l8k6ArQT/1vGDe1
        C4MGzGM8+Q1UrZaEA6sbGqjPCX0uRya42uU4aGqX1/eF1yytLg9bBCwFQXmikmIHD3smKz41O35AV
        7pPYpiVARQsYoZIEAE8RMr6HKwS5DP5BKFsNpr4kct2D3cfllLcVTVWt32skyjrfUG0EcgGUZW62h
        jkNH2DZMENp+1ZbPtlSMAP1ESglC+E9mRl5wsIZOwqYHoLismnfhd3ibWtJFTfS1T5zIdVtglDb6x
        YMvxRDXimFSVzbKz96QBnW1FrWBf3hRR41y/NOWXpCl4i1vPaHrWJq5qn2UsC2fWPuj3ROpYIZC3k
        DjR0SZmw==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q3Gxe-008Xe1-3x; Sun, 28 May 2023 15:01:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH nft v5 0/8] Bitwise boolean operations with variable RHS operands
Date:   Sun, 28 May 2023 15:00:50 +0100
Message-Id: <20230528140058.1218669-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch-set adds support for new bitwise boolean operations to
nftables, and uses this to extend the types of value which can be
assigned to packet marks and payload fields.  The original motivation
for these changes was Kevin Darbyshire-Bryant's wish to be able to set
the conntrack mark to a bitwise expression derived from a DSCP value:

  https://lore.kernel.org/netfilter-devel/20191203160652.44396-1-ldir@darbyshire-bryant.me.uk/#r

For example:

  nft add rule t c ct mark set ip dscp lshift 26 or 0x10

Examples like this could be implemented solely by changes to user space.
However, other examples came up in later discussion, such as:

  nft add rule t c ct mark set ct mark and 0xffff0000 or meta mark and 0xffff

and most recently:

  nft add rule t c ct mark set ct mark or ip dscp or 0x200

which require boolean bitwise operations with two variable operands.

Hitherto, the kernel has required that AND, OR and XOR operations be
converted in user space to mask-and-xor operations on one register and
two immediate values.  The related kernel space patch-set, however, adds
support for performing these operations directly on one register and an
immediate value, or on two registers.  This patch-set extends nftables
to make use of this functionality.

The previous version of this series also included a few small changes to
make it easier to add debug output and changes to support the assign-
ments which did not require binops on two registers.  The former have
been dropped and the latter were reworked and applied by Pablo.  The
following remain.

* Patch 1 adds support for linearizing and delinearizing the new
  operations.
* Patches 2-7 add support for using them in payload and mark
  assignments.
* Patch 8 adds tests for the new assignments.

Jeremy Sowden (8):
  netlink: support (de)linearization of new bitwise boolean operations
  netlink_delinearize: refactor stmt_payload_binop_postprocess
  netlink_delinearize: add support for processing variable payload
    statement arguments
  evaluate: prevent nested byte-order conversions
  evaluate: preserve existing binop properties
  evaluate: allow binop expressions with variable right-hand operands
  parser_json: allow RHS mark and payload expressions
  tests: add tests for binops with variable RHS operands

 include/linux/netfilter/nf_tables.h           |  19 +-
 src/evaluate.c                                |  67 ++--
 src/netlink_delinearize.c                     | 335 ++++++++++++------
 src/netlink_linearize.c                       |  62 +++-
 src/parser_json.c                             |   8 +-
 tests/py/any/ct.t                             |   1 +
 tests/py/any/ct.t.json                        |  37 ++
 tests/py/any/ct.t.payload                     |   9 +
 tests/py/inet/meta.t                          |   2 +
 tests/py/inet/meta.t.json                     |  37 ++
 tests/py/inet/meta.t.payload                  |   9 +
 tests/py/ip/ct.t                              |   1 +
 tests/py/ip/ct.t.json                         |  36 ++
 tests/py/ip/ct.t.payload                      |  11 +
 tests/py/ip/ip.t                              |   2 +
 tests/py/ip/ip.t.json                         |  77 +++-
 tests/py/ip/ip.t.payload                      |  28 ++
 tests/py/ip/ip.t.payload.bridge               |  32 ++
 tests/py/ip/ip.t.payload.inet                 |  32 ++
 tests/py/ip/ip.t.payload.netdev               |  32 ++
 tests/py/ip6/ct.t                             |   1 +
 tests/py/ip6/ct.t.json                        |  36 ++
 tests/py/ip6/ct.t.payload                     |  12 +
 tests/py/ip6/ip6.t                            |   2 +
 tests/py/ip6/ip6.t.json                       |  76 ++++
 tests/py/ip6/ip6.t.payload.inet               |  36 ++
 tests/py/ip6/ip6.t.payload.ip6                |  32 ++
 .../shell/testcases/bitwise/0040mark_binop_10 |  11 +
 .../shell/testcases/bitwise/0040mark_binop_11 |  11 +
 .../shell/testcases/bitwise/0040mark_binop_12 |  11 +
 .../shell/testcases/bitwise/0040mark_binop_13 |  11 +
 .../testcases/bitwise/0044payload_binop_0     |  11 +
 .../testcases/bitwise/0044payload_binop_1     |  11 +
 .../testcases/bitwise/0044payload_binop_2     |  11 +
 .../testcases/bitwise/0044payload_binop_3     |  11 +
 .../testcases/bitwise/0044payload_binop_4     |  11 +
 .../testcases/bitwise/0044payload_binop_5     |  11 +
 .../bitwise/dumps/0040mark_binop_10.nft       |   6 +
 .../bitwise/dumps/0040mark_binop_11.nft       |   6 +
 .../bitwise/dumps/0040mark_binop_12.nft       |   6 +
 .../bitwise/dumps/0040mark_binop_13.nft       |   6 +
 .../bitwise/dumps/0044payload_binop_0.nft     |   6 +
 .../bitwise/dumps/0044payload_binop_1.nft     |   6 +
 .../bitwise/dumps/0044payload_binop_2.nft     |   6 +
 .../bitwise/dumps/0044payload_binop_3.nft     |   6 +
 .../bitwise/dumps/0044payload_binop_4.nft     |   6 +
 .../bitwise/dumps/0044payload_binop_5.nft     |   6 +
 47 files changed, 1062 insertions(+), 140 deletions(-)
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_10
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_11
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_12
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_13
 create mode 100755 tests/shell/testcases/bitwise/0044payload_binop_0
 create mode 100755 tests/shell/testcases/bitwise/0044payload_binop_1
 create mode 100755 tests/shell/testcases/bitwise/0044payload_binop_2
 create mode 100755 tests/shell/testcases/bitwise/0044payload_binop_3
 create mode 100755 tests/shell/testcases/bitwise/0044payload_binop_4
 create mode 100755 tests/shell/testcases/bitwise/0044payload_binop_5
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_10.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_11.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_12.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_13.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0044payload_binop_0.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0044payload_binop_1.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0044payload_binop_2.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0044payload_binop_3.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0044payload_binop_4.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0044payload_binop_5.nft

-- 
2.39.2

