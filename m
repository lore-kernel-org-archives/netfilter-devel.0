From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Fri, 07 Jul 2006 05:37:57 +0200
Message-ID: <44ADD715.7060507@trash.net>
References: <W8195318669268441152182124@nocme1bl6.telenet-ops.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020405010806060907090501"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "bdschuym@pandora.be" <bdschuym@telenet.be>
In-Reply-To: <W8195318669268441152182124@nocme1bl6.telenet-ops.be>
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

This is a multi-part message in MIME format.
--------------020405010806060907090501
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

bdschuym@pandora.be wrote:
> Looks good, but please use deferred instead of defered :)

This is the latest version. Fixed the crash and added a
runtime warning to the physdev match and on-the-fly activation
when needed, so we don't need the sysctls. Works fine in
a few simple tests, if there are no further objections
I'll submit this version.


--------------020405010806060907090501
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: bridge netfilter: add deferred output hooks to feature-removal-schedule

Add deferred output hooks to feature-removal-schedule and disable them by
default. Until their removal they will be activated by the physdev match
when needed.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 47190a17ac996af8d1f1bcbc5650ff64a0ab171d
tree 52644df0d058e6174ffa37166ea69b59e62c556e
parent 120bda20c6f64b32e8bfbdd7b34feafaa5f5332e
author Patrick McHardy <kaber@trash.net> Fri, 07 Jul 2006 05:34:59 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 07 Jul 2006 05:34:59 +0200

 Documentation/feature-removal-schedule.txt |   16 ++++++++++++++++
 include/linux/netfilter_bridge.h           |    3 +++
 net/bridge/br_netfilter.c                  |   11 +++++++++--
 net/netfilter/xt_physdev.c                 |    9 +++++++++
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 99f219a..e6aa994 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -266,3 +266,19 @@ Why:	The interrupt related SA_* flags ar
 Who:	Thomas Gleixner <tglx@linutronix.de>
 
 ---------------------------
+
+What:	Bridge netfilter deferred IPv4/IPv6 output hook calling
+When:	January 2007
+Why:	The deferred output hooks are a layering violation causing lots
+	of unusual and broken behaviour on bridge devices. Examples of
+	things they break include QoS classifation using the MARK or
+	CLASSIFY targets, the IPsec policy match and connection tracking
+	with VLANs on a bridge. Their only use is to enable bridge output
+	port filtering within iptables with the physdev match, which can
+	just as well be done by combining iptables and ebtables using
+	netfilter marks. Until it will get removed the hook deferral is
+	disabled by default and is only enabled when needed.
+
+Who:	Patrick McHardy <kaber@trash.net>
+
+---------------------------
diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 8776402..8d5bd29 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -45,6 +45,7 @@ #define BRNF_BRIDGED_DNAT		0x02
 #define BRNF_DONT_TAKE_PARENT		0x04
 #define BRNF_BRIDGED			0x08
 #define BRNF_NF_BRIDGE_PREROUTING	0x10
+#define BRNF_DEFERRED_HOOK		0x20
 
 
 /* Only used in br_forward.c */
@@ -79,6 +80,8 @@ struct bridge_skb_cb {
 		__u32 ipv4;
 	} daddr;
 };
+
+extern int brnf_deferred_hooks;
 #endif /* CONFIG_BRIDGE_NETFILTER */
 
 #endif /* __KERNEL__ */
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 8298a51..dfe242f 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -61,6 +61,8 @@ #else
 #define brnf_filter_vlan_tagged 1
 #endif
 
+int brnf_deferred_hooks;
+
 static __be16 inline vlan_proto(const struct sk_buff *skb)
 {
 	return vlan_eth_hdr(skb)->h_vlan_encapsulated_proto;
@@ -721,7 +723,9 @@ #endif
 		NF_HOOK(PF_BRIDGE, NF_BR_FORWARD, skb, realindev,
 			skb->dev, br_forward_finish);
 		goto out;
-	}
+	} else if (!(nf_bridge->mask & BRNF_DEFERRED_HOOK))
+		return NF_ACCEPT;
+
 	realoutdev = bridge_parent(skb->dev);
 	if (!realoutdev)
 		return NF_DROP;
@@ -913,7 +917,10 @@ #if defined(CONFIG_VLAN_8021Q) || define
 		if (out->priv_flags & IFF_802_1Q_VLAN)
 			nf_bridge->netoutdev = (struct net_device *)out;
 #endif
-		return NF_STOP;
+		if (brnf_deferred_hooks) {
+			nf_bridge->mask |= BRNF_DEFERRED_HOOK;
+			return NF_STOP;
+		}
 	}
 
 	return NF_ACCEPT;
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 5fe4c9d..7b9dba2 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -113,6 +113,15 @@ checkentry(const char *tablename,
 	if (!(info->bitmask & XT_PHYSDEV_OP_MASK) ||
 	    info->bitmask & ~XT_PHYSDEV_OP_MASK)
 		return 0;
+	if (brnf_deferred_hooks == 0 && info->bitmask & XT_PHYSDEV_OP_OUT &&
+	    hook_mask & ((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_FORWARD))) {
+		printk(KERN_WARNING "physdev match: using --physdev-out in the "
+		       "OUTPUT or FORWARD chain is deprecated and breaks other "
+		       "things, it will be removed in January 2007. See "
+		       "Documentation/feature-removal-schedule.txt for "
+		       "details.\n");
+		brnf_deferred_hooks = 1;
+	}
 	return 1;
 }
 

--------------020405010806060907090501--
