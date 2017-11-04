From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH nf-next] netfilter: nf_defrag_ipv4: Add sysctl to disable per interface
Date: Fri,  3 Nov 2017 20:28:40 -0600
Message-ID: <1509762520-17873-1-git-send-email-subashab@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To: netfilter-devel@vger.kernel.org, steffen.klassert@secunet.com,
        pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56732 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751869AbdKDC2u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2017 22:28:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a sysctl nf_ipv4_defrag_skip to skip defragmentation per
interface. This is set 0 to preserve existing behavior (always
defrag per interface).

This is useful for pure ipv4 forwarding scenarios (without NAT)
in conjunction with xfrm. It appears that network stack defrags
the packets and then forwards them to xfrm which then encrypts
and then later fragments them on a different boundary compared
to the source.

An example of this usage is for fixing wifi calling on networks
where certain routers are configured to drop fragments explicitly.
Wifi calling was failing because data from rmnet interfaces was
fragmented and got reassembled and then forwarded and encrypted
and transmitted over wifi. Upon encryption, these packets were
larger than wifi MTU and hence were fragmented and sent to network.

We avoid fragmentation with this change as the original packets
themselves do not need to be fragmented after encryption since
these packets were smaller in size than the wifi MTU.

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 Documentation/networking/ip-sysctl.txt |  3 +++
 include/linux/inetdevice.h             |  2 ++
 include/uapi/linux/ip.h                |  1 +
 include/uapi/linux/sysctl.h            |  1 +
 kernel/sysctl_binary.c                 |  1 +
 net/ipv4/devinet.c                     |  2 ++
 net/ipv4/netfilter/nf_defrag_ipv4.c    | 10 ++++++++--
 7 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 77f4de5..d846607 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -1281,6 +1281,9 @@ drop_gratuitous_arp - BOOLEAN
 	(or in the case of 802.11, must not be used to prevent attacks.)
 	Default: off (0)
 
+nf_ipv4_defrag_skip - BOOLEAN
+	Skip defragmentation per interface if set.
+	Default : 0 (always defrag)
 
 tag - INTEGER
 	Allows you to write a number, which can be used as required.
diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 681dff3..638b681 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -129,6 +129,8 @@ static inline void ipv4_devconf_setall(struct in_device *in_dev)
 #define IN_DEV_ARP_ANNOUNCE(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_ANNOUNCE)
 #define IN_DEV_ARP_IGNORE(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_IGNORE)
 #define IN_DEV_ARP_NOTIFY(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_NOTIFY)
+#define IN_DEV_NF_IPV4_DEFRAG_SKIP(in_dev) \
+	IN_DEV_ORCONF((in_dev), NF_IPV4_DEFRAG_SKIP)
 
 struct in_ifaddr {
 	struct hlist_node	hash;
diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index f291569..739a4f3 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -167,6 +167,7 @@ enum
 	IPV4_DEVCONF_IGNORE_ROUTES_WITH_LINKDOWN,
 	IPV4_DEVCONF_DROP_UNICAST_IN_L2_MULTICAST,
 	IPV4_DEVCONF_DROP_GRATUITOUS_ARP,
+	IPV4_DEVCONF_NF_IPV4_DEFRAG_SKIP,
 	__IPV4_DEVCONF_MAX
 };
 
diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index e13d480..dd3f439 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -480,6 +480,7 @@ enum
 	NET_IPV4_CONF_PROMOTE_SECONDARIES=20,
 	NET_IPV4_CONF_ARP_ACCEPT=21,
 	NET_IPV4_CONF_ARP_NOTIFY=22,
+	NET_IPV4_CONF_NF_IPV4_DEFRAG_SKIP = 23,
 };
 
 /* /proc/sys/net/ipv4/netfilter */
diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 58ea8c0..8acb0c6 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -254,6 +254,7 @@ struct bin_table {
 	{ CTL_INT,	NET_IPV4_CONF_NOPOLICY,			"disable_policy" },
 	{ CTL_INT,	NET_IPV4_CONF_FORCE_IGMP_VERSION,	"force_igmp_version" },
 	{ CTL_INT,	NET_IPV4_CONF_PROMOTE_SECONDARIES,	"promote_secondaries" },
+	{ CTL_INT, NET_IPV4_CONF_NF_IPV4_DEFRAG_SKIP, "nf_ipv4_defrag_skip" },
 	{}
 };
 
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index a4573bc..2713a2f 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2280,6 +2280,8 @@ static int ipv4_doint_and_flush(struct ctl_table *ctl, int write,
 					"ignore_routes_with_linkdown"),
 		DEVINET_SYSCTL_RW_ENTRY(DROP_GRATUITOUS_ARP,
 					"drop_gratuitous_arp"),
+		DEVINET_SYSCTL_RW_ENTRY(NF_IPV4_DEFRAG_SKIP,
+					"nf_ipv4_defrag_skip"),
 
 		DEVINET_SYSCTL_FLUSHING_ENTRY(NOXFRM, "disable_xfrm"),
 		DEVINET_SYSCTL_FLUSHING_ENTRY(NOPOLICY, "disable_policy"),
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index 37fe1616..9e6f9d2 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -11,6 +11,7 @@
 #include <linux/netfilter.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/inetdevice.h>
 #include <net/netns/generic.h>
 #include <net/route.h>
 #include <net/ip.h>
@@ -81,8 +82,13 @@ static unsigned int ipv4_conntrack_defrag(void *priv,
 #endif
 	/* Gather fragments. */
 	if (ip_is_fragment(ip_hdr(skb))) {
-		enum ip_defrag_users user =
-			nf_ct_defrag_user(state->hook, skb);
+		enum ip_defrag_users user;
+
+		if (skb->dev &&
+		    IN_DEV_NF_IPV4_DEFRAG_SKIP(__in_dev_get_rcu(skb->dev)))
+			return NF_ACCEPT;
+
+		user = nf_ct_defrag_user(state->hook, skb);
 
 		if (nf_ct_ipv4_gather_frags(state->net, skb, user))
 			return NF_STOLEN;
-- 
1.9.1

