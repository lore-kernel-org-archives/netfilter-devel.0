Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F30C76188
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 10:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AF56217D6
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 10:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfGVKRA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 06:17:00 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45468 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbfGVKQ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 06:16:59 -0400
Received: from localhost ([::1]:58558 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hpVNK-0000d3-1N; Mon, 22 Jul 2019 12:16:58 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 00/11] Larger xtables-save review
Date:   Mon, 22 Jul 2019 12:16:17 +0200
Message-Id: <20190722101628.21195-1-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series started as a fix to program names mentioned in *-save
outputs and ended in merging ebtables-save and arptables-save code into
xtables_save_main used by ip{6,}tables-nft-save.

The first patch is actually unrelated but was discovered when testing
counter output - depending on environment, ebtables-nft might segfault.

The second patch fixes option '-c' of ebtables-nft-save which enables
counter prefixes in dumped rules but failed to disable the classical
ebtables-style counters.

Patch three unifies the header/footer comments in all the *-save tools
and also drops the extra newline printed in ebtables- and arptables-save
output, so test scripts need adjustments beyond dropping the new comment
lines from output.

Patch four fixes the table compatibility check in ip{6,}tables-nft-save.

Patches five and seven to nine prepare for integrating arptables- and
ebtables-save into the xtables-save code.

Patch six merely fixes a minor coding-style issue.

Patches ten and eleven finally perform the actual merge.

Changes since v1:
- Rebased onto current master branch.
- Improved commit message in patch eight.

Phil Sutter (11):
  ebtables: Fix error message for invalid parameters
  ebtables-save: Fix counter formatting
  xtables-save: Unify *-save header/footer comments
  xtables-save: Fix table compatibility check
  nft: Make nft_for_each_table() more versatile
  xtables-save: Avoid mixed code and declarations
  xtables-save: Pass optstring/longopts to xtables_save_main()
  xtables-save: Make COMMIT line optional
  xtables-save: Pass format flags to do_output()
  arptables-save: Merge into xtables_save_main()
  ebtables-save: Merge into xtables_save_main()

 iptables/nft-bridge.c                         |  39 +--
 iptables/nft.c                                |   6 +-
 iptables/nft.h                                |   2 +-
 .../arptables/0001-arptables-save-restore_0   |   7 +-
 .../0002-arptables-restore-defaults_0         |   6 +-
 .../arptables/0003-arptables-verbose-output_0 |   5 +-
 .../ebtables/0002-ebtables-save-restore_0     |   4 +-
 .../ebtables/0003-ebtables-restore-defaults_0 |   6 +-
 .../testcases/ebtables/0004-save-counters_0   |  64 +++++
 iptables/xtables-eb.c                         |   4 +-
 iptables/xtables-save.c                       | 237 ++++--------------
 11 files changed, 143 insertions(+), 237 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/ebtables/0004-save-counters_0

-- 
2.22.0

