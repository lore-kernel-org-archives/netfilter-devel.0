From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH] NETFILTER: Use non-deprecated __RW_LOCK_UNLOCKED macro.
Date: Sat, 15 Mar 2008 14:42:21 -0400 (EDT)
Message-ID: <alpine.LFD.1.00.0803151440220.25279@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:33076 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbYCOSm1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Mar 2008 14:42:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  not compile-tested, but fairly straightforward.


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
index 69f3d7e..1e5ea8c 100644
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
index c55a210..d7cd5c1 100644
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
index e41fe8c..8a8422a 100644
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

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
