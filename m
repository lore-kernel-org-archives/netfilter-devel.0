From: Markus Koetter <koetter@rrzn.uni-hannover.de>
Subject: [PATCH 2/5] netlink: delinarize chain policy
Date: Wed, 17 Jun 2015 22:07:34 +0200
Message-ID: <1434571657-20047-3-git-send-email-koetter@rrzn.uni-hannover.de>
References: <1434571657-20047-1-git-send-email-koetter@rrzn.uni-hannover.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.uni-hannover.de ([130.75.2.114]:38457 "EHLO
	mailout2.uni-hannover.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbbFQUO2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jun 2015 16:14:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by mailout2.uni-hannover.de (Postfix) with ESMTP id 74EF3609F
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2015 22:04:01 +0200 (CEST)
Received: from mailout2.uni-hannover.de ([127.0.0.1])
	by localhost (mailout2.uni-hannover.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zyUKdXP4m-Df for <netfilter-devel@vger.kernel.org>;
	Wed, 17 Jun 2015 22:04:01 +0200 (CEST)
Received: from hass1404.example.prv (p4FDA71FA.dip0.t-ipconnect.de [79.218.113.250])
	(Authenticated sender: koetter@rrzn.uni-hannover.de)
	by mailout2.uni-hannover.de (Postfix) with ESMTPSA id 42C94608A
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2015 22:04:01 +0200 (CEST)
In-Reply-To: <1434571657-20047-1-git-send-email-koetter@rrzn.uni-hannover.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 include/rule.h | 1 +
 src/netlink.c  | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index fbd327b..40cb98a 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -119,6 +119,7 @@ struct chain {
 	const char		*type;
 	struct scope		scope;
 	struct list_head	rules;
+	uint32_t		policy;
 };
 
 extern const char *chain_type_name_lookup(const char *name);
diff --git a/src/netlink.c b/src/netlink.c
index 84d9d27..17aabd4 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -675,6 +675,10 @@ static struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 		chain->flags        |= CHAIN_F_BASECHAIN;
 	}
 
+	if (nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_TYPE))
+		chain->policy =
+		nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_POLICY);
+
 	return chain;
 }
 
-- 
1.9.1

