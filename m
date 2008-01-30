From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/69]: ebtables: mark matches, targets and watchers __read_mostly
Date: Wed, 30 Jan 2008 21:17:09 +0100 (MET)
Message-ID: <20080130201707.29874.50265.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60653 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766001AbYA3URK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:10 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ebtables: mark matches, targets and watchers __read_mostly

Reference to previous related commit: 9f15c5302de4e8b0aac7ca24c36bf26a7fe1a513.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 343530ff0e7ba8c4efd3ebac683f9a9b7295b73d
tree 5eb23713f2427f996cc477c40506440eeeedb256
parent ddc4e00ab9447d62118a6a0506369726065d1df5
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 29 Jan 2008 16:21:55 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:14 +0100

 net/bridge/netfilter/ebt_802_3.c    |    3 +--
 net/bridge/netfilter/ebt_among.c    |    2 +-
 net/bridge/netfilter/ebt_arp.c      |    3 +--
 net/bridge/netfilter/ebt_arpreply.c |    3 +--
 net/bridge/netfilter/ebt_dnat.c     |    3 +--
 net/bridge/netfilter/ebt_ip.c       |    3 +--
 net/bridge/netfilter/ebt_limit.c    |    3 +--
 net/bridge/netfilter/ebt_mark.c     |    3 +--
 net/bridge/netfilter/ebt_mark_m.c   |    3 +--
 net/bridge/netfilter/ebt_pkttype.c  |    3 +--
 net/bridge/netfilter/ebt_redirect.c |    3 +--
 net/bridge/netfilter/ebt_snat.c     |    3 +--
 net/bridge/netfilter/ebt_stp.c      |    3 +--
 net/bridge/netfilter/ebt_ulog.c     |    2 +-
 net/bridge/netfilter/ebt_vlan.c     |    2 +-
 15 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index ef73592..9853402 100644
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
index bf0d1d9..70b6dca 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -212,7 +212,7 @@ static int ebt_among_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_among = {
+static struct ebt_match filter_among __read_mostly = {
 	.name		= EBT_AMONG_MATCH,
 	.match		= ebt_filter_among,
 	.check		= ebt_among_check,
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index 8d6ab64..7c535be 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -116,8 +116,7 @@ static int ebt_arp_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_arp =
-{
+static struct ebt_match filter_arp __read_mostly = {
 	.name		= EBT_ARP_MATCH,
 	.match		= ebt_filter_arp,
 	.check		= ebt_arp_check,
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 9f25423..0c42795 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -76,8 +76,7 @@ static int ebt_target_reply_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_target reply_target =
-{
+static struct ebt_target reply_target __read_mostly = {
 	.name		= EBT_ARPREPLY_TARGET,
 	.target		= ebt_target_reply,
 	.check		= ebt_target_reply_check,
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 285378d..e700cbf 100644
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
index 78efe9b..65caa00 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -107,8 +107,7 @@ static int ebt_ip_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_ip =
-{
+static struct ebt_match filter_ip __read_mostly = {
 	.name		= EBT_IP_MATCH,
 	.match		= ebt_filter_ip,
 	.check		= ebt_ip_check,
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index 3c44bd6..8cbdc01 100644
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
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 93ea763..36723f4 100644
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
index 914c244..9b0a454 100644
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
index 19a69ea..676db32 100644
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
index f206a27..bfdf2fb 100644
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
index ed85858..e252dab 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -68,8 +68,7 @@ static int ebt_target_snat_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_target snat =
-{
+static struct ebt_target snat __read_mostly = {
 	.name		= EBT_SNAT_TARGET,
 	.target		= ebt_target_snat,
 	.check		= ebt_target_snat_check,
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index c264797..40f36d3 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -174,8 +174,7 @@ static int ebt_stp_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_match filter_stp =
-{
+static struct ebt_match filter_stp __read_mostly = {
 	.name		= EBT_STP_MATCH,
 	.match		= ebt_filter_stp,
 	.check		= ebt_stp_check,
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 748eecd..2d4c9ef 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -272,7 +272,7 @@ static int ebt_ulog_check(const char *tablename, unsigned int hookmask,
 	return 0;
 }
 
-static struct ebt_watcher ulog = {
+static struct ebt_watcher ulog __read_mostly = {
 	.name		= EBT_ULOG_WATCHER,
 	.watcher	= ebt_ulog,
 	.check		= ebt_ulog_check,
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index 96897e2..ab60b0d 100644
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
