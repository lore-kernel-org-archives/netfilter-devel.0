Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C19DCA9EAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 16:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00CCC21906
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 16:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503489AbfJXQhx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 12:37:53 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:58936 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503426AbfJXQhx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 12:37:53 -0400
Received: from localhost ([::1]:43794 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iNg7U-0005EY-Hn; Thu, 24 Oct 2019 18:37:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 0/7] Improve xtables-restore performance
Date:   Thu, 24 Oct 2019 18:37:05 +0200
Message-Id: <20191024163712.22405-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series speeds up xtables-restore calls with --noflush (typically
used to batch a few commands for faster execution) by preliminary input
inspection.

Before, setting --noflush flag would inevitably lead to full cache
population. With this series in place, if input can be fully buffered
and no commands requiring full cache is contained, no initial cache
population happens and each rule parsed will cause fetching of cache
bits as required.

The input buffer size is arbitrarily chosen to be 64KB.

Patches one and two prepare code for patch three which moves the loop
content parsing each line of input into a separate function. The
reduction of code indenting is used by patch four which deals with
needless line breaks.

Patch five deals with another requirement of input buffering, namely
stripping newline characters from each line. This is not a problem by
itself, but add_param_to_argv() replaces them by nul-chars and so
strings stop being consistently terminated (some by a single, some by
two nul-chars).

Patch six then finally adds the buffering and caching decision code.

Patch seven is pretty unrelated but tests a specific behaviour of
*tables-restore I wasn't sure of at first.

Phil Sutter (7):
  xtables-restore: Integrate restore callbacks into struct
    nft_xt_restore_parse
  xtables-restore: Introduce struct nft_xt_restore_state
  xtables-restore: Introduce line parsing function
  xtables-restore: Remove some pointless linebreaks
  xtables-restore: Allow lines without trailing newline character
  xtables-restore: Improve performance of --noflush operation
  tests: shell: Add ipt-restore/0007-flush-noflush_0

 iptables/nft-shared.h                         |  18 +-
 .../ipt-restore/0007-flush-noflush_0          |  42 ++
 iptables/xshared.c                            |   4 +
 iptables/xtables-restore.c                    | 443 +++++++++++-------
 iptables/xtables-translate.c                  |   6 +-
 5 files changed, 323 insertions(+), 190 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/ipt-restore/0007-flush-noflush_0

-- 
2.23.0

