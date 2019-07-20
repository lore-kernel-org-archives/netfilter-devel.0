Return-Path: <SRS0=YHPx=VR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB356C76195
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 16:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEA502085A
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 16:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfGTQbk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jul 2019 12:31:40 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40946 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbfGTQbk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jul 2019 12:31:40 -0400
Received: from localhost ([::1]:54036 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hosGo-0005VH-Kt; Sat, 20 Jul 2019 18:31:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 00/12] Larger xtables-save review
Date:   Sat, 20 Jul 2019 18:30:14 +0200
Message-Id: <20190720163026.15410-1-phil@nwl.cc>
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

Patch three sorts program names quoted in output of any of the *-save
programs, patch four unifies the header/footer comments in the same. The
latter also drops the extra newline printed in ebtables- and
arptables-save output, so test scripts need adjustments beyond dropping
the new comment lines from output.

Patch five fixes the table compatibility check in ip{6,}tables-nft-save.

Patches six and eight to ten prepare for integrating arptables- and
ebtables-save into the xtables-save code.

Patch seven merely fixes a minor coding-style issue.

Patches eleven and twelve finally perform the actual merge.

Phil Sutter (12):
  ebtables: Fix error message for invalid parameters
  ebtables-save: Fix counter formatting
  xtables-save: Use argv[0] as program name
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
 iptables/xtables-save.c                       | 242 ++++--------------
 11 files changed, 146 insertions(+), 239 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/ebtables/0004-save-counters_0

-- 
2.22.0

