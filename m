From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 2/2] Port nfnetlink and nfnetlink_conntrack to 2.6
Date: Mon, 28 Mar 2005 01:56:15 +0200
Message-ID: <4247481F.9090702@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040802020008040203050003"
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------040802020008040203050003
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Comments about changes:

o Minor change: my compiler (gcc-2.95) complained about ct_debug so I 
inserted the classical DEBUGP macro.

o No important modifications in nfnetlink.c

o Added support to identify conntracks by id.

o Removed ordered list, now we just insert a unsigned int in struct 
ip_conntrack to hold the id. Now the table dumping is done iterating the 
hash table.

o Adaptation to ct-event API

o improved way to delete a conntrack (marcus sundberg)

o kill [dump|change]_natinfo, now that must be handle in 
[dump|change]_status.

o IMPORTANT: I haven't tested expectation handling.

Things I consider to do:

o split CTNL_MSG_GETCONNTRACK to two messages types: 
CTNL_MSG_GETCONNTRACK and CTNL_MSG_DMPCONNTRACK (dump)

o split CTNL_MSG_NEWCONNTRACK to two messages types: 
CTNL_MSG_NEWCONNTRACK and CTNL_MSG_UPDCONNTRACK (update)

o Move nfnetlink.h and nfnetlink_conntrack.h to netfilter/ directory.

--------------040802020008040203050003
Content-Type: text/x-patch;
 name="nfct.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nfct.patch"

--- linux-2.5/net/ipv4/netfilter/nfnetlink.c.orig	2005-03-07 20:16:24.000000000 +0100
+++ linux-2.5/net/ipv4/netfilter/nfnetlink.c	2005-03-26 04:22:53.000000000 +0100
@@ -42,14 +42,9 @@
 static char __initdata nfversion[] = "0.12";
 
 #if 1
-static int nf_debug_level = 1;
-#define nf_debug(level, format, arg...)					\
-do {									\
-	if (nf_debug_level > level)					\
-		printk(KERN_DEBUG "%s: " format, __FUNCTION__, ## arg);	\
-} while(0)
+#define DEBUGP printk
 #else
-#define nf_debug(level, format, arg...)
+#define DEBUGP(format, args...)
 #endif
 
 static struct sock *nfnl = NULL;
@@ -87,9 +82,7 @@
 
 int nfnetlink_subsys_register(struct nfnetlink_subsystem *n)
 {
-	MOD_INC_USE_COUNT;
-
-	nf_debug(0, "registering subsystem ID %u\n", n->subsys_id);
+	DEBUGP("registering subsystem ID %u\n", n->subsys_id);
 
 	nfnl_lock();
 	list_add(&n->list, &subsys_list);
@@ -101,15 +94,13 @@
 
 int nfnetlink_subsys_unregister(struct nfnetlink_subsystem *n)
 {
-	nf_debug(0, "unregistering subsystem ID %u\n", n->subsys_id);
+	DEBUGP("unregistering subsystem ID %u\n", n->subsys_id);
 
 	nfnl_lock();
 	subsys_table[n->subsys_id] = NULL;
 	list_del(&n->list);
 	nfnl_unlock();
 
-	MOD_DEC_USE_COUNT;
-
 	return 0;
 }
 
@@ -126,8 +117,7 @@
 	ss = subsys_table[subsys_id];
 
 	if (type >= ss->cb_count) {
-		nf_debug(0, "msgtype %u >= %u, returning\n", type, 
-			 ss->cb_count);
+		DEBUGP("msgtype %u >= %u, returning\n", type, ss->cb_count);
 		return NULL;
 	}
 
@@ -222,38 +212,38 @@
 	struct nfnl_callback *nc;
 	int type, err = 0;
 
-	nf_debug(0, "entered; subsys=%u, msgtype=%u\n",
+	DEBUGP("entered; subsys=%u, msgtype=%u\n",
 		 NFNL_SUBSYS_ID(nlh->nlmsg_type),
 		 NFNL_MSG_TYPE(nlh->nlmsg_type));
 
 	/* Only requests are handled by kernel now. */
 	if (!(nlh->nlmsg_flags & NLM_F_REQUEST)) {
-		nf_debug(0, "received non-request message\n");
+		DEBUGP("received non-request message\n");
 		return 0;
 	}
 
 	/* Unknown message: reply with EINVAL */
 	type = nlh->nlmsg_type;
 	if (NFNL_SUBSYS_ID(type) > NFNL_SUBSYS_COUNT) {
-		nf_debug(0, "subsys_id > subsys_count\n");
+		DEBUGP("subsys_id > subsys_count\n");
 		goto err_inval;
 	}
 
 	/* All the messages must have at least 1 byte length */
 	if (nlh->nlmsg_len < NLMSG_LENGTH(sizeof(struct nfgenmsg))) {
-		nf_debug(0, "received message was too short\n");
+		DEBUGP("received message was too short\n");
 		return 0;
 	}
 
 	nc = nfnetlink_find_client(type);
 	if (!nc) {
-		nf_debug(0, "unable to find client for type %d\n", type);
+		DEBUGP("unable to find client for type %d\n", type);
 		goto err_inval;
 	}
 
 	if (nc->cap_required && 
 	    !cap_raised(NETLINK_CB(skb).eff_cap, nc->cap_required)) {
-		nf_debug(0, "permission denied for type %d\n", type);
+		DEBUGP("permission denied for type %d\n", type);
 		*errp = -EPERM;
 		return -1;
 	}
@@ -304,10 +294,11 @@
 		if (nfnl_shlock_nowait())
 			return;
 
-		while ((skb = skb_dequeue(&sk->receive_queue)) != NULL) {
+		while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
 			if (nfnetlink_rcv_skb(skb)) {
 				if (skb->len)
-					skb_queue_head(&sk->receive_queue, skb);
+					skb_queue_head(&sk->sk_receive_queue,
+						       skb);
 				else
 					kfree_skb(skb);
 				break;
@@ -316,13 +307,13 @@
 		}
 
 		up(&nfnl_sem);
-	} while(nfnl && nfnl->receive_queue.qlen);
+	} while(nfnl && nfnl->sk_receive_queue.qlen);
 }
 
 void __exit nfnetlink_exit(void)
 {
 	printk("Netfilter removing netlink socket.\n");
-	sock_release(nfnl->socket);
+	sock_release(nfnl->sk_socket);
 	return;
 }
 
--- linux-2.5/include/linux/nfnetlink.h.orig	2005-03-07 20:41:04.000000000 +0100
+++ linux-2.5/include/linux/nfnetlink.h	2005-03-28 00:12:37.000000000 +0200
@@ -72,8 +72,9 @@
 #define NFM_PAYLOAD(n)  NLMSG_PAYLOAD(n, sizeof(struct nfgenmsg))
 
 
+/* Now it's uses NETLINK_FIREWALL */
 #ifndef NETLINK_NETFILTER
-#define NETLINK_NETFILTER	6
+#define NETLINK_NETFILTER	3
 #endif
 
 /* netfilter netlink message types are split in two pieces:
--- linux-2.5/net/ipv4/netfilter/nfnetlink_conntrack.c.orig	2005-03-07 20:16:55.000000000 +0100
+++ linux-2.5/net/ipv4/netfilter/nfnetlink_conntrack.c	2005-03-28 01:36:29.000000000 +0200
@@ -57,16 +57,8 @@
 static char __initdata ctversion[] = "0.12";
 
 #if 1
-static int ct_debug_level = 1;
-#define ct_debug(level, format, arg...)					\
-do {									\
-	if(ct_debug_level > level)					\
-		printk(KERN_DEBUG "%s: " format, __FUNCTION__, ## arg);	\
-} while(0)
-/* FIXME: this define is just needed for DUMP_TUPLE */
-#define DEBUGP(format, args...)	ct_debug(0, format, ## args)
+#define DEBUGP printk
 #else
-#define ct_debug(level, format, arg...)
 #define DEBUGP(format, args...)
 #endif
 
@@ -142,32 +134,19 @@
 }
 
 static inline int
-ctnetlink_dump_natinfo(struct sk_buff *skb, const struct ip_conntrack *ct)
+ctnetlink_dump_mark(struct sk_buff *skb, const struct ip_conntrack *ct)
 {
-#ifdef CONFIG_IP_NF_NAT_NEEDED
-	const struct ip_nat_info *info = &ct->nat.info;
-	struct cta_nat cn;
-
-	if (!info->initialized || !info->num_manips)
-		return 0;
-
-	cn.num_manips = info->num_manips;
-	memcpy(&cn.manips, &info->manips,
-	       info->num_manips * sizeof(struct ip_nat_info_manip));
-	NFA_PUT(skb, CTA_NATINFO, sizeof(struct cta_nat), &cn);
-	return 0;
-
-nfattr_failure:
-	return -1;
-#else
 	return 0;
-#endif
 }
 
 static inline int
-ctnetlink_dump_mark(struct sk_buff *skb, const struct ip_conntrack *ct)
+ctnetlink_dump_id(struct sk_buff *skb, const struct ip_conntrack *ct)
 {
+	NFA_PUT(skb, CTA_ID, sizeof(unsigned int), &ct->id);
 	return 0;
+
+nfattr_failure:
+	return -1;
 }
 
 static int
@@ -193,8 +172,8 @@
 	    ctnetlink_dump_timeout(skb, ct) < 0 ||
 	    ctnetlink_dump_protoinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
-	    ctnetlink_dump_natinfo(skb, ct) < 0 ||
-	    ctnetlink_dump_mark(skb, ct) < 0)
+	    ctnetlink_dump_mark(skb, ct) < 0 ||
+	    ctnetlink_dump_id(skb, ct) < 0)
 		goto nfattr_failure;
 
 	nlh->nlmsg_len = skb->tail - b;
@@ -230,7 +209,7 @@
 	return groups;
 }
 
-#define EVENT(m,e) ((m) & (1 << (e)))
+#define EVENT(m,e) (m & e)
 
 static int ctnetlink_conntrack_event(struct notifier_block *this,
                                      unsigned long events, void *ptr)
@@ -243,8 +222,8 @@
 	unsigned char *b;
 	int flags = 0;
 
-	/* FIXME: much too big, costs lots of socket buffer space */
-	skb = alloc_skb(400 /* NLMSG_GOODSIZE */, GFP_ATOMIC);
+	/* netlink_trim now reduces the impact of using NLMSG_GOODSIZE */
+	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb)
 		return NOTIFY_DONE;
 
@@ -271,7 +250,7 @@
 	if (ctnetlink_dump_tuples(skb, ct) < 0)
 		goto nfattr_failure;
 
-	if (EVENT(events, IPCT_STATUS)
+	if ((EVENT(events, IPCT_STATUS) || EVENT(events, IPCT_NATINFO))
 	    && ctnetlink_dump_status(skb, ct) < 0)
 		goto nfattr_failure;
 	if (EVENT(events, IPCT_REFRESH)
@@ -283,9 +262,6 @@
 	if (EVENT(events, IPCT_HELPINFO)
 	    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 		goto nfattr_failure;
-	if (EVENT(events, IPCT_NATINFO)
-	    && ctnetlink_dump_natinfo(skb, ct) < 0)
-		goto nfattr_failure;
 
 	nlh->nlmsg_len = skb->tail - b;
 	nfnetlink_send(skb, 0, ctnetlink_get_mcgroups(ct), 0);
@@ -303,18 +279,17 @@
 	[CTA_STATUS-1]		= sizeof(unsigned long),
 	[CTA_PROTOINFO-1]	= sizeof(struct cta_proto),
 	[CTA_HELPINFO-1]	= sizeof(struct cta_help),
-	[CTA_NATINFO-1]		= sizeof(struct cta_nat),
 	[CTA_TIMEOUT-1]		= sizeof(unsigned long),
+	[CTA_ID-1]		= sizeof(unsigned int),
 
 	[CTA_EXP_TUPLE-1]	= sizeof(struct ip_conntrack_tuple),
 	[CTA_EXP_MASK-1]	= sizeof(struct ip_conntrack_tuple),
 	[CTA_EXP_SEQNO-1]	= sizeof(u_int32_t),
 	[CTA_EXP_PROTO-1]	= sizeof(struct cta_exp_proto),
-	[CTA_EXP_HELP-1]	= sizeof(struct cta_exp_help),
 	[CTA_EXP_TIMEOUT-1]	= sizeof(unsigned long)
 };
 
-static inline int ctnetlink_kill(const struct ip_conntrack *i, void *data)
+static inline int ctnetlink_kill(struct ip_conntrack *i, void *data)
 {
 	struct ip_conntrack *t = (struct ip_conntrack *)data;
 
@@ -332,12 +307,18 @@
 	struct ip_conntrack_tuple_hash *h;
 	struct ip_conntrack_tuple *tuple;
 	struct nfattr *cda[CTA_MAX];
+	struct ip_conntrack *ct;
+	unsigned int *id = NULL;
 
-	ct_debug(0, "entered\n");
+	DEBUGP("entered %s\n", __FUNCTION__);
 
 	if (nfnetlink_check_attributes(ctnl_subsys, nlh, cda) < 0)
 		return -EINVAL;
 
+	if (cda[CTA_ID-1] &&
+	    NFA_PAYLOAD(cda[CTA_ID-1]) < cta_min[CTA_ID-1])
+		return -EINVAL;
+
 	if (cda[CTA_ORIG-1] &&
 	    NFA_PAYLOAD(cda[CTA_ORIG-1]) < cta_min[CTA_ORIG-1])
 		return -EINVAL;
@@ -345,6 +326,9 @@
 	if (cda[CTA_RPLY-1] &&
 	    NFA_PAYLOAD(cda[CTA_RPLY-1]) < cta_min[CTA_RPLY-1])
 		return -EINVAL;
+
+	if (cda[CTA_ID-1])
+		id = NFA_DATA(cda[CTA_ID-1]);
 	
 	if (cda[CTA_ORIG-1])
 		tuple = NFA_DATA(cda[CTA_ORIG-1]);
@@ -352,52 +336,69 @@
 		if (cda[CTA_RPLY-1])
 			tuple = NFA_DATA(cda[CTA_RPLY-1]);
 		else {
-			ct_debug(0, "no tuple found in request\n");
+			DEBUGP("no tuple found in request\n");
 			return -EINVAL;
 		}
 	}
 
 	h = ip_conntrack_find_get(tuple, NULL);
 	if (!h) {
-		ct_debug(0, "tuple not found in conntrack hash:");
+		DEBUGP("tuple not found in conntrack hash:");
 		DUMP_TUPLE(tuple);
 		return -ENOENT;
 	}
 
-	ct_debug(0, "calling selective_cleanup\n");
-	ip_ct_selective_cleanup(ctnetlink_kill, h->ctrack);
-	ip_conntrack_put(h->ctrack);
+	ct = tuplehash_to_ctrack(h);
+	if (*id != ct->id) {
+		DEBUGP("matching tuple with different id: %u!=%u", *id, ct->id);
+		return -ENOENT;
+	}
+	if (del_timer(&ct->timeout)) {
+		ip_conntrack_put(ct);
+		ct->timeout.function((unsigned long)ct);
+	}
+	DEBUGP("leaving\n");
 
 	return 0;
 }
 
 static int ctnetlink_done(struct netlink_callback *cb)
 {
-	ct_debug(0, "entering\n");
+	DEBUGP("entered %s\n", __FUNCTION__);
 	return 0;
 }
 
 static int
 ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct ip_conntrack *ct;
+	struct ip_conntrack *ct = NULL;
+	struct ip_conntrack_tuple_hash *h;
+	struct list_head *i;
 
-	ct_debug(0, "entered, last=%lu\n", cb->args[0]);
+	DEBUGP("entered %s, last bucket=%lu id=%lu\n", __FUNCTION__, 
+			cb->args[0], cb->args[1]);
 
-	/* Traverse ordered list; send originals then reply. */
 	READ_LOCK(&ip_conntrack_lock);
-	list_for_each_entry(ct, &ip_conntrack_ordered_list, olist) {
-		if (ct->id <= cb->args[0])
-			continue;
-		if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
-		                        cb->nlh->nlmsg_seq,
-					CTNL_MSG_NEWCONNTRACK, 1, ct) < 0)
-			break;
-		cb->args[0] = ct->id;
+	for (; cb->args[0] < ip_conntrack_htable_size; 
+					cb->args[0]++, cb->args[1]=0) {
+		list_for_each(i, &ip_conntrack_hash[cb->args[0]]) {
+			h = (struct ip_conntrack_tuple_hash *) i;
+			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
+				continue;
+			ct = tuplehash_to_ctrack(h);
+			if (ct->id <= cb->args[1])
+				continue;
+			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
+		                        	cb->nlh->nlmsg_seq,
+						CTNL_MSG_NEWCONNTRACK,
+						1, ct) < 0)
+				break;
+			cb->args[1] = ct->id;
+		}
 	}
 	READ_UNLOCK(&ip_conntrack_lock);
-	
-	ct_debug(0, "leaving, last=%lu\n", cb->args[0]);
+
+	DEBUGP("leaving, last bucket=%lu id=%lu\n", cb->args[0], cb->args[1]);
 
 	return skb->len;
 }
@@ -412,8 +413,9 @@
 	struct ip_conntrack *ct;
 	struct sk_buff *skb2 = NULL;
 	int err;
+	unsigned int *id = NULL;
 
-	ct_debug(0, "entered\n");
+	DEBUGP("entered %s\n", __FUNCTION__);
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct nfgenmsg *msg = NLMSG_DATA(nlh);
@@ -437,6 +439,10 @@
 	if (nfnetlink_check_attributes(ctnl_subsys, nlh, cda) < 0)
 		return -EINVAL;
 
+	if (cda[CTA_ID-1] &&
+	    NFA_PAYLOAD(cda[CTA_ID-1]) < cta_min[CTA_ID-1])
+		return -EINVAL;
+
 	if (cda[CTA_ORIG-1] &&
 	    NFA_PAYLOAD(cda[CTA_ORIG-1]) < cta_min[CTA_ORIG-1])
 		return -EINVAL;
@@ -444,6 +450,9 @@
 	if (cda[CTA_RPLY-1] &&
 	    NFA_PAYLOAD(cda[CTA_RPLY-1]) < cta_min[CTA_RPLY-1])
 		return -EINVAL;
+
+	if (cda[CTA_ID-1])
+		id = NFA_DATA(cda[CTA_ID-1]);
 	
 	if (cda[CTA_ORIG-1])
 		tuple = NFA_DATA(cda[CTA_ORIG-1]);
@@ -456,11 +465,17 @@
 
 	h = ip_conntrack_find_get(tuple, NULL);
 	if (!h) {
-		ct_debug(0, "tuple not found in conntrack hash:");
+		DEBUGP("tuple not found in conntrack hash:");
 		DUMP_TUPLE(tuple);
 		return -ENOENT;
 	}
-	ct = h->ctrack;
+	DEBUGP("tuple found\n");
+	ct = tuplehash_to_ctrack(h);
+
+	if (*id != ct->id) {
+		DEBUGP("matching tuple with different id: %u!=%u", *id, ct->id);
+		return -ENOENT;
+	}
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb2) {
@@ -472,12 +487,20 @@
 	err = ctnetlink_fill_info(skb2, NETLINK_CB(skb).pid, nlh->nlmsg_seq, 
 				  CTNL_MSG_NEWCONNTRACK, 1, ct);
 	ip_conntrack_put(ct);
-	if (err <= 0)
+	if (err <= 0) {
+		DEBUGP("error filling info\n");
 		goto nlmsg_failure;
+	}
+	/* This simpifies user space handling --pablo */
+        NLMSG_PUT(skb2, NETLINK_CB(skb).pid, nlh->nlmsg_seq, NLMSG_DONE, 0);
 
 	err = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).pid, MSG_DONTWAIT);
-	if (err < 0)
+	if (err < 0) {
+		DEBUGP("error sending skb\n");
 		return err;
+	}
+
+	DEBUGP("leaving\n");
 	return 0;
 
 nlmsg_failure:
@@ -486,6 +509,7 @@
 	return -1;
 }
 
+/* TODO: Now we have to handle NAT modifications here */
 static inline int
 ctnetlink_change_status(struct ip_conntrack *ct, unsigned long *status)
 {
@@ -516,13 +540,13 @@
 	if (cp->num_proto != proto)
 		return -EINVAL;
 
-	icp = __ip_ct_find_proto(cp->num_proto);
-	if (icp->ctnl_check_private
-	    && icp->ctnl_check_private(&cp->proto) < 0)
+	icp = ip_ct_find_proto(cp->num_proto);
+	if (icp->change_check_proto
+	    && icp->change_check_proto(&cp->proto) < 0)
 		return -EINVAL;
 
-	if (icp->ctnl_change)
-		icp->ctnl_change(ct, &cp->proto);
+	if (icp->change_proto)
+		icp->change_proto(ct, &cp->proto);
 
 	return 0;
 }
@@ -543,7 +567,7 @@
 		if (helper == NULL)
 			return -ENOENT;
 	} else if (*h->name == '\0') {
-		ip_conntrack_remove_expectations(ct, 1);
+		ip_ct_remove_expectations(ct);
 		ct->helper = NULL;
 		return 0;
 	}
@@ -553,43 +577,13 @@
 		return -EINVAL;
 
 	ct->helper = helper;
-	if (helper->ctnl_change)
-		helper->ctnl_change(ct, &h->help);
+	if (helper->change_help)
+		helper->change_help(ct, &h->help);
 
 	return 0;
 }
 
 static inline int
-ctnetlink_change_natinfo(struct ip_conntrack *ct, struct cta_nat *n)
-{
-#ifdef CONFIG_IP_NF_NAT_NEEDED
-	struct ip_nat_info *info = &ct->nat.info;
-	int i;
-
-	if (n->num_manips > IP_NAT_MAX_MANIPS)
-		return -EINVAL;
-
-	if (info->initialized && n->num_manips < info->num_manips)
-		return -EINVAL;
-
-	for (i = 0; i < n->num_manips; i++) {
-		if (n->manips[i].direction > IP_CT_DIR_MAX)
-			return -EINVAL;
-		if (n->manips[i].hooknum > NF_IP_NUMHOOKS)
-			return -EINVAL;
-		if (n->manips[i].hooknum == NF_IP_FORWARD)
-			return -EINVAL;
-		if (n->manips[i].maniptype > IP_NAT_MANIP_DST)
-			return -EINVAL;
-	}
-
-	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
-}
-
-static inline int
 ctnetlink_change_timeout(struct ip_conntrack *ct, unsigned long *timeout)
 {
 	if (!del_timer(&ct->timeout))
@@ -605,8 +599,8 @@
 {
 	void *data;
 	int err;
-	
-	ct_debug(0, "entered\n");
+
+	DEBUGP("entered %s\n", __FUNCTION__);
 
 	if (cda[CTA_STATUS-1]) {
 		data = NFA_DATA(cda[CTA_STATUS-1]);
@@ -623,18 +617,13 @@
 		if ((err = ctnetlink_change_helpinfo(ct, data)) < 0)
 			return err;
 	}
-	if (cda[CTA_NATINFO-1]) {
-		data = NFA_DATA(cda[CTA_NATINFO-1]);
-		if ((err = ctnetlink_change_natinfo(ct, data)) < 0)
-			return err;
-	}
 	if (cda[CTA_TIMEOUT-1]) {
 		data = NFA_DATA(cda[CTA_TIMEOUT-1]);
 		if ((err = ctnetlink_change_timeout(ct, data)) < 0)
 			return err;
 	}
 
-	ct_debug(0, "all done\n");
+	DEBUGP("all done\n");
 	return 0;
 }
 
@@ -642,18 +631,19 @@
 ctnetlink_create_conntrack(struct nfattr *cda[])
 {
 	struct ip_conntrack *ct;
-	struct ip_conntrack_tuple *otuple, *rtuple, t;
+	struct ip_conntrack_tuple *otuple, *rtuple;
 	struct ip_conntrack_protocol *icp;
 	struct cta_proto *proto;
 	unsigned long *status;
 	unsigned long *timeout;
 	int err;
+	unsigned int hash, hash_repl;
 
-	ct_debug(0, "entered\n");
+	DEBUGP("entered %s\n", __FUNCTION__);
 
 	if (!(cda[CTA_ORIG-1] && cda[CTA_RPLY-1] && cda[CTA_STATUS-1] &&
 	      cda[CTA_PROTOINFO-1] && cda[CTA_TIMEOUT-1])) {
-		ct_debug(0, "required attribute(s) missing\n");
+		DEBUGP("required attribute(s) missing\n");
 		return -EINVAL;
 	}
 
@@ -661,22 +651,20 @@
 	rtuple  = NFA_DATA(cda[CTA_RPLY-1]);
 	timeout = NFA_DATA(cda[CTA_TIMEOUT-1]);
 
-	status  = NFA_DATA(cda[CTA_STATUS-1]);
+	status = NFA_DATA(cda[CTA_STATUS-1]);
+	/* cannot create unconfirmed connections */
 	if (!(*status & IPS_CONFIRMED))
-		return -EINVAL;	/* cannot create unconfirmed connections */
+		return -EINVAL;	
 
 	proto = NFA_DATA(cda[CTA_PROTOINFO-1]);
-	icp   = __ip_ct_find_proto(proto->num_proto);
-
-	if (!invert_tuple(&t, otuple, icp) || !ip_ct_tuple_equal(&t, rtuple))
-		; // FIXME: nat changes reply tuples // return -EINVAL;
+	icp   = ip_ct_find_proto(proto->num_proto);
 
-	if (icp->ctnl_check_tuples
-	    && icp->ctnl_check_tuples(otuple, rtuple) < 0)
+	if (icp->change_check_tuples
+	    && icp->change_check_tuples(otuple, rtuple) < 0)
 		return -EINVAL;
 	
-	if (icp->ctnl_check_private
-	    && icp->ctnl_check_private(&proto->proto) < 0)
+	if (icp->change_check_proto
+	    && icp->change_check_proto(&proto->proto) < 0)
 		return -EINVAL;
 
 	ct = ip_conntrack_alloc(otuple, rtuple);
@@ -686,9 +674,10 @@
 	ct->status = *status;
 	ct->timeout.expires = jiffies + *timeout * HZ;
 
-	if (icp->ctnl_change)
-		icp->ctnl_change(ct, &proto->proto);
+	if (icp->change_proto)
+		icp->change_proto(ct, &proto->proto);
 
+	/* FIXME: Split function to NEW and CHANGE */
 	cda[CTA_ORIG-1] = cda[CTA_RPLY-1] = cda[CTA_PROTOINFO-1] = 
 		cda[CTA_STATUS-1] = cda[CTA_TIMEOUT-1] = NULL;
 
@@ -698,10 +687,12 @@
 		return err;
 	}
 
-	ip_conntrack_place_in_lists(ct);
+	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	hash_repl = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+	ip_conntrack_insert(ct, hash, hash_repl);
 	add_timer(&ct->timeout);
 
-	ct_debug(0, "all done\n");
+	DEBUGP("all done\n");
 	return 0;
 }
 
@@ -714,16 +705,19 @@
 	struct ip_conntrack_tuple_hash *h = NULL;
 	int i, err = 0;
 
-	ct_debug(0, "entered\n");
+	DEBUGP("entered %s\n", __FUNCTION__);
 
 	if (nfnetlink_check_attributes(ctnl_subsys, nlh, cda) < 0)
 		return -EINVAL;
 
 	for (i = 0; i < CTA_MAX; i++)
-		if (cda[i] && NFA_PAYLOAD(cda[i]) < cta_min[i])
+		if (cda[i] && NFA_PAYLOAD(cda[i]) < cta_min[i]) {
+			DEBUGP("attribute %u has incorrect size %u<%u\n", 
+				i, NFA_PAYLOAD(cda[i]), cta_min[i]);
 			return -EINVAL;
+		}
 
-	ct_debug(0, "all attribute sizes ok\n");
+	DEBUGP("all attribute sizes ok\n");
 
 	if (cda[CTA_ORIG-1])
 		otuple = NFA_DATA(cda[CTA_ORIG-1]);
@@ -732,33 +726,36 @@
 		rtuple = NFA_DATA(cda[CTA_RPLY-1]);
 
 	if (otuple == NULL && rtuple == NULL) {
-		ct_debug(0, "no tuple found in request\n");
+		DEBUGP("no tuple found in request\n");
 		return -EINVAL;
 	}
 
-	WRITE_LOCK(&ip_conntrack_lock);
+	/* If we create a conntrack, it isn't in the hashed yet so
+	 * no need to lock. Split this function in two. */
 	if (otuple)
-		h = __ip_conntrack_find_get(otuple, NULL);
+		h = ip_conntrack_find_get(otuple, NULL);
 	if (h == NULL && rtuple)
-		h = __ip_conntrack_find_get(rtuple, NULL);
+		h = ip_conntrack_find_get(rtuple, NULL);
 
+	WRITE_LOCK(&ip_conntrack_lock);
 	if (h == NULL) {
-		ct_debug(0, "no such conntrack, create new\n");
+		DEBUGP("no such conntrack, create new\n");
 		err = -ENOENT;
 		if (!(nlh->nlmsg_flags & NLM_F_CREATE))
 			goto out_unlock;
 		err = ctnetlink_create_conntrack(cda);
+
 		goto out_unlock;
 	} else {
-		ct_debug(0, "conntrack found, change\n");
+		DEBUGP("conntrack found, change\n");
 		err = -EEXIST;
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			goto out_put;
-		err = ctnetlink_change_conntrack(h->ctrack, cda);
+		err = ctnetlink_change_conntrack(tuplehash_to_ctrack(h), cda);
 	}
 
 out_put:
-	ip_conntrack_put(h->ctrack);
+	ip_conntrack_put(tuplehash_to_ctrack(h));
 out_unlock:
 	WRITE_UNLOCK(&ip_conntrack_lock);
 	return err;
@@ -781,10 +778,10 @@
 }
 
 static inline int
-ctnetlink_exp_dump_seqno(struct sk_buff *skb,
-                         const struct ip_conntrack_expect *exp)
+ctnetlink_exp_dump_timeout(struct sk_buff *skb, 
+			   const struct ip_conntrack_expect *exp)
 {
-	NFA_PUT(skb, CTA_EXP_SEQNO, sizeof(u_int32_t), &exp->seq);
+	NFA_PUT(skb, CTA_EXP_TIMEOUT, sizeof(unsigned long), &exp->timeout);
 	return 0;
 	
 nfattr_failure:
@@ -798,21 +795,6 @@
 	return 0;
 }
 
-static inline int
-ctnetlink_exp_dump_help(struct sk_buff *skb,
-                        const struct ip_conntrack_expect *exp)
-{
-	struct cta_exp_help ch;
-
-	memcpy(&ch.help, &exp->help, sizeof(ch.help));
-	NFA_PUT(skb, CTA_EXP_HELP, sizeof(union ip_conntrack_expect_help),
-	        &exp->help);
-	return 0;
-	
-nfattr_failure:
-	return -1;
-}
-
 static int
 ctnetlink_exp_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 		    int event, 
@@ -833,9 +815,7 @@
 	nfmsg->nfgen_family = AF_INET;
 
 	if (ctnetlink_exp_dump_tuples(skb, exp) < 0 ||
-	    ctnetlink_exp_dump_seqno(skb, exp) < 0 ||
-	    ctnetlink_exp_dump_proto(skb, exp) < 0 ||
-	    ctnetlink_exp_dump_help(skb, exp) < 0)
+	    ctnetlink_exp_dump_timeout(skb, exp) < 0)
 		goto nfattr_failure;
 
 	nlh->nlmsg_len = skb->tail - b;
@@ -867,7 +847,7 @@
 		kfree_skb(skb);
 	return NULL;
 }
-
+/*
 static void
 ctnetlink_exp_create(struct ip_conntrack_expect *exp)
 {
@@ -893,7 +873,7 @@
 	}
 	kfree_skb(skb);
 	return;
-}
+}*/
 
 static int
 ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb, 
@@ -931,7 +911,7 @@
 	/* after list removal, usage count == 1 */
 	ip_conntrack_unexpect_related(exp);
 	/* we have put what we 'get' above. after this line usage count == 0 */
-	ip_conntrack_expect_put(exp);
+	ip_conntrack_expect_free(exp);
 
 	return 0;
 }
@@ -958,7 +938,7 @@
 static int
 ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	ct_debug(0, "entered\n");
+	DEBUGP("entered %s\n", __FUNCTION__);
 	if (cb->args[0] == 0) {
 		READ_LOCK(&ip_conntrack_lock);
 		LIST_FIND(&ip_conntrack_expect_list, 
@@ -968,7 +948,7 @@
 		READ_UNLOCK(&ip_conntrack_lock);
 		cb->args[0] = 1;
 	}
-	ct_debug(0, "returning\n");
+	DEBUGP("returning\n");
 
 	return skb->len;
 }
@@ -984,8 +964,7 @@
 	struct sk_buff *skb2 = NULL;
 	int err, proto;
 
-	ct_debug(0, "entered\n");
-
+	DEBUGP("entered %s\n", __FUNCTION__);
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct nfgenmsg *msg = NLMSG_DATA(nlh);
 		u32 rlen;
@@ -993,7 +972,7 @@
 		if (msg->nfgen_family != AF_INET)
 			return -EAFNOSUPPORT;
 
-		ct_debug(0, "starting dump\n");
+		DEBUGP("starting dump\n");
 			if ((*errp = netlink_dump_start(ctnl, skb, nlh,
 		    				ctnetlink_exp_dump_table,
 						ctnetlink_done)) != 0)
@@ -1065,15 +1044,15 @@
 	struct ip_conntrack_tuple *tuple, *mask;
 	struct ip_conntrack_tuple *orig, *reply;
 	struct ip_conntrack_tuple_hash *h = NULL;
-	struct ip_conntrack_expect exp, *new;
+	struct ip_conntrack_expect *exp;
 	struct ip_conntrack_helper *helper;
 	unsigned long timeout;
 	int err;
 
-	ct_debug(0, "entered\n");
+	DEBUGP("entered %s\n", __FUNCTION__);
 
 	if (!(cda[CTA_ORIG-1] || cda[CTA_RPLY-1])) {
-		ct_debug(0, "required attributes missing\n");
+		DEBUGP("required attributes missing\n");
 		return -EINVAL;
 	}
 
@@ -1082,21 +1061,13 @@
 	orig  = NFA_DATA(cda[CTA_ORIG-1]);
 	reply = NFA_DATA(cda[CTA_RPLY-1]);
 
-	memcpy(&exp.tuple, tuple, sizeof(struct ip_conntrack_tuple));
-	memcpy(&exp.mask, mask, sizeof(struct ip_conntrack_tuple));
-
-	exp.expectfn = NULL;
-
-	if (cda[CTA_EXP_SEQNO-1])
-		exp.seq = *(u_int32_t *)NFA_DATA(cda[CTA_EXP_SEQNO-1]);
-
-	h = __ip_conntrack_find_get(orig, NULL);
+	h = ip_conntrack_find_get(orig, NULL);
 	if (h == NULL)
-		h = __ip_conntrack_find_get(reply, NULL);
+		h = ip_conntrack_find_get(reply, NULL);
 	if (h == NULL)
 		return -ENOENT;
 
-	helper = h->ctrack->helper;
+	helper = tuplehash_to_ctrack(h)->helper;
 
 	if (cda[CTA_EXP_TIMEOUT-1])
 		timeout = *(unsigned long *)NFA_DATA(cda[CTA_EXP_TIMEOUT-1]);
@@ -1105,24 +1076,21 @@
 	else
 		return -EINVAL;
 
-	if (helper && helper->ctnl_new_expect) {
-		struct cta_exp_proto *cp = NULL;
-		struct cta_exp_help *ch = NULL;
-
-		if (cda[CTA_EXP_PROTO-1])
-			cp = NFA_DATA(cda[CTA_EXP_PROTO-1]);
-		if (cda[CTA_EXP_HELP-1])
-			ch = NFA_DATA(cda[CTA_EXP_HELP-1]);
-		
-		helper->ctnl_new_expect(&exp, &cp->proto, &ch->help);
-	}
+	exp = ip_conntrack_expect_alloc();
+	if (!exp)
+		return -ENOMEM;
+	
+	exp->expectfn = NULL;
+	exp->master = tuplehash_to_ctrack(h);
+	memcpy(&exp->tuple, tuple, sizeof(struct ip_conntrack_tuple));
+	memcpy(&exp->mask, mask, sizeof(struct ip_conntrack_tuple));
 
-	err = __ip_conntrack_expect_related(h->ctrack, &exp, &new);
+	err = ip_conntrack_expect_related(exp);
 	if (err < 0)
 		return err;
 	
-	new->timeout.expires = jiffies + timeout * HZ;
-	add_timer(&new->timeout);
+	exp->timeout.expires = jiffies + timeout * HZ;
+	add_timer(&exp->timeout);
 	return 0;
 }
 
@@ -1149,7 +1117,8 @@
 	mask  = NFA_DATA(cda[CTA_EXP_MASK-1]);
 
 	WRITE_LOCK(&ip_conntrack_lock);
-	exp = __ip_ct_expect_find_tm(tuple, mask);
+	
+	exp = ip_conntrack_expect_find_get(tuple);
 
 	if (exp == NULL) {
 		err = -ENOENT;
@@ -1180,7 +1149,7 @@
 {
 	printk("ctnetlink: unregistering with nfnetlink.\n");
 //	ip_conntrack_notify_unregister(&ctnl_exp_notify);
-	ip_conntrack_notify_unregister(&ctnl_notifier);
+	ip_conntrack_unregister_notifier(&ctnl_notifier);
 	nfnetlink_subsys_unregister(ctnl_subsys);
 	kfree(ctnl_subsys);
 	return;
@@ -1219,7 +1188,7 @@
 		goto err_free_subsys;
 	}
 
-	if ((ret = ip_conntrack_notify_register(&ctnl_notifier)) < 0) {
+	if ((ret = ip_conntrack_register_notifier(&ctnl_notifier)) < 0) {
 		printk("ctnetlink_init: cannot register notifier.\n");
 		goto err_unreg_subsys;
 	}
--- linux-2.5/include/linux/nfnetlink_conntrack.h.orig	2005-03-07 20:40:54.000000000 +0100
+++ linux-2.5/include/linux/nfnetlink_conntrack.h	2005-03-28 00:11:39.000000000 +0200
@@ -5,6 +5,12 @@
 
 /* CTNETLINK for ip_conntrack */
 
+/* TODO: Add more message types:
+ *
+ * 	o CTNL_MSG_UPDCONNTRACK, update conntracks
+ * 	o CTNL_MSG_DMPCONNTRACK, dump conntrack table
+ * 	o CTNL_MSG_FSHCONNTRACK, flush conntrack table
+ */
 enum cntl_msg_types {
 	CTNL_MSG_NEWCONNTRACK,
 	CTNL_MSG_GETCONNTRACK,
@@ -28,15 +34,14 @@
 	CTA_STATUS,     /* [unsigned long] Status of connection. */
 	CTA_PROTOINFO,  /* [cta_proto] Protocol specific ct information. */
 	CTA_HELPINFO,   /* [cta_help] Helper specific information. */
-	CTA_NATINFO,    /* [cta_nat] Any NAT transformations. */
 	CTA_TIMEOUT,    /* [unsigned long] timer */
 	CTA_MARK,       /* [unsigned long] mark .*/
+	CTA_ID,		/* [unsigned int] id */
 	
 	CTA_EXP_TUPLE,	/* [ip_conntrack_tuple] Expected tuple */
 	CTA_EXP_MASK,	/* [ip_conntrack_tuple] Mask for EXP_TUPLE */
 	CTA_EXP_SEQNO,	/* [u_int32_t] sequence number */
 	CTA_EXP_PROTO,	/* [cta_exp_proto] */
-	CTA_EXP_HELP,	/* [cta_exp_help] */
 	CTA_EXP_TIMEOUT,/* [unsigned long] timer */
 
 	CTA_MAX = CTA_EXP_TIMEOUT
@@ -45,12 +50,6 @@
 /* Attribute specific data structures.
  */
 
-#include <linux/netfilter_ipv4/ip_nat.h>
-struct cta_nat {
-	unsigned int num_manips;
-	struct ip_nat_info_manip manips[IP_NAT_MAX_MANIPS];
-};
-
 struct cta_proto {
 	unsigned char num_proto;	/* Protocol number IPPROTO_X */
 	union ip_conntrack_proto proto;
@@ -67,10 +66,6 @@
 	union ip_conntrack_expect_proto proto;
 };
 
-struct cta_exp_help {
-	union ip_conntrack_expect_help help;
-};
-
 /* ctnetlink multicast groups: reports any change of ctinfo,
  * ctstatus, or protocol state change.
  */

--------------040802020008040203050003--
