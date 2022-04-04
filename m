Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A157C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242930AbiDDMQb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241909AbiDDMQ0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:16:26 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6262511C2D
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oX+KGUwztOyoMN7ts7TT1Jqdy/OQg9uT0Km7jO55Fn0=; b=M9okte8BM9AEjVOcmZDkhwRCfB
        EEjeaqL1Yw7o24VaZVcLYp4PNQQJ2aZs7dTaerHfp3XVL5EwdNGbgAp4KBr1Yok4ZUZ6Iv7dMoER0
        dEsKqaaphszc2JONmpAgAPtkbKzpo2NrQj8NPffGfMV0im9ih8CpvlVpydHcHxDB0s4SgwA0oSuya
        LvgWKQ6jQR0Ar0WqYFEeCGYBxKtdLLNZNgEWdr7Itr2KclX1alNtz/acL87hYJleJAOkV/UQD/Ikf
        RFp7Wp154uXKkRFOxQ7+3Ev0yBd4wBWANLdZQqQYEaQ0wGIVT0doHdw3v2MvKolbklzvPKZLc6vXg
        SoyDoWFA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbI-007FTC-BC; Mon, 04 Apr 2022 13:14:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 00/32] Extend values assignable to packet marks and payload fields
Date:   Mon,  4 Apr 2022 13:13:38 +0100
Message-Id: <20220404121410.188509-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch-set extends the types of value which can be assigned to
packet marks and payload fields.  The original motivation for these
changes was Kevin Darbyshire-Bryant's wish to be able to set the
conntrack mark to a bitwise expression derived from a DSCP value:

  https://lore.kernel.org/netfilter-devel/20191203160652.44396-1-ldir@darbyshire-bryant.me.uk/#r

For example:

  nft add rule t c ct mark set ip dscp lshift 26 or 0x10

In principle, examples like this can be implemented solely by changes to
user space.  However, in some cases the payload munging leads to the
generation of multi-byte binops in host byte-order which are not
correctly eliminated during delinearization: the easiest way to fix this
was to pass the bit-length of these expressions to and from the kernel.

One of the changes required for this example is to relax the requirement
that when assigning a non-integer rvalue, its data-type must match that
of the lvalue.  I have been conservative in relaxing this: for an lvalue
of mark type, any rvalue with integer base-type may be assigned.  I did
try allowing the assignment of any rvalue of integer base-type to any
lvalue of integer base-type, but doing so caused test failures which
were sufficiently obscure that I decided wait and see if the patch-set
in its current form is positively received before spending time
diagnosing and fixing them.

Other examples came up in later discussion, such as:

  nft add rule t c ct mark set ct mark and 0xffff0000 or meta mark and 0xffff

and most recently:

  nft add rule t c ct mark set ct mark or ip dscp or 0x200

These require boolean bitwise operations with two variable operands.
Hitherto, the kernel has required that AND, OR and XOR operations be
converted in user space to mask-and-xor operations on one register and
two immediate values.  The related kernel space patch-set, however, adds
support for performing these operations directly on one register and an
immediate value, or on two registers.  This patch-set extends nftables
to make use of this functionality.

The patch-set is structured as follows.

  * Patch 1 adds a .gitignore file for examples/.
  * Patches 2-5 make some changes which I found helpful when adding
    debugging output.
  * Patch 6 updates the nf_tables.h kernel UAPI header to 5.17-rc7.
  * Patches 7-14 add support for assignments which do not require
    bitwise operations with variable RHS operands.
  * Patches 15-17 add tests for these.
  * Patches 18-30 add support for assignments which do require binops
    with variable RHS.
  * Patches 31-32 add tests for these.

Changes since v3

  * Patches 1-6 are new.
  * When I first posted a version of this work two years ago, the main
    focus was the changes necessary to implement binops with variable
    RHS operands.  My intention was to post the remaining changes,
    including support for assigning expressions of one type to those of
    another, separately.  The problem with this approach was that it led
    to rather contrived test-cases which in turn obscured the intended
    uses of the patch-set.  On this occasion, therefore, I have sent
    everything at once, and patches 7-17 are new.
  * In the previous versions, the variable RHS binops were still
    implemented as mask-and-xor operations, but the mask and xor values
    could be passed in registers.  Thus, in patches 18-30, the
    linearization and delinearization have been substantially reworked,
    and a number of other fixes have also been added.

For reference, v3 may be found here:

  https://lore.kernel.org/netfilter-devel/20200303094844.26694-1-jeremy@azazel.net/#r

Jeremy Sowden (32):
  examples: add .gitignore file
  include: add missing `#include`
  src: move `byteorder_names` array
  datatype: support `NULL` symbol-tables when printing constants
  ct: support `NULL` symbol-tables when looking up labels
  include: update nf_tables.h
  include: add new bitwise bit-length attribute to nf_tables.h
  netlink: send bit-length of bitwise binops to kernel
  netlink_delinearize: add postprocessing for payload binops
  netlink_delinearize: correct type and byte-order of shifts
  netlink_delinearize: correct length of right bitwise operand
  payload: set byte-order when completing expression
  evaluate: support shifts larger than the width of the left operand
  evaluate: relax type-checking for integer arguments in mark statements
  tests: shell: rename some test-cases
  tests: shell: add test-cases for ct and packet mark payload
    expressions
  tests: py: add test-cases for ct and packet mark payload expressions
  include: add new bitwise boolean attributes to nf_tables.h
  evaluate: don't eval unary arguments
  evaluate: prevent nested byte-order conversions
  evaluate: don't clobber binop lengths
  evaluate: insert byte-order conversions for expressions between 9 and
    15 bits
  evaluate: set eval context to leftmost bitwise operand
  netlink_delinearize: fix typo
  netlink_delinearize: refactor stmt_payload_binop_postprocess
  netlink_delinearize: add support for processing variable payload
    statement arguments
  netlink: rename bitwise operation functions
  netlink: support (de)linearization of new bitwise boolean operations
  parser_json: allow RHS ct, meta and payload expressions
  evaluate: allow binop expressions with variable right-hand operands
  tests: shell: add tests for binops with variable RHS operands
  tests: py: add tests for binops with variable RHS operands

 examples/.gitignore                           |   5 +
 include/datatype.h                            |   7 +
 include/linux/netfilter/nf_tables.h           |  49 ++-
 src/ct.c                                      |   9 +-
 src/datatype.c                                |  14 +-
 src/evaluate.c                                | 101 +++--
 src/netlink_delinearize.c                     | 408 +++++++++++++-----
 src/netlink_linearize.c                       |  66 ++-
 src/parser_json.c                             |   8 +-
 src/payload.c                                 |   1 +
 tests/py/any/ct.t                             |   1 +
 tests/py/any/ct.t.json                        |  37 ++
 tests/py/any/ct.t.payload                     |   9 +
 tests/py/inet/meta.t                          |   1 +
 tests/py/inet/meta.t.json                     |  37 ++
 tests/py/inet/meta.t.payload                  |   9 +
 tests/py/ip/ct.t                              |   3 +
 tests/py/ip/ct.t.json                         |  94 ++++
 tests/py/ip/ct.t.payload                      |  29 ++
 tests/py/ip/ip.t                              |   2 +
 tests/py/ip/ip.t.json                         |  77 +++-
 tests/py/ip/ip.t.payload                      |  28 ++
 tests/py/ip/ip.t.payload.bridge               |  32 ++
 tests/py/ip/ip.t.payload.inet                 |  32 ++
 tests/py/ip/ip.t.payload.netdev               |  32 ++
 tests/py/ip/meta.t                            |   3 +
 tests/py/ip/meta.t.json                       |  59 +++
 tests/py/ip/meta.t.payload                    |  18 +
 tests/py/ip6/ct.t                             |   7 +
 tests/py/ip6/ct.t.json                        |  93 ++++
 tests/py/ip6/ct.t.payload                     |  31 ++
 tests/py/ip6/ip6.t                            |   2 +
 tests/py/ip6/ip6.t.json                       |  76 ++++
 tests/py/ip6/ip6.t.payload.inet               |  34 ++
 tests/py/ip6/ip6.t.payload.ip6                |  30 ++
 tests/py/ip6/meta.t                           |   3 +
 tests/py/ip6/meta.t.json                      |  58 +++
 tests/py/ip6/meta.t.payload                   |  20 +
 .../{0040mark_shift_0 => 0040mark_binop_0}    |   2 +-
 .../{0040mark_shift_1 => 0040mark_binop_1}    |   2 +-
 .../shell/testcases/chains/0040mark_binop_10  |  11 +
 .../shell/testcases/chains/0040mark_binop_11  |  11 +
 .../shell/testcases/chains/0040mark_binop_12  |  11 +
 .../shell/testcases/chains/0040mark_binop_13  |  11 +
 tests/shell/testcases/chains/0040mark_binop_2 |  11 +
 tests/shell/testcases/chains/0040mark_binop_3 |  11 +
 tests/shell/testcases/chains/0040mark_binop_4 |  11 +
 tests/shell/testcases/chains/0040mark_binop_5 |  11 +
 tests/shell/testcases/chains/0040mark_binop_6 |  11 +
 tests/shell/testcases/chains/0040mark_binop_7 |  11 +
 tests/shell/testcases/chains/0040mark_binop_8 |  11 +
 tests/shell/testcases/chains/0040mark_binop_9 |  11 +
 .../testcases/chains/0044payload_binop_0      |  11 +
 .../testcases/chains/0044payload_binop_1      |  11 +
 .../testcases/chains/0044payload_binop_2      |  11 +
 .../testcases/chains/0044payload_binop_3      |  11 +
 .../testcases/chains/0044payload_binop_4      |  11 +
 .../testcases/chains/0044payload_binop_5      |  11 +
 ...0mark_shift_0.nft => 0040mark_binop_0.nft} |   2 +-
 ...0mark_shift_1.nft => 0040mark_binop_1.nft} |   2 +-
 .../chains/dumps/0040mark_binop_10.nft        |   6 +
 .../chains/dumps/0040mark_binop_11.nft        |   6 +
 .../chains/dumps/0040mark_binop_12.nft        |   6 +
 .../chains/dumps/0040mark_binop_13.nft        |   6 +
 .../chains/dumps/0040mark_binop_2.nft         |   6 +
 .../chains/dumps/0040mark_binop_3.nft         |   6 +
 .../chains/dumps/0040mark_binop_4.nft         |   6 +
 .../chains/dumps/0040mark_binop_5.nft         |   6 +
 .../chains/dumps/0040mark_binop_6.nft         |   6 +
 .../chains/dumps/0040mark_binop_7.nft         |   6 +
 .../chains/dumps/0040mark_binop_8.nft         |   6 +
 .../chains/dumps/0040mark_binop_9.nft         |   6 +
 .../chains/dumps/0044payload_binop_0.nft      |   6 +
 .../chains/dumps/0044payload_binop_1.nft      |   6 +
 .../chains/dumps/0044payload_binop_2.nft      |   6 +
 .../chains/dumps/0044payload_binop_3.nft      |   6 +
 .../chains/dumps/0044payload_binop_4.nft      |   6 +
 .../chains/dumps/0044payload_binop_5.nft      |   6 +
 78 files changed, 1660 insertions(+), 179 deletions(-)
 create mode 100644 examples/.gitignore
 create mode 100644 tests/py/ip6/ct.t
 create mode 100644 tests/py/ip6/ct.t.json
 create mode 100644 tests/py/ip6/ct.t.payload
 rename tests/shell/testcases/chains/{0040mark_shift_0 => 0040mark_binop_0} (68%)
 rename tests/shell/testcases/chains/{0040mark_shift_1 => 0040mark_binop_1} (70%)
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_10
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_11
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_12
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_13
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_2
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_3
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_4
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_5
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_6
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_7
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_8
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_9
 create mode 100755 tests/shell/testcases/chains/0044payload_binop_0
 create mode 100755 tests/shell/testcases/chains/0044payload_binop_1
 create mode 100755 tests/shell/testcases/chains/0044payload_binop_2
 create mode 100755 tests/shell/testcases/chains/0044payload_binop_3
 create mode 100755 tests/shell/testcases/chains/0044payload_binop_4
 create mode 100755 tests/shell/testcases/chains/0044payload_binop_5
 rename tests/shell/testcases/chains/dumps/{0040mark_shift_0.nft => 0040mark_binop_0.nft} (58%)
 rename tests/shell/testcases/chains/dumps/{0040mark_shift_1.nft => 0040mark_binop_1.nft} (64%)
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_10.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_11.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_12.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_13.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_2.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_3.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_4.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_5.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_6.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_7.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_8.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_9.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0044payload_binop_0.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0044payload_binop_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0044payload_binop_2.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0044payload_binop_3.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0044payload_binop_4.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0044payload_binop_5.nft

-- 
2.35.1

