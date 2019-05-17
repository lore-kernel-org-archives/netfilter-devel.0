Return-Path: <SRS0=W6An=TR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F028EC04AB4
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 May 2019 23:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC2522087E
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 May 2019 23:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfEQXAu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 May 2019 19:00:50 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:57054 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726519AbfEQXAu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 May 2019 19:00:50 -0400
Received: from localhost ([::1]:41910 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hRlqK-0007GS-Pz; Sat, 18 May 2019 01:00:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Eric Garver <e@erig.me>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 0/3] Resolve cache update woes
Date:   Sat, 18 May 2019 01:00:30 +0200
Message-Id: <20190517230033.25417-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series implements a fix for situations where a cache update removes
local (still uncommitted) items from cache leading to spurious errors
afterwards.

The series is based on Eric's "src: update cache if cmd is more
specific" patch which is still under review but resolves a distinct
problem from the one addressed in this series.

The first patch improves Eric's patch a bit. If he's OK with my change,
it may very well be just folded into his.

Phil Sutter (3):
  src: Improve cache_needs_more() algorithm
  libnftables: Keep list of commands in nft context
  src: Restore local entries after cache update

 include/nftables.h |  1 +
 src/libnftables.c  | 21 +++++------
 src/rule.c         | 91 +++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 96 insertions(+), 17 deletions(-)

-- 
2.21.0

