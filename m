From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH][NET] update Kconfig files for bridging firewall
Date: Sat, 23 Aug 2003 10:32:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200308231032.55831.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David S.Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

The patch below adds some comments about filtering bridged ARP traffic and
using netfilter for a bridging firewall. It also makes a menu for the
ebtables configuration, which makes it look like the IP, IPv6 and DECnet
filtering configuration.

This patch is an incremental patch, it assumes you applied the arpreply
patch I sent yesterday. It is vs the Linux kernel snapshot (bk10) from
yesterday.

cheers,
Bart

--- linux-2.6.0-test3/net/Kconfig.old	2003-08-23 10:14:48.000000000 +0200
+++ linux-2.6.0-test3/net/Kconfig	2003-08-23 10:15:52.000000000 +0200
@@ -191,9 +191,11 @@
 	  information.
 
 	  If you enable iptables support along with the bridge support then you
-	  turn your bridge into a bridging firewall.
+	  turn your bridge into a bridging IP firewall.
 	  iptables will then see the IP packets being bridged, so you need to
 	  take this into account when setting up your firewall rules.
+	  Enabling arptables support when bridging will let arptables see
+	  bridged ARP traffic in the arptables FORWARD chain.
 
 	  If you want to compile this code as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
@@ -243,6 +245,12 @@
 	  box can transparently forward the traffic to a local server,
 	  typically a caching proxy server.
 
+	  Yet another use of Netfilter is building a bridging firewall. Using
+	  a bridge with Network packet filtering enabled makes iptables "see"
+	  the bridged traffic. For filtering on the lower network and Ethernet
+	  protocols over the bridge, use ebtables (under bridge netfilter
+	  configuration).
+
 	  Various modules exist for netfilter which replace the previous
 	  masquerading (ipmasqadm), packet filtering (ipchains), transparent
 	  proxying, and portforwarding mechanisms. Please see
--- linux-2.6.0-test3/net/bridge/netfilter/Kconfig.old	2003-08-23 10:14:56.000000000 +0200
+++ linux-2.6.0-test3/net/bridge/netfilter/Kconfig	2003-08-23 10:29:55.000000000 +0200
@@ -1,9 +1,16 @@
 #
 # Bridge netfilter configuration
 #
+
+menu "Bridge: Netfilter Configuration"
+	depends on BRIDGE && NETFILTER
+
 config BRIDGE_NF_EBTABLES
-	tristate "Bridge: ebtables"
-	depends on NETFILTER && BRIDGE
+	tristate "Ethernet Bridge tables (ebtables) support"
+	help
+	  ebtables is a general, extensible frame/packet identification
+	  framework. Say 'Y' or 'M' here if you want to do Ethernet
+	  filtering/NAT/brouting on the Ethernet bridge.
 #
 # tables
 #
@@ -172,3 +179,5 @@
 
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
+endmenu
