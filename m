From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RESEND PATCH -stable,4.3.y] netfilter: xt_TEE: fix NULL dereference
Date: Tue, 16 Feb 2016 20:41:20 +0100
Message-ID: <1455651680-11775-2-git-send-email-pablo@netfilter.org>
References: <1455651680-11775-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53407 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755806AbcBPTla (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 14:41:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BEBA3C882D
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 20:41:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A76FE91DD
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 20:41:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4779822014
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 20:41:26 +0100 (CET)
In-Reply-To: <1455651680-11775-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric Dumazet <edumazet@google.com>

[ upstream commit 45efccdbec3cd465c4776ed9ca1d7b1bba1b7e34 ]

iptables -I INPUT ... -j TEE --gateway 10.1.2.3

<crash> because --oif was not specified

tee_tg_check() sets ->priv pointer to NULL in this case.

Fixes: bbde9fc1824a ("netfilter: factor out packet duplication for IPv4/IPv6")
Cc: <stable@vger.kernel.org> # 4.3.x
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_TEE.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index fd980aa..c5fdea1 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -31,8 +31,9 @@ static unsigned int
 tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tee_tginfo *info = par->targinfo;
+	int oif = info->priv ? info->priv->oif : 0;
 
-	nf_dup_ipv4(skb, par->hooknum, &info->gw.in, info->priv->oif);
+	nf_dup_ipv4(skb, par->hooknum, &info->gw.in, oif);
 
 	return XT_CONTINUE;
 }
@@ -42,8 +43,9 @@ static unsigned int
 tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tee_tginfo *info = par->targinfo;
+	int oif = info->priv ? info->priv->oif : 0;
 
-	nf_dup_ipv6(skb, par->hooknum, &info->gw.in6, info->priv->oif);
+	nf_dup_ipv6(skb, par->hooknum, &info->gw.in6, oif);
 
 	return XT_CONTINUE;
 }
-- 
2.1.4

