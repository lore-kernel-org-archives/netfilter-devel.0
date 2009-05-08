From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/11] netfilter: xtables: remove redundant casts
Date: Fri,  8 May 2009 11:26:34 +0200
Message-ID: <1241774801-2315-5-git-send-email-jengelh@medozas.de>
References: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53353 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbZEHJ0m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 May 2009 05:26:42 -0400
In-Reply-To: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/ip_tables.c  |    2 +-
 net/ipv6/netfilter/ip6_tables.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 5abc276..7fcbc16 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -280,7 +280,7 @@ static void trace_packet(struct sk_buff *skb,
 	char *hookname, *chainname, *comment;
 	unsigned int rulenum = 0;
 
-	table_base = (void *)private->entries[smp_processor_id()];
+	table_base = private->entries[smp_processor_id()];
 	root = get_entry(table_base, private->hook_entry[hook]);
 
 	hookname = chainname = (char *)hooknames[hook];
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 37a850e..2b52fac 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -312,7 +312,7 @@ static void trace_packet(struct sk_buff *skb,
 	char *hookname, *chainname, *comment;
 	unsigned int rulenum = 0;
 
-	table_base = (void *)private->entries[smp_processor_id()];
+	table_base = private->entries[smp_processor_id()];
 	root = get_entry(table_base, private->hook_entry[hook]);
 
 	hookname = chainname = (char *)hooknames[hook];
-- 
1.6.2.2

