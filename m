Return-Path: <SRS0=MWc4=UA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EF3C28CC1
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 13:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C0DB272B4
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 13:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559396260;
	bh=yVDF691FvRRmQWwU9hpWWqnPFhNxOx4wwe332Tui718=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hoLDaLiz+UFnocDNSyv6RaSE/yfqAkRouDTKlciO/hQzsTqK8srd3hTXA8++YUVyd
	 vh+netsayWYrWNturqxADO52aQVy1JGvOk7u7P5wzjh8P16oJ3N8skpe5fc0l8u4hm
	 BAtaUrDnU75TNRI3y796PKQVhB2EvC/5ppE4aMa8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbfFANhj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Jun 2019 09:37:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727779AbfFANVr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Jun 2019 09:21:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3F83272FC;
        Sat,  1 Jun 2019 13:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395306;
        bh=yVDF691FvRRmQWwU9hpWWqnPFhNxOx4wwe332Tui718=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yvz9PsWIGQOk5TibzWZqJEDrqs2dVeGXf4n2LkDS/8q1RXlzppJeX39/digbLSqI/
         yBlkZr8jCXVT8sDLMdbyUc25ccBzelc97L5eCKvIDnRgGe32L2b6S4n06JDUqQSiq9
         LSA3sB/UkELY4euY3Txr14ol/nnk2z5NyZpU8ACs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 064/173] netfilter: nf_flow_table: fix missing error check for rhashtable_insert_fast
Date:   Sat,  1 Jun 2019 09:17:36 -0400
Message-Id: <20190601131934.25053-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 43c8f131184faf20c07221f3e09724611c6525d8 ]

rhashtable_insert_fast() may return an error value when memory
allocation fails, but flow_offload_add() does not check for errors.
This patch just adds missing error checking.

Fixes: ac2a66665e23 ("netfilter: add generic flow table infrastructure")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index c0c72ae9df42f..604446c0264cc 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -185,14 +185,25 @@ static const struct rhashtable_params nf_flow_offload_rhash_params = {
 
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 {
-	flow->timeout = (u32)jiffies;
+	int err;
 
-	rhashtable_insert_fast(&flow_table->rhashtable,
-			       &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
-			       nf_flow_offload_rhash_params);
-	rhashtable_insert_fast(&flow_table->rhashtable,
-			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
-			       nf_flow_offload_rhash_params);
+	err = rhashtable_insert_fast(&flow_table->rhashtable,
+				     &flow->tuplehash[0].node,
+				     nf_flow_offload_rhash_params);
+	if (err < 0)
+		return err;
+
+	err = rhashtable_insert_fast(&flow_table->rhashtable,
+				     &flow->tuplehash[1].node,
+				     nf_flow_offload_rhash_params);
+	if (err < 0) {
+		rhashtable_remove_fast(&flow_table->rhashtable,
+				       &flow->tuplehash[0].node,
+				       nf_flow_offload_rhash_params);
+		return err;
+	}
+
+	flow->timeout = (u32)jiffies;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
-- 
2.20.1

