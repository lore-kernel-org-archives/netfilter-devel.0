From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [-stable-3.8.y 4/9] netfilter: nf_ct_sip: don't drop packets with offsets pointing outside the packet
Date: Tue,  7 May 2013 01:05:23 +0200
Message-ID: <1367881528-15524-4-git-send-email-pablo@netfilter.org>
References: <1367881528-15524-1-git-send-email-pablo@netfilter.org>
Cc: stable@vger.kernel.org, davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52130 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759795Ab3EFXGA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 May 2013 19:06:00 -0400
In-Reply-To: <1367881528-15524-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>

Some Cisco phones create huge messages that are spread over multiple packets.
After calculating the offset of the SIP body, it is validated to be within
the packet and the packet is dropped otherwise. This breaks operation of
these phones. Since connection tracking is supposed to be passive, just let
those packets pass unmodified and untracked.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

[ This patch is a backport of 3a7b21e ]
---
 net/netfilter/nf_conntrack_sip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index df8f4f2..b4e0d1c 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1547,7 +1547,7 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
 
 		msglen = origlen = end - dptr;
 		if (msglen > datalen)
-			return NF_DROP;
+			return NF_ACCEPT;
 
 		ret = process_sip_msg(skb, ct, protoff, dataoff,
 				      &dptr, &msglen);
-- 
1.7.10.4

