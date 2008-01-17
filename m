From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 3/4] [NETFILTER]: ebtables: mark matches, targets and watchers
 __read_mostly
Date: Thu, 17 Jan 2008 21:11:05 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801172110550.18447@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37793 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbYAQULH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:11:07 -0500
In-Reply-To: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 110d4caa32e46b7dd78e6b59518e0137fc02a6e4
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Jan 17 20:12:15 2008 +0100

    [NETFILTER]: ebtables: mark matches, targets and watchers __read_mostly
    
    Reference to previous related commit:
    9f15c5302de4e8b0aac7ca24c36bf26a7fe1a513.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 2311ce0..66b9c07 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -50,8 +50,7 @@ static int ebt_802_3_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_802_3 =
-{
+static struct ebt_match filter_802_3 __read_mostly = {
 	.name		= "802_3",
 	.match		= ebt_filter_802_3,
 	.check		= ebt_802_3_check,
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 56502e6..f67b96d 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -212,7 +212,7 @@ static int ebt_among_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_among = {
+static struct ebt_match filter_among __read_mostly = {
 	.name		= "among",
 	.match		= ebt_filter_among,
 	.check		= ebt_among_check,
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index 2260626..7279513 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -116,8 +116,7 @@ static int ebt_arp_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_arp =
-{
+static struct ebt_match filter_arp __read_mostly = {
 	.name		= "arp",
 	.match		= ebt_filter_arp,
 	.check		= ebt_arp_check,
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 10f9811..a1559ca 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -76,8 +76,7 @@ static int ebt_target_reply_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_target reply_target =
-{
+static struct ebt_target reply_target __read_mostly = {
 	.name		= "arpreply",
 	.target		= ebt_target_reply,
 	.check		= ebt_target_reply_check,
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 7696fb6..5df87dd 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -46,8 +46,7 @@ static int ebt_target_dnat_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_target dnat =
-{
+static struct ebt_target dnat __read_mostly = {
 	.name		= "dnat",
 	.target		= ebt_target_dnat,
 	.check		= ebt_target_dnat_check,
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index 4470a63..5b9134a 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -107,8 +107,7 @@ static int ebt_ip_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_ip =
-{
+static struct ebt_match filter_ip __read_mostly = {
 	.name		= "ip",
 	.match		= ebt_filter_ip,
 	.check		= ebt_ip_check,
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index d90062d..beb47c3 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -90,8 +90,7 @@ static int ebt_limit_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match ebt_limit_reg =
-{
+static struct ebt_match ebt_limit_reg __read_mostly = {
 	.name		= "limit",
 	.match		= ebt_limit_match,
 	.check		= ebt_limit_check,
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index f4659f9..3f6de4e 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -179,15 +179,14 @@ static void ebt_log(const struct sk_buff *skb, unsigned int hooknr,
 			       info->prefix);
 }
 
-static struct ebt_watcher log =
-{
+static struct ebt_watcher log __read_mostly = {
 	.name		= "log",
 	.watcher	= ebt_log,
 	.check		= ebt_log_check,
 	.me		= THIS_MODULE,
 };
 
-static const struct nf_logger ebt_log_logger = {
+static const struct nf_logger ebt_log_logger __read_mostly = {
 	.name 		= "ebt_log",
 	.logfn		= &ebt_log_packet,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 64a816c..70c8b8f 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -57,8 +57,7 @@ static int ebt_target_mark_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_target mark_target =
-{
+static struct ebt_target mark_target __read_mostly = {
 	.name		= "mark",
 	.target		= ebt_target_mark,
 	.check		= ebt_target_mark_check,
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index 5b86f4f..e2cb1e6 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -39,8 +39,7 @@ static int ebt_mark_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_mark =
-{
+static struct ebt_match filter_mark __read_mostly = {
 	.name		= "mark_m",
 	.match		= ebt_filter_mark,
 	.check		= ebt_mark_check,
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index 3f4f03a..ce104df 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -36,8 +36,7 @@ static int ebt_pkttype_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_pkttype =
-{
+static struct ebt_match filter_pkttype __read_mostly = {
 	.name		= "pkttype",
 	.match		= ebt_filter_pkttype,
 	.check		= ebt_pkttype_check,
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index e08f7fd..3e035a9 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -51,8 +51,7 @@ static int ebt_target_redirect_check(const char *tablename, unsigned int hookmas
 	return 0;
 }
 
-static struct ebt_target redirect_target =
-{
+static struct ebt_target redirect_target __read_mostly = {
 	.name		= "redirect",
 	.target		= ebt_target_redirect,
 	.check		= ebt_target_redirect_check,
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index f393525..22158ab 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -68,8 +68,7 @@ static int ebt_target_snat_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_target snat =
-{
+static struct ebt_target snat __read_mostly = {
 	.name		= "snat",
 	.target		= ebt_target_snat,
 	.check		= ebt_target_snat_check,
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 56be580..370726c 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -174,8 +174,7 @@ static int ebt_stp_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_stp =
-{
+static struct ebt_match filter_stp __read_mostly = {
 	.name		= "stp",
 	.match		= ebt_filter_stp,
 	.check		= ebt_stp_check,
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index d053522..3a56afe 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -272,14 +272,14 @@ static int ebt_ulog_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_watcher ulog = {
+static struct ebt_watcher ulog __read_mostly = {
 	.name		= "ulog",
 	.watcher	= ebt_ulog,
 	.check		= ebt_ulog_check,
 	.me		= THIS_MODULE,
 };
 
-static const struct nf_logger ebt_ulog_logger = {
+static const struct nf_logger ebt_ulog_logger __read_mostly = {
 	.name		= "ulog",
 	.logfn		= &ebt_log_packet,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index ecb4f3d..6fadc52 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -170,7 +170,7 @@ ebt_check_vlan(const char *tablename,
 	return 0;
 }
 
-static struct ebt_match filter_vlan = {
+static struct ebt_match filter_vlan __read_mostly = {
 	.name		= "vlan",
 	.match		= ebt_filter_vlan,
 	.check		= ebt_check_vlan,
