From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] evaluate: missing break; in str2hooknum()
Date: Tue, 17 Mar 2015 17:25:32 +0100
Message-ID: <1426609532-6462-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54017 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbbCQQVt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 12:21:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index a3484c6..7ecb793 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1786,6 +1786,7 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
 			return NF_INET_POST_ROUTING;
 		else if (!strcmp(hook, "output"))
 			return NF_INET_LOCAL_OUT;
+		break;
 	case NFPROTO_ARP:
 		if (!strcmp(hook, "input"))
 			return NF_ARP_IN;
@@ -1793,6 +1794,7 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
 			return NF_ARP_FORWARD;
 		else if (!strcmp(hook, "output"))
 			return NF_ARP_OUT;
+		break;
 	default:
 		break;
 	}
-- 
1.7.10.4

