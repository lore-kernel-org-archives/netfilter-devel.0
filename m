Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76706C388F9
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Nov 2020 11:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B36F22240
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Nov 2020 11:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbgKULL5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Nov 2020 06:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727524AbgKULL5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Nov 2020 06:11:57 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FDFC0613CF
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2020 03:11:56 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 0597F59777754; Sat, 21 Nov 2020 12:11:53 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id C7F3B59777752;
        Sat, 21 Nov 2020 12:11:51 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, jengelh@inai.de
Subject: [PATCH] netfilter: use actual socket sk for REJECT action
Date:   Sat, 21 Nov 2020 12:11:51 +0100
Message-Id: <20201121111151.15960-1-jengelh@inai.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

True to the message of commit v5.10-rc1-105-g46d6c5ae953c, _do_
actually make use of state->sk when possible, such as in the REJECT
modules.

Reported-by: Minqiang Chen <ptpt52@gmail.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
Compile-tested only.
As 46d6c5ae9 has made its way into stable, maybe this one shall too.

 include/net/netfilter/ipv4/nf_reject.h | 4 ++--
 include/net/netfilter/ipv6/nf_reject.h | 5 ++---
 net/ipv4/netfilter/ipt_REJECT.c        | 3 ++-
 net/ipv4/netfilter/nf_reject_ipv4.c    | 6 +++---
 net/ipv4/netfilter/nft_reject_ipv4.c   | 3 ++-
 net/ipv6/netfilter/ip6t_REJECT.c       | 2 +-
 net/ipv6/netfilter/nf_reject_ipv6.c    | 5 +++--
 net/ipv6/netfilter/nft_reject_ipv6.c   | 3 ++-
 net/netfilter/nft_reject_inet.c        | 6 ++++--
 9 files changed, 21 insertions(+), 16 deletions(-)

diff --git include/net/netfilter/ipv4/nf_reject.h include/net/netfilter/ipv4/nf_reject.h
index 40e0e0623f46..d8207a82d761 100644
--- include/net/netfilter/ipv4/nf_reject.h
+++ include/net/netfilter/ipv4/nf_reject.h
@@ -8,8 +8,8 @@
 #include <net/netfilter/nf_reject.h>
 
 void nf_send_unreach(struct sk_buff *skb_in, int code, int hook);
-void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook);
-
+void nf_send_reset(struct net *net, struct sock *, struct sk_buff *oldskb,
+		   int hook);
 const struct tcphdr *nf_reject_ip_tcphdr_get(struct sk_buff *oldskb,
 					     struct tcphdr *_oth, int hook);
 struct iphdr *nf_reject_iphdr_put(struct sk_buff *nskb,
diff --git include/net/netfilter/ipv6/nf_reject.h include/net/netfilter/ipv6/nf_reject.h
index 4a3ef9ebdf6f..86e87bc2c516 100644
--- include/net/netfilter/ipv6/nf_reject.h
+++ include/net/netfilter/ipv6/nf_reject.h
@@ -7,9 +7,8 @@
 
 void nf_send_unreach6(struct net *net, struct sk_buff *skb_in, unsigned char code,
 		      unsigned int hooknum);
-
-void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook);
-
+void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
+		    int hook);
 const struct tcphdr *nf_reject_ip6_tcphdr_get(struct sk_buff *oldskb,
 					      struct tcphdr *otcph,
 					      unsigned int *otcplen, int hook);
diff --git net/ipv4/netfilter/ipt_REJECT.c net/ipv4/netfilter/ipt_REJECT.c
index e16b98ee6266..4b8840734762 100644
--- net/ipv4/netfilter/ipt_REJECT.c
+++ net/ipv4/netfilter/ipt_REJECT.c
@@ -56,7 +56,8 @@ reject_tg(struct sk_buff *skb, const struct xt_action_param *par)
 		nf_send_unreach(skb, ICMP_PKT_FILTERED, hook);
 		break;
 	case IPT_TCP_RESET:
-		nf_send_reset(xt_net(par), skb, hook);
+		nf_send_reset(xt_net(par), par->state->sk, skb, hook);
+		break;
 	case IPT_ICMP_ECHOREPLY:
 		/* Doesn't happen. */
 		break;
diff --git net/ipv4/netfilter/nf_reject_ipv4.c net/ipv4/netfilter/nf_reject_ipv4.c
index 93b07739807b..efe14a6a5d9b 100644
--- net/ipv4/netfilter/nf_reject_ipv4.c
+++ net/ipv4/netfilter/nf_reject_ipv4.c
@@ -112,7 +112,8 @@ static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
 }
 
 /* Send RST reply */
-void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
+void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
+		   int hook)
 {
 	struct net_device *br_indev __maybe_unused;
 	struct sk_buff *nskb;
@@ -144,8 +145,7 @@ void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
 				   ip4_dst_hoplimit(skb_dst(nskb)));
 	nf_reject_ip_tcphdr_put(nskb, oldskb, oth);
-
-	if (ip_route_me_harder(net, nskb->sk, nskb, RTN_UNSPEC))
+	if (ip_route_me_harder(net, sk, nskb, RTN_UNSPEC))
 		goto free_nskb;
 
 	niph = ip_hdr(nskb);
diff --git net/ipv4/netfilter/nft_reject_ipv4.c net/ipv4/netfilter/nft_reject_ipv4.c
index e408f813f5d8..ff437e4ed6db 100644
--- net/ipv4/netfilter/nft_reject_ipv4.c
+++ net/ipv4/netfilter/nft_reject_ipv4.c
@@ -27,7 +27,8 @@ static void nft_reject_ipv4_eval(const struct nft_expr *expr,
 		nf_send_unreach(pkt->skb, priv->icmp_code, nft_hook(pkt));
 		break;
 	case NFT_REJECT_TCP_RST:
-		nf_send_reset(nft_net(pkt), pkt->skb, nft_hook(pkt));
+		nf_send_reset(nft_net(pkt), pkt->xt.state->sk, pkt->skb,
+			      nft_hook(pkt));
 		break;
 	default:
 		break;
diff --git net/ipv6/netfilter/ip6t_REJECT.c net/ipv6/netfilter/ip6t_REJECT.c
index 3ac5485049f0..a35019d2e480 100644
--- net/ipv6/netfilter/ip6t_REJECT.c
+++ net/ipv6/netfilter/ip6t_REJECT.c
@@ -61,7 +61,7 @@ reject_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 		/* Do nothing */
 		break;
 	case IP6T_TCP_RESET:
-		nf_send_reset6(net, skb, xt_hooknum(par));
+		nf_send_reset6(net, par->state->sk, skb, xt_hooknum(par));
 		break;
 	case IP6T_ICMP6_POLICY_FAIL:
 		nf_send_unreach6(net, skb, ICMPV6_POLICY_FAIL, xt_hooknum(par));
diff --git net/ipv6/netfilter/nf_reject_ipv6.c net/ipv6/netfilter/nf_reject_ipv6.c
index 4aef6baaa55e..8b145f2a2841 100644
--- net/ipv6/netfilter/nf_reject_ipv6.c
+++ net/ipv6/netfilter/nf_reject_ipv6.c
@@ -141,7 +141,8 @@ static int nf_reject6_fill_skb_dst(struct sk_buff *skb_in)
 	return 0;
 }
 
-void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
+void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
+		    int hook)
 {
 	struct net_device *br_indev __maybe_unused;
 	struct sk_buff *nskb;
@@ -233,7 +234,7 @@ void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
 		dev_queue_xmit(nskb);
 	} else
 #endif
-		ip6_local_out(net, nskb->sk, nskb);
+		ip6_local_out(net, sk, nskb);
 }
 EXPORT_SYMBOL_GPL(nf_send_reset6);
 
diff --git net/ipv6/netfilter/nft_reject_ipv6.c net/ipv6/netfilter/nft_reject_ipv6.c
index c1098a1968e1..7969d1f3018d 100644
--- net/ipv6/netfilter/nft_reject_ipv6.c
+++ net/ipv6/netfilter/nft_reject_ipv6.c
@@ -28,7 +28,8 @@ static void nft_reject_ipv6_eval(const struct nft_expr *expr,
 				 nft_hook(pkt));
 		break;
 	case NFT_REJECT_TCP_RST:
-		nf_send_reset6(nft_net(pkt), pkt->skb, nft_hook(pkt));
+		nf_send_reset6(nft_net(pkt), pkt->xt.state->sk, pkt->skb,
+			       nft_hook(pkt));
 		break;
 	default:
 		break;
diff --git net/netfilter/nft_reject_inet.c net/netfilter/nft_reject_inet.c
index cf8f2646e93c..36b219e2e896 100644
--- net/netfilter/nft_reject_inet.c
+++ net/netfilter/nft_reject_inet.c
@@ -28,7 +28,8 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 					nft_hook(pkt));
 			break;
 		case NFT_REJECT_TCP_RST:
-			nf_send_reset(nft_net(pkt), pkt->skb, nft_hook(pkt));
+			nf_send_reset(nft_net(pkt), pkt->xt.state->sk,
+				      pkt->skb, nft_hook(pkt));
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
 			nf_send_unreach(pkt->skb,
@@ -44,7 +45,8 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 					 priv->icmp_code, nft_hook(pkt));
 			break;
 		case NFT_REJECT_TCP_RST:
-			nf_send_reset6(nft_net(pkt), pkt->skb, nft_hook(pkt));
+			nf_send_reset6(nft_net(pkt), pkt->xt.state->sk,
+				       pkt->skb, nft_hook(pkt));
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
 			nf_send_unreach6(nft_net(pkt), pkt->skb,
-- 
2.29.2

