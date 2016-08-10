From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/9] netfilter: nf_conntrack_sip: CSeq 0 is a valid CSeq
Date: Wed, 10 Aug 2016 21:16:40 +0200
Message-ID: <1470856605-7903-5-git-send-email-pablo@netfilter.org>
References: <1470856605-7903-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58032 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S941128AbcHJTRD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 15:17:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AC83B1F18D5
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 21:16:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9B2C3FF6F8
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 21:16:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 618B0FF2D4
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 21:16:53 +0200 (CEST)
In-Reply-To: <1470856605-7903-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Christophe Leroy <christophe.leroy@c-s.fr>

Do not drop packet when CSeq is 0 as 0 is also a valid value for CSeq.

simple_strtoul() will return 0 either when all digits are 0
or if there are no digits at all. Therefore when simple_strtoul()
returns 0 we check if first character is digit 0 or not.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_sip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 8d9db9d..7d77217 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1383,7 +1383,7 @@ static int process_sip_response(struct sk_buff *skb, unsigned int protoff,
 		return NF_DROP;
 	}
 	cseq = simple_strtoul(*dptr + matchoff, NULL, 10);
-	if (!cseq) {
+	if (!cseq && *(*dptr + matchoff) != '0') {
 		nf_ct_helper_log(skb, ct, "cannot get cseq");
 		return NF_DROP;
 	}
@@ -1446,7 +1446,7 @@ static int process_sip_request(struct sk_buff *skb, unsigned int protoff,
 			return NF_DROP;
 		}
 		cseq = simple_strtoul(*dptr + matchoff, NULL, 10);
-		if (!cseq) {
+		if (!cseq && *(*dptr + matchoff) != '0') {
 			nf_ct_helper_log(skb, ct, "cannot get cseq");
 			return NF_DROP;
 		}
-- 
2.1.4

