From: timg@tpi.com (Tim Gardner)
Subject: linux-next netfilter: xt_recent: Add an entry reaper
Date: Sat, 27 Feb 2010 20:38:41 -0700 (MST)
Message-ID: <20100228033841.265CFF8BB0@sepang.rtg.net>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

>From 03b1a0171cd3b7eb680ec738ddcc21c59688f6fe Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Sat, 27 Feb 2010 20:22:07 -0700
Subject: [PATCH] netfilter: xt_recent: Add an entry reaper

One of the problems with the way xt_recent is implemented is that
there is no efficient way to remove expired entries. Of course,
one can write a rule '-m recent --remove', but you have to know
beforehand which entry to delete. This commit adds reaper
logic which checks one entry on the LRU list each time a rule
is invoked that has a '--seconds' value. If an entry ceases
to accumulate time stamps, then eventually the reaper will
encounter it in the LRU list and remove it.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 net/netfilter/xt_recent.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 7073dbb..5747440 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -76,6 +76,7 @@ struct recent_table {
 	unsigned int		refcnt;
 	unsigned int		entries;
 	struct list_head	lru_list;
+	struct list_head	*reaper; /* points to the lru_list */
 	struct list_head	iphash[0];
 };
 
@@ -140,12 +141,41 @@ recent_entry_lookup(const struct recent_table *table,
 
 static void recent_entry_remove(struct recent_table *t, struct recent_entry *e)
 {
+	/*
+	 * Advance the reaper if its about to be deleted.
+	 */
+	if (list_entry(t->reaper, struct recent_entry, lru_list) == e)
+		t->reaper = t->reaper->next;
+
 	list_del(&e->list);
 	list_del(&e->lru_list);
 	kfree(e);
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
+	 * Don't reap the list head.
+	 */
+	t->reaper = t->reaper->next;
+	if (t->reaper == (&t->lru_list))
+		return;
+
+	e = list_entry(t->reaper, struct recent_entry, lru_list);
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
@@ -272,6 +302,8 @@ recent_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 				break;
 			}
 		}
+
+		recent_entry_reap(t, time);
 	}
 
 	if (info->check_set & XT_RECENT_SET ||
@@ -331,6 +363,7 @@ static bool recent_mt_check(const struct xt_mtchk_param *par)
 	t->refcnt = 1;
 	strcpy(t->name, info->name);
 	INIT_LIST_HEAD(&t->lru_list);
+	t->reaper = t->lru_list.next;
 	for (i = 0; i < ip_list_hash_size; i++)
 		INIT_LIST_HEAD(&t->iphash[i]);
 #ifdef CONFIG_PROC_FS
-- 
1.7.0

