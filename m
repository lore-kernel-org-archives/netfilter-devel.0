From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng] port ip_conntrack_h323 to the linux 2.6.11-rc3 API
Date: Fri, 11 Feb 2005 23:38:58 +0100
Message-ID: <20050211223858.GA27306@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
To: netfilter-devel@lists.netfilter.org, kadlec@blackhole.kfki.hu
Content-Disposition: inline
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


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

this patch ports the H.323 conntrack module to the new linux
2.6.11-rc3 API. I havn't tested that thoroughly; my nfsim tests
succeed (these will be published later), and it compiles with the real
kernel.

This is work in progress. I have already begun writing a "real" parser
for H.225 which will replace the "brute force" algorithm in the
current module. Expect more patches soon.

Max


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="h323-port_to_2.6.11.patch"

Fri Feb 11 22:51:14 CET 2005  max@duempel.org
  * port to linux 2.6.11
diff -rN -u h323-6-old/h323-conntrack-nat/linux-2.6/include/linux/netfilter_ipv4/ip_conntrack_h323.h h323-6-new/h323-conntrack-nat/linux-2.6/include/linux/netfilter_ipv4/ip_conntrack_h323.h
--- h323-6-old/h323-conntrack-nat/linux-2.6/include/linux/netfilter_ipv4/ip_conntrack_h323.h	2005-02-11 22:51:35.434033024 +0100
+++ h323-6-new/h323-conntrack-nat/linux-2.6/include/linux/netfilter_ipv4/ip_conntrack_h323.h	2005-02-11 22:49:31.000000000 +0100
@@ -3,29 +3,35 @@
 /* H.323 connection tracking. */
 
 #ifdef __KERNEL__
-/* Protects H.323 related data */
-#include <linux/netfilter_ipv4/lockhelp.h>
-DECLARE_LOCK_EXTERN(ip_h323_lock);
-#endif
 
 /* Default H.225 port */
 #define H225_PORT	1720
 
-/* This structure is per expected connection */
-struct ip_ct_h225_expect {
-	u_int16_t port;			/* Port of the H.225 helper/RTCP/RTP channel */
-	enum ip_conntrack_dir dir;	/* Direction of the original connection */
-	unsigned int offset;		/* offset of the address in the payload */
-};
-
 /* This structure exists only once per master */
 struct ip_ct_h225_master {
-	int is_h225;				/* H.225 or H.245 connection */
-#ifdef CONFIG_IP_NF_NAT_NEEDED
-	enum ip_conntrack_dir dir;		/* Direction of the original connection */
-	u_int32_t seq[IP_CT_DIR_MAX];		/* Exceptional packet mangling for signal addressess... */
-	unsigned int offset[IP_CT_DIR_MAX];	/* ...and the offset of the addresses in the payload */
-#endif
+	int dummy;
 };
 
+struct ip_conntrack_expect;
+struct ip_conntrack;
+
+extern int (*ip_nat_h245_hook)(struct sk_buff **pskb,
+			       enum ip_conntrack_info ctinfo,
+			       unsigned int offset,
+			       struct ip_conntrack_expect *exp);
+
+extern int (*ip_nat_h225_hook)(struct sk_buff **pskb,
+			       enum ip_conntrack_info ctinfo,
+			       unsigned int offset,
+			       struct ip_conntrack_expect *exp);
+
+extern void (*ip_nat_h225_signal_hook)(struct sk_buff **pskb,
+				       struct ip_conntrack *ct,
+				       enum ip_conntrack_info ctinfo,
+				       unsigned int offset,
+				       int dir,
+				       int orig_dir);
+
+#endif /* __KERNEL__ */
+
 #endif /* _IP_CONNTRACK_H323_H */
diff -rN -u h323-6-old/h323-conntrack-nat/linux-2.6/include/linux/netfilter_ipv4/ip_conntrack.h.ladd_3 h323-6-new/h323-conntrack-nat/linux-2.6/include/linux/netfilter_ipv4/ip_conntrack.h.ladd_3
--- h323-6-old/h323-conntrack-nat/linux-2.6/include/linux/netfilter_ipv4/ip_conntrack.h.ladd_3	2005-02-11 22:51:35.433033176 +0100
+++ h323-6-new/h323-conntrack-nat/linux-2.6/include/linux/netfilter_ipv4/ip_conntrack.h.ladd_3	1970-01-01 01:00:00.000000000 +0100
@@ -1,2 +0,0 @@
-	/* insert conntrack helper private data (expect) here */
-	struct ip_ct_h225_expect exp_h225_info;
diff -rN -u h323-6-old/h323-conntrack-nat/linux-2.6/net/ipv4/netfilter/ip_conntrack_h323.c h323-6-new/h323-conntrack-nat/linux-2.6/net/ipv4/netfilter/ip_conntrack_h323.c
--- h323-6-old/h323-conntrack-nat/linux-2.6/net/ipv4/netfilter/ip_conntrack_h323.c	2005-02-11 22:51:35.441031960 +0100
+++ h323-6-new/h323-conntrack-nat/linux-2.6/net/ipv4/netfilter/ip_conntrack_h323.c	2005-02-11 22:49:51.000000000 +0100
@@ -29,11 +29,31 @@
 
 /* This is slow, but it's simple. --RR */
 static char h323_buffer[65536];
-static DECLARE_LOCK(h323_buffer_lock);
 
-DECLARE_LOCK(ip_h323_lock);
+static DECLARE_LOCK(ip_h323_lock);
+
 struct module *ip_conntrack_h323 = THIS_MODULE;
 
+int (*ip_nat_h245_hook)(struct sk_buff **pskb,
+			enum ip_conntrack_info ctinfo,
+			unsigned int offset,
+			struct ip_conntrack_expect *exp);
+EXPORT_SYMBOL_GPL(ip_nat_h245_hook);
+
+int (*ip_nat_h225_hook)(struct sk_buff **pskb,
+			enum ip_conntrack_info ctinfo,
+			unsigned int offset,
+			struct ip_conntrack_expect *exp);
+EXPORT_SYMBOL_GPL(ip_nat_h225_hook);
+
+void (*ip_nat_h225_signal_hook)(struct sk_buff **pskb,
+				struct ip_conntrack *ct,
+				enum ip_conntrack_info ctinfo,
+				unsigned int offset,
+				int dir,
+				int orig_dir);
+EXPORT_SYMBOL_GPL(ip_nat_h225_signal_hook);
+
 #if 0
 #define DEBUGP printk
 #else
@@ -41,19 +61,16 @@
 #endif
 
 /* FIXME: This should be in userspace.  Later. */
-static int h245_help(struct sk_buff *skb,
+static int h245_help(struct sk_buff **pskb,
 		     struct ip_conntrack *ct,
 		     enum ip_conntrack_info ctinfo)
 {
-	struct iphdr *iph = skb->nh.iph;
 	struct tcphdr _tcph, *tcph;
 	unsigned char *data;
 	unsigned char *data_limit;
 	unsigned dataoff, datalen;
 	int dir = CTINFO2DIR(ctinfo);
-	struct ip_ct_h225_master *info = &ct->help.ct_h225_info;
 	struct ip_conntrack_expect *exp;
-	struct ip_ct_h225_expect *exp_info;
 	u_int16_t data_port;
 	u_int32_t data_ip;
 	unsigned int i;
@@ -66,25 +83,25 @@
 		return NF_ACCEPT;
 	}
 
-	tcph = skb_header_pointer(skb, skb->nh.iph->ihl*4,
+	tcph = skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl*4,
 				  sizeof(_tcph), &_tcph);
 	if (tcph == NULL)
 		return NF_ACCEPT;
 
 	DEBUGP("ct_h245_help: help entered %u.%u.%u.%u:%u->%u.%u.%u.%u:%u\n",
-		NIPQUAD(iph->saddr), ntohs(tcph->source),
-		NIPQUAD(iph->daddr), ntohs(tcph->dest));
+		NIPQUAD((*pskb)->nh.iph->saddr), ntohs(tcph->source),
+		NIPQUAD((*pskb)->nh.iph->daddr), ntohs(tcph->dest));
 
-	dataoff = skb->nh.iph->ihl*4 + tcph->doff*4;
+	dataoff = (*pskb)->nh.iph->ihl*4 + tcph->doff*4;
 	/* No data? */
-	if (dataoff >= skb->len) {
-		DEBUGP("ct_h245_help: skblen = %u\n", skb->len);
+	if (dataoff >= (*pskb)->len) {
+		DEBUGP("ct_h245_help: skblen = %u\n", (*pskb)->len);
 		return NF_ACCEPT;
 	}
-	datalen = skb->len - dataoff;
+	datalen = (*pskb)->len - dataoff;
 
-	LOCK_BH(&h323_buffer_lock);
-	data = skb_header_pointer(skb, dataoff,
+	LOCK_BH(&ip_h323_lock);
+	data = skb_header_pointer((*pskb), dataoff,
 				  datalen, h323_buffer);
 	BUG_ON(data == NULL);
 
@@ -93,13 +110,13 @@
 	          ipadrr port */
 	for (i = 0; data <= data_limit; data++, i++) {
 		data_ip = *((u_int32_t *)data);
-		if (data_ip == iph->saddr) {
+		if (data_ip == ct->tuplehash[dir].tuple.src.ip) {
 			data_port = *((u_int16_t *)(data + 4));
 
 			/* update the H.225 info */
 			DEBUGP("ct_h245_help: new RTCP/RTP requested %u.%u.%u.%u:->%u.%u.%u.%u:%u\n",
 				NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
-				NIPQUAD(iph->saddr), ntohs(data_port));
+				NIPQUAD((*pskb)->nh.iph->saddr), ntohs(data_port));
 
 			exp = ip_conntrack_expect_alloc();
 			if (exp == NULL) {
@@ -107,16 +124,6 @@
 				goto out;
 			}
 
-			exp_info = &exp->help.exp_h225_info;
-
-			LOCK_BH(&ip_h323_lock);
-			info->is_h225 = H225_PORT + 1;
-			exp_info->port = data_port;
-			exp_info->dir = dir;
-			exp_info->offset = i;
-
-			exp->seq = ntohl(tcph->seq) + i;
-
 			exp->tuple = ((struct ip_conntrack_tuple)
 				{ { ct->tuplehash[!dir].tuple.src.ip,
 				    { 0 } },
@@ -125,59 +132,63 @@
 				    IPPROTO_UDP }});
 			exp->mask = ((struct ip_conntrack_tuple)
 				{ { 0xFFFFFFFF, { 0 } },
-				  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFFFF }});
+				  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
 
 			exp->expectfn = NULL;
 
-			/* Ignore failure; should only happen with NAT */
-			ip_conntrack_expect_related(exp, ct);
+			if (ip_nat_h245_hook != NULL) {
+				ret = ip_nat_h245_hook(pskb, ctinfo, i,
+						       exp);
+			} else {
+				/* Can't expect this?  Best to drop packet now. */
+				if (ip_conntrack_expect_related(exp) != 0) {
+					ip_conntrack_expect_free(exp);
+					ret = NF_DROP;
+				} else
+					ret = NF_ACCEPT;
+			}
 
-			UNLOCK_BH(&ip_h323_lock);
+			break;
 		}
 	}
 
 	ret = NF_ACCEPT;
  out:
-	UNLOCK_BH(&h323_buffer_lock);
+	UNLOCK_BH(&ip_h323_lock);
 	return ret;
 }
 
 /* H.245 helper is not registered! */
 static struct ip_conntrack_helper h245 = {
 	.name = "H.245",
-	.flags = IP_CT_HELPER_F_REUSE_EXPECT,
 	.max_expected = 8,
 	.timeout = 240,
 	.tuple = { .dst = { .protonum = IPPROTO_TCP } },
 	.mask = { .src = { .u = { 0xFFFF } },
-		  .dst = { .protonum = 0xFFFF } },
+		  .dst = { .protonum = 0xFF } },
 	.help = h245_help
 };
 
-static int h225_expect(struct ip_conntrack *ct)
+static void h225_expect(struct ip_conntrack *new,
+			struct ip_conntrack_expect *this)
 {
 	WRITE_LOCK(&ip_conntrack_lock);
-	ct->helper = &h245;
-	DEBUGP("h225_expect: helper for %p added\n", ct);
+	new->helper = &h245;
+	DEBUGP("h225_expect: helper for %p added\n", new);
 	WRITE_UNLOCK(&ip_conntrack_lock);
-
-	return NF_ACCEPT;	/* unused */
 }
 
 /* FIXME: This should be in userspace.  Later. */
-static int h225_help(struct sk_buff *skb,
+static int h225_help(struct sk_buff **pskb,
 		     struct ip_conntrack *ct,
 		     enum ip_conntrack_info ctinfo)
 {
-	struct iphdr *iph = skb->nh.iph;
 	struct tcphdr _tcph, *tcph;
 	unsigned char *data;
 	unsigned char *data_limit;
 	unsigned dataoff, datalen;
 	int dir = CTINFO2DIR(ctinfo);
-	struct ip_ct_h225_master *info = &ct->help.ct_h225_info;
 	struct ip_conntrack_expect *exp;
-	struct ip_ct_h225_expect *exp_info;
 	u_int16_t data_port;
 	u_int32_t data_ip;
 	unsigned int i;
@@ -190,25 +201,25 @@
 		return NF_ACCEPT;
 	}
 
-	tcph = skb_header_pointer(skb, skb->nh.iph->ihl*4,
+	tcph = skb_header_pointer((*pskb), (*pskb)->nh.iph->ihl*4,
 				  sizeof(_tcph), &_tcph);
 	if (tcph == NULL)
 		return NF_ACCEPT;
 
 	DEBUGP("ct_h225_help: help entered %u.%u.%u.%u:%u->%u.%u.%u.%u:%u\n",
-		NIPQUAD(iph->saddr), ntohs(tcph->source),
-		NIPQUAD(iph->daddr), ntohs(tcph->dest));
+		NIPQUAD((*pskb)->nh.iph->saddr), ntohs(tcph->source),
+		NIPQUAD((*pskb)->nh.iph->daddr), ntohs(tcph->dest));
 
-	dataoff = skb->nh.iph->ihl*4 + tcph->doff*4;
+	dataoff = (*pskb)->nh.iph->ihl*4 + tcph->doff*4;
 	/* No data? */
-	if (dataoff >= skb->len) {
-		DEBUGP("ct_h225_help: skblen = %u\n", skb->len);
+	if (dataoff >= (*pskb)->len) {
+		DEBUGP("ct_h225_help: skblen = %u\n", (*pskb)->len);
 		return NF_ACCEPT;
 	}
-	datalen = skb->len - dataoff;
+	datalen = (*pskb)->len - dataoff;
 
-	LOCK_BH(&h323_buffer_lock);
-	data = skb_header_pointer(skb, dataoff,
+	LOCK_BH(&ip_h323_lock);
+	data = skb_header_pointer((*pskb), dataoff,
 				  datalen, h323_buffer);
 	BUG_ON(data == NULL);
 
@@ -217,21 +228,17 @@
 	          ipadrr port */
 	for (i = 0; data <= data_limit; data++, i++) {
 		data_ip = *((u_int32_t *)data);
-		if (data_ip == iph->saddr) {
+		if (data_ip == ct->tuplehash[dir].tuple.src.ip) {
 			data_port = *((u_int16_t *)(data + 4));
-			if (data_port == tcph->source) {
+			if (data_port == ct->tuplehash[dir].tuple.src.u.tcp.port) {
 				/* Signal address */
 				DEBUGP("ct_h225_help: sourceCallSignalAddress from %u.%u.%u.%u\n",
-					NIPQUAD(iph->saddr));
+					NIPQUAD((*pskb)->nh.iph->saddr));
 				/* Update the H.225 info so that NAT can mangle the address/port
 				   even when we have no expected connection! */
-#ifdef CONFIG_IP_NF_NAT_NEEDED
-				LOCK_BH(&ip_h323_lock);
-				info->dir = dir;
-				info->seq[IP_CT_DIR_ORIGINAL] = ntohl(tcph->seq) + i;
-				info->offset[IP_CT_DIR_ORIGINAL] = i;
-				UNLOCK_BH(&ip_h323_lock);
-#endif
+				if (ip_nat_h225_signal_hook != NULL)
+					ip_nat_h225_signal_hook(pskb, ct, ctinfo,
+								i, IP_CT_DIR_ORIGINAL, dir);
 			} else {
 				/* update the H.225 info */
 				exp = ip_conntrack_expect_alloc();
@@ -240,16 +247,6 @@
 					goto out;
 				}
 
-				exp_info = &exp->help.exp_h225_info;
-
-				LOCK_BH(&ip_h323_lock);
-				info->is_h225 = H225_PORT;
-				exp_info->port = data_port;
-				exp_info->dir = dir;
-				exp_info->offset = i;
-
-				exp->seq = ntohl(tcph->seq) + i;
-
 				exp->tuple = ((struct ip_conntrack_tuple)
 					{ { ct->tuplehash[!dir].tuple.src.ip,
 					    { 0 } },
@@ -258,54 +255,55 @@
 					    IPPROTO_TCP }});
 				exp->mask = ((struct ip_conntrack_tuple)
 					{ { 0xFFFFFFFF, { 0 } },
-					  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFFFF }});
+					  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
 
 				exp->expectfn = h225_expect;
+				exp->master = ct;
 
-				/* Ignore failure */
-				ip_conntrack_expect_related(exp, ct);
-
-				DEBUGP("ct_h225_help: new H.245 requested %u.%u.%u.%u->%u.%u.%u.%u:%u\n",
-					NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
-					NIPQUAD(iph->saddr), ntohs(data_port));
-
-				UNLOCK_BH(&ip_h323_lock);
+				if (ip_nat_h225_hook != NULL) {
+					ret = ip_nat_h225_hook(pskb, ctinfo, i,
+							       exp);
+				} else {
+					/* Can't expect this?  Best to drop packet now. */
+					if (ip_conntrack_expect_related(exp) != 0) {
+						ip_conntrack_expect_free(exp);
+						ret = NF_DROP;
+					} else
+						ret = NF_ACCEPT;
+				}
 			}
-#ifdef CONFIG_IP_NF_NAT_NEEDED
-		} else if (data_ip == iph->daddr) {
+
+			break;
+		} else if (data_ip == ct->tuplehash[dir].tuple.dst.ip) {
 			data_port = *((u_int16_t *)(data + 4));
-			if (data_port == tcph->dest) {
+			if (data_port == ct->tuplehash[dir].tuple.dst.u.tcp.port) {
 				/* Signal address */
 				DEBUGP("ct_h225_help: destCallSignalAddress %u.%u.%u.%u\n",
-					NIPQUAD(iph->daddr));
+					NIPQUAD((*pskb)->nh.iph->daddr));
 				/* Update the H.225 info so that NAT can mangle the address/port
 				   even when we have no expected connection! */
-				LOCK_BH(&ip_h323_lock);
-				info->dir = dir;
-				info->seq[IP_CT_DIR_REPLY] = ntohl(tcph->seq) + i;
-				info->offset[IP_CT_DIR_REPLY] = i;
-				UNLOCK_BH(&ip_h323_lock);
+				if (ip_nat_h225_signal_hook != NULL)
+					ip_nat_h225_signal_hook(pskb, ct, ctinfo,
+								i, IP_CT_DIR_REPLY, dir);
 			}
-#endif
 		}
 	}
 
 	ret = NF_ACCEPT;
  out:
-	UNLOCK_BH(&h323_buffer_lock);
+	UNLOCK_BH(&ip_h323_lock);
 	return ret;
 }
 
 static struct ip_conntrack_helper h225 = {
 	.name = "H.225",
-	.flags = IP_CT_HELPER_F_REUSE_EXPECT,
 	.me = THIS_MODULE,
 	.max_expected = 2,
 	.timeout = 240,
 	.tuple = { .src = { .u = { __constant_htons(H225_PORT) } },
 		   .dst = { .protonum = IPPROTO_TCP } },
 	.mask = { .src = { .u = { 0xFFFF } },
-		  .dst = { .protonum = 0xFFFF } },
+		  .dst = { .protonum = 0xFF } },
 	.help = h225_help
 };
 
@@ -320,9 +318,5 @@
 	ip_conntrack_helper_unregister(&h225);
 }
 
-EXPORT_SYMBOL(ip_h323_lock);
-
-PROVIDES_CONNTRACK(h225);
-PROVIDES_CONNTRACK(h245);
 module_init(init);
 module_exit(fini);
diff -rN -u h323-6-old/h323-conntrack-nat/linux-2.6/net/ipv4/netfilter/ip_nat_h323.c h323-6-new/h323-conntrack-nat/linux-2.6/net/ipv4/netfilter/ip_nat_h323.c
--- h323-6-old/h323-conntrack-nat/linux-2.6/net/ipv4/netfilter/ip_nat_h323.c	2005-02-11 22:51:35.438032416 +0100
+++ h323-6-new/h323-conntrack-nat/linux-2.6/net/ipv4/netfilter/ip_nat_h323.c	2005-02-11 22:49:31.000000000 +0100
@@ -28,7 +28,6 @@
 MODULE_DESCRIPTION("H.323 'brute force' connection tracking module");
 MODULE_LICENSE("GPL");
 
-DECLARE_LOCK_EXTERN(ip_h323_lock);
 struct module *ip_nat_h323 = THIS_MODULE;
 
 #if 0
@@ -37,368 +36,101 @@
 #define DEBUGP(format, args...)
 #endif
 
-/* FIXME: Time out? --RR */
-
-static unsigned int
-h225_nat_expected(struct sk_buff **pskb,
-		  unsigned int hooknum,
-		  struct ip_conntrack *ct,
-		  struct ip_nat_info *info);
-
-static unsigned int h225_nat_help(struct ip_conntrack *ct,
-				  struct ip_conntrack_expect *exp,
-				  struct ip_nat_info *info,
-				  enum ip_conntrack_info ctinfo,
-				  unsigned int hooknum,
-				  struct sk_buff **pskb);
-
-static struct ip_nat_helper h245 = {
-	.list = { NULL, NULL },
-	.name = "H.245",
-	.flags = 0,
-	.me = THIS_MODULE,
-	.tuple = { { 0, { 0 } },
-		   { 0, { 0 }, IPPROTO_TCP } },
-	.mask = { { 0, { 0xFFFF } },
-		  { 0, { 0 }, 0xFFFF } },
-	.help = h225_nat_help,
-	.expect = h225_nat_expected
-};
-
-static unsigned int
-h225_nat_expected(struct sk_buff **pskb,
-		  unsigned int hooknum,
-		  struct ip_conntrack *ct,
-		  struct ip_nat_info *info)
-{
-	struct ip_nat_range range;
-	u_int32_t newdstip, newsrcip, newip;
-	u_int16_t port;
-	struct ip_ct_h225_expect *exp_info;
-	struct ip_ct_h225_master *master_info;
-	struct ip_conntrack *master = master_ct(ct);
-	unsigned int is_h225, ret;
-
-	IP_NF_ASSERT(info);
-	IP_NF_ASSERT(master);
-
-	IP_NF_ASSERT(!(info->initialized & (1<<HOOK2MANIP(hooknum))));
-
-	DEBUGP("h225_nat_expected: We have a connection!\n");
-	master_info = &ct->master->expectant->help.ct_h225_info;
-	exp_info = &ct->master->help.exp_h225_info;
-
-	LOCK_BH(&ip_h323_lock);
-
-	DEBUGP("master: ");
-	DUMP_TUPLE(&master->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-	DUMP_TUPLE(&master->tuplehash[IP_CT_DIR_REPLY].tuple);
-	DEBUGP("conntrack: ");
-	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-	if (exp_info->dir == IP_CT_DIR_ORIGINAL) {
-		/* Make connection go to the client. */
-		newdstip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
-		newsrcip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
-		DEBUGP("h225_nat_expected: %u.%u.%u.%u->%u.%u.%u.%u (to client)\n",
-		       NIPQUAD(newsrcip), NIPQUAD(newdstip));
-	} else {
-		/* Make the connection go to the server */
-		newdstip = master->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
-		newsrcip = master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
-		DEBUGP("h225_nat_expected: %u.%u.%u.%u->%u.%u.%u.%u (to server)\n",
-		       NIPQUAD(newsrcip), NIPQUAD(newdstip));
-	}
-	port = exp_info->port;
-	is_h225 = master_info->is_h225 == H225_PORT;
-	UNLOCK_BH(&ip_h323_lock);
-
-	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC)
-		newip = newsrcip;
-	else
-		newip = newdstip;
-
-	DEBUGP("h225_nat_expected: IP to %u.%u.%u.%u\n", NIPQUAD(newip));
-
-	/* We don't want to manip the per-protocol, just the IPs... */
-	range.flags = IP_NAT_RANGE_MAP_IPS;
-	range.min_ip = range.max_ip = newip;
-
-	/* ... unless we're doing a MANIP_DST, in which case, make
-	   sure we map to the correct port */
-	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_DST) {
-		range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
-		range.min = range.max
-			= ((union ip_conntrack_manip_proto)
-				{ .tcp = { port } });
-	}
-
-	ret = ip_nat_setup_info(ct, &range, hooknum);
-
-	if (is_h225) {
-		DEBUGP("h225_nat_expected: H.225, setting NAT helper for %p\n", ct);
-		/* NAT expectfn called with ip_nat_lock write-locked */
-		info->helper = &h245;
-	}
-	return ret;
-}
-
-static int h323_signal_address_fixup(struct ip_conntrack *ct,
-				     struct sk_buff **pskb,
-				     enum ip_conntrack_info ctinfo)
+static void ip_nat_h225_signal(struct sk_buff **pskb,
+			       struct ip_conntrack *ct,
+			       enum ip_conntrack_info ctinfo,
+			       unsigned int offset,
+			       int dir,
+			       int orig_dir)
 {
-	struct iphdr *iph = (*pskb)->nh.iph;
-	struct tcphdr _tcph, *tcph;
-	u_int32_t tcplen, datalen;
-	struct ip_ct_h225_master *info = &ct->help.ct_h225_info;
 	struct {
 		u_int32_t ip;
 		u_int16_t port;
 	} __attribute__ ((__packed__)) newdata;
-	int i;
-	int ret;
 
-	tcph = skb_header_pointer(*pskb, iph->ihl * 4, sizeof(_tcph), &_tcph);
-	if (tcph == NULL)
-		return NF_ACCEPT;
-
-	tcplen = (*pskb)->len - iph->ihl * 4;
-	datalen = tcplen - tcph->doff * 4;
-
-	MUST_BE_LOCKED(&ip_h323_lock);
-
-	DEBUGP("h323_signal_address_fixup: %s %s\n",
-		between(info->seq[IP_CT_DIR_ORIGINAL], ntohl(tcph->seq), ntohl(tcph->seq) + datalen)
-			? "yes" : "no",
-		between(info->seq[IP_CT_DIR_REPLY], ntohl(tcph->seq), ntohl(tcph->seq) + datalen)
-			? "yes" : "no");
-	if (!(between(info->seq[IP_CT_DIR_ORIGINAL], ntohl(tcph->seq), ntohl(tcph->seq) + datalen)
-		|| between(info->seq[IP_CT_DIR_REPLY], ntohl(tcph->seq), ntohl(tcph->seq) + datalen)))
-		return 1;
-
-	DEBUGP("h323_signal_address_fixup: offsets %u + 6  and %u + 6 in %u\n",
-		info->offset[IP_CT_DIR_ORIGINAL],
-		info->offset[IP_CT_DIR_REPLY],
-		tcplen);
-	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
-
-	for (i = 0; i < IP_CT_DIR_MAX; i++) {
-		DEBUGP("h323_signal_address_fixup: %s %s\n",
-			info->dir == IP_CT_DIR_ORIGINAL ? "original" : "reply",
-			i == IP_CT_DIR_ORIGINAL ? "caller" : "callee");
-		if (!between(info->seq[i], ntohl(tcph->seq),
-			     ntohl(tcph->seq) + datalen))
-			continue;
-		if (!between(info->seq[i] + 6, ntohl(tcph->seq),
-			     ntohl(tcph->seq) + datalen)) {
-			/* Partial retransmisison. It's a cracker being funky. */
-			if (net_ratelimit()) {
-				printk("H.323_NAT: partial packet %u/6 in %u/%u\n",
-				     info->seq[i],
-				     ntohl(tcph->seq),
-				     ntohl(tcph->seq) + datalen);
-			}
-			return 0;
-		}
-
-		/* Change address inside packet to match way we're mapping
-		   this connection. */
-		if (i == IP_CT_DIR_ORIGINAL) {
-			newdata.ip = ct->tuplehash[!info->dir].tuple.dst.ip;
-			newdata.port = ct->tuplehash[!info->dir].tuple.dst.u.tcp.port;
-		} else {
-			newdata.ip = ct->tuplehash[!info->dir].tuple.src.ip;
-			newdata.port = ct->tuplehash[!info->dir].tuple.src.u.tcp.port;
-		}
-
-		/* Modify the packet */
-		ret = ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
-					       info->seq[i] - ntohl(tcph->seq),
-					       sizeof(newdata),
-					       (const char*)&newdata, sizeof(newdata));
-		if (!ret)
-			return 0;
+	/* Change address inside packet to match way we're mapping
+	   this connection. */
+	if (dir == IP_CT_DIR_ORIGINAL) {
+		newdata.ip = ct->tuplehash[!orig_dir].tuple.dst.ip;
+		newdata.port = ct->tuplehash[!orig_dir].tuple.dst.u.tcp.port;
+	} else {
+		newdata.ip = ct->tuplehash[!orig_dir].tuple.src.ip;
+		newdata.port = ct->tuplehash[!orig_dir].tuple.src.u.tcp.port;
 	}
 
-	return 1;
+	/* Modify the packet */
+	ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
+				 offset,
+				 sizeof(newdata),
+				 (const char*)&newdata, sizeof(newdata));
 }
 
-static int h323_data_fixup(struct ip_ct_h225_expect *info,
-			   struct ip_conntrack *ct,
-			   struct sk_buff **pskb,
-			   enum ip_conntrack_info ctinfo,
-			   struct ip_conntrack_expect *expect)
+static int ip_nat_h225(struct sk_buff **pskb,
+		       enum ip_conntrack_info ctinfo,
+		       unsigned int offset,
+		       struct ip_conntrack_expect *exp)
 {
+	u_int16_t port;
 	struct {
 		u_int32_t ip;
 		u_int16_t port;
 	} __attribute__ ((__packed__)) newdata;
-	struct ip_conntrack_tuple newtuple;
-	struct iphdr *iph = (*pskb)->nh.iph;
-	struct tcphdr _tcph, *tcph;
-	u_int32_t tcplen;
-	struct ip_ct_h225_master *master_info = &ct->help.ct_h225_info;
-	int is_h225;
+	int dir = CTINFO2DIR(ctinfo);
+	struct ip_conntrack *ct = exp->master;
 	int ret;
 
-	tcph = skb_header_pointer(*pskb, iph->ihl * 4, sizeof(_tcph), &_tcph);
-	if (tcph == NULL)
-		return NF_ACCEPT;
-
-	tcplen = (*pskb)->len - iph->ihl * 4;
-
-	MUST_BE_LOCKED(&ip_h323_lock);
-	DEBUGP("h323_data_fixup: offset %u + 6 in %u\n", info->offset, tcplen);
-	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
-
-	if (!between(expect->seq + 6, ntohl(tcph->seq),
-		    ntohl(tcph->seq) + tcplen - tcph->doff * 4)) {
-		/* Partial retransmisison. It's a cracker being funky. */
-		if (net_ratelimit()) {
-			printk("H.323_NAT: partial packet %u/6 in %u/%u\n",
-			     expect->seq,
-			     ntohl(tcph->seq),
-			     ntohl(tcph->seq) + tcplen - tcph->doff * 4);
-		}
-		return 0;
-	}
-
-	/* Change address inside packet to match way we're mapping
-	   this connection. */
-	if (info->dir == IP_CT_DIR_REPLY) {
-		/* Must be where client thinks server is */
-		newdata.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
-		/* Expect something from client->server */
-		newtuple.src.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
-		newtuple.dst.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
-	} else {
-		/* Must be where server thinks client is */
-		newdata.ip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
-		/* Expect something from server->client */
-		newtuple.src.ip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
-		newtuple.dst.ip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
-	}
-
-	is_h225 = (master_info->is_h225 == H225_PORT);
-
-	if (is_h225) {
-		newtuple.dst.protonum = IPPROTO_TCP;
-		newtuple.src.u.tcp.port = expect->tuple.src.u.tcp.port;
-	} else {
-		newtuple.dst.protonum = IPPROTO_UDP;
-		newtuple.src.u.udp.port = expect->tuple.src.u.udp.port;
-	}
+	/* Connection will come from wherever this packet goes, hence !dir */
+	newdata.ip = ct->tuplehash[!dir].tuple.dst.ip;
+	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
+	exp->dir = !dir;
+
+	/* When you see the packet, we need to NAT it the same as the
+	 * this one. */
+	exp->expectfn = ip_nat_follow_master;
 
 	/* Try to get same port: if not, try to change it. */
-	for (newdata.port = ntohs(info->port); newdata.port != 0; newdata.port++) {
-		if (is_h225)
-			newtuple.dst.u.tcp.port = htons(newdata.port);
-		else
-			newtuple.dst.u.udp.port = htons(newdata.port);
-
-		if (ip_conntrack_change_expect(expect, &newtuple) == 0)
+	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
+		exp->tuple.dst.u.tcp.port = htons(port);
+		if (ip_conntrack_expect_related(exp) == 0)
 			break;
 	}
-	if (newdata.port == 0) {
-		DEBUGP("h323_data_fixup: no free port found!\n");
-		return 0;
+
+	if (port == 0) {
+		ip_conntrack_expect_free(exp);
+		return NF_DROP;
 	}
 
-	newdata.port = htons(newdata.port);
+	newdata.port = htons(port);
 
-	/* Modify the packet */
+	/* now mangle packet */
 	ret = ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
-				       expect->seq - ntohl(tcph->seq),
+				       offset,
 				       sizeof(newdata),
 				       (const char*)&newdata, sizeof(newdata));
 	if (!ret)
-		return 0;
-
-	return 1;
-}
-
-static unsigned int h225_nat_help(struct ip_conntrack *ct,
-				  struct ip_conntrack_expect *exp,
-				  struct ip_nat_info *info,
-				  enum ip_conntrack_info ctinfo,
-				  unsigned int hooknum,
-				  struct sk_buff **pskb)
-{
-	int dir;
-	struct ip_ct_h225_expect *exp_info;
-
-	/* Only mangle things once: original direction in POST_ROUTING
-	   and reply direction on PRE_ROUTING. */
-	dir = CTINFO2DIR(ctinfo);
-	DEBUGP("nat_h323: dir %s at hook %s\n",
-	       dir == IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
-	       hooknum == NF_IP_POST_ROUTING ? "POSTROUTING"
-	       : hooknum == NF_IP_PRE_ROUTING ? "PREROUTING"
-	       : hooknum == NF_IP_LOCAL_OUT ? "OUTPUT" : "???");
-	if (!((hooknum == NF_IP_POST_ROUTING && dir == IP_CT_DIR_ORIGINAL)
-	      || (hooknum == NF_IP_PRE_ROUTING && dir == IP_CT_DIR_REPLY))) {
-		DEBUGP("nat_h323: Not touching dir %s at hook %s\n",
-		       dir == IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
-		       hooknum == NF_IP_POST_ROUTING ? "POSTROUTING"
-		       : hooknum == NF_IP_PRE_ROUTING ? "PREROUTING"
-		       : hooknum == NF_IP_LOCAL_OUT ? "OUTPUT" : "???");
-		return NF_ACCEPT;
-	}
-
-	if (!exp) {
-		LOCK_BH(&ip_h323_lock);
-		if (!h323_signal_address_fixup(ct, pskb, ctinfo)) {
-			UNLOCK_BH(&ip_h323_lock);
-			return NF_DROP;
-		}
-		UNLOCK_BH(&ip_h323_lock);
-		return NF_ACCEPT;
-	}
-
-	exp_info = &exp->help.exp_h225_info;
-
-	LOCK_BH(&ip_h323_lock);
-	if (!h323_data_fixup(exp_info, ct, pskb, ctinfo, exp)) {
-		UNLOCK_BH(&ip_h323_lock);
 		return NF_DROP;
-	}
-	UNLOCK_BH(&ip_h323_lock);
 
 	return NF_ACCEPT;
 }
 
-static struct ip_nat_helper h225 = {
-	.list = { NULL, NULL },
-	.name = "H.225",
-	.flags = IP_NAT_HELPER_F_ALWAYS,
-	.me = THIS_MODULE,
-	.tuple = { { 0, { .tcp = { __constant_htons(H225_PORT) } } },
-		   { 0, { 0 }, IPPROTO_TCP } },
-	.mask = { { 0, { .tcp = { 0xFFFF } } },
-		  { 0, { 0 }, 0xFFFF } },
-	.help = h225_nat_help,
-	.expect = h225_nat_expected
-};
-
 static int __init init(void)
 {
-	int ret;
-
-	ret = ip_nat_helper_register(&h225);
+	BUG_ON(ip_nat_h225_hook != NULL);
+	BUG_ON(ip_nat_h245_hook != NULL);
 
-	if (ret != 0)
-		printk("ip_nat_h323: cannot initialize the module!\n");
+	ip_nat_h225_hook = ip_nat_h225;
+	ip_nat_h225_signal_hook = ip_nat_h225_signal;
+	ip_nat_h245_hook = ip_nat_h225;
 
-	return ret;
+	return 0;
 }
 
 static void __exit fini(void)
 {
-	ip_nat_helper_unregister(&h225);
+	ip_nat_h225_hook = NULL;
+	ip_nat_h225_signal_hook = NULL;
+	ip_nat_h245_hook = NULL;
 }
 
-NEEDS_CONNTRACK(h225);
-NEEDS_CONNTRACK(h245);
 module_init(init);
 module_exit(fini);


--Q68bSM7Ycu6FN28Q--
