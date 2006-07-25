From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/06]: bridge netfilter: add deferred output hooks to
	feature-removal-schedule
Date: Tue, 25 Jul 2006 05:27:00 +0200 (MEST)
Message-ID: <20060725032700.25063.90123.sendpatchset@localhost.localdomain>
References: <20060725032653.25063.8139.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060725032653.25063.8139.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: bridge netfilter: add deferred output hooks to feature-removal-schedule

Add bridge netfilter deferred output hooks to feature-removal-schedule and
disable them by default. Until their removal they will be activated by the
physdev match when needed.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6484ca45f549ab966c21d2e1da36f3d0d14a20a2
tree 6b7cccfacd48e55cd0d713d55ba6e655187cd965
parent 9a713120692b6601fa2abf506862bc40c16459ba
author Patrick McHardy <kaber@trash.net> Tue, 25 Jul 2006 05:04:32 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 25 Jul 2006 05:04:32 +0200

 Documentation/feature-removal-schedule.txt |   16 ++++++++++++++++
 include/linux/netfilter_bridge.h           |    2 ++
 net/bridge/br_netfilter.c                  |    5 +++++
 net/netfilter/xt_physdev.c                 |   15 +++++++++++++++
 4 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 9d3a077..87851ef 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -258,3 +258,19 @@ Why:	These drivers never compiled since 
 Who:	Jean Delvare <khali@linux-fr.org>
 
 ---------------------------
+
+What:	Bridge netfilter deferred IPv4/IPv6 output hook calling
+When:	January 2007
+Why:	The deferred output hooks are a layering violation causing unusual
+	and broken behaviour on bridge devices. Examples of things they
+	break include QoS classifation using the MARK or CLASSIFY targets,
+	the IPsec policy match and connection tracking with VLANs on a
+	bridge. Their only use is to enable bridge output port filtering
+	within iptables with the physdev match, which can also be done by
+	combining iptables and ebtables using netfilter marks. Until it
+	will get removed the hook deferral is disabled by default and is
+	only enabled when needed.
+
+Who:	Patrick McHardy <kaber@trash.net>
+
+---------------------------
diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 8776402..31f02ba 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -79,6 +79,8 @@ struct bridge_skb_cb {
 		__u32 ipv4;
 	} daddr;
 };
+
+extern int brnf_deferred_hooks;
 #endif /* CONFIG_BRIDGE_NETFILTER */
 
 #endif /* __KERNEL__ */
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index cbc8a38..05b3de8 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -61,6 +61,9 @@ #else
 #define brnf_filter_vlan_tagged 1
 #endif
 
+int brnf_deferred_hooks;
+EXPORT_SYMBOL_GPL(brnf_deferred_hooks);
+
 static __be16 inline vlan_proto(const struct sk_buff *skb)
 {
 	return vlan_eth_hdr(skb)->h_vlan_encapsulated_proto;
@@ -890,6 +893,8 @@ #ifdef CONFIG_SYSCTL
 				return NF_ACCEPT;
 			else if (ip->version == 6 && !brnf_call_ip6tables)
 				return NF_ACCEPT;
+			else if (!brnf_deferred_hooks)
+				return NF_ACCEPT;
 #endif
 			if (hook == NF_IP_POST_ROUTING)
 				return NF_ACCEPT;
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 5fe4c9d..a9f4f6f 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -113,6 +113,21 @@ checkentry(const char *tablename,
 	if (!(info->bitmask & XT_PHYSDEV_OP_MASK) ||
 	    info->bitmask & ~XT_PHYSDEV_OP_MASK)
 		return 0;
+	if (brnf_deferred_hooks == 0 &&
+	    info->bitmask & XT_PHYSDEV_OP_OUT &&
+	    (!(info->bitmask & XT_PHYSDEV_OP_BRIDGED) ||
+	     info->invert & XT_PHYSDEV_OP_BRIDGED) &&
+	    hook_mask & ((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_FORWARD) |
+	                 (1 << NF_IP_POST_ROUTING))) {
+		printk(KERN_WARNING "physdev match: using --physdev-out in the "
+		       "OUTPUT, FORWARD and POSTROUTING chains for non-bridged "
+		       "traffic is deprecated and breaks other things, it will "
+		       "be removed in January 2007. See Documentation/"
+		       "feature-removal-schedule.txt for details. This doesn't "
+		       "affect you in case you're using it for purely bridged "
+		       "traffic.\n");
+		brnf_deferred_hooks = 1;
+	}
 	return 1;
 }
 
