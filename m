From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/12] netfilter: xt_checksum: ignore gso skbs
Date: Tue, 11 Sep 2018 02:20:35 +0200
Message-ID: <20180911002044.9100-4-pablo@netfilter.org>
References: <20180911002044.9100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180911002044.9100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Satish Patel reports a skb_warn_bad_offload() splat caused
by -j CHECKSUM rules:

-A POSTROUTING -p tcp -m tcp --sport 80 -j CHECKSUM

The CHECKSUM target has never worked with GSO skbs, and the above rule
makes no sense as kernel will handle checksum updates on transmit.

Unfortunately, there are 3rd party tools that install such rules, so we
cannot reject this from the config plane without potential breakage.

Amend Kconfig text to clarify that the CHECKSUM target is only useful
in virtualized environments, where old dhcp clients that use AF_PACKET
used to discard UDP packets with a 'bad' header checksum and add a
one-time warning in case such rule isn't restricted to UDP.

v2: check IP6T_F_PROTO flag before cmp (Michal Kubecek)

Reported-by: Satish Patel <satish.txt@gmail.com>
Reported-by: Markos Chandras <markos.chandras@suse.com>
Reported-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig       | 12 ++++++------
 net/netfilter/xt_CHECKSUM.c | 22 +++++++++++++++++++++-
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 71709c104081..f61c306de1d0 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -771,13 +771,13 @@ config NETFILTER_XT_TARGET_CHECKSUM
 	depends on NETFILTER_ADVANCED
 	---help---
 	  This option adds a `CHECKSUM' target, which can be used in the iptables mangle
-	  table.
+	  table to work around buggy DHCP clients in virtualized environments.
 
-	  You can use this target to compute and fill in the checksum in
-	  a packet that lacks a checksum.  This is particularly useful,
-	  if you need to work around old applications such as dhcp clients,
-	  that do not work well with checksum offloads, but don't want to disable
-	  checksum offload in your device.
+	  Some old DHCP clients drop packets because they are not aware
+	  that the checksum would normally be offloaded to hardware and
+	  thus should be considered valid.
+	  This target can be used to fill in the checksum using iptables
+	  when such packets are sent via a virtual network device.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
diff --git a/net/netfilter/xt_CHECKSUM.c b/net/netfilter/xt_CHECKSUM.c
index 9f4151ec3e06..6c7aa6a0a0d2 100644
--- a/net/netfilter/xt_CHECKSUM.c
+++ b/net/netfilter/xt_CHECKSUM.c
@@ -16,6 +16,9 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_CHECKSUM.h>
 
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michael S. Tsirkin <mst@redhat.com>");
 MODULE_DESCRIPTION("Xtables: checksum modification");
@@ -25,7 +28,7 @@ MODULE_ALIAS("ip6t_CHECKSUM");
 static unsigned int
 checksum_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	if (skb->ip_summed == CHECKSUM_PARTIAL)
+	if (skb->ip_summed == CHECKSUM_PARTIAL && !skb_is_gso(skb))
 		skb_checksum_help(skb);
 
 	return XT_CONTINUE;
@@ -34,6 +37,8 @@ checksum_tg(struct sk_buff *skb, const struct xt_action_param *par)
 static int checksum_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_CHECKSUM_info *einfo = par->targinfo;
+	const struct ip6t_ip6 *i6 = par->entryinfo;
+	const struct ipt_ip *i4 = par->entryinfo;
 
 	if (einfo->operation & ~XT_CHECKSUM_OP_FILL) {
 		pr_info_ratelimited("unsupported CHECKSUM operation %x\n",
@@ -43,6 +48,21 @@ static int checksum_tg_check(const struct xt_tgchk_param *par)
 	if (!einfo->operation)
 		return -EINVAL;
 
+	switch (par->family) {
+	case NFPROTO_IPV4:
+		if (i4->proto == IPPROTO_UDP &&
+		    (i4->invflags & XT_INV_PROTO) == 0)
+			return 0;
+		break;
+	case NFPROTO_IPV6:
+		if ((i6->flags & IP6T_F_PROTO) &&
+		    i6->proto == IPPROTO_UDP &&
+		    (i6->invflags & XT_INV_PROTO) == 0)
+			return 0;
+		break;
+	}
+
+	pr_warn_once("CHECKSUM should be avoided.  If really needed, restrict with \"-p udp\" and only use in OUTPUT\n");
 	return 0;
 }
 
-- 
2.11.0
