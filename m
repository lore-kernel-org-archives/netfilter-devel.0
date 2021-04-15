Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC8F0C433ED
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 13:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5E4A611F1
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 13:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhDONN5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 09:13:57 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57866 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhDONN5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 09:13:57 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 64F1B62C0E
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Apr 2021 15:13:06 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/10] cache updates
Date:   Thu, 15 Apr 2021 15:13:20 +0200
Message-Id: <20210415131330.6692-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains cache updates for nft:

#1 adds a object hashtable for lookups by name.
#2 adds a flowtable hashtable for lookups by name.
#3 adds set_cache_del() and use it from the monitor path.
#4 adds ruleset-defined sets to the cache.
#5 adds ruleset-defined flowtables to the cache.
#6 populates the table cache for several objects.
#7 adds ruleset-define policy objects to the cache.
#8 move struct nft_cache declaration to include/cache.h
#9 adds a table hashtable for lookups by name.
#10 removes table_lookup_global() which is not required
    anymore after the previous updates.

Pablo Neira Ayuso (10):
  cache: add hashtable cache for object
  cache: add hashtable cache for flowtable
  cache: add set_cache_del() and use it
  evaluate: add set to the cache
  evaluate: add flowtable to the cache
  cache: missing table cache for several policy objects
  evaluate: add object to the cache
  cache: move struct nft_cache declaration to cache.h
  cache: add hashtable cache for table
  evaluate: remove table_lookup_global()

 include/cache.h           |  25 ++++
 include/netlink.h         |   2 +
 include/nftables.h        |   8 +-
 include/rule.h            |  18 +--
 src/cache.c               | 244 ++++++++++++++++++++++++++++++++++++--
 src/evaluate.c            |  83 ++++++-------
 src/json.c                |  24 ++--
 src/libnftables.c         |   8 ++
 src/monitor.c             |  20 ++--
 src/netlink.c             |  23 +---
 src/netlink_delinearize.c |   4 +-
 src/rule.c                | 125 ++++++++-----------
 12 files changed, 399 insertions(+), 185 deletions(-)

-- 
2.20.1

