From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/8]: Add NetBIOS name service helper
Date: Tue, 06 Sep 2005 19:55:31 +0200
Message-ID: <431DD813.8010309@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="02.diff"
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

[NETFILTER]: Add NetBIOS name service helper

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b057eac5e17bda8e06a6f3241a837d415a18be4d
tree fd37ca39beae9fad2e0ce5a652756ebc5f9acaab
parent d6d0e225ee3dd43d2a14fbd0aaded74bc7d45da1
author Patrick McHardy <kaber@trash.net> Sun, 04 Sep 2005 17:50:41 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 04 Sep 2005 17:50:41 +0200

 net/ipv4/netfilter/Kconfig  |   19 +++++++++++++++++++
 net/ipv4/netfilter/Makefile |    1 +
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -85,6 +85,25 @@ config IP_NF_IRC
 
 	  To compile it as a module, choose M here.  If unsure, say Y.
 
+config IP_NF_NETBIOS_NS
+	tristate "NetBIOS name service protocol support (EXPERIMENTAL)"
+	depends on IP_NF_CONNTRACK && EXPERIMENTAL
+	help
+	  NetBIOS name service requests are sent as broadcast messages from an
+	  unprivileged port and responded to with unicast messages to the
+	  same port. This make them hard to firewall properly because connection
+	  tracking doesn't deal with broadcasts. This helper tracks locally
+	  originating NetBIOS name service requests and the corresponding
+	  responses. It relies on correct IP address configuration, specifically
+	  netmask and broadcast address. When properly configured, the output
+	  of "ip address show" should look similar to this:
+
+	  $ ip -4 address show eth0
+	  4: eth0: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast qlen 1000
+	      inet 172.16.2.252/24 brd 172.16.2.255 scope global eth0
+	  
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_NF_TFTP
 	tristate "TFTP protocol support"
 	depends on IP_NF_CONNTRACK
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_IP_NF_AMANDA) += ip_conntra
 obj-$(CONFIG_IP_NF_TFTP) += ip_conntrack_tftp.o
 obj-$(CONFIG_IP_NF_FTP) += ip_conntrack_ftp.o
 obj-$(CONFIG_IP_NF_IRC) += ip_conntrack_irc.o
+obj-$(CONFIG_IP_NF_NETBIOS_NS) += ip_conntrack_netbios_ns.o
 
 # NAT helpers 
 obj-$(CONFIG_IP_NF_NAT_AMANDA) += ip_nat_amanda.o
