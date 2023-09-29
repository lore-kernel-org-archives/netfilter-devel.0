Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 295FBE728D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 19:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbjI2TTd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 15:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbjI2TTc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 15:19:32 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA483F5
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 12:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5AHf6X4EpzacVib9Gr14I+6KklGxFzNKMluUxA6aNs4=; b=jVKCkhn9cNboCwpXZXWE+S1kAJ
        SeU0e+3p7u8I2idb6LN72hOm0CfjEHpyskWq7zvqzDZYoZJAWxrB7fNhWJQodT/9nx48/TTP6fYmi
        9DM06CRXijLIxoQrzthz/DZR+IkWPvFlpyxiWqhlod8WzhM31WZ+WlltnNsc01p0Y01QcFgfvFzD8
        tv2DDDzHUWEN5IKk03aTji5dIrD77LDxmudNV4ari1ca/mnU6rextWyu9ydjIknqCnNWLooiQoZQX
        Sjp9il82l2JWnSQShKiNYxAR8YETco+qDmmuyihXnbsZ0z+D7SBlAZE8hq/hKQ9J9Nczs0e7ZlDA1
        abHJrGuw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qmJ1K-0005E9-GM; Fri, 29 Sep 2023 21:19:26 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 0/5] nf_tables: nft_rule_dump_ctx fits into netlink_callback
Date:   Fri, 29 Sep 2023 21:19:17 +0200
Message-ID: <20230929191922.6230-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Struct netlink_callback has a 48byte scratch area for use by dump
callbacks to keep personal stuff.

In rule dumps set up by nf_tables_getrule(), this is used only to store
a cursor into the list of rules being dumped. Other data is allocated
and the pointer value assigned to struct netlink_callback::data.

Since the allocated data structure is small and fits into the scratch
area even after adding some more fields, move it there.

Patch 1 "simplifies" nf_tables_dump_rules_start() a bit, but actually
exists only to reduce patch 5's size.

Patch 2 is more or less fallout: The memset would mess things up after
this series, but it was pointless in the first place.

Patches 3 and 4 extend struct nft_rule_dump_ctx and make
struct netlink_callback's scratch area unused.

Patch 5 then finally eliminates the allocation.

All this is early preparation for reset command locking but unrelated
enough to go alone.

Phil Sutter (5):
  netfilter: nf_tables: Always allocate nft_rule_dump_ctx
  netfilter: nf_tables: Drop pointless memset when dumping rules
  netfilter: nf_tables: Carry reset flag in nft_rule_dump_ctx
  netfilter: nf_tables: Carry s_idx in nft_rule_dump_ctx
  netfilter: nf_tables: Don't allocate nft_rule_dump_ctx

 net/netfilter/nf_tables_api.c | 80 ++++++++++++++---------------------
 1 file changed, 31 insertions(+), 49 deletions(-)

-- 
2.41.0

