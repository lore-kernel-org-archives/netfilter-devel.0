From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/3] netfilter: ipset: Whitespace fixes: some space before tab slipped in.
Date: Sat,  9 Apr 2011 22:03:01 +0200
Message-ID: <1302379382-32338-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1302379382-32338-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1302379382-32338-2-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:39704 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab1DIUDF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Apr 2011 16:03:05 -0400
In-Reply-To: <1302379382-32338-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
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

