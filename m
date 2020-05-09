Return-Path: <SRS0=rZfM=6X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 589D8C28CBC
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 11:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38F2821655
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 11:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgEILwK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 May 2020 07:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726063AbgEILwK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 May 2020 07:52:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F04C061A0C
        for <netfilter-devel@vger.kernel.org>; Sat,  9 May 2020 04:52:10 -0700 (PDT)
Received: from localhost ([::1]:37184 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jXO1Y-0005fY-P3; Sat, 09 May 2020 13:52:08 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/2] Critical: Unbreak nfnl_osf tool
Date:   Sat,  9 May 2020 13:51:58 +0200
Message-Id: <20200509115200.19480-1-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I managed to render nfnl_osf tool useless with my (obviously untested)
conversion to nfnl_query(). Unbreak it and also fix delete functionality
which was already broken before I started messing with it.

Phil Sutter (2):
  nfnl_osf: Fix broken conversion to nfnl_query()
  nfnl_osf: Improve error handling

 utils/nfnl_osf.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

-- 
2.25.1

