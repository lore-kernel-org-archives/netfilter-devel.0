From: Tim Gardner <timg@tpi.com>
Subject: Re: linux-next netfilter: xt_recent: Add an entry reaper
Date: Sun, 28 Feb 2010 11:23:58 -0700
Message-ID: <4B8AB4BE.7080206@tpi.com>
References: <20100228033841.265CFF8BB0@sepang.rtg.net> <1267331677.9082.46.camel@edumazet-laptop>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020405070705010908040904"
Cc: kaber@trash.net, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <1267331677.9082.46.camel@edumazet-laptop>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020405070705010908040904
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Eric Dumazet wrote:
> Le samedi 27 février 2010 à 20:38 -0700, Tim Gardner a écrit :
>> From 03b1a0171cd3b7eb680ec738ddcc21c59688f6fe Mon Sep 17 00:00:00 2001
>> From: Tim Gardner <tim.gardner@canonical.com>
>> Date: Sat, 27 Feb 2010 20:22:07 -0700
>> Subject: [PATCH] netfilter: xt_recent: Add an entry reaper
>>
>> One of the problems with the way xt_recent is implemented is that
>> there is no efficient way to remove expired entries. Of course,
>> one can write a rule '-m recent --remove', but you have to know
>> beforehand which entry to delete. This commit adds reaper
>> logic which checks one entry on the LRU list each time a rule
>> is invoked that has a '--seconds' value. If an entry ceases
>> to accumulate time stamps, then eventually the reaper will
>> encounter it in the LRU list and remove it.
>>
> 
> Might I ask why do you want to remove expired entries like this, using
> cpu cycles in the fast path ? I dont understand why you need this reaper
> pointer given we already have lru_list to give us the oldest entry.
> 
> 1) They are normally removed in recent_entry_init(), when a new entry is
> about to be added.
> 
> 2) All entries are flushed when
> 	echo clear > /proc/net/xt_recent/<tablename>
> 
> 3) You could eventually implement a purge operation to remove all
> expired entries at will
> 
>       echo purge > /proc/net/xt_recent/<tablename>
> 
> 
> 

I realize there are manual methods for removing entries, but I argue
that manual methods are insufficient in a dynamic environment.

Let me explain one of my use cases. One of the companies that I work for
is an ISP. Our primary bridge/firewall uses iptables as a first line of
defense. One of the methods to detect attackers is by using a port scan
detection filter (PSD), which is a bit memory and CPU intensive. Once
PSD identifies an attacker, then that source IP is added to a 'recent'
filter instance with an X second timeout, and the PSD entry flushes
after some timeout. 'recent' continues to block _all_ traffic from that
source IP until it stops sending packets for at least X seconds, at
which time I would like 'recent' to release the entry.

Here is a rule snippet that implements this behavior:

IRAW="iptables -t raw"
$IRAW -N DROPIP
$IRAW -A PREROUTING -m recent --name psd  --update --seconds 3600 -j DROP
$IRAW -A PREROUTING -m psd --update --seconds 600 -J DROPIP
$IRAW -A DROPIP -m recent --name psd --set -j DROP

As long as '-m recent --name psd  --update --seconds 3600' drops entries
older then 3600 seconds, then nothing external is required to recover
those entries.

As for your fast path comment, how about scaling the frequency with
which the reaper is run using a module parameter ? See attached patch.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357

--------------020405070705010908040904
Content-Type: text/x-patch;
 name="0001-netfilter-xt_recent-Add-an-entry-reaper.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-netfilter-xt_recent-Add-an-entry-reaper.patch"

>From edfca1ddb8dab2f37efbece9b22299a9cb6e343c Mon Sep 17 00:00:00 2001
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

Also adds a ip_reaper_freq module parameter that dictates how
often the reaper is run, e.g., once for every 'ip_reaper_freq' received
packets.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 net/netfilter/xt_recent.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 7073dbb..9310dfb 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -41,18 +41,21 @@ MODULE_ALIAS("ipt_recent");
 MODULE_ALIAS("ip6t_recent");
 
 static unsigned int ip_list_tot = 100;
+static unsigned int ip_reaper_freq = 100;
 static unsigned int ip_pkt_list_tot = 20;
 static unsigned int ip_list_hash_size = 0;
 static unsigned int ip_list_perms = 0644;
 static unsigned int ip_list_uid = 0;
 static unsigned int ip_list_gid = 0;
 module_param(ip_list_tot, uint, 0400);
+module_param(ip_reaper_freq, uint, 0400);
 module_param(ip_pkt_list_tot, uint, 0400);
 module_param(ip_list_hash_size, uint, 0400);
 module_param(ip_list_perms, uint, 0400);
 module_param(ip_list_uid, uint, 0400);
 module_param(ip_list_gid, uint, 0400);
 MODULE_PARM_DESC(ip_list_tot, "number of IPs to remember per list");
+MODULE_PARM_DESC(ip_reaper_freq, "call the reaper every X packets");
 MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP address to remember (max. 255)");
 MODULE_PARM_DESC(ip_list_hash_size, "size of hash table used to look up IPs");
 MODULE_PARM_DESC(ip_list_perms, "permissions on /proc/net/xt_recent/* files");
@@ -76,6 +79,8 @@ struct recent_table {
 	unsigned int		refcnt;
 	unsigned int		entries;
 	struct list_head	lru_list;
+	struct list_head	*reaper; /* points to the lru_list */
+	unsigned int		reaper_cnt;
 	struct list_head	iphash[0];
 };
 
@@ -140,12 +145,41 @@ recent_entry_lookup(const struct recent_table *table,
 
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
@@ -272,6 +306,14 @@ recent_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 				break;
 			}
 		}
+
+		/*
+		 * Run the reaper every ip_reaper_freq packets.
+		 */
+		if (++t->reaper_cnt >= ip_reaper_freq) {
+			t->reaper_cnt = 0;
+			recent_entry_reap(t, time);
+		}
 	}
 
 	if (info->check_set & XT_RECENT_SET ||
@@ -331,6 +373,7 @@ static bool recent_mt_check(const struct xt_mtchk_param *par)
 	t->refcnt = 1;
 	strcpy(t->name, info->name);
 	INIT_LIST_HEAD(&t->lru_list);
+	t->reaper = t->lru_list.next;
 	for (i = 0; i < ip_list_hash_size; i++)
 		INIT_LIST_HEAD(&t->iphash[i]);
 #ifdef CONFIG_PROC_FS
-- 
1.7.0


--------------020405070705010908040904--
