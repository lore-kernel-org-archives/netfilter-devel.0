From: timg@tpi.com (Tim Gardner)
Subject: nf-next: netfilter: xt_recent: Add an entry reaper
Date: Tue, 16 Mar 2010 11:09:15 -0600 (MDT)
Message-ID: <20100316170915.8F49FF88DA@sepang.rtg.net>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:1727 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759845Ab0CPRJY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:09:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick,

Please reference http://marc.info/?l=netfilter&m=126732834921736&w=2 for the previous
discussion of this patch. Acked-by from Eric Duzamet in
http://marc.info/?l=netfilter&m=126747603013790&w=2

rtg
----------------
>From f2b0624b159e3282d348cd045741725a64d71716 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Sat, 27 Feb 2010 20:22:07 -0700
Subject: [PATCH] netfilter: xt_recent: Add an entry reaper (V4)

One of the problems with the way xt_recent is implemented is that
there is no efficient way to remove expired entries. Of course,
one can write a rule '-m recent --remove', but you have to know
beforehand which entry to delete. This commit adds reaper
logic which checks the head of the LRU list when a rule
is invoked that has a '--seconds' value and XT_RECENT_REAP set. If an
entry ceases to accumulate time stamps, then it will eventually bubble
to the top of the LRU list where it is then reaped.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
(cherry picked from commit 3cd53e6474b307bba448103865bed63ffe81b626)
---
 include/linux/netfilter/xt_recent.h |    4 ++++
 net/netfilter/xt_recent.c           |   28 +++++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/xt_recent.h b/include/linux/netfilter/xt_recent.h
index d2c2766..bba990e 100644
--- a/include/linux/netfilter/xt_recent.h
+++ b/include/linux/netfilter/xt_recent.h
@@ -9,6 +9,7 @@ enum {
 	XT_RECENT_UPDATE   = 1 << 2,
 	XT_RECENT_REMOVE   = 1 << 3,
 	XT_RECENT_TTL      = 1 << 4,
+	XT_RECENT_REAP     = 1 << 5,
 
 	XT_RECENT_SOURCE   = 0,
 	XT_RECENT_DEST     = 1,
@@ -16,6 +17,9 @@ enum {
 	XT_RECENT_NAME_LEN = 200,
 };
 
+/* Only allowed with --rcheck and --update */
+#define XT_RECENT_MODIFIERS (XT_RECENT_TTL|XT_RECENT_REAP)
+
 struct xt_recent_mtinfo {
 	__u32 seconds;
 	__u32 hit_count;
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 7073dbb..873a101 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -146,6 +146,25 @@ static void recent_entry_remove(struct recent_table *t, struct recent_entry *e)
 	t->entries--;
 }
 
+/*
+ * Drop entries with timestamps older then 'time'.
+ */
+static void recent_entry_reap(struct recent_table *t, unsigned long time)
+{
+	struct recent_entry *e;
+
+	/*
+	 * The head of the LRU list is always the oldest entry.
+	 */
+	e = list_entry(t->lru_list.next, struct recent_entry, lru_list);
+
+	/*
+	 * The last time stamp is the most recent.
+	 */
+	if (time_after(time, e->stamps[e->index-1]))
+		recent_entry_remove(t, e);
+}
+
 static struct recent_entry *
 recent_entry_init(struct recent_table *t, const union nf_inet_addr *addr,
 		  u_int16_t family, u_int8_t ttl)
@@ -272,6 +291,10 @@ recent_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 				break;
 			}
 		}
+
+		/* info->seconds must be non-zero */
+		if (info->check_set & XT_RECENT_REAP)
+			recent_entry_reap(t, time);
 	}
 
 	if (info->check_set & XT_RECENT_SET ||
@@ -304,7 +327,10 @@ static bool recent_mt_check(const struct xt_mtchk_param *par)
 		      XT_RECENT_CHECK | XT_RECENT_UPDATE)) != 1)
 		return false;
 	if ((info->check_set & (XT_RECENT_SET | XT_RECENT_REMOVE)) &&
-	    (info->seconds || info->hit_count))
+	    (info->seconds || info->hit_count ||
+	    (info->check_set & XT_RECENT_MODIFIERS)))
+		return false;
+	if ((info->check_set & XT_RECENT_REAP) && !info->seconds)
 		return false;
 	if (info->hit_count > ip_pkt_list_tot) {
 		pr_info(KBUILD_MODNAME ": hitcount (%u) is larger than "
-- 
1.7.0

