From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 1/4] [NETFILTER]: ebtables: expand/remove unneeded macros
Date: Sun, 20 Jan 2008 19:30:26 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801201909160.14598@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr>
 <47934659.50303@trash.net>  <Pine.LNX.4.64.0801201407280.14598@fbirervta.pbzchgretzou.qr>
  <479349D3.6050103@trash.net>  <1200839199.2868.25.camel@localhost.localdomain>
  <47935E7A.1000908@trash.net>  <Pine.LNX.4.64.0801201815160.14598@fbirervta.pbzchgretzou.qr>
 <1200852441.2894.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43416 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbYATSa2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:30:28 -0500
In-Reply-To: <1200852441.2894.30.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 20 2008 19:07, Bart De Schuymer wrote:
>Op zo, 20-01-2008 te 18:34 +0100, schreef Jan Engelhardt:
>> "Ugh." I do not think ebtables(8) should depend on such macros.
>> iptables(8) does not do that either.
>> What good would those macros be for? It is not like the module names
>> would be changing anyway (one purpose of macros - to reduce the number
>> of places where you have to change things iff things change).
>
>We are talking about EBT_ENTRY_ITERATE and the like, right?
>I didn't see your patch, but even the kernel code uses the ITERATE
>macros more than once.
>
No, just the name macros:


(shortened)
diff --git a/include/linux/netfilter_bridge/ebt_802_3.h b/include/linux/netfilter_bridge/ebt_802_3.h
index a11b0c2..11421ca 100644
--- a/include/linux/netfilter_bridge/ebt_802_3.h
+++ b/include/linux/netfilter_bridge/ebt_802_3.h
@@ -4,8 +4,6 @@
 #define EBT_802_3_SAP 0x01
 #define EBT_802_3_TYPE 0x02
 
-#define EBT_802_3_MATCH "802_3"
-
 /*
  * If frame has DSAP/SSAP value 0xaa you must check the SNAP type
  * to discover what kind of packet we're carrying. 
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 41a7807..2e8d994 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -52,7 +52,7 @@ static int ebt_802_3_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_match filter_802_3 =
 {
-	.name		= EBT_802_3_MATCH,
+	.name		= "802_3",
 	.match		= ebt_filter_802_3,
 	.check		= ebt_802_3_check,
 	.me		= THIS_MODULE,

>> >> For the
>> >> other patches I have no objection except that the MODULE_DESCRIPTION
>> >> isn't consistent with using upper case after 'Ebtables: ', but I guess
>> >> that's nitpicking :) Anyway, thanks Jan.
>> 
>> It is consistent...
>> 
>> 18:17 ichi:~/Coding/linux_nosov > git log -p
>> 4ad299b1644579e5c9aae025bf81f6aff1cbdc77^..4ad299b1644579e5c9aae025bf81f6aff1cbdc77
>> | grep MODULE_DESC | grep ^+
>> 
>> +MODULE_DESCRIPTION("Ebtables: DSAP/SSAP field and SNAP type matching");
>> +MODULE_DESCRIPTION("Ebtables: Combined MAC/IP address list matching");
>> +MODULE_DESCRIPTION("Ebtables: ARP protocol packet match");
>> +MODULE_DESCRIPTION("Ebtables: ARP reply target");
>> +MODULE_DESCRIPTION("Ebtables: Destination MAC address translation");
>> +MODULE_DESCRIPTION("Ebtables: IPv4 protocol packet match");
>> +MODULE_DESCRIPTION("Ebtables: rate-limit match");
>> +MODULE_DESCRIPTION("Ebtables: Packet logging to syslog");
>> +MODULE_DESCRIPTION("Ebtables: packet mark modification");
>
>packet vs Packet, rate vs Packet, ... But this is not worth the
>bandwidth at all, I should just shut up :)

I need to pay more attention. I was kinda missing out on "after 
Ebtables".

Well, here you go. 

===

commit 22f2242ce892107edb3900a39a626a41c1d95ba7
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sun Jan 20 19:29:09 2008 +0100

    [NETFILTER]: Update modules' descriptions
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index 9e1ce0e..8cbdc01 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -109,5 +109,5 @@ static void __exit ebt_limit_fini(void)
 
 module_init(ebt_limit_init);
 module_exit(ebt_limit_fini);
-MODULE_DESCRIPTION("Ebtables: rate-limit match");
+MODULE_DESCRIPTION("Ebtables: Rate-limit match");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 3ce077f..36723f4 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -76,5 +76,5 @@ static void __exit ebt_mark_fini(void)
 
 module_init(ebt_mark_init);
 module_exit(ebt_mark_fini);
-MODULE_DESCRIPTION("Ebtables: packet mark modification");
+MODULE_DESCRIPTION("Ebtables: Packet mark modification");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index a47e0d6..9b0a454 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -58,5 +58,5 @@ static void __exit ebt_mark_m_fini(void)
 
 module_init(ebt_mark_m_init);
 module_exit(ebt_mark_m_fini);
-MODULE_DESCRIPTION("Ebtables: packet mark match");
+MODULE_DESCRIPTION("Ebtables: Packet mark match");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index 6d8a730..676db32 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -55,5 +55,5 @@ static void __exit ebt_pkttype_fini(void)
 
 module_init(ebt_pkttype_init);
 module_exit(ebt_pkttype_fini);
-MODULE_DESCRIPTION("Ebtables: link layer packet type match");
+MODULE_DESCRIPTION("Ebtables: Link layer packet type match");
 MODULE_LICENSE("GPL");
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 0a0a56d..01327f0 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -340,4 +340,4 @@ module_init(ebt_ulog_init);
 module_exit(ebt_ulog_fini);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
-MODULE_DESCRIPTION("Ebtables: packet logging to netlink using ULOG");
+MODULE_DESCRIPTION("Ebtables: Packet logging to netlink using ULOG");
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index d80fee8..984ea81 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -25,7 +25,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("Xtables: automatic-address SNAT");
+MODULE_DESCRIPTION("Xtables: Automatic-address SNAT");
 
 /* Lock protects masq region inside conntrack */
 static DEFINE_RWLOCK(masq_lock);
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index 22606e2..2171e78 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -29,7 +29,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("Xtables: packet \"rejection\" target for IPv4");
+MODULE_DESCRIPTION("Xtables: Packet \"rejection\" target for IPv4");
 
 /* Send RST reply */
 static void send_reset(struct sk_buff *oldskb, int hook)
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index fa24efa..d03a1a3 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -50,7 +50,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
-MODULE_DESCRIPTION("Xtables: packet logging to netlink using ULOG");
+MODULE_DESCRIPTION("Xtables: Packet logging to netlink using ULOG");
 MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_NFLOG);
 
 #define ULOG_NL_EVENT		111		/* Harald's favorite number */
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index 49587a4..e84402c 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -21,7 +21,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_DESCRIPTION("Xtables: address type match for IPv4");
+MODULE_DESCRIPTION("Xtables: Address type match for IPv4");
 
 static inline bool match_type(const struct net_device *dev, __be32 addr,
 			      u_int16_t mask)
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index b23baa6..b4b77df 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -31,7 +31,7 @@
 #include <linux/netfilter_ipv6/ip6t_REJECT.h>
 
 MODULE_AUTHOR("Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>");
-MODULE_DESCRIPTION("Xtables: packet \"rejection\" target for IPv6");
+MODULE_DESCRIPTION("Xtables: Packet \"rejection\" target for IPv6");
 MODULE_LICENSE("GPL");
 
 /* Send RST reply */
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index 5fecfb4..aa4491c 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -26,7 +26,7 @@
 #include <net/checksum.h>
 
 MODULE_AUTHOR("Henrik Nordstrom <hno@marasystems.com>");
-MODULE_DESCRIPTION("Xtables: connection mark modification");
+MODULE_DESCRIPTION("Xtables: Connection mark modification");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_CONNMARK");
 MODULE_ALIAS("ip6t_CONNMARK");
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 1faa913..045a9ed 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -26,7 +26,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("James Morris <jmorris@redhat.com>");
-MODULE_DESCRIPTION("Xtables: target for copying between connection and security mark");
+MODULE_DESCRIPTION("Xtables: Target for copying between connection and security mark");
 MODULE_ALIAS("ipt_CONNSECMARK");
 MODULE_ALIAS("ip6t_CONNSECMARK");
 
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index f9ce20b..5cac532 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -20,7 +20,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-MODULE_DESCRIPTION("Xtables: packet mark modification");
+MODULE_DESCRIPTION("Xtables: Packet mark modification");
 MODULE_ALIAS("ipt_MARK");
 MODULE_ALIAS("ip6t_MARK");
 
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index 19ae8ef..00d4911 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -15,7 +15,7 @@
 #include <net/netfilter/nf_log.h>
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_DESCRIPTION("Xtables: packet logging to netlink using NFLOG");
+MODULE_DESCRIPTION("Xtables: Packet logging to netlink using NFLOG");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_NFLOG");
 MODULE_ALIAS("ip6t_NFLOG");
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index beb24d1..c3da3d2 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -17,7 +17,7 @@
 #include <linux/netfilter/xt_NFQUEUE.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("Xtables: packet forwarding to netlink");
+MODULE_DESCRIPTION("Xtables: Packet forwarding to netlink");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_NFQUEUE");
 MODULE_ALIAS("ip6t_NFQUEUE");
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index c5ba525..b6ca699 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -197,7 +197,7 @@ static void __exit xt_rateest_tg_fini(void)
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Xtables: packet rate estimator");
+MODULE_DESCRIPTION("Xtables: Packet rate estimator");
 MODULE_ALIAS("ipt_RATEEST");
 MODULE_ALIAS("ip6t_RATEEST");
 module_init(xt_rateest_tg_init);
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index b11b3ec..e3abc75 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -20,7 +20,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("James Morris <jmorris@redhat.com>");
-MODULE_DESCRIPTION("Xtables: packet security mark modification");
+MODULE_DESCRIPTION("Xtables: Packet security mark modification");
 MODULE_ALIAS("ipt_SECMARK");
 MODULE_ALIAS("ip6t_SECMARK");
 
diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_TRACE.c
index 30dab79..336a55e 100644
--- a/net/netfilter/xt_TRACE.c
+++ b/net/netfilter/xt_TRACE.c
@@ -5,7 +5,7 @@
 
 #include <linux/netfilter/x_tables.h>
 
-MODULE_DESCRIPTION("Xtables: packet flow tracing");
+MODULE_DESCRIPTION("Xtables: Packet flow tracing");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_TRACE");
 MODULE_ALIAS("ip6t_TRACE");
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index aaa1b96..dcb315b 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -28,7 +28,7 @@
 #include <linux/netfilter/xt_connmark.h>
 
 MODULE_AUTHOR("Henrik Nordstrom <hno@marasystems.com>");
-MODULE_DESCRIPTION("Xtables: connection mark match");
+MODULE_DESCRIPTION("Xtables: Connection mark match");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_connmark");
 MODULE_ALIAS("ip6t_connmark");
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 851cba6..51670b1 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -20,7 +20,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-MODULE_DESCRIPTION("Xtables: connection tracking state match");
+MODULE_DESCRIPTION("Xtables: Connection tracking state match");
 MODULE_ALIAS("ipt_conntrack");
 MODULE_ALIAS("ip6t_conntrack");
 
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index d479ca9..9dd1073 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -35,7 +35,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("Xtables: per hash-bucket rate-limit match");
+MODULE_DESCRIPTION("Xtables: Per-hashbucket rate-limit match");
 MODULE_ALIAS("ipt_hashlimit");
 MODULE_ALIAS("ip6t_hashlimit");
 
diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index dbea0e0..6ca90e0 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -177,4 +177,4 @@ module_init(iprange_mt_init);
 module_exit(iprange_mt_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, Jan Engelhardt <jengelh@computergmbh.de>");
-MODULE_DESCRIPTION("Xtables: arbitrary IPv4 range matching");
+MODULE_DESCRIPTION("Xtables: Arbitrary IPv4 range matching");
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index aad9ab8..4f2987f 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -16,7 +16,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Herve Eychenne <rv@wallfire.org>");
-MODULE_DESCRIPTION("Xtables: rate-limit match");
+MODULE_DESCRIPTION("Xtables: Rate-limit match");
 MODULE_ALIAS("ipt_limit");
 MODULE_ALIAS("ip6t_limit");
 
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 9f78f61..746079a 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -18,7 +18,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-MODULE_DESCRIPTION("Xtables: packet mark match");
+MODULE_DESCRIPTION("Xtables: Packet mark match");
 MODULE_ALIAS("ipt_mark");
 MODULE_ALIAS("ip6t_mark");
 
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index 31daa81..b4ba955 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -22,7 +22,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("Xtables: multiple port matching for TCP, UDP, UDP-Lite, SCTP and DCCP");
+MODULE_DESCRIPTION("Xtables: Multiple port matching for TCP, UDP, UDP-Lite, SCTP and DCCP");
 MODULE_ALIAS("ipt_multiport");
 MODULE_ALIAS("ip6t_multiport");
 
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index d382f9c..fea7eed 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -205,7 +205,7 @@ static void __exit owner_mt_exit(void)
 module_init(owner_mt_init);
 module_exit(owner_mt_exit);
 MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
-MODULE_DESCRIPTION("Xtables: socket owner matching");
+MODULE_DESCRIPTION("Xtables: Socket owner matching");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_owner");
 MODULE_ALIAS("ip6t_owner");
diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index 7936f7e..7f3adfe 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -18,7 +18,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michal Ludvig <michal@logix.cz>");
-MODULE_DESCRIPTION("Xtables: link layer packet type match");
+MODULE_DESCRIPTION("Xtables: Link layer packet type match");
 MODULE_ALIAS("ipt_pkttype");
 MODULE_ALIAS("ip6t_pkttype");
 
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index 3b021d0..333ce9c 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -11,7 +11,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sam Johnston <samj@samj.net>");
-MODULE_DESCRIPTION("Xtables: countdown quota match");
+MODULE_DESCRIPTION("Xtables: Countdown quota match");
 MODULE_ALIAS("ipt_quota");
 MODULE_ALIAS("ip6t_quota");
 
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index 4313308..5db4334 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -18,7 +18,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_DESCRIPTION("Xtables: statistics-based matching (\"Nth\", random)");
+MODULE_DESCRIPTION("Xtables: Statistics-based matching (\"Nth\", random)");
 MODULE_ALIAS("ipt_statistic");
 MODULE_ALIAS("ip6t_statistic");
 
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 72f694d..aaff1bf 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -16,7 +16,7 @@
 #include <linux/textsearch.h>
 
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@eurodev.net>");
-MODULE_DESCRIPTION("Xtables: string-based matching");
+MODULE_DESCRIPTION("Xtables: String-based matching");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_string");
 MODULE_ALIAS("ip6t_string");
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index e9a8794..fcba9bc 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -264,7 +264,7 @@ static void __exit time_mt_exit(void)
 module_init(time_mt_init);
 module_exit(time_mt_exit);
 MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
-MODULE_DESCRIPTION("Xtables: time-based matching");
+MODULE_DESCRIPTION("Xtables: Time-based matching");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_time");
 MODULE_ALIAS("ip6t_time");
diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 9b8ed39..6acf9e0 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -130,7 +130,7 @@ static void __exit u32_mt_exit(void)
 module_init(u32_mt_init);
 module_exit(u32_mt_exit);
 MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
-MODULE_DESCRIPTION("Xtables: arbitrary byte matching");
+MODULE_DESCRIPTION("Xtables: Arbitrary byte matching");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_u32");
 MODULE_ALIAS("ip6t_u32");
