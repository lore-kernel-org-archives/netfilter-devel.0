From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/4] psd: reduce size of struct host
Date: Thu, 14 Jun 2012 22:13:33 +0200
Message-ID: <1339704814-1605-4-git-send-email-fw@strlen.de>
References: <1339704814-1605-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41694 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173Ab2FNUOx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:14:53 -0400
In-Reply-To: <1339704814-1605-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We can use u16, saving 8 bytes total (weight cant't exceed PSD_MAX_RATE,
10000).  Also re-format comments & struct initializers.

no functional changes.
---
 extensions/libxt_psd.c |   24 ++++++++++++------------
 extensions/xt_psd.c    |   16 ++++++++--------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/extensions/libxt_psd.c b/extensions/libxt_psd.c
index e60178b..483c69a 100644
--- a/extensions/libxt_psd.c
+++ b/extensions/libxt_psd.c
@@ -137,19 +137,19 @@ static void psd_mt_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match psd_mt_reg = {
-	.name			= "psd",
-	.version		= XTABLES_VERSION,
-	.revision   	= 1,
-	.family        = NFPROTO_IPV4,
-	.size			= XT_ALIGN(sizeof(struct xt_psd_info)),
+	.name           = "psd",
+	.version        = XTABLES_VERSION,
+	.revision       = 1,
+	.family         = NFPROTO_IPV4,
+	.size           = XT_ALIGN(sizeof(struct xt_psd_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_psd_info)),
-	.help			= psd_mt_help,
-	.init			= psd_mt_init,
-	.parse			= psd_mt_parse,
-	.final_check	= psd_mt_final_check,
-	.print			= psd_mt_print,
-	.save			= psd_mt_save,
-	.extra_opts		= psd_mt_opts,
+	.help           = psd_mt_help,
+	.init           = psd_mt_init,
+	.parse          = psd_mt_parse,
+	.final_check    = psd_mt_final_check,
+	.print          = psd_mt_print,
+	.save           = psd_mt_save,
+	.extra_opts     = psd_mt_opts,
 };
 
 static __attribute__((constructor)) void psd_mt_ldr(void)
diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index f3fa336..00ff1d4 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -53,13 +53,13 @@ struct port {
  * Information we keep per each source address.
  */
 struct host {
-	struct host *next;						/* Next entry with the same hash */
-	unsigned long timestamp;					/* Last update time */
-	struct in_addr src_addr;				/* Source address */
-	struct in_addr dest_addr;				/* Destination address */
-	unsigned short src_port;				/* Source port */
-	int count;								/* Number of ports in the list */
-	int weight;								/* Total weight of ports in the list */
+	struct host *next;			/* Next entry with the same hash */
+	unsigned long timestamp;		/* Last update time */
+	struct in_addr src_addr;		/* Source address */
+	struct in_addr dest_addr;		/* Destination address */
+	__be16 src_port;			/* Source port */
+	u16 weight;				/* Total weight of ports in the list */
+	u8 count;				/* Number of ports in the list */
 	struct port ports[SCAN_MAX_COUNT - 1];	/* List of ports */
 };
 
@@ -70,7 +70,7 @@ static struct {
 	spinlock_t lock;
 	struct host list[LIST_SIZE];	/* List of source addresses */
 	struct host *hash[HASH_SIZE];	/* Hash: pointers into the list */
-	int index;						/* Oldest entry to be replaced */
+	int index;			/* Oldest entry to be replaced */
 } state;
 
 /*
-- 
1.7.3.4

