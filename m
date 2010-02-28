From: Tim Gardner <timg@tpi.com>
Subject: Re: linux-next netfilter: xt_recent: Add an entry reaper
Date: Sun, 28 Feb 2010 16:12:55 -0700
Message-ID: <4B8AF877.4080001@tpi.com>
References: <20100228033841.265CFF8BB0@sepang.rtg.net>	 <1267331677.9082.46.camel@edumazet-laptop>  <4B8AB4BE.7080206@tpi.com> <1267388436.9082.84.camel@edumazet-laptop>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050305040604010803030705"
Cc: kaber@trash.net, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <1267388436.9082.84.camel@edumazet-laptop>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050305040604010803030705
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Eric Dumazet wrote:
> Le dimanche 28 février 2010 à 11:23 -0700, Tim Gardner a écrit :
>> I realize there are manual methods for removing entries, but I argue
>> that manual methods are insufficient in a dynamic environment.
>>
>> Let me explain one of my use cases. One of the companies that I work for
>> is an ISP. Our primary bridge/firewall uses iptables as a first line of
>> defense. One of the methods to detect attackers is by using a port scan
>> detection filter (PSD), which is a bit memory and CPU intensive. Once
>> PSD identifies an attacker, then that source IP is added to a 'recent'
>> filter instance with an X second timeout, and the PSD entry flushes
>> after some timeout. 'recent' continues to block _all_ traffic from that
>> source IP until it stops sending packets for at least X seconds, at
>> which time I would like 'recent' to release the entry.
>>
>> Here is a rule snippet that implements this behavior:
>>
>> IRAW="iptables -t raw"
>> $IRAW -N DROPIP
>> $IRAW -A PREROUTING -m recent --name psd  --update --seconds 3600 -j DROP
>> $IRAW -A PREROUTING -m psd --update --seconds 600 -J DROPIP
>> $IRAW -A DROPIP -m recent --name psd --set -j DROP
>>
>> As long as '-m recent --name psd  --update --seconds 3600' drops entries
>> older then 3600 seconds, then nothing external is required to recover
>> those entries.
>>
>> As for your fast path comment, how about scaling the frequency with
>> which the reaper is run using a module parameter ? See attached patch.
>>
>> rtg
> 
> OK but as pointed by Jan Engelhardt, same table can be used with
> different matches and different delays, so your patch is not good. You
> should add a parameter (--reap or some flag) to iptables rule to ask for
> this reap, and not let it happen in general case.
> 
> iptables -A ... -m recent --name foo --seconds 60 -j DOTHAT
> iptables -A ... -m recent --name foo --seconds 3600 --reap -j ELSE
> 
> Also, I am convinced your reap pointer is not good, because it can point
> to an entry that is renewed once per second for example, and reaper will
> be frozen.
> 
> You should use lru_list.next only, because this one is guaranted to
> point to the oldest entry in table
> 
> 

You are right about the reaper pointer. I'd forgotten that the LRU list
was already sorted oldest to newest. Doh! I've cleaned that up some.

This version adds the '--reap' flag and only looks at the head of the
LRU list once per ip_reaper_freq packets.

I also added a check that makes sure --rttl and --reap modify only the
--rcheck and --update options.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357

--------------050305040604010803030705
Content-Type: text/x-patch;
 name="0001-netfilter-xt_recent-Add-an-entry-reaper-V3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-netfilter-xt_recent-Add-an-entry-reaper-V3.patch"

>From 35779dff0bb13a6ff20a910c5958b9ca48a0cce7 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Sat, 27 Feb 2010 20:22:07 -0700
Subject: [PATCH] netfilter: xt_recent: Add an entry reaper (V3)

One of the problems with the way xt_recent is implemented is that
there is no efficient way to remove expired entries. Of course,
one can write a rule '-m recent --remove', but you have to know
beforehand which entry to delete. This commit adds reaper
logic which checks the head of the LRU list when a rule
is invoked that has a '--seconds' value and XT_RECENT_REAP set. If an
entry ceases to accumulate time stamps, then it will eventually bubble
to the top of the LRU list where it is then reaped.

Also adds a ip_reaper_freq module parameter that dictates how
often the reaper is run, e.g., once for every 'ip_reaper_freq' received
packets.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 include/linux/netfilter/xt_recent.h |    4 +++
 net/netfilter/xt_recent.c           |   36 ++++++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletions(-)

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
index 7073dbb..2acc9e4 100644
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
@@ -76,6 +79,7 @@ struct recent_table {
 	unsigned int		refcnt;
 	unsigned int		entries;
 	struct list_head	lru_list;
+	unsigned int		reaper_cnt;
 	struct list_head	iphash[0];
 };
 
@@ -146,6 +150,25 @@ static void recent_entry_remove(struct recent_table *t, struct recent_entry *e)
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
@@ -272,6 +295,16 @@ recent_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 				break;
 			}
 		}
+
+		/*
+		 * Run the reaper every ip_reaper_freq packets.
+		 */
+		if ((info->check_set & XT_RECENT_REAP) &&
+		    info->seconds &&
+		    (++t->reaper_cnt >= ip_reaper_freq)) {
+			t->reaper_cnt = 0;
+			recent_entry_reap(t, time);
+		}
 	}
 
 	if (info->check_set & XT_RECENT_SET ||
@@ -304,7 +337,8 @@ static bool recent_mt_check(const struct xt_mtchk_param *par)
 		      XT_RECENT_CHECK | XT_RECENT_UPDATE)) != 1)
 		return false;
 	if ((info->check_set & (XT_RECENT_SET | XT_RECENT_REMOVE)) &&
-	    (info->seconds || info->hit_count))
+	    (info->seconds || info->hit_count ||
+		(info->check_set & XT_RECENT_MODIFIERS)))
 		return false;
 	if (info->hit_count > ip_pkt_list_tot) {
 		pr_info(KBUILD_MODNAME ": hitcount (%u) is larger than "
-- 
1.7.0


--------------050305040604010803030705--
