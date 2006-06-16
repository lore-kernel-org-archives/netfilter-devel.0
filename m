From: Amin Azez <azez@ufomechanic.net>
Subject: [PATCH] ipt_account rate patch
Date: Fri, 16 Jun 2006 15:24:08 +0100
Message-ID: <e6ueuc$qsq$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080003020407020006030803"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080003020407020006030803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Here are some patches I did for ipt_account before ipt_ACCOUNT which
supports larger subnets was re-released.

As well as per-ip packet and byte counting, the patches also does per-ip
rate calculating, so you can use this as part of a rate limiting rule
and drop packets that would exceed the rate.

You get to choose whether or not dropped packets should also be accounted.

Just as ipt_account supports total-subnet accounting, so we also support
total-subnet rate calculations as well.

The rate calculations are an improved version of what is in
ip_conntrack_rate.c, namely we can handle the timer wraps around zero.

Sam

--------------080003020407020006030803
Content-Type: text/plain;
 name="libipt_account_rate.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libipt_account_rate.diff"

--- extensions/libipt_account.c.rate	2006-05-16 11:14:35.000000000 +0100
+++ extensions/libipt_account.c	2006-05-16 15:23:38.000000000 +0100
@@ -34,14 +34,50 @@
 			"--ashort\n"
 			"       table will colect only short statistics (only total counters\n"
 			"       without splitting it into protocols.\n"
+			"--non-subnet\n"
+			"	Traffic whose src or dst ip is not in the account subnet\n"
+			"	should be counted as matching, even though no rate tests\n"
+			"	can be done.\n"
+			"--above\n"
+			"       Matches if any of the ranges are exceeded\n"
+			"--below\n"
+			"       (Default) Matches if none of the ranges are exceeded\n"
+			"[!] --src-rate rate\n"
+			"       TRUE if IP-specific rate on packets from that subnets [not] in range\n"
+			"[!] --src-subnet-rate\n"
+			"       TRUE if rate on all packets from that subnets [not] in range\n"
+			"[!] --dst-rate rate\n"
+			"       TRUE if IP-specific rate on packets to that subnets [not] in range\n"
+			"[!] --dst-subnet-rate rate\n"
+			"       TRUE if rate on all packets to that subnets [not] in range\n"
+			"--ignore-src-over\n"
+			"       Don't count packets if rate is exceeded.\n"
+			"       Perhaps Use this if you intend to drop such packets.\n"
+			"--ignore-dst-over\n"
+			"       Don't count packets if rate is exceeded.\n"
+			"       Perhaps Use this if you intend to drop such packets.\n"
+			"--check-only\n"
+			"       Don't count packets at all, just check decayed rate to\n"
+			"       calculate if the packet would have been dropped.\n"
 	, 
 	IPTABLES_VERSION);
 };
 
 static struct option opts[] = {
-	{ .name = "aaddr",  .has_arg = 1, .flag = NULL, .val = 201 },
-	{ .name = "aname",  .has_arg = 1, .flag = NULL, .val = 202 },
-	{ .name = "ashort", .has_arg = 0, .flag = NULL, .val = 203 },
+	{ .name = "aaddr",             .has_arg = 1, .flag = NULL, .val = 201 },
+	{ .name = "aname",             .has_arg = 1, .flag = NULL, .val = 202 },
+	{ .name = "ashort",            .has_arg = 0, .flag = NULL, .val = 203 },
+	{ .name = "src-rate",          .has_arg = 1, .flag = NULL, .val = 204 },
+	{ .name = "src-subnet-rate",   .has_arg = 1, .flag = NULL, .val = 205 },
+	{ .name = "dst-rate",          .has_arg = 1, .flag = NULL, .val = 206 },
+	{ .name = "dst-subnet-rate",   .has_arg = 1, .flag = NULL, .val = 207 },
+	{ .name = "ignore-src-over",   .has_arg = 0, .flag = NULL, .val = 208 },
+	{ .name = "ignore-dst-over",   .has_arg = 0, .flag = NULL, .val = 209 },
+	{ .name = "check-only",        .has_arg = 0, .flag = NULL, .val = 210 },
+	{ .name = "not",               .has_arg = 0, .flag = NULL, .val = 211 },
+	{ .name = "above",             .has_arg = 0, .flag = NULL, .val = 211 },
+	{ .name = "below",             .has_arg = 0, .flag = NULL, .val = 212 },
+	{ .name = "non-subnet",        .has_arg = 0, .flag = NULL, .val = 213 },
 	{ .name = 0, .has_arg = 0, .flag = 0, .val = 0 }
 };
 
@@ -206,6 +242,39 @@
 		case 203:
 			info->shortlisting = 1;
 			break;
+		case 204:
+			info->src_rate=atoi(optarg);
+			if (invert) info->accounting|=IPT_ACCOUNT_INVERT_src_RATE;
+			break;
+		case 205:
+			info->src_subnet_rate=atoi(optarg);
+			if (invert) info->accounting|=IPT_ACCOUNT_INVERT_src_SUBNET_RATE;
+			break;
+		case 206:
+			info->dest_rate=atoi(optarg);
+			if (invert) info->accounting|=IPT_ACCOUNT_INVERT_dest_RATE;
+			break;
+		case 207:
+			info->dest_subnet_rate=atoi(optarg);
+			if (invert) info->accounting|=IPT_ACCOUNT_INVERT_dest_SUBNET_RATE;
+			break;
+		case 208:
+			info->accounting|=IPT_ACCOUNT_src_OVER;
+			break;
+		case 209:
+			info->accounting|=IPT_ACCOUNT_dest_OVER;
+			break;
+		case 210:
+			info->accounting|=IPT_ACCOUNT_CHECKONLY;
+			break;
+		case 211:
+			info->accounting|=IPT_ACCOUNT_INVERT;
+			break;
+		case 212: /* we default to below */
+			break;
+		case 213:
+			info->accounting|=IPT_ACCOUNT_INVERT_NAME;
+			break;
 		default:
 			return 0;			
 	}
@@ -235,6 +304,30 @@
 	printf("name: %s ", info->name);
 	if (info->shortlisting)
 		printf("short-listing ");
+	
+	if ((info->accounting & IPT_ACCOUNT_INVERT) && (info->src_rate || info->src_subnet_rate || info->dest_rate || info->dest_subnet_rate))
+		printf("NOT ");
+	printf("(");
+	if (info->src_rate)
+		printf("src-rate: %c %u B/s ",(info->accounting & IPT_ACCOUNT_INVERT_src_RATE)?'>':'<',info->src_rate);
+
+	if (info->src_subnet_rate)
+		printf("src-subnet-rate: %c %u B/s ",(info->accounting & IPT_ACCOUNT_INVERT_src_SUBNET_RATE)?'>':'<',info->src_subnet_rate);
+
+	if (info->dest_rate)
+		printf("dst-rate: %c %u B/s ",(info->accounting & IPT_ACCOUNT_INVERT_dest_RATE)?'>':'<',info->dest_rate);
+
+	if (info->dest_subnet_rate)
+		printf("dst-subnet-rate: %c %u B/s ",(info->accounting & IPT_ACCOUNT_INVERT_dest_SUBNET_RATE)?'>':'<',info->dest_subnet_rate);
+	printf(") ");
+	if (info->accounting & IPT_ACCOUNT_src_OVER)
+		printf("ignore-src-over ");
+
+	if (info->accounting & IPT_ACCOUNT_dest_OVER)
+		printf("ignore-dst-over ");
+
+	if (info->accounting & IPT_ACCOUNT_CHECKONLY)
+		printf("check-only ");
 }
 
 /* Function used for saving rule containing account match */
@@ -252,6 +345,41 @@
 	printf("--aname %s ", info->name);
 	if (info->shortlisting)
 		printf("--ashort ");
+
+	if ((info->accounting & IPT_ACCOUNT_INVERT_NAME))
+		printf("--non-subnet ");
+
+	if ((info->accounting & IPT_ACCOUNT_INVERT) && (info->src_rate || info->src_subnet_rate || info->dest_rate || info->dest_subnet_rate))
+		printf("--above ");
+
+	if (info->src_rate) {
+		if (info->accounting & IPT_ACCOUNT_INVERT_src_RATE) printf("! ");
+		printf("--src-rate %u ",info->src_rate);
+	}
+
+	if (info->src_subnet_rate) {
+		if (info->accounting & IPT_ACCOUNT_INVERT_src_SUBNET_RATE) printf("! ");
+		printf("--src-subnet-rate %u ",info->src_subnet_rate);
+	}
+
+	if (info->dest_rate) {
+		if (info->accounting & IPT_ACCOUNT_INVERT_dest_RATE) printf("! ");
+		printf("--dst-rate %d ",info->dest_rate);
+	}
+
+	if (info->dest_subnet_rate) {
+		if (info->accounting & IPT_ACCOUNT_INVERT_dest_SUBNET_RATE) printf("! ");
+		printf("--dst-subnet-rate %d ",info->dest_subnet_rate);
+	}
+
+	if (info->accounting & IPT_ACCOUNT_src_OVER)
+		printf("--ignore-src-over ");
+
+	if (info->accounting & IPT_ACCOUNT_dest_OVER)
+		printf("--ignore-dst-over ");
+
+	if (info->accounting & IPT_ACCOUNT_CHECKONLY)
+		printf("--check-only ");
 }
 	
 static struct iptables_match account = {

--------------080003020407020006030803
Content-Type: text/x-patch;
 name="ipt_account_rate.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="ipt_account_rate.patch"

--- net/ipv4/netfilter/ipt_account.c	2006-06-16 14:12:09.000000000 +0100
+++ net/ipv4/netfilter/ipt_account.c	2006-05-23 13:04:41.000000000 +0100
@@ -1,14 +1,20 @@
 /* 
  * accounting match (ipt_account.c)
  * (C) 2003,2004 by Piotr Gasidlo (quaker@barbara.eu.org)
+ * (C) 2006 by UFO Mechanic <azez@ufomechanic.net>
+ *     added rate calculations based on connrate, ip_conntrack_rate.c
+ *     - which is Copyright (c) 2004 Nuutti Kotivuori <naked@iki.fi>
  *
  * Version: 0.1.7
  *
  * This software is distributed under the terms of GNU GPL
  */
 
+#include <linux/config.h>
 #include <linux/module.h>
+#include <linux/types.h>
 #include <linux/skbuff.h>
+#include <linux/jiffies.h>
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
@@ -33,7 +39,7 @@
 #endif
 
 static char version[] =
-KERN_INFO IPT_ACCOUNT_NAME " " IPT_ACCOUNT_VERSION " : Piotr Gasid³o <quaker@barbara.eu.org>, http://www.barbara.eu.org/~quaker/ipt_account/\n";
+KERN_INFO IPT_ACCOUNT_NAME " " IPT_ACCOUNT_VERSION " : Piotr GasidÂ³o <quaker@barbara.eu.org>, http://www.barbara.eu.org/~quaker/ipt_account/\n";
 
 /* rights for files created in /proc/net/ipt_account/ */
 static int permissions = 0644;
@@ -49,31 +55,118 @@
 MODULE_PARM_DESC(permissions,"permissions on /proc/net/ipt_account/* files");
 MODULE_PARM_DESC(netmask, "maximum *save* size of one list (netmask)");
 
+/* Notes from: ip_conntrack_rate.c by Nuutti Kotivuori <naked@iki.fi>
+   I wanted to build a simpler and more robust rate estimator than the
+   one used in sched/estimator.c. After evaluating a few choices I
+   settled with the one given in an example in [RFC2859], which is the
+   rate estimator described in [TON98].
+
+   I will copy the example table from [RFC2859] here:
+
+========================================================================
+|Initially:                                                            |
+|                                                                      |
+|      AVG_INTERVAL = a constant;                                      |
+|      avg-rate     = CTR;                                             |
+|      t-front      = 0;                                               |
+|                                                                      |
+|Upon each packet's arrival, the rate estimator updates its variables: |
+|                                                                      |
+|      Bytes_in_win = avg-rate * AVG_INTERVAL;                         |
+|      New_bytes    = Bytes_in_win + pkt_size;                         |
+|      avg-rate     = New_bytes/( now - t-front + AVG_INTERVAL);       |
+|      t-front      = now;                                             |
+|                                                                      |
+|Where:                                                                |
+|      now          = The time of the current packet arrival           |
+|      pkt_size     = The packet size in bytes of the arriving packet  |
+|      avg-rate     = Measured Arrival Rate of traffic stream          |
+|      AVG_INTERVAL = Time window over which history is kept           |
+|                                                                      |
+|                                                                      |
+|              Figure 2. Example Rate Estimator Algorithm              |
+|                                                                      |
+========================================================================
+
+   Additionally we have to be concerned about overflows, remainders
+   and resolution in the algorithm. These are documented in the code
+   below.
+
+   References:
+
+   [RFC2859] W. Fang, N. Seddigh and B. Nandy, "A Time Sliding Window
+             Three Colour Marker (TSWTCM)", RFC 2859, June 2000.
+
+   [TON98]   D.D. Clark, W. Fang, "Explicit Allocation of Best Effort
+             Packet Delivery Service", IEEE/ACM Transactions on
+             Networking, August 1998, Vol 6. No. 4, pp. 362-373.
+*/
+
+/* There are three important limits which need to be explored: maximum
+   expressable rate, minimum expressable rate, minimum packet size to
+   be countable.
+
+   Maximum expressable rate depends on the size of the window and the
+   scale we have chosen. It is approximately 2^32 / window /
+   scale. For example with a window of 3 seconds and a scale of 100,
+   the maximum rate is 14 megabytes per second, eg. 115Mbit/s.
+
+   Minimum expressable rate depends on scale and the HZ on the
+   architecture. It is HZ / scale. For example on most platforms where
+   HZ is now 1000, this is 10 bytes per second, eg. 0.08kbit/s.
+
+   Minimum packet size to be countable depends on the window size,
+   scale and HZ. This is basically the smallest packet that when
+   arriving immediately after the previous packet can cause the
+   average rate to rise from zero to one. It is (HZ * window) /
+   scale. For example with a window of 3 seconds, a scale of 100 and a
+   HZ of 1000, this would be 30. That is, a continuous stream of
+   packets less than 30 bytes long would not be able to rise the rate
+   above zero.
+
+   These limitations are a simple consequence of the current
+   implementation using integer arithmetics. */
+
+/* Maximum number of tokens in total that we can have in a window is
+   limited by the range of the u_int32_t datatype. We prevent the
+   overflow of this by first calculating the maximum amount of tokens
+   a single packet can add and substracting that from the maximum
+   value the window can get. */
+#define MAX_PACKET_IN_TOKENS (0x0000ffff * IP_CONNTRACK_RATE_SCALE)
+#define MAX_TOKENS_IN_WINDOW (0xffffffff - MAX_PACKET_IN_TOKENS)
+
+/* estimation interval, in jiffies */
+#define IP_CONNTRACK_RATE_INTERVAL (3 * HZ)
+
+/* scale on how many tokens per byte to generate */
+#define IP_CONNTRACK_RATE_SCALE 100
+
 /* structure with statistics counters */
 struct t_ipt_account_stat {
 	u_int64_t b_all, b_tcp, b_udp, b_icmp, b_other;		/* byte counters for all/tcp/udp/icmp/other traffic  */
 	u_int64_t p_all, p_tcp, p_udp, p_icmp, p_other;		/* packet counters for all/tcp/udp/icmp/other traffic */
+	u_int32_t avgrate;					/* rate data for all traffic, tokens per jiffy */
+	unsigned long time;					/* time when this record was last updated */	
 };
 
 /* stucture with statistics counters, used when table is created with --ashort switch */
 struct t_ipt_account_stat_short {
 	u_int64_t b_all;					/* byte counters for all traffic */
 	u_int64_t p_all;					/* packet counters for all traffic */
+	u_int32_t avgrate;					/* rate data for all traffic, tokens per jiffy */
+	unsigned long time;					/* time when this record was last updated */	
 };
  
 /* structure holding to/from statistics for single ip */
 struct t_ipt_account_ip_list {
 	struct t_ipt_account_stat src;
 	struct t_ipt_account_stat dest;
-	unsigned long time;					/* time when this record was last updated */	
-	
 };
 
 /* same as above, for tables with --ashort switch */
 struct t_ipt_account_ip_list_short {
 	struct t_ipt_account_stat_short src;
 	struct t_ipt_account_stat_short dest;
-	unsigned long time;
 };
 
 /* structure describing single table */
@@ -101,6 +194,44 @@
 /* root pointer holding list of the tables */
 static struct t_ipt_account_table *account_tables = NULL;
 
+/* rate calculations taken from conntrack_rate_count in ip_conntrack_rate.c */
+/* NOTE: this is not bits/second tokens/jiffy, use get_rate to convert */
+static inline u_int32_t
+calc_new_rate(u_int32_t avgrate, unsigned int len, unsigned long then, unsigned long now)
+{
+        u_int32_t new_bytes;
+	u_int32_t interval;
+
+        new_bytes = (avgrate * IP_CONNTRACK_RATE_INTERVAL +
+                     len * IP_CONNTRACK_RATE_SCALE);
+        if(new_bytes > MAX_TOKENS_IN_WINDOW)
+                new_bytes = MAX_TOKENS_IN_WINDOW;
+
+	/* if timer wrapped back past zero then interval is distance each side of zero */
+	if(time_before(now,then)) interval=now+(MAX_JIFFY_OFFSET-then);
+	else interval=now-then;
+
+	return new_bytes / (interval + IP_CONNTRACK_RATE_INTERVAL);
+}
+
+/* do_rate_count taken from conntrack_rate_count in ip_conntrack_rate.c */
+/* account struct must already be locked for us */
+static inline void
+do_rate_count(u_int32_t *avgrate, unsigned int len, unsigned long then, unsigned long now)
+{
+	*avgrate = calc_new_rate(*avgrate, len, then, now);
+}
+
+/* do rate conversions from tokens per jiffy to bytes per second */
+static inline u_int32_t rate_get(u_int32_t rate) {
+	return rate * HZ / IP_CONNTRACK_RATE_SCALE;
+}
+
+/* use new timestamp, return in b/second */
+static inline u_int32_t rate_now_get(u_int32_t rate, unsigned long then, unsigned long now) {
+	return calc_new_rate(rate,0,then,now) * HZ / IP_CONNTRACK_RATE_SCALE;
+}
+
 /* convert ascii to ip */
 int atoip(char *buffer, u_int32_t *ip) {
 
@@ -355,7 +486,8 @@
 			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() updating row.\n");
 			spin_lock_bh(&table->ip_list_lock);
 			/* update counters, do not overwrite time field */
-			memcpy(&table->ip_list.l[ip - table->network], &l, sizeof(struct t_ipt_account_ip_list) - sizeof(unsigned long));
+			memcpy(&table->ip_list.l[ip - table->network].src, &l.src, sizeof(l.src) - sizeof(unsigned long));
+			memcpy(&table->ip_list.l[ip - table->network].dest, &l.dest, sizeof(l.dest) - sizeof(unsigned long));
 			spin_unlock_bh(&table->ip_list_lock);
 		} else {
 			memset(&s, 0, sizeof(struct t_ipt_account_ip_list_short));
@@ -436,7 +568,10 @@
 			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() updating row.\n");
 			spin_lock_bh(&table->ip_list_lock);
 			/* update counters, do not overwrite time field */
-			memcpy(&table->ip_list.s[ip - table->network], &s, sizeof(struct t_ipt_account_ip_list_short) - sizeof(unsigned long));
+			/* Sam - I don't like this implied knowledge that time is the last item in the struct
+			 * or that the implied knowledge of the packed-ness of the struct */
+			memcpy(&table->ip_list.s[ip - table->network].src, &s.src, sizeof(s.src) - sizeof(unsigned long));
+			memcpy(&table->ip_list.s[ip - table->network].dest, &s.dest, sizeof(s.dest) - sizeof(unsigned long));
 			spin_unlock_bh(&table->ip_list_lock);
 		}
 	}
@@ -453,12 +588,15 @@
 	unsigned int *bucket = (unsigned int *)v;
 
 	u_int32_t address = table->network + *bucket;
+	unsigned long now = jiffies;
 	struct timespec last;
 
 	if (!table->shortlisting) {
-		jiffies_to_timespec(jiffies - table->ip_list.l[*bucket].time, &last);
+		unsigned long src_then = table->ip_list.l[*bucket].src.time;
+		unsigned long dest_then = table->ip_list.l[*bucket].dest.time;
+		jiffies_to_timespec(min(now - src_then, now - dest_then), &last);
 		seq_printf(s,
-				"ip = %u.%u.%u.%u bytes_src = %llu %llu %llu %llu %llu packets_src = %llu %llu %llu %llu %llu bytes_dest = %llu %llu %llu %llu %llu packets_dest = %llu %llu %llu %llu %llu time = %lu\n",
+				"ip = %u.%u.%u.%u bytes_src = %llu %llu %llu %llu %llu packets_src = %llu %llu %llu %llu %llu rate_src = %u bytes_dest = %llu %llu %llu %llu %llu packets_dest = %llu %llu %llu %llu %llu rate_dest = %u time = %lu\n",
 				HIPQUAD(address),
 				table->ip_list.l[*bucket].src.b_all,
 				table->ip_list.l[*bucket].src.b_tcp,
@@ -470,6 +608,7 @@
 				table->ip_list.l[*bucket].src.p_udp,
 				table->ip_list.l[*bucket].src.p_icmp,
 				table->ip_list.l[*bucket].src.p_other,
+				rate_now_get(table->ip_list.l[*bucket].src.avgrate,src_then,now),
 				table->ip_list.l[*bucket].dest.b_all,
 				table->ip_list.l[*bucket].dest.b_tcp,
 				table->ip_list.l[*bucket].dest.b_udp,
@@ -480,17 +619,22 @@
 				table->ip_list.l[*bucket].dest.p_udp,
 				table->ip_list.l[*bucket].dest.p_icmp,
 				table->ip_list.l[*bucket].dest.p_other,
+				rate_now_get(table->ip_list.l[*bucket].dest.avgrate,dest_then,now),
 				last.tv_sec
 			);
 	} else {
-		jiffies_to_timespec(jiffies - table->ip_list.s[*bucket].time, &last);
+		unsigned long src_then = table->ip_list.s[*bucket].src.time;
+		unsigned long dest_then = table->ip_list.s[*bucket].dest.time;
+		jiffies_to_timespec(min(now - src_then, now - dest_then), &last);
 		seq_printf(s,
-				"ip = %u.%u.%u.%u bytes_src = %llu packets_src = %llu bytes_dest = %llu packets_dest = %llu time = %lu\n",
+				"ip = %u.%u.%u.%u bytes_src = %llu packets_src = %llu rate_src = %u bytes_dest = %llu packets_dest = %llu rate_dest = %u time = %lu\n",
 				HIPQUAD(address),
 				table->ip_list.s[*bucket].src.b_all,
 				table->ip_list.s[*bucket].src.p_all,
+				rate_now_get(table->ip_list.s[*bucket].src.avgrate,src_then,now),
 				table->ip_list.s[*bucket].dest.b_all,
 				table->ip_list.s[*bucket].dest.p_all,
+				rate_now_get(table->ip_list.s[*bucket].dest.avgrate,dest_then,now),
 				last.tv_sec
 			  );
 	}
@@ -530,7 +674,7 @@
 	/* update packet & bytes counters in *stat structure */
 	stat->b_all += skb->len;
 	stat->p_all++;
-	
+
 	switch (skb->nh.iph->protocol) {
 		case IPPROTO_TCP:
 			stat->b_tcp += skb->len;
@@ -548,6 +692,7 @@
 			stat->b_other += skb->len;
 			stat->p_other++;
 	}
+
 }
 
 static inline void do_account_short(struct t_ipt_account_stat_short *stat, const struct sk_buff *skb) {
@@ -557,6 +702,64 @@
 	stat->p_all++;
 }
 
+/* This block of code would have been repeated 4 times but was factored to
+ * make a #parameterized #define block. The algorithm is kept simple clear
+ * and implemented accurately in each place */
+
+/* assemble proper mask name based on direction */
+#define IPT_ACCOUNT_RULE(DIRECTION) IPT_ACCOUNT_ ## DIRECTION ## _OVER
+/* DIRECTION = src/dest
+ * SL=s/l for short or long
+ * ADDRESS=src_address/dest_address 
+ * SHORT=_short if short */
+#define DO_ACCOUNT(DIRECTION,SL,ADDRESS,SHORT) do { /* gives us scope as well as ; */ \
+	/* update counters this host */ \
+	int limit=0; \
+	u_int32_t ip_index=ADDRESS - table->network; \
+\
+	/* If we are limiting, calc what decayed rate would be by now */ \
+	if (info->DIRECTION ## _rate) { \
+		/* these rates are tokens/jiffy */ \
+		u_int32_t rate=rate_get(calc_new_rate(table->ip_list.SL[ip_index].DIRECTION.avgrate,0, \
+		     table->ip_list.SL[ip_index].DIRECTION.time,now)); \
+		if (((info->accounting & IPT_ACCOUNT_INVERT_ ## DIRECTION ## _RATE) != 0) ^ \
+		    (rate > info->DIRECTION ## _rate) ) { \
+				limit++; /* record failure */ \
+		} \
+	} \
+	/* If we are subnet limiting, calc what decayed rate would be by now */ \
+	if (info->DIRECTION ## _subnet_rate) { \
+		/* these rates are tokens/jiffy */ \
+		u_int32_t subnet_rate=rate_get(calc_new_rate(table->ip_list.SL[0].DIRECTION.avgrate,0, \
+		     table->ip_list.SL[0].DIRECTION.time,now)); \
+		if (((info->accounting & IPT_ACCOUNT_INVERT_ ## DIRECTION ## _SUBNET_RATE) != 0) ^ \
+		    (subnet_rate > info->DIRECTION ## _subnet_rate) ) { \
+				limit++; /* record failure */ \
+		} \
+	} \
+\
+	/* Now account for this data, unless over limit AND told not to count over-limit */ \
+	if (! limit || 0==(info->accounting & IPT_ACCOUNT_RULE(DIRECTION))) { \
+		do_account ## SHORT(&table->ip_list.SL[ip_index].DIRECTION, skb); \
+		do_rate_count(&table->ip_list.SL[ip_index].DIRECTION.avgrate, \
+			skb->len,table->ip_list.SL[ip_index].DIRECTION.time, now); \
+		table->ip_list.SL[ip_index].DIRECTION.time = now; \
+\
+		/* update also counters for all hosts in this table (network address) */ \
+		if (table->netmask != INADDR_BROADCAST) { \
+			do_account ## SHORT(&table->ip_list.SL[0].DIRECTION, skb); \
+			do_rate_count(&table->ip_list.SL[0].DIRECTION.avgrate, \
+				skb->len,table->ip_list.SL[0].DIRECTION.time, now); \
+			table->ip_list.SL[0].DIRECTION.time = now; \
+		} \
+	} \
+	failed+=limit; /* combine failures */ \
+} while(0)
+
+/* Change of semantics here when rate is added.
+ * Normally TRUE is returned if the packet is accounted in the subnet otherwise FALSE
+ * Now, if a rate arguments are passed  then FALSE is returned if that rate check fails
+ */
 static int match(const struct sk_buff *skb,
 	  const struct net_device *in,
 	  const struct net_device *out,
@@ -568,10 +771,18 @@
 	const struct t_ipt_account_info *info = (struct t_ipt_account_info*)matchinfo;
 	struct t_ipt_account_table *table;
 	int ret;
+	int failed=0;
+	int sets=0; /* count how many times we are found in the set, 0,1,2 */
 	unsigned long now;
 
-	u_int32_t address;
-	
+	/* Two complex cases:
+	 * 1. the src and dest ip are in the same subnet - if so we must not update the subnet time in src
+	 * 2. the src and dest ip are the same - if so we must not update the ip time in src 
+	 * These cases require us to pre-calculate some values */
+			
+	u_int32_t src_address;
+	u_int32_t dest_address;
+
 	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() entered.\n");
 	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() match name = %s.\n", info->name);
 	
@@ -592,68 +803,60 @@
 	/*  lock table while updating statistics */
 	spin_lock_bh(&table->ip_list_lock);
 
-	/* default: no match */
+	/* default: false */
 	ret = 0;
 
 	/* get current time */
 	now = jiffies;
 
 	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() got packet src = %u.%u.%u.%u, dst = %u.%u.%u.%u, proto = %u.\n", NIPQUAD(skb->nh.iph->saddr), NIPQUAD(skb->nh.iph->daddr), skb->nh.iph->protocol);
-			
+
 	/* check whether traffic from source ip address ... */
-	address = ntohl(skb->nh.iph->saddr);
+	src_address = ntohl(skb->nh.iph->saddr);
+	dest_address = ntohl(skb->nh.iph->daddr);
 	/* ... is being accounted by this table */	
-	if (address && ((u_int32_t)(address & table->netmask) == (u_int32_t)table->network)) {		
+	if (src_address && ((u_int32_t)(src_address & table->netmask) == (u_int32_t)table->network)) {		
 		/* yes, account this packet */
-		dprintk(KERN_INFO "ipt_account: match() accounting packet src = %u.%u.%u.%u, proto = %u.\n", HIPQUAD(address), skb->nh.iph->protocol);
+		dprintk(KERN_INFO "ipt_account: match() accounting packet src = %u.%u.%u.%u, proto = %u.\n", HIPQUAD(src_address), skb->nh.iph->protocol);
 		/* update counters this host */
 		if (!table->shortlisting) {
-			do_account(&table->ip_list.l[address - table->network].src, skb);
-			table->ip_list.l[address - table->network].time = now;
-			/* update also counters for all hosts in this table (network address) */
-			if (table->netmask != INADDR_BROADCAST) {
-				do_account(&table->ip_list.l[0].src, skb);
-				table->ip_list.l[0].time = now;
-			}
+			DO_ACCOUNT(src,l,src_address,);
 		} else {
-			do_account_short(&table->ip_list.s[address - table->network].src, skb);
-			table->ip_list.s[address - table->network].time = now;
-			/* update also counters for all hosts in this table (network address) */
-			if (table->netmask != INADDR_BROADCAST) {
-				do_account_short(&table->ip_list.s[0].src, skb);
-				table->ip_list.s[0].time = now;
-			}
+			DO_ACCOUNT(src,s,src_address,_short);
 		}
 		/* yes, it's a match */
-		ret = 1;
+		sets ++;
 	}
 
 	/* do the same thing with destination ip address */
-	address = ntohl(skb->nh.iph->daddr);
-	if (address && ((u_int32_t)(address & table->netmask) == (u_int32_t)table->network)) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() accounting packet dst = %u.%u.%u.%u, proto = %u.\n", HIPQUAD(address), skb->nh.iph->protocol);
+	if (dest_address && ((u_int32_t)(dest_address & table->netmask) == (u_int32_t)table->network)) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() accounting packet dst = %u.%u.%u.%u, proto = %u.\n", HIPQUAD(dest_address), skb->nh.iph->protocol);
 		if (!table->shortlisting) {
-			do_account(&table->ip_list.l[address - table->network].dest, skb);
-			table->ip_list.l[address - table->network].time = now;
-			if (table->netmask != INADDR_BROADCAST) {
-				do_account(&table->ip_list.l[0].dest, skb);				
-				table->ip_list.s[0].time = now;
-			}
+			DO_ACCOUNT(dest,l,dest_address,);
 		} else {
-			do_account_short(&table->ip_list.s[address - table->network].dest, skb);
-			table->ip_list.s[address - table->network].time = now;
-			if (table->netmask != INADDR_BROADCAST) {
-				do_account_short(&table->ip_list.s[0].dest, skb);
-				table->ip_list.s[0].time = now;
-			}
+			DO_ACCOUNT(dest,s,dest_address,_short);
 		}
-		ret = 1;
+		sets++;
 	}
 	spin_unlock_bh(&table->ip_list_lock);
 	
 	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() left.\n");	
 
-	return ret;
+	/* if sets is zero it means we did no rate tests */
+	if (sets) {
+		/* failed is >1 if any rate tests failed, now normalize this with IPT_ACCOUNT_INVERT */
+		failed=((failed!=0) ^ ((info->accounting & IPT_ACCOUNT_INVERT)!=0));
+	} else { 
+/* let INVERT_NAME be whether no sets is a failure or not */
+		failed=((sets==0) ^ ((info->accounting & IPT_ACCOUNT_INVERT_NAME)!=0));
+	}
+
+	if (failed) {
+		return 0;
+	} else {
+		return 1;
+	}
+	return 1;
 }
 
 static int checkentry(const char *tablename,
--- include/linux/netfilter_ipv4/ipt_account.h	2005-07-08 13:11:25.000000000 +0100
+++ include/linux/netfilter_ipv4/ipt_account.h	2006-05-16 10:58:00.000000000 +0100
@@ -13,13 +13,32 @@
 #define IPT_ACCOUNT_NAME_LEN 64
 
 #define IPT_ACCOUNT_NAME "ipt_account"
-#define IPT_ACCOUNT_VERSION  "0.1.7"
+#define IPT_ACCOUNT_VERSION  "0.1.7-rate"
+
+/* Whether or not to account for packets which go over permitted rate 
+ * If these are going to be dropped, it may be better not to count */
+
+#define IPT_ACCOUNT_src_OVER                1 << 0
+#define IPT_ACCOUNT_dest_OVER               1 << 1
+#define IPT_ACCOUNT_CHECKONLY               1 << 2
+#define IPT_ACCOUNT_INVERT_src_RATE         1 << 3
+#define IPT_ACCOUNT_INVERT_src_SUBNET_RATE  1 << 4
+#define IPT_ACCOUNT_INVERT_dest_RATE        1 << 5
+#define IPT_ACCOUNT_INVERT_dest_SUBNET_RATE 1 << 6
+/* this IPT_ACCOUNT_INVERT is the most useful, the other INVERT are for insane people */
+#define IPT_ACCOUNT_INVERT                  1 << 7
+#define IPT_ACCOUNT_INVERT_NAME             1 << 8
 
 struct t_ipt_account_info {
 	char name[IPT_ACCOUNT_NAME_LEN];
 	u_int32_t network;
 	u_int32_t netmask;
 	int shortlisting:1;
+	int accounting:9;
+	u_int32_t src_rate;
+	u_int32_t src_subnet_rate;
+	u_int32_t dest_rate;
+	u_int32_t dest_subnet_rate;
 };
 
 #endif

--------------080003020407020006030803--
