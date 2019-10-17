Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A439CA9EB3
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 22:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0787F21A49
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 22:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438308AbfJQWtI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 18:49:08 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:42624 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732705AbfJQWtI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 18:49:08 -0400
Received: from localhost ([::1]:55714 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iLEZv-00044p-2j; Fri, 18 Oct 2019 00:49:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/8] A bit of *tables-restore review fallout
Date:   Fri, 18 Oct 2019 00:48:28 +0200
Message-Id: <20191017224836.8261-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Preparing for upcoming xtables-restore performance improvements I
noticed a few things to smooth out. Patches in this series are not
functionally related.

Phil Sutter (8):
  xtables-restore: Treat struct nft_xt_restore_parse as const
  xtables-restore: Use xt_params->program_name
  xtables-restore: Introduce rule counter tokenizer function
  xtables-restore: Constify struct nft_xt_restore_cb
  iptables-restore: Constify struct iptables_restore_cb
  xtables-restore: Drop pointless newargc reset
  xtables-restore: Drop local xtc_ops instance
  xtables-restore: Drop chain_list callback

 iptables/iptables-restore.c                   | 44 +++-------
 iptables/iptables-xml.c                       | 31 +------
 iptables/nft-shared.h                         |  7 +-
 .../ipt-restore/0008-restore-counters_0       | 22 +++++
 iptables/xshared.c                            | 37 +++++++++
 iptables/xshared.h                            |  1 +
 iptables/xtables-restore.c                    | 81 ++++---------------
 iptables/xtables-translate.c                  |  4 +-
 8 files changed, 90 insertions(+), 137 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/ipt-restore/0008-restore-counters_0

-- 
2.23.0

