Return-Path: <SRS0=aq0Q=4C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8941FC3F68F
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 18:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 574932168B
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 18:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581704171;
	bh=qvwoSwHQR/CEYML/m4S92gmCzbWa6SrCwHV6LF4C9vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=iTEf6daLENcmHZe1AGOW4krSMTftAROwQ9XuFq6qWQPc1pAxD6YhVEJfpkztKeumu
	 l/AdY+rXBMiAakktWgn3ij2eC/SPYoifkxKXY7YDpHOigdWmZk44MJ50FrsFgrDkUo
	 +0iBOpo04as5IrbDXZJvt9u3Z+N+s3bA4WoHopdk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404771AbgBNSQK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Feb 2020 13:16:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:56750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730386AbgBNPvj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Feb 2020 10:51:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2395224676;
        Fri, 14 Feb 2020 15:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695499;
        bh=qvwoSwHQR/CEYML/m4S92gmCzbWa6SrCwHV6LF4C9vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=coIpfov5uwgDiY0Kn0NngcS436oaXG8XPRqA89jH/fVCdv9yb1c/EGmiu0Amn941e
         pBm32HGayEgtEtB9Ah/zwyqKE4p3iGMdvgMqSlK4Jd3w+Pfj0c+Lngp1j+aK4XsXBY
         ecZ3lUuNMIvrraFZgCXuk6hqI1t6KSmfZOREgGu0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Blakey <paulb@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 126/542] netfilter: flowtable: Fix hardware flush order on nf_flow_table_cleanup
Date:   Fri, 14 Feb 2020 10:41:58 -0500
Message-Id: <20200214154854.6746-126-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

[ Upstream commit 91bfaa15a379e9af24f71fb4ee08d8019b6e8ec7 ]

On netdev down event, nf_flow_table_cleanup() is called for the relevant
device and it cleans all the tables that are on that device.
If one of those tables has hardware offload flag,
nf_flow_table_iterate_cleanup flushes hardware and then runs the gc.
But the gc can queue more hardware work, which will take time to execute.

Instead first add the work, then flush it, to execute it now.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 640a46fd710d2..ec402baf16d64 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -530,9 +530,9 @@ static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
 static void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
 					  struct net_device *dev)
 {
-	nf_flow_table_offload_flush(flowtable);
 	nf_flow_table_iterate(flowtable, nf_flow_table_do_cleanup, dev);
 	flush_delayed_work(&flowtable->gc_work);
+	nf_flow_table_offload_flush(flowtable);
 }
 
 void nf_flow_table_cleanup(struct net_device *dev)
-- 
2.20.1

