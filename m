Return-Path: <SRS0=2e0L=2R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CFAC2D0C6
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 17:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB04A206CB
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 17:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577469527;
	bh=9pq68zwuBtcHgShwLeWaVi65N0QZZnhESnqWP6ebRYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Qt7ryWTLfYSYWHzwkPYffSTDhzD1n1DkzI/c06kpLj3A0wLqj2V3KsdL0pMDBNIa0
	 1uxB+h5kNrCKNB0Wrrqhr3aMis4ydkSqjywPdnx6QM7lJL1pUGEAT1bIP/1U/mjaXK
	 Iw8xMtxw11LI3D1mjMgurwH03qDuUkuH2YYNd+xs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfL0R6k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Dec 2019 12:58:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727387AbfL0RlS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60CD7222D9;
        Fri, 27 Dec 2019 17:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468478;
        bh=9pq68zwuBtcHgShwLeWaVi65N0QZZnhESnqWP6ebRYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+CrWXvddHiCedWYvMhpEnmhafou5OEHd+2V0FPEvOdBwdFpeXI1VVRxyXVLil0k8
         F5GjF3lt7UgV9Y9TJbUXtB9fpURz+rbF8atHx9xYhwyV4CoKdTgUmBf5B0PNJvQ20s
         zhgeD6mE8TBbYwL7a84CVwEWZ9ChaH9OJuGiY3+8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wenxu <wenxu@ucloud.cn>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 017/187] netfilter: nf_tables_offload: Check for the NETDEV_UNREGISTER event
Date:   Fri, 27 Dec 2019 12:38:05 -0500
Message-Id: <20191227174055.4923-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

[ Upstream commit d1f4c966475c6dd2545c6625022cb24e878bee11 ]

Check for the NETDEV_UNREGISTER event from the nft_offload_netdev_event
function, which is the event that actually triggers the clean up.

Fixes: 06d392cbe3db ("netfilter: nf_tables_offload: remove rules when the device unregisters")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_offload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 5f6037695dee..6f7eab502e65 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -446,6 +446,9 @@ static int nft_offload_netdev_event(struct notifier_block *this,
 	struct net *net = dev_net(dev);
 	struct nft_chain *chain;
 
+	if (event != NETDEV_UNREGISTER)
+		return NOTIFY_DONE;
+
 	mutex_lock(&net->nft.commit_mutex);
 	chain = __nft_offload_get_chain(dev);
 	if (chain)
-- 
2.20.1

