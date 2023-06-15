Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18099EB64DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Jun 2023 14:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240874AbjFOOo0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Jun 2023 10:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238918AbjFOOo0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Jun 2023 10:44:26 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BDB2738
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2023 07:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lwhq6F/YyvCascMaNV0M5svv3DyZJs4xN1FRoW59ZKc=; b=eAXr2r0Kj4P8uWjbU1Zw6V3WaJ
        jZq+z7Q6wiUooitfvhTXMZdUQYSEuWTMCf0fTQpGEpgcaNe6v/SnwGsoIYQGad+GmJ+g+mDN+5A9s
        YPWTORnwvooSvvPzxC+D2ZdHfArMEFcT778/ZKQpvWWvjOqO9n+zX876wscvrvvnJejcPtjcXLOl3
        iadWX6BqPLVPf6FlpIdLlcjtYlcbkiTxU7paW4G/8B7Xj0DCyWxnbQEeHL37238LSBI8xfYtUF9ld
        Lt572ZOSerfd4BDc9RIlGoXCZiaEBy92Cqub5JcE6ncY2DeLvv3YKY/kscubDw4WLLx4ETVTOjXsc
        Brzc1s7A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1q9oD1-0003mt-I1; Thu, 15 Jun 2023 16:44:23 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/3] Implement 'reset {set,map,element}' commands
Date:   Thu, 15 Jun 2023 16:44:11 +0200
Message-Id: <20230615144414.1393-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series makes use of the new NFT_MSG_GETSETELEM_RESET message type
to reset state in set elements.

Patches one and two are fallout from working on the actual
implementation in patch three.

Phil Sutter (3):
  evaluate: Merge some cases in cmd_evaluate_list()
  evaluate: Cache looked up set for list commands
  Implement 'reset {set,map,element}' commands

 doc/libnftables-json.adoc                  |  2 +-
 doc/nft.txt                                | 13 ++--
 include/linux/netfilter/nf_tables.h        |  2 +
 include/mnl.h                              |  6 +-
 include/netlink.h                          |  5 +-
 src/cache.c                                |  9 ++-
 src/evaluate.c                             | 42 +++--------
 src/json.c                                 |  9 ++-
 src/mnl.c                                  | 22 ++++--
 src/netlink.c                              |  8 +--
 src/parser_bison.y                         | 12 ++++
 src/parser_json.c                          |  4 ++
 src/rule.c                                 | 27 +++++--
 tests/shell/testcases/sets/reset_command_0 | 82 ++++++++++++++++++++++
 14 files changed, 181 insertions(+), 62 deletions(-)
 create mode 100755 tests/shell/testcases/sets/reset_command_0

-- 
2.40.0

