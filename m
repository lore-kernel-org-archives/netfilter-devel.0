Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1393AC10F03
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 13:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BA0F20678
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 13:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbfDYNAD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 09:00:03 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:55880 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728506AbfDYNAD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 09:00:03 -0400
Received: from localhost ([::1]:40738 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hJdys-0007tB-Ge; Thu, 25 Apr 2019 15:00:02 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/4] Misc minor fixes
Date:   Thu, 25 Apr 2019 14:59:39 +0200
Message-Id: <20190425125943.15787-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series contains a few smaller fixes to tests and JSON parser.

Phil Sutter (4):
  tests: monitor: Adjust to changed events ordering
  tests/py: Fix error messages in chain_delete()
  parser_json: Fix typo in ct timeout policy parser
  parser_json: Fix parser for list maps command

 src/parser_json.c                | 4 ++--
 tests/monitor/testcases/simple.t | 4 ++--
 tests/py/nft-test.py             | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.21.0

