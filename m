From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] Introducing the Change API
Date: Sat, 04 Dec 2004 23:15:18 +0100
Message-ID: <41B236F6.9090405@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060901080006020601050400"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------060901080006020601050400
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I've finished the change API patch which goes on top of the conntrack 
event API[1]. This patch provides a way to modify some parts of a 
conntrack such as protocol and helper private info.

I've defined three generic functions:

a) helper handlings
generic_change_help
generic_change_new_expect

b) proto handlings
generic_change_proto

Since there are mostly the same thing, if there's any weird protocol, we 
can still defined our own function. I've also added a new field in 
ip_conntrack_protocol and ip_conntrack_helper, to make their locks, if 
any, accessible. So it's flexible enough.

Comments and review welcome.

Next step, work on the ctnetlink-nfnetlink stuff. Is there any plan to 
push forward both patches?

Refs:
[1] 
https://lists.netfilter.org/pipermail/netfilter-devel/2004-November/017453.html

--
Pablo

--------------060901080006020601050400
Content-Type: text/plain;
 name="parche"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="parche"

diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' linux-2.5/net/ipv4/netfilter/ip_conntrack_amanda.c change/net/ipv4/netfilter/ip_conntrack_amanda.c
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-12-04 20:13:32.000000000 +0100
+++ change/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-12-04 19:35:16.000000000 +0100
@@ -136,6 +136,8 @@
 	.mask = { .src = { .u = { 0xFFFF } },
 		 .dst = { .protonum = 0xFFFF },
 	},
+	.change_help = generic_change_help,
+	.change_new_expect = generic_change_new_expect,
 };
 
 static void __exit fini(void)
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' linux-2.5/net/ipv4/netfilter/ip_conntrack_core.c change/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_core.c	2004-12-04 20:13:32.000000000 +0100
+++ change/net/ipv4/netfilter/ip_conntrack_core.c	2004-12-04 20:14:15.000000000 +0100
@@ -1244,6 +1244,51 @@
 	}
 }
 
+void generic_change_proto(struct ip_conntrack *ct,
+			  union ip_conntrack_proto *p)
+{
+	struct ip_conntrack_tuple *t = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+	struct ip_conntrack_protocol *proto;
+	
+	proto = ip_ct_find_proto(t->dst.protonum);
+	if (proto->lock != NULL) {
+		WRITE_LOCK(proto->lock);
+		memcpy(&ct->proto, p, sizeof(union ip_conntrack_proto));
+		WRITE_UNLOCK(proto->lock);
+	} else
+		memcpy(&ct->proto, p, sizeof(union ip_conntrack_proto));
+}
+
+void generic_change_help(struct ip_conntrack *ct, union ip_conntrack_help *h)
+{
+	struct ip_conntrack_helper *helper= ct->helper;
+
+	if (helper->lock != NULL) {
+		LOCK_BH(helper->lock);
+		memcpy(&ct->help, h, sizeof(ct->help));
+		UNLOCK_BH(helper->lock);
+	} else
+		memcpy(&ct->help, h, sizeof(ct->help));
+}
+
+int generic_change_new_expect(struct ip_conntrack_expect *exp,
+			      union ip_conntrack_expect_proto *p,
+			      union ip_conntrack_expect_help *h)
+{
+	struct ip_conntrack_helper *helper = exp->expectant->helper;
+
+	if (h == NULL)
+		return -1;
+	if (helper->lock != NULL) {
+		LOCK_BH(helper->lock);
+		memcpy(&exp->help, h, sizeof(exp->help));
+		UNLOCK_BH(helper->lock);
+	} else
+		memcpy(&exp->help, h, sizeof(exp->help));
+
+	return 0;
+}
+
 /* Fast function for those who don't want to parse /proc (and I don't
    blame them). */
 /* Reversing the socket's dst/src point of view gives us the reply
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' linux-2.5/net/ipv4/netfilter/ip_conntrack_ftp.c change/net/ipv4/netfilter/ip_conntrack_ftp.c
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-12-04 20:13:32.000000000 +0100
+++ change/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-12-04 19:35:11.000000000 +0100
@@ -440,6 +440,9 @@
 		ftp[i].flags = IP_CT_HELPER_F_REUSE_EXPECT;
 		ftp[i].me = ip_conntrack_ftp;
 		ftp[i].help = help;
+		ftp[i].lock = &ip_ftp_lock;
+		ftp[i].change_help = generic_change_help;
+		ftp[i].change_new_expect = generic_change_new_expect;
 
 		tmpname = &ftp_names[i][0];
 		if (ports[i] == FTP_PORT)
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' linux-2.5/net/ipv4/netfilter/ip_conntrack_irc.c change/net/ipv4/netfilter/ip_conntrack_irc.c
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_irc.c	2004-12-04 20:13:32.000000000 +0100
+++ change/net/ipv4/netfilter/ip_conntrack_irc.c	2004-12-04 19:34:57.000000000 +0100
@@ -271,6 +271,9 @@
 		hlpr->flags = IP_CT_HELPER_F_REUSE_EXPECT;
 		hlpr->me = ip_conntrack_irc;
 		hlpr->help = help;
+		hlpr->lock = &irc_buffer_lock;
+		hlpr->change_help = generic_change_help;
+		hlpr->change_new_expect = generic_change_new_expect;
 
 		tmpname = &irc_names[i][0];
 		if (ports[i] == IRC_PORT)
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' linux-2.5/net/ipv4/netfilter/ip_conntrack_proto_icmp.c change/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-12-04 20:13:32.000000000 +0100
+++ change/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-12-04 19:09:42.000000000 +0100
@@ -109,16 +109,17 @@
 	return NF_ACCEPT;
 }
 
+static u_int8_t valid_new[] = {
+	[ICMP_ECHO] = 1,
+	[ICMP_TIMESTAMP] = 1,
+	[ICMP_INFO_REQUEST] = 1,
+	[ICMP_ADDRESS] = 1
+};
+
 /* Called when a new connection for this protocol found. */
 static int icmp_new(struct ip_conntrack *conntrack,
 		    const struct sk_buff *skb)
 {
-	static u_int8_t valid_new[]
-		= { [ICMP_ECHO] = 1,
-		    [ICMP_TIMESTAMP] = 1,
-		    [ICMP_INFO_REQUEST] = 1,
-		    [ICMP_ADDRESS] = 1 };
-
 	if (conntrack->tuplehash[0].tuple.dst.u.icmp.type >= sizeof(valid_new)
 	    || !valid_new[conntrack->tuplehash[0].tuple.dst.u.icmp.type]) {
 		/* Can't create a new ICMP `conn' with this. */
@@ -266,6 +267,17 @@
 	return icmp_error_message(skb, ctinfo, hooknum);
 }
 
+static int icmp_change_check_tuples(struct ip_conntrack_tuple *orig,
+				    struct ip_conntrack_tuple *reply)
+{
+	unsigned int type = orig->dst.u.icmp.type;
+
+	if (type >= sizeof(valid_new) || !valid_new[type])
+		return -EINVAL;
+
+	return 0;
+}
+
 struct ip_conntrack_protocol ip_conntrack_protocol_icmp =
 {
 	.proto 			= IPPROTO_ICMP,
@@ -277,4 +289,6 @@
 	.packet			= icmp_packet,
 	.new			= icmp_new,
 	.error			= icmp_error,
+	.change_check_tuples    = icmp_change_check_tuples,
+	.change_proto           = generic_change_proto,
 };
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' linux-2.5/net/ipv4/netfilter/ip_conntrack_proto_sctp.c change/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2004-12-04 20:13:32.000000000 +0100
+++ change/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2004-12-04 19:17:53.000000000 +0100
@@ -506,6 +506,7 @@
 struct ip_conntrack_protocol ip_conntrack_protocol_sctp = { 
 	.proto 		 = IPPROTO_SCTP, 
 	.name 		 = "sctp",
+	.lock		 = &sctp_lock,
 	.pkt_to_tuple 	 = sctp_pkt_to_tuple, 
 	.invert_tuple 	 = sctp_invert_tuple, 
 	.print_tuple 	 = sctp_print_tuple, 
@@ -514,6 +515,7 @@
 	.new 		 = sctp_new, 
 	.destroy 	 = NULL, 
 	.exp_matches_pkt = sctp_exp_matches_pkt, 
+	.change_proto	 = generic_change_proto,
 	.me 		 = THIS_MODULE 
 };
 
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' linux-2.5/net/ipv4/netfilter/ip_conntrack_proto_tcp.c change/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-12-04 20:13:32.000000000 +0100
+++ change/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-12-04 19:09:06.000000000 +0100
@@ -1079,6 +1079,7 @@
 {
 	.proto 			= IPPROTO_TCP,
 	.name 			= "tcp",
+	.lock			= &tcp_lock,
 	.pkt_to_tuple 		= tcp_pkt_to_tuple,
 	.invert_tuple 		= tcp_invert_tuple,
 	.print_tuple 		= tcp_print_tuple,
@@ -1087,4 +1088,5 @@
 	.new 			= tcp_new,
 	.exp_matches_pkt	= tcp_exp_matches_pkt,
 	.error			= tcp_error,
+	.change_proto           = generic_change_proto,
 };
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' linux-2.5/net/ipv4/netfilter/ip_conntrack_proto_udp.c change/net/ipv4/netfilter/ip_conntrack_proto_udp.c
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2004-12-04 20:13:32.000000000 +0100
+++ change/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2004-12-04 19:09:13.000000000 +0100
@@ -146,4 +146,5 @@
 	.packet			= udp_packet,
 	.new			= udp_new,
 	.error			= udp_error,
+	.change_proto           = generic_change_proto,
 };
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' linux-2.5/net/ipv4/netfilter/ip_conntrack_standalone.c change/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-12-04 20:13:32.000000000 +0100
+++ change/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-12-04 14:58:09.000000000 +0100
@@ -880,6 +880,9 @@
 {
 }
 
+EXPORT_SYMBOL(generic_change_proto);
+EXPORT_SYMBOL(generic_change_help);
+EXPORT_SYMBOL(generic_change_new_expect);
 #ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
 EXPORT_SYMBOL(ip_conntrack_chain);
 EXPORT_SYMBOL(ip_conntrack_register_notifier);
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' linux-2.5/net/ipv4/netfilter/ip_conntrack_tftp.c change/net/ipv4/netfilter/ip_conntrack_tftp.c
--- linux-2.5/net/ipv4/netfilter/ip_conntrack_tftp.c	2004-12-04 20:13:32.000000000 +0100
+++ change/net/ipv4/netfilter/ip_conntrack_tftp.c	2004-12-04 19:34:43.000000000 +0100
@@ -123,6 +123,8 @@
 		tftp[i].flags = IP_CT_HELPER_F_REUSE_EXPECT;
 		tftp[i].me = THIS_MODULE;
 		tftp[i].help = tftp_help;
+		tftp[i].change_help = generic_change_help;
+		tftp[i].change_new_expect = generic_change_new_expect;
 
 		tmpname = &tftp_names[i][0];
 		if (ports[i] == TFTP_PORT)
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' linux-2.5/include/linux/netfilter_ipv4/ip_conntrack_helper.h change/include/linux/netfilter_ipv4/ip_conntrack_helper.h
--- linux-2.5/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2004-12-04 20:13:32.000000000 +0100
+++ change/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2004-12-04 20:02:28.000000000 +0100
@@ -18,6 +18,7 @@
 	unsigned int max_expected;	/* Maximum number of concurrent 
 					 * expected connections */
 	unsigned int timeout;		/* timeout for expecteds */
+	spinlock_t *lock;		/* protect private info and buffer */
 
 	/* Mask of things we will help (compared against server response) */
 	struct ip_conntrack_tuple tuple;
@@ -28,6 +29,11 @@
 	int (*help)(struct sk_buff *skb,
 		    struct ip_conntrack *ct,
 		    enum ip_conntrack_info conntrackinfo);
+
+	void (*change_help)(struct ip_conntrack *, union ip_conntrack_help *);
+	int (*change_new_expect)(struct ip_conntrack_expect *,
+				 union ip_conntrack_expect_proto *,
+				 union ip_conntrack_expect_help *);
 };
 
 extern int ip_conntrack_helper_register(struct ip_conntrack_helper *);
@@ -45,5 +51,10 @@
 extern int ip_conntrack_change_expect(struct ip_conntrack_expect *expect,
 				      struct ip_conntrack_tuple *newtuple);
 extern void ip_conntrack_unexpect_related(struct ip_conntrack_expect *exp);
+extern void generic_change_help(struct ip_conntrack *ct,
+				union ip_conntrack_help *h);
+extern int generic_change_new_expect(struct ip_conntrack_expect *exp,
+				     union ip_conntrack_expect_proto *p,
+				     union ip_conntrack_expect_help *h);
 
 #endif /*_IP_CONNTRACK_HELPER_H*/
Los ficheros binarios linux-2.5/include/linux/netfilter_ipv4/.ip_conntrack.h.swp y change/include/linux/netfilter_ipv4/.ip_conntrack.h.swp son distintos
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' linux-2.5/include/linux/netfilter_ipv4/ip_conntrack_protocol.h change/include/linux/netfilter_ipv4/ip_conntrack_protocol.h
--- linux-2.5/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2004-12-04 20:13:32.000000000 +0100
+++ change/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2004-12-04 19:37:57.000000000 +0100
@@ -13,6 +13,9 @@
 	/* Protocol name */
 	const char *name;
 
+	/* Lock which protects private proto stuff */
+	rwlock_t *lock;
+
 	/* Try to fill in the third arg: dataoff is offset past IP
            hdr.  Return true if possible. */
 	int (*pkt_to_tuple)(const struct sk_buff *skb,
@@ -51,6 +54,17 @@
 	int (*error)(struct sk_buff *skb, enum ip_conntrack_info *ctinfo,
 		     unsigned int hooknum);
 
+	/* check if tuples are valid for a new connection */
+	int (*change_check_tuples)(struct ip_conntrack_tuple *orig,
+				   struct ip_conntrack_tuple *reply);
+
+	/* check protocol data is valid */
+	int (*change_check_proto)(union ip_conntrack_proto *p);
+
+	/* change protocol info on behalf of ctnetlink */
+	void (*change_proto)(struct ip_conntrack *ct,
+			     union ip_conntrack_proto *p);
+
 	/* Module (if any) which this is connected to. */
 	struct module *me;
 };
@@ -67,6 +81,10 @@
 	return ip_ct_protos[protocol];
 }
 
+/* Change API */
+extern void generic_change_proto(struct ip_conntrack *conntrack,
+				 union ip_conntrack_proto *p);
+
 /* Existing built-in protocols */
 extern struct ip_conntrack_protocol ip_conntrack_protocol_tcp;
 extern struct ip_conntrack_protocol ip_conntrack_protocol_udp;

--------------060901080006020601050400--
