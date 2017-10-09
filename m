From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/12] netfilter: SYNPROXY: skip non-tcp packet in {ipv4, ipv6}_synproxy_hook
Date: Mon,  9 Oct 2017 18:25:45 +0200
Message-ID: <1507566346-32553-12-git-send-email-pablo@netfilter.org>
References: <1507566346-32553-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1507566346-32553-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Lin Zhang <xiaolou4617@gmail.com>

In function {ipv4,ipv6}_synproxy_hook we expect a normal tcp packet, but
the real server maybe reply an icmp error packet related to the exist
tcp conntrack, so we will access wrong tcp data.

Fix it by checking for the protocol field and only process tcp traffic.

Signed-off-by: Lin Zhang <xiaolou4617@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ipt_SYNPROXY.c  | 3 ++-
 net/ipv6/netfilter/ip6t_SYNPROXY.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
index 811689e523c3..f75fc6b53115 100644
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -330,7 +330,8 @@ static unsigned int ipv4_synproxy_hook(void *priv,
 	if (synproxy == NULL)
 		return NF_ACCEPT;
 
-	if (nf_is_loopback_packet(skb))
+	if (nf_is_loopback_packet(skb) ||
+	    ip_hdr(skb)->protocol != IPPROTO_TCP)
 		return NF_ACCEPT;
 
 	thoff = ip_hdrlen(skb);
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index a5cd43d75393..437af8c95277 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -353,7 +353,7 @@ static unsigned int ipv6_synproxy_hook(void *priv,
 	nexthdr = ipv6_hdr(skb)->nexthdr;
 	thoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
 				 &frag_off);
-	if (thoff < 0)
+	if (thoff < 0 || nexthdr != IPPROTO_TCP)
 		return NF_ACCEPT;
 
 	th = skb_header_pointer(skb, thoff, sizeof(_th), &_th);
-- 
2.1.4
