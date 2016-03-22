From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/5] netfilter: x_tables: make sure e->next_offset covers remaining blob size
Date: Tue, 22 Mar 2016 18:02:50 +0100
Message-ID: <1458666173-24318-3-git-send-email-fw@strlen.de>
References: <1458666173-24318-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38137 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756167AbcCVRCn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 13:02:43 -0400
In-Reply-To: <1458666173-24318-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Otherwise this function may read data beyond the ruleset blob.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/arp_tables.c | 6 ++++--
 net/ipv4/netfilter/ip_tables.c  | 6 ++++--
 net/ipv6/netfilter/ip6_tables.c | 6 ++++--
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 830bbe8..51d4fe5 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -573,7 +573,8 @@ static inline int check_entry_size_and_hooks(struct arpt_entry *e,
 	int err;
 
 	if ((unsigned long)e % __alignof__(struct arpt_entry) != 0 ||
-	    (unsigned char *)e + sizeof(struct arpt_entry) >= limit) {
+	    (unsigned char *)e + sizeof(struct arpt_entry) >= limit ||
+	    (unsigned char *)e + e->next_offset > limit) {
 		duprintf("Bad offset %p\n", e);
 		return -EINVAL;
 	}
@@ -1232,7 +1233,8 @@ check_compat_entry_size_and_hooks(struct compat_arpt_entry *e,
 
 	duprintf("check_compat_entry_size_and_hooks %p\n", e);
 	if ((unsigned long)e % __alignof__(struct compat_arpt_entry) != 0 ||
-	    (unsigned char *)e + sizeof(struct compat_arpt_entry) >= limit) {
+	    (unsigned char *)e + sizeof(struct compat_arpt_entry) >= limit ||
+	    (unsigned char *)e + e->next_offset > limit) {
 		duprintf("Bad offset %p, limit = %p\n", e, limit);
 		return -EINVAL;
 	}
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 1d72a3c..fb7694e 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -738,7 +738,8 @@ check_entry_size_and_hooks(struct ipt_entry *e,
 	int err;
 
 	if ((unsigned long)e % __alignof__(struct ipt_entry) != 0 ||
-	    (unsigned char *)e + sizeof(struct ipt_entry) >= limit) {
+	    (unsigned char *)e + sizeof(struct ipt_entry) >= limit ||
+	    (unsigned char *)e + e->next_offset > limit) {
 		duprintf("Bad offset %p\n", e);
 		return -EINVAL;
 	}
@@ -1492,7 +1493,8 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 
 	duprintf("check_compat_entry_size_and_hooks %p\n", e);
 	if ((unsigned long)e % __alignof__(struct compat_ipt_entry) != 0 ||
-	    (unsigned char *)e + sizeof(struct compat_ipt_entry) >= limit) {
+	    (unsigned char *)e + sizeof(struct compat_ipt_entry) >= limit ||
+	    (unsigned char *)e + e->next_offset > limit) {
 		duprintf("Bad offset %p, limit = %p\n", e, limit);
 		return -EINVAL;
 	}
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 26a5ad1..b248528f 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -750,7 +750,8 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
 	int err;
 
 	if ((unsigned long)e % __alignof__(struct ip6t_entry) != 0 ||
-	    (unsigned char *)e + sizeof(struct ip6t_entry) >= limit) {
+	    (unsigned char *)e + sizeof(struct ip6t_entry) >= limit ||
+	    (unsigned char *)e + e->next_offset > limit) {
 		duprintf("Bad offset %p\n", e);
 		return -EINVAL;
 	}
@@ -1504,7 +1505,8 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 
 	duprintf("check_compat_entry_size_and_hooks %p\n", e);
 	if ((unsigned long)e % __alignof__(struct compat_ip6t_entry) != 0 ||
-	    (unsigned char *)e + sizeof(struct compat_ip6t_entry) >= limit) {
+	    (unsigned char *)e + sizeof(struct compat_ip6t_entry) >= limit ||
+	    (unsigned char *)e + e->next_offset > limit) {
 		duprintf("Bad offset %p, limit = %p\n", e, limit);
 		return -EINVAL;
 	}
-- 
2.4.10

