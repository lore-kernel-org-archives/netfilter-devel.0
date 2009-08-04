From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 013/103] netfilter: xtables: switch table AFs to nfproto
Date: Tue,  4 Aug 2009 09:24:57 +0200
Message-ID: <1249370787-17583-14-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50620 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541AbZHDH0r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:26:47 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/iptable_filter.c    |    2 +-
 net/ipv4/netfilter/iptable_mangle.c    |    2 +-
 net/ipv4/netfilter/iptable_raw.c       |    2 +-
 net/ipv4/netfilter/iptable_security.c  |    2 +-
 net/ipv4/netfilter/nf_nat_rule.c       |    2 +-
 net/ipv6/netfilter/ip6table_filter.c   |    2 +-
 net/ipv6/netfilter/ip6table_mangle.c   |    2 +-
 net/ipv6/netfilter/ip6table_raw.c      |    2 +-
 net/ipv6/netfilter/ip6table_security.c |    2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index bef326c..97dbd94 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -57,7 +57,7 @@ static struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.me		= THIS_MODULE,
-	.af		= AF_INET,
+	.af		= NFPROTO_IPV4,
 };
 
 /* The work comes in here from netfilter.c. */
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 1442df7..28647f1 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -68,7 +68,7 @@ static struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.me		= THIS_MODULE,
-	.af		= AF_INET,
+	.af		= NFPROTO_IPV4,
 };
 
 /* The work comes in here from netfilter.c. */
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 1d28df8..494784c 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -40,7 +40,7 @@ static struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks =  RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
-	.af = AF_INET,
+	.af = NFPROTO_IPV4,
 };
 
 /* The work comes in here from netfilter.c. */
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index 8c5a250..8804e1a 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -61,7 +61,7 @@ static struct xt_table security_table = {
 	.name		= "security",
 	.valid_hooks	= SECURITY_VALID_HOOKS,
 	.me		= THIS_MODULE,
-	.af		= AF_INET,
+	.af		= NFPROTO_IPV4,
 };
 
 static unsigned int
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index 6348a79..6448a9b 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -62,7 +62,7 @@ static struct xt_table nat_table = {
 	.name		= "nat",
 	.valid_hooks	= NAT_VALID_HOOKS,
 	.me		= THIS_MODULE,
-	.af		= AF_INET,
+	.af		= NFPROTO_IPV4,
 };
 
 /* Source NAT */
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index b35c358..0a3ae48 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -55,7 +55,7 @@ static struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.me		= THIS_MODULE,
-	.af		= AF_INET6,
+	.af		= NFPROTO_IPV6,
 };
 
 /* The work comes in here from netfilter.c. */
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index a98ced1..0f49e00 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -61,7 +61,7 @@ static struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.me		= THIS_MODULE,
-	.af		= AF_INET6,
+	.af		= NFPROTO_IPV6,
 };
 
 /* The work comes in here from netfilter.c. */
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index ec12540..679865e 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -39,7 +39,7 @@ static struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks = RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
-	.af = AF_INET6,
+	.af = NFPROTO_IPV6,
 };
 
 /* The work comes in here from netfilter.c. */
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index d808507..822afab 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -60,7 +60,7 @@ static struct xt_table security_table = {
 	.name		= "security",
 	.valid_hooks	= SECURITY_VALID_HOOKS,
 	.me		= THIS_MODULE,
-	.af		= AF_INET6,
+	.af		= NFPROTO_IPV6,
 };
 
 static unsigned int
-- 
1.6.3.3

