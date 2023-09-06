Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282BBEE14A0
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 16:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243031AbjIFQZ6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 12:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234200AbjIFQZ5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 12:25:57 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93D6199F;
        Wed,  6 Sep 2023 09:25:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qdvLh-0007wK-G7; Wed, 06 Sep 2023 18:25:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Kyle Zeng <zengyhkyle@gmail.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: [PATCH net 5/6] netfilter: ipset: add the missing IP_SET_HASH_WITH_NET0 macro for ip_set_hash_netportnet.c
Date:   Wed,  6 Sep 2023 18:25:11 +0200
Message-ID: <20230906162525.11079-6-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230906162525.11079-1-fw@strlen.de>
References: <20230906162525.11079-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Kyle Zeng <zengyhkyle@gmail.com>

The missing IP_SET_HASH_WITH_NET0 macro in ip_set_hash_netportnet can
lead to the use of wrong `CIDR_POS(c)` for calculating array offsets,
which can lead to integer underflow. As a result, it leads to slab
out-of-bound access.
This patch adds back the IP_SET_HASH_WITH_NET0 macro to
ip_set_hash_netportnet to address the issue.

Fixes: 886503f34d63 ("netfilter: ipset: actually allow allowable CIDR 0 in hash:net,port,net")
Suggested-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Kyle Zeng <zengyhkyle@gmail.com>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_hash_netportnet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 005a7ce87217..bf4f91b78e1d 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -36,6 +36,7 @@ MODULE_ALIAS("ip_set_hash:net,port,net");
 #define IP_SET_HASH_WITH_PROTO
 #define IP_SET_HASH_WITH_NETS
 #define IPSET_NET_COUNT 2
+#define IP_SET_HASH_WITH_NET0
 
 /* IPv4 variant */
 
-- 
2.41.0

