From: Jan Engelhardt <jengelh@medozas.de>
Subject: Synchronize invert flag order with manpages
Date: Sun, 10 Aug 2008 17:07:16 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808101706410.18701@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37478 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbYHJVHS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Aug 2008 17:07:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit aaafc7a89fd686583a1791a4f5f88c13864c7a14
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Aug 10 16:50:38 2008 -0400

Synchronize invert flag order with manpages
    
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_ah.c         |    4 ++--
 extensions/libip6t_dst.c        |    2 +-
 extensions/libip6t_frag.c       |    4 ++--
 extensions/libip6t_hbh.c        |    2 +-
 extensions/libip6t_hl.c         |    2 +-
 extensions/libip6t_icmp6.c      |    2 +-
 extensions/libip6t_ipv6header.c |    2 +-
 extensions/libip6t_mh.c         |    2 +-
 extensions/libip6t_rt.c         |    6 +++---
 extensions/libipt_ah.c          |    2 +-
 extensions/libipt_icmp.c        |    2 +-
 extensions/libipt_realm.c       |    2 +-
 extensions/libxt_dccp.c         |    4 ++--
 extensions/libxt_esp.c          |    2 +-
 extensions/libxt_mac.c          |    2 +-
 extensions/libxt_multiport.c    |    6 +++---
 extensions/libxt_physdev.c      |    4 ++--
 extensions/libxt_sctp.c         |    6 +++---
 extensions/libxt_tcp.c          |    8 ++++----
 extensions/libxt_udp.c          |    4 ++--
 ip6tables.c                     |   10 +++++-----
 iptables.c                      |   12 ++++++------
 22 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index ce2d7fc..5483e30 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -13,8 +13,8 @@ static void ah_help(void)
 {
 	printf(
 "ah match options:\n"
-" --ahspi [!] spi[:spi]         match spi (range)\n"
-" --ahlen [!] length            total length of this header\n"
+"[!] --ahspi spi[:spi]          match spi (range)\n"
+"[!] --ahlen length             total length of this header\n"
 " --ahres                       check the reserved filed, too\n");
 }
 
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index d3c54dd..8882b11 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -16,7 +16,7 @@ static void dst_help(void)
 {
 	printf(
 "dst match options:\n"
-"  --dst-len [!] length          total length of this header\n"
+"[!] --dst-len length            total length of this header\n"
 "  --dst-opts TYPE[:LEN][,TYPE[:LEN]...]\n"
 "                                Options and its length (list, max: %d)\n",
 IP6T_OPTS_OPTSNR);
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 64e110d..1dd48ba 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -13,8 +13,8 @@ static void frag_help(void)
 {
 	printf(
 "frag match options:\n"
-" --fragid [!] id[:id]          match the id (range)\n"
-" --fraglen [!] length          total length of this header\n"
+"[!] --fragid id[:id]           match the id (range)\n"
+"[!] --fraglen length           total length of this header\n"
 " --fragres                     check the reserved filed, too\n"
 " --fragfirst                   matches on the first fragment\n"
 " [--fragmore|--fraglast]       there are more fragments or this\n"
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index e12fe4e..6492f9f 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -19,7 +19,7 @@ static void hbh_help(void)
 {
 	printf(
 "hbh match options:\n"
-"  --hbh-len [!] length          total length of this header\n"
+"[!] --hbh-len length            total length of this header\n"
 "  --hbh-opts TYPE[:LEN][,TYPE[:LEN]...] \n"
 "                                Options and its length (list, max: %d)\n",
 IP6T_OPTS_OPTSNR);
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 2af9a20..b895e36 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -19,7 +19,7 @@ static void hl_help(void)
 {
 	printf(
 "hl match options:\n"
-"  --hl-eq [!] value	Match hop limit value\n"
+"[!] --hl-eq value	Match hop limit value\n"
 "  --hl-lt value	Match HL < value\n"
 "  --hl-gt value	Match HL > value\n");
 }
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index caecc4f..c29fe61 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -78,7 +78,7 @@ static void icmp6_help(void)
 {
 	printf(
 "icmpv6 match options:\n"
-" --icmpv6-type [!] typename	match icmpv6 type\n"
+"[!] --icmpv6-type typename	match icmpv6 type\n"
 "				(or numeric type or type/code)\n");
 	print_icmpv6types();
 }
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 5597872..547f966 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -138,7 +138,7 @@ static void ipv6header_help(void)
 {
 	printf(
 "ipv6header match options:\n"
-"--header [!] headers     Type of header to match, by name\n"
+"[!] --header headers     Type of header to match, by name\n"
 "                         names: hop,dst,route,frag,auth,esp,none,proto\n"
 "                    long names: hop-by-hop,ipv6-opts,ipv6-route,\n"
 "                                ipv6-frag,ah,esp,ipv6-nonxt,protocol\n"
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index a6cd562..cc7476e 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -62,7 +62,7 @@ static void mh_help(void)
 {
 	printf(
 "mh match options:\n"
-" --mh-type [!] type[:type]	match mh type\n");
+"[!] --mh-type type[:type]	match mh type\n");
 	print_types_all();
 }
 
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index b5f54ee..50c9444 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -19,9 +19,9 @@ static void rt_help(void)
 {
 	printf(
 "rt match options:\n"
-" --rt-type [!] type            match the type\n"
-" --rt-segsleft [!] num[:num]   match the Segments Left field (range)\n"
-" --rt-len [!] length           total length of this header\n"
+"[!] --rt-type type             match the type\n"
+"[!] --rt-segsleft num[:num]    match the Segments Left field (range)\n"
+"[!] --rt-len length            total length of this header\n"
 " --rt-0-res                    check the reserved filed, too (type 0)\n"
 " --rt-0-addrs ADDR[,ADDR...]   Type=0 addresses (list, max: %d)\n"
 " --rt-0-not-strict             List of Type=0 addresses not a strict list\n",
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 182b51a..386c43f 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -13,7 +13,7 @@ static void ah_help(void)
 {
 	printf(
 "ah match options:\n"
-" --ahspi [!] spi[:spi]\n"
+"[!] --ahspi spi[:spi]\n"
 "				match spi (range)\n");
 }
 
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 4361f13..f57503a 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -102,7 +102,7 @@ static void icmp_help(void)
 {
 	printf(
 "icmp match options:\n"
-" --icmp-type [!] typename	match icmp type\n"
+"[!] --icmp-type typename	match icmp type\n"
 "				(or numeric type or type/code)\n");
 	print_icmptypes();
 }
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 7fdc293..1e7f690 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -19,7 +19,7 @@ static void realm_help(void)
 {
 	printf(
 "realm match options:\n"
-" --realm [!] value[/mask]\n"
+"[!] --realm value[/mask]\n"
 "				Match realm\n");
 }
 
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index c368ba4..8aa3d06 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -36,9 +36,9 @@ static void dccp_help(void)
 {
 	printf(
 "dccp match options\n"
-" --source-port [!] port[:port]                          match source port(s)\n"
+"[!] --source-port port[:port]                          match source port(s)\n"
 " --sport ...\n"
-" --destination-port [!] port[:port]                     match destination port(s)\n"
+"[!] --destination-port port[:port]                     match destination port(s)\n"
 " --dport ...\n");
 }
 
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 82749f5..1da8245 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -13,7 +13,7 @@ static void esp_help(void)
 {
 	printf(
 "esp match options:\n"
-" --espspi [!] spi[:spi]\n"
+"[!] --espspi spi[:spi]\n"
 "				match spi (range)\n");
 }
 
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index f13d905..a842ee9 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -17,7 +17,7 @@ static void mac_help(void)
 {
 	printf(
 "mac match options:\n"
-" --mac-source [!] XX:XX:XX:XX:XX:XX\n"
+"[!] --mac-source XX:XX:XX:XX:XX:XX\n"
 "				Match source MAC address\n");
 }
 
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 413f178..3c2ece1 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -31,13 +31,13 @@ static void multiport_help_v1(void)
 {
 	printf(
 "multiport match options:\n"
-" --source-ports [!] port[,port:port,port...]\n"
+"[!] --source-ports port[,port:port,port...]\n"
 " --sports ...\n"
 "				match source port(s)\n"
-" --destination-ports [!] port[,port:port,port...]\n"
+"[!] --destination-ports port[,port:port,port...]\n"
 " --dports ...\n"
 "				match destination port(s)\n"
-" --ports [!] port[,port:port,port]\n"
+"[!] --ports port[,port:port,port]\n"
 "				match both source and destination port(s)\n");
 }
 
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index 34547c8..0577b59 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -16,8 +16,8 @@ static void physdev_help(void)
 {
 	printf(
 "physdev match options:\n"
-" --physdev-in [!] input name[+]		bridge port name ([+] for wildcard)\n"
-" --physdev-out [!] output name[+]	bridge port name ([+] for wildcard)\n"
+" [!] --physdev-in inputname[+]		bridge port name ([+] for wildcard)\n"
+" [!] --physdev-out outputname[+]	bridge port name ([+] for wildcard)\n"
 " [!] --physdev-is-in			arrived on a bridge device\n"
 " [!] --physdev-is-out			will leave on a bridge device\n"
 " [!] --physdev-is-bridged		it's a bridged packet\n");
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 653b601..8f363ff 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -57,11 +57,11 @@ static void sctp_help(void)
 {
 	printf(
 "sctp match options\n"
-" --source-port [!] port[:port]                          match source port(s)\n"
+"[!] --source-port port[:port]                          match source port(s)\n"
 " --sport ...\n"
-" --destination-port [!] port[:port]                     match destination port(s)\n"
+"[!] --destination-port port[:port]                     match destination port(s)\n"
 " --dport ...\n" 
-" --chunk-types [!] (all|any|none) (chunktype[:flags])+	match if all, any or none of\n"
+"[!] --chunk-types (all|any|none) (chunktype[:flags])+	match if all, any or none of\n"
 "						        chunktypes are present\n"
 "chunktypes - DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE ASCONF ASCONF_ACK ALL NONE\n");
 }
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 743c5a2..d780064 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -12,17 +12,17 @@ static void tcp_help(void)
 {
 	printf(
 "tcp match options:\n"
-" --tcp-flags [!] mask comp	match when TCP flags & mask == comp\n"
+"[!] --tcp-flags mask comp	match when TCP flags & mask == comp\n"
 "				(Flags: SYN ACK FIN RST URG PSH ALL NONE)\n"
 "[!] --syn			match when only SYN flag set\n"
 "				(equivalent to --tcp-flags SYN,RST,ACK,FIN SYN)\n"
-" --source-port [!] port[:port]\n"
+"[!] --source-port port[:port]\n"
 " --sport ...\n"
 "				match source port(s)\n"
-" --destination-port [!] port[:port]\n"
+"[!] --destination-port port[:port]\n"
 " --dport ...\n"
 "				match destination port(s)\n"
-" --tcp-option [!] number       match if TCP option set\n");
+"[!] --tcp-option number        match if TCP option set\n");
 }
 
 static const struct option tcp_opts[] = {
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 9c3665a..a749f13 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -12,10 +12,10 @@ static void udp_help(void)
 {
 	printf(
 "udp match options:\n"
-" --source-port [!] port[:port]\n"
+"[!] --source-port port[:port]\n"
 " --sport ...\n"
 "				match source port(s)\n"
-" --destination-port [!] port[:port]\n"
+"[!] --destination-port port[:port]\n"
 " --dport ...\n"
 "				match destination port(s)\n");
 }
diff --git a/ip6tables.c b/ip6tables.c
index 283a1c2..12298ca 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -320,12 +320,12 @@ exit_printhelp(struct ip6tables_rule_match *matches)
 "				Change chain name, (moving any references)\n"
 
 "Options:\n"
-"  --proto	-p [!] proto	protocol: by number or name, eg. `tcp'\n"
-"  --source	-s [!] address[/mask]\n"
+"[!] --proto	-p proto	protocol: by number or name, eg. `tcp'\n"
+"[!] --source	-s address[/mask]\n"
 "				source specification\n"
-"  --destination -d [!] address[/mask]\n"
+"[!] --destination -d address[/mask]\n"
 "				destination specification\n"
-"  --in-interface -i [!] input name[+]\n"
+"[!] --in-interface -i input name[+]\n"
 "				network interface name ([+] for wildcard)\n"
 "  --jump	-j target\n"
 "				target for rule (may load target extension)\n"
@@ -336,7 +336,7 @@ exit_printhelp(struct ip6tables_rule_match *matches)
 "  --match	-m match\n"
 "				extended match (may load extension)\n"
 "  --numeric	-n		numeric output of addresses and ports\n"
-"  --out-interface -o [!] output name[+]\n"
+"[!] --out-interface -o output name[+]\n"
 "				network interface name ([+] for wildcard)\n"
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
diff --git a/iptables.c b/iptables.c
index 41e1836..bc3e2cf 100644
--- a/iptables.c
+++ b/iptables.c
@@ -322,14 +322,14 @@ exit_printhelp(struct iptables_rule_match *matches)
 "				Change chain name, (moving any references)\n"
 
 "Options:\n"
-"  --proto	-p [!] proto	protocol: by number or name, eg. `tcp'\n"
-"  --source	-s [!] address[/mask]\n"
+"[!] --proto	-p proto	protocol: by number or name, eg. `tcp'\n"
+"[!] --source	-s address[/mask]\n"
 "				source specification\n"
-"  --destination -d [!] address[/mask]\n"
+"[!] --destination -d address[/mask]\n"
 "				destination specification\n"
-"  --in-interface -i [!] input name[+]\n"
+"[!] --in-interface -i input name[+]\n"
 "				network interface name ([+] for wildcard)\n"
-"  --jump	-j target\n"
+" --jump	-j target\n"
 "				target for rule (may load target extension)\n"
 #ifdef IPT_F_GOTO
 "  --goto      -g chain\n"
@@ -338,7 +338,7 @@ exit_printhelp(struct iptables_rule_match *matches)
 "  --match	-m match\n"
 "				extended match (may load extension)\n"
 "  --numeric	-n		numeric output of addresses and ports\n"
-"  --out-interface -o [!] output name[+]\n"
+"[!] --out-interface -o output name[+]\n"
 "				network interface name ([+] for wildcard)\n"
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"

