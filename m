Return-Path: <SRS0=dC0K=W7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A34A0C3A5A9
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 19:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C0562077B
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 19:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731760AbfIDThA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 15:37:00 -0400
Received: from correo.us.es ([193.147.175.20]:37892 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731010AbfIDTg5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 15:36:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 11170303D01
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Sep 2019 21:36:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05419B8011
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Sep 2019 21:36:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EEDA0B8007; Wed,  4 Sep 2019 21:36:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E9820B7FF2;
        Wed,  4 Sep 2019 21:36:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Sep 2019 21:36:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B97DD42EE38E;
        Wed,  4 Sep 2019 21:36:51 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/5] netfilter: bridge: Drops IPv6 packets if IPv6 module is not loaded
Date:   Wed,  4 Sep 2019 21:36:42 +0200
Message-Id: <20190904193646.23830-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190904193646.23830-1-pablo@netfilter.org>
References: <20190904193646.23830-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Leonardo Bras <leonardo@linux.ibm.com>

A kernel panic can happen if a host has disabled IPv6 on boot and have to
process guest packets (coming from a bridge) using it's ip6tables.

IPv6 packets need to be dropped if the IPv6 module is not loaded, and the
host ip6tables will be used.

Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/br_netfilter_hooks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index d3f9592f4ff8..af7800103e51 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -496,6 +496,10 @@ static unsigned int br_nf_pre_routing(void *priv,
 		if (!brnet->call_ip6tables &&
 		    !br_opt_get(br, BROPT_NF_CALL_IP6TABLES))
 			return NF_ACCEPT;
+		if (!ipv6_mod_enabled()) {
+			pr_warn_once("Module ipv6 is disabled, so call_ip6tables is not supported.");
+			return NF_DROP;
+		}
 
 		nf_bridge_pull_encap_header_rcsum(skb);
 		return br_nf_pre_routing_ipv6(priv, skb, state);
-- 
2.11.0

