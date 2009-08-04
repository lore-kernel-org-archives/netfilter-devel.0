From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 025/103] netfilter: xtables: constify initial table data
Date: Tue,  4 Aug 2009 09:25:09 +0200
Message-ID: <1249370787-17583-26-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50626 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbZHDH1A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:00 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/netfilter/ebtable_broute.c  |    2 +-
 net/bridge/netfilter/ebtable_filter.c  |    2 +-
 net/ipv4/netfilter/arptable_filter.c   |    4 ++--
 net/ipv4/netfilter/iptable_filter.c    |    2 +-
 net/ipv4/netfilter/iptable_mangle.c    |    4 ++--
 net/ipv4/netfilter/iptable_raw.c       |    4 ++--
 net/ipv4/netfilter/iptable_security.c  |    4 ++--
 net/ipv4/netfilter/nf_nat_rule.c       |    4 ++--
 net/ipv6/netfilter/ip6table_filter.c   |    2 +-
 net/ipv6/netfilter/ip6table_mangle.c   |    4 ++--
 net/ipv6/netfilter/ip6table_raw.c      |    4 ++--
 net/ipv6/netfilter/ip6table_security.c |    4 ++--
 12 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index c751111..d32ab13 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -41,7 +41,7 @@ static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
 	return 0;
 }
 
-static struct ebt_table broute_table =
+static const struct ebt_table broute_table =
 {
 	.name		= "broute",
 	.table		= &initial_table,
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index 4b988db..60b1a6c 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -50,7 +50,7 @@ static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
 	return 0;
 }
 
-static struct ebt_table frame_filter =
+static const struct ebt_table frame_filter =
 {
 	.name		= "filter",
 	.table		= &initial_table,
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index c1a3797..c45a8a1 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -15,7 +15,7 @@ MODULE_DESCRIPTION("arptables filter table");
 #define FILTER_VALID_HOOKS ((1 << NF_ARP_IN) | (1 << NF_ARP_OUT) | \
 			   (1 << NF_ARP_FORWARD))
 
-static struct
+static const struct
 {
 	struct arpt_replace repl;
 	struct arpt_standard entries[3];
@@ -45,7 +45,7 @@ static struct
 	.term = ARPT_ERROR_INIT,
 };
 
-static struct xt_table packet_filter = {
+static const struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.me		= THIS_MODULE,
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 212757f..05c1d3c 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -53,7 +53,7 @@ static struct
 	.term = IPT_ERROR_INIT,			/* ERROR */
 };
 
-static struct xt_table packet_filter = {
+static const struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.me		= THIS_MODULE,
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 9a2f0b5..b504f72 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -28,7 +28,7 @@ MODULE_DESCRIPTION("iptables mangle table");
 			    (1 << NF_INET_POST_ROUTING))
 
 /* Ouch - five different hooks? Maybe this should be a config option..... -- BC */
-static struct
+static const struct
 {
 	struct ipt_replace repl;
 	struct ipt_standard entries[5];
@@ -64,7 +64,7 @@ static struct
 	.term = IPT_ERROR_INIT,			/* ERROR */
 };
 
-static struct xt_table packet_mangler = {
+static const struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.me		= THIS_MODULE,
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index c454ee9..2f87098 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -9,7 +9,7 @@
 
 #define RAW_VALID_HOOKS ((1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT))
 
-static struct
+static const struct
 {
 	struct ipt_replace repl;
 	struct ipt_standard entries[2];
@@ -36,7 +36,7 @@ static struct
 	.term = IPT_ERROR_INIT,			/* ERROR */
 };
 
-static struct xt_table packet_raw = {
+static const struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks =  RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index cab6baf..4cee3dc 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -27,7 +27,7 @@ MODULE_DESCRIPTION("iptables security table, for MAC rules");
 				(1 << NF_INET_FORWARD) | \
 				(1 << NF_INET_LOCAL_OUT)
 
-static struct
+static const struct
 {
 	struct ipt_replace repl;
 	struct ipt_standard entries[3];
@@ -57,7 +57,7 @@ static struct
 	.term = IPT_ERROR_INIT,			/* ERROR */
 };
 
-static struct xt_table security_table = {
+static const struct xt_table security_table = {
 	.name		= "security",
 	.valid_hooks	= SECURITY_VALID_HOOKS,
 	.me		= THIS_MODULE,
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index 6448a9b..9e81e0d 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -28,7 +28,7 @@
 			 (1 << NF_INET_POST_ROUTING) | \
 			 (1 << NF_INET_LOCAL_OUT))
 
-static struct
+static const struct
 {
 	struct ipt_replace repl;
 	struct ipt_standard entries[3];
@@ -58,7 +58,7 @@ static struct
 	.term = IPT_ERROR_INIT,			/* ERROR */
 };
 
-static struct xt_table nat_table = {
+static const struct xt_table nat_table = {
 	.name		= "nat",
 	.valid_hooks	= NAT_VALID_HOOKS,
 	.me		= THIS_MODULE,
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 0b5f24b..e8d3a03 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -51,7 +51,7 @@ static struct
 	.term = IP6T_ERROR_INIT,		/* ERROR */
 };
 
-static struct xt_table packet_filter = {
+static const struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.me		= THIS_MODULE,
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index c663d9c..ec803a2 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -21,7 +21,7 @@ MODULE_DESCRIPTION("ip6tables mangle table");
 			    (1 << NF_INET_LOCAL_OUT) | \
 			    (1 << NF_INET_POST_ROUTING))
 
-static struct
+static const struct
 {
 	struct ip6t_replace repl;
 	struct ip6t_standard entries[5];
@@ -57,7 +57,7 @@ static struct
 	.term = IP6T_ERROR_INIT,		/* ERROR */
 };
 
-static struct xt_table packet_mangler = {
+static const struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.me		= THIS_MODULE,
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 17d32d4..86ea699 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -8,7 +8,7 @@
 
 #define RAW_VALID_HOOKS ((1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT))
 
-static struct
+static const struct
 {
 	struct ip6t_replace repl;
 	struct ip6t_standard entries[2];
@@ -35,7 +35,7 @@ static struct
 	.term = IP6T_ERROR_INIT,		/* ERROR */
 };
 
-static struct xt_table packet_raw = {
+static const struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks = RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index b402437..7db37ba 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -26,7 +26,7 @@ MODULE_DESCRIPTION("ip6tables security table, for MAC rules");
 				(1 << NF_INET_FORWARD) | \
 				(1 << NF_INET_LOCAL_OUT)
 
-static struct
+static const struct
 {
 	struct ip6t_replace repl;
 	struct ip6t_standard entries[3];
@@ -56,7 +56,7 @@ static struct
 	.term = IP6T_ERROR_INIT,		/* ERROR */
 };
 
-static struct xt_table security_table = {
+static const struct xt_table security_table = {
 	.name		= "security",
 	.valid_hooks	= SECURITY_VALID_HOOKS,
 	.me		= THIS_MODULE,
-- 
1.6.3.3

