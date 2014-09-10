From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 18/25] netfilter: xt_string: Remove unnecessary initialization of struct ts_state
Date: Wed, 10 Sep 2014 17:10:35 +0200
Message-ID: <1410361842-4656-19-git-send-email-pablo@netfilter.org>
References: <1410361842-4656-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55931 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbaIJPKb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:10:31 -0400
In-Reply-To: <1410361842-4656-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Bojan Prtvar <prtvar.b@gmail.com>

The skb_find_text() accepts uninitialized textsearch state variable.

Signed-off-by: Bojan Prtvar <prtvar.b@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_string.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index d3c48b1..5699adb 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -29,7 +29,6 @@ string_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	struct ts_state state;
 	bool invert;
 
-	memset(&state, 0, sizeof(struct ts_state));
 	invert = conf->u.v1.flags & XT_STRING_FLAG_INVERT;
 
 	return (skb_find_text((struct sk_buff *)skb, conf->from_offset,
-- 
1.7.10.4

