Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A1FAC282CE
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 19:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D790E218FF
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 19:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555962348;
	bh=szBkXxqiqCEEnOvkzWxbI2WmligjzE5ZDcccd/LXTqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=KV+SI0AEymNPoOjgTls51fHFBxSgs1DCw6lMWJFvlYNVJtImGpX0/OH30bxHzJmdl
	 qoi9QXSTNMinfJaZDbfZ0A6+O2p8GxSueQV9qC02YyOoVdQSCnIM5bfYZV8Zyyc8RS
	 aqp3AAQVZLS4KfNCugVTBNNAUPt3sjNzOEPKWEXw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbfDVTps (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 15:45:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729831AbfDVTpm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 15:45:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3D6A218B0;
        Mon, 22 Apr 2019 19:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555962341;
        bh=szBkXxqiqCEEnOvkzWxbI2WmligjzE5ZDcccd/LXTqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aELPiK+Zm0fFUVwyjxFclWUMXZv4grKe1maZfPN5JFN0O649/6BJroYC4NE3y3X7D
         1iyWN4gJiyOLao9BiYY19mGoD1Axt8QbISgW0+vsFiZF6rO7om9Hwl0wpwVCdgcK+h
         /7Y+jaBntHlw0huehfYIiyHIgDu7wn4+0Wz1NPeM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/68] netfilter: ip6t_srh: fix NULL pointer dereferences
Date:   Mon, 22 Apr 2019 15:44:21 -0400
Message-Id: <20190422194516.11634-13-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190422194516.11634-1-sashal@kernel.org>
References: <20190422194516.11634-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit 6d65561f3d5ec933151939c543d006b79044e7a6 ]

skb_header_pointer may return NULL. The current code dereference
its return values without a NULL check.

The fix inserts the checks to avoid NULL pointer dereferences.

Fixes: 202a8ff545cc ("netfilter: add IPv6 segment routing header 'srh' match")
Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 net/ipv6/netfilter/ip6t_srh.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv6/netfilter/ip6t_srh.c b/net/ipv6/netfilter/ip6t_srh.c
index 1059894a6f4c..4cb83fb69844 100644
--- a/net/ipv6/netfilter/ip6t_srh.c
+++ b/net/ipv6/netfilter/ip6t_srh.c
@@ -210,6 +210,8 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		psidoff = srhoff + sizeof(struct ipv6_sr_hdr) +
 			  ((srh->segments_left + 1) * sizeof(struct in6_addr));
 		psid = skb_header_pointer(skb, psidoff, sizeof(_psid), &_psid);
+		if (!psid)
+			return false;
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_PSID,
 				ipv6_masked_addr_cmp(psid, &srhinfo->psid_msk,
 						     &srhinfo->psid_addr)))
@@ -223,6 +225,8 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		nsidoff = srhoff + sizeof(struct ipv6_sr_hdr) +
 			  ((srh->segments_left - 1) * sizeof(struct in6_addr));
 		nsid = skb_header_pointer(skb, nsidoff, sizeof(_nsid), &_nsid);
+		if (!nsid)
+			return false;
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_NSID,
 				ipv6_masked_addr_cmp(nsid, &srhinfo->nsid_msk,
 						     &srhinfo->nsid_addr)))
@@ -233,6 +237,8 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	if (srhinfo->mt_flags & IP6T_SRH_LSID) {
 		lsidoff = srhoff + sizeof(struct ipv6_sr_hdr);
 		lsid = skb_header_pointer(skb, lsidoff, sizeof(_lsid), &_lsid);
+		if (!lsid)
+			return false;
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LSID,
 				ipv6_masked_addr_cmp(lsid, &srhinfo->lsid_msk,
 						     &srhinfo->lsid_addr)))
-- 
2.19.1

