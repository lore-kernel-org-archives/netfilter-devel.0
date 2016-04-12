From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/8] netfilter: ipv6: unnecessary to check whether ip6_route_output() returns NULL
Date: Wed, 13 Apr 2016 01:02:44 +0200
Message-ID: <1460502166-20340-7-git-send-email-pablo@netfilter.org>
References: <1460502166-20340-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36539 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965778AbcDLXDH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 19:03:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CA8E5EAA9B
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:03:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B98811B30B7
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:03:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7D36B1B3065
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2016 01:03:01 +0200 (CEST)
In-Reply-To: <1460502166-20340-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

ip6_route_output() never returns NULL, so it is not appropriate to
check if the return value is NULL.

Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nf_reject_ipv6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 4709f65..a540022 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -158,7 +158,7 @@ void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
 	fl6.fl6_dport = otcph->source;
 	security_skb_classify_flow(oldskb, flowi6_to_flowi(&fl6));
 	dst = ip6_route_output(net, NULL, &fl6);
-	if (dst == NULL || dst->error) {
+	if (dst->error) {
 		dst_release(dst);
 		return;
 	}
-- 
2.1.4

