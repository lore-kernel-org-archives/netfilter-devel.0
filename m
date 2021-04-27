Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406F5C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Apr 2021 10:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FFC4613B2
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Apr 2021 10:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbhD0Knz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Apr 2021 06:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235562AbhD0Kny (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 06:43:54 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679DEC061574
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Apr 2021 03:43:11 -0700 (PDT)
Received: from localhost ([::1]:59176 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lbLBN-0001Yg-VS; Tue, 27 Apr 2021 12:43:10 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/2] Drop use of some obsolete functions
Date:   Tue, 27 Apr 2021 12:42:57 +0200
Message-Id: <20210427104259.22042-1-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A run of 'rpminspect' (a static code analyzer) complained about calls to
gethostbyaddr(), inet_aton() and inet_ntoa(). Eliminating those offered
the chance to drop some redundant code from nft-arp.c as well.

Phil Sutter (2):
  Eliminate inet_aton() and inet_ntoa()
  nft-arp: Make use of ipv4_addr_to_string()

 extensions/libebt_among.c |  6 ++-
 iptables/nft-arp.c        | 99 ++++-----------------------------------
 iptables/nft-ipv4.c       | 23 +++++----
 iptables/xshared.c        |  6 +--
 iptables/xshared.h        |  3 ++
 5 files changed, 32 insertions(+), 105 deletions(-)

-- 
2.31.0

