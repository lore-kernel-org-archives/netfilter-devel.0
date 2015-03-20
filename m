From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: xt_TPROXY: fix invflags check in tproxy_tg6_check()
Date: Fri, 20 Mar 2015 14:00:32 +0100
Message-ID: <1426856432-6375-1-git-send-email-pablo@netfilter.org>
Cc: balazs.scheidler@balabit.com, hidden@balabit.hu, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52427 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbbCTM4r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Mar 2015 08:56:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have to check for IP6T_INV_PROTO in invflags, instead of flags.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_TPROXY.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index ef8a926..50e1e5a 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -513,8 +513,8 @@ static int tproxy_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct ip6t_ip6 *i = par->entryinfo;
 
-	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP)
-	    && !(i->flags & IP6T_INV_PROTO))
+	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP) &&
+	    !(i->invflags & IP6T_INV_PROTO))
 		return 0;
 
 	pr_info("Can be used only in combination with "
-- 
1.7.10.4

