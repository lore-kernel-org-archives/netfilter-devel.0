Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADF1C07480
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Oct 2023 17:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377908AbjJTRep (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Oct 2023 13:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjJTRem (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2023 13:34:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29FBD67
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2023 10:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=L2UcNsS3g0gKqqCTS5obUY8kFwjyrw8ItTcgPyeiIQU=; b=ZnwSOS5kSdm2SyBeRl7B6fKXBs
        FI71BgGWIxe6S7O4Vv0w7OZ4elRMQJthCnptkiQlwE+svKX/nvPfwHR+Utje1xngqs5T+IxQSJS8Y
        GZ5Q3sevRZ6We29WxgcECSQ4H7BrL8Yx3Ffq6/w5VFyAu53UKQssnDSF6h3S/LONh8wAUuM1uG2YF
        u50/o8U9qGtfn8CJ4VNoZaLneRZb3i8d4FzTXAuPQE/pINHlsvqMyzZbhlxh1Jr3ee1PdOrIMxmeg
        xjHqgYrGnMuChLWB8Cnn3AkPxrC4IQTAYa7LXELgRwFxFA5ns/ZEHBzc5aEYcFoqheHdX0pz6H3sL
        o6YLVdMg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qttOQ-0003kq-1y; Fri, 20 Oct 2023 19:34:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 0/6] Refactor nft_obj_filter into nft_obj_dump_ctx
Date:   Fri, 20 Oct 2023 19:34:27 +0200
Message-ID: <20231020173433.4611-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is ultimately prep work for object reset locking, but valid on it's
own:

Make object dump routines utilize struct netlink_callback's scratch area
for context data. This requires to relocate the s_idx counter, so turn
nft_obj_filter into a real context data structure holding also the
counter (and the reset boolean as well).

Phil Sutter (6):
  netfilter: nf_tables: Drop pointless memset in nf_tables_dump_obj
  netfilter: nf_tables: Unconditionally allocate nft_obj_filter
  netfilter: nf_tables: A better name for nft_obj_filter
  netfilter: nf_tables: Carry s_idx in nft_obj_dump_ctx
  netfilter: nf_tables: nft_obj_filter fits into cb->ctx
  netfilter: nf_tables: Carry reset boolean in nft_obj_dump_ctx

 net/netfilter/nf_tables_api.c | 66 ++++++++++++++---------------------
 1 file changed, 26 insertions(+), 40 deletions(-)

-- 
2.41.0

