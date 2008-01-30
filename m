From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/69]: ebtables: Update modules' descriptions
Date: Wed, 30 Jan 2008 21:17:07 +0100 (MET)
Message-ID: <20080130201705.29874.36769.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60646 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449AbYA3URJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:09 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ebtables: Update modules' descriptions

Update the MODULES_DESCRIPTION() tags for all Ebtables modules.

Reference to previous related commit: 3e53176b24b94f660ba61bfab5bcaf5c135bbcf2.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ddc4e00ab9447d62118a6a0506369726065d1df5
tree b5ed55dca07bd2bdb9e9a082ba05c9e1aba71c5b
parent b98625021b5c086ec97c2121eaf9f06873339d3e
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 29 Jan 2008 16:21:55 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:14 +0100

 net/bridge/netfilter/ebt_802_3.c    |    1 +
 net/bridge/netfilter/ebt_among.c    |    1 +
 net/bridge/netfilter/ebt_arp.c      |    1 +
 net/bridge/netfilter/ebt_arpreply.c |    1 +
 net/bridge/netfilter/ebt_dnat.c     |    1 +
 net/bridge/netfilter/ebt_ip.c       |    1 +
 net/bridge/netfilter/ebt_limit.c    |    1 +
 net/bridge/netfilter/ebt_log.c      |    1 +
 net/bridge/netfilter/ebt_mark.c     |    1 +
 net/bridge/netfilter/ebt_mark_m.c   |    1 +
 net/bridge/netfilter/ebt_pkttype.c  |    1 +
 net/bridge/netfilter/ebt_redirect.c |    1 +
 net/bridge/netfilter/ebt_snat.c     |    1 +
 net/bridge/netfilter/ebt_stp.c      |    1 +
 net/bridge/netfilter/ebt_ulog.c     |    3 +--
 net/bridge/netfilter/ebt_vlan.c     |    3 +--
 16 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index ac1730b..ef73592 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -70,4 +70,5 @@ static void __exit ebt_802_3_fini(void)
 
 module_init(ebt_802_3_init);
 module_exit(ebt_802_3_fini);
+MODULE_DESCRIPTION("Ebtables: DSAP/SSAP field and SNAP type matching");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 318157e..bf0d1d9 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -231,4 +231,5 @@ static void __exit ebt_among_fini(void)
 
 module_init(ebt_among_init);
 module_exit(ebt_among_fini);
+MODULE_DESCRIPTION("Ebtables: Combined MAC/IP address list matching");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index 933433e..8d6ab64 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -136,4 +136,5 @@ static void __exit ebt_arp_fini(void)
 
 module_init(ebt_arp_init);
 module_exit(ebt_arp_fini);
+MODULE_DESCRIPTION("Ebtables: ARP protocol packet match");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 7b6a8c1..9f25423 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -96,4 +96,5 @@ static void __exit ebt_arpreply_fini(void)
 
 module_init(ebt_arpreply_init);
 module_exit(ebt_arpreply_fini);
+MODULE_DESCRIPTION("Ebtables: ARP reply target");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 6ad9160..285378d 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -66,4 +66,5 @@ static void __exit ebt_dnat_fini(void)
 
 module_init(ebt_dnat_init);
 module_exit(ebt_dnat_fini);
+MODULE_DESCRIPTION("Ebtables: Destination MAC address translation");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index 82934f9..78efe9b 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -127,4 +127,5 @@ static void __exit ebt_ip_fini(void)
 
 module_init(ebt_ip_init);
 module_exit(ebt_ip_fini);
+MODULE_DESCRIPTION("Ebtables: IPv4 protocol packet match");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index 2eb5cb7..3c44bd6 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -110,4 +110,5 @@ static void __exit ebt_limit_fini(void)
 
 module_init(ebt_limit_init);
 module_exit(ebt_limit_fini);
+MODULE_DESCRIPTION("Ebtables: Rate-limit match");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index 40560d6..0b209e4 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -212,4 +212,5 @@ static void __exit ebt_log_fini(void)
 
 module_init(ebt_log_init);
 module_exit(ebt_log_fini);
+MODULE_DESCRIPTION("Ebtables: Packet logging to syslog");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 6fe93df..93ea763 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -77,4 +77,5 @@ static void __exit ebt_mark_fini(void)
 
 module_init(ebt_mark_init);
 module_exit(ebt_mark_fini);
+MODULE_DESCRIPTION("Ebtables: Packet mark modification");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index 0acab09..914c244 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -59,4 +59,5 @@ static void __exit ebt_mark_m_fini(void)
 
 module_init(ebt_mark_m_init);
 module_exit(ebt_mark_m_fini);
+MODULE_DESCRIPTION("Ebtables: Packet mark match");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index a15cf06..19a69ea 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -56,4 +56,5 @@ static void __exit ebt_pkttype_fini(void)
 
 module_init(ebt_pkttype_init);
 module_exit(ebt_pkttype_fini);
+MODULE_DESCRIPTION("Ebtables: Link layer packet type match");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index c1f9ca2..f206a27 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -71,4 +71,5 @@ static void __exit ebt_redirect_fini(void)
 
 module_init(ebt_redirect_init);
 module_exit(ebt_redirect_fini);
+MODULE_DESCRIPTION("Ebtables: Packet redirection to localhost");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 6bc263c..ed85858 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -88,4 +88,5 @@ static void __exit ebt_snat_fini(void)
 
 module_init(ebt_snat_init);
 module_exit(ebt_snat_fini);
+MODULE_DESCRIPTION("Ebtables: Source MAC address translation");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index fe323c4..c264797 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -194,4 +194,5 @@ static void __exit ebt_stp_fini(void)
 
 module_init(ebt_stp_init);
 module_exit(ebt_stp_fini);
+MODULE_DESCRIPTION("Ebtables: Spanning Tree Protocol packet match");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 2015711..748eecd 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -340,5 +340,4 @@ module_init(ebt_ulog_init);
 module_exit(ebt_ulog_fini);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
-MODULE_DESCRIPTION("ebtables userspace logging module for bridged Ethernet"
-		   " frames");
+MODULE_DESCRIPTION("Ebtables: Packet logging to netlink using ULOG");
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index 097d067..96897e2 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -31,8 +31,7 @@ static int debug;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "debug=1 is turn on debug messages");
 MODULE_AUTHOR("Nick Fedchik <nick@fedchik.org.ua>");
-MODULE_DESCRIPTION("802.1Q match module (ebtables extension), v"
-		   MODULE_VERS);
+MODULE_DESCRIPTION("Ebtables: 802.1Q VLAN tag match");
 MODULE_LICENSE("GPL");
 
 
