Return-Path: <SRS0=hXfx=ZH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A1B7C432C3
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 09:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ACC720740
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 09:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKOJrX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Nov 2019 04:47:23 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:54722 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfKOJrX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Nov 2019 04:47:23 -0500
Received: from localhost ([::1]:39580 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iVYCI-0008Dr-A0; Fri, 15 Nov 2019 10:47:22 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/2] Restore rule counter zeroing
Date:   Fri, 15 Nov 2019 10:47:23 +0100
Message-Id: <20191115094725.19756-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Zeroing rule counters was broken in two ways: On one hand, cache
optimizations went a little too far (actually I missed that rule cache
is required for CMD_ZERO). On the other, rule replace logic was
insufficient with regards to NFTA_RULE_COMPAT attribute (elaborate
details in second patch).

Phil Sutter (2):
  nft: CMD_ZERO needs a rule cache
  nft: Fix -Z for rules with NFTA_RULE_COMPAT

 iptables/nft.c             | 41 ++++++++++++++++++++++++++++++++++++++
 iptables/xtables-restore.c |  1 +
 2 files changed, 42 insertions(+)

-- 
2.24.0

