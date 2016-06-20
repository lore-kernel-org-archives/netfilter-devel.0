From: Liping Zhang <zlpnobody@163.com>
Subject: [PACTH nf-next] netfilter: nf_reject_ipv4: don't send tcp RST if the packet is non-TCP
Date: Mon, 20 Jun 2016 21:26:28 +0800
Message-ID: <1466429188-3942-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:39670 "EHLO m12-12.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbcFTN2Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jun 2016 09:28:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

In iptables, if the user add a rule to send tcp RST and specify the
non-TCP protocol, such as UDP, kernel will reject this request. But
in nftables, this validity check only occurs in nft tool, i.e. only
in userspace.

This means that user can add such a rule like follows via nfnetlink:
  "nft add rule filter forward ip protocol udp reject with tcp reset"

This will generate some confusing tcp RST packets. So we should send
tcp RST only when it is TCP packet.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/ipv4/netfilter/nf_reject_ipv4.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index b6ea57e..fd82202 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -24,6 +24,9 @@ const struct tcphdr *nf_reject_ip_tcphdr_get(struct sk_buff *oldskb,
 	if (ip_hdr(oldskb)->frag_off & htons(IP_OFFSET))
 		return NULL;
 
+	if (ip_hdr(oldskb)->protocol != IPPROTO_TCP)
+		return NULL;
+
 	oth = skb_header_pointer(oldskb, ip_hdrlen(oldskb),
 				 sizeof(struct tcphdr), _oth);
 	if (oth == NULL)
-- 
1.7.9.5


