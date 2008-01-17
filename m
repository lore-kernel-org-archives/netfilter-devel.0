From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 4/4] [NETFILTER]: ebtables: Update modules' descriptions
Date: Thu, 17 Jan 2008 21:11:19 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801172111060.18447@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37795 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbYAQULV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:11:21 -0500
In-Reply-To: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 4ad299b1644579e5c9aae025bf81f6aff1cbdc77
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Jan 17 20:12:15 2008 +0100

    [NETFILTER]: ebtables: Update modules' descriptions
    
    Update the MODULES_DESCRIPTION() tags for all Ebtables modules.
    
    Reference to previous related commit:
    3e53176b24b94f660ba61bfab5bcaf5c135bbcf2.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 66b9c07..089511a 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -69,4 +69,5 @@ static void __exit ebt_802_3_fini(void)
 
 module_init(ebt_802_3_init);
 module_exit(ebt_802_3_fini);
+MODULE_DESCRIPTION("Ebtables: DSAP/SSAP field and SNAP type matching");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index f67b96d..da6b3d9 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -231,4 +231,5 @@ static void __exit ebt_among_fini(void)
 
 module_init(ebt_among_init);
 module_exit(ebt_among_fini);
+MODULE_DESCRIPTION("Ebtables: Combined MAC/IP address list matching");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index 7279513..e512327 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -135,4 +135,5 @@ static void __exit ebt_arp_fini(void)
 
 module_init(ebt_arp_init);
 module_exit(ebt_arp_fini);
+MODULE_DESCRIPTION("Ebtables: ARP protocol packet match");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index a1559ca..3ce1de7 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -95,4 +95,5 @@ static void __exit ebt_arpreply_fini(void)
 
 module_init(ebt_arpreply_init);
 module_exit(ebt_arpreply_fini);
+MODULE_DESCRIPTION("Ebtables: ARP reply target");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 5df87dd..5119d92 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -65,4 +65,5 @@ static void __exit ebt_dnat_fini(void)
 
 module_init(ebt_dnat_init);
 module_exit(ebt_dnat_fini);
+MODULE_DESCRIPTION("Ebtables: Destination MAC address translation");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index 5b9134a..594353d 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -126,4 +126,5 @@ static void __exit ebt_ip_fini(void)
 
 module_init(ebt_ip_init);
 module_exit(ebt_ip_fini);
+MODULE_DESCRIPTION("Ebtables: IPv4 protocol packet match");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index beb47c3..0384d98 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -109,4 +109,5 @@ static void __exit ebt_limit_fini(void)
 
 module_init(ebt_limit_init);
 module_exit(ebt_limit_fini);
+MODULE_DESCRIPTION("Ebtables: rate-limit match");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index 3f6de4e..a7edf2e 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -211,4 +211,5 @@ static void __exit ebt_log_fini(void)
 
 module_init(ebt_log_init);
 module_exit(ebt_log_fini);
+MODULE_DESCRIPTION("Ebtables: Packet logging to syslog");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 70c8b8f..32c1b53 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -76,4 +76,5 @@ static void __exit ebt_mark_fini(void)
 
 module_init(ebt_mark_init);
 module_exit(ebt_mark_fini);
+MODULE_DESCRIPTION("Ebtables: packet mark modification");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index e2cb1e6..cd12628 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -58,4 +58,5 @@ static void __exit ebt_mark_m_fini(void)
 
 module_init(ebt_mark_m_init);
 module_exit(ebt_mark_m_fini);
+MODULE_DESCRIPTION("Ebtables: packet mark match");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index ce104df..e8f7f2c 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -55,4 +55,5 @@ static void __exit ebt_pkttype_fini(void)
 
 module_init(ebt_pkttype_init);
 module_exit(ebt_pkttype_fini);
+MODULE_DESCRIPTION("Ebtables: link layer packet type match");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 3e035a9..38a7bf8 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -70,4 +70,5 @@ static void __exit ebt_redirect_fini(void)
 
 module_init(ebt_redirect_init);
 module_exit(ebt_redirect_fini);
+MODULE_DESCRIPTION("Ebtables: Packet redirection to localhost");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 22158ab..a798dcd 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -87,4 +87,5 @@ static void __exit ebt_snat_fini(void)
 
 module_init(ebt_snat_init);
 module_exit(ebt_snat_fini);
+MODULE_DESCRIPTION("Ebtables: Source MAC address translation");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 370726c..ea23804 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -193,4 +193,5 @@ static void __exit ebt_stp_fini(void)
 
 module_init(ebt_stp_init);
 module_exit(ebt_stp_fini);
+MODULE_DESCRIPTION("Ebtables: Spanning Tree Protocol packet match");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 3a56afe..628d716 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -340,5 +340,4 @@ module_init(ebt_ulog_init);
 module_exit(ebt_ulog_fini);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
-MODULE_DESCRIPTION("ebtables userspace logging module for bridged Ethernet"
-		   " frames");
+MODULE_DESCRIPTION("Ebtables: packet logging to netlink using ULOG");
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index 6fadc52..545d97b 100644
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
 
 
