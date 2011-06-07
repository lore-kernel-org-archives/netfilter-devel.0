From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 02/15] netfilter: ipset: Whitespace fixes: some space before tab slipped in.
Date: Tue,  7 Jun 2011 18:56:07 +0200
Message-ID: <1307465780-28980-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1307465780-28980-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-2-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:58830 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175Ab1FGQ4W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:56:22 -0400
In-Reply-To: <1307465780-28980-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
1.7.0.4

