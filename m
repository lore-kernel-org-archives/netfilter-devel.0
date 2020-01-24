Return-Path: <SRS0=/v6G=3N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B25C32771
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jan 2020 14:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E9FC2072C
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jan 2020 14:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579875855;
	bh=NvMQwN4NqQFLjdHLzXDLee5CT4nUiZxasY9ZXbNAiJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=SWyPICtQYclEQ/ebK0S04fS0wd+hGDPdb+EA1EZ612weouWYzL24p+wYjTCstpTvM
	 8RIhSnE7DUuvd76ATOSEQZyOIMsEVaIu2tAkYeTuOz1g0IqIPPaXg0HIOc9DWhTpg9
	 EF/VRKppO1SQOc9GjBzTSp4NzzrUrz7wgKC+z5/E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392309AbgAXOWO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Jan 2020 09:22:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392301AbgAXOWL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Jan 2020 09:22:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA857222C2;
        Fri, 24 Jan 2020 14:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875731;
        bh=NvMQwN4NqQFLjdHLzXDLee5CT4nUiZxasY9ZXbNAiJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtsY0hKHOIli7/ScGdlv7nMfKvOb8e0PZZwhSjIUfroAiSShZ7oNg5Hqbz0sh2nX0
         ar+wRcFg4wL1TgaOx3/QqoO91Ktbv7DO5nRbDO+bnp44w4o+UhZr9/4ScE4ulaahfu
         srQ/aRNme/CkT0+9dZLDz+j4vnt8w5qh8WHMHWGQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/18] netfilter: fix a use-after-free in mtype_destroy()
Date:   Fri, 24 Jan 2020 09:21:49 -0500
Message-Id: <20200124142157.30931-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142157.30931-1-sashal@kernel.org>
References: <20200124142157.30931-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit c120959387efa51479056fd01dc90adfba7a590c ]

map->members is freed by ip_set_free() right before using it in
mtype_ext_cleanup() again. So we just have to move it down.

Reported-by: syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com
Fixes: 40cd63bf33b2 ("netfilter: ipset: Support extensions which need a per data destroy function")
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 2e8e7e5fb4a64..9b32059dee2d7 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -66,9 +66,9 @@ mtype_destroy(struct ip_set *set)
 	if (SET_WITH_TIMEOUT(set))
 		del_timer_sync(&map->gc);
 
-	ip_set_free(map->members);
 	if (set->dsize && set->extensions & IPSET_EXT_DESTROY)
 		mtype_ext_cleanup(set);
+	ip_set_free(map->members);
 	ip_set_free(map);
 
 	set->data = NULL;
-- 
2.20.1

