Return-Path: <SRS0=tJiL=YV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B15CCA9EC0
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 15:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7738120830
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 15:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390088AbfJ1PtV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Oct 2019 11:49:21 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40158 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390007AbfJ1PtV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Oct 2019 11:49:21 -0400
Received: from localhost ([::1]:53248 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iP7Gh-00028J-L0; Mon, 28 Oct 2019 16:49:19 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 00/10] Reduce code size around arptables-nft
Date:   Mon, 28 Oct 2019 16:48:08 +0100
Message-Id: <20191028154818.31257-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A review of xtables-arp.c exposed a significant amount of dead, needless
or duplicated code. This series deals with some low hanging fruits. Most
of the changes affect xtables-arp.c and nft-arp.c only, but where common
issues existed or code was to be shared, other files are touched as
well.

Changes since v1:
- Add missing inverse_for_options array adjustments to patch 7.

Phil Sutter (10):
  ip6tables, xtables-arp: Drop unused struct pprot
  xshared: Share a common add_command() implementation
  xshared: Share a common implementation of parse_rulenumber()
  Merge CMD_* defines
  xtables-arp: Drop generic_opt_check()
  Replace TRUE/FALSE with true/false
  xtables-arp: Integrate OPT_* defines into xshared.h
  xtables-arp: Drop some unused variables
  xtables-arp: Use xtables_parse_interface()
  nft-arp: Use xtables_print_mac_and_mask()

 iptables/ip6tables.c   |  73 +-----------
 iptables/iptables.c    |  64 +----------
 iptables/nft-arp.c     |  31 +----
 iptables/nft-shared.h  |  17 ---
 iptables/xshared.c     |  39 +++++++
 iptables/xshared.h     |  32 ++++++
 iptables/xtables-arp.c | 255 ++++-------------------------------------
 iptables/xtables.c     |  48 +-------
 8 files changed, 107 insertions(+), 452 deletions(-)

-- 
2.23.0

