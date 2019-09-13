Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C7CC4CEC7
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 11:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D364F20693
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 11:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388196AbfIMLbb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 07:31:31 -0400
Received: from correo.us.es ([193.147.175.20]:42626 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388117AbfIMLb2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B60574FFE14
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 13:31:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A46FAA7E25
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 13:31:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A322CA7E28; Fri, 13 Sep 2019 13:31:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 908F6A7E25;
        Fri, 13 Sep 2019 13:31:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 589FE42EE395;
        Fri, 13 Sep 2019 13:31:23 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 22/27] netfilter: br_netfilter: update stub br_nf_pre_routing_ipv6 parameter to `void *priv`.
Date:   Fri, 13 Sep 2019 13:30:57 +0200
Message-Id: <20190913113102.15776-23-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

The real br_nf_pre_routing_ipv6 function, defined when CONFIG_IPV6 is
enabled, expects `void *priv`, not `const struct nf_hook_ops *ops`.
Update the stub br_nf_pre_routing_ipv6, defined when CONFIG_IPV6 is
disabled, to match.

Fixes: 06198b34a3e0 ("netfilter: Pass priv instead of nf_hook_ops to netfilter hooks")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/br_netfilter.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index 2a613c84d49f..c53909fd22cd 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -68,7 +68,7 @@ static inline int br_validate_ipv6(struct net *net, struct sk_buff *skb)
 }
 
 static inline unsigned int
-br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops, struct sk_buff *skb,
+br_nf_pre_routing_ipv6(void *priv, struct sk_buff *skb,
 		       const struct nf_hook_state *state)
 {
 	return NF_ACCEPT;
-- 
2.11.0

