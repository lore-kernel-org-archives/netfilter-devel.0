Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A627C00319
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2859720838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfCBShw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:37:52 -0500
Received: from mail.us.es ([193.147.175.20]:36394 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727313AbfCBShd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:37:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2DF371361B7
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:37:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E805DA867
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:37:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 14278DA85E; Sat,  2 Mar 2019 19:37:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34B2ADA844;
        Sat,  2 Mar 2019 19:37:29 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:37:29 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A86184265A2F;
        Sat,  2 Mar 2019 19:37:28 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 23/29] netfilter: bridge: Don't sabotage nf_hook calls for an l3mdev slave
Date:   Sat,  2 Mar 2019 19:37:14 +0100
Message-Id: <20190302183720.3220-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183720.3220-1-pablo@netfilter.org>
References: <20190302183720.3220-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/br_netfilter_hooks.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 40d058378b52..9d34de68571b 100644
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


