Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780E8CE7A8C
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Sep 2023 01:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjIWByE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 21:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjIWByD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 21:54:03 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED3E1A8;
        Fri, 22 Sep 2023 18:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uNZUe3aZG8TITkwpZsigv7SBafCmnnUKlP7IpcuOXqc=; b=b/E1/FcQ1zeJs1N5X1agSeanYL
        h+EfsHT4qjiWSwwtCAtuu6n5zaCqiLYK8kPl7VNOvoU2P8DKu3PTyT3jj2RrhZtYygdyY3huCtJxj
        SZT2ktX3pIYw8qza098O3xoIczu8YGedkCj2jDZ+tyPn1lnbBtVOEnOcPL3ehRyLmYIFoYNX5v/gM
        nSmC8jdCUbpWsNc7+xZvFvBc06vKGBNUhRmPbnlmMiO6asmbVE10Q10cfKIWQZfpYa0eRbI2I+3o8
        mzUhwaQY63KtK3cKr44eyWRXc8wJXGQ3GLRWkwgrpWWbcLcunjGcu1lmhjGMWFOLtJP5629Unv+wO
        p8qtSodg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qjrqF-00028f-0a; Sat, 23 Sep 2023 03:53:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [nf PATCH 0/3] Review nf_tables audit logging
Date:   Sat, 23 Sep 2023 03:53:48 +0200
Message-ID: <20230923015351.15707-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When working on locking for reset commands, some audit log calls had to
be adjusted as well. This series deals with the "fallout" from adding
tests for the changed log calls, dealing with the uncovered issues and
adding more tests.

Patch 1 adds more testing to nft_audit.sh for commands which are
unproblematic.

Patch 2 deals with (likely) leftovers from audit log flood prevention in
commit c520292f29b80 ("audit: log nftables configuration change events
once per table").

Patch 3 changes logging for object reset requests to happen once per
table (if skb size is sufficient) and thereby aligns output with object
add requests. As a side-effect, logging is fixed to happen after the
actual reset has succeeded, not before.

NOTE: This whole series probably depends on the reset locking series[1]
submitted earlier, but there's no functional connection and reviews
should happen independently.

[1] https://lore.kernel.org/netfilter-devel/20230923013807.11398-1-phil@nwl.cc/

Phil Sutter (3):
  selftests: netfilter: Extend nft_audit.sh
  netfilter: nf_tables: Deduplicate nft_register_obj audit logs
  netfilter: nf_tables: Audit log object reset once per table

 net/netfilter/nf_tables_api.c                 |  95 +++++-----
 .../testing/selftests/netfilter/nft_audit.sh  | 163 ++++++++++++++++--
 2 files changed, 203 insertions(+), 55 deletions(-)

-- 
2.41.0

