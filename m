From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 20/22]: Fix whitespace errors
Date: Mon, 12 Feb 2007 11:36:49 +0100 (MET)
Message-ID: <20070212103648.661.34200.sendpatchset@localhost.localdomain>
References: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix whitespace errors

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 353c941b0735b883510bfd7bb98fcd4fc8a0ee08
tree 14c9e7a24feed39641b2f97b6e2b247bd229062c
parent a3987b41ed8c0275393942316c502e4cffbc0126
author YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org> Mon, 12 Feb 2007 11:08:07 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:08:07 +0100

 net/netfilter/core.c                         |    6 -
 net/netfilter/nf_conntrack_core.c            |   18 +-
 net/netfilter/nf_conntrack_expect.c          |    2 
 net/netfilter/nf_conntrack_ftp.c             |   14 +-
 net/netfilter/nf_conntrack_h323_main.c       |   20 +--
 net/netfilter/nf_conntrack_irc.c             |    2 
 net/netfilter/nf_conntrack_l3proto_generic.c |    2 
 net/netfilter/nf_conntrack_netbios_ns.c      |    2 
 net/netfilter/nf_conntrack_netlink.c         |  106 +++++++-------
 net/netfilter/nf_conntrack_pptp.c            |    2 
 net/netfilter/nf_conntrack_proto_sctp.c      |   72 +++++----
 net/netfilter/nf_conntrack_proto_tcp.c       |  204 +++++++++++++-------------
 net/netfilter/nf_conntrack_sip.c             |    6 -
 net/netfilter/nf_conntrack_standalone.c      |    2 
 net/netfilter/nf_conntrack_tftp.c            |    2 
 net/netfilter/nf_internals.h                 |    2 
 net/netfilter/nf_log.c                       |    6 -
 net/netfilter/nf_queue.c                     |   22 +--
 net/netfilter/nf_sockopt.c                   |   12 +-
 net/netfilter/nfnetlink.c                    |   10 +
 net/netfilter/nfnetlink_log.c                |   52 +++----
 net/netfilter/nfnetlink_queue.c              |   84 +++++------
 net/netfilter/x_tables.c                     |   12 +-
 net/netfilter/xt_CLASSIFY.c                  |    4 -
 net/netfilter/xt_MARK.c                      |    4 -
 net/netfilter/xt_NFQUEUE.c                   |    4 -
 net/netfilter/xt_NOTRACK.c                   |    4 -
 net/netfilter/xt_SECMARK.c                   |    2 
 net/netfilter/xt_conntrack.c                 |   32 ++--
 net/netfilter/xt_dccp.c                      |   20 +--
 net/netfilter/xt_hashlimit.c                 |    8 +
 net/netfilter/xt_helper.c                    |   18 +-
 net/netfilter/xt_length.c                    |    4 -
 net/netfilter/xt_limit.c                     |    2 
 net/netfilter/xt_mark.c                      |    6 -
 net/netfilter/xt_multiport.c                 |    2 
 net/netfilter/xt_physdev.c                   |    2 
 net/netfilter/xt_policy.c                    |   24 ++-
 net/netfilter/xt_quota.c                     |    4 -
 net/netfilter/xt_realm.c                     |    2 
 net/netfilter/xt_sctp.c                      |   30 ++--
 net/netfilter/xt_string.c                    |    8 +
 net/netfilter/xt_tcpmss.c                    |    4 -
 43 files changed, 422 insertions(+), 422 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index f61e0c2..c3ebdbd 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -1,4 +1,4 @@
-/* netfilter.c: look after the filters for various protocols. 
+/* netfilter.c: look after the filters for various protocols.
  * Heavily influenced by the old firewall.c by David Bonn and Alan Cox.
  *
  * Thanks to Rob `CmdrTaco' Malda for not influencing this code in any
@@ -141,14 +141,14 @@ unsigned int nf_iterate(struct list_head
 			continue;
 
 		/* Optimization: we don't need to hold module
-                   reference here, since function can't sleep. --RR */
+		   reference here, since function can't sleep. --RR */
 		verdict = elem->hook(hook, skb, indev, outdev, okfn);
 		if (verdict != NF_ACCEPT) {
 #ifdef CONFIG_NETFILTER_DEBUG
 			if (unlikely((verdict & NF_VERDICT_MASK)
 							> NF_MAX_VERDICT)) {
 				NFDEBUG("Evil return from %p(%u).\n",
-				        elem->hook, hook);
+					elem->hook, hook);
 				continue;
 			}
 #endif
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0cc1505..32891eb 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -424,7 +424,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_find_get)
 
 static void __nf_conntrack_hash_insert(struct nf_conn *ct,
 				       unsigned int hash,
-				       unsigned int repl_hash) 
+				       unsigned int repl_hash)
 {
 	ct->id = ++nf_conntrack_next_id;
 	list_add(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list,
@@ -1066,7 +1066,7 @@ get_next_corpse(int (*iter)(struct nf_co
 			if (iter(ct, data))
 				goto found;
 		}
- 	}
+	}
 	list_for_each_entry(h, &unconfirmed, list) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		if (iter(ct, data))
@@ -1107,7 +1107,7 @@ static void free_conntrack_hash(struct l
 	if (vmalloced)
 		vfree(hash);
 	else
-		free_pages((unsigned long)hash, 
+		free_pages((unsigned long)hash,
 			   get_order(sizeof(struct list_head) * size));
 }
 
@@ -1168,18 +1168,18 @@ static struct list_head *alloc_hashtable
 	struct list_head *hash;
 	unsigned int i;
 
-	*vmalloced = 0; 
-	hash = (void*)__get_free_pages(GFP_KERNEL, 
+	*vmalloced = 0;
+	hash = (void*)__get_free_pages(GFP_KERNEL,
 				       get_order(sizeof(struct list_head)
 						 * size));
-	if (!hash) { 
+	if (!hash) {
 		*vmalloced = 1;
 		printk(KERN_WARNING "nf_conntrack: falling back to vmalloc.\n");
 		hash = vmalloc(sizeof(struct list_head) * size);
 	}
 
 	if (hash)
-		for (i = 0; i < size; i++) 
+		for (i = 0; i < size; i++)
 			INIT_LIST_HEAD(&hash[i]);
 
 	return hash;
@@ -1286,9 +1286,9 @@ int __init nf_conntrack_init(void)
 
 	/* Don't NEED lock here, but good form anyway. */
 	write_lock_bh(&nf_conntrack_lock);
-        for (i = 0; i < AF_MAX; i++)
+	for (i = 0; i < AF_MAX; i++)
 		nf_ct_l3protos[i] = &nf_conntrack_l3proto_generic;
-        write_unlock_bh(&nf_conntrack_lock);
+	write_unlock_bh(&nf_conntrack_lock);
 
 	/* For use by REJECT target */
 	rcu_assign_pointer(ip_ct_attach, __nf_conntrack_attach);
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 9cbf926..3139f45 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -130,7 +130,7 @@ void nf_ct_remove_expectations(struct nf
 		if (i->master == ct && del_timer(&i->timeout)) {
 			nf_ct_unlink_expect(i);
 			nf_conntrack_expect_put(i);
- 		}
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(nf_ct_remove_expectations);
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 92a9471..3089dfc 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -126,7 +126,7 @@ get_ipv6_addr(const char *src, size_t dl
 }
 
 static int try_number(const char *data, size_t dlen, u_int32_t array[],
-                      int array_size, char sep, char term)
+		      int array_size, char sep, char term)
 {
 	u_int32_t i, len;
 
@@ -413,8 +413,8 @@ static int help(struct sk_buff **pskb,
 		goto out_update_nl;
 	}
 
-        /* Initialize IP/IPv6 addr to expected address (it's not mentioned
-           in EPSV responses) */
+	/* Initialize IP/IPv6 addr to expected address (it's not mentioned
+	   in EPSV responses) */
 	cmd.l3num = ct->tuplehash[dir].tuple.src.l3num;
 	memcpy(cmd.u3.all, &ct->tuplehash[dir].tuple.src.u3.all,
 	       sizeof(cmd.u3.all));
@@ -466,11 +466,11 @@ static int help(struct sk_buff **pskb,
 	    memcmp(&cmd.u3.all, &ct->tuplehash[dir].tuple.src.u3.all,
 		     sizeof(cmd.u3.all))) {
 		/* Enrico Scholz's passive FTP to partially RNAT'd ftp
-                   server: it really wants us to connect to a
-                   different IP address.  Simply don't record it for
-                   NAT. */
+		   server: it really wants us to connect to a
+		   different IP address.  Simply don't record it for
+		   NAT. */
 		if (cmd.l3num == PF_INET) {
-                	DEBUGP("conntrack_ftp: NOT RECORDING: " NIPQUAD_FMT " != " NIPQUAD_FMT "\n",
+			DEBUGP("conntrack_ftp: NOT RECORDING: " NIPQUAD_FMT " != " NIPQUAD_FMT "\n",
 			       NIPQUAD(cmd.u3.ip),
 			       NIPQUAD(ct->tuplehash[dir].tuple.src.u3.ip));
 		} else {
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 6d85689..b284db7 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -49,7 +49,7 @@ MODULE_PARM_DESC(gkrouted_only, "only ac
 static int callforward_filter __read_mostly = 1;
 module_param(callforward_filter, bool, 0600);
 MODULE_PARM_DESC(callforward_filter, "only create call forwarding expectations "
-		                     "if both endpoints are on different sides "
+				     "if both endpoints are on different sides "
 				     "(determined by routing information)");
 
 /* Hooks for NAT */
@@ -300,7 +300,7 @@ static int expect_rtp_rtcp(struct sk_buf
 				 IPPROTO_UDP, NULL, &rtcp_port);
 
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
-	   	   &ct->tuplehash[!dir].tuple.dst.u3,
+		   &ct->tuplehash[!dir].tuple.dst.u3,
 		   sizeof(ct->tuplehash[dir].tuple.src.u3)) &&
 		   (nat_rtp_rtcp = rcu_dereference(nat_rtp_rtcp_hook)) &&
 		   ct->status & IPS_NAT_MASK) {
@@ -743,7 +743,7 @@ #if defined(CONFIG_IPV6) || defined(CONF
 			rt2 = (struct rt6_info *)ip6_route_output(NULL, &fl2);
 			if (rt2) {
 				if (!memcmp(&rt1->rt6i_gateway, &rt2->rt6i_gateway,
-				 	    sizeof(rt1->rt6i_gateway)) &&
+					    sizeof(rt1->rt6i_gateway)) &&
 				    rt1->u.dst.dev == rt2->u.dst.dev)
 					ret = 1;
 				dst_release(&rt2->u.dst);
@@ -780,7 +780,7 @@ static int expect_callforwarding(struct 
 	 * we don't need to track the second call */
 	if (callforward_filter &&
 	    callforward_do_filter(&addr, &ct->tuplehash[!dir].tuple.src.u3,
-	    			  ct->tuplehash[!dir].tuple.src.l3num)) {
+				  ct->tuplehash[!dir].tuple.src.l3num)) {
 		DEBUGP("nf_ct_q931: Call Forwarding not tracked\n");
 		return 0;
 	}
@@ -840,7 +840,7 @@ static int process_setup(struct sk_buff 
 	if ((setup->options & eSetup_UUIE_destCallSignalAddress) &&
 	    (set_h225_addr) && ct->status && IPS_NAT_MASK &&
 	    get_h225_addr(ct, *data, &setup->destCallSignalAddress,
-	    		  &addr, &port) &&
+			  &addr, &port) &&
 	    memcmp(&addr, &ct->tuplehash[!dir].tuple.src.u3, sizeof(addr))) {
 		DEBUGP("nf_ct_q931: set destCallSignalAddress "
 		       NIP6_FMT ":%hu->" NIP6_FMT ":%hu\n",
@@ -858,7 +858,7 @@ static int process_setup(struct sk_buff 
 	if ((setup->options & eSetup_UUIE_sourceCallSignalAddress) &&
 	    (set_h225_addr) && ct->status & IPS_NAT_MASK &&
 	    get_h225_addr(ct, *data, &setup->sourceCallSignalAddress,
-	    		  &addr, &port) &&
+			  &addr, &port) &&
 	    memcmp(&addr, &ct->tuplehash[!dir].tuple.dst.u3, sizeof(addr))) {
 		DEBUGP("nf_ct_q931: set sourceCallSignalAddress "
 		       NIP6_FMT ":%hu->" NIP6_FMT ":%hu\n",
@@ -1282,7 +1282,7 @@ static int expect_q931(struct sk_buff **
 	for (i = 0; i < count; i++) {
 		if (get_h225_addr(ct, *data, &taddr[i], &addr, &port) &&
 		    memcmp(&addr, &ct->tuplehash[dir].tuple.src.u3,
-		    	   sizeof(addr)) == 0 && port != 0)
+			   sizeof(addr)) == 0 && port != 0)
 			break;
 	}
 
@@ -1294,7 +1294,7 @@ static int expect_q931(struct sk_buff **
 		return -1;
 	nf_conntrack_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
 				 gkrouted_only ? /* only accept calls from GK? */
-				 	&ct->tuplehash[!dir].tuple.src.u3 :
+					&ct->tuplehash[!dir].tuple.src.u3 :
 					NULL,
 				 &ct->tuplehash[!dir].tuple.dst.u3,
 				 IPPROTO_TCP, NULL, &port);
@@ -1513,7 +1513,7 @@ static int process_arq(struct sk_buff **
 	set_h225_addr = rcu_dereference(set_h225_addr_hook);
 	if ((arq->options & eAdmissionRequest_destCallSignalAddress) &&
 	    get_h225_addr(ct, *data, &arq->destCallSignalAddress,
-	    		  &addr, &port) &&
+			  &addr, &port) &&
 	    !memcmp(&addr, &ct->tuplehash[dir].tuple.src.u3, sizeof(addr)) &&
 	    port == info->sig_port[dir] &&
 	    set_h225_addr && ct->status & IPS_NAT_MASK) {
@@ -1526,7 +1526,7 @@ static int process_arq(struct sk_buff **
 
 	if ((arq->options & eAdmissionRequest_srcCallSignalAddress) &&
 	    get_h225_addr(ct, *data, &arq->srcCallSignalAddress,
-	    		  &addr, &port) &&
+			  &addr, &port) &&
 	    !memcmp(&addr, &ct->tuplehash[dir].tuple.src.u3, sizeof(addr)) &&
 	    set_h225_addr && ct->status & IPS_NAT_MASK) {
 		/* Calling ARQ */
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index ed01db6..43ccd0e 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -57,7 +57,7 @@ #define MINMATCHLEN	5
 
 #if 0
 #define DEBUGP(format, args...) printk(KERN_DEBUG "%s:%s:" format, \
-                                       __FILE__, __FUNCTION__ , ## args)
+				       __FILE__, __FUNCTION__ , ## args)
 #else
 #define DEBUGP(format, args...)
 #endif
diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
index a3d31c3..cbd96f3 100644
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ b/net/netfilter/nf_conntrack_l3proto_generic.c
@@ -77,7 +77,7 @@ generic_prepare(struct sk_buff **pskb, u
 
 
 static u_int32_t generic_get_features(const struct nf_conntrack_tuple *tuple)
-				
+
 {
 	return NF_CT_F_BASIC;
 }
diff --git a/net/netfilter/nf_conntrack_netbios_ns.c b/net/netfilter/nf_conntrack_netbios_ns.c
index 2a48efd..bb26a65 100644
--- a/net/netfilter/nf_conntrack_netbios_ns.c
+++ b/net/netfilter/nf_conntrack_netbios_ns.c
@@ -43,7 +43,7 @@ module_param(timeout, uint, 0400);
 MODULE_PARM_DESC(timeout, "timeout for master connection/replies in seconds");
 
 static int help(struct sk_buff **pskb, unsigned int protoff,
-                struct nf_conn *ct, enum ip_conntrack_info ctinfo)
+		struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 {
 	struct nf_conntrack_expect *exp;
 	struct iphdr *iph = (*pskb)->nh.iph;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c64f029..48f0531 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -6,10 +6,10 @@
  * (C) 2003 by Patrick Mchardy <kaber@trash.net>
  * (C) 2005-2006 by Pablo Neira Ayuso <pablo@eurodev.net>
  *
- * I've reworked this stuff to use attributes instead of conntrack 
+ * I've reworked this stuff to use attributes instead of conntrack
  * structures. 5.44 am. I need more tea. --pablo 05/07/11.
  *
- * Initial connection tracking via netlink development funded and 
+ * Initial connection tracking via netlink development funded and
  * generally made possible by Network Robots, Inc. (www.networkrobots.com)
  *
  * Further development of this code funded by Astaro AG (http://www.astaro.com)
@@ -53,7 +53,7 @@ MODULE_LICENSE("GPL");
 static char __initdata version[] = "0.93";
 
 static inline int
-ctnetlink_dump_tuples_proto(struct sk_buff *skb, 
+ctnetlink_dump_tuples_proto(struct sk_buff *skb,
 			    const struct nf_conntrack_tuple *tuple,
 			    struct nf_conntrack_l4proto *l4proto)
 {
@@ -64,7 +64,7 @@ ctnetlink_dump_tuples_proto(struct sk_bu
 
 	if (likely(l4proto->tuple_to_nfattr))
 		ret = l4proto->tuple_to_nfattr(skb, tuple);
-	
+
 	NFA_NEST_END(skb, nest_parms);
 
 	return ret;
@@ -135,7 +135,7 @@ ctnetlink_dump_timeout(struct sk_buff *s
 		timeout = 0;
 	else
 		timeout = htonl(timeout_l / HZ);
-	
+
 	NFA_PUT(skb, CTA_TIMEOUT, sizeof(timeout), &timeout);
 	return 0;
 
@@ -154,7 +154,7 @@ ctnetlink_dump_protoinfo(struct sk_buff 
 		nf_ct_l4proto_put(l4proto);
 		return 0;
 	}
-	
+
 	nest_proto = NFA_NEST(skb, CTA_PROTOINFO);
 
 	ret = l4proto->to_nfattr(skb, nest_proto, ct);
@@ -178,7 +178,7 @@ ctnetlink_dump_helpinfo(struct sk_buff *
 
 	if (!help || !help->helper)
 		return 0;
-		
+
 	nest_helper = NFA_NEST(skb, CTA_HELP);
 	NFA_PUT(skb, CTA_HELP_NAME, strlen(help->helper->name), help->helper->name);
 
@@ -250,7 +250,7 @@ static inline int
 ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	__be32 use = htonl(atomic_read(&ct->ct_general.use));
-	
+
 	NFA_PUT(skb, CTA_USE, sizeof(u_int32_t), &use);
 	return 0;
 
@@ -262,7 +262,7 @@ #define tuple(ct, dir) (&(ct)->tuplehash
 
 static int
 ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
-		    int event, int nowait, 
+		    int event, int nowait,
 		    const struct nf_conn *ct)
 {
 	struct nlmsghdr *nlh;
@@ -277,7 +277,7 @@ ctnetlink_fill_info(struct sk_buff *skb,
 	nfmsg  = NLMSG_DATA(nlh);
 
 	nlh->nlmsg_flags    = (nowait && pid) ? NLM_F_MULTI : 0;
-	nfmsg->nfgen_family = 
+	nfmsg->nfgen_family =
 		ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	nfmsg->version      = NFNETLINK_V0;
 	nfmsg->res_id	    = 0;
@@ -286,7 +286,7 @@ ctnetlink_fill_info(struct sk_buff *skb,
 	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
 		goto nfattr_failure;
 	NFA_NEST_END(skb, nest_parms);
-	
+
 	nest_parms = NFA_NEST(skb, CTA_TUPLE_REPLY);
 	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_REPLY)) < 0)
 		goto nfattr_failure;
@@ -314,7 +314,7 @@ nfattr_failure:
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 static int ctnetlink_conntrack_event(struct notifier_block *this,
-                                     unsigned long events, void *ptr)
+				     unsigned long events, void *ptr)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
@@ -364,7 +364,7 @@ static int ctnetlink_conntrack_event(str
 	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
 		goto nfattr_failure;
 	NFA_NEST_END(skb, nest_parms);
-	
+
 	nest_parms = NFA_NEST(skb, CTA_TUPLE_REPLY);
 	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_REPLY)) < 0)
 		goto nfattr_failure;
@@ -383,16 +383,16 @@ static int ctnetlink_conntrack_event(str
 
 		if (events & IPCT_PROTOINFO
 		    && ctnetlink_dump_protoinfo(skb, ct) < 0)
-		    	goto nfattr_failure;
+			goto nfattr_failure;
 
 		if ((events & IPCT_HELPER || nfct_help(ct))
 		    && ctnetlink_dump_helpinfo(skb, ct) < 0)
-		    	goto nfattr_failure;
+			goto nfattr_failure;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
 		if ((events & IPCT_MARK || ct->mark)
 		    && ctnetlink_dump_mark(skb, ct) < 0)
-		    	goto nfattr_failure;
+			goto nfattr_failure;
 #endif
 
 		if (events & IPCT_COUNTER_FILLING &&
@@ -450,7 +450,7 @@ restart:
 				cb->args[1] = 0;
 			}
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
-		                        	cb->nlh->nlmsg_seq,
+						cb->nlh->nlmsg_seq,
 						IPCTNL_MSG_CT_NEW,
 						1, ct) < 0) {
 				nf_conntrack_get(&ct->ct_general);
@@ -500,7 +500,7 @@ static const size_t cta_min_proto[CTA_PR
 };
 
 static inline int
-ctnetlink_parse_tuple_proto(struct nfattr *attr, 
+ctnetlink_parse_tuple_proto(struct nfattr *attr,
 			    struct nf_conntrack_tuple *tuple)
 {
 	struct nfattr *tb[CTA_PROTO_MAX];
@@ -522,7 +522,7 @@ ctnetlink_parse_tuple_proto(struct nfatt
 		ret = l4proto->nfattr_to_tuple(tb, tuple);
 
 	nf_ct_l4proto_put(l4proto);
-	
+
 	return ret;
 }
 
@@ -609,7 +609,7 @@ nfnetlink_parse_nat(struct nfattr *nat,
 	int err;
 
 	memset(range, 0, sizeof(*range));
-	
+
 	nfattr_parse_nested(tb, CTA_NAT_MAX, nat);
 
 	if (nfattr_bad_size(tb, CTA_NAT_MAX, cta_min_nat))
@@ -661,7 +661,7 @@ static const size_t cta_min[CTA_MAX] = {
 };
 
 static int
-ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb, 
+ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			struct nlmsghdr *nlh, struct nfattr *cda[], int *errp)
 {
 	struct nf_conntrack_tuple_hash *h;
@@ -692,14 +692,14 @@ ctnetlink_del_conntrack(struct sock *ctn
 		return -ENOENT;
 
 	ct = nf_ct_tuplehash_to_ctrack(h);
-	
+
 	if (cda[CTA_ID-1]) {
 		u_int32_t id = ntohl(*(__be32 *)NFA_DATA(cda[CTA_ID-1]));
 		if (ct->id != id) {
 			nf_ct_put(ct);
 			return -ENOENT;
 		}
-	}	
+	}
 	if (del_timer(&ct->timeout))
 		ct->timeout.function((unsigned long)ct);
 
@@ -709,7 +709,7 @@ ctnetlink_del_conntrack(struct sock *ctn
 }
 
 static int
-ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb, 
+ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			struct nlmsghdr *nlh, struct nfattr *cda[], int *errp)
 {
 	struct nf_conntrack_tuple_hash *h;
@@ -765,7 +765,7 @@ #endif
 		return -ENOMEM;
 	}
 
-	err = ctnetlink_fill_info(skb2, NETLINK_CB(skb).pid, nlh->nlmsg_seq, 
+	err = ctnetlink_fill_info(skb2, NETLINK_CB(skb).pid, nlh->nlmsg_seq,
 				  IPCTNL_MSG_CT_NEW, 1, ct);
 	nf_ct_put(ct);
 	if (err <= 0)
@@ -793,12 +793,12 @@ ctnetlink_change_status(struct nf_conn *
 	if (d & (IPS_EXPECTED|IPS_CONFIRMED|IPS_DYING))
 		/* unchangeable */
 		return -EINVAL;
-	
+
 	if (d & IPS_SEEN_REPLY && !(status & IPS_SEEN_REPLY))
 		/* SEEN_REPLY bit can only be set */
 		return -EINVAL;
 
-	
+
 	if (d & IPS_ASSURED && !(status & IPS_ASSURED))
 		/* ASSURED bit can only be set */
 		return -EINVAL;
@@ -877,7 +877,7 @@ ctnetlink_change_helper(struct nf_conn *
 			memset(&help->help, 0, sizeof(help->help));
 		}
 	}
-	
+
 	help->helper = helper;
 
 	return 0;
@@ -887,7 +887,7 @@ static inline int
 ctnetlink_change_timeout(struct nf_conn *ct, struct nfattr *cda[])
 {
 	u_int32_t timeout = ntohl(*(__be32 *)NFA_DATA(cda[CTA_TIMEOUT-1]));
-	
+
 	if (!del_timer(&ct->timeout))
 		return -ETIME;
 
@@ -955,7 +955,7 @@ #endif
 }
 
 static int
-ctnetlink_create_conntrack(struct nfattr *cda[], 
+ctnetlink_create_conntrack(struct nfattr *cda[],
 			   struct nf_conntrack_tuple *otuple,
 			   struct nf_conntrack_tuple *rtuple)
 {
@@ -965,7 +965,7 @@ ctnetlink_create_conntrack(struct nfattr
 
 	ct = nf_conntrack_alloc(otuple, rtuple);
 	if (ct == NULL || IS_ERR(ct))
-		return -ENOMEM;	
+		return -ENOMEM;
 
 	if (!cda[CTA_TIMEOUT-1])
 		goto err;
@@ -1003,13 +1003,13 @@ #endif
 
 	return 0;
 
-err:	
+err:
 	nf_conntrack_free(ct);
 	return err;
 }
 
-static int 
-ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb, 
+static int
+ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			struct nlmsghdr *nlh, struct nfattr *cda[], int *errp)
 {
 	struct nf_conntrack_tuple otuple, rtuple;
@@ -1065,9 +1065,9 @@ out_unlock:
 	return err;
 }
 
-/*********************************************************************** 
- * EXPECT 
- ***********************************************************************/ 
+/***********************************************************************
+ * EXPECT
+ ***********************************************************************/
 
 static inline int
 ctnetlink_exp_dump_tuple(struct sk_buff *skb,
@@ -1075,7 +1075,7 @@ ctnetlink_exp_dump_tuple(struct sk_buff 
 			 enum ctattr_expect type)
 {
 	struct nfattr *nest_parms = NFA_NEST(skb, type);
-	
+
 	if (ctnetlink_dump_tuples(skb, tuple) < 0)
 		goto nfattr_failure;
 
@@ -1085,7 +1085,7 @@ ctnetlink_exp_dump_tuple(struct sk_buff 
 
 nfattr_failure:
 	return -1;
-}			
+}
 
 static inline int
 ctnetlink_exp_dump_mask(struct sk_buff *skb,
@@ -1120,7 +1120,7 @@ nfattr_failure:
 
 static inline int
 ctnetlink_exp_dump_expect(struct sk_buff *skb,
-                          const struct nf_conntrack_expect *exp)
+			  const struct nf_conntrack_expect *exp)
 {
 	struct nf_conn *master = exp->master;
 	__be32 timeout = htonl((exp->timeout.expires - jiffies) / HZ);
@@ -1134,20 +1134,20 @@ ctnetlink_exp_dump_expect(struct sk_buff
 				 &master->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 				 CTA_EXPECT_MASTER) < 0)
 		goto nfattr_failure;
-	
+
 	NFA_PUT(skb, CTA_EXPECT_TIMEOUT, sizeof(timeout), &timeout);
 	NFA_PUT(skb, CTA_EXPECT_ID, sizeof(u_int32_t), &id);
 
 	return 0;
-	
+
 nfattr_failure:
 	return -1;
 }
 
 static int
 ctnetlink_exp_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
-		    int event, 
-		    int nowait, 
+		    int event,
+		    int nowait,
 		    const struct nf_conntrack_expect *exp)
 {
 	struct nlmsghdr *nlh;
@@ -1250,7 +1250,7 @@ ctnetlink_exp_dump_table(struct sk_buff 
 			goto out;
 		*id = exp->id;
 	}
-out:	
+out:
 	read_unlock_bh(&nf_conntrack_lock);
 
 	return skb->len;
@@ -1262,7 +1262,7 @@ static const size_t cta_min_exp[CTA_EXPE
 };
 
 static int
-ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb, 
+ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
 		     struct nlmsghdr *nlh, struct nfattr *cda[], int *errp)
 {
 	struct nf_conntrack_tuple tuple;
@@ -1279,7 +1279,7 @@ ctnetlink_get_expect(struct sock *ctnl, 
 		u32 rlen;
 
 		if ((*errp = netlink_dump_start(ctnl, skb, nlh,
-		    				ctnetlink_exp_dump_table,
+						ctnetlink_exp_dump_table,
 						ctnetlink_done)) != 0)
 			return -EINVAL;
 		rlen = NLMSG_ALIGN(nlh->nlmsg_len);
@@ -1307,14 +1307,14 @@ ctnetlink_get_expect(struct sock *ctnl, 
 			nf_conntrack_expect_put(exp);
 			return -ENOENT;
 		}
-	}	
+	}
 
 	err = -ENOMEM;
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!skb2)
 		goto out;
 
-	err = ctnetlink_exp_fill_info(skb2, NETLINK_CB(skb).pid, 
+	err = ctnetlink_exp_fill_info(skb2, NETLINK_CB(skb).pid,
 				      nlh->nlmsg_seq, IPCTNL_MSG_EXP_NEW,
 				      1, exp);
 	if (err <= 0)
@@ -1332,7 +1332,7 @@ out:
 }
 
 static int
-ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb, 
+ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 		     struct nlmsghdr *nlh, struct nfattr *cda[], int *errp)
 {
 	struct nf_conntrack_expect *exp, *tmp;
@@ -1366,7 +1366,7 @@ ctnetlink_del_expect(struct sock *ctnl, 
 
 		/* after list removal, usage count == 1 */
 		nf_conntrack_unexpect_related(exp);
-		/* have to put what we 'get' above. 
+		/* have to put what we 'get' above.
 		 * after this line usage count == 0 */
 		nf_conntrack_expect_put(exp);
 	} else if (cda[CTA_EXPECT_HELP_NAME-1]) {
@@ -1449,7 +1449,7 @@ ctnetlink_create_expect(struct nfattr *c
 		err = -ENOMEM;
 		goto out;
 	}
-	
+
 	exp->expectfn = NULL;
 	exp->flags = 0;
 	exp->master = ct;
@@ -1460,7 +1460,7 @@ ctnetlink_create_expect(struct nfattr *c
 	err = nf_conntrack_expect_related(exp);
 	nf_conntrack_expect_put(exp);
 
-out:	
+out:
 	nf_ct_put(nf_ct_tuplehash_to_ctrack(h));
 	return err;
 }
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index c59df3b..115bcb5 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -520,7 +520,7 @@ conntrack_pptp_help(struct sk_buff **psk
 	tcph = skb_header_pointer(*pskb, nexthdr_off, sizeof(_tcph), &_tcph);
 	BUG_ON(!tcph);
 	nexthdr_off += tcph->doff * 4;
- 	datalen = tcplen - tcph->doff * 4;
+	datalen = tcplen - tcph->doff * 4;
 
 	pptph = skb_header_pointer(*pskb, nexthdr_off, sizeof(_pptph), &_pptph);
 	if (!pptph) {
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 76e2636..0133afa 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -1,9 +1,9 @@
 /*
  * Connection tracking protocol helper module for SCTP.
- * 
- * SCTP is defined in RFC 2960. References to various sections in this code 
+ *
+ * SCTP is defined in RFC 2960. References to various sections in this code
  * are to this RFC.
- * 
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -45,7 +45,7 @@ #endif
 static DEFINE_RWLOCK(sctp_lock);
 
 /* FIXME: Examine ipfilter's timeouts and conntrack transitions more
-   closely.  They're more complex. --RR 
+   closely.  They're more complex. --RR
 
    And so for me for SCTP :D -Kiran */
 
@@ -94,32 +94,32 @@ #define	sSR SCTP_CONNTRACK_SHUTDOWN_RECD
 #define	sSA SCTP_CONNTRACK_SHUTDOWN_ACK_SENT
 #define	sIV SCTP_CONNTRACK_MAX
 
-/* 
+/*
 	These are the descriptions of the states:
 
-NOTE: These state names are tantalizingly similar to the states of an 
+NOTE: These state names are tantalizingly similar to the states of an
 SCTP endpoint. But the interpretation of the states is a little different,
-considering that these are the states of the connection and not of an end 
+considering that these are the states of the connection and not of an end
 point. Please note the subtleties. -Kiran
 
 NONE              - Nothing so far.
-COOKIE WAIT       - We have seen an INIT chunk in the original direction, or also 
-                    an INIT_ACK chunk in the reply direction.
+COOKIE WAIT       - We have seen an INIT chunk in the original direction, or also
+		    an INIT_ACK chunk in the reply direction.
 COOKIE ECHOED     - We have seen a COOKIE_ECHO chunk in the original direction.
 ESTABLISHED       - We have seen a COOKIE_ACK in the reply direction.
 SHUTDOWN_SENT     - We have seen a SHUTDOWN chunk in the original direction.
 SHUTDOWN_RECD     - We have seen a SHUTDOWN chunk in the reply directoin.
 SHUTDOWN_ACK_SENT - We have seen a SHUTDOWN_ACK chunk in the direction opposite
-                    to that of the SHUTDOWN chunk.
-CLOSED            - We have seen a SHUTDOWN_COMPLETE chunk in the direction of 
-                    the SHUTDOWN chunk. Connection is closed.
+		    to that of the SHUTDOWN chunk.
+CLOSED            - We have seen a SHUTDOWN_COMPLETE chunk in the direction of
+		    the SHUTDOWN chunk. Connection is closed.
 */
 
 /* TODO
- - I have assumed that the first INIT is in the original direction. 
+ - I have assumed that the first INIT is in the original direction.
  This messes things when an INIT comes in the reply direction in CLOSED
  state.
- - Check the error type in the reply dir before transitioning from 
+ - Check the error type in the reply dir before transitioning from
 cookie echoed to closed.
  - Sec 5.2.4 of RFC 2960
  - Multi Homing support.
@@ -237,7 +237,7 @@ static int do_basic_checks(struct nf_con
 	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
 		DEBUGP("Chunk Num: %d  Type: %d\n", count, sch->type);
 
-		if (sch->type == SCTP_CID_INIT 
+		if (sch->type == SCTP_CID_INIT
 			|| sch->type == SCTP_CID_INIT_ACK
 			|| sch->type == SCTP_CID_SHUTDOWN_COMPLETE) {
 			flag = 1;
@@ -277,42 +277,42 @@ static int new_state(enum ip_conntrack_d
 	DEBUGP("Chunk type: %d\n", chunk_type);
 
 	switch (chunk_type) {
-		case SCTP_CID_INIT: 
+		case SCTP_CID_INIT:
 			DEBUGP("SCTP_CID_INIT\n");
 			i = 0; break;
-		case SCTP_CID_INIT_ACK: 
+		case SCTP_CID_INIT_ACK:
 			DEBUGP("SCTP_CID_INIT_ACK\n");
 			i = 1; break;
-		case SCTP_CID_ABORT: 
+		case SCTP_CID_ABORT:
 			DEBUGP("SCTP_CID_ABORT\n");
 			i = 2; break;
-		case SCTP_CID_SHUTDOWN: 
+		case SCTP_CID_SHUTDOWN:
 			DEBUGP("SCTP_CID_SHUTDOWN\n");
 			i = 3; break;
-		case SCTP_CID_SHUTDOWN_ACK: 
+		case SCTP_CID_SHUTDOWN_ACK:
 			DEBUGP("SCTP_CID_SHUTDOWN_ACK\n");
 			i = 4; break;
-		case SCTP_CID_ERROR: 
+		case SCTP_CID_ERROR:
 			DEBUGP("SCTP_CID_ERROR\n");
 			i = 5; break;
-		case SCTP_CID_COOKIE_ECHO: 
+		case SCTP_CID_COOKIE_ECHO:
 			DEBUGP("SCTP_CID_COOKIE_ECHO\n");
 			i = 6; break;
-		case SCTP_CID_COOKIE_ACK: 
+		case SCTP_CID_COOKIE_ACK:
 			DEBUGP("SCTP_CID_COOKIE_ACK\n");
 			i = 7; break;
-		case SCTP_CID_SHUTDOWN_COMPLETE: 
+		case SCTP_CID_SHUTDOWN_COMPLETE:
 			DEBUGP("SCTP_CID_SHUTDOWN_COMPLETE\n");
 			i = 8; break;
 		default:
 			/* Other chunks like DATA, SACK, HEARTBEAT and
 			its ACK do not cause a change in state */
-			DEBUGP("Unknown chunk type, Will stay in %s\n", 
+			DEBUGP("Unknown chunk type, Will stay in %s\n",
 						sctp_conntrack_names[cur_state]);
 			return cur_state;
 	}
 
-	DEBUGP("dir: %d   cur_state: %s  chunk_type: %d  new_state: %s\n", 
+	DEBUGP("dir: %d   cur_state: %s  chunk_type: %d  new_state: %s\n",
 			dir, sctp_conntrack_names[cur_state], chunk_type,
 			sctp_conntrack_names[sctp_conntracks[dir][i][cur_state]]);
 
@@ -377,7 +377,7 @@ static int sctp_packet(struct nf_conn *c
 			/* Sec 8.5.1 (C) */
 			if (!(sh->vtag == conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])
 				&& !(sh->vtag == conntrack->proto.sctp.vtag
-							[1 - CTINFO2DIR(ctinfo)] 
+							[1 - CTINFO2DIR(ctinfo)]
 					&& (sch->flags & 1))) {
 				write_unlock_bh(&sctp_lock);
 				return -1;
@@ -402,17 +402,17 @@ static int sctp_packet(struct nf_conn *c
 		}
 
 		/* If it is an INIT or an INIT ACK note down the vtag */
-		if (sch->type == SCTP_CID_INIT 
+		if (sch->type == SCTP_CID_INIT
 			|| sch->type == SCTP_CID_INIT_ACK) {
 			sctp_inithdr_t _inithdr, *ih;
 
 			ih = skb_header_pointer(skb, offset + sizeof(sctp_chunkhdr_t),
-			                        sizeof(_inithdr), &_inithdr);
+						sizeof(_inithdr), &_inithdr);
 			if (ih == NULL) {
 					write_unlock_bh(&sctp_lock);
 					return -1;
 			}
-			DEBUGP("Setting vtag %x for dir %d\n", 
+			DEBUGP("Setting vtag %x for dir %d\n",
 					ih->init_tag, !CTINFO2DIR(ctinfo));
 			conntrack->proto.sctp.vtag[!CTINFO2DIR(ctinfo)] = ih->init_tag;
 		}
@@ -466,7 +466,7 @@ static int sctp_new(struct nf_conn *conn
 	newconntrack = SCTP_CONNTRACK_MAX;
 	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
 		/* Don't need lock here: this conntrack not in circulation yet */
-		newconntrack = new_state(IP_CT_DIR_ORIGINAL, 
+		newconntrack = new_state(IP_CT_DIR_ORIGINAL,
 					 SCTP_CONNTRACK_NONE, sch->type);
 
 		/* Invalid: delete conntrack */
@@ -481,14 +481,14 @@ static int sctp_new(struct nf_conn *conn
 				sctp_inithdr_t _inithdr, *ih;
 
 				ih = skb_header_pointer(skb, offset + sizeof(sctp_chunkhdr_t),
-				                        sizeof(_inithdr), &_inithdr);
+							sizeof(_inithdr), &_inithdr);
 				if (ih == NULL)
 					return 0;
 
-				DEBUGP("Setting vtag %x for new conn\n", 
+				DEBUGP("Setting vtag %x for new conn\n",
 					ih->init_tag);
 
-				conntrack->proto.sctp.vtag[IP_CT_DIR_REPLY] = 
+				conntrack->proto.sctp.vtag[IP_CT_DIR_REPLY] =
 								ih->init_tag;
 			} else {
 				/* Sec 8.5.1 (A) */
@@ -498,7 +498,7 @@ static int sctp_new(struct nf_conn *conn
 		/* If it is a shutdown ack OOTB packet, we expect a return
 		   shutdown complete, otherwise an ABORT Sec 8.4 (5) and (8) */
 		else {
-			DEBUGP("Setting vtag %x for new conn OOTB\n", 
+			DEBUGP("Setting vtag %x for new conn OOTB\n",
 				sh->vtag);
 			conntrack->proto.sctp.vtag[IP_CT_DIR_REPLY] = sh->vtag;
 		}
@@ -698,7 +698,7 @@ int __init nf_conntrack_proto_sctp_init(
  cleanup_sctp4:
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_sctp4);
  out:
-	DEBUGP("SCTP conntrack module loading %s\n", 
+	DEBUGP("SCTP conntrack module loading %s\n",
 					ret ? "failed": "succeeded");
 	return ret;
 }
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 6fccdcf..c2884f9 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -55,8 +55,8 @@ #endif
 /* Protects conntrack->proto.tcp */
 static DEFINE_RWLOCK(tcp_lock);
 
-/* "Be conservative in what you do, 
-    be liberal in what you accept from others." 
+/* "Be conservative in what you do,
+    be liberal in what you accept from others."
     If it's non-zero, we mark only out of window RST segments as INVALID. */
 int nf_ct_tcp_be_liberal __read_mostly = 0;
 
@@ -64,8 +64,8 @@ int nf_ct_tcp_be_liberal __read_mostly =
    connections. */
 int nf_ct_tcp_loose __read_mostly = 1;
 
-/* Max number of the retransmitted packets without receiving an (acceptable) 
-   ACK from the destination. If this number is reached, a shorter timer 
+/* Max number of the retransmitted packets without receiving an (acceptable)
+   ACK from the destination. If this number is reached, a shorter timer
    will be started. */
 int nf_ct_tcp_max_retrans __read_mostly = 3;
 
@@ -84,7 +84,7 @@ static const char *tcp_conntrack_names[]
 	"CLOSE",
 	"LISTEN"
 };
-  
+
 #define SECS * HZ
 #define MINS * 60 SECS
 #define HOURS * 60 MINS
@@ -100,10 +100,10 @@ static unsigned int nf_ct_tcp_timeout_ti
 static unsigned int nf_ct_tcp_timeout_close __read_mostly =        10 SECS;
 
 /* RFC1122 says the R2 limit should be at least 100 seconds.
-   Linux uses 15 packets as limit, which corresponds 
+   Linux uses 15 packets as limit, which corresponds
    to ~13-30min depending on RTO. */
 static unsigned int nf_ct_tcp_timeout_max_retrans __read_mostly =   5 MINS;
- 
+
 static unsigned int * tcp_timeouts[] = {
     NULL,                              /* TCP_CONNTRACK_NONE */
     &nf_ct_tcp_timeout_syn_sent,       /* TCP_CONNTRACK_SYN_SENT, */
@@ -116,7 +116,7 @@ static unsigned int * tcp_timeouts[] = {
     &nf_ct_tcp_timeout_close,          /* TCP_CONNTRACK_CLOSE, */
     NULL,                              /* TCP_CONNTRACK_LISTEN */
  };
- 
+
 #define sNO TCP_CONNTRACK_NONE
 #define sSS TCP_CONNTRACK_SYN_SENT
 #define sSR TCP_CONNTRACK_SYN_RECV
@@ -139,13 +139,13 @@ enum tcp_bit_set {
 	TCP_RST_SET,
 	TCP_NONE_SET,
 };
-  
+
 /*
  * The TCP state transition table needs a few words...
  *
  * We are the man in the middle. All the packets go through us
  * but might get lost in transit to the destination.
- * It is assumed that the destinations can't receive segments 
+ * It is assumed that the destinations can't receive segments
  * we haven't seen.
  *
  * The checked segment is in window, but our windows are *not*
@@ -155,11 +155,11 @@ enum tcp_bit_set {
  * The meaning of the states are:
  *
  * NONE:	initial state
- * SYN_SENT:	SYN-only packet seen 
+ * SYN_SENT:	SYN-only packet seen
  * SYN_RECV:	SYN-ACK packet seen
  * ESTABLISHED:	ACK packet seen
  * FIN_WAIT:	FIN packet seen
- * CLOSE_WAIT:	ACK seen (after FIN) 
+ * CLOSE_WAIT:	ACK seen (after FIN)
  * LAST_ACK:	FIN seen (after FIN)
  * TIME_WAIT:	last ACK seen
  * CLOSE:	closed connection
@@ -167,8 +167,8 @@ enum tcp_bit_set {
  * LISTEN state is not used.
  *
  * Packets marked as IGNORED (sIG):
- *	if they may be either invalid or valid 
- *	and the receiver may send back a connection 
+ *	if they may be either invalid or valid
+ *	and the receiver may send back a connection
  *	closing RST or a SYN/ACK.
  *
  * Packets marked as INVALID (sIV):
@@ -185,7 +185,7 @@ static enum tcp_conntrack tcp_conntracks
  *	sSS -> sSS	Retransmitted SYN
  *	sSR -> sIG	Late retransmitted SYN?
  *	sES -> sIG	Error: SYNs in window outside the SYN_SENT state
- *			are errors. Receiver will reply with RST 
+ *			are errors. Receiver will reply with RST
  *			and close the connection.
  *			Or we are not in sync and hold a dead connection.
  *	sFW -> sIG
@@ -198,10 +198,10 @@ static enum tcp_conntrack tcp_conntracks
 /*synack*/ { sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV },
 /*
  * A SYN/ACK from the client is always invalid:
- *	- either it tries to set up a simultaneous open, which is 
+ *	- either it tries to set up a simultaneous open, which is
  *	  not supported;
  *	- or the firewall has just been inserted between the two hosts
- *	  during the session set-up. The SYN will be retransmitted 
+ *	  during the session set-up. The SYN will be retransmitted
  *	  by the true client (or it'll time out).
  */
 /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
@@ -213,7 +213,7 @@ static enum tcp_conntrack tcp_conntracks
  *	sSR -> sFW	Close started.
  *	sES -> sFW
  *	sFW -> sLA	FIN seen in both directions, waiting for
- *			the last ACK. 
+ *			the last ACK.
  *			Migth be a retransmitted FIN as well...
  *	sCW -> sLA
  *	sLA -> sLA	Retransmitted FIN. Remain in the same state.
@@ -291,7 +291,7 @@ static enum tcp_conntrack tcp_conntracks
 /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
 /*rst*/    { sIV, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sIV },
 /*none*/   { sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV }
-  	}
+	}
 };
 
 static int tcp_pkt_to_tuple(const struct sk_buff *skb,
@@ -352,21 +352,21 @@ static unsigned int get_conntrack_index(
 
 /* TCP connection tracking based on 'Real Stateful TCP Packet Filtering
    in IP Filter' by Guido van Rooij.
-   
+
    http://www.nluug.nl/events/sane2000/papers.html
    http://www.iae.nl/users/guido/papers/tcp_filtering.ps.gz
-   
+
    The boundaries and the conditions are changed according to RFC793:
    the packet must intersect the window (i.e. segments may be
    after the right or before the left edge) and thus receivers may ACK
    segments after the right edge of the window.
 
-   	td_maxend = max(sack + max(win,1)) seen in reply packets
+	td_maxend = max(sack + max(win,1)) seen in reply packets
 	td_maxwin = max(max(win, 1)) + (sack - ack) seen in sent packets
 	td_maxwin += seq + len - sender.td_maxend
 			if seq + len > sender.td_maxend
 	td_end    = max(seq + len) seen in sent packets
-   
+
    I.   Upper bound for valid data:	seq <= sender.td_maxend
    II.  Lower bound for valid data:	seq + len >= sender.td_end - receiver.td_maxwin
    III.	Upper bound for valid ack:      sack <= receiver.td_end
@@ -374,8 +374,8 @@ static unsigned int get_conntrack_index(
 
    where sack is the highest right edge of sack block found in the packet.
 
-   The upper bound limit for a valid ack is not ignored - 
-   we doesn't have to deal with fragments. 
+   The upper bound limit for a valid ack is not ignored -
+   we doesn't have to deal with fragments.
 */
 
 static inline __u32 segment_seq_plus_len(__u32 seq,
@@ -388,19 +388,19 @@ static inline __u32 segment_seq_plus_len
 	return (seq + len - dataoff - tcph->doff*4
 		+ (tcph->syn ? 1 : 0) + (tcph->fin ? 1 : 0));
 }
-  
+
 /* Fixme: what about big packets? */
 #define MAXACKWINCONST			66000
 #define MAXACKWINDOW(sender)						\
 	((sender)->td_maxwin > MAXACKWINCONST ? (sender)->td_maxwin	\
 					      : MAXACKWINCONST)
-  
+
 /*
  * Simplified tcp_parse_options routine from tcp_input.c
  */
 static void tcp_options(const struct sk_buff *skb,
 			unsigned int dataoff,
-			struct tcphdr *tcph, 
+			struct tcphdr *tcph,
 			struct ip_ct_tcp_state *state)
 {
 	unsigned char buff[(15 * 4) - sizeof(struct tcphdr)];
@@ -414,7 +414,7 @@ static void tcp_options(const struct sk_
 				 length, buff);
 	BUG_ON(ptr == NULL);
 
-	state->td_scale = 
+	state->td_scale =
 	state->flags = 0;
 
 	while (length > 0) {
@@ -434,7 +434,7 @@ static void tcp_options(const struct sk_
 			if (opsize > length)
 				break;	/* don't parse partial options */
 
-			if (opcode == TCPOPT_SACK_PERM 
+			if (opcode == TCPOPT_SACK_PERM
 			    && opsize == TCPOLEN_SACK_PERM)
 				state->flags |= IP_CT_TCP_FLAG_SACK_PERM;
 			else if (opcode == TCPOPT_WINDOW
@@ -457,7 +457,7 @@ static void tcp_options(const struct sk_
 static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 		     struct tcphdr *tcph, __u32 *sack)
 {
-        unsigned char buff[(15 * 4) - sizeof(struct tcphdr)];
+	unsigned char buff[(15 * 4) - sizeof(struct tcphdr)];
 	unsigned char *ptr;
 	int length = (tcph->doff*4) - sizeof(struct tcphdr);
 	__u32 tmp;
@@ -472,10 +472,10 @@ static void tcp_sack(const struct sk_buf
 	/* Fast path for timestamp-only option */
 	if (length == TCPOLEN_TSTAMP_ALIGNED*4
 	    && *(__be32 *)ptr ==
-	        __constant_htonl((TCPOPT_NOP << 24)
-	        		 | (TCPOPT_NOP << 16)
-	        		 | (TCPOPT_TIMESTAMP << 8)
-	        		 | TCPOLEN_TIMESTAMP))
+		__constant_htonl((TCPOPT_NOP << 24)
+				 | (TCPOPT_NOP << 16)
+				 | (TCPOPT_TIMESTAMP << 8)
+				 | TCPOLEN_TIMESTAMP))
 		return;
 
 	while (length > 0) {
@@ -495,15 +495,15 @@ static void tcp_sack(const struct sk_buf
 			if (opsize > length)
 				break;	/* don't parse partial options */
 
-			if (opcode == TCPOPT_SACK 
-			    && opsize >= (TCPOLEN_SACK_BASE 
-			    		  + TCPOLEN_SACK_PERBLOCK)
-			    && !((opsize - TCPOLEN_SACK_BASE) 
-			    	 % TCPOLEN_SACK_PERBLOCK)) {
-			    	for (i = 0;
-			    	     i < (opsize - TCPOLEN_SACK_BASE);
-			    	     i += TCPOLEN_SACK_PERBLOCK) {
-				     	tmp = ntohl(*((__be32 *)(ptr+i)+1));
+			if (opcode == TCPOPT_SACK
+			    && opsize >= (TCPOLEN_SACK_BASE
+					  + TCPOLEN_SACK_PERBLOCK)
+			    && !((opsize - TCPOLEN_SACK_BASE)
+				 % TCPOLEN_SACK_PERBLOCK)) {
+				for (i = 0;
+				     i < (opsize - TCPOLEN_SACK_BASE);
+				     i += TCPOLEN_SACK_PERBLOCK) {
+					tmp = ntohl(*((__be32 *)(ptr+i)+1));
 
 					if (after(tmp, *sack))
 						*sack = tmp;
@@ -516,12 +516,12 @@ static void tcp_sack(const struct sk_buf
 	}
 }
 
-static int tcp_in_window(struct ip_ct_tcp *state, 
-                         enum ip_conntrack_dir dir,
-                         unsigned int index,
-                         const struct sk_buff *skb,
+static int tcp_in_window(struct ip_ct_tcp *state,
+			 enum ip_conntrack_dir dir,
+			 unsigned int index,
+			 const struct sk_buff *skb,
 			 unsigned int dataoff,
-                         struct tcphdr *tcph,
+			 struct tcphdr *tcph,
 			 int pf)
 {
 	struct ip_ct_tcp_state *sender = &state->seen[dir];
@@ -543,14 +543,14 @@ static int tcp_in_window(struct ip_ct_tc
 	DEBUGP("tcp_in_window: START\n");
 	DEBUGP("tcp_in_window: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu "
 	       "seq=%u ack=%u sack=%u win=%u end=%u\n",
-		NIPQUAD(iph->saddr), ntohs(tcph->source), 
+		NIPQUAD(iph->saddr), ntohs(tcph->source),
 		NIPQUAD(iph->daddr), ntohs(tcph->dest),
 		seq, ack, sack, win, end);
 	DEBUGP("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
 	       "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
 		sender->td_end, sender->td_maxend, sender->td_maxwin,
-		sender->td_scale, 
-		receiver->td_end, receiver->td_maxend, receiver->td_maxwin, 
+		sender->td_scale,
+		receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
 		receiver->td_scale);
 
 	if (sender->td_end == 0) {
@@ -561,26 +561,26 @@ static int tcp_in_window(struct ip_ct_tc
 			/*
 			 * Outgoing SYN-ACK in reply to a SYN.
 			 */
-			sender->td_end = 
+			sender->td_end =
 			sender->td_maxend = end;
 			sender->td_maxwin = (win == 0 ? 1 : win);
 
 			tcp_options(skb, dataoff, tcph, sender);
-			/* 
+			/*
 			 * RFC 1323:
 			 * Both sides must send the Window Scale option
 			 * to enable window scaling in either direction.
 			 */
 			if (!(sender->flags & IP_CT_TCP_FLAG_WINDOW_SCALE
 			      && receiver->flags & IP_CT_TCP_FLAG_WINDOW_SCALE))
-				sender->td_scale = 
+				sender->td_scale =
 				receiver->td_scale = 0;
 		} else {
 			/*
 			 * We are in the middle of a connection,
 			 * its history is lost for us.
 			 * Let's try to use the data from the packet.
-		 	 */
+			 */
 			sender->td_end = end;
 			sender->td_maxwin = (win == 0 ? 1 : win);
 			sender->td_maxend = end + sender->td_maxwin;
@@ -592,7 +592,7 @@ static int tcp_in_window(struct ip_ct_tc
 		   && after(end, sender->td_end)) {
 		/*
 		 * RFC 793: "if a TCP is reinitialized ... then it need
-		 * not wait at all; it must only be sure to use sequence 
+		 * not wait at all; it must only be sure to use sequence
 		 * numbers larger than those recently used."
 		 */
 		sender->td_end =
@@ -607,8 +607,8 @@ static int tcp_in_window(struct ip_ct_tc
 		 * If there is no ACK, just pretend it was set and OK.
 		 */
 		ack = sack = receiver->td_end;
-	} else if (((tcp_flag_word(tcph) & (TCP_FLAG_ACK|TCP_FLAG_RST)) == 
-		    (TCP_FLAG_ACK|TCP_FLAG_RST)) 
+	} else if (((tcp_flag_word(tcph) & (TCP_FLAG_ACK|TCP_FLAG_RST)) ==
+		    (TCP_FLAG_ACK|TCP_FLAG_RST))
 		   && (ack == 0)) {
 		/*
 		 * Broken TCP stacks, that set ACK in RST packets as well
@@ -637,21 +637,21 @@ static int tcp_in_window(struct ip_ct_tc
 	DEBUGP("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
 	       "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
 		sender->td_end, sender->td_maxend, sender->td_maxwin,
-		sender->td_scale, 
+		sender->td_scale,
 		receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
 		receiver->td_scale);
 
 	DEBUGP("tcp_in_window: I=%i II=%i III=%i IV=%i\n",
 		before(seq, sender->td_maxend + 1),
 		after(end, sender->td_end - receiver->td_maxwin - 1),
-	    	before(sack, receiver->td_end + 1),
-	    	after(ack, receiver->td_end - MAXACKWINDOW(sender)));
+		before(sack, receiver->td_end + 1),
+		after(ack, receiver->td_end - MAXACKWINDOW(sender)));
 
 	if (before(seq, sender->td_maxend + 1) &&
 	    after(end, sender->td_end - receiver->td_maxwin - 1) &&
 	    before(sack, receiver->td_end + 1) &&
 	    after(ack, receiver->td_end - MAXACKWINDOW(sender))) {
-	    	/*
+		/*
 		 * Take into account window scaling (RFC 1323).
 		 */
 		if (!tcph->syn)
@@ -676,7 +676,7 @@ static int tcp_in_window(struct ip_ct_tc
 				receiver->td_maxend++;
 		}
 
-		/* 
+		/*
 		 * Check retransmissions.
 		 */
 		if (index == TCP_ACK_SET) {
@@ -712,11 +712,11 @@ static int tcp_in_window(struct ip_ct_tc
 			: "ACK is over the upper bound (ACKed data not seen yet)"
 			: "SEQ is under the lower bound (already ACKed data retransmitted)"
 			: "SEQ is over the upper bound (over the window of the receiver)");
-  	}
-  
+	}
+
 	DEBUGP("tcp_in_window: res=%i sender end=%u maxend=%u maxwin=%u "
 	       "receiver end=%u maxend=%u maxwin=%u\n",
-		res, sender->td_end, sender->td_maxend, sender->td_maxwin, 
+		res, sender->td_end, sender->td_maxend, sender->td_maxwin,
 		receiver->td_end, receiver->td_maxend, receiver->td_maxwin);
 
 	return res;
@@ -727,7 +727,7 @@ #ifdef CONFIG_NF_NAT_NEEDED
 /* Caller must linearize skb at tcp header. */
 void nf_conntrack_tcp_update(struct sk_buff *skb,
 			     unsigned int dataoff,
-			     struct nf_conn *conntrack, 
+			     struct nf_conn *conntrack,
 			     int dir)
 {
 	struct tcphdr *tcph = (void *)skb->data + dataoff;
@@ -750,7 +750,7 @@ #endif
 	DEBUGP("tcp_update: sender end=%u maxend=%u maxwin=%u scale=%i "
 	       "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
 		sender->td_end, sender->td_maxend, sender->td_maxwin,
-		sender->td_scale, 
+		sender->td_scale,
 		receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
 		receiver->td_scale);
 }
@@ -804,8 +804,8 @@ static int tcp_error(struct sk_buff *skb
 			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
 				"nf_ct_tcp: short packet ");
 		return -NF_ACCEPT;
-  	}
-  
+	}
+
 	/* Not whole TCP header or malformed packet */
 	if (th->doff*4 < sizeof(struct tcphdr) || tcplen < th->doff*4) {
 		if (LOG_INVALID(IPPROTO_TCP))
@@ -813,7 +813,7 @@ static int tcp_error(struct sk_buff *skb
 				"nf_ct_tcp: truncated/malformed packet ");
 		return -NF_ACCEPT;
 	}
-  
+
 	/* Checksum invalid? Ignore.
 	 * We skip checking packets on the outgoing path
 	 * because the checksum is assumed to be correct.
@@ -870,28 +870,28 @@ static int tcp_packet(struct nf_conn *co
 		 *
 		 * a) SYN in ORIGINAL
 		 * b) SYN/ACK in REPLY
-		 * c) ACK in reply direction after initial SYN in original. 
+		 * c) ACK in reply direction after initial SYN in original.
 		 */
 		if (index == TCP_SYNACK_SET
 		    && conntrack->proto.tcp.last_index == TCP_SYN_SET
 		    && conntrack->proto.tcp.last_dir != dir
 		    && ntohl(th->ack_seq) ==
-		    	     conntrack->proto.tcp.last_end) {
-			/* This SYN/ACK acknowledges a SYN that we earlier 
+			     conntrack->proto.tcp.last_end) {
+			/* This SYN/ACK acknowledges a SYN that we earlier
 			 * ignored as invalid. This means that the client and
 			 * the server are both in sync, while the firewall is
 			 * not. We kill this session and block the SYN/ACK so
-			 * that the client cannot but retransmit its SYN and 
+			 * that the client cannot but retransmit its SYN and
 			 * thus initiate a clean new session.
 			 */
-		    	write_unlock_bh(&tcp_lock);
+			write_unlock_bh(&tcp_lock);
 			if (LOG_INVALID(IPPROTO_TCP))
 				nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
 					  "nf_ct_tcp: killing out of sync session ");
-		    	if (del_timer(&conntrack->timeout))
-		    		conntrack->timeout.function((unsigned long)
-		    					    conntrack);
-		    	return -NF_DROP;
+			if (del_timer(&conntrack->timeout))
+				conntrack->timeout.function((unsigned long)
+							    conntrack);
+			return -NF_DROP;
 		}
 		conntrack->proto.tcp.last_index = index;
 		conntrack->proto.tcp.last_dir = dir;
@@ -921,13 +921,13 @@ static int tcp_packet(struct nf_conn *co
 			IP_CT_TCP_FLAG_CLOSE_INIT)
 		    || after(ntohl(th->seq),
 			     conntrack->proto.tcp.seen[dir].td_end)) {
-		    	/* Attempt to reopen a closed connection.
-		    	* Delete this connection and look up again. */
-		    	write_unlock_bh(&tcp_lock);
-		    	if (del_timer(&conntrack->timeout))
-		    		conntrack->timeout.function((unsigned long)
-		    					    conntrack);
-		    	return -NF_REPEAT;
+			/* Attempt to reopen a closed connection.
+			* Delete this connection and look up again. */
+			write_unlock_bh(&tcp_lock);
+			if (del_timer(&conntrack->timeout))
+				conntrack->timeout.function((unsigned long)
+							    conntrack);
+			return -NF_REPEAT;
 		} else {
 			write_unlock_bh(&tcp_lock);
 			if (LOG_INVALID(IPPROTO_TCP))
@@ -938,9 +938,9 @@ static int tcp_packet(struct nf_conn *co
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
 		    && ((test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
-		         && conntrack->proto.tcp.last_index == TCP_SYN_SET)
-		        || (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
-		            && conntrack->proto.tcp.last_index == TCP_ACK_SET))
+			 && conntrack->proto.tcp.last_index == TCP_SYN_SET)
+			|| (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
+			    && conntrack->proto.tcp.last_index == TCP_ACK_SET))
 		    && ntohl(th->ack_seq) == conntrack->proto.tcp.last_end) {
 			/* RST sent to invalid SYN or ACK we had let through
 			 * at a) and c) above:
@@ -1005,8 +1005,8 @@ static int tcp_packet(struct nf_conn *co
 		   && (old_state == TCP_CONNTRACK_SYN_RECV
 		       || old_state == TCP_CONNTRACK_ESTABLISHED)
 		   && new_state == TCP_CONNTRACK_ESTABLISHED) {
-		/* Set ASSURED if we see see valid ack in ESTABLISHED 
-		   after SYN_RECV or a valid answer for a picked up 
+		/* Set ASSURED if we see see valid ack in ESTABLISHED
+		   after SYN_RECV or a valid answer for a picked up
 		   connection. */
 		set_bit(IPS_ASSURED_BIT, &conntrack->status);
 		nf_conntrack_event_cache(IPCT_STATUS, skb);
@@ -1015,7 +1015,7 @@ static int tcp_packet(struct nf_conn *co
 
 	return NF_ACCEPT;
 }
- 
+
 /* Called when a new connection for this protocol found. */
 static int tcp_new(struct nf_conn *conntrack,
 		   const struct sk_buff *skb,
@@ -1071,7 +1071,7 @@ #endif
 		if (conntrack->proto.tcp.seen[0].td_maxwin == 0)
 			conntrack->proto.tcp.seen[0].td_maxwin = 1;
 		conntrack->proto.tcp.seen[0].td_maxend =
-			conntrack->proto.tcp.seen[0].td_end + 
+			conntrack->proto.tcp.seen[0].td_end +
 			conntrack->proto.tcp.seen[0].td_maxwin;
 		conntrack->proto.tcp.seen[0].td_scale = 0;
 
@@ -1081,20 +1081,20 @@ #endif
 		conntrack->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM |
 						     IP_CT_TCP_FLAG_BE_LIBERAL;
 	}
-    
+
 	conntrack->proto.tcp.seen[1].td_end = 0;
 	conntrack->proto.tcp.seen[1].td_maxend = 0;
 	conntrack->proto.tcp.seen[1].td_maxwin = 1;
-	conntrack->proto.tcp.seen[1].td_scale = 0;      
+	conntrack->proto.tcp.seen[1].td_scale = 0;
 
 	/* tcp_packet will set them */
 	conntrack->proto.tcp.state = TCP_CONNTRACK_NONE;
 	conntrack->proto.tcp.last_index = TCP_NONE_SET;
-	 
+
 	DEBUGP("tcp_new: sender end=%u maxend=%u maxwin=%u scale=%i "
 	       "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
 		sender->td_end, sender->td_maxend, sender->td_maxwin,
-		sender->td_scale, 
+		sender->td_scale,
 		receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
 		receiver->td_scale);
 	return 1;
@@ -1110,7 +1110,7 @@ static int tcp_to_nfattr(struct sk_buff 
 			 const struct nf_conn *ct)
 {
 	struct nfattr *nest_parms;
-	
+
 	read_lock_bh(&tcp_lock);
 	nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
 	NFA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
@@ -1140,7 +1140,7 @@ static int nfattr_to_tcp(struct nfattr *
 	if (!attr)
 		return 0;
 
-        nfattr_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, attr);
+	nfattr_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, attr);
 
 	if (nfattr_bad_size(tb, CTA_PROTOINFO_TCP_MAX, cta_min_tcp))
 		return -EINVAL;
@@ -1149,7 +1149,7 @@ static int nfattr_to_tcp(struct nfattr *
 		return -EINVAL;
 
 	write_lock_bh(&tcp_lock);
-	ct->proto.tcp.state = 
+	ct->proto.tcp.state =
 		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
 	write_unlock_bh(&tcp_lock);
 
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 9dec115..7aaa8c9 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -341,7 +341,7 @@ int ct_sip_get_info(struct nf_conn *ct,
 			continue;
 		}
 		aux = ct_sip_search(hnfo->ln_str, dptr, hnfo->ln_strlen,
-		                    ct_sip_lnlen(dptr, limit),
+				    ct_sip_lnlen(dptr, limit),
 				    hnfo->case_sensitive);
 		if (!aux) {
 			DEBUGP("'%s' not found in '%s'.\n", hnfo->ln_str,
@@ -451,12 +451,12 @@ static int sip_help(struct sk_buff **psk
 
 		/* We'll drop only if there are parse problems. */
 		if (!parse_addr(ct, dptr + matchoff, NULL, &addr,
-			        dptr + datalen)) {
+				dptr + datalen)) {
 			ret = NF_DROP;
 			goto out;
 		}
 		if (ct_sip_get_info(ct, dptr, datalen, &matchoff, &matchlen,
-		                    POS_MEDIA) > 0) {
+				    POS_MEDIA) > 0) {
 
 			port = simple_strtoul(dptr + matchoff, NULL, 10);
 			if (port < 1024) {
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index f1cb60f..7661246 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -472,7 +472,7 @@ #endif /* CNFIG_PROC_FS */
 static void __exit nf_conntrack_standalone_fini(void)
 {
 #ifdef CONFIG_SYSCTL
- 	unregister_sysctl_table(nf_ct_sysctl_header);
+	unregister_sysctl_table(nf_ct_sysctl_header);
 #endif
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("nf_conntrack", proc_net_stat);
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index f5bffe2..37c4542 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -31,7 +31,7 @@ MODULE_PARM_DESC(ports, "Port numbers of
 
 #if 0
 #define DEBUGP(format, args...) printk("%s:%s:" format, \
-                                       __FILE__, __FUNCTION__ , ## args)
+				       __FILE__, __FUNCTION__ , ## args)
 #else
 #define DEBUGP(format, args...)
 #endif
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index a981971..0df7fff 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -24,7 +24,7 @@ extern unsigned int nf_iterate(struct li
 
 /* nf_queue.c */
 extern int nf_queue(struct sk_buff *skb,
-		    struct list_head *elem, 
+		    struct list_head *elem,
 		    int pf, unsigned int hook,
 		    struct net_device *indev,
 		    struct net_device *outdev,
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 0db2fd8..90a1d74 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -41,7 +41,7 @@ int nf_log_register(int pf, struct nf_lo
 
 	mutex_unlock(&nf_log_mutex);
 	return ret;
-}		
+}
 EXPORT_SYMBOL(nf_log_register);
 
 void nf_log_unregister_pf(int pf)
@@ -83,7 +83,7 @@ void nf_log_packet(int pf,
 	va_list args;
 	char prefix[NF_LOG_PREFIXLEN];
 	struct nf_logger *logger;
-	
+
 	rcu_read_lock();
 	logger = rcu_dereference(nf_loggers[pf]);
 	if (logger) {
@@ -136,7 +136,7 @@ static int seq_show(struct seq_file *s, 
 
 	if (!logger)
 		return seq_printf(s, "%2lld NONE\n", *pos);
-	
+
 	return seq_printf(s, "%2lld %s\n", *pos, logger->name);
 }
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 4d8936e..fb467b4 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -10,7 +10,7 @@ #include <net/protocol.h>
 
 #include "nf_internals.h"
 
-/* 
+/*
  * A queue handler may be registered for each protocol.  Each is protected by
  * long term mutex.  The handler must provide an an outfn() to accept packets
  * for queueing and must reinject all packets it receives, no matter what.
@@ -22,7 +22,7 @@ static DEFINE_RWLOCK(queue_handler_lock)
 /* return EBUSY when somebody else is registered, return EEXIST if the
  * same handler is registered, return 0 in case of success. */
 int nf_register_queue_handler(int pf, struct nf_queue_handler *qh)
-{      
+{
 	int ret;
 
 	if (pf >= NPROTO)
@@ -52,7 +52,7 @@ int nf_unregister_queue_handler(int pf)
 	write_lock_bh(&queue_handler_lock);
 	queue_handler[pf] = NULL;
 	write_unlock_bh(&queue_handler_lock);
-	
+
 	return 0;
 }
 EXPORT_SYMBOL(nf_unregister_queue_handler);
@@ -70,8 +70,8 @@ void nf_unregister_queue_handlers(struct
 }
 EXPORT_SYMBOL_GPL(nf_unregister_queue_handlers);
 
-/* 
- * Any packet that leaves via this function must come back 
+/*
+ * Any packet that leaves via this function must come back
  * through nf_reinject().
  */
 static int __nf_queue(struct sk_buff *skb,
@@ -115,7 +115,7 @@ #endif
 		return 1;
 	}
 
-	*info = (struct nf_info) { 
+	*info = (struct nf_info) {
 		(struct nf_hook_ops *)elem, pf, hook, indev, outdev, okfn };
 
 	/* If it's going away, ignore hook. */
@@ -226,10 +226,10 @@ #endif
 	module_put(info->elem->owner);
 
 	list_for_each_rcu(i, &nf_hooks[info->pf][info->hook]) {
-		if (i == elem) 
-  			break;
-  	}
-  
+		if (i == elem)
+			break;
+	}
+
 	if (i == &nf_hooks[info->pf][info->hook]) {
 		/* The module which sent it to userspace is gone. */
 		NFDEBUG("%s: module disappeared, dropping packet.\n",
@@ -252,7 +252,7 @@ #endif
 	if (verdict == NF_ACCEPT) {
 	next_hook:
 		verdict = nf_iterate(&nf_hooks[info->pf][info->hook],
-				     &skb, info->hook, 
+				     &skb, info->hook,
 				     info->indev, info->outdev, &elem,
 				     info->okfn, INT_MIN);
 	}
diff --git a/net/netfilter/nf_sockopt.c b/net/netfilter/nf_sockopt.c
index c2e44e9..8b8ece7 100644
--- a/net/netfilter/nf_sockopt.c
+++ b/net/netfilter/nf_sockopt.c
@@ -32,13 +32,13 @@ int nf_register_sockopt(struct nf_sockop
 	list_for_each(i, &nf_sockopts) {
 		struct nf_sockopt_ops *ops = (struct nf_sockopt_ops *)i;
 		if (ops->pf == reg->pf
-		    && (overlap(ops->set_optmin, ops->set_optmax, 
+		    && (overlap(ops->set_optmin, ops->set_optmax,
 				reg->set_optmin, reg->set_optmax)
-			|| overlap(ops->get_optmin, ops->get_optmax, 
+			|| overlap(ops->get_optmin, ops->get_optmax,
 				   reg->get_optmin, reg->get_optmax))) {
 			NFDEBUG("nf_sock overlap: %u-%u/%u-%u v %u-%u/%u-%u\n",
-				ops->set_optmin, ops->set_optmax, 
-				ops->get_optmin, ops->get_optmax, 
+				ops->set_optmin, ops->set_optmax,
+				ops->get_optmin, ops->get_optmax,
 				reg->set_optmin, reg->set_optmax,
 				reg->get_optmin, reg->get_optmax);
 			ret = -EBUSY;
@@ -73,7 +73,7 @@ void nf_unregister_sockopt(struct nf_soc
 EXPORT_SYMBOL(nf_unregister_sockopt);
 
 /* Call get/setsockopt() */
-static int nf_sockopt(struct sock *sk, int pf, int val, 
+static int nf_sockopt(struct sock *sk, int pf, int val,
 		      char __user *opt, int *len, int get)
 {
 	struct list_head *i;
@@ -107,7 +107,7 @@ static int nf_sockopt(struct sock *sk, i
 	}
 	mutex_unlock(&nf_sockopt_mutex);
 	return -ENOPROTOOPT;
-	
+
  out:
 	mutex_lock(&nf_sockopt_mutex);
 	ops->use--;
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 52fdfa2..f42bb13 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -105,7 +105,7 @@ static inline struct nfnl_callback *
 nfnetlink_find_client(u_int16_t type, struct nfnetlink_subsystem *ss)
 {
 	u_int8_t cb_id = NFNL_MSG_TYPE(type);
-	
+
 	if (cb_id >= ss->cb_count) {
 		DEBUGP("msgtype %u >= %u, returning\n", type, ss->cb_count);
 		return NULL;
@@ -187,7 +187,7 @@ nfnetlink_check_attributes(struct nfnetl
 	/* implicit: if nlmsg_len == min_len, we return 0, and an empty
 	 * (zeroed) cda[] array. The message is valid, but empty. */
 
-        return 0;
+	return 0;
 }
 
 int nfnetlink_has_listeners(unsigned int group)
@@ -268,12 +268,12 @@ #endif
 	}
 
 	{
-		u_int16_t attr_count = 
+		u_int16_t attr_count =
 			ss->cb[NFNL_MSG_TYPE(nlh->nlmsg_type)].attr_count;
 		struct nfattr *cda[attr_count];
 
 		memset(cda, 0, sizeof(struct nfattr *) * attr_count);
-		
+
 		err = nfnetlink_check_attributes(ss, nlh, cda);
 		if (err < 0)
 			goto err_inval;
@@ -357,7 +357,7 @@ static int __init nfnetlink_init(void)
 	printk("Netfilter messages via NETLINK v%s.\n", nfversion);
 
 	nfnl = netlink_kernel_create(NETLINK_NETFILTER, NFNLGRP_MAX,
-	                             nfnetlink_rcv, THIS_MODULE);
+				     nfnetlink_rcv, THIS_MODULE);
 	if (!nfnl) {
 		printk(KERN_ERR "cannot initialize nfnetlink!\n");
 		return -1;
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 6511bb0..f2298a6 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -75,7 +75,7 @@ struct nfulnl_instance {
 	u_int32_t seq;			/* instance-local sequential counter */
 	u_int16_t group_num;		/* number of this queue */
 	u_int16_t flags;
-	u_int8_t copy_mode;	
+	u_int8_t copy_mode;
 };
 
 static DEFINE_RWLOCK(instances_lock);
@@ -146,7 +146,7 @@ instance_create(u_int16_t group_num, int
 	UDEBUG("entering (group_num=%u, pid=%d)\n", group_num,
 		pid);
 
-	write_lock_bh(&instances_lock);	
+	write_lock_bh(&instances_lock);
 	if (__instance_lookup(group_num)) {
 		inst = NULL;
 		UDEBUG("aborting, instance already exists\n");
@@ -179,10 +179,10 @@ instance_create(u_int16_t group_num, int
 	if (!try_module_get(THIS_MODULE))
 		goto out_free;
 
-	hlist_add_head(&inst->hlist, 
+	hlist_add_head(&inst->hlist,
 		       &instance_table[instance_hashfn(group_num)]);
 
-	UDEBUG("newly added node: %p, next=%p\n", &inst->hlist, 
+	UDEBUG("newly added node: %p, next=%p\n", &inst->hlist,
 		inst->hlist.next);
 
 	write_unlock_bh(&instances_lock);
@@ -251,14 +251,14 @@ nfulnl_set_mode(struct nfulnl_instance *
 	int status = 0;
 
 	spin_lock_bh(&inst->lock);
-	
+
 	switch (mode) {
 	case NFULNL_COPY_NONE:
 	case NFULNL_COPY_META:
 		inst->copy_mode = mode;
 		inst->copy_range = 0;
 		break;
-		
+
 	case NFULNL_COPY_PACKET:
 		inst->copy_mode = mode;
 		/* we're using struct nfattr which has 16bit nfa_len */
@@ -267,7 +267,7 @@ nfulnl_set_mode(struct nfulnl_instance *
 		else
 			inst->copy_range = range;
 		break;
-		
+
 	default:
 		status = -EINVAL;
 		break;
@@ -327,7 +327,7 @@ nfulnl_set_flags(struct nfulnl_instance 
 	return 0;
 }
 
-static struct sk_buff *nfulnl_alloc_skb(unsigned int inst_size, 
+static struct sk_buff *nfulnl_alloc_skb(unsigned int inst_size,
 					unsigned int pkt_size)
 {
 	struct sk_buff *skb;
@@ -387,7 +387,7 @@ __nfulnl_send(struct nfulnl_instance *in
 
 static void nfulnl_timer(unsigned long data)
 {
-	struct nfulnl_instance *inst = (struct nfulnl_instance *)data; 
+	struct nfulnl_instance *inst = (struct nfulnl_instance *)data;
 
 	UDEBUG("timer function called, flushing buffer\n");
 
@@ -399,9 +399,9 @@ static void nfulnl_timer(unsigned long d
 
 /* This is an inline function, we don't really care about a long
  * list of arguments */
-static inline int 
+static inline int
 __build_packet_message(struct nfulnl_instance *inst,
-			const struct sk_buff *skb, 
+			const struct sk_buff *skb,
 			unsigned int data_len,
 			unsigned int pf,
 			unsigned int hooknum,
@@ -417,9 +417,9 @@ __build_packet_message(struct nfulnl_ins
 	__be32 tmp_uint;
 
 	UDEBUG("entered\n");
-		
+
 	old_tail = inst->skb->tail;
-	nlh = NLMSG_PUT(inst->skb, 0, 0, 
+	nlh = NLMSG_PUT(inst->skb, 0, 0,
 			NFNL_SUBSYS_ULOG << 8 | NFULNL_MSG_PACKET,
 			sizeof(struct nfgenmsg));
 	nfmsg = NLMSG_DATA(nlh);
@@ -457,7 +457,7 @@ #else
 			NFA_PUT(inst->skb, NFULA_IFINDEX_INDEV,
 				sizeof(tmp_uint), &tmp_uint);
 			if (skb->nf_bridge && skb->nf_bridge->physindev) {
-				tmp_uint = 
+				tmp_uint =
 				    htonl(skb->nf_bridge->physindev->ifindex);
 				NFA_PUT(inst->skb, NFULA_IFINDEX_PHYSINDEV,
 					sizeof(tmp_uint), &tmp_uint);
@@ -488,7 +488,7 @@ #else
 			NFA_PUT(inst->skb, NFULA_IFINDEX_OUTDEV,
 				sizeof(tmp_uint), &tmp_uint);
 			if (skb->nf_bridge) {
-				tmp_uint = 
+				tmp_uint =
 				    htonl(skb->nf_bridge->physoutdev->ifindex);
 				NFA_PUT(inst->skb, NFULA_IFINDEX_PHYSOUTDEV,
 					sizeof(tmp_uint), &tmp_uint);
@@ -558,7 +558,7 @@ #endif
 		if (skb_copy_bits(skb, 0, NFA_DATA(nfa), data_len))
 			BUG();
 	}
-		
+
 	nlh->nlmsg_len = inst->skb->tail - old_tail;
 	return 0;
 
@@ -599,7 +599,7 @@ nfulnl_log_packet(unsigned int pf,
 	unsigned int nlbufsiz;
 	unsigned int plen;
 
-	if (li_user && li_user->type == NF_LOG_TYPE_ULOG) 
+	if (li_user && li_user->type == NF_LOG_TYPE_ULOG)
 		li = li_user;
 	else
 		li = &default_loginfo;
@@ -648,24 +648,24 @@ #endif
 	/* per-rule qthreshold overrides per-instance */
 	if (qthreshold > li->u.ulog.qthreshold)
 		qthreshold = li->u.ulog.qthreshold;
-	
+
 	switch (inst->copy_mode) {
 	case NFULNL_COPY_META:
 	case NFULNL_COPY_NONE:
 		data_len = 0;
 		break;
-	
+
 	case NFULNL_COPY_PACKET:
-		if (inst->copy_range == 0 
+		if (inst->copy_range == 0
 		    || inst->copy_range > skb->len)
 			data_len = skb->len;
 		else
 			data_len = inst->copy_range;
-		
+
 		size += NFA_SPACE(data_len);
 		UDEBUG("copy_packet, therefore size now %u\n", size);
 		break;
-	
+
 	default:
 		spin_unlock_bh(&inst->lock);
 		instance_put(inst);
@@ -991,9 +991,9 @@ static int seq_show(struct seq_file *s, 
 {
 	const struct nfulnl_instance *inst = v;
 
-	return seq_printf(s, "%5d %6d %5d %1d %5d %6d %2d\n", 
+	return seq_printf(s, "%5d %6d %5d %1d %5d %6d %2d\n",
 			  inst->group_num,
-			  inst->peer_pid, inst->qlen, 
+			  inst->peer_pid, inst->qlen,
 			  inst->copy_mode, inst->copy_range,
 			  inst->flushtimeout, atomic_read(&inst->use));
 }
@@ -1041,10 +1041,10 @@ static int __init nfnetlink_log_init(voi
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *proc_nful;
 #endif
-	
+
 	for (i = 0; i < INSTANCE_BUCKETS; i++)
 		INIT_HLIST_HEAD(&instance_table[i]);
-	
+
 	/* it's not really all that important to have a random value, so
 	 * we can do this from the init function, even if there hasn't
 	 * been that much entropy yet */
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a88a017..2ea362c 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -129,7 +129,7 @@ instance_create(u_int16_t queue_num, int
 
 	QDEBUG("entering for queue_num=%u, pid=%d\n", queue_num, pid);
 
-	write_lock_bh(&instances_lock);	
+	write_lock_bh(&instances_lock);
 	if (__instance_lookup(queue_num)) {
 		inst = NULL;
 		QDEBUG("aborting, instance already exists\n");
@@ -154,7 +154,7 @@ instance_create(u_int16_t queue_num, int
 	if (!try_module_get(THIS_MODULE))
 		goto out_free;
 
-	hlist_add_head(&inst->hlist, 
+	hlist_add_head(&inst->hlist,
 		       &instance_table[instance_hashfn(queue_num)]);
 
 	write_unlock_bh(&instances_lock);
@@ -239,14 +239,14 @@ __enqueue_entry(struct nfqnl_instance *q
  * entry if cmpfn is NULL.
  */
 static inline struct nfqnl_queue_entry *
-__find_entry(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, 
+__find_entry(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn,
 		   unsigned long data)
 {
 	struct list_head *p;
 
 	list_for_each_prev(p, &queue->queue_list) {
 		struct nfqnl_queue_entry *entry = (struct nfqnl_queue_entry *)p;
-		
+
 		if (!cmpfn || cmpfn(entry, data))
 			return entry;
 	}
@@ -279,7 +279,7 @@ static inline void
 __nfqnl_flush(struct nfqnl_instance *queue, int verdict)
 {
 	struct nfqnl_queue_entry *entry;
-	
+
 	while ((entry = __find_dequeue_entry(queue, NULL, 0)))
 		issue_verdict(entry, verdict);
 }
@@ -289,14 +289,14 @@ __nfqnl_set_mode(struct nfqnl_instance *
 		 unsigned char mode, unsigned int range)
 {
 	int status = 0;
-	
+
 	switch (mode) {
 	case NFQNL_COPY_NONE:
 	case NFQNL_COPY_META:
 		queue->copy_mode = mode;
 		queue->copy_range = 0;
 		break;
-		
+
 	case NFQNL_COPY_PACKET:
 		queue->copy_mode = mode;
 		/* we're using struct nfattr which has 16bit nfa_len */
@@ -305,7 +305,7 @@ __nfqnl_set_mode(struct nfqnl_instance *
 		else
 			queue->copy_range = range;
 		break;
-		
+
 	default:
 		status = -EINVAL;
 
@@ -318,7 +318,7 @@ find_dequeue_entry(struct nfqnl_instance
 			 nfqnl_cmpfn cmpfn, unsigned long data)
 {
 	struct nfqnl_queue_entry *entry;
-	
+
 	spin_lock_bh(&queue->lock);
 	entry = __find_dequeue_entry(queue, cmpfn, data);
 	spin_unlock_bh(&queue->lock);
@@ -369,13 +369,13 @@ #endif
 	outdev = entinf->outdev;
 
 	spin_lock_bh(&queue->lock);
-	
+
 	switch (queue->copy_mode) {
 	case NFQNL_COPY_META:
 	case NFQNL_COPY_NONE:
 		data_len = 0;
 		break;
-	
+
 	case NFQNL_COPY_PACKET:
 		if ((entskb->ip_summed == CHECKSUM_PARTIAL ||
 		     entskb->ip_summed == CHECKSUM_COMPLETE) &&
@@ -383,15 +383,15 @@ #endif
 			spin_unlock_bh(&queue->lock);
 			return NULL;
 		}
-		if (queue->copy_range == 0 
+		if (queue->copy_range == 0
 		    || queue->copy_range > entskb->len)
 			data_len = entskb->len;
 		else
 			data_len = queue->copy_range;
-		
+
 		size += NFA_SPACE(data_len);
 		break;
-	
+
 	default:
 		*errp = -EINVAL;
 		spin_unlock_bh(&queue->lock);
@@ -403,9 +403,9 @@ #endif
 	skb = alloc_skb(size, GFP_ATOMIC);
 	if (!skb)
 		goto nlmsg_failure;
-		
+
 	old_tail= skb->tail;
-	nlh = NLMSG_PUT(skb, 0, 0, 
+	nlh = NLMSG_PUT(skb, 0, 0,
 			NFNL_SUBSYS_QUEUE << 8 | NFQNL_MSG_PACKET,
 			sizeof(struct nfgenmsg));
 	nfmsg = NLMSG_DATA(nlh);
@@ -427,9 +427,9 @@ #ifndef CONFIG_BRIDGE_NETFILTER
 #else
 		if (entinf->pf == PF_BRIDGE) {
 			/* Case 1: indev is physical input device, we need to
-			 * look for bridge group (when called from 
+			 * look for bridge group (when called from
 			 * netfilter_bridge) */
-			NFA_PUT(skb, NFQA_IFINDEX_PHYSINDEV, sizeof(tmp_uint), 
+			NFA_PUT(skb, NFQA_IFINDEX_PHYSINDEV, sizeof(tmp_uint),
 				&tmp_uint);
 			/* this is the bridge group "brX" */
 			tmp_uint = htonl(indev->br_port->br->dev->ifindex);
@@ -457,7 +457,7 @@ #ifndef CONFIG_BRIDGE_NETFILTER
 #else
 		if (entinf->pf == PF_BRIDGE) {
 			/* Case 1: outdev is physical output device, we need to
-			 * look for bridge group (when called from 
+			 * look for bridge group (when called from
 			 * netfilter_bridge) */
 			NFA_PUT(skb, NFQA_IFINDEX_PHYSOUTDEV, sizeof(tmp_uint),
 				&tmp_uint);
@@ -490,7 +490,7 @@ #endif
 		struct nfqnl_msg_packet_hw phw;
 
 		int len = entskb->dev->hard_header_parse(entskb,
-			                                   phw.hw_addr);
+							   phw.hw_addr);
 		phw.hw_addrlen = htons(len);
 		NFA_PUT(skb, NFQA_HWADDR, sizeof(phw), &phw);
 	}
@@ -520,7 +520,7 @@ #endif
 		if (skb_copy_bits(entskb, 0, NFA_DATA(nfa), data_len))
 			BUG();
 	}
-		
+
 	nlh->nlmsg_len = skb->tail - old_tail;
 	return skb;
 
@@ -535,7 +535,7 @@ nfattr_failure:
 }
 
 static int
-nfqnl_enqueue_packet(struct sk_buff *skb, struct nf_info *info, 
+nfqnl_enqueue_packet(struct sk_buff *skb, struct nf_info *info,
 		     unsigned int queuenum, void *data)
 {
 	int status = -EINVAL;
@@ -560,7 +560,7 @@ nfqnl_enqueue_packet(struct sk_buff *skb
 	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
 	if (entry == NULL) {
 		if (net_ratelimit())
-			printk(KERN_ERR 
+			printk(KERN_ERR
 				"nf_queue: OOM in nfqnl_enqueue_packet()\n");
 		status = -ENOMEM;
 		goto err_out_put;
@@ -573,18 +573,18 @@ nfqnl_enqueue_packet(struct sk_buff *skb
 	nskb = nfqnl_build_packet_message(queue, entry, &status);
 	if (nskb == NULL)
 		goto err_out_free;
-		
+
 	spin_lock_bh(&queue->lock);
-	
+
 	if (!queue->peer_pid)
-		goto err_out_free_nskb; 
+		goto err_out_free_nskb;
 
 	if (queue->queue_total >= queue->queue_maxlen) {
-                queue->queue_dropped++;
+		queue->queue_dropped++;
 		status = -ENOSPC;
 		if (net_ratelimit())
-		          printk(KERN_WARNING "nf_queue: full at %d entries, "
-				 "dropping packets(s). Dropped: %d\n", 
+			  printk(KERN_WARNING "nf_queue: full at %d entries, "
+				 "dropping packets(s). Dropped: %d\n",
 				 queue->queue_total, queue->queue_dropped);
 		goto err_out_free_nskb;
 	}
@@ -592,7 +592,7 @@ nfqnl_enqueue_packet(struct sk_buff *skb
 	/* nfnetlink_unicast will either free the nskb or add it to a socket */
 	status = nfnetlink_unicast(nskb, queue->peer_pid, MSG_DONTWAIT);
 	if (status < 0) {
-	        queue->queue_user_dropped++;
+		queue->queue_user_dropped++;
 		goto err_out_unlock;
 	}
 
@@ -603,8 +603,8 @@ nfqnl_enqueue_packet(struct sk_buff *skb
 	return status;
 
 err_out_free_nskb:
-	kfree_skb(nskb); 
-	
+	kfree_skb(nskb);
+
 err_out_unlock:
 	spin_unlock_bh(&queue->lock);
 
@@ -629,11 +629,11 @@ nfqnl_mangle(void *data, int data_len, s
 			return -EINVAL;
 		if (diff > skb_tailroom(e->skb)) {
 			struct sk_buff *newskb;
-			
+
 			newskb = skb_copy_expand(e->skb,
-			                         skb_headroom(e->skb),
-			                         diff,
-			                         GFP_ATOMIC);
+						 skb_headroom(e->skb),
+						 diff,
+						 GFP_ATOMIC);
 			if (newskb == NULL) {
 				printk(KERN_WARNING "nf_queue: OOM "
 				      "in mangle, dropping packet\n");
@@ -676,7 +676,7 @@ static int
 dev_cmp(struct nfqnl_queue_entry *entry, unsigned long ifindex)
 {
 	struct nf_info *entinf = entry->info;
-	
+
 	if (entinf->indev)
 		if (entinf->indev->ifindex == ifindex)
 			return 1;
@@ -702,7 +702,7 @@ static void
 nfqnl_dev_drop(int ifindex)
 {
 	int i;
-	
+
 	QDEBUG("entering for ifindex %u\n", ifindex);
 
 	/* this only looks like we have to hold the readlock for a way too long
@@ -717,7 +717,7 @@ nfqnl_dev_drop(int ifindex)
 
 		hlist_for_each_entry(inst, tmp, head, hlist) {
 			struct nfqnl_queue_entry *entry;
-			while ((entry = find_dequeue_entry(inst, dev_cmp, 
+			while ((entry = find_dequeue_entry(inst, dev_cmp,
 							   ifindex)) != NULL)
 				issue_verdict(entry, NF_DROP);
 		}
@@ -835,8 +835,8 @@ nfqnl_recv_verdict(struct sock *ctnl, st
 
 	if (nfqa[NFQA_MARK-1])
 		entry->skb->mark = ntohl(*(__be32 *)
-		                         NFA_DATA(nfqa[NFQA_MARK-1]));
-		
+					 NFA_DATA(nfqa[NFQA_MARK-1]));
+
 	issue_verdict(entry, verdict);
 	instance_put(queue);
 	return 0;
@@ -1093,7 +1093,7 @@ static int __init nfnetlink_queue_init(v
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *proc_nfqueue;
 #endif
-	
+
 	for (i = 0; i < INSTANCE_BUCKETS; i++)
 		INIT_HLIST_HEAD(&instance_table[i]);
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8996584..6d04e35 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -305,7 +305,7 @@ int xt_find_revision(int af, const char 
 EXPORT_SYMBOL_GPL(xt_find_revision);
 
 int xt_check_match(const struct xt_match *match, unsigned short family,
-                   unsigned int size, const char *table, unsigned int hook_mask,
+		   unsigned int size, const char *table, unsigned int hook_mask,
 		   unsigned short proto, int inv_proto)
 {
 	if (XT_ALIGN(match->matchsize) != size) {
@@ -377,7 +377,7 @@ int xt_compat_match_to_user(struct xt_en
 
 	if (copy_to_user(cm, m, sizeof(*cm)) ||
 	    put_user(msize, &cm->u.user.match_size))
-	    	return -EFAULT;
+		return -EFAULT;
 
 	if (match->compat_to_user) {
 		if (match->compat_to_user((void __user *)cm->data, m->data))
@@ -432,7 +432,7 @@ int xt_compat_target_offset(struct xt_ta
 EXPORT_SYMBOL_GPL(xt_compat_target_offset);
 
 void xt_compat_target_from_user(struct xt_entry_target *t, void **dstptr,
-			        int *size)
+				int *size)
 {
 	struct xt_target *target = t->u.kernel.target;
 	struct compat_xt_entry_target *ct = (struct compat_xt_entry_target *)t;
@@ -467,7 +467,7 @@ int xt_compat_target_to_user(struct xt_e
 
 	if (copy_to_user(ct, t, sizeof(*ct)) ||
 	    put_user(tsize, &ct->u.user.target_size))
-	    	return -EFAULT;
+		return -EFAULT;
 
 	if (target->compat_to_user) {
 		if (target->compat_to_user((void __user *)ct->data, t->data))
@@ -710,7 +710,7 @@ static void *xt_tgt_seq_start(struct seq
 
 	if (mutex_lock_interruptible(&xt[af].mutex) != 0)
 		return NULL;
-	
+
 	return xt_get_idx(list, seq, *pos);
 }
 
@@ -723,7 +723,7 @@ static void *xt_tgt_seq_next(struct seq_
 
 	if (af >= NPROTO)
 		return NULL;
-	
+
 	list = type2list(af, type);
 	if (!list)
 		return NULL;
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 4007bbe..3088483 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -48,7 +48,7 @@ static struct xt_target xt_classify_targ
 		.table		= "mangle",
 		.hooks		= (1 << NF_IP_LOCAL_OUT) |
 				  (1 << NF_IP_FORWARD) |
-			          (1 << NF_IP_POST_ROUTING),
+				  (1 << NF_IP_POST_ROUTING),
 		.me 		= THIS_MODULE,
 	},
 	{
@@ -59,7 +59,7 @@ static struct xt_target xt_classify_targ
 		.table		= "mangle",
 		.hooks		= (1 << NF_IP6_LOCAL_OUT) |
 				  (1 << NF_IP6_FORWARD) |
-			          (1 << NF_IP6_POST_ROUTING),
+				  (1 << NF_IP6_POST_ROUTING),
 		.me 		= THIS_MODULE,
 	},
 };
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index cfc45af..4381780 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -50,11 +50,11 @@ target_v1(struct sk_buff **pskb,
 	case XT_MARK_SET:
 		mark = markinfo->mark;
 		break;
-		
+
 	case XT_MARK_AND:
 		mark = (*pskb)->mark & markinfo->mark;
 		break;
-		
+
 	case XT_MARK_OR:
 		mark = (*pskb)->mark | markinfo->mark;
 		break;
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 39e1175..201155b 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -3,9 +3,9 @@
  * (C) 2005 by Harald Welte <laforge@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as 
+ * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- * 
+ *
  */
 
 #include <linux/module.h>
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
index 6d00dca..b874a20 100644
--- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -22,8 +22,8 @@ target(struct sk_buff **pskb,
 	if ((*pskb)->nfct != NULL)
 		return XT_CONTINUE;
 
-	/* Attach fake conntrack entry. 
-	   If there is a real ct entry correspondig to this packet, 
+	/* Attach fake conntrack entry.
+	   If there is a real ct entry correspondig to this packet,
 	   it'll hang aroun till timing out. We don't deal with it
 	   for performance reasons. JK */
 	nf_ct_untrack(*pskb);
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index f1131c3..705f0e8 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -55,7 +55,7 @@ static int checkentry_selinux(struct xt_
 {
 	int err;
 	struct xt_secmark_target_selinux_info *sel = &info->u.sel;
-	
+
 	sel->selctx[SECMARK_SELCTX_MAX - 1] = '\0';
 
 	err = selinux_string_to_sid(sel->selctx, &sel->selsid);
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 3dc2357..2885c37 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -51,10 +51,10 @@ #define FWINV(bool, invflg) ((bool) ^ !!
 	if (ct == &ip_conntrack_untracked)
 		statebit = XT_CONNTRACK_STATE_UNTRACKED;
 	else if (ct)
- 		statebit = XT_CONNTRACK_STATE_BIT(ctinfo);
- 	else
- 		statebit = XT_CONNTRACK_STATE_INVALID;
- 
+		statebit = XT_CONNTRACK_STATE_BIT(ctinfo);
+	else
+		statebit = XT_CONNTRACK_STATE_INVALID;
+
 	if (sinfo->flags & XT_CONNTRACK_STATE) {
 		if (ct) {
 			if (test_bit(IPS_SRC_NAT_BIT, &ct->status))
@@ -77,7 +77,7 @@ #define FWINV(bool, invflg) ((bool) ^ !!
 	    FWINV(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum !=
 		  sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum,
 		  XT_CONNTRACK_PROTO))
-                return 0;
+		return 0;
 
 	if (sinfo->flags & XT_CONNTRACK_ORIGSRC &&
 	    FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip &
@@ -147,10 +147,10 @@ #define FWINV(bool,invflg) ((bool) ^ !!(
 	if (ct == &nf_conntrack_untracked)
 		statebit = XT_CONNTRACK_STATE_UNTRACKED;
 	else if (ct)
- 		statebit = XT_CONNTRACK_STATE_BIT(ctinfo);
- 	else
- 		statebit = XT_CONNTRACK_STATE_INVALID;
- 
+		statebit = XT_CONNTRACK_STATE_BIT(ctinfo);
+	else
+		statebit = XT_CONNTRACK_STATE_INVALID;
+
 	if (sinfo->flags & XT_CONNTRACK_STATE) {
 		if (ct) {
 			if (test_bit(IPS_SRC_NAT_BIT, &ct->status))
@@ -171,41 +171,41 @@ #define FWINV(bool,invflg) ((bool) ^ !!(
 
 	if (sinfo->flags & XT_CONNTRACK_PROTO &&
 	    FWINV(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum !=
-	    	  sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum,
+		  sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum,
 		  XT_CONNTRACK_PROTO))
-                return 0;
+		return 0;
 
 	if (sinfo->flags & XT_CONNTRACK_ORIGSRC &&
 	    FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip &
-	    	   sinfo->sipmsk[IP_CT_DIR_ORIGINAL].s_addr) !=
+		   sinfo->sipmsk[IP_CT_DIR_ORIGINAL].s_addr) !=
 		  sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip,
 		  XT_CONNTRACK_ORIGSRC))
 		return 0;
 
 	if (sinfo->flags & XT_CONNTRACK_ORIGDST &&
 	    FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.ip &
-	    	   sinfo->dipmsk[IP_CT_DIR_ORIGINAL].s_addr) !=
+		   sinfo->dipmsk[IP_CT_DIR_ORIGINAL].s_addr) !=
 		  sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip,
 		  XT_CONNTRACK_ORIGDST))
 		return 0;
 
 	if (sinfo->flags & XT_CONNTRACK_REPLSRC &&
 	    FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip &
-	    	   sinfo->sipmsk[IP_CT_DIR_REPLY].s_addr) !=
+		   sinfo->sipmsk[IP_CT_DIR_REPLY].s_addr) !=
 		  sinfo->tuple[IP_CT_DIR_REPLY].src.ip,
 		  XT_CONNTRACK_REPLSRC))
 		return 0;
 
 	if (sinfo->flags & XT_CONNTRACK_REPLDST &&
 	    FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip &
-	    	   sinfo->dipmsk[IP_CT_DIR_REPLY].s_addr) !=
+		   sinfo->dipmsk[IP_CT_DIR_REPLY].s_addr) !=
 		  sinfo->tuple[IP_CT_DIR_REPLY].dst.ip,
 		  XT_CONNTRACK_REPLDST))
 		return 0;
 
 	if (sinfo->flags & XT_CONNTRACK_STATUS &&
 	    FWINV((ct->status & sinfo->statusmask) == 0,
-	    	  XT_CONNTRACK_STATUS))
+		  XT_CONNTRACK_STATUS))
 		return 0;
 
 	if(sinfo->flags & XT_CONNTRACK_EXPIRES) {
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 3e6cf43..2c9c0de 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -26,7 +26,7 @@ MODULE_DESCRIPTION("Match for DCCP proto
 MODULE_ALIAS("ipt_dccp");
 
 #define DCCHECK(cond, option, flag, invflag) (!((flag) & (option)) \
-		                  || (!!((invflag) & (option)) ^ (cond)))
+				  || (!!((invflag) & (option)) ^ (cond)))
 
 static unsigned char *dccp_optbuf;
 static DEFINE_SPINLOCK(dccp_buflock);
@@ -67,9 +67,9 @@ dccp_find_option(u_int8_t option,
 			return 1;
 		}
 
-		if (op[i] < 2) 
+		if (op[i] < 2)
 			i++;
-		else 
+		else
 			i += op[i+1]?:1;
 	}
 
@@ -106,18 +106,18 @@ match(const struct sk_buff *skb,
 
 	if (offset)
 		return 0;
-	
+
 	dh = skb_header_pointer(skb, protoff, sizeof(_dh), &_dh);
 	if (dh == NULL) {
 		*hotdrop = 1;
 		return 0;
-       	}
+	}
 
-	return  DCCHECK(((ntohs(dh->dccph_sport) >= info->spts[0]) 
-			&& (ntohs(dh->dccph_sport) <= info->spts[1])), 
-		   	XT_DCCP_SRC_PORTS, info->flags, info->invflags)
-		&& DCCHECK(((ntohs(dh->dccph_dport) >= info->dpts[0]) 
-			&& (ntohs(dh->dccph_dport) <= info->dpts[1])), 
+	return  DCCHECK(((ntohs(dh->dccph_sport) >= info->spts[0])
+			&& (ntohs(dh->dccph_sport) <= info->spts[1])),
+			XT_DCCP_SRC_PORTS, info->flags, info->invflags)
+		&& DCCHECK(((ntohs(dh->dccph_dport) >= info->dpts[0])
+			&& (ntohs(dh->dccph_dport) <= info->dpts[1])),
 			XT_DCCP_DEST_PORTS, info->flags, info->invflags)
 		&& DCCHECK(match_types(dh, info->typemask),
 			   XT_DCCP_TYPE, info->flags, info->invflags)
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index bd1f7a2..852e405 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -208,7 +208,7 @@ static int htable_create(struct xt_hashl
 	spin_lock_init(&hinfo->lock);
 	hinfo->pde = create_proc_entry(minfo->name, 0,
 				       family == AF_INET ? hashlimit_procdir4 :
-				       			   hashlimit_procdir6);
+							   hashlimit_procdir6);
 	if (!hinfo->pde) {
 		vfree(hinfo);
 		return -1;
@@ -240,7 +240,7 @@ static int select_gc(struct xt_hashlimit
 }
 
 static void htable_selective_cleanup(struct xt_hashlimit_htable *ht,
-		 		int (*select)(struct xt_hashlimit_htable *ht,
+				int (*select)(struct xt_hashlimit_htable *ht,
 					      struct dsthash_ent *he))
 {
 	unsigned int i;
@@ -279,7 +279,7 @@ static void htable_destroy(struct xt_has
 	/* remove proc entry */
 	remove_proc_entry(hinfo->pde->name,
 			  hinfo->family == AF_INET ? hashlimit_procdir4 :
-			  			     hashlimit_procdir6);
+						     hashlimit_procdir6);
 	htable_selective_cleanup(hinfo, select_all);
 	vfree(hinfo);
 }
@@ -483,7 +483,7 @@ hashlimit_match(const struct sk_buff *sk
 		return 1;
 	}
 
-       	spin_unlock_bh(&hinfo->lock);
+	spin_unlock_bh(&hinfo->lock);
 
 	/* default case: we're overlimit, thus don't match */
 	return 0;
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 04bc32b..407d1d5 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -53,7 +53,7 @@ match(const struct sk_buff *skb,
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 	int ret = info->invert;
-	
+
 	ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
 	if (!ct) {
 		DEBUGP("xt_helper: Eek! invalid conntrack?\n");
@@ -67,19 +67,19 @@ match(const struct sk_buff *skb,
 
 	read_lock_bh(&ip_conntrack_lock);
 	if (!ct->master->helper) {
-		DEBUGP("xt_helper: master ct %p has no helper\n", 
+		DEBUGP("xt_helper: master ct %p has no helper\n",
 			exp->expectant);
 		goto out_unlock;
 	}
 
-	DEBUGP("master's name = %s , info->name = %s\n", 
+	DEBUGP("master's name = %s , info->name = %s\n",
 		ct->master->helper->name, info->name);
 
 	if (info->name[0] == '\0')
 		ret ^= 1;
 	else
-		ret ^= !strncmp(ct->master->helper->name, info->name, 
-		                strlen(ct->master->helper->name));
+		ret ^= !strncmp(ct->master->helper->name, info->name,
+				strlen(ct->master->helper->name));
 out_unlock:
 	read_unlock_bh(&ip_conntrack_lock);
 	return ret;
@@ -102,7 +102,7 @@ match(const struct sk_buff *skb,
 	struct nf_conn_help *master_help;
 	enum ip_conntrack_info ctinfo;
 	int ret = info->invert;
-	
+
 	ct = nf_ct_get((struct sk_buff *)skb, &ctinfo);
 	if (!ct) {
 		DEBUGP("xt_helper: Eek! invalid conntrack?\n");
@@ -117,19 +117,19 @@ match(const struct sk_buff *skb,
 	read_lock_bh(&nf_conntrack_lock);
 	master_help = nfct_help(ct->master);
 	if (!master_help || !master_help->helper) {
-		DEBUGP("xt_helper: master ct %p has no helper\n", 
+		DEBUGP("xt_helper: master ct %p has no helper\n",
 			exp->expectant);
 		goto out_unlock;
 	}
 
-	DEBUGP("master's name = %s , info->name = %s\n", 
+	DEBUGP("master's name = %s , info->name = %s\n",
 		ct->master->helper->name, info->name);
 
 	if (info->name[0] == '\0')
 		ret ^= 1;
 	else
 		ret ^= !strncmp(master_help->helper->name, info->name,
-		                strlen(master_help->helper->name));
+				strlen(master_help->helper->name));
 out_unlock:
 	read_unlock_bh(&nf_conntrack_lock);
 	return ret;
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index 67fd30d..32fb998 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -32,7 +32,7 @@ match(const struct sk_buff *skb,
 {
 	const struct xt_length_info *info = matchinfo;
 	u_int16_t pktlen = ntohs(skb->nh.iph->tot_len);
-	
+
 	return (pktlen >= info->min && pktlen <= info->max) ^ info->invert;
 }
 
@@ -48,7 +48,7 @@ match6(const struct sk_buff *skb,
 {
 	const struct xt_length_info *info = matchinfo;
 	u_int16_t pktlen = ntohs(skb->nh.ipv6h->payload_len) + sizeof(struct ipv6hdr);
-	
+
 	return (pktlen >= info->min && pktlen <= info->max) ^ info->invert;
 }
 
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index fda7b7d..6fd8347 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -89,7 +89,7 @@ ipt_limit_match(const struct sk_buff *sk
 		return 1;
 	}
 
-       	spin_unlock_bh(&limit_lock);
+	spin_unlock_bh(&limit_lock);
 	return 0;
 }
 
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index dfa1ee6..39911dd 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -36,10 +36,10 @@ match(const struct sk_buff *skb,
 
 static int
 checkentry(const char *tablename,
-           const void *entry,
+	   const void *entry,
 	   const struct xt_match *match,
-           void *matchinfo,
-           unsigned int hook_mask)
+	   void *matchinfo,
+	   unsigned int hook_mask)
 {
 	const struct xt_mark_info *minfo = matchinfo;
 
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index 1602086..4dce2a8 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -91,7 +91,7 @@ ports_match_v1(const struct xt_multiport
 		}
 	}
 
- 	return minfo->invert;
+	return minfo->invert;
 }
 
 static int
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index b9b3ffc..35a0fe2 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -117,7 +117,7 @@ checkentry(const char *tablename,
 	    (!(info->bitmask & XT_PHYSDEV_OP_BRIDGED) ||
 	     info->invert & XT_PHYSDEV_OP_BRIDGED) &&
 	    hook_mask & ((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_FORWARD) |
-	                 (1 << NF_IP_POST_ROUTING))) {
+			 (1 << NF_IP_POST_ROUTING))) {
 		printk(KERN_WARNING "physdev match: using --physdev-out in the "
 		       "OUTPUT, FORWARD and POSTROUTING chains for non-bridged "
 		       "traffic is not supported anymore.\n");
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index 46bde2b..15b45a9 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -109,13 +109,13 @@ match_policy_out(const struct sk_buff *s
 }
 
 static int match(const struct sk_buff *skb,
-                 const struct net_device *in,
-                 const struct net_device *out,
-                 const struct xt_match *match,
-                 const void *matchinfo,
-                 int offset,
-                 unsigned int protoff,
-                 int *hotdrop)
+		 const struct net_device *in,
+		 const struct net_device *out,
+		 const struct xt_match *match,
+		 const void *matchinfo,
+		 int offset,
+		 unsigned int protoff,
+		 int *hotdrop)
 {
 	const struct xt_policy_info *info = matchinfo;
 	int ret;
@@ -134,27 +134,27 @@ static int match(const struct sk_buff *s
 }
 
 static int checkentry(const char *tablename, const void *ip_void,
-                      const struct xt_match *match,
-                      void *matchinfo, unsigned int hook_mask)
+		      const struct xt_match *match,
+		      void *matchinfo, unsigned int hook_mask)
 {
 	struct xt_policy_info *info = matchinfo;
 
 	if (!(info->flags & (XT_POLICY_MATCH_IN|XT_POLICY_MATCH_OUT))) {
 		printk(KERN_ERR "xt_policy: neither incoming nor "
-		                "outgoing policy selected\n");
+				"outgoing policy selected\n");
 		return 0;
 	}
 	/* hook values are equal for IPv4 and IPv6 */
 	if (hook_mask & (1 << NF_IP_PRE_ROUTING | 1 << NF_IP_LOCAL_IN)
 	    && info->flags & XT_POLICY_MATCH_OUT) {
 		printk(KERN_ERR "xt_policy: output policy not valid in "
-		                "PRE_ROUTING and INPUT\n");
+				"PRE_ROUTING and INPUT\n");
 		return 0;
 	}
 	if (hook_mask & (1 << NF_IP_POST_ROUTING | 1 << NF_IP_LOCAL_OUT)
 	    && info->flags & XT_POLICY_MATCH_IN) {
 		printk(KERN_ERR "xt_policy: input policy not valid in "
-		                "POST_ROUTING and OUTPUT\n");
+				"POST_ROUTING and OUTPUT\n");
 		return 0;
 	}
 	if (info->len > XT_POLICY_MAX_ELEM) {
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index b75fa2c..bfdde06 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -30,8 +30,8 @@ match(const struct sk_buff *skb,
 		q->quota -= skb->len;
 		ret ^= 1;
 	} else {
-	        /* we do not allow even small packets from now on */
-	        q->quota = 0;
+		/* we do not allow even small packets from now on */
+		q->quota = 0;
 	}
 	spin_unlock_bh(&quota_lock);
 
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index a80b7d1..97ffc2f 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -35,7 +35,7 @@ match(const struct sk_buff *skb,
 {
 	const struct xt_realm_info *info = matchinfo;
 	struct dst_entry *dst = skb->dst;
-    
+
 	return (info->id == (dst->tclassid & info->mask)) ^ info->invert;
 }
 
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index 71bf036..f86d8d7 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -66,9 +66,9 @@ #endif
 			duprintf("Dropping invalid SCTP packet.\n");
 			*hotdrop = 1;
 			return 0;
-        	}
+		}
 
-		duprintf("Chunk num: %d\toffset: %d\ttype: %d\tlength: %d\tflags: %x\n", 
+		duprintf("Chunk num: %d\toffset: %d\ttype: %d\tlength: %d\tflags: %x\n",
 				++i, offset, sch->type, htons(sch->length), sch->flags);
 
 		offset += (ntohs(sch->length) + 3) & ~3;
@@ -78,21 +78,21 @@ #endif
 		if (SCTP_CHUNKMAP_IS_SET(chunkmap, sch->type)) {
 			switch (chunk_match_type) {
 			case SCTP_CHUNK_MATCH_ANY:
-				if (match_flags(flag_info, flag_count, 
+				if (match_flags(flag_info, flag_count,
 					sch->type, sch->flags)) {
 					return 1;
 				}
 				break;
 
 			case SCTP_CHUNK_MATCH_ALL:
-				if (match_flags(flag_info, flag_count, 
+				if (match_flags(flag_info, flag_count,
 					sch->type, sch->flags)) {
 					SCTP_CHUNKMAP_CLEAR(chunkmapcopy, sch->type);
 				}
 				break;
 
 			case SCTP_CHUNK_MATCH_ONLY:
-				if (!match_flags(flag_info, flag_count, 
+				if (!match_flags(flag_info, flag_count,
 					sch->type, sch->flags)) {
 					return 0;
 				}
@@ -136,24 +136,24 @@ match(const struct sk_buff *skb,
 		duprintf("Dropping non-first fragment.. FIXME\n");
 		return 0;
 	}
-	
+
 	sh = skb_header_pointer(skb, protoff, sizeof(_sh), &_sh);
 	if (sh == NULL) {
 		duprintf("Dropping evil TCP offset=0 tinygram.\n");
 		*hotdrop = 1;
 		return 0;
-       	}
+	}
 	duprintf("spt: %d\tdpt: %d\n", ntohs(sh->source), ntohs(sh->dest));
 
-	return  SCCHECK(((ntohs(sh->source) >= info->spts[0]) 
-			&& (ntohs(sh->source) <= info->spts[1])), 
-		   	XT_SCTP_SRC_PORTS, info->flags, info->invflags)
-		&& SCCHECK(((ntohs(sh->dest) >= info->dpts[0]) 
-			&& (ntohs(sh->dest) <= info->dpts[1])), 
+	return  SCCHECK(((ntohs(sh->source) >= info->spts[0])
+			&& (ntohs(sh->source) <= info->spts[1])),
+			XT_SCTP_SRC_PORTS, info->flags, info->invflags)
+		&& SCCHECK(((ntohs(sh->dest) >= info->dpts[0])
+			&& (ntohs(sh->dest) <= info->dpts[1])),
 			XT_SCTP_DEST_PORTS, info->flags, info->invflags)
 		&& SCCHECK(match_packet(skb, protoff + sizeof (sctp_sctphdr_t),
 					info->chunkmap, info->chunk_match_type,
- 					info->flag_info, info->flag_count, 
+					info->flag_info, info->flag_count,
 					hotdrop),
 			   XT_SCTP_CHUNK_TYPES, info->flags, info->invflags);
 }
@@ -170,9 +170,9 @@ checkentry(const char *tablename,
 	return !(info->flags & ~XT_SCTP_VALID_FLAGS)
 		&& !(info->invflags & ~XT_SCTP_VALID_FLAGS)
 		&& !(info->invflags & ~info->flags)
-		&& ((!(info->flags & XT_SCTP_CHUNK_TYPES)) || 
+		&& ((!(info->flags & XT_SCTP_CHUNK_TYPES)) ||
 			(info->chunk_match_type &
-				(SCTP_CHUNK_MATCH_ALL 
+				(SCTP_CHUNK_MATCH_ALL
 				| SCTP_CHUNK_MATCH_ANY
 				| SCTP_CHUNK_MATCH_ONLY)));
 }
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 4453252..999a005 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -1,5 +1,5 @@
 /* String matching match for iptables
- * 
+ *
  * (C) 2005 Pablo Neira Ayuso <pablo@eurodev.net>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -35,8 +35,8 @@ static int match(const struct sk_buff *s
 
 	memset(&state, 0, sizeof(struct ts_state));
 
-	return (skb_find_text((struct sk_buff *)skb, conf->from_offset, 
-			     conf->to_offset, conf->config, &state) 
+	return (skb_find_text((struct sk_buff *)skb, conf->from_offset,
+			     conf->to_offset, conf->config, &state)
 			     != UINT_MAX) ^ conf->invert;
 }
 
@@ -55,7 +55,7 @@ static int checkentry(const char *tablen
 	if (conf->from_offset > conf->to_offset)
 		return 0;
 	if (conf->algo[XT_STRING_MAX_ALGO_NAME_SIZE - 1] != '\0')
-	    	return 0;
+		return 0;
 	if (conf->patlen > XT_STRING_MAX_PATTERN_SIZE)
 		return 0;
 	ts_conf = textsearch_prepare(conf->algo, conf->pattern, conf->patlen,
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index a3682fe..80571d0 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -64,9 +64,9 @@ match(const struct sk_buff *skb,
 			u_int16_t mssval;
 
 			mssval = (op[i+2] << 8) | op[i+3];
-			
+
 			return (mssval >= info->mss_min &&
-			        mssval <= info->mss_max) ^ info->invert;
+				mssval <= info->mss_max) ^ info->invert;
 		}
 		if (op[i] < 2)
 			i++;
