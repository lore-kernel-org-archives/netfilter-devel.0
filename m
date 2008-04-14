From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/41]: Use non-deprecated __RW_LOCK_UNLOCKED macro
Date: Mon, 14 Apr 2008 12:16:25 +0200 (MEST)
Message-ID: <20080414101621.32717.19046.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36244 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbYDNKQ0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:26 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Use non-deprecated __RW_LOCK_UNLOCKED macro

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0d2ae4cfe02283c53b2ec3bf86aa2e334381036d
tree 27b55b9f1086d69b8a2a31bb6e79c66a42b78932
parent 8d2a75d2ec1d4b66a9401235cfca89e4f0c488a6
author Robert P. J. Day <rpjday@crashcourse.ca> Mon, 14 Apr 2008 12:10:40 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:40 +0200

 net/ipv4/netfilter/arptable_filter.c |    2 +-
 net/ipv4/netfilter/iptable_filter.c  |    2 +-
 net/ipv4/netfilter/iptable_mangle.c  |    2 +-
 net/ipv4/netfilter/iptable_raw.c     |    2 +-
 net/ipv4/netfilter/nf_nat_rule.c     |    2 +-
 net/ipv6/netfilter/ip6table_filter.c |    2 +-
 net/ipv6/netfilter/ip6table_mangle.c |    2 +-
 net/ipv6/netfilter/ip6table_raw.c    |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 4e9c496..629e495 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -48,7 +48,7 @@ static struct
 static struct arpt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
-	.lock		= RW_LOCK_UNLOCKED,
+	.lock		= __RW_LOCK_UNLOCKED(packet_filter.lock),
 	.private	= NULL,
 	.me		= THIS_MODULE,
 	.af		= NF_ARP,
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 7fcf60a..1ea677d 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -56,7 +56,7 @@ static struct
 static struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
-	.lock		= RW_LOCK_UNLOCKED,
+	.lock		= __RW_LOCK_UNLOCKED(packet_filter.lock),
 	.me		= THIS_MODULE,
 	.af		= AF_INET,
 };
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index ba82703..da59182 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -67,7 +67,7 @@ static struct
 static struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
-	.lock		= RW_LOCK_UNLOCKED,
+	.lock		= __RW_LOCK_UNLOCKED(packet_mangler.lock),
 	.me		= THIS_MODULE,
 	.af		= AF_INET,
 };
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 4b68974..fddce77 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -39,7 +39,7 @@ static struct
 static struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks =  RAW_VALID_HOOKS,
-	.lock = RW_LOCK_UNLOCKED,
+	.lock = __RW_LOCK_UNLOCKED(packet_raw.lock),
 	.me = THIS_MODULE,
 	.af = AF_INET,
 };
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index f8fda57..e330a29 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -61,7 +61,7 @@ static struct
 static struct xt_table __nat_table = {
 	.name		= "nat",
 	.valid_hooks	= NAT_VALID_HOOKS,
-	.lock		= RW_LOCK_UNLOCKED,
+	.lock		= __RW_LOCK_UNLOCKED(__nat_table.lock),
 	.me		= THIS_MODULE,
 	.af		= AF_INET,
 };
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 2d9cd09..f979e48 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -54,7 +54,7 @@ static struct
 static struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
-	.lock		= RW_LOCK_UNLOCKED,
+	.lock		= __RW_LOCK_UNLOCKED(packet_filter.lock),
 	.me		= THIS_MODULE,
 	.af		= AF_INET6,
 };
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 035343a..27a5e8b 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -60,7 +60,7 @@ static struct
 static struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
-	.lock		= RW_LOCK_UNLOCKED,
+	.lock		= __RW_LOCK_UNLOCKED(packet_mangler.lock),
 	.me		= THIS_MODULE,
 	.af		= AF_INET6,
 };
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 5cd8420..92b9107 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -38,7 +38,7 @@ static struct
 static struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks = RAW_VALID_HOOKS,
-	.lock = RW_LOCK_UNLOCKED,
+	.lock = __RW_LOCK_UNLOCKED(packet_raw.lock),
 	.me = THIS_MODULE,
 	.af = AF_INET6,
 };
