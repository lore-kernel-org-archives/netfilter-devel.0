From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3/11] Netfilter:  Fix Up IRC, AMANDA, TFTP and SNMP Helpers
Date: Mon, 17 Jan 2005 16:45:16 +1100
Message-ID: <1105940716.3954.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

Name: Fix Up IRC, AMANDA, TFTP and SNMP Helpers
Status: Compiled on 2.6.10-rc2-bk6
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Fixes up the other helpers for direct conntrack->NAT helper calling.
SNMP doesn't really need a conntrack helper, but under this new model,
the NAT helper will register at that point anyway: NAT helpers
themselves are removed.

Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2005-01-17 14:59:08.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2005-01-17 15:24:38.991188592 +1100
@@ -415,10 +415,6 @@
 		IP_NF_ASSERT(info->num_manips <= IP_NAT_MAX_MANIPS);
 	}
 
-	/* If there's a helper, assign it; based on new tuple. */
-	if (!conntrack->master)
-		info->helper = __ip_nat_find_helper(&reply);
-
 	/* It's done. */
 	info->initialized |= (1 << HOOK2MANIP(hooknum));
 
@@ -523,16 +519,6 @@
 			}
 		}
 	}
-
-	if (info->helper) {
-		DEBUGP("do_bindings: helper existing for (%p)\n", ct);
-
-		/* Always defragged for helpers */
-		IP_NF_ASSERT(!((*pskb)->nh.iph->frag_off
-			       & htons(IP_MF|IP_OFFSET)));
-
-		ret = info->helper->help(ct, NULL, info, ctinfo, hooknum,pskb);
-	}
 	READ_UNLOCK(&ip_nat_lock);
 
 	/* FIXME: NAT/conntrack helpers should set ctinfo &
Index: linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_nat_helper.h
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/include/linux/netfilter_ipv4/ip_nat_helper.h	2005-01-17 14:59:08.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_nat_helper.h	2005-01-17 15:24:42.044724384 +1100
@@ -7,40 +7,6 @@
 
 struct sk_buff;
 
-/* Flags */
-/* NAT helper must be called on every packet (for TCP) */
-#define IP_NAT_HELPER_F_ALWAYS		0x01
-
-struct ip_nat_helper
-{
-	struct list_head list;		/* Internal use */
-
-	const char *name;		/* name of the module */
-	unsigned char flags;		/* Flags (see above) */
-	struct module *me;		/* pointer to self */
-	
-	/* Mask of things we will help: vs. tuple from server */
-	struct ip_conntrack_tuple tuple;
-	struct ip_conntrack_tuple mask;
-	
-	/* Helper function: returns verdict */
-	unsigned int (*help)(struct ip_conntrack *ct,
-			     struct ip_conntrack_expect *exp,
-			     struct ip_nat_info *info,
-			     enum ip_conntrack_info ctinfo,
-			     unsigned int hooknum,
-			     struct sk_buff **pskb);
-};
-
-extern int ip_nat_helper_register(struct ip_nat_helper *me);
-extern void ip_nat_helper_unregister(struct ip_nat_helper *me);
-
-extern struct ip_nat_helper *
-ip_nat_find_helper(const struct ip_conntrack_tuple *tuple);
-
-extern struct ip_nat_helper *
-__ip_nat_find_helper(const struct ip_conntrack_tuple *tuple);
-
 /* These return true or false. */
 extern int ip_nat_mangle_tcp_packet(struct sk_buff **skb,
 				struct ip_conntrack *ct,
Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_conntrack_amanda.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_amanda.c	2005-01-06 12:02:22.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_conntrack_amanda.c	2005-01-17 15:24:41.988732896 +1100
@@ -44,14 +44,22 @@
 static char amanda_buffer[65536];
 static DECLARE_LOCK(amanda_buffer_lock);
 
-static int help(struct sk_buff *skb,
+unsigned int (*ip_nat_amanda_hook)(struct sk_buff **pskb,
+				   struct ip_conntrack *ct,
+				   enum ip_conntrack_info ctinfo,
+				   unsigned int matchoff,
+				   unsigned int matchlen,
+				   struct ip_conntrack_expect *exp);
+EXPORT_SYMBOL_GPL(ip_nat_amanda_hook);
+
+static int help(struct sk_buff **pskb,
                 struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
 {
 	struct ip_conntrack_expect *exp;
-	struct ip_ct_amanda_expect *exp_amanda_info;
 	char *data, *data_limit, *tmp;
 	unsigned int dataoff, i;
 	u_int16_t port, len;
+	int ret = NF_ACCEPT;
 
 	/* Only look at packets from the Amanda server */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
@@ -62,17 +70,17 @@
 	ip_ct_refresh_acct(ct, ctinfo, NULL, master_timeout * HZ);
 
 	/* No data? */
-	dataoff = skb->nh.iph->ihl*4 + sizeof(struct udphdr);
-	if (dataoff >= skb->len) {
+	dataoff = (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
+	if (dataoff >= (*pskb)->len) {
 		if (net_ratelimit())
-			printk("amanda_help: skblen = %u\n", skb->len);
+			printk("amanda_help: skblen = %u\n", (*pskb)->len);
 		return NF_ACCEPT;
 	}
 
 	LOCK_BH(&amanda_buffer_lock);
-	skb_copy_bits(skb, dataoff, amanda_buffer, skb->len - dataoff);
+	skb_copy_bits(*pskb, dataoff, amanda_buffer, (*pskb)->len - dataoff);
 	data = amanda_buffer;
-	data_limit = amanda_buffer + skb->len - dataoff;
+	data_limit = amanda_buffer + (*pskb)->len - dataoff;
 	*data_limit = '\0';
 
 	/* Search for the CONNECT string */
@@ -96,36 +104,41 @@
 			break;
 
 		exp = ip_conntrack_expect_alloc();
-		if (exp == NULL)
+		if (exp == NULL) {
+			ret = NF_DROP;
 			goto out;
+		}
+
+		exp->expectfn = NULL;
 
 		exp->tuple.src.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+		exp->tuple.src.u.tcp.port = 0;
 		exp->tuple.dst.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
 		exp->tuple.dst.protonum = IPPROTO_TCP;
+		exp->tuple.dst.u.tcp.port = htons(port);
+
 		exp->mask.src.ip = 0xFFFFFFFF;
+		exp->mask.src.u.tcp.port = 0;
 		exp->mask.dst.ip = 0xFFFFFFFF;
 		exp->mask.dst.protonum = 0xFFFF;
 		exp->mask.dst.u.tcp.port = 0xFFFF;
 
-		exp_amanda_info = &exp->help.exp_amanda_info;
-		exp_amanda_info->offset = tmp - amanda_buffer;
-		exp_amanda_info->port   = port;
-		exp_amanda_info->len    = len;
-
-		exp->tuple.dst.u.tcp.port = htons(port);
-
-		ip_conntrack_expect_related(exp, ct);
+		if (ip_nat_amanda_hook)
+			ret = ip_nat_amanda_hook(pskb, ct, ctinfo,
+						 tmp - amanda_buffer,
+						 len, exp);
+		else if (ip_conntrack_expect_related(exp, ct) != 0)
+			ret = NF_DROP;
 	}
 
 out:
 	UNLOCK_BH(&amanda_buffer_lock);
-	return NF_ACCEPT;
+	return ret;
 }
 
 static struct ip_conntrack_helper amanda_helper = {
 	.max_expected = ARRAY_SIZE(conns),
 	.timeout = 180,
-	.flags = IP_CT_HELPER_F_REUSE_EXPECT,
 	.me = THIS_MODULE,
 	.help = help,
 	.name = "amanda",
@@ -148,6 +161,5 @@
 	return ip_conntrack_helper_register(&amanda_helper);
 }
 
-PROVIDES_CONNTRACK(amanda);
 module_init(init);
 module_exit(fini);
Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_helper.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_nat_helper.c	2005-01-17 14:59:08.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_helper.c	2005-01-17 15:24:41.988732896 +1100
@@ -47,7 +47,6 @@
 #define DUMP_OFFSET(x)
 #endif
 
-static LIST_HEAD(helpers);
 DECLARE_LOCK(ip_nat_seqofs_lock);
 
 /* Setup TCP sequence correction given this change at this sequence */
@@ -448,76 +447,3 @@
 
 	ip_nat_copy_manip(master, ct->master, ct);
 }
-
-static inline int
-helper_cmp(const struct ip_nat_helper *helper,
-	   const struct ip_conntrack_tuple *tuple)
-{
-	return ip_ct_tuple_mask_cmp(tuple, &helper->tuple, &helper->mask);
-}
-
-int ip_nat_helper_register(struct ip_nat_helper *me)
-{
-	int ret = 0;
-
-	WRITE_LOCK(&ip_nat_lock);
-	if (LIST_FIND(&helpers, helper_cmp, struct ip_nat_helper *,&me->tuple))
-		ret = -EBUSY;
-	else
-		list_prepend(&helpers, me);
-	WRITE_UNLOCK(&ip_nat_lock);
-
-	return ret;
-}
-
-struct ip_nat_helper *
-__ip_nat_find_helper(const struct ip_conntrack_tuple *tuple)
-{
-	return LIST_FIND(&helpers, helper_cmp, struct ip_nat_helper *, tuple);
-}
-
-struct ip_nat_helper *
-ip_nat_find_helper(const struct ip_conntrack_tuple *tuple)
-{
-	struct ip_nat_helper *h;
-
-	READ_LOCK(&ip_nat_lock);
-	h = __ip_nat_find_helper(tuple);
-	READ_UNLOCK(&ip_nat_lock);
-
-	return h;
-}
-
-static int
-kill_helper(struct ip_conntrack *i, void *helper)
-{
-	int ret;
-
-	READ_LOCK(&ip_nat_lock);
-	ret = (i->nat.info.helper == helper);
-	READ_UNLOCK(&ip_nat_lock);
-
-	return ret;
-}
-
-void ip_nat_helper_unregister(struct ip_nat_helper *me)
-{
-	WRITE_LOCK(&ip_nat_lock);
-	/* Autoloading conntrack helper might have failed */
-	if (LIST_FIND(&helpers, helper_cmp, struct ip_nat_helper *,&me->tuple)) {
-		LIST_DELETE(&helpers, me);
-	}
-	WRITE_UNLOCK(&ip_nat_lock);
-
-	/* Someone could be still looking at the helper in a bh. */
-	synchronize_net();
-
-	/* Find anything using it, and umm, kill them.  We can't turn
-	   them into normal connections: if we've adjusted SYNs, then
-	   they'll ackstorm.  So we just drop it.  We used to just
-	   bump module count when a connection existed, but that
-	   forces admins to gen fake RSTs or bounce box, either of
-	   which is just a long-winded way of making things
-	   worse. --RR */
-	ip_ct_iterate_cleanup(kill_helper, me);
-}
Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_snmp_basic.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_nat_snmp_basic.c	2005-01-17 13:59:08.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_snmp_basic.c	2005-01-17 14:59:11.000000000 +1100
@@ -1234,15 +1234,15 @@
 	
 	if (!snmp_parse_mangle((unsigned char *)udph + sizeof(struct udphdr),
 	                       paylen, &map, &udph->check)) {
-		printk(KERN_WARNING "bsalg: parser failed\n");
+		if (net_ratelimit())
+			printk(KERN_WARNING "bsalg: parser failed\n");
 		return NF_DROP;
 	}
 	return NF_ACCEPT;
 }
 
-/* 
- * NAT helper function, packets arrive here from NAT code.
- */
+/* We don't actually set up expectations, just adjust internal IP
+ * addresses if this is being NATted */
 static unsigned int nat_help(struct ip_conntrack *ct,
 			     struct ip_conntrack_expect *exp,
                              struct ip_nat_info *info,
@@ -1251,25 +1251,23 @@
                              struct sk_buff **pskb)
 {
 	int dir = CTINFO2DIR(ctinfo);
+	unsigned int ret;
 	struct iphdr *iph = (*pskb)->nh.iph;
 	struct udphdr *udph = (struct udphdr *)((u_int32_t *)iph + iph->ihl);
 	
-	if (!skb_ip_make_writable(pskb, (*pskb)->len))
-		return NF_DROP;
-
-	spin_lock_bh(&snmp_lock);
-	
 	/*
 	 * Translate snmp replies on pre-routing (DNAT) and snmp traps
 	 * on post routing (SNAT).
 	 */
 	if (!((dir == IP_CT_DIR_REPLY && hooknum == NF_IP_PRE_ROUTING &&
-			udph->source == ntohs(SNMP_PORT)) ||
+	       udph->source == ntohs(SNMP_PORT)) ||
 	      (dir == IP_CT_DIR_ORIGINAL && hooknum == NF_IP_POST_ROUTING &&
-	      		udph->dest == ntohs(SNMP_TRAP_PORT)))) {
-		spin_unlock_bh(&snmp_lock);
+	       udph->dest == ntohs(SNMP_TRAP_PORT))))
+		return NF_ACCEPT;
+
+	/* No NAT? */
+	if (ct->nat.num_manips == 0)
 		return NF_ACCEPT;
-	}
 
 	if (debug > 1) {
 		printk(KERN_DEBUG "bsalg: dir=%s hook=%d manip=%s len=%d "
@@ -1294,41 +1292,52 @@
 	 * enough room for a UDP header.  Just verify the UDP length field so we
 	 * can mess around with the payload.
 	 */
-	 if (ntohs(udph->len) == (*pskb)->len - (iph->ihl << 2)) {
-	 	int ret = snmp_translate(ct, info, ctinfo, hooknum, pskb);
-	 	spin_unlock_bh(&snmp_lock);
-	 	return ret;
+	if (ntohs(udph->len) != (*pskb)->len - (iph->ihl << 2)) {
+		 if (net_ratelimit())
+			 printk(KERN_WARNING "SNMP: dropping malformed packet "
+				"src=%u.%u.%u.%u dst=%u.%u.%u.%u\n",
+				NIPQUAD(iph->saddr), NIPQUAD(iph->daddr));
+		 return NF_DROP;
 	}
-	
-	if (net_ratelimit())
-		printk(KERN_WARNING "bsalg: dropping malformed packet "
-		       "src=%u.%u.%u.%u dst=%u.%u.%u.%u\n",
-		       NIPQUAD(iph->saddr), NIPQUAD(iph->daddr));
+
+	if (!skb_ip_make_writable(pskb, (*pskb)->len))
+		return NF_DROP;
+
+	spin_lock_bh(&snmp_lock);
+	ret = snmp_translate(ct, info, ctinfo, hooknum, pskb);
 	spin_unlock_bh(&snmp_lock);
-	return NF_DROP;
+	return ret;
 }
 
-static struct ip_nat_helper snmp = { 
-	{ NULL, NULL },
-	"snmp",
-	0,
-	THIS_MODULE,
-	{ { 0, { .udp = { __constant_htons(SNMP_PORT) } } },
-	  { 0, { 0 }, IPPROTO_UDP } },
-	{ { 0, { .udp = { 0xFFFF } } },
-	  { 0, { 0 }, 0xFFFF } },
-	nat_help, NULL };
- 
-static struct ip_nat_helper snmp_trap = { 
-	{ NULL, NULL },
-	"snmp_trap",
-	0,
-	THIS_MODULE,
-	{ { 0, { .udp = { __constant_htons(SNMP_TRAP_PORT) } } },
-	  { 0, { 0 }, IPPROTO_UDP } },
-	{ { 0, { .udp = { 0xFFFF } } },
-	  { 0, { 0 }, 0xFFFF } },
-	nat_help, NULL };
+static struct ip_conntrack_helper snmp_helper = {
+	.max_expected = 0,
+	.timeout = 180,
+	.me = THIS_MODULE,
+	.help = help,
+	.name = "snmp",
+
+	.tuple = { .src = { .u = { __constant_htons(SNMP_PORT) } },
+		   .dst = { .protonum = IPPROTO_UDP },
+	},
+	.mask = { .src = { .u = { 0xFFFF } },
+		 .dst = { .protonum = 0xFFFF },
+	},
+};
+
+static struct ip_conntrack_helper snmp_trap_helper = {
+	.max_expected = 0,
+	.timeout = 180,
+	.me = THIS_MODULE,
+	.help = help,
+	.name = "snmp_trap",
+
+	.tuple = { .src = { .u = { __constant_htons(SNMP_TRAP_PORT) } },
+		   .dst = { .protonum = IPPROTO_UDP },
+	},
+	.mask = { .src = { .u = { 0xFFFF } },
+		 .dst = { .protonum = 0xFFFF },
+	},
+};
 
 /*****************************************************************************
  *
@@ -1340,12 +1349,12 @@
 {
 	int ret = 0;
 
-	ret = ip_nat_helper_register(&snmp);
+	ret = ip_conntrack_helper_register(&snmp);
 	if (ret < 0)
 		return ret;
-	ret = ip_nat_helper_register(&snmp_trap);
+	ret = ip_conntrack_helper_register(&snmp_trap);
 	if (ret < 0) {
-		ip_nat_helper_unregister(&snmp);
+		ip_conntrack_helper_unregister(&snmp);
 		return ret;
 	}
 	return ret;
@@ -1353,9 +1362,8 @@
 
 static void __exit fini(void)
 {
-	ip_nat_helper_unregister(&snmp);
-	ip_nat_helper_unregister(&snmp_trap);
-	synchronize_net();
+	ip_conntrack_helper_unregister(&snmp);
+	ip_conntrack_helper_unregister(&snmp_trap);
 }
 
 module_init(init);
Index: linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-17 14:59:08.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-17 15:24:42.044724384 +1100
@@ -79,11 +79,6 @@
 
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 #include <linux/netfilter_ipv4/ip_nat.h>
-
-/* per conntrack: nat application helper private data */
-union ip_conntrack_nat_help {
-	/* insert nat helper private data here */
-};
 #endif
 
 #include <linux/types.h>
@@ -191,7 +186,6 @@
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 	struct {
 		struct ip_nat_info info;
-		union ip_conntrack_nat_help help;
 #if defined(CONFIG_IP_NF_TARGET_MASQUERADE) || \
 	defined(CONFIG_IP_NF_TARGET_MASQUERADE_MODULE)
 		int masq_index;
@@ -303,15 +297,5 @@
 
 #define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count++)
 
-/* eg. PROVIDES_CONNTRACK(ftp); */
-#define PROVIDES_CONNTRACK(name)                        \
-        int needs_ip_conntrack_##name;                  \
-        EXPORT_SYMBOL(needs_ip_conntrack_##name)
-
-/*. eg. NEEDS_CONNTRACK(ftp); */
-#define NEEDS_CONNTRACK(name)                                           \
-        extern int needs_ip_conntrack_##name;                           \
-        static int *need_ip_conntrack_##name __attribute_used__ = &needs_ip_conntrack_##name
-
 #endif /* __KERNEL__ */
 #endif /* _IP_CONNTRACK_H */
Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_conntrack_tftp.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_tftp.c	2005-01-06 12:02:22.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_conntrack_tftp.c	2005-01-17 15:24:41.989732744 +1100
@@ -38,15 +38,22 @@
 #define DEBUGP(format, args...)
 #endif
 
-static int tftp_help(struct sk_buff *skb,
+unsigned int (*ip_nat_tftp_hook)(struct sk_buff **pskb,
+				 struct ip_conntrack *ct,
+				 enum ip_conntrack_info ctinfo,
+				 struct ip_conntrack_expect *exp);
+EXPORT_SYMBOL_GPL(ip_nat_tftp_hook);
+
+static int tftp_help(struct sk_buff **pskb,
 		     struct ip_conntrack *ct,
 		     enum ip_conntrack_info ctinfo)
 {
 	struct tftphdr _tftph, *tfh;
 	struct ip_conntrack_expect *exp;
+	unsigned int ret = NF_ACCEPT;
 
-	tfh = skb_header_pointer(skb,
-				 skb->nh.iph->ihl * 4 + sizeof(struct udphdr),
+	tfh = skb_header_pointer(*pskb,
+				 (*pskb)->nh.iph->ihl*4+sizeof(struct udphdr),
 				 sizeof(_tftph), &_tftph);
 	if (tfh == NULL)
 		return NF_ACCEPT;
@@ -61,7 +68,7 @@
 
 		exp = ip_conntrack_expect_alloc();
 		if (exp == NULL)
-			return NF_ACCEPT;
+			return NF_DROP;
 
 		exp->tuple = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
 		exp->mask.src.ip = 0xffffffff;
@@ -73,7 +80,10 @@
 		DEBUGP("expect: ");
 		DUMP_TUPLE(&exp->tuple);
 		DUMP_TUPLE(&exp->mask);
-		ip_conntrack_expect_related(exp, ct);
+		if (ip_nat_tftp_hook)
+			ret = ip_nat_tftp_hook(pskb, ct, ctinfo, exp);
+		else if (ip_conntrack_expect_related(exp, ct) != 0)
+			ret = NF_DROP;
 		break;
 	case TFTP_OPCODE_DATA:
 	case TFTP_OPCODE_ACK:
@@ -120,7 +130,6 @@
 		tftp[i].mask.src.u.udp.port = 0xFFFF;
 		tftp[i].max_expected = 1;
 		tftp[i].timeout = 0;
-		tftp[i].flags = IP_CT_HELPER_F_REUSE_EXPECT;
 		tftp[i].me = THIS_MODULE;
 		tftp[i].help = tftp_help;
 
@@ -144,7 +153,5 @@
 	return(0);
 }
 
-PROVIDES_CONNTRACK(tftp);
-
 module_init(init);
 module_exit(fini);
Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_amanda.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_nat_amanda.c	2005-01-13 12:11:13.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_amanda.c	2005-01-17 15:24:41.989732744 +1100
@@ -31,118 +31,63 @@
 MODULE_DESCRIPTION("Amanda NAT helper");
 MODULE_LICENSE("GPL");
 
-static unsigned int
-amanda_nat_expected(struct sk_buff **pskb,
-                    unsigned int hooknum,
-                    struct ip_conntrack *ct,
-                    struct ip_nat_info *info)
+static unsigned int help(struct sk_buff **pskb,
+			 struct ip_conntrack *ct,
+			 enum ip_conntrack_info ctinfo,
+			 unsigned int matchoff,
+			 unsigned int matchlen,
+			 struct ip_conntrack_expect *exp)
 {
-	struct ip_conntrack *master = master_ct(ct);
-	struct ip_ct_amanda_expect *exp_amanda_info;
-	struct ip_nat_range range;
-	u_int32_t newip;
-
-	IP_NF_ASSERT(info);
-	IP_NF_ASSERT(master);
-	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
-
-	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC)
-		newip = master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
-	else
-		newip = master->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
-
-	/* We don't want to manip the per-protocol, just the IPs. */
-	range.flags = IP_NAT_RANGE_MAP_IPS;
-	range.min_ip = range.max_ip = newip;
-
-	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_DST) {
-		exp_amanda_info = &ct->master->help.exp_amanda_info;
-		range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
-		range.min = range.max
-			= ((union ip_conntrack_manip_proto)
-				{ .udp = { htons(exp_amanda_info->port) } });
-	}
-
-	return ip_nat_setup_info(ct, &range, hooknum);
-}
-
-static int amanda_data_fixup(struct ip_conntrack *ct,
-                             struct sk_buff **pskb,
-                             enum ip_conntrack_info ctinfo,
-                             struct ip_conntrack_expect *exp)
-{
-	struct ip_ct_amanda_expect *exp_amanda_info;
-	struct ip_conntrack_tuple t = exp->tuple;
 	char buffer[sizeof("65535")];
 	u_int16_t port;
+	unsigned int ret;
 
-	/* Alter conntrack's expectations. */
-	exp_amanda_info = &exp->help.exp_amanda_info;
-	t.dst.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
-	for (port = exp_amanda_info->port; port != 0; port++) {
-		t.dst.u.tcp.port = htons(port);
-		if (ip_conntrack_change_expect(exp, &t) == 0)
+	/* Connection comes from client. */
+	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
+	exp->dir = IP_CT_DIR_ORIGINAL;
+
+	/* When you see the packet, we need to NAT it the same as the
+	 * this one (ie. same IP: it will be TCP and master is UDP). */
+	exp->expectfn = ip_nat_follow_master;
+
+	/* Try to get same port: if not, try to change it. */
+	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
+		int err;
+		exp->tuple.dst.u.tcp.port = htons(port);
+		atomic_inc(&exp->use);
+		err = ip_conntrack_expect_related(exp, ct);
+		/* Success, or retransmit. */
+		if (!err || err == -EEXIST)
 			break;
 	}
-	if (port == 0)
-		return 0;
-
-	sprintf(buffer, "%u", port);
-	return ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
-	                                exp_amanda_info->offset,
-	                                exp_amanda_info->len,
-	                                buffer, strlen(buffer));
-}
 
-static unsigned int help(struct ip_conntrack *ct,
-                         struct ip_conntrack_expect *exp,
-                         struct ip_nat_info *info,
-                         enum ip_conntrack_info ctinfo,
-                         unsigned int hooknum,
-                         struct sk_buff **pskb)
-{
-	int dir = CTINFO2DIR(ctinfo);
-	int ret = NF_ACCEPT;
-
-	/* Only mangle things once: original direction in POST_ROUTING
-	   and reply direction on PRE_ROUTING. */
-	if (!((hooknum == NF_IP_POST_ROUTING && dir == IP_CT_DIR_ORIGINAL)
-	      || (hooknum == NF_IP_PRE_ROUTING && dir == IP_CT_DIR_REPLY)))
-		return NF_ACCEPT;
-
-	/* if this exectation has a "offset" the packet needs to be mangled */
-	if (exp->help.exp_amanda_info.offset != 0)
-		if (!amanda_data_fixup(ct, pskb, ctinfo, exp))
-			ret = NF_DROP;
-	exp->help.exp_amanda_info.offset = 0;
+	if (port == 0) {
+		ip_conntrack_expect_put(exp);
+		return NF_DROP;
+	}
 
+	sprintf(buffer, "%u", port);
+	ret = ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
+				       matchoff, matchlen,
+				       buffer, strlen(buffer));
+	if (ret != NF_ACCEPT)
+		ip_conntrack_unexpect_related(exp);
 	return ret;
 }
 
-static struct ip_nat_helper ip_nat_amanda_helper;
-
 static void __exit fini(void)
 {
-	ip_nat_helper_unregister(&ip_nat_amanda_helper);
+	ip_nat_amanda_hook = NULL;
+	/* Make sure noone calls it, meanwhile. */
+	synchronize_net();
 }
 
 static int __init init(void)
 {
-	struct ip_nat_helper *hlpr = &ip_nat_amanda_helper;
-
-	hlpr->tuple.dst.protonum = IPPROTO_UDP;
-	hlpr->tuple.src.u.udp.port = htons(10080);
-	hlpr->mask.src.u.udp.port = 0xFFFF;
-	hlpr->mask.dst.protonum = 0xFFFF;
-	hlpr->help = help;
-	hlpr->flags = 0;
-	hlpr->me = THIS_MODULE;
-	hlpr->expect = amanda_nat_expected;
-	hlpr->name = "amanda";
-
-	return ip_nat_helper_register(hlpr);
+	BUG_ON(ip_nat_amanda_hook);
+	ip_nat_amanda_hook = help;
+	return 0;
 }
 
-NEEDS_CONNTRACK(amanda);
 module_init(init);
 module_exit(fini);
Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_tftp.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_nat_tftp.c	2005-01-13 12:11:13.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_tftp.c	2005-01-17 15:24:41.989732744 +1100
@@ -38,168 +38,33 @@
 MODULE_DESCRIPTION("tftp NAT helper");
 MODULE_LICENSE("GPL");
 
-#define MAX_PORTS 8
-
-static int ports[MAX_PORTS];
-static int ports_c = 0;
-module_param_array(ports, int, &ports_c, 0400);
-MODULE_PARM_DESC(ports, "port numbers of tftp servers");
-
-#if 0
-#define DEBUGP(format, args...) printk("%s:%s:" format, \
-                                       __FILE__, __FUNCTION__ , ## args)
-#else
-#define DEBUGP(format, args...)
-#endif
-static unsigned int 
-tftp_nat_help(struct ip_conntrack *ct,
-	      struct ip_conntrack_expect *exp,
-	      struct ip_nat_info *info,
-	      enum ip_conntrack_info ctinfo,
-	      unsigned int hooknum,
-	      struct sk_buff **pskb)
+static unsigned int help(struct sk_buff **pskb,
+			 struct ip_conntrack *ct,
+			 enum ip_conntrack_info ctinfo,
+			 struct ip_conntrack_expect *exp)
 {
-	int dir = CTINFO2DIR(ctinfo);
-	struct tftphdr _tftph, *tfh;
-	struct ip_conntrack_tuple repl;
-
-	if (!((hooknum == NF_IP_POST_ROUTING && dir == IP_CT_DIR_ORIGINAL)
-	      || (hooknum == NF_IP_PRE_ROUTING && dir == IP_CT_DIR_REPLY))) 
-		return NF_ACCEPT;
-
-	if (!exp) {
-		DEBUGP("no conntrack expectation to modify\n");
-		return NF_ACCEPT;
-	}
-
-	tfh = skb_header_pointer(*pskb,
-				 (*pskb)->nh.iph->ihl*4+sizeof(struct udphdr),
-				 sizeof(_tftph), &_tftph);
-	if (tfh == NULL)
+	exp->saved_proto.udp.port = exp->tuple.dst.u.tcp.port;
+	exp->dir = IP_CT_DIR_REPLY;
+	exp->expectfn = ip_nat_follow_master;
+	if (ip_conntrack_expect_related(exp, ct) != 0) {
+		ip_conntrack_expect_put(exp);
 		return NF_DROP;
-
-	switch (ntohs(tfh->opcode)) {
-	/* RRQ and WRQ works the same way */
-	case TFTP_OPCODE_READ:
-	case TFTP_OPCODE_WRITE:
-		repl = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
-		DEBUGP("");
-		DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-		DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
-		DEBUGP("expecting: ");
-		DUMP_TUPLE(&repl);
-		DUMP_TUPLE(&exp->mask);
-		ip_conntrack_change_expect(exp, &repl);
-		break;
-	default:
-		DEBUGP("Unknown opcode\n");
-	}               
-
-	return NF_ACCEPT;
-}
-
-static unsigned int 
-tftp_nat_expected(struct sk_buff **pskb,
-		  unsigned int hooknum,
-		  struct ip_conntrack *ct, 
-		  struct ip_nat_info *info) 
-{
-	const struct ip_conntrack *master = ct->master->expectant;
-	const struct ip_conntrack_tuple *orig = 
-			&master->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
-	struct ip_nat_range range;
-#if 0
-	const struct ip_conntrack_tuple *repl =
-			&master->tuplehash[IP_CT_DIR_REPLY].tuple;
-	struct udphdr _udph, *uh;
-
-	uh = skb_header_pointer(*pskb,
-				(*pskb)->nh.iph->ihl*4,
-				sizeof(_udph), &_udph);
-	if (uh == NULL)
-		return NF_DROP;
-#endif
-
-	IP_NF_ASSERT(info);
-	IP_NF_ASSERT(master);
-	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
-
-	range.flags = IP_NAT_RANGE_MAP_IPS;
-
-	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC) {
-		range.min_ip = range.max_ip = orig->dst.ip; 
-		DEBUGP("orig: %u.%u.%u.%u:%u <-> %u.%u.%u.%u:%u "
-			"newsrc: %u.%u.%u.%u\n",
-                        NIPQUAD((*pskb)->nh.iph->saddr), ntohs(uh->source),
- 			NIPQUAD((*pskb)->nh.iph->daddr), ntohs(uh->dest),
-			NIPQUAD(orig->dst.ip));
-	} else {
-		range.min_ip = range.max_ip = orig->src.ip;
-		range.min.udp.port = range.max.udp.port = orig->src.u.udp.port;
-		range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
-
-		DEBUGP("orig: %u.%u.%u.%u:%u <-> %u.%u.%u.%u:%u "
-			"newdst: %u.%u.%u.%u:%u\n",
-                        NIPQUAD((*pskb)->nh.iph->saddr), ntohs(uh->source),
-                        NIPQUAD((*pskb)->nh.iph->daddr), ntohs(uh->dest),
-                        NIPQUAD(orig->src.ip), ntohs(orig->src.u.udp.port));
 	}
-
-	return ip_nat_setup_info(ct, &range, hooknum);
+	return NF_ACCEPT;
 }
 
-static struct ip_nat_helper tftp[MAX_PORTS];
-static char tftp_names[MAX_PORTS][10];
-
-static void fini(void)
+static void __exit fini(void)
 {
-	int i;
-
-	for (i = 0 ; i < ports_c; i++) {
-		DEBUGP("unregistering helper for port %d\n", ports[i]);
-		ip_nat_helper_unregister(&tftp[i]);
-	}
+	ip_nat_tftp_hook = NULL;
+	/* Make sure noone calls it, meanwhile. */
+	synchronize_net();
 }
 
 static int __init init(void)
 {
-	int i, ret = 0;
-	char *tmpname;
-
-	if (ports_c == 0)
-		ports[ports_c++] = TFTP_PORT;
-
-	for (i = 0; i < ports_c; i++) {
-		memset(&tftp[i], 0, sizeof(struct ip_nat_helper));
-
-		tftp[i].tuple.dst.protonum = IPPROTO_UDP;
-		tftp[i].tuple.src.u.udp.port = htons(ports[i]);
-		tftp[i].mask.dst.protonum = 0xFFFF;
-		tftp[i].mask.src.u.udp.port = 0xFFFF;
-		tftp[i].help = tftp_nat_help;
-		tftp[i].flags = 0;
-		tftp[i].me = THIS_MODULE;
-		tftp[i].expect = tftp_nat_expected;
-
-		tmpname = &tftp_names[i][0];
-		if (ports[i] == TFTP_PORT)
-			sprintf(tmpname, "tftp");
-		else
-			sprintf(tmpname, "tftp-%d", i);
-		tftp[i].name = tmpname;
-		
-		DEBUGP("ip_nat_tftp: registering for port %d: name %s\n",
-			ports[i], tftp[i].name);
-		ret = ip_nat_helper_register(&tftp[i]);
-
-		if (ret) {
-			printk("ip_nat_tftp: unable to register for port %d\n",
-				ports[i]);
-			fini();
-			return ret;
-		}
-	}
-	return ret;
+	BUG_ON(ip_nat_tftp_hook);
+	ip_nat_tftp_hook = help;
+	return 0;
 }
 
 module_init(init);
Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_irc.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_nat_irc.c	2005-01-13 12:11:13.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_irc.c	2005-01-17 15:24:41.989732744 +1100
@@ -1,5 +1,6 @@
 /* IRC extension for TCP NAT alteration.
  * (C) 2000-2001 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2004 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
  * based on a copy of RR's ip_nat_ftp.c
  *
  * ip_nat_irc.c,v 1.16 2001/12/06 07:42:10 laforge Exp
@@ -8,12 +9,6 @@
  *      modify it under the terms of the GNU General Public License
  *      as published by the Free Software Foundation; either version
  *      2 of the License, or (at your option) any later version.
- *
- *	Module load syntax:
- * 	insmod ip_nat_irc.o ports=port1,port2,...port<MAX_PORTS>
- *	
- * 	please give the ports of all IRC servers You wish to connect to.
- *	If You don't specify ports, the default will be port 6667
  */
 
 #include <linux/module.h>
@@ -35,66 +30,21 @@
 #define DEBUGP(format, args...)
 #endif
 
-#define MAX_PORTS 8
-static int ports[MAX_PORTS];
-static int ports_c;
-
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("IRC (DCC) NAT helper");
 MODULE_LICENSE("GPL");
-module_param_array(ports, int, &ports_c, 0400);
-MODULE_PARM_DESC(ports, "port numbers of IRC servers");
 
 /* FIXME: Time out? --RR */
 
-static unsigned int
-irc_nat_expected(struct sk_buff **pskb,
-		 unsigned int hooknum,
-		 struct ip_conntrack *ct,
-		 struct ip_nat_info *info)
-{
-	struct ip_nat_range range;
-	u_int32_t newdstip, newsrcip, newip;
-
-	struct ip_conntrack *master = master_ct(ct);
-
-	IP_NF_ASSERT(info);
-	IP_NF_ASSERT(master);
-
-	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
-
-	DEBUGP("nat_expected: We have a connection!\n");
-
-	newdstip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
-	newsrcip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
-	DEBUGP("nat_expected: DCC cmd. %u.%u.%u.%u->%u.%u.%u.%u\n",
-	       NIPQUAD(newsrcip), NIPQUAD(newdstip));
-
-	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC)
-		newip = newsrcip;
-	else
-		newip = newdstip;
-
-	DEBUGP("nat_expected: IP to %u.%u.%u.%u\n", NIPQUAD(newip));
-
-	/* We don't want to manip the per-protocol, just the IPs. */
-	range.flags = IP_NAT_RANGE_MAP_IPS;
-	range.min_ip = range.max_ip = newip;
-
-	return ip_nat_setup_info(ct, &range, hooknum);
-}
-
-static int irc_data_fixup(const struct ip_ct_irc_expect *exp_irc_info,
-			  struct ip_conntrack *ct,
-			  struct sk_buff **pskb,
-			  enum ip_conntrack_info ctinfo,
-			  struct ip_conntrack_expect *expect)
+static unsigned int help(struct sk_buff **pskb,
+			 struct ip_conntrack *ct,
+			 enum ip_conntrack_info ctinfo,
+			 unsigned int matchoff,
+			 unsigned int matchlen,
+			 struct ip_conntrack_expect *exp)
 {
-	u_int32_t newip;
-	struct ip_conntrack_tuple t;
-	struct iphdr *iph = (*pskb)->nh.iph;
-	struct tcphdr *tcph = (void *) iph + iph->ihl * 4;
 	u_int16_t port;
+	unsigned int ret;
 
 	/* "4294967296 65635 " */
 	char buffer[18];
@@ -103,21 +53,30 @@
 	       expect->seq, exp_irc_info->len,
 	       ntohl(tcph->seq));
 
-	newip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
-
-	/* Alter conntrack's expectations. */
-	t = expect->tuple;
-	t.dst.ip = newip;
-	for (port = exp_irc_info->port; port != 0; port++) {
-		t.dst.u.tcp.port = htons(port);
-		if (ip_conntrack_change_expect(expect, &t) == 0) {
-			DEBUGP("using port %d", port);
+	/* Reply comes from server. */
+	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
+	exp->dir = IP_CT_DIR_REPLY;
+
+	/* When you see the packet, we need to NAT it the same as the
+	 * this one. */
+	exp->expectfn = ip_nat_follow_master;
+
+	/* Try to get same port: if not, try to change it. */
+	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
+		int err;
+
+		exp->tuple.dst.u.tcp.port = htons(port);
+		atomic_inc(&exp->use);
+		err = ip_conntrack_expect_related(exp, ct);
+		/* Success, or retransmit. */
+		if (!err || err == -EEXIST)
 			break;
-		}
+	}
 
+	if (port == 0) {
+		ip_conntrack_expect_put(exp);
+		return NF_DROP;
 	}
-	if (port == 0)
-		return 0;
 
 	/*      strlen("\1DCC CHAT chat AAAAAAAA P\1\n")=27
 	 *      strlen("\1DCC SCHAT chat AAAAAAAA P\1\n")=28
@@ -132,131 +91,31 @@
 	 *              0x01, \n:  terminators
 	 */
 
-	sprintf(buffer, "%u %u", ntohl(newip), port);
+	sprintf(buffer, "%u %u", ntohl(exp->tuple.src.ip), port);
 	DEBUGP("ip_nat_irc: Inserting '%s' == %u.%u.%u.%u, port %u\n",
-	       buffer, NIPQUAD(newip), port);
-
-	return ip_nat_mangle_tcp_packet(pskb, ct, ctinfo, 
-					expect->seq - ntohl(tcph->seq),
-					exp_irc_info->len, buffer, 
-					strlen(buffer));
-}
-
-static unsigned int help(struct ip_conntrack *ct,
-			 struct ip_conntrack_expect *exp,
-			 struct ip_nat_info *info,
-			 enum ip_conntrack_info ctinfo,
-			 unsigned int hooknum, 
-			 struct sk_buff **pskb)
-{
-	struct iphdr *iph = (*pskb)->nh.iph;
-	struct tcphdr *tcph = (void *) iph + iph->ihl * 4;
-	unsigned int datalen;
-	int dir;
-	struct ip_ct_irc_expect *exp_irc_info;
-
-	if (!exp)
-		DEBUGP("ip_nat_irc: no exp!!");
-		
-	exp_irc_info = &exp->help.exp_irc_info;
-
-	/* Only mangle things once: original direction in POST_ROUTING
-	   and reply direction on PRE_ROUTING. */
-	dir = CTINFO2DIR(ctinfo);
-	if (!((hooknum == NF_IP_POST_ROUTING && dir == IP_CT_DIR_ORIGINAL)
-	      || (hooknum == NF_IP_PRE_ROUTING && dir == IP_CT_DIR_REPLY))) {
-		DEBUGP("nat_irc: Not touching dir %s at hook %s\n",
-		       dir == IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
-		       hooknum == NF_IP_POST_ROUTING ? "POSTROUTING"
-		       : hooknum == NF_IP_PRE_ROUTING ? "PREROUTING"
-		       : hooknum == NF_IP_LOCAL_OUT ? "OUTPUT" : "???");
-		return NF_ACCEPT;
-	}
-	DEBUGP("got beyond not touching\n");
+	       buffer, NIPQUAD(exp->tuple.src.ip), port);
 
-	datalen = (*pskb)->len - iph->ihl * 4 - tcph->doff * 4;
-	/* Check whether the whole IP/address pattern is carried in the payload */
-	if (between(exp->seq + exp_irc_info->len,
-		    ntohl(tcph->seq),
-		    ntohl(tcph->seq) + datalen)) {
-		if (!irc_data_fixup(exp_irc_info, ct, pskb, ctinfo, exp))
-			return NF_DROP;
-	} else { 
-		/* Half a match?  This means a partial retransmisison.
-		   It's a cracker being funky. */
-		if (net_ratelimit()) {
-			printk
-			    ("IRC_NAT: partial packet %u/%u in %u/%u\n",
-			     exp->seq, exp_irc_info->len,
-			     ntohl(tcph->seq),
-			     ntohl(tcph->seq) + datalen);
-		}
-		return NF_DROP;
-	}
-	return NF_ACCEPT;
+	ret = ip_nat_mangle_tcp_packet(pskb, ct, ctinfo, 
+				       matchoff, matchlen, buffer, 
+				       strlen(buffer));
+	if (ret != NF_ACCEPT)
+		ip_conntrack_unexpect_related(exp);
+	return ret;
 }
 
-static struct ip_nat_helper ip_nat_irc_helpers[MAX_PORTS];
-static char irc_names[MAX_PORTS][10];
-
-/* This function is intentionally _NOT_ defined as  __exit, because
- * it is needed by init() */
-static void fini(void)
+static void __exit fini(void)
 {
-	int i;
-
-	for (i = 0; i < ports_c; i++) {
-		DEBUGP("ip_nat_irc: unregistering helper for port %d\n",
-		       ports[i]);
-		ip_nat_helper_unregister(&ip_nat_irc_helpers[i]);
-	} 
+	ip_nat_irc_hook = NULL;
+	/* Make sure noone calls it, meanwhile. */
+	synchronize_net();
 }
 
 static int __init init(void)
 {
-	int ret = 0;
-	int i;
-	struct ip_nat_helper *hlpr;
-	char *tmpname;
-
-	if (ports_c == 0)
-		ports[ports_c++] = IRC_PORT;
-
-	for (i = 0; i < ports_c; i++) {
-		hlpr = &ip_nat_irc_helpers[i];
-		hlpr->tuple.dst.protonum = IPPROTO_TCP;
-		hlpr->tuple.src.u.tcp.port = htons(ports[i]);
-		hlpr->mask.src.u.tcp.port = 0xFFFF;
-		hlpr->mask.dst.protonum = 0xFFFF;
-		hlpr->help = help;
-		hlpr->flags = 0;
-		hlpr->me = THIS_MODULE;
-		hlpr->expect = irc_nat_expected;
-
-		tmpname = &irc_names[i][0];
-		if (ports[i] == IRC_PORT)
-			sprintf(tmpname, "irc");
-		else
-			sprintf(tmpname, "irc-%d", i);
-		hlpr->name = tmpname;
-
-		DEBUGP
-		    ("ip_nat_irc: Trying to register helper for port %d: name %s\n",
-		     ports[i], hlpr->name);
-		ret = ip_nat_helper_register(hlpr);
-
-		if (ret) {
-			printk
-			    ("ip_nat_irc: error registering helper for port %d\n",
-			     ports[i]);
-			fini();
-			return 1;
-		}
-	}
-	return ret;
+	BUG_ON(ip_nat_irc_hook);
+	ip_nat_irc_hook = help;
+	return 0;
 }
 
-NEEDS_CONNTRACK(irc);
-
 module_init(init);
 module_exit(fini);
Index: linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_tftp.h
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_tftp.h	2005-01-06 12:02:22.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_tftp.h	2005-01-17 15:24:42.044724384 +1100
@@ -13,4 +13,9 @@
 #define TFTP_OPCODE_ACK		4
 #define TFTP_OPCODE_ERROR	5
 
+unsigned int (*ip_nat_tftp_hook)(struct sk_buff **pskb,
+				 struct ip_conntrack *ct,
+				 enum ip_conntrack_info ctinfo,
+				 struct ip_conntrack_expect *exp);
+
 #endif /* _IP_CT_TFTP */
Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_conntrack_irc.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_irc.c	2005-01-06 12:02:22.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_conntrack_irc.c	2005-01-17 15:24:41.989732744 +1100
@@ -43,6 +43,14 @@
 static char irc_buffer[65536];
 static DECLARE_LOCK(irc_buffer_lock);
 
+unsigned int (*ip_nat_irc_hook)(struct sk_buff **pskb,
+				struct ip_conntrack *ct,
+				enum ip_conntrack_info ctinfo,
+				unsigned int matchoff,
+				unsigned int matchlen,
+				struct ip_conntrack_expect *exp);
+EXPORT_SYMBOL_GPL(ip_nat_irc_hook);
+
 MODULE_AUTHOR("Harald Welte <davem@davemloft.net>");
 MODULE_DESCRIPTION("IRC (DCC) connection tracking helper");
 MODULE_LICENSE("GPL");
@@ -98,7 +106,7 @@
 	return 0;
 }
 
-static int help(struct sk_buff *skb,
+static int help(struct sk_buff **pskb,
 		struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
 {
 	unsigned int dataoff;
@@ -106,11 +114,10 @@
 	char *data, *data_limit, *ib_ptr;
 	int dir = CTINFO2DIR(ctinfo);
 	struct ip_conntrack_expect *exp;
-	struct ip_ct_irc_expect *exp_irc_info = NULL;
-
+	u32 seq;
 	u_int32_t dcc_ip;
 	u_int16_t dcc_port;
-	int i;
+	int i, ret = NF_ACCEPT;
 	char *addr_beg_p, *addr_end_p;
 
 	DEBUGP("entered\n");
@@ -127,23 +134,23 @@
 	}
 
 	/* Not a full tcp header? */
-	th = skb_header_pointer(skb, skb->nh.iph->ihl*4,
+	th = skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl*4,
 				sizeof(_tcph), &_tcph);
 	if (th == NULL)
 		return NF_ACCEPT;
 
 	/* No data? */
-	dataoff = skb->nh.iph->ihl*4 + th->doff*4;
-	if (dataoff >= skb->len)
+	dataoff = (*pskb)->nh.iph->ihl*4 + th->doff*4;
+	if (dataoff >= (*pskb)->len)
 		return NF_ACCEPT;
 
 	LOCK_BH(&irc_buffer_lock);
-	ib_ptr = skb_header_pointer(skb, dataoff,
-				    skb->len - dataoff, irc_buffer);
+	ib_ptr = skb_header_pointer(*pskb, dataoff,
+				    (*pskb)->len - dataoff, irc_buffer);
 	BUG_ON(ib_ptr == NULL);
 
 	data = ib_ptr;
-	data_limit = ib_ptr + skb->len - dataoff;
+	data_limit = ib_ptr + (*pskb)->len - dataoff;
 
 	/* strlen("\1DCC SENT t AAAAAAAA P\1\n")=24
 	 * 5+MINMATCHLEN+strlen("t AAAAAAAA P\1\n")=14 */
@@ -195,19 +202,15 @@
 			}
 
 			exp = ip_conntrack_expect_alloc();
-			if (exp == NULL)
+			if (exp == NULL) {
+				ret = NF_DROP;
 				goto out;
-
-			exp_irc_info = &exp->help.exp_irc_info;
+			}
 
 			/* save position of address in dcc string,
 			 * necessary for NAT */
 			DEBUGP("tcph->seq = %u\n", th->seq);
-			exp->seq = ntohl(th->seq) + (addr_beg_p - ib_ptr);
-			exp_irc_info->len = (addr_end_p - addr_beg_p);
-			exp_irc_info->port = dcc_port;
-			DEBUGP("wrote info seq=%u (ofs=%u), len=%d\n",
-				exp->seq, (addr_end_p - _data), exp_irc_info->len);
+			seq = ntohl(th->seq) + (addr_beg_p - ib_ptr);
 
 			exp->tuple = ((struct ip_conntrack_tuple)
 				{ { 0, { 0 } },
@@ -216,24 +219,21 @@
 			exp->mask = ((struct ip_conntrack_tuple)
 				{ { 0, { 0 } },
 				  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFFFF }});
-
 			exp->expectfn = NULL;
-
-			DEBUGP("expect_related %u.%u.%u.%u:%u-%u.%u.%u.%u:%u\n",
-				NIPQUAD(exp->tuple.src.ip),
-				ntohs(exp->tuple.src.u.tcp.port),
-				NIPQUAD(exp->tuple.dst.ip),
-				ntohs(exp->tuple.dst.u.tcp.port));
-
-			ip_conntrack_expect_related(exp, ct);
-
+			if (ip_nat_irc_hook)
+				ret = ip_nat_irc_hook(pskb, ct, ctinfo, 
+						      addr_beg_p - ib_ptr,
+						      addr_end_p - addr_beg_p,
+						      exp);
+			else if (ip_conntrack_expect_related(exp, ct) != 0)
+				ret = NF_DROP;
 			goto out;
 		} /* for .. NUM_DCCPROTO */
 	} /* while data < ... */
 
  out:
 	UNLOCK_BH(&irc_buffer_lock);
-	return NF_ACCEPT;
+	return ret;
 }
 
 static struct ip_conntrack_helper irc_helpers[MAX_PORTS];
@@ -268,7 +268,6 @@
 		hlpr->mask.dst.protonum = 0xFFFF;
 		hlpr->max_expected = max_dcc_channels;
 		hlpr->timeout = dcc_timeout;
-		hlpr->flags = IP_CT_HELPER_F_REUSE_EXPECT;
 		hlpr->me = ip_conntrack_irc;
 		hlpr->help = help;
 
@@ -305,7 +304,5 @@
 	}
 }
 
-PROVIDES_CONNTRACK(irc);
-
 module_init(init);
 module_exit(fini);
Index: linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_irc.h
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_irc.h	2005-01-06 12:02:22.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_irc.h	2005-01-17 15:24:42.044724384 +1100
@@ -14,24 +14,17 @@
 #ifndef _IP_CONNTRACK_IRC_H
 #define _IP_CONNTRACK_IRC_H
 
-/* We record seq number and length of irc ip/port text here: all in
-   host order. */
-
-/* This structure is per expected connection */
-struct ip_ct_irc_expect
-{
-	/* length of IP address */
-	u_int32_t len;
-	/* Port that was to be used */
-	u_int16_t port;
-};
-
 /* This structure exists only once per master */
 struct ip_ct_irc_master {
 };
 
-
 #ifdef __KERNEL__
+extern unsigned int (*ip_nat_irc_hook)(struct sk_buff **pskb,
+				       struct ip_conntrack *ct,
+				       enum ip_conntrack_info ctinfo,
+				       unsigned int matchoff,
+				       unsigned int matchlen,
+				       struct ip_conntrack_expect *exp);
 
 #define IRC_PORT	6667
 
Index: linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_amanda.h
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_amanda.h	2005-01-06 12:02:22.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_amanda.h	2005-01-17 15:24:42.044724384 +1100
@@ -2,11 +2,11 @@
 #define _IP_CONNTRACK_AMANDA_H
 /* AMANDA tracking. */
 
-struct ip_ct_amanda_expect
-{
-	u_int16_t port;		/* port number of this expectation */
-	u_int16_t offset;	/* offset of port in ctrl packet */
-	u_int16_t len;		/* length of the port number string */
-};
-
+struct ip_conntrack_expect;
+extern unsigned int (*ip_nat_amanda_hook)(struct sk_buff **pskb,
+					  struct ip_conntrack *ct,
+					  enum ip_conntrack_info ctinfo,
+					  unsigned int matchoff,
+					  unsigned int matchlen,
+					  struct ip_conntrack_expect *exp);
 #endif /* _IP_CONNTRACK_AMANDA_H */
