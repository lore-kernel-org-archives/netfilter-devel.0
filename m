From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH] xt_AUDIT.c: remove ipv6 dependencies
Date: Sat, 21 May 2011 23:37:40 +0100
Message-ID: <4DD83EB4.5040800@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Thomas Graf <tgraf@redhat.com>, Patrick McHardy <kaber@trash.net>,
	Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:45158 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab1EUWhu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 May 2011 18:37:50 -0400
Received: by wwk4 with SMTP id 4so500551wwk.1
        for <netfilter-devel@vger.kernel.org>; Sat, 21 May 2011 15:37:49 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

All,


This patch follows the one I submitted yesterday and removes the dependencies on ipv6 allowing the AUDIT target be compiled on systems where no ipv6 is implemented or running.

Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
---
 net/netfilter/xt_AUDIT.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index e823f18..5cea31e 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -23,14 +23,18 @@
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 #include <linux/security.h>
 #endif
+#ifdef CONFIG_IPV6
 #include <net/ipv6.h>
+#endif
 #include <net/ip.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Thomas Graf <tgraf@redhat.com>");
 MODULE_DESCRIPTION("Xtables: creates audit records for dropped/accepted packets");
 MODULE_ALIAS("ipt_AUDIT");
+#ifdef CONFIG_IPV6
 MODULE_ALIAS("ip6t_AUDIT");
+#endif
 MODULE_ALIAS("ebt_AUDIT");
 MODULE_ALIAS("arpt_AUDIT");
 
@@ -55,8 +59,10 @@ static void audit_proto(struct audit_buffer *ab, struct sk_buff *skb,
 		}
 		break;
 
-	case IPPROTO_ICMP:
-	case IPPROTO_ICMPV6: {
+#ifdef CONFIG_IPV6
+	case IPPROTO_ICMPV6:
+#endif
+	case IPPROTO_ICMP: {
 		const u8 *iptr;
 		u8 _ih[2];
 
@@ -96,6 +102,7 @@ static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
 	audit_proto(ab, skb, ih->protocol, ih->ihl * 4);
 }
 
+#ifdef CONFIG_IPV6
 static void audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 {
 	struct ipv6hdr _ip6h;
@@ -120,6 +127,7 @@ static void audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 		audit_proto(ab, skb, nexthdr, offset);
 }
 
+#endif
 static unsigned int
 audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -160,10 +168,12 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 			case __constant_htons(ETH_P_IP):
 				audit_ip4(ab, skb);
 				break;
+#ifdef CONFIG_IPV6
 
 			case __constant_htons(ETH_P_IPV6):
 				audit_ip6(ab, skb);
 				break;
+#endif
 			}
 		}
 	}
@@ -172,10 +182,12 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	case NFPROTO_IPV4:
 		audit_ip4(ab, skb);
 		break;
+#ifdef CONFIG_IPV6
 
 	case NFPROTO_IPV6:
 		audit_ip6(ab, skb);
 		break;
+#endif
 	}
 
 	audit_log_end(ab);
-- 
1.7.3.4


