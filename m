Return-Path: <SRS0=cZSN=YJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02636FA3728
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 23:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6944207FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 23:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390462AbfJPXDn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Oct 2019 19:03:43 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40202 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731616AbfJPXDn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Oct 2019 19:03:43 -0400
Received: from localhost ([::1]:53292 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iKsKU-0005er-E3; Thu, 17 Oct 2019 01:03:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/4] A bunch of fixes for --echo option
Date:   Thu, 17 Oct 2019 01:03:18 +0200
Message-Id: <20191016230322.24432-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Echo/monitor testsuite failed for multiple reasons. With this series
applied and a libnftnl with the recently submiited NFTA_CT_TIMEOUT_DATA
parser fix in place, testsuite finally passes again.

Phil Sutter (4):
  monitor: Add missing newline to error message
  Revert "monitor: fix double cache update with --echo"
  tests/monitor: Fix for changed ct timeout format
  rule: Fix for single line ct timeout printing

 src/monitor.c                    | 3 ++-
 src/rule.c                       | 2 +-
 tests/monitor/testcases/object.t | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

-- 
2.23.0

