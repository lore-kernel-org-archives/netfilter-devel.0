From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PTCH 2.5.68] netfilter using Read Copy Update
Date: Mon, 28 Apr 2003 14:24:30 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030428062622.5F0FE2C4D3@lists.samba.org>
References: <20030427132413.GP990@sunbeam.de.gnumonks.org>
Cc: Stephen Hemminger <shemminger@osdl.org>,
	netfilter-devel@lists.netfilter.org, davem@redhat.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-reply-to: Your message of "Sun, 27 Apr 2003 15:24:13 +0200."
             <20030427132413.GP990@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <20030427132413.GP990@sunbeam.de.gnumonks.org> you write:
> 
> --K0mDTbuGRobClnW5
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> Content-Transfer-Encoding: quoted-printable
> 
> On Thu, Apr 24, 2003 at 09:04:06AM -0700, Stephen Hemminger wrote:
> > This is an update to netfilter core that uses the read-copy-update
> > instead of brlock.  The code is similar to my earlier patch but less
> > invasive.
> 
> I will try to review this patch and eventually push it to David Miller.

There is a fundamental flaw in the nf_reinject code: when a packet is
reinjected, it makes an attempt to figure out if the hook which sent
it to queue in the first place has vanished, and if so it drops the
packet.

Of course, this is racy (it compares nf_hook_ops addresses) but
"mostly works".  The best solution is to hold a reference to the hook
so it can't vanish.

Stephen, it should be simple for you to rework your patch on top of
this one.

Dave, please apply unless someone has objections.
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.

Name: Add owner field to nf_hook_ops
Author: Rusty Russell
Status: Trivial

D: Adds an owner field to nf_hook_ops, and use it to hold the hook in place
D: for queued packets.

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .18005-linux-2.5.68-bk8/include/linux/netfilter.h .18005-linux-2.5.68-bk8.updated/include/linux/netfilter.h
--- .18005-linux-2.5.68-bk8/include/linux/netfilter.h	2003-01-02 12:32:48.000000000 +1100
+++ .18005-linux-2.5.68-bk8.updated/include/linux/netfilter.h	2003-04-28 13:42:54.000000000 +1000
@@ -47,6 +47,7 @@ struct nf_hook_ops
 
 	/* User fills in from here down. */
 	nf_hookfn *hook;
+	struct module *owner;
 	int pf;
 	int hooknum;
 	/* Hooks are ordered in ascending priority. */
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .18005-linux-2.5.68-bk8/net/bridge/br_netfilter.c .18005-linux-2.5.68-bk8.updated/net/bridge/br_netfilter.c
--- .18005-linux-2.5.68-bk8/net/bridge/br_netfilter.c	2003-04-20 18:05:16.000000000 +1000
+++ .18005-linux-2.5.68-bk8.updated/net/bridge/br_netfilter.c	2003-04-28 13:43:10.000000000 +1000
@@ -572,15 +572,15 @@ static unsigned int ipv4_sabotage_out(un
  * ip_refrag() can return NF_STOLEN.
  */
 static struct nf_hook_ops br_nf_ops[] = {
-	{ { NULL, NULL }, br_nf_pre_routing, PF_BRIDGE, NF_BR_PRE_ROUTING, NF_BR_PRI_BRNF },
-	{ { NULL, NULL }, br_nf_local_in, PF_BRIDGE, NF_BR_LOCAL_IN, NF_BR_PRI_BRNF },
-	{ { NULL, NULL }, br_nf_forward, PF_BRIDGE, NF_BR_FORWARD, NF_BR_PRI_BRNF },
-	{ { NULL, NULL }, br_nf_local_out, PF_BRIDGE, NF_BR_LOCAL_OUT, NF_BR_PRI_FIRST },
-	{ { NULL, NULL }, br_nf_post_routing, PF_BRIDGE, NF_BR_POST_ROUTING, NF_BR_PRI_LAST },
-	{ { NULL, NULL }, ipv4_sabotage_in, PF_INET, NF_IP_PRE_ROUTING, NF_IP_PRI_FIRST },
-	{ { NULL, NULL }, ipv4_sabotage_out, PF_INET, NF_IP_FORWARD, NF_IP_PRI_BRIDGE_SABOTAGE_FORWARD },
-	{ { NULL, NULL }, ipv4_sabotage_out, PF_INET, NF_IP_LOCAL_OUT, NF_IP_PRI_BRIDGE_SABOTAGE_LOCAL_OUT },
-	{ { NULL, NULL }, ipv4_sabotage_out, PF_INET, NF_IP_POST_ROUTING, NF_IP_PRI_FIRST }
+	{ { NULL, NULL }, br_nf_pre_routing, THIS_MODULE, PF_BRIDGE, NF_BR_PRE_ROUTING, NF_BR_PRI_BRNF },
+	{ { NULL, NULL }, br_nf_local_in, THIS_MODULE, PF_BRIDGE, NF_BR_LOCAL_IN, NF_BR_PRI_BRNF },
+	{ { NULL, NULL }, br_nf_forward, THIS_MODULE, PF_BRIDGE, NF_BR_FORWARD, NF_BR_PRI_BRNF },
+	{ { NULL, NULL }, br_nf_local_out, THIS_MODULE, PF_BRIDGE, NF_BR_LOCAL_OUT, NF_BR_PRI_FIRST },
+	{ { NULL, NULL }, br_nf_post_routing, THIS_MODULE, PF_BRIDGE, NF_BR_POST_ROUTING, NF_BR_PRI_LAST },
+	{ { NULL, NULL }, ipv4_sabotage_in, THIS_MODULE, PF_INET, NF_IP_PRE_ROUTING, NF_IP_PRI_FIRST },
+	{ { NULL, NULL }, ipv4_sabotage_out, THIS_MODULE, PF_INET, NF_IP_FORWARD, NF_IP_PRI_BRIDGE_SABOTAGE_FORWARD },
+	{ { NULL, NULL }, ipv4_sabotage_out, THIS_MODULE, PF_INET, NF_IP_LOCAL_OUT, NF_IP_PRI_BRIDGE_SABOTAGE_LOCAL_OUT },
+	{ { NULL, NULL }, ipv4_sabotage_out, THIS_MODULE, PF_INET, NF_IP_POST_ROUTING, NF_IP_PRI_FIRST }
 };
 
 #define NUMHOOKS (sizeof(br_nf_ops)/sizeof(br_nf_ops[0]))
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .18005-linux-2.5.68-bk8/net/bridge/netfilter/ebtable_filter.c .18005-linux-2.5.68-bk8.updated/net/bridge/netfilter/ebtable_filter.c
--- .18005-linux-2.5.68-bk8/net/bridge/netfilter/ebtable_filter.c	2003-03-25 12:17:32.000000000 +1100
+++ .18005-linux-2.5.68-bk8.updated/net/bridge/netfilter/ebtable_filter.c	2003-04-28 13:56:28.000000000 +1000
@@ -70,18 +70,21 @@ ebt_hook (unsigned int hook, struct sk_b
 static struct nf_hook_ops ebt_ops_filter[] = {
 	{
 		.hook		= ebt_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_BRIDGE,
 		.hooknum	= NF_BR_LOCAL_IN,
 		.priority	= NF_BR_PRI_FILTER_BRIDGED,
 	},
 	{
 		.hook		= ebt_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_BRIDGE,
 		.hooknum	= NF_BR_FORWARD,
 		.priority	= NF_BR_PRI_FILTER_BRIDGED,
 	},
 	{
 		.hook		= ebt_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_BRIDGE,
 		.hooknum	= NF_BR_LOCAL_OUT,
 		.priority	= NF_BR_PRI_FILTER_OTHER,
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .18005-linux-2.5.68-bk8/net/bridge/netfilter/ebtable_nat.c .18005-linux-2.5.68-bk8.updated/net/bridge/netfilter/ebtable_nat.c
--- .18005-linux-2.5.68-bk8/net/bridge/netfilter/ebtable_nat.c	2003-03-25 12:17:32.000000000 +1100
+++ .18005-linux-2.5.68-bk8.updated/net/bridge/netfilter/ebtable_nat.c	2003-04-28 13:43:07.000000000 +1000
@@ -76,18 +76,21 @@ ebt_nat_src(unsigned int hook, struct sk
 static struct nf_hook_ops ebt_ops_nat[] = {
 	{
 		.hook		= ebt_nat_dst,
+		.owner		= THIS_MODULE,
 		.pf		= PF_BRIDGE,
 		.hooknum	= NF_BR_LOCAL_OUT,
 		.priority	= NF_BR_PRI_NAT_DST_OTHER,
 	},
 	{
 		.hook		= ebt_nat_src,
+		.owner		= THIS_MODULE,
 		.pf		= PF_BRIDGE,
 		.hooknum	= NF_BR_POST_ROUTING,
 		.priority	= NF_BR_PRI_NAT_SRC,
 	},
 	{
 		.hook		= ebt_nat_dst,
+		.owner		= THIS_MODULE,
 		.pf		= PF_BRIDGE,
 		.hooknum	= NF_BR_PRE_ROUTING,
 		.priority	= NF_BR_PRI_NAT_DST_BRIDGED,
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .18005-linux-2.5.68-bk8/net/core/netfilter.c .18005-linux-2.5.68-bk8.updated/net/core/netfilter.c
--- .18005-linux-2.5.68-bk8/net/core/netfilter.c	2003-04-20 18:05:16.000000000 +1000
+++ .18005-linux-2.5.68-bk8.updated/net/core/netfilter.c	2003-04-28 13:52:52.000000000 +1000
@@ -350,6 +350,8 @@ static unsigned int nf_iterate(struct li
 		if (hook_thresh > elem->priority)
 			continue;
 
+		/* Optimization: we don't need to hold module
+                   reference here, since function can't sleep. --RR */
 		switch (elem->hook(hook, skb, indev, outdev, okfn)) {
 		case NF_QUEUE:
 			return NF_QUEUE;
@@ -408,12 +410,12 @@ int nf_unregister_queue_handler(int pf)
  * Any packet that leaves via this function must come back 
  * through nf_reinject().
  */
-static void nf_queue(struct sk_buff *skb, 
-		     struct list_head *elem, 
-		     int pf, unsigned int hook,
-		     struct net_device *indev,
-		     struct net_device *outdev,
-		     int (*okfn)(struct sk_buff *))
+static int nf_queue(struct sk_buff *skb, 
+		    struct list_head *elem, 
+		    int pf, unsigned int hook,
+		    struct net_device *indev,
+		    struct net_device *outdev,
+		    int (*okfn)(struct sk_buff *))
 {
 	int status;
 	struct nf_info *info;
@@ -422,9 +424,10 @@ static void nf_queue(struct sk_buff *skb
 	struct net_device *physoutdev = NULL;
 #endif
 
+	/* QUEUE == DROP if noone is waiting, to be safe. */
 	if (!queue_handler[pf].outfn) {
 		kfree_skb(skb);
-		return;
+		return 1;
 	}
 
 	info = kmalloc(sizeof(*info), GFP_ATOMIC);
@@ -433,12 +436,16 @@ static void nf_queue(struct sk_buff *skb
 			printk(KERN_ERR "OOM queueing packet %p\n",
 			       skb);
 		kfree_skb(skb);
-		return;
+		return 1;
 	}
 
 	*info = (struct nf_info) { 
 		(struct nf_hook_ops *)elem, pf, hook, indev, outdev, okfn };
 
+	/* If it's going away, ignore hook. */
+	if (!try_module_get(info->elem->owner))
+		return 0;
+
 	/* Bump dev refs so they don't vanish while packet is out */
 	if (indev) dev_hold(indev);
 	if (outdev) dev_hold(outdev);
@@ -461,10 +468,12 @@ static void nf_queue(struct sk_buff *skb
 		if (physindev) dev_put(physindev);
 		if (physoutdev) dev_put(physoutdev);
 #endif
+		module_put(info->elem->owner);
 		kfree(info);
 		kfree_skb(skb);
-		return;
+		return 1;
 	}
+	return 1;
 }
 
 int nf_hook_slow(int pf, unsigned int hook, struct sk_buff *skb,
@@ -497,11 +506,13 @@ int nf_hook_slow(int pf, unsigned int ho
 #endif
 
 	elem = &nf_hooks[pf][hook];
+ next_hook:
 	verdict = nf_iterate(&nf_hooks[pf][hook], &skb, hook, indev,
 			     outdev, &elem, okfn, hook_thresh);
 	if (verdict == NF_QUEUE) {
 		NFDEBUG("nf_hook: Verdict = QUEUE.\n");
-		nf_queue(skb, elem, pf, hook, indev, outdev, okfn);
+		if (!nf_queue(skb, elem, pf, hook, indev, outdev, okfn))
+			goto next_hook;
 	}
 
 	switch (verdict) {
@@ -527,15 +538,9 @@ void nf_reinject(struct sk_buff *skb, st
 
 	/* We don't have BR_NETPROTO_LOCK here */
 	br_read_lock_bh(BR_NETPROTO_LOCK);
-	for (i = nf_hooks[info->pf][info->hook].next; i != elem; i = i->next) {
-		if (i == &nf_hooks[info->pf][info->hook]) {
-			/* The module which sent it to userspace is gone. */
-			NFDEBUG("%s: module disappeared, dropping packet.\n",
-			         __FUNCTION__);
-			verdict = NF_DROP;
-			break;
-		}
-	}
+
+	/* Drop reference to owner of hook which queued us. */
+	module_put(info->elem->owner);
 
 	/* Continue traversal iff userspace said ok... */
 	if (verdict == NF_REPEAT) {
@@ -544,6 +549,7 @@ void nf_reinject(struct sk_buff *skb, st
 	}
 
 	if (verdict == NF_ACCEPT) {
+	next_hook:
 		verdict = nf_iterate(&nf_hooks[info->pf][info->hook],
 				     &skb, info->hook, 
 				     info->indev, info->outdev, &elem,
@@ -556,8 +562,9 @@ void nf_reinject(struct sk_buff *skb, st
 		break;
 
 	case NF_QUEUE:
-		nf_queue(skb, elem, info->pf, info->hook, 
-			 info->indev, info->outdev, info->okfn);
+		if (!nf_queue(skb, elem, info->pf, info->hook, 
+			      info->indev, info->outdev, info->okfn))
+			goto next_hook;
 		break;
 
 	case NF_DROP:
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .18005-linux-2.5.68-bk8/net/ipv4/netfilter/arptable_filter.c .18005-linux-2.5.68-bk8.updated/net/ipv4/netfilter/arptable_filter.c
--- .18005-linux-2.5.68-bk8/net/ipv4/netfilter/arptable_filter.c	2003-03-18 12:21:41.000000000 +1100
+++ .18005-linux-2.5.68-bk8.updated/net/ipv4/netfilter/arptable_filter.c	2003-04-28 13:54:36.000000000 +1000
@@ -133,11 +133,13 @@ static unsigned int arpt_hook(unsigned i
 static struct nf_hook_ops arpt_ops[] = {
 	{
 		.hook		= arpt_hook,
+		.owner		= THIS_MODULE,
 		.pf		= NF_ARP,
 		.hooknum	= NF_ARP_IN,
 	},
 	{
 		.hook		= arpt_hook,
+		.owner		= THIS_MODULE,
 		.pf		= NF_ARP,
 		.hooknum	= NF_ARP_OUT,
 	}
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .18005-linux-2.5.68-bk8/net/ipv4/netfilter/ip_conntrack_standalone.c .18005-linux-2.5.68-bk8.updated/net/ipv4/netfilter/ip_conntrack_standalone.c
--- .18005-linux-2.5.68-bk8/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-04-08 11:15:07.000000000 +1000
+++ .18005-linux-2.5.68-bk8.updated/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-04-28 13:55:31.000000000 +1000
@@ -227,6 +227,7 @@ static unsigned int ip_conntrack_local(u
    make it the first hook. */
 static struct nf_hook_ops ip_conntrack_in_ops = {
 	.hook		= ip_conntrack_in,
+	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_PRE_ROUTING,
 	.priority	= NF_IP_PRI_CONNTRACK,
@@ -234,6 +235,7 @@ static struct nf_hook_ops ip_conntrack_i
 
 static struct nf_hook_ops ip_conntrack_local_out_ops = {
 	.hook		= ip_conntrack_local,
+	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_LOCAL_OUT,
 	.priority	= NF_IP_PRI_CONNTRACK,
@@ -242,6 +244,7 @@ static struct nf_hook_ops ip_conntrack_l
 /* Refragmenter; last chance. */
 static struct nf_hook_ops ip_conntrack_out_ops = {
 	.hook		= ip_refrag,
+	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_POST_ROUTING,
 	.priority	= NF_IP_PRI_LAST,
@@ -249,6 +252,7 @@ static struct nf_hook_ops ip_conntrack_o
 
 static struct nf_hook_ops ip_conntrack_local_in_ops = {
 	.hook		= ip_confirm,
+	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_LOCAL_IN,
 	.priority	= NF_IP_PRI_LAST-1,
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .18005-linux-2.5.68-bk8/net/ipv4/netfilter/ip_fw_compat.c .18005-linux-2.5.68-bk8.updated/net/ipv4/netfilter/ip_fw_compat.c
--- .18005-linux-2.5.68-bk8/net/ipv4/netfilter/ip_fw_compat.c	2003-04-20 18:05:16.000000000 +1000
+++ .18005-linux-2.5.68-bk8.updated/net/ipv4/netfilter/ip_fw_compat.c	2003-04-28 13:55:39.000000000 +1000
@@ -226,6 +226,7 @@ static int sock_fn(struct sock *sk, int 
 
 static struct nf_hook_ops preroute_ops = {
 	.hook		= fw_in,
+	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_PRE_ROUTING,
 	.priority	= NF_IP_PRI_FILTER,
@@ -233,6 +234,7 @@ static struct nf_hook_ops preroute_ops =
 
 static struct nf_hook_ops postroute_ops = {
 	.hook		= fw_in,
+	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_POST_ROUTING,
 	.priority	= NF_IP_PRI_FILTER,
@@ -240,6 +242,7 @@ static struct nf_hook_ops postroute_ops 
 
 static struct nf_hook_ops forward_ops = {
 	.hook		= fw_in,
+	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_FORWARD,
 	.priority	= NF_IP_PRI_FILTER,
@@ -247,6 +250,7 @@ static struct nf_hook_ops forward_ops = 
 
 static struct nf_hook_ops local_in_ops = {
 	.hook		= fw_confirm,
+	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_LOCAL_IN,
 	.priority	= NF_IP_PRI_LAST - 1,
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .18005-linux-2.5.68-bk8/net/ipv4/netfilter/ip_nat_standalone.c .18005-linux-2.5.68-bk8.updated/net/ipv4/netfilter/ip_nat_standalone.c
--- .18005-linux-2.5.68-bk8/net/ipv4/netfilter/ip_nat_standalone.c	2003-04-20 18:05:16.000000000 +1000
+++ .18005-linux-2.5.68-bk8.updated/net/ipv4/netfilter/ip_nat_standalone.c	2003-04-28 13:53:52.000000000 +1000
@@ -238,6 +238,7 @@ ip_nat_local_fn(unsigned int hooknum,
 /* Before packet filtering, change destination */
 static struct nf_hook_ops ip_nat_in_ops = {
 	.hook		= ip_nat_fn,
+	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_PRE_ROUTING,
 	.priority	= NF_IP_PRI_NAT_DST,
@@ -246,6 +247,7 @@ static struct nf_hook_ops ip_nat_in_ops 
 /* After packet filtering, change source */
 static struct nf_hook_ops ip_nat_out_ops = {
 	.hook		= ip_nat_out,
+	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_POST_ROUTING,
 	.priority	= NF_IP_PRI_NAT_SRC,
@@ -254,6 +256,7 @@ static struct nf_hook_ops ip_nat_out_ops
 /* Before packet filtering, change destination */
 static struct nf_hook_ops ip_nat_local_out_ops = {
 	.hook		= ip_nat_local_fn,
+	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_LOCAL_OUT,
 	.priority	= NF_IP_PRI_NAT_DST,
@@ -262,6 +265,7 @@ static struct nf_hook_ops ip_nat_local_o
 #ifdef CONFIG_IP_NF_NAT_LOCAL
 static struct nf_hook_ops ip_nat_local_in_ops = {
 	.hook		= ip_nat_fn,
+	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_LOCAL_IN,
 	.priority	= NF_IP_PRI_NAT_SRC,
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .18005-linux-2.5.68-bk8/net/ipv4/netfilter/iptable_filter.c .18005-linux-2.5.68-bk8.updated/net/ipv4/netfilter/iptable_filter.c
--- .18005-linux-2.5.68-bk8/net/ipv4/netfilter/iptable_filter.c	2003-04-20 18:05:16.000000000 +1000
+++ .18005-linux-2.5.68-bk8.updated/net/ipv4/netfilter/iptable_filter.c	2003-04-28 13:55:05.000000000 +1000
@@ -125,18 +125,21 @@ ipt_local_out_hook(unsigned int hook,
 static struct nf_hook_ops ipt_ops[] = {
 	{
 		.hook		= ipt_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_INET,
 		.hooknum	= NF_IP_LOCAL_IN,
 		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
 		.hook		= ipt_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_INET,
 		.hooknum	= NF_IP_FORWARD,
 		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
 		.hook		= ipt_local_out_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_INET,
 		.hooknum	= NF_IP_LOCAL_OUT,
 		.priority	= NF_IP_PRI_FILTER,
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .18005-linux-2.5.68-bk8/net/ipv4/netfilter/iptable_mangle.c .18005-linux-2.5.68-bk8.updated/net/ipv4/netfilter/iptable_mangle.c
--- .18005-linux-2.5.68-bk8/net/ipv4/netfilter/iptable_mangle.c	2003-04-20 18:05:16.000000000 +1000
+++ .18005-linux-2.5.68-bk8.updated/net/ipv4/netfilter/iptable_mangle.c	2003-04-28 13:55:18.000000000 +1000
@@ -178,30 +178,35 @@ ipt_local_hook(unsigned int hook,
 static struct nf_hook_ops ipt_ops[] = {
 	{
 		.hook		= ipt_route_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_INET,
 		.hooknum	= NF_IP_PRE_ROUTING, 
 		.priority	= NF_IP_PRI_MANGLE,
 	},
 	{
 		.hook		= ipt_route_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_INET,
 		.hooknum	= NF_IP_LOCAL_IN,
 		.priority	= NF_IP_PRI_MANGLE,
 	},
 	{
 		.hook		= ipt_route_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_INET,
 		.hooknum	= NF_IP_FORWARD,
 		.priority	= NF_IP_PRI_MANGLE,
 	},
 	{
 		.hook		= ipt_local_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_INET,
 		.hooknum	= NF_IP_LOCAL_OUT,
 		.priority	= NF_IP_PRI_MANGLE,
 	},
 	{
 		.hook		= ipt_route_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_INET,
 		.hooknum	= NF_IP_POST_ROUTING,
 		.priority	= NF_IP_PRI_MANGLE,
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .18005-linux-2.5.68-bk8/net/ipv6/netfilter/ip6table_filter.c .18005-linux-2.5.68-bk8.updated/net/ipv6/netfilter/ip6table_filter.c
--- .18005-linux-2.5.68-bk8/net/ipv6/netfilter/ip6table_filter.c	2003-03-18 12:21:41.000000000 +1100
+++ .18005-linux-2.5.68-bk8.updated/net/ipv6/netfilter/ip6table_filter.c	2003-04-28 13:55:48.000000000 +1000
@@ -123,18 +123,21 @@ ip6t_local_out_hook(unsigned int hook,
 static struct nf_hook_ops ip6t_ops[] = {
 	{
 		.hook		= ip6t_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_INET6,
 		.hooknum	= NF_IP6_LOCAL_IN,
 		.priority	= NF_IP6_PRI_FILTER,
 	},
 	{
 		.hook		= ip6t_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_INET6,
 		.hooknum	= NF_IP6_FORWARD,
 		.priority	= NF_IP6_PRI_FILTER,
 	},
 	{
 		.hook		= ip6t_local_out_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_INET6,
 		.hooknum	= NF_IP6_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_FILTER,
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .18005-linux-2.5.68-bk8/net/ipv6/netfilter/ip6table_mangle.c .18005-linux-2.5.68-bk8.updated/net/ipv6/netfilter/ip6table_mangle.c
--- .18005-linux-2.5.68-bk8/net/ipv6/netfilter/ip6table_mangle.c	2003-04-20 18:05:17.000000000 +1000
+++ .18005-linux-2.5.68-bk8.updated/net/ipv6/netfilter/ip6table_mangle.c	2003-04-28 13:55:59.000000000 +1000
@@ -186,30 +186,35 @@ ip6t_local_hook(unsigned int hook,
 static struct nf_hook_ops ip6t_ops[] = {
 	{
 		.hook		= ip6t_route_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_INET6,
 		.hooknum	= NF_IP6_PRE_ROUTING,
 		.priority	= NF_IP6_PRI_MANGLE,
 	},
 	{
 		.hook		= ip6t_local_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_INET6,
 		.hooknum	= NF_IP6_LOCAL_IN,
 		.priority	= NF_IP6_PRI_MANGLE,
 	},
 	{
 		.hook		= ip6t_route_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_INET6,
 		.hooknum	= NF_IP6_FORWARD,
 		.priority	= NF_IP6_PRI_MANGLE,
 	},
 	{
 		.hook		= ip6t_local_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_INET6,
 		.hooknum	= NF_IP6_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_MANGLE,
 	},
 	{
 		.hook		= ip6t_route_hook,
+		.owner		= THIS_MODULE,
 		.pf		= PF_INET6,
 		.hooknum	= NF_IP6_POST_ROUTING,
 		.priority	= NF_IP6_PRI_MANGLE,
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .18005-linux-2.5.68-bk8/net/sched/sch_ingress.c .18005-linux-2.5.68-bk8.updated/net/sched/sch_ingress.c
--- .18005-linux-2.5.68-bk8/net/sched/sch_ingress.c	2003-04-28 11:24:35.000000000 +1000
+++ .18005-linux-2.5.68-bk8.updated/net/sched/sch_ingress.c	2003-04-28 13:56:09.000000000 +1000
@@ -241,6 +241,7 @@ static struct nf_hook_ops ing_ops =
 {
 	{ NULL, NULL},
 	ing_hook,
+	THIS_MODULE,
 	PF_INET,
 	NF_IP_PRE_ROUTING,
 	NF_IP_PRI_FILTER + 1
