From: Patrick McHardy <kaber@trash.net>
Subject: Re: patch for conntrack expectations
Date: Tue, 24 Feb 2004 17:32:42 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <403B7CAA.3060005@trash.net>
References: <403014C5.8080102@eurodev.net> <20040217213217.GF30968@obroa-skai.de.gnumonks.org> <4032F4DE.3050402@eurodev.net> <20040218172539.GX9464@sunbeam.de.gnumonks.org> <4038B14C.901@eurodev.net> <20040224094014.GV13386@sunbeam.de.gnumonks.org> <403B1F5F.6010004@trash.net> <20040224102432.GX13386@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060706080503020604070801"
Cc: Pablo Neira <pablo@eurodev.net>,  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040224102432.GX13386@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060706080503020604070801
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Harald Welte wrote:
> On Tue, Feb 24, 2004 at 10:54:39AM +0100, Patrick McHardy wrote:
> 
> 
>>The 2.4 patch went in, the 2.6 didn't. Some of the problems got fixed
>>in 2.6 when removing skb_linearize, but some didn't. Do you want me to
>>resubmit the patch to you ?
> 
> 
> yes, please.

Old patch attached, it still applies cleanly.

> 
>>Regards
>>Patrick
> 
> 


--------------060706080503020604070801
Content-Type: text/x-patch;
 name="2.6-amanda-helpers.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6-amanda-helpers.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1356  -> 1.1357 
#	include/linux/netfilter_ipv4/ip_conntrack_amanda.h	1.2     -> 1.3    
#	net/ipv4/netfilter/ip_nat_amanda.c	1.5     -> 1.6    
#	net/ipv4/netfilter/ip_conntrack_amanda.c	1.4     -> 1.5    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/09/28	kaber@trash.net	1.1357
# [NETFILTER]: Fix amanda helpers
# --------------------------------------------
#
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack_amanda.h b/include/linux/netfilter_ipv4/ip_conntrack_amanda.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_amanda.h	Sun Sep 28 04:38:42 2003
+++ b/include/linux/netfilter_ipv4/ip_conntrack_amanda.h	Sun Sep 28 04:38:42 2003
@@ -2,20 +2,11 @@
 #define _IP_CONNTRACK_AMANDA_H
 /* AMANDA tracking. */
 
-#ifdef __KERNEL__
-
-#include <linux/netfilter_ipv4/lockhelp.h>
-
-/* Protects amanda part of conntracks */
-DECLARE_LOCK_EXTERN(ip_amanda_lock);
-
-#endif
-
 struct ip_ct_amanda_expect
 {
 	u_int16_t port;		/* port number of this expectation */
-	u_int16_t offset;	/* offset of the port specification in ctrl packet */
-	u_int16_t len;		/* the length of the port number specification */
+	u_int16_t offset;	/* offset of port in ctrl packet */
+	u_int16_t len;		/* length of the port number string */
 };
 
 #endif /* _IP_CONNTRACK_AMANDA_H */
diff -Nru a/net/ipv4/netfilter/ip_conntrack_amanda.c b/net/ipv4/netfilter/ip_conntrack_amanda.c
--- a/net/ipv4/netfilter/ip_conntrack_amanda.c	Sun Sep 28 04:38:42 2003
+++ b/net/ipv4/netfilter/ip_conntrack_amanda.c	Sun Sep 28 04:38:42 2003
@@ -18,6 +18,7 @@
  *
  */
 
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netfilter.h>
 #include <linux/ip.h>
@@ -36,50 +37,37 @@
 MODULE_PARM(master_timeout, "i");
 MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
 
-DECLARE_LOCK(ip_amanda_lock);
-
-char *conns[] = { "DATA ", "MESG ", "INDEX " };
-
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
+static char *conns[] = { "DATA ", "MESG ", "INDEX " };
 
 /* This is slow, but it's simple. --RR */
 static char amanda_buffer[65536];
+static DECLARE_LOCK(amanda_buffer_lock);
 
 static int help(struct sk_buff *skb,
-		struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
+                struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
 {
-	char *data, *data_limit;
-	int dir = CTINFO2DIR(ctinfo);
+	struct ip_conntrack_expect exp;
+	struct ip_ct_amanda_expect *exp_amanda_info;
+	char *data, *data_limit, *tmp;
 	unsigned int dataoff, i;
-	struct ip_ct_amanda *info =
-				(struct ip_ct_amanda *)&ct->help.ct_ftp_info;
 
-	/* Can't track connections formed before we registered */
-	if (!info)
+	/* Only look at packets from the Amanda server */
+	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
 		return NF_ACCEPT;
 
 	/* increase the UDP timeout of the master connection as replies from
 	 * Amanda clients to the server can be quite delayed */
 	ip_ct_refresh(ct, master_timeout * HZ);
 
-	/* If packet is coming from Amanda server */
-	if (dir == IP_CT_DIR_ORIGINAL)
-		return NF_ACCEPT;
-
 	/* No data? */
 	dataoff = skb->nh.iph->ihl*4 + sizeof(struct udphdr);
 	if (dataoff >= skb->len) {
 		if (net_ratelimit())
-			printk("ip_conntrack_amanda_help: skblen = %u\n",
-			       (unsigned)skb->len);
+			printk("amanda_help: skblen = %u\n", skb->len);
 		return NF_ACCEPT;
 	}
 
-	LOCK_BH(&ip_amanda_lock);
+	LOCK_BH(&amanda_buffer_lock);
 	skb_copy_bits(skb, dataoff, amanda_buffer, skb->len - dataoff);
 	data = amanda_buffer;
 	data_limit = amanda_buffer + skb->len - dataoff;
@@ -89,84 +77,39 @@
 	data = strstr(data, "CONNECT ");
 	if (!data)
 		goto out;
-
-	DEBUGP("ip_conntrack_amanda_help: CONNECT found in connection "
-		   "%u.%u.%u.%u:%u %u.%u.%u.%u:%u\n",
-		   NIPQUAD(iph->saddr), htons(udph->source),
-		   NIPQUAD(iph->daddr), htons(udph->dest));
 	data += strlen("CONNECT ");
 
+	memset(&exp, 0, sizeof(exp));
+	exp.tuple.src.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+	exp.tuple.dst.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
+	exp.tuple.dst.protonum = IPPROTO_TCP;
+	exp.mask.src.ip = 0xFFFFFFFF;
+	exp.mask.dst.ip = 0xFFFFFFFF;
+	exp.mask.dst.protonum = 0xFFFF;
+	exp.mask.dst.u.tcp.port = 0xFFFF;
+
 	/* Only search first line. */	
-	if (strchr(data, '\n'))
-		*strchr(data, '\n') = '\0';
+	if ((tmp = strchr(data, '\n')))
+		*tmp = '\0';
 
+	exp_amanda_info = &exp.help.exp_amanda_info;
 	for (i = 0; i < ARRAY_SIZE(conns); i++) {
 		char *match = strstr(data, conns[i]);
-		if (match) {
-			char *portchr;
-			struct ip_conntrack_expect expect;
-			struct ip_ct_amanda_expect *exp_amanda_info =
-				&expect.help.exp_amanda_info;
-
-			memset(&expect, 0, sizeof(expect));
-
-			data += strlen(conns[i]);
-			/* this is not really tcp, but let's steal an
-			 * idea from a tcp stream helper :-) */
-			// XXX expect.seq = data - amanda_buffer;
-			exp_amanda_info->offset = data - amanda_buffer;
-// XXX DEBUGP("expect.seq = %p - %p = %d\n", data, amanda_buffer, expect.seq);
-DEBUGP("exp_amanda_info->offset = %p - %p = %d\n", data, amanda_buffer, exp_amanda_info->offset);
-			portchr = data;
-			exp_amanda_info->port = simple_strtoul(data, &data,10);
-			exp_amanda_info->len = data - portchr;
-
-			/* eat whitespace */
-			while (*data == ' ')
-				data++;
-			DEBUGP("ip_conntrack_amanda_help: "
-			       "CONNECT %s request with port "
-			       "%u found\n", conns[i],
-			       exp_amanda_info->port);
-
-			expect.tuple = ((struct ip_conntrack_tuple)
-				{ { ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip,
-				    { 0 } },
-				  { ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip,
-				    { htons(exp_amanda_info->port) },
-				    IPPROTO_TCP }});
-			expect.mask = ((struct ip_conntrack_tuple)
-				{ { 0, { 0 } },
-				  { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
-
-			expect.expectfn = NULL;
-
-			DEBUGP ("ip_conntrack_amanda_help: "
-				"expect_related: %u.%u.%u.%u:%u - "
-				"%u.%u.%u.%u:%u\n",
-				NIPQUAD(expect.tuple.src.ip),
-				ntohs(expect.tuple.src.u.tcp.port),
-				NIPQUAD(expect.tuple.dst.ip),
-				ntohs(expect.tuple.dst.u.tcp.port));
-			if (ip_conntrack_expect_related(ct, &expect)
-			    == -EEXIST) {
-				;
-				/* this must be a packet being resent */
-				/* XXX - how do I get the
-				 *       ip_conntrack_expect that
-				 *       already exists so that I can
-				 *       update the .seq so that the
-				 *       nat module rewrites the port
-				 *       numbers?
-				 *       Perhaps I should use the
-				 *       exp_amanda_info instead of
-				 *       .seq.
-				 */
-			}
-		}
+		if (!match)
+			continue;
+		tmp = data = match + strlen(conns[i]);
+		exp_amanda_info->offset = data - amanda_buffer;
+		exp_amanda_info->port   = simple_strtoul(data, &data, 10);
+		exp_amanda_info->len    = data - tmp;
+		if (exp_amanda_info->port == 0 || exp_amanda_info->len > 5)
+			break;
+
+		exp.tuple.dst.u.tcp.port = htons(exp_amanda_info->port);
+		ip_conntrack_expect_related(ct, &exp);
 	}
- out:
-	UNLOCK_BH(&ip_amanda_lock);
+
+out:
+	UNLOCK_BH(&amanda_buffer_lock);
 	return NF_ACCEPT;
 }
 
@@ -186,29 +129,16 @@
 	},
 };
 
-static void fini(void)
+static void __exit fini(void)
 {
-	DEBUGP("ip_ct_amanda: unregistering helper for port 10080\n");
 	ip_conntrack_helper_unregister(&amanda_helper);
 }
 
 static int __init init(void)
 {
-	int ret;
-
-	DEBUGP("ip_ct_amanda: registering helper for port 10080\n");
-	ret = ip_conntrack_helper_register(&amanda_helper);
-
-	if (ret) {
-		printk("ip_ct_amanda: ERROR registering helper\n");
-		fini();
-		return -EBUSY;
-	}
-	return 0;
+	return ip_conntrack_helper_register(&amanda_helper);
 }
 
 PROVIDES_CONNTRACK(amanda);
-EXPORT_SYMBOL(ip_amanda_lock);
-
 module_init(init);
 module_exit(fini);
diff -Nru a/net/ipv4/netfilter/ip_nat_amanda.c b/net/ipv4/netfilter/ip_nat_amanda.c
--- a/net/ipv4/netfilter/ip_nat_amanda.c	Sun Sep 28 04:38:42 2003
+++ b/net/ipv4/netfilter/ip_nat_amanda.c	Sun Sep 28 04:38:42 2003
@@ -11,69 +11,45 @@
  * 	insmod ip_nat_amanda.o
  */
 
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter.h>
+#include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <linux/udp.h>
-#include <linux/kernel.h>
 #include <net/tcp.h>
 #include <net/udp.h>
 
+#include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
-#include <linux/netfilter_ipv4/ip_nat_rule.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_amanda.h>
 
 
-#if 0
-#define DEBUGP printk
-#define DUMP_OFFSET(x)	printk("offset_before=%d, offset_after=%d, correction_pos=%u\n", x->offset_before, x->offset_after, x->correction_pos);
-#else
-#define DEBUGP(format, args...)
-#define DUMP_OFFSET(x)
-#endif
-
 MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
 MODULE_DESCRIPTION("Amanda NAT helper");
 MODULE_LICENSE("GPL");
 
-/* protects amanda part of conntracks */
-DECLARE_LOCK_EXTERN(ip_amanda_lock);
-
 static unsigned int
 amanda_nat_expected(struct sk_buff **pskb,
-		 unsigned int hooknum,
-		 struct ip_conntrack *ct,
-		 struct ip_nat_info *info)
+                    unsigned int hooknum,
+                    struct ip_conntrack *ct,
+                    struct ip_nat_info *info)
 {
-	struct ip_nat_multi_range mr;
-	u_int32_t newdstip, newsrcip, newip;
-	u_int16_t port;
-	struct ip_ct_amanda_expect *exp_info;
 	struct ip_conntrack *master = master_ct(ct);
+	struct ip_ct_amanda_expect *exp_amanda_info;
+	struct ip_nat_multi_range mr;
+	u_int32_t newip;
 
 	IP_NF_ASSERT(info);
 	IP_NF_ASSERT(master);
-
 	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
 
-	DEBUGP("nat_expected: We have a connection!\n");
-	exp_info = &ct->master->help.exp_amanda_info;
-
-	newdstip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
-	newsrcip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
-	DEBUGP("nat_expected: %u.%u.%u.%u->%u.%u.%u.%u\n",
-	       NIPQUAD(newsrcip), NIPQUAD(newdstip));
-
-	port = exp_info->port;
-
 	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC)
-		newip = newsrcip;
+		newip = master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
 	else
-		newip = newdstip;
-
-	DEBUGP("nat_expected: IP to %u.%u.%u.%u\n", NIPQUAD(newip));
+		newip = master->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
 
 	mr.rangesize = 1;
 	/* We don't want to manip the per-protocol, just the IPs. */
@@ -81,121 +57,79 @@
 	mr.range[0].min_ip = mr.range[0].max_ip = newip;
 
 	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_DST) {
+		exp_amanda_info = &ct->master->help.exp_amanda_info;
 		mr.range[0].flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
 		mr.range[0].min = mr.range[0].max
 			= ((union ip_conntrack_manip_proto)
-				{ .udp = { htons(port) } });
+				{ .udp = { htons(exp_amanda_info->port) } });
 	}
 
 	return ip_nat_setup_info(ct, &mr, hooknum);
 }
 
 static int amanda_data_fixup(struct ip_conntrack *ct,
-			  struct sk_buff **pskb,
-			  enum ip_conntrack_info ctinfo,
-			  struct ip_conntrack_expect *expect)
+                             struct sk_buff **pskb,
+                             enum ip_conntrack_info ctinfo,
+                             struct ip_conntrack_expect *exp)
 {
-	u_int32_t newip;
-	/* DATA 99999 MESG 99999 INDEX 99999 */
-	char buffer[6];
-	struct ip_conntrack_expect *exp = expect;
-	struct ip_ct_amanda_expect *ct_amanda_info = &exp->help.exp_amanda_info;
+	struct ip_ct_amanda_expect *exp_amanda_info;
 	struct ip_conntrack_tuple t = exp->tuple;
+	char buffer[sizeof("65535")];
 	u_int16_t port;
 
-	MUST_BE_LOCKED(&ip_amanda_lock);
-
-	newip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
-	DEBUGP ("ip_nat_amanda_help: newip = %u.%u.%u.%u\n", NIPQUAD(newip));
-
 	/* Alter conntrack's expectations. */
-
-	/* We can read expect here without conntrack lock, since it's
-	   only set in ip_conntrack_amanda, with ip_amanda_lock held
-	   writable */
-
-	t.dst.ip = newip;
-	for (port = ct_amanda_info->port; port != 0; port++) {
+	exp_amanda_info = &exp->help.exp_amanda_info;
+	t.dst.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
+	for (port = exp_amanda_info->port; port != 0; port++) {
 		t.dst.u.tcp.port = htons(port);
 		if (ip_conntrack_change_expect(exp, &t) == 0)
 			break;
 	}
-
 	if (port == 0)
 		return 0;
 
 	sprintf(buffer, "%u", port);
-
-	return ip_nat_mangle_udp_packet(pskb, ct, ctinfo, /* XXX exp->seq */ ct_amanda_info->offset, 
-					ct_amanda_info->len, buffer, strlen(buffer));
+	return ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
+	                                exp_amanda_info->offset,
+	                                exp_amanda_info->len,
+	                                buffer, strlen(buffer));
 }
 
 static unsigned int help(struct ip_conntrack *ct,
-			 struct ip_conntrack_expect *exp,
-			 struct ip_nat_info *info,
-			 enum ip_conntrack_info ctinfo,
-			 unsigned int hooknum,
-			 struct sk_buff **pskb)
+                         struct ip_conntrack_expect *exp,
+                         struct ip_nat_info *info,
+                         enum ip_conntrack_info ctinfo,
+                         unsigned int hooknum,
+                         struct sk_buff **pskb)
 {
-	int dir;
+	int dir = CTINFO2DIR(ctinfo);
+	int ret = NF_ACCEPT;
 
-	if (!exp)
-		DEBUGP("ip_nat_amanda: no exp!!");
-		
 	/* Only mangle things once: original direction in POST_ROUTING
 	   and reply direction on PRE_ROUTING. */
-	dir = CTINFO2DIR(ctinfo);
 	if (!((hooknum == NF_IP_POST_ROUTING && dir == IP_CT_DIR_ORIGINAL)
-	      || (hooknum == NF_IP_PRE_ROUTING && dir == IP_CT_DIR_REPLY))) {
-		DEBUGP("ip_nat_amanda_help: Not touching dir %s at hook %s\n",
-		       dir == IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
-		       hooknum == NF_IP_POST_ROUTING ? "POSTROUTING"
-		       : hooknum == NF_IP_PRE_ROUTING ? "PREROUTING"
-		       : hooknum == NF_IP_LOCAL_OUT ? "OUTPUT"
-		       : hooknum == NF_IP_LOCAL_IN ? "INPUT" : "???");
+	      || (hooknum == NF_IP_PRE_ROUTING && dir == IP_CT_DIR_REPLY)))
 		return NF_ACCEPT;
-	}
-	DEBUGP("ip_nat_amanda_help: got beyond not touching: dir %s at hook %s for expect: ",
-		   dir == IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
-		   hooknum == NF_IP_POST_ROUTING ? "POSTROUTING"
-		   : hooknum == NF_IP_PRE_ROUTING ? "PREROUTING"
-		     : hooknum == NF_IP_LOCAL_OUT ? "OUTPUT"
-		       : hooknum == NF_IP_LOCAL_IN ? "INPUT" : "???");
-	DUMP_TUPLE(&exp->tuple);
 
-	LOCK_BH(&ip_amanda_lock);
-// XXX	if (exp->seq != 0)
+	/* if this exectation has a "offset" the packet needs to be mangled */
 	if (exp->help.exp_amanda_info.offset != 0)
-		/*  if this packet has a "seq" it needs to have it's content mangled */
-		if (!amanda_data_fixup(ct, pskb, ctinfo, exp)) {
-			UNLOCK_BH(&ip_amanda_lock);
-			DEBUGP("ip_nat_amanda: NF_DROP\n");
-			return NF_DROP;
-		}
+		if (!amanda_data_fixup(ct, pskb, ctinfo, exp))
+			ret = NF_DROP;
 	exp->help.exp_amanda_info.offset = 0;
-	UNLOCK_BH(&ip_amanda_lock);
 
-	DEBUGP("ip_nat_amanda: NF_ACCEPT\n");
-	return NF_ACCEPT;
+	return ret;
 }
 
 static struct ip_nat_helper ip_nat_amanda_helper;
 
-/* This function is intentionally _NOT_ defined as  __exit, because
- * it is needed by init() */
-static void fini(void)
+static void __exit fini(void)
 {
-	DEBUGP("ip_nat_amanda: unregistering nat helper\n");
 	ip_nat_helper_unregister(&ip_nat_amanda_helper);
 }
 
 static int __init init(void)
 {
-	int ret = 0;
-	struct ip_nat_helper *hlpr;
-
-	hlpr = &ip_nat_amanda_helper;
-	memset(hlpr, 0, sizeof(struct ip_nat_helper));
+	struct ip_nat_helper *hlpr = &ip_nat_amanda_helper;
 
 	hlpr->tuple.dst.protonum = IPPROTO_UDP;
 	hlpr->tuple.src.u.udp.port = htons(10080);
@@ -205,20 +139,9 @@
 	hlpr->flags = 0;
 	hlpr->me = THIS_MODULE;
 	hlpr->expect = amanda_nat_expected;
-
 	hlpr->name = "amanda";
 
-	DEBUGP
-	    ("ip_nat_amanda: Trying to register nat helper\n");
-	ret = ip_nat_helper_register(hlpr);
-
-	if (ret) {
-		printk
-		    ("ip_nat_amanda: error registering nat helper\n");
-		fini();
-		return 1;
-	}
-	return ret;
+	return ip_nat_helper_register(hlpr);
 }
 
 NEEDS_CONNTRACK(amanda);

--------------060706080503020604070801--
