From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 3/4] [NETFILTER]: ebtables: mark matches, targets and
 watchers __read_mostly
Date: Sun, 20 Jan 2008 19:07:27 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801201907060.14598@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801172110550.18447@fbirervta.pbzchgretzou.qr>
 <47936043.2030103@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51701 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbYATSH3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:07:29 -0500
In-Reply-To: <47936043.2030103@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 20 2008 15:52, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> commit 110d4caa32e46b7dd78e6b59518e0137fc02a6e4
>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>> Date:   Thu Jan 17 20:12:15 2008 +0100
>> 
>>     [NETFILTER]: ebtables: mark matches, targets and watchers __read_mostly
>
>
> This doesn't apply without the first patch.
>

Please use this one while 1/4 is sorted out..

===

commit 18497df6a7a37ddaf7d2c604246f585c5f247958
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Jan 17 20:12:15 2008 +0100

    [NETFILTER]: ebtables: mark matches, targets and watchers __read_mostly
    
    Reference to previous related commit:
    9f15c5302de4e8b0aac7ca24c36bf26a7fe1a513.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 41a7807..1404b11 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -50,8 +50,7 @@ static int ebt_802_3_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_802_3 =
-{
+static struct ebt_match filter_802_3 __read_mostly = {
 	.name		= EBT_802_3_MATCH,
 	.match		= ebt_filter_802_3,
 	.check		= ebt_802_3_check,
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 6436d30..24c51e0 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -206,7 +206,7 @@ static int ebt_among_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_among = {
+static struct ebt_match filter_among __read_mostly = {
 	.name		= EBT_AMONG_MATCH,
 	.match		= ebt_filter_among,
 	.check		= ebt_among_check,
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index 1814139..7805e1c 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -113,8 +113,7 @@ static int ebt_arp_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_arp =
-{
+static struct ebt_match filter_arp __read_mostly = {
 	.name		= EBT_ARP_MATCH,
 	.match		= ebt_filter_arp,
 	.check		= ebt_arp_check,
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 48a80e4..d846bdb 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -73,8 +73,7 @@ static int ebt_target_reply_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_target reply_target =
-{
+static struct ebt_target reply_target __read_mostly = {
 	.name		= EBT_ARPREPLY_TARGET,
 	.target		= ebt_target_reply,
 	.check		= ebt_target_reply_check,
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 74262e9..ed25828 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -46,8 +46,7 @@ static int ebt_target_dnat_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_target dnat =
-{
+static struct ebt_target dnat __read_mostly = {
 	.name		= EBT_DNAT_TARGET,
 	.target		= ebt_target_dnat,
 	.check		= ebt_target_dnat_check,
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index 69f7f0a..223aa4b 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -105,8 +105,7 @@ static int ebt_ip_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_ip =
-{
+static struct ebt_match filter_ip __read_mostly = {
 	.name		= EBT_IP_MATCH,
 	.match		= ebt_filter_ip,
 	.check		= ebt_ip_check,
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index d48fa5c..f6c63a4 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -90,8 +90,7 @@ static int ebt_limit_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match ebt_limit_reg =
-{
+static struct ebt_match ebt_limit_reg __read_mostly = {
 	.name		= EBT_LIMIT_MATCH,
 	.match		= ebt_limit_match,
 	.check		= ebt_limit_check,
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index 3be9e98..2d57bba 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -183,7 +183,7 @@ static struct ebt_watcher log =
 	.me		= THIS_MODULE,
 };
 
-static const struct nf_logger ebt_log_logger = {
+static const struct nf_logger ebt_log_logger __read_mostly = {
 	.name 		= "ebt_log",
 	.logfn		= &ebt_log_packet,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 6cba543..ac6c6da 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -57,8 +57,7 @@ static int ebt_target_mark_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_target mark_target =
-{
+static struct ebt_target mark_target __read_mostly = {
 	.name		= EBT_MARK_TARGET,
 	.target		= ebt_target_mark,
 	.check		= ebt_target_mark_check,
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index 6b0d216..9e5413f 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -39,8 +39,7 @@ static int ebt_mark_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_mark =
-{
+static struct ebt_match filter_mark __read_mostly = {
 	.name		= EBT_MARK_MATCH,
 	.match		= ebt_filter_mark,
 	.check		= ebt_mark_check,
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index 4fffd70..6fe9885 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -36,8 +36,7 @@ static int ebt_pkttype_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_pkttype =
-{
+static struct ebt_match filter_pkttype __read_mostly = {
 	.name		= EBT_PKTTYPE_MATCH,
 	.match		= ebt_filter_pkttype,
 	.check		= ebt_pkttype_check,
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 422cb83..a9a9442 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -51,8 +51,7 @@ static int ebt_target_redirect_check(const char *tablename, unsigned int hookmas
 	return 0;
 }
 
-static struct ebt_target redirect_target =
-{
+static struct ebt_target redirect_target __read_mostly = {
 	.name		= EBT_REDIRECT_TARGET,
 	.target		= ebt_target_redirect,
 	.check		= ebt_target_redirect_check,
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 425ac92..1361c83 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -67,8 +67,7 @@ static int ebt_target_snat_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_target snat =
-{
+static struct ebt_target snat __read_mostly = {
 	.name		= EBT_SNAT_TARGET,
 	.target		= ebt_target_snat,
 	.check		= ebt_target_snat_check,
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 31b7736..3a5d166 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -172,8 +172,7 @@ static int ebt_stp_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_stp =
-{
+static struct ebt_match filter_stp __read_mostly = {
 	.name		= EBT_STP_MATCH,
 	.match		= ebt_filter_stp,
 	.check		= ebt_stp_check,
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index b73ba28..0d6f5fe 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -272,14 +272,14 @@ static int ebt_ulog_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_watcher ulog = {
+static struct ebt_watcher ulog __read_mostly = {
 	.name		= EBT_ULOG_WATCHER,
 	.watcher	= ebt_ulog,
 	.check		= ebt_ulog_check,
 	.me		= THIS_MODULE,
 };
 
-static const struct nf_logger ebt_ulog_logger = {
+static const struct nf_logger ebt_ulog_logger __read_mostly = {
 	.name		= EBT_ULOG_WATCHER,
 	.logfn		= &ebt_log_packet,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index 0ddf749..ff44129 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -169,7 +169,7 @@ ebt_check_vlan(const char *tablename,
 	return 0;
 }
 
-static struct ebt_match filter_vlan = {
+static struct ebt_match filter_vlan __read_mostly = {
 	.name		= EBT_VLAN_MATCH,
 	.match		= ebt_filter_vlan,
 	.check		= ebt_check_vlan,
