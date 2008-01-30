From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/69]: Use const in struct xt_match, xt_target, xt_table
Date: Wed, 30 Jan 2008 21:16:55 +0100 (MET)
Message-ID: <20080130201653.29874.21272.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60631 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933435AbYA3UQ5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:16:57 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Use const in struct xt_match, xt_target, xt_table

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a2a8ddee99386b740ec6242b2a185617ba59edac
tree cd3566e5dd481ca08cb0c4e9baeb424c354895cf
parent 529b54d47425038bf231b8ce446447e957b3c89d
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 29 Jan 2008 16:21:49 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:12 +0100

 include/linux/netfilter/x_tables.h |    6 +++---
 net/ipv4/netfilter/ip_tables.c     |    2 +-
 net/ipv6/netfilter/ip6_tables.c    |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index b99ede5..90dc6ea 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -214,7 +214,7 @@ struct xt_match
 	/* Free to use by each match */
 	unsigned long data;
 
-	char *table;
+	const char *table;
 	unsigned int matchsize;
 	unsigned int compatsize;
 	unsigned int hooks;
@@ -261,7 +261,7 @@ struct xt_target
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
 
-	char *table;
+	const char *table;
 	unsigned int targetsize;
 	unsigned int compatsize;
 	unsigned int hooks;
@@ -277,7 +277,7 @@ struct xt_table
 	struct list_head list;
 
 	/* A unique name... */
-	char name[XT_TABLE_MAXNAMELEN];
+	const char name[XT_TABLE_MAXNAMELEN];
 
 	/* What hooks you will enter on */
 	unsigned int valid_hooks;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 982b7f9..628a6b5 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -291,7 +291,7 @@ static void trace_packet(struct sk_buff *skb,
 			 unsigned int hook,
 			 const struct net_device *in,
 			 const struct net_device *out,
-			 char *tablename,
+			 const char *tablename,
 			 struct xt_table_info *private,
 			 struct ipt_entry *e)
 {
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index dd7860f..92b4898 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -320,7 +320,7 @@ static void trace_packet(struct sk_buff *skb,
 			 unsigned int hook,
 			 const struct net_device *in,
 			 const struct net_device *out,
-			 char *tablename,
+			 const char *tablename,
 			 struct xt_table_info *private,
 			 struct ip6t_entry *e)
 {
