From: Tim Gardner <timg@tpi.com>
Subject: Re: linux-next netfilter: xt_recent: Add an entry reaper
Date: Mon, 01 Mar 2010 13:24:04 -0700
Message-ID: <4B8C2264.2040808@tpi.com>
References: <20100228033841.265CFF8BB0@sepang.rtg.net>	 <1267331677.9082.46.camel@edumazet-laptop>  <4B8AB4BE.7080206@tpi.com>	 <1267388436.9082.84.camel@edumazet-laptop>  <4B8AF877.4080001@tpi.com> <1267409855.9082.103.camel@edumazet-laptop>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020006060000010601090702"
Cc: kaber@trash.net, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <1267409855.9082.103.camel@edumazet-laptop>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020006060000010601090702
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Eric Dumazet wrote:
> Le dimanche 28 février 2010 à 16:12 -0700, Tim Gardner a écrit :
> 
>> You are right about the reaper pointer. I'd forgotten that the LRU list
>> was already sorted oldest to newest. Doh! I've cleaned that up some.
>>
>> This version adds the '--reap' flag and only looks at the head of the
>> LRU list once per ip_reaper_freq packets.
>>
>> I also added a check that makes sure --rttl and --reap modify only the
>> --rcheck and --update options.
>>
>> rtg
> 
> @@ -272,6 +295,16 @@ recent_mt(const struct sk_buff *skb, const struct
> xt_match_param *par)
>                                 break;
>                         }
>                 }
> +
> +               /*
> +                * Run the reaper every ip_reaper_freq packets.
> +                */
> +               if ((info->check_set & XT_RECENT_REAP) &&
> +                   info->seconds &&
> 
> This (info->seconds) test is redundant, if you test it _once_ in
> recent_mt_check()
> 
> +                   (++t->reaper_cnt >= ip_reaper_freq)) {
> +                       t->reaper_cnt = 0;
> +                       recent_entry_reap(t, time);
> +               }
>         }
> 
> 
> ie :
> 
> diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
> index fc70a49..66d68f3 100644
> --- a/net/netfilter/xt_recent.c
> +++ b/net/netfilter/xt_recent.c
> @@ -294,6 +294,8 @@ static bool recent_mt_check(const struct
> xt_mtchk_param *par)
>         if ((info->check_set & (XT_RECENT_SET | XT_RECENT_REMOVE)) &&
>             (info->seconds || info->hit_count))
>                 return false;
> +       if ((info->check_set & XT_RECENT_REAP) && !info->seconds)
> +               return false;
>         if (info->hit_count > ip_pkt_list_tot)
>                 return false;
>         if (info->name[0] == '\0' ||
> 
> 
> 
> Then, now that reaping is done as a rule option only, I am not sure we
> still need the reaper_cnt logic, since you probably want ip_reaper_freq
> = 1, or else table size will probably grow at its limit, even in non DOS
> situation.
> 
> 
> 

Agreed, see attached.

-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357

--------------020006060000010601090702
Content-Type: text/x-patch;
 name="0001-netfilter-xt_recent-Add-an-entry-reaper-V4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-netfilter-xt_recent-Add-an-entry-reaper-V4.patch"

>From 3cd53e6474b307bba448103865bed63ffe81b626 Mon Sep 17 00:00:00 2001
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


--------------020006060000010601090702--
