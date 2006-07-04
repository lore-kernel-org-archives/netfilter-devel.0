From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Tue, 04 Jul 2006 11:27:50 +0200
Message-ID: <44AA3496.5050909@trash.net>
References: <44AA3446.6050609@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050106020006080900060900"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <44AA3446.6050609@trash.net>
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
--------------050106020006080900060900
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Finally got to taking care of the first part of getting
> rid of the defered bridge hooks. Bart, does this look
> correct to you? This stuff confuses me badly :) Thanks.
> 
> ------------------------------------------------------------------------
> 
> [NETFILTER]: SCTP conntrack: fix crash triggered by packet without chunks

D'oh, wrong patch.



--------------050106020006080900060900
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 43ab119..cfbf892 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -248,3 +248,21 @@ Why:	The interface no longer has any cal
 Who:	Nick Piggin <npiggin@suse.de>
 
 ---------------------------
+
+What:	Bridge netfilter defered IPv4/IPv6 output hook calling
+When:	January 2007
+Why:	The defered output hooks are a bad layering violation causing
+	lots of unusual and broken behaviour on bridge devices.
+	Examples include broken QoS classifation using the MARK or
+	CLASSIFY targets, broken behaviour with the IPsec policy match,
+	broken connection tracking with VLAN on a bridge, ...
+
+	Their only use is to enable bridge output port filtering within
+	iptables with the physdev match, which can just as well be done by
+	combining iptables and ebtables using netfilter marks. Until they
+	will be removed the deferal will be deactivated by default and
+	needs to be manually enabled by users requiring this behavious
+	through /proc/sys/bridge/bridge-nf-defer-{iptables,ip6tables}.
+Who:	Patrick McHardy <kaber@trash.net>
+
+---------------------------
diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index a75b84b..7f27bfd 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -46,6 +46,7 @@ #define BRNF_BRIDGED_DNAT		0x02
 #define BRNF_DONT_TAKE_PARENT		0x04
 #define BRNF_BRIDGED			0x08
 #define BRNF_NF_BRIDGE_PREROUTING	0x10
+#define BRNF_DEFERED_HOOK		0x20
 
 
 /* Only used in br_forward.c */
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 98338ed..8f54428 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -763,6 +763,8 @@ enum {
 	NET_BRIDGE_NF_CALL_IPTABLES = 2,
 	NET_BRIDGE_NF_CALL_IP6TABLES = 3,
 	NET_BRIDGE_NF_FILTER_VLAN_TAGGED = 4,
+	NET_BRIDGE_NF_DEFER_IPTABLES = 5,
+	NET_BRIDGE_NF_DEFER_IP6TABLES = 6,
 };
 
 /* CTL_PROC names: */
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 3da9264..3068e90 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -55,6 +55,8 @@ #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *brnf_sysctl_header;
 static int brnf_call_iptables = 1;
 static int brnf_call_ip6tables = 1;
+static int brnf_defer_iptables = 0;
+static int brnf_defer_ip6tables = 0;
 static int brnf_call_arptables = 1;
 static int brnf_filter_vlan_tagged = 1;
 #else
@@ -729,7 +731,9 @@ #endif
 		NF_HOOK(PF_BRIDGE, NF_BR_FORWARD, skb, realindev,
 			skb->dev, br_forward_finish);
 		goto out;
-	}
+	} else if (!(nf_bridge->mask & BRNF_DEFERED_HOOK))
+		return NF_ACCEPT;
+
 	realoutdev = bridge_parent(skb->dev);
 	if (!realoutdev)
 		return NF_DROP;
@@ -885,6 +889,7 @@ #if defined(CONFIG_VLAN_8021Q) || define
 #endif
 	    ) {
 		struct nf_bridge_info *nf_bridge;
+		struct iphdr *ip;
 
 		if (!skb->nf_bridge) {
 #ifdef CONFIG_SYSCTL
@@ -892,7 +897,7 @@ #ifdef CONFIG_SYSCTL
 			   the version should be 4 or 6. We can't use
 			   skb->protocol because that isn't set on
 			   PF_INET(6)/LOCAL_OUT. */
-			struct iphdr *ip = skb->nh.iph;
+			ip = skb->nh.iph;
 
 			if (ip->version == 4 && !brnf_call_iptables)
 				return NF_ACCEPT;
@@ -921,7 +926,11 @@ #if defined(CONFIG_VLAN_8021Q) || define
 		if (out->priv_flags & IFF_802_1Q_VLAN)
 			nf_bridge->netoutdev = (struct net_device *)out;
 #endif
-		return NF_STOP;
+		if ((ip->version == 4 && brnf_defer_iptables) ||
+		    (ip->version == 6 && brnf_defer_ip6tables)) {
+			nf_bridge->mask |= BRNF_DEFERED_HOOK;
+			return NF_STOP;
+		}
 	}
 
 	return NF_ACCEPT;
@@ -1051,6 +1060,22 @@ static ctl_table brnf_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &brnf_sysctl_call_tables,
 	},
+	{
+		.ctl_name	= NET_BRIDGE_NF_DEFER_IPTABLES,
+		.procname	= "bridge-nf-defer-iptables",
+		.data		= &brnf_defer_iptables,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &brnf_sysctl_call_tables,
+	},
+	{
+		.ctl_name	= NET_BRIDGE_NF_DEFER_IP6TABLES,
+		.procname	= "bridge-nf-defer-ip6tables",
+		.data		= &brnf_defer_ip6tables,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &brnf_sysctl_call_tables,
+	},
 	{ .ctl_name = 0 }
 };
 

--------------050106020006080900060900--
