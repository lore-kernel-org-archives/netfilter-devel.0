Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA59C48BE0
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Jun 2021 16:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C7FA6101B
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Jun 2021 16:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhFKQmu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 12:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhFKQmt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 12:42:49 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC45BC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Jun 2021 09:40:50 -0700 (PDT)
Received: from localhost ([::1]:41300 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1lrkDA-0005bj-9x; Fri, 11 Jun 2021 18:40:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 00/10] Some covscan fixes
Date:   Fri, 11 Jun 2021 18:40:54 +0200
Message-Id: <20210611164104.8121-1-phil@nwl.cc>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series fixes a bunch of minor issues identified by Coverity tool.

Phil Sutter (10):
  parser_bison: Fix for implicit declaration of isalnum
  parser_json: Fix for memleak in tcp option error path
  evaluate: Mark fall through case in str2hooknum()
  json: Drop pointless assignment in exthdr_expr_json()
  netlink: Avoid memleak in error path of netlink_delinearize_set()
  netlink: Avoid memleak in error path of netlink_delinearize_chain()
  netlink: Avoid memleak in error path of netlink_delinearize_table()
  netlink: Avoid memleak in error path of netlink_delinearize_obj()
  netlink_delinearize: Fix suspicious calloc() call
  rule: Fix for potential off-by-one in cmd_add_loc()

 src/evaluate.c            | 1 +
 src/json.c                | 1 -
 src/netlink.c             | 7 +++++--
 src/netlink_delinearize.c | 5 ++---
 src/parser_bison.y        | 1 +
 src/parser_json.c         | 6 +++---
 src/rule.c                | 2 +-
 7 files changed, 13 insertions(+), 10 deletions(-)

-- 
2.31.1

