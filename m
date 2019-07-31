Return-Path: <SRS0=6+Vk=V4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31A1C32751
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 16:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 937FB206A2
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 16:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbfGaQja (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Jul 2019 12:39:30 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40904 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfGaQja (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Jul 2019 12:39:30 -0400
Received: from localhost ([::1]:53994 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hsrdR-0005jC-5d; Wed, 31 Jul 2019 18:39:29 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/5] xtables-monitor enhancements
Date:   Wed, 31 Jul 2019 18:39:10 +0200
Message-Id: <20190731163915.22232-1-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series introduces family-specific xtables-monitor aliases as
suggested during NFWS, the relevant code is in patches four and five.

The first three patches are fallout from the above, mostly minor fixes
found along the way.

Phil Sutter (5):
  doc: Clean generated *-restore-translate man pages
  doc: Fix xtables-monitor man page
  xtables-monitor: Improve error messages
  xtables-monitor: Support ARP and bridge families
  xtables-monitor: Add family-specific aliases

 iptables/Makefile.am          |  21 ++++--
 iptables/xtables-monitor.8.in |  32 +++++++--
 iptables/xtables-monitor.c    | 124 ++++++++++++++++++++++++++++------
 iptables/xtables-multi.h      |   4 ++
 iptables/xtables-nft-multi.c  |   4 ++
 5 files changed, 154 insertions(+), 31 deletions(-)

-- 
2.22.0

