Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D896CC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 May 2022 02:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238937AbiEYCcr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 May 2022 22:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235106AbiEYCcp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 May 2022 22:32:45 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D06254F9F
        for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2022 19:32:44 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1653445962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VvM8I4ZAqqilkOwCZ5czqLhUXw9LWp9edURJ9I5GvHM=;
        b=V2qpKKurXYHJtJhBscMR1518ojE8nNpCfnUbyeQ3S7BLycyWYdKxY3n/i6pfNbPb6F2PZX
        LqddWmBAgUnoUzC6TmYGgpoydTLSsT9wAgek5tQtc/+6XF+/ZlOTtQEjpPkBsGj1CnOj4J
        ywrH9wn0fVkJ6byS9VyI/5c1oLNiUtY=
From:   Jackie Liu <liu.yun@linux.dev>
To:     fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, liu.yun@linux.dev
Subject: [PATCH] netfilter: conntrack: use fallthrough to cleanup
Date:   Wed, 25 May 2022 10:32:15 +0800
Message-Id: <20220525023215.422470-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

These cases all use the same function. we can simplify the code through
fallthrough.

$ size net/netfilter/nf_conntrack_core.o

        text	   data	    bss	    dec	    hex	filename
before  81601	  81430	    768	 163799	  27fd7	net/netfilter/nf_conntrack_core.o
after   80361	  81430	    768	 162559	  27aff	net/netfilter/nf_conntrack_core.o

Arch: aarch64
Gcc : gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1)

Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 net/netfilter/nf_conntrack_core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0164e5f522e8..5ae64f4971d3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -329,20 +329,18 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 		return gre_pkt_to_tuple(skb, dataoff, net, tuple);
 #endif
 	case IPPROTO_TCP:
-	case IPPROTO_UDP: /* fallthrough */
-		return nf_ct_get_tuple_ports(skb, dataoff, tuple);
+	case IPPROTO_UDP:
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
 	case IPPROTO_UDPLITE:
-		return nf_ct_get_tuple_ports(skb, dataoff, tuple);
 #endif
 #ifdef CONFIG_NF_CT_PROTO_SCTP
 	case IPPROTO_SCTP:
-		return nf_ct_get_tuple_ports(skb, dataoff, tuple);
 #endif
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 	case IPPROTO_DCCP:
-		return nf_ct_get_tuple_ports(skb, dataoff, tuple);
 #endif
+		/* fallthrough */
+		return nf_ct_get_tuple_ports(skb, dataoff, tuple);
 	default:
 		break;
 	}
-- 
2.25.1

