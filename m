From: Gregory Vander Schueren <gregory.vanderschueren@tessares.net>
Subject: [PATCH] inet: don't call skb_orphan if tproxy happens in layer 2
Date: Thu, 15 Feb 2018 18:25:45 +0100
Message-ID: <1518715545-2188-1-git-send-email-gregory.vanderschueren@tessares.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Cc: gregory.detal@tessares.net,
        Gregory Vander Schueren <gregory.vanderschueren@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:54550 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1427232AbeBOR0S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Feb 2018 12:26:18 -0500
Received: by mail-wm0-f65.google.com with SMTP id z81so2229192wmb.4
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Feb 2018 09:26:17 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If sysctl bridge-nf-call-iptables is enabled, iptables chains are already
traversed from the bridging code. In such case, tproxy already happened when
reaching ip_rcv. Thus no need to call skb_orphan as this would actually undo
tproxy.

Fixes: 71f9dacd2e4d (inet: Call skb_orphan before tproxy activates)
Signed-off-by: Gregory Vander Schueren <gregory.vanderschueren@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---

Hi,

We noticed issues when using tproxy with net.bridge.bridge-nf-call-iptables
enabled. In such case, ip_rcv() basically undo tproxy's job. The following
patch proposes a fix.

Feedback would be most welcome,
Gregory

 include/linux/netfilter_bridge.h | 12 ++++++++++++
 net/ipv4/ip_input.c              |  9 +++++++--
 net/ipv6/ip6_input.c             |  9 +++++++--
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index b671fdf..b1c48f5 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -66,12 +66,24 @@ static inline bool nf_bridge_in_prerouting(const struct sk_buff *skb)
 {
 	return skb->nf_bridge && skb->nf_bridge->in_prerouting;
 }
+
+static inline bool
+nf_bridge_has_called_iptables(const struct sk_buff *skb)
+{
+	return skb->nf_bridge != NULL;
+}
 #else
 #define br_drop_fake_rtable(skb)	        do { } while (0)
 static inline bool nf_bridge_in_prerouting(const struct sk_buff *skb)
 {
 	return false;
 }
+
+static inline bool
+nf_bridge_has_called_iptables(const struct sk_buff *skb)
+{
+	return false;
+}
 #endif /* CONFIG_BRIDGE_NETFILTER */
 
 #endif
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 57fc13c..2450205 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -143,6 +143,7 @@
 #include <net/checksum.h>
 #include <net/inet_ecn.h>
 #include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_bridge.h>
 #include <net/xfrm.h>
 #include <linux/mroute.h>
 #include <linux/netlink.h>
@@ -487,8 +488,12 @@ int ip_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt,
 	memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
 	IPCB(skb)->iif = skb->skb_iif;
 
-	/* Must drop socket now because of tproxy. */
-	skb_orphan(skb);
+	/* If nf_bridge calls iptables then tproxy already happened.
+	 * No need to call skb_orphan as this would undo tproxy.
+	 */
+	if (!nf_bridge_has_called_iptables(skb))
+		/* Must drop socket now because of tproxy. */
+		skb_orphan(skb);
 
 	return NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING,
 		       net, NULL, skb, dev, NULL,
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 9ee208a..60ce4735 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -32,6 +32,7 @@
 
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv6.h>
+#include <linux/netfilter_bridge.h>
 
 #include <net/sock.h>
 #include <net/snmp.h>
@@ -202,8 +203,12 @@ int ipv6_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt
 
 	rcu_read_unlock();
 
-	/* Must drop socket now because of tproxy. */
-	skb_orphan(skb);
+	/* If nf_bridge calls iptables then tproxy already happened.
+	 * No need to call skb_orphan as this would undo tproxy.
+	 */
+	if (!nf_bridge_has_called_iptables(skb))
+		/* Must drop socket now because of tproxy. */
+		skb_orphan(skb);
 
 	return NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING,
 		       net, NULL, skb, dev, NULL,
-- 
2.7.4


-- 

------------------------------
DISCLAIMER.
This email and any files transmitted with it are confidential and intended 
solely for the use of the individual or entity to whom they are addressed. 
If you have received this email in error please notify the system manager. 
This message contains confidential information and is intended only for the 
individual named. If you are not the named addressee you should not 
disseminate, distribute or copy this e-mail. Please notify the sender 
immediately by e-mail if you have received this e-mail by mistake and 
delete this e-mail from your system. If you are not the intended recipient 
you are notified that disclosing, copying, distributing or taking any 
action in reliance on the contents of this information is strictly 
prohibited.
