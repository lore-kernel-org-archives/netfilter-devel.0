Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A87C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 22:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AC7C2073C
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 22:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfLBWY1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 17:24:27 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:54618 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfLBWY1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 17:24:27 -0500
Received: from localhost ([::1]:39476 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1ibu7G-0000Ei-7K; Mon, 02 Dec 2019 23:24:26 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 0/4] Fix covscan-detected issues
Date:   Mon,  2 Dec 2019 23:23:57 +0100
Message-Id: <20191202222401.867-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These are merely memleaks in error paths related to multi device support
in flowtables and netdev family chains.

Phil Sutter (4):
  flowtable: Fix memleak in error path of nftnl_flowtable_parse_devs()
  chain: Fix memleak in error path of nftnl_chain_parse_devs()
  flowtable: Correctly check realloc() call
  chain: Correctly check realloc() call

 src/chain.c     | 12 ++++++------
 src/flowtable.c | 12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

-- 
2.24.0

