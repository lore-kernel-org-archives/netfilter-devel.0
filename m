Return-Path: <SRS0=FJFf=5X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D68C2BA2B
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Apr 2020 14:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D50C72072A
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Apr 2020 14:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgDGOez (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Apr 2020 10:34:55 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:54928 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728306AbgDGOez (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Apr 2020 10:34:55 -0400
Received: from localhost ([::1]:39786 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jLpJW-0007dk-2o; Tue, 07 Apr 2020 16:34:54 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/3] nft: cache: Minor review
Date:   Tue,  7 Apr 2020 16:34:42 +0200
Message-Id: <20200407143445.26394-1-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Minor code simplification in patches 1 and 2, a small tweak to set
fetching in patch 3.

Basically these are fall-out from working at rewritten cache logic.

Phil Sutter (3):
  nft: cache: Eliminate init_chain_cache()
  nft: cache: Init per table set list along with chain list
  nft: cache: Fetch sets per table

 iptables/nft-cache.c | 57 ++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 36 deletions(-)

-- 
2.25.1

