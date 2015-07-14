From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next 5/6] netfilter: xtables: remove __pure annotation
Date: Tue, 14 Jul 2015 17:51:10 +0200
Message-ID: <1436889071-3637-6-git-send-email-fw@strlen.de>
References: <1436889071-3637-1-git-send-email-fw@strlen.de>
Cc: eric.dumazet@gmail.com, Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49923 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752743AbbGNPvV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jul 2015 11:51:21 -0400
In-Reply-To: <1436889071-3637-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

sparse complains:
ip_tables.c:361:27: warning: incorrect type in assignment (different modifiers)
ip_tables.c:361:27:    expected struct ipt_entry *[assigned] e
ip_tables.c:361:27:    got struct ipt_entry [pure] *

doesn't change generated code.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v1 of this patch.
 net/ipv4/netfilter/arp_tables.c | 2 +-
 net/ipv4/netfilter/ip_tables.c  | 2 +-
 net/ipv6/netfilter/ip6_tables.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 969fdbe..c416cb3 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -240,7 +240,7 @@ get_entry(const void *base, unsigned int offset)
 	return (struct arpt_entry *)(base + offset);
 }
 
-static inline __pure
+static inline
 struct arpt_entry *arpt_next_entry(const struct arpt_entry *entry)
 {
 	return (void *)entry + entry->next_offset;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index ff585bd..787f99e 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -276,7 +276,7 @@ static void trace_packet(const struct sk_buff *skb,
 }
 #endif
 
-static inline __pure
+static inline
 struct ipt_entry *ipt_next_entry(const struct ipt_entry *entry)
 {
 	return (void *)entry + entry->next_offset;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index ea6d105..4e21f80 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -305,7 +305,7 @@ static void trace_packet(const struct sk_buff *skb,
 }
 #endif
 
-static inline __pure struct ip6t_entry *
+static inline struct ip6t_entry *
 ip6t_next_entry(const struct ip6t_entry *entry)
 {
 	return (void *)entry + entry->next_offset;
-- 
2.0.5

