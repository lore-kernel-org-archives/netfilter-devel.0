Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBCFC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 10:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjKCKXo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 06:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjKCKXn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 06:23:43 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E35D44
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 03:23:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qyrKx-00054R-Ea; Fri, 03 Nov 2023 11:23:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables 0/4] add arptables-translate
Date:   Fri,  3 Nov 2023 11:23:22 +0100
Message-ID: <20231103102330.27578-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

iptables-nft lacks a translate variant for arptables.

Add it.  First patch fixes a bug in existing arptables-nft,
second patch adds missing mask matching.
Patch 3 is the main arptables-translate support.

Last patch adds a few test cases.

Florian Westphal (4):
  arptables-nft: use ARPT_INV flags consistently
  nft-arp: add missing mask support
  nft-arp: add arptables-translate
  arptables-txlate: add test cases

 extensions/generic.txlate        |   6 +
 extensions/libarpt_mangle.c      |  47 +++++++
 extensions/libarpt_mangle.txlate |   6 +
 iptables/nft-arp.c               | 230 +++++++++++++++++++++++++++----
 iptables/nft-ruleparse-arp.c     |  24 ++--
 iptables/xtables-multi.h         |   1 +
 iptables/xtables-nft-multi.c     |   1 +
 iptables/xtables-translate.c     |  35 ++++-
 xlate-test.py                    |   2 +-
 9 files changed, 312 insertions(+), 40 deletions(-)
 create mode 100644 extensions/libarpt_mangle.txlate

-- 
2.41.0

