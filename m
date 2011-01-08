From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] kernel: remove unused ctnl parameter from call_ad
Date: Sat,  8 Jan 2011 04:14:38 +0100
Message-ID: <1294456479-4401-2-git-send-email-jengelh@medozas.de>
References: <1294456479-4401-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48622 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab1AHDOm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Jan 2011 22:14:42 -0500
In-Reply-To: <1294456479-4401-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 kernel/ip_set.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/ip_set.c b/kernel/ip_set.c
index 6d353d9..85e4e23 100644
--- a/kernel/ip_set.c
+++ b/kernel/ip_set.c
@@ -1315,8 +1315,7 @@ static const struct nla_policy ip_set_adt_policy[IPSET_ATTR_CMD_MAX + 1] = {
 };
 
 static int
-call_ad(struct sock *ctnl, struct sk_buff *skb,
-	const struct nlattr * const attr[],
+call_ad(struct sk_buff *skb, const struct nlattr *const attr[],
 	struct ip_set *set, const struct nlattr *nla,
 	enum ipset_adt adt, u32 flags)
 {
@@ -1372,7 +1371,7 @@ ip_set_uadd(struct sock *ctnl, struct sk_buff *skb,
 		return -EEXIST;
 
 	if (attr[IPSET_ATTR_DATA]) {
-		ret = call_ad(ctnl, skb, attr,
+		ret = call_ad(skb, attr,
 			      set, attr[IPSET_ATTR_DATA], IPSET_ADD, flags);
 	} else {
 		int nla_rem;
@@ -1381,7 +1380,7 @@ ip_set_uadd(struct sock *ctnl, struct sk_buff *skb,
 			if (nla_type(nla) != IPSET_ATTR_DATA
 			    || !flag_nested(nla))
 				return -IPSET_ERR_PROTOCOL;
-			ret = call_ad(ctnl, skb, attr,
+			ret = call_ad(skb, attr,
 				       set, nla, IPSET_ADD, flags);
 			if (ret < 0)
 				return ret;
@@ -1416,7 +1415,7 @@ ip_set_udel(struct sock *ctnl, struct sk_buff *skb,
 		return -EEXIST;
 
 	if (attr[IPSET_ATTR_DATA]) {
-		ret = call_ad(ctnl, skb, attr,
+		ret = call_ad(skb, attr,
 			      set, attr[IPSET_ATTR_DATA], IPSET_DEL, flags);
 	} else {
 		int nla_rem;
@@ -1425,7 +1424,7 @@ ip_set_udel(struct sock *ctnl, struct sk_buff *skb,
 			if (nla_type(nla) != IPSET_ATTR_DATA
 			    || !flag_nested(nla))
 				return -IPSET_ERR_PROTOCOL;
-			ret = call_ad(ctnl, skb, attr,
+			ret = call_ad(skb, attr,
 				       set, nla, IPSET_DEL, flags);
 			if (ret < 0)
 				return ret;
-- 
1.7.1

