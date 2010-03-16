From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/10] netfilter: xt_CT: par->family is an nfproto
Date: Tue, 16 Mar 2010 02:32:05 +0100
Message-ID: <1268703135-2622-2-git-send-email-jengelh@medozas.de>
References: <1268703135-2622-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49793 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937346Ab0CPBc0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:32:26 -0400
In-Reply-To: <1268703135-2622-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
1.7.0.2

