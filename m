Return-Path: <SRS0=37vH=RQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD86C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 08:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE9AC2171F
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 08:33:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ExlJToAm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfCMIdj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 04:33:39 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37747 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbfCMIdj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 04:33:39 -0400
Received: by mail-pg1-f193.google.com with SMTP id q206so1004651pgq.4;
        Wed, 13 Mar 2019 01:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kS4MBFSnFethJLvwLfLpu7GcZAfpWw8gd0PEoBSK+jI=;
        b=ExlJToAmkyoM/aZsQB/ZouyNdbz3MuR52/2Ywpklw0JoHYiTImoKRMpH/W2Z58lWfL
         TAkKArWOyDgVHcX9S25Z6xm5frwsB+HEHe5FOf1KGBw0JT8O7SNB0Du7FWHha57Tmgx/
         qx0hFJk4Xorr7j4W6Hf4soOI8tCf03+o+9Y+mP71rFS+OAUsyYi4yKrQvOuK2kAupq/i
         9PHoinmPZgNPhl/F7eVWZrcX+8SmjxjECt1w+swff+bxcz9y1hFj/2x42UTxVYuSVHiL
         MXhcikUq627CswMV5lz49HANGVXbvKhlc/IH4ei8Ux+Xh4OlciGNu3Tq6TccnC/K4VXe
         mcVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kS4MBFSnFethJLvwLfLpu7GcZAfpWw8gd0PEoBSK+jI=;
        b=fCAbkaQ67Kx6SFozrJGN5pCpPVtiX5l8sp9UmIh+OC2C7IH4b7cnOpLz8vxqtcHqzS
         p69e9DN0n0yLFIIXIQOMzYtIH+/UcsCG7AKcTddky0VmabsN5gW9xhSo4qsFKdihERYh
         mS3uQKu0WJubowIKN7cLWW2gg1S3ja40T2LPLTGWLFfHMP+Y5Sy7dBAVF+cKT7luh7i5
         0uJTL3BIWYZJ/W8SyEg0EDz3RmEfQNY2ieg7o1+NjL6ZtCqGI2bZd41ccMOWE+IzTr4X
         9peK9YD1bRBjTNDBSsEzygZKAudxwOkn0u+kyA6p8pCj2QR1Sk/oqyO+3lGV5owymb34
         tuJg==
X-Gm-Message-State: APjAAAXBqVKNsZ4g4V5WtVk5taKszR54/t7k1pBbAuSauOwZxNm+xHr6
        FZPwnxyXgtnXhKgEXJ3WfaaEwPH1fMA=
X-Google-Smtp-Source: APXvYqzxACXqL9j6uwx6R1vBXo+34+T/YceXOuMiU07sT61dDeG9ZLbH26VU4hkUm/aRcWT3gHaLgA==
X-Received: by 2002:a62:f201:: with SMTP id m1mr42903119pfh.97.1552466017927;
        Wed, 13 Mar 2019 01:33:37 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l7sm39875990pfj.162.2019.03.13.01.33.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Mar 2019 01:33:37 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, pablo@netfilter.org,
        fw@strlen.de
Subject: [PATCH net] netfilter: bridge: set skb transport_header before entering NF_INET_PRE_ROUTING
Date:   Wed, 13 Mar 2019 16:33:29 +0800
Message-Id: <35febf82503a4126b5ba28b02a0ca6e8f37a2765.1552466009.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since Commit 21d1196a35f5 ("ipv4: set transport header earlier"),
skb->transport_header has been always set before entering INET
netfilter. This patch is to set skb->transport_header for bridge
before entering INET netfilter by bridge-nf-call-iptables.

It also fixes an issue that sctp_error() couldn't compute a right
csum due to unset skb->transport_header.

Fixes: e6d8b64b34aa ("net: sctp: fix and consolidate SCTP checksumming code")
Reported-by: Li Shuang <shuali@redhat.com>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/bridge/br_netfilter_hooks.c | 1 +
 net/bridge/br_netfilter_ipv6.c  | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index c93c35b..4d09a33 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -502,6 +502,7 @@ static unsigned int br_nf_pre_routing(void *priv,
 	nf_bridge->ipv4_daddr = ip_hdr(skb)->daddr;
 
 	skb->protocol = htons(ETH_P_IP);
+	skb->transport_header = skb->network_header + ip_hdr(skb)->ihl * 4;
 
 	NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
 		skb->dev, NULL,
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index 564710f..e88d664 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -235,6 +235,8 @@ unsigned int br_nf_pre_routing_ipv6(void *priv,
 	nf_bridge->ipv6_daddr = ipv6_hdr(skb)->daddr;
 
 	skb->protocol = htons(ETH_P_IPV6);
+	skb->transport_header = skb->network_header + sizeof(struct ipv6hdr);
+
 	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
 		skb->dev, NULL,
 		br_nf_pre_routing_finish_ipv6);
-- 
2.1.0

