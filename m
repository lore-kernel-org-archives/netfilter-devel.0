Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E83BDC433FF
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 13:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFEE820679
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 13:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564753044;
	bh=nUdfbhfIQrSghXscbJC5+DYXbBibO3UhUhJIbYLvPp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wFzHOnCgIPdoRcR3f7slxMi4hViXLEpMhHefKz0zQsnozpcBlS2vLMiStXLWFgAfE
	 y8i4ZOdc9pUilP0jnzOPx4HsPAxHNRTvSqm9WrUR+8A7w1ZKxPqUHWsBn0jEH4rEFx
	 zNP6+/Qnp78TK7A2cPNJZOZo37T1fScOGAB1naX8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393224AbfHBNT4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 09:19:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393219AbfHBNTz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 09:19:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8D6D2173E;
        Fri,  2 Aug 2019 13:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564751994;
        bh=nUdfbhfIQrSghXscbJC5+DYXbBibO3UhUhJIbYLvPp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dr6P3OuRq961fC8OsY45tXvhfBE8NiYpURE9AsA8rg1xDQG+dkbKpPZ0yNZ+neQFP
         vNqBKpMDSbKPpn5PiAPdwwI/iJW2wBYiWjn4hddWke5G+8fsPdrycWw3ucc9vc3zGY
         IhyRsOXWJcrHiOU82c7Fd9aEhqAPx/Rz8EbdGsNc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 02/76] netfilter: nfnetlink: avoid deadlock due to synchronous request_module
Date:   Fri,  2 Aug 2019 09:18:36 -0400
Message-Id: <20190802131951.11600-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 1b0890cd60829bd51455dc5ad689ed58c4408227 ]

Thomas and Juliana report a deadlock when running:

(rmmod nf_conntrack_netlink/xfrm_user)

  conntrack -e NEW -E &
  modprobe -v xfrm_user

They provided following analysis:

conntrack -e NEW -E
    netlink_bind()
        netlink_lock_table() -> increases "nl_table_users"
            nfnetlink_bind()
            # does not unlock the table as it's locked by netlink_bind()
                __request_module()
                    call_usermodehelper_exec()

This triggers "modprobe nf_conntrack_netlink" from kernel, netlink_bind()
won't return until modprobe process is done.

"modprobe xfrm_user":
    xfrm_user_init()
        register_pernet_subsys()
            -> grab pernet_ops_rwsem
                ..
                netlink_table_grab()
                    calls schedule() as "nl_table_users" is non-zero

so modprobe is blocked because netlink_bind() increased
nl_table_users while also holding pernet_ops_rwsem.

"modprobe nf_conntrack_netlink" runs and inits nf_conntrack_netlink:
    ctnetlink_init()
        register_pernet_subsys()
            -> blocks on "pernet_ops_rwsem" thanks to xfrm_user module

both modprobe processes wait on one another -- neither can make
progress.

Switch netlink_bind() to "nowait" modprobe -- this releases the netlink
table lock, which then allows both modprobe instances to complete.

Reported-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Reported-by: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 92077d4591090..4abbb452cf6c6 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -578,7 +578,7 @@ static int nfnetlink_bind(struct net *net, int group)
 	ss = nfnetlink_get_subsys(type << 8);
 	rcu_read_unlock();
 	if (!ss)
-		request_module("nfnetlink-subsys-%d", type);
+		request_module_nowait("nfnetlink-subsys-%d", type);
 	return 0;
 }
 #endif
-- 
2.20.1

