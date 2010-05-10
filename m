From: kaber@trash.net
Subject: [PATCH 05/84] netfilter: xt_CT: par->family is an nfproto
Date: Mon, 10 May 2010 22:17:36 +0200
Message-ID: <1273522735-24672-6-git-send-email-kaber@trash.net>
References: <1273522735-24672-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54506 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab0EJUS7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 May 2010 16:18:59 -0400
In-Reply-To: <1273522735-24672-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_CT.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 61c50fa..fda603e 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -37,13 +37,13 @@ static unsigned int xt_ct_target(struct sk_buff *skb,
 
 static u8 xt_ct_find_proto(const struct xt_tgchk_param *par)
 {
-	if (par->family == AF_INET) {
+	if (par->family == NFPROTO_IPV4) {
 		const struct ipt_entry *e = par->entryinfo;
 
 		if (e->ip.invflags & IPT_INV_PROTO)
 			return 0;
 		return e->ip.proto;
-	} else if (par->family == AF_INET6) {
+	} else if (par->family == NFPROTO_IPV6) {
 		const struct ip6t_entry *e = par->entryinfo;
 
 		if (e->ipv6.invflags & IP6T_INV_PROTO)
-- 
1.7.0.4

