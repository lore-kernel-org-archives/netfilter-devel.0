From: Tim Gardner <timg@tpi.com>
Subject: dstlimit mods for SRC IP and GC load leveling
Date: Sat, 10 Jan 2004 11:15:02 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401101115.02332.timg@tpi.com>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_2DDAKDLUCWBJ5KKQZ3FR"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------Boundary-00=_2DDAKDLUCWBJ5KKQZ3FR
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Harald,

Attached are some suggested patches for dstlimit. They add the ability to=
=20
limit based on only source IP as well as dest IP and/or dest port. I real=
ize=20
this makes the name of the filter a bit of a misnomer, but it was really =
easy=20
to add source IP only functionality to your filter. I would also like to =
see=20
ICMP limiting added.

The other change is to load level garbage collection. As the number of ha=
sh=20
entries increase, the cost to run garbage collection on the whole hash ta=
ble=20
all at once becomes very expensive.

I've only compiled these changes, so they are not tested. If you like the=
=20
proposed changes, then I have about 1200 test units to try them on.

My thinking is thus:

I work for a wireless ISP. We are deploying Linux based wireless=20
antenna/routers at the edges of our network (at the customer site). One o=
f=20
the problems that I am combatting are viruses on our customer's LANs that=
=20
spew enormous numbers of packets per second (among other abuses). My goal=
=20
with this filter is to limit a particular abuser on the customer's LAN=20
without limiting all IPs on their LAN.

Dstlimit is only one of many that I use to limit outside abuse. I will so=
on=20
submit an extended version of PSD which I call PSD Plus. It uses the weig=
hted=20
connection metaphor as well, but applies it to connections from an IP as =
=20
opposed to connections to an IP.=20

rtg
--=20
Tim Gardner - timg@tpi.com
www.tpi.com 406-443-5357
--------------Boundary-00=_2DDAKDLUCWBJ5KKQZ3FR
Content-Type: text/x-diff;
  charset="us-ascii";
  name="iptables.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="iptables.diff"

diff -r -u --new-file iptables/extensions/libipt_dstlimit.c iptables.wrk/extensions/libipt_dstlimit.c
--- iptables/extensions/libipt_dstlimit.c	Thu Nov 20 03:47:57 2003
+++ iptables.wrk/extensions/libipt_dstlimit.c	Sat Jan 10 08:35:11 2004
@@ -34,6 +34,7 @@
 "                                [Packets per second unless followed by \n"
 "                                /sec /minute /hour /day postfixes]\n"
 "--dstlimit-mode <mode>		mode\n"
+"					srcip\n"
 "					dstip\n"
 "					dstip-destport\n"
 "					srcip-dstip\n"
@@ -202,6 +203,8 @@
 					"--dstlimit-mode");
 		if (!strcmp(optarg, "dstip"))
 			r->mode = IPT_DSTLIMIT_HASH_DIP;
+		else if (!strcmp(optarg, "srcip"))
+			r->mode = IPT_DSTLIMIT_HASH_SIP;
 		else if (!strcmp(optarg, "dstip-destport"))
 			r->mode = IPT_DSTLIMIT_HASH_DIP|IPT_DSTLIMIT_HASH_DPT;
 		else if (!strcmp(optarg, "srcip-dstip"))

--------------Boundary-00=_2DDAKDLUCWBJ5KKQZ3FR
Content-Type: text/x-diff;
  charset="us-ascii";
  name="patch-o-matic-ng.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="patch-o-matic-ng.diff"

diff -r -u --new-file patch-o-matic-ng/dstlimit/help patch-o-matic-ng.wrk/dstlimit/help
--- patch-o-matic-ng/dstlimit/help	Thu Dec 18 11:15:29 2003
+++ patch-o-matic-ng.wrk/dstlimit/help	Sat Jan 10 09:13:22 2004
@@ -5,6 +5,7 @@
 
 It gives you the ability to say 
 	'1000 packets per second for every host in 192.168.0.0/16'
+	'1000 packets per second for every host from 192.168.0.0/16'
 	'100 packets per second for every service of 192.168.1.1'
 
 Parameters are:
@@ -12,7 +13,7 @@
 		A rate just like the limit match
 	--dstlimit-burst <num>
 		Burst value, just like limit match
-	--dstlimit-mode destip | destip-destport
+	--dstlimit-mode srcip | destip | destip-destport 
 		Limit per IP or per port
 	--dstlimit-name foo
 		The name for the /proc/net/ipt_dstlimit/foo entry
diff -r -u --new-file patch-o-matic-ng/dstlimit/linux/net/ipv4/netfilter/ipt_dstlimit.c patch-o-matic-ng.wrk/dstlimit/linux/net/ipv4/netfilter/ipt_dstlimit.c
--- patch-o-matic-ng/dstlimit/linux/net/ipv4/netfilter/ipt_dstlimit.c	Thu Dec 18 11:15:29 2003
+++ patch-o-matic-ng.wrk/dstlimit/linux/net/ipv4/netfilter/ipt_dstlimit.c	Sat Jan 10 09:48:14 2004
@@ -81,6 +81,9 @@
 	spinlock_t lock;		/* lock for list_head */
 	u_int32_t rnd;			/* random seed for hash */
 	struct timer_list timer;	/* timer for gc */
+	unsigned int gc_interval;	/* gc interval as a function of
+					   hash table size */
+	int gc_slot;			/* Next gc cleanup slot */
 	atomic_t count;			/* number entries in table */
 
 	/* seq_file stuff */
@@ -210,7 +213,9 @@
 	hinfo->pde->data = hinfo;
 
 	init_timer(&hinfo->timer);
-	hinfo->timer.expires = jiffies + MS2JIFFIES(minfo->gc_interval);
+	hinfo->gc_interval = minfo->gc_interval / minfo->size;
+	if (!hinfo->gc_interval) hinfo->gc_interval = 1000/CLOCKS_PER_SEC;
+	hinfo->timer.expires = jiffies + MS2JIFFIES(hinfo->gc_interval);
 	hinfo->timer.data = (unsigned long )hinfo;
 	hinfo->timer.function = htable_gc;
 	add_timer(&hinfo->timer);
@@ -232,19 +237,21 @@
 		 		int (*select)(struct ipt_dstlimit_htable *ht, 
 					      struct dsthash_ent *he))
 {
-	int i;
+	struct dsthash_ent *dh, *n;
 
 	IP_NF_ASSERT(ht->minfo->size && ht->minfo->max);
 
-	/* lock hash table and iterate over it */
+	/* lock hash table and iterate until one hash bucket gets scanned */
 	LOCK_BH(&ht->lock);
-	for (i = 0; i < ht->minfo->size; i++) {
-		struct dsthash_ent *dh, *n;
-		list_for_each_entry_safe(dh, n, &ht->hash[i], list) {
-			if ((*select)(ht, dh))
-				__dsthash_free(ht, dh);
-		}
+	if (ht->gc_slot >= ht->minfo->size)
+	{
+		ht->gc_slot = 0;
+	}
+	list_for_each_entry_safe(dh, n, &ht->hash[ht->gc_slot], list) {
+		if ((*select)(ht, dh))
+			__dsthash_free(ht, dh);
 	}
+	ht->gc_slot += 1;
 	UNLOCK_BH(&ht->lock);
 }
 
@@ -256,7 +263,7 @@
 	htable_selective_cleanup(ht, select_gc);
 
 	/* re-add the timer accordingly */
-	ht->timer.expires = jiffies + MS2JIFFIES(ht->minfo->gc_interval);
+	ht->timer.expires = jiffies + MS2JIFFIES(ht->gc_interval);
 	add_timer(&ht->timer);
 }
 
@@ -334,8 +341,10 @@
 
 	memset(&dst, 0, sizeof(dst));
 
-	/* dest ip is always in hash */
-	dst.dst_ip = skb->nh.iph->daddr;
+	/* destination ip only if respective hashmode, otherwise set to
+	 * zero */
+	if (r->mode & IPT_DSTLIMIT_HASH_DIP)
+		dst.dst_ip = skb->nh.iph->daddr;
 
 	/* source ip only if respective hashmode, otherwise set to
 	 * zero */

--------------Boundary-00=_2DDAKDLUCWBJ5KKQZ3FR--
