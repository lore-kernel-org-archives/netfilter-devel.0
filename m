Return-Path: <SRS0=SqQQ=RB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B629FC43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 00:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B87B2184D
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 00:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551140479;
	bh=X51vj5EVI/oOsso7M7I8E5Rl0eYPknjI1XH43zy0SpY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=ovwfN/eiHtepwpmYTAg+XCE359Zg5w8PNH5livpw0u1Dg0nRoSFVTkjLahGuQoBKv
	 iBIc+WBFyJFf/bplPlV4S8bN6NQ4DmrvJCZwSWBrzkIwC5uj8VjE/AGCwB9ZcHoTto
	 mSuxKwM45G3lyYoqz1ircttny1onpANMiigrqEq4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbfBZAVR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 19:21:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:54578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727551AbfBZAVQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 19:21:16 -0500
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32F852184D;
        Tue, 26 Feb 2019 00:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551140475;
        bh=X51vj5EVI/oOsso7M7I8E5Rl0eYPknjI1XH43zy0SpY=;
        h=From:To:Cc:Subject:Date:From;
        b=u4bWwPILiOgBFeOd6d02R+8G4Y8MzvYHH4WF9sn+8tEIXA3d4L7djyAGtbjjDfygf
         du7NzNv/15Pki8BJaxmk+ZXklJLB4oqUsYz6cX3yVABEW2/9E5UsfCgBdcA4RiS3uB
         xjZDJFMb/7yK7nUGok1sEb3MRB5SLUx/tTCbQlbY=
From:   David Ahern <dsahern@kernel.org>
To:     pablo@netfilter.org
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net] netfilter: bridge: Don't sabotage nf_hook calls for an l3mdev slave
Date:   Mon, 25 Feb 2019 16:21:14 -0800
Message-Id: <20190226002114.2245-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Followup to a173f066c7cf ("netfilter: bridge: Don't sabotage nf_hook
calls from an l3mdev"). Some packets (e.g., ndisc) do not have the skb
device flipped to the l3mdev (e.g., VRF) device. Update ip_sabotage_in
to not drop packets for slave devices too. Currently, neighbor
solicitation packets for 'dev -> bridge (addr) -> vrf' setups are getting
dropped. This patch enables IPv6 communications for bridges with an
address that are enslaved to a VRF.

Fixes: 73e20b761acf ("net: vrf: Add support for PREROUTING rules on vrf device")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/bridge/br_netfilter_hooks.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index c93c35bb73dd..8ab222babc98 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -831,7 +831,8 @@ static unsigned int ip_sabotage_in(void *priv,
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 
 	if (nf_bridge && !nf_bridge->in_prerouting &&
-	    !netif_is_l3_master(skb->dev)) {
+	    !netif_is_l3_master(skb->dev) &&
+	    !netif_is_l3_slave(skb->dev)) {
 		state->okfn(state->net, state->sk, skb);
 		return NF_STOLEN;
 	}
-- 
2.11.0

