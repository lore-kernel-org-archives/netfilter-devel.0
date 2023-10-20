Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E12FFC25B40
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Oct 2023 17:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377915AbjJTRep (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Oct 2023 13:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjJTRem (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2023 13:34:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED62FD68
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2023 10:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Iu+53/w5OWCGWed8Iv1zc0bWnDgl4BGKxDc4yJ32RaI=; b=Ro/C7HkeVyToJllOXA5+cuAQvA
        UXex2hI9S4RK2rnNtrc57NQnpFFLHsqKRRpFtrC13miYiBqXOahlr5KfB7O/x9ufAWIjsP5HOPQJO
        MpptkUOzh1mcourF233TFUmAFd2gGsI3k4ngxE096JpEOE9c2P0u5v2FXF1lLxYgQT7ZbZMz491Ri
        sHWsu0WyJk/0pfeS+YcFyXoqlRDBZ8hXMCUXf//CiFm0tVC64e8ZsfMmuR/M+usq0mhSiYeEkzQrB
        E3zgTWKU7tUv5ub8JWvMaUCpDpbU8eRgN0GkwrsjlyK43hsP29UzdpQ7ptmtq7PCpzIVD0CqHYdeY
        KgpPHJfQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qttOQ-0003kv-Bh; Fri, 20 Oct 2023 19:34:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 1/6] netfilter: nf_tables: Drop pointless memset in nf_tables_dump_obj
Date:   Fri, 20 Oct 2023 19:34:28 +0200
Message-ID: <20231020173433.4611-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231020173433.4611-1-phil@nwl.cc>
References: <20231020173433.4611-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The code does not make use of cb->args fields past the first one, no
need to zero them.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 20734fbb0d94..0f7ee76ad64f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7725,9 +7725,6 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 				goto cont;
 			if (idx < s_idx)
 				goto cont;
-			if (idx > s_idx)
-				memset(&cb->args[1], 0,
-				       sizeof(cb->args) - sizeof(cb->args[0]));
 			if (filter && filter->table &&
 			    strcmp(filter->table, table->name))
 				goto cont;
-- 
2.41.0

