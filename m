From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/26] netfilter: nf_reject_ipv4: don't send tcp RST if the packet is non-TCP
Date: Wed,  6 Jul 2016 16:23:53 +0200
Message-ID: <1467815048-2240-12-git-send-email-pablo@netfilter.org>
References: <1467815048-2240-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1467815048-2240-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 3 +++
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
2.1.4
