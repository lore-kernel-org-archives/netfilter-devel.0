From: kaber@trash.net
Subject: [PATCH 07/20] netfilter: ipset: whitespace fixes: some space before tab slipped in
Date: Thu, 16 Jun 2011 21:47:07 +0200
Message-ID: <1308253640-29942-8-git-send-email-kaber@trash.net>
References: <1308253640-29942-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64144 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab1FPTrZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:47:25 -0400
In-Reply-To: <1308253640-29942-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/ipset/ip_set_list_set.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index a0290ff..c2c29da 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -310,8 +310,8 @@ list_set_uadt(struct ip_set *set, struct nlattr *tb[],
 				     !id_eq(map, i + 1, refid)) ||
 				    (before < 0 &&
 				     (i == 0 || !id_eq(map, i - 1, refid)))) {
-				     	ret = -IPSET_ERR_EXIST;
-				     	goto finish;
+					ret = -IPSET_ERR_EXIST;
+					goto finish;
 				}
 				e->timeout = ip_set_timeout_set(timeout);
 				ip_set_put_byindex(id);
-- 
1.7.2.3

