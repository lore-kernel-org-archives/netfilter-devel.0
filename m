Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61ADBC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jan 2022 00:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347258AbiALAeM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 19:34:12 -0500
Received: from mail.netfilter.org ([217.70.188.207]:47916 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236299AbiALAeM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 19:34:12 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 807BA64285
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jan 2022 01:31:19 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/4] fix list chain x y with anonymous chains
Date:   Wed, 12 Jan 2022 01:33:57 +0100
Message-Id: <20220112003401.332999-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Patches 1 to 3 are cache preparation work.

Then, patch 4 fixes listing

 # nft list chain x y
 table ip x {
        chain y {
                jump {
                        accept
                }
        }
 }

This is broken in the nftables 1.0.1 release.

See https://bugzilla.netfilter.org/show_bug.cgi?id=1577

Pablo Neira Ayuso (4):
  src: do not use the nft_cache_filter object from mnl.c
  cache: do not set error code twice
  cache: add helper function to fill up the rule cache
  src: 'nft list chain' prints anonymous chains correctly

 include/cache.h                               |   3 +
 include/mnl.h                                 |   2 +-
 include/netlink.h                             |   1 +
 src/cache.c                                   | 113 ++++++++++++------
 src/mnl.c                                     |  12 +-
 src/netlink_delinearize.c                     |   8 ++
 .../testcases/cache/0010_implicit_chain_0     |  19 +++
 7 files changed, 113 insertions(+), 45 deletions(-)
 create mode 100755 tests/shell/testcases/cache/0010_implicit_chain_0

-- 
2.30.2

