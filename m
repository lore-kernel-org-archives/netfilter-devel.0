Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF976C001B0
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 11:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbjHJLXk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 07:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbjHJLXj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 07:23:39 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9088268A
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 04:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5vd/PUErkm7zyamcb3Rr/kzuL/THySBbt4MOXcC/1YE=; b=C3zVI47lT2V/8+VP4dqEiDNFbm
        8cy//ZXpm2rcvnh6m5L/CwyBTtK1ohbZmL0kD5fu9RNIpgsu1CyILGkrx31y/UaGGVOvUwBt0xtga
        7/FSgcLo1z4sg721sY6AM1IjrpMIeZ3x6bK1PXxkoo/3kHD+bs01I+dGcU5guvutlhSu2kMj47AXv
        OnKB0baA/Ydj267J+GMJ1x4ayzsaJt0UIfiWSEFXoKuUFXjEVvNJH+4IiTgACs6qTIeQJeYVYuRgO
        ctc0eDcfJyU8cojog6NrjHcJjnnC5kzEmurklc0CicfAD8CWas3TyuOGWTWAxzqE7SsmPFk6k0PET
        kWHyPryg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qU3lN-0004Nq-RG
        for netfilter-devel@vger.kernel.org; Thu, 10 Aug 2023 13:23:34 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 1/3] nft: Create builtin chains with counters enabled
Date:   Thu, 10 Aug 2023 13:23:23 +0200
Message-Id: <20230810112325.20630-2-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230810112325.20630-1-phil@nwl.cc>
References: <20230810112325.20630-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The kernel enables policy counters for nftables chains only if
NFTA_CHAIN_COUNTERS attribute is present. For this to be generated, one
has to set NFTNL_CHAIN_PACKETS and NFTNL_CHAIN_BYTES attributes in the
allocated nftnl_chain object.

The above happened for base chains only with iptables-nft-restore if
called with --counters flag. Since this is very unintuitive to users,
fix the situation by adding counters to base chains in any case.

Fixes: 384958620abab ("use nf_tables and nf_tables compatibility interface")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 326dc20b21d65..97fd4f49fdb4c 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -701,6 +701,9 @@ nft_chain_builtin_alloc(int family, const char *tname,
 
 	nftnl_chain_set_str(c, NFTNL_CHAIN_TYPE, chain->type);
 
+	nftnl_chain_set_u64(c, NFTNL_CHAIN_PACKETS, 0);
+	nftnl_chain_set_u64(c, NFTNL_CHAIN_BYTES, 0);
+
 	return c;
 }
 
@@ -961,6 +964,7 @@ static struct nftnl_chain *nft_chain_new(struct nft_handle *h,
 				       int policy,
 				       const struct xt_counters *counters)
 {
+	static const struct xt_counters zero = {};
 	struct nftnl_chain *c;
 	const struct builtin_table *_t;
 	const struct builtin_chain *_c;
@@ -985,12 +989,10 @@ static struct nftnl_chain *nft_chain_new(struct nft_handle *h,
 		return NULL;
 	}
 
-	if (counters) {
-		nftnl_chain_set_u64(c, NFTNL_CHAIN_BYTES,
-					counters->bcnt);
-		nftnl_chain_set_u64(c, NFTNL_CHAIN_PACKETS,
-					counters->pcnt);
-	}
+	if (!counters)
+		counters = &zero;
+	nftnl_chain_set_u64(c, NFTNL_CHAIN_BYTES, counters->bcnt);
+	nftnl_chain_set_u64(c, NFTNL_CHAIN_PACKETS, counters->pcnt);
 
 	return c;
 }
-- 
2.40.0

