Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433DBC7EE31
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 19:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjE1TPU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 15:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjE1TPT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 15:15:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95ACC4;
        Sun, 28 May 2023 12:15:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 779A96158B;
        Sun, 28 May 2023 19:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970C7C433EF;
        Sun, 28 May 2023 19:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1685301317;
        bh=ZrgvYMZ7dUYviZ/NCUj5O0qXO6Zjsj3iW0k25R5z5Bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OVWp8KcM/c87rGKntGxO2FTF1b0C/b/8dHJMaiDNk1L7y2v4C9U2w/Z47PnfmnV/f
         FwxxZ8gA0G8hUJ+OibpJAD1wldS0d5XLfI3iF4AqT+5xcOnprydnSOwals1Sekdzip
         zD1ao5hPlkzshekhzJwO1UK/nOzWFFWSIeibvIeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.14 68/86] netfilter: nf_tables: do not allow RULE_ID to refer to another chain
Date:   Sun, 28 May 2023 20:10:42 +0100
Message-Id: <20230528190831.159343774@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.564682883@linuxfoundation.org>
References: <20230528190828.564682883@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ 36d5b2913219ac853908b0f1c664345e04313856 ]

When doing lookups for rules on the same batch by using its ID, a rule from
a different chain can be used. If a rule is added to a chain but tries to
be positioned next to a rule from a different chain, it will be linked to
chain2, but the use counter on chain1 would be the one to be incremented.

When looking for rules by ID, use the chain that was used for the lookup by
name. The chain used in the context copied to the transaction needs to
match that same chain. That way, struct nft_rule does not need to get
enlarged with another member.

Fixes: 1a94e38d254b ("netfilter: nf_tables: add NFTA_RULE_ID attribute")
Fixes: 75dd48e2e420 ("netfilter: nf_tables: Support RULE_ID reference in new rule")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2475,6 +2475,7 @@ err1:
 }
 
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
+					     const struct nft_chain *chain,
 					     const struct nlattr *nla)
 {
 	u32 id = ntohl(nla_get_be32(nla));
@@ -2484,6 +2485,7 @@ static struct nft_rule *nft_rule_lookup_
 		struct nft_rule *rule = nft_trans_rule(trans);
 
 		if (trans->msg_type == NFT_MSG_NEWRULE &&
+		    trans->ctx.chain == chain &&
 		    id == nft_trans_rule_id(trans))
 			return rule;
 	}
@@ -2530,7 +2532,7 @@ static int nf_tables_delrule(struct net
 
 			err = nft_delrule(&ctx, rule);
 		} else if (nla[NFTA_RULE_ID]) {
-			rule = nft_rule_lookup_byid(net, nla[NFTA_RULE_ID]);
+			rule = nft_rule_lookup_byid(net, chain, nla[NFTA_RULE_ID]);
 			if (IS_ERR(rule))
 				return PTR_ERR(rule);
 


