From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/8] Netfilter:  Call NAT Helper Modules Directly from
	Conntrack Modules, fixup FTP
Date: Tue, 11 Jan 2005 21:20:31 +1100
Message-ID: <1105438831.19331.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

Name: Call NAT Helper Modules Directly from Conntrack Modules, fixup FTP
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Status: Tested under nfsim

Currently connection tracking and NAT helper modules for a protocol
interact only indirectly (the conntrack module places information in
the conntrack structure, which the NAT module pulls out).

This leads to several issues:
1) Both modules must know what port to watch, and must match.
2) Identifying the particular packet which created the connection
   is cumbersome (TCP) or impossible (UDP).
3) The connection tracking code sets up an expectation which the
   NAT code then has to change.
4) The lack of direct symbol dependencies means we have to contrive
   one, since they are functionally dependent.

Here is the current code flow:
FTP CONTROL PACKET:
NF_IP_PRE_ROUTING:
   ip_conntrack_in
      resolve_normal_ct
         init_conntrack: sets ct->helper to ip_conntrack_ftp.c:help()
   ct->help(): if PORT/PASV command:
      Sets exp->help.exp_ftp_info to tcp seq number of data.
      ip_conntrack_expect(): expects the connection

   ip_nat_setup_info: sets ct->nat.info->helper to ip_nat_ftp.c:help()
   ip_nat_fn:
      proto->exp_matches_pkt: if packet matches expectation
      ct->nat.info->helper(): If packet going client->server,
            and packet data is one in ct_ftp_info:
         ftp_data_fixup():
            ip_conntrack_change_expect(): change the expectation
            Modify packet contents with new address.

NF_IP_POST_ROUTING:
   ip_nat_fn
      ct->nat.info->helper(): If packet going server->client,
            and packet data is one in ct_ftp_info:
         ftp_data_fixup():
            ip_conntrack_change_expect(): change the expectation
            Modify packet contents with new address.

FTP DATA (EXPECTED) CONNECTION FIRST PACKET:
NF_IP_PRE_ROUTING:
   ip_conntrack_in
      resolve_normal_ct
         init_conntrack: set ct->master.
   ip_nat_fn:
      master->nat.info.helper->expect()
         Set up source NAT mapping to match FTP control connection.

NF_IP_PRE_ROUTING:
   ip_nat_fn:
      master->nat.info.helper->expect()
         Set up dest NAT mapping to match FTP control connection.


The new flow looks like this:
FTP CONTROL PACKET:
NF_IP_PRE_ROUTING:
   ip_conntrack_in
      resolve_normal_ct
         init_conntrack: sets ct->helper to ip_conntrack_ftp.c:help()

NF_IP_POST_ROUTING:
   ip_confirm:
      ct->helper->help:
         If !ip_nat_ftp_hook: ip_conntrack_expect().
         ip_nat_ftp: 
            set exp->oldproto to old port.
            ip_conntrack_change_expect(): change the expectation
            set exp->expectfn to ftp_nat_expected.
            Modify packet contents with new address.

FTP DATA (EXPECTED) CONNECTION FIRST PACKET:
NF_IP_PRE_ROUTING:
   ip_conntrack_in
      resolve_normal_ct
         init_conntrack: set ct->master.
         call exp->expectfn (ftp_nat_expected):
             call ip_nat_follow_master().

The big changes are that the ip_nat_ftp module sets ip_conntrack_ftp's
ip_nat_ftp_hook when it initializes, so it calls the NAT code directly
when a packet containing the expect information is found by the
conntrack helper: and this interface can carry all the information
these two want to share.  Also, that conntrack helper is called as the
packet leaves the box, so there are no issues with expectations being
set up before the packet has been filtered.  The NAT helper doesn't
need to register and duplicate the conntrack ports.

The other trick is ip_nat_follow_master(), which does the NAT setup
all at once (source and destination NAT as required) such that the
expected connection is NATed the same way the master connection
was.

We also call ip_conntrack_tcp_update() (which I incidentally neatened)
after mangling a TCP packet; ip_nat_seq_adjust() does this, but now
mangling is done at the last possible moment, after
ip_nat_seq_adjust() was already called.

Index: linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2005-01-06 09:16:46.000000000 +1100
+++ linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2005-01-06 11:59:03.225275808 +1100
@@ -490,20 +490,6 @@
 	return 1;
 }
 
-static inline int exp_for_packet(struct ip_conntrack_expect *exp,
-			         struct sk_buff *skb)
-{
-	struct ip_conntrack_protocol *proto;
-	int ret = 1;
-
-	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
-	proto = ip_ct_find_proto(skb->nh.iph->protocol);
-	if (proto->exp_matches_pkt)
-		ret = proto->exp_matches_pkt(exp, skb);
-
-	return ret;
-}
-
 /* Do packet manipulations according to binding. */
 unsigned int
 do_bindings(struct ip_conntrack *ct,
@@ -512,8 +498,7 @@
 	    unsigned int hooknum,
 	    struct sk_buff **pskb)
 {
-	unsigned int i;
-	struct ip_nat_helper *helper;
+	int i, ret = NF_ACCEPT;
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	int proto = (*pskb)->nh.iph->protocol;
 
@@ -538,75 +523,32 @@
 			}
 		}
 	}
-	helper = info->helper;
-	READ_UNLOCK(&ip_nat_lock);
-
-	if (helper) {
-		struct ip_conntrack_expect *exp = NULL;
-		struct list_head *cur_item;
-		int ret = NF_ACCEPT;
-		int helper_called = 0;
 
+	if (info->helper) {
 		DEBUGP("do_bindings: helper existing for (%p)\n", ct);
 
 		/* Always defragged for helpers */
 		IP_NF_ASSERT(!((*pskb)->nh.iph->frag_off
 			       & htons(IP_MF|IP_OFFSET)));
 
-		/* Have to grab read lock before sibling_list traversal */
-		READ_LOCK(&ip_conntrack_lock);
-		list_for_each_prev(cur_item, &ct->sibling_list) { 
-			exp = list_entry(cur_item, struct ip_conntrack_expect, 
-					 expected_list);
-					 
-			/* if this expectation is already established, skip */
-			if (exp->sibling)
-				continue;
-
-			if (exp_for_packet(exp, *pskb)) {
-				/* FIXME: May be true multiple times in the
-				 * case of UDP!! */
-				DEBUGP("calling nat helper (exp=%p) for packet\n", exp);
-				ret = helper->help(ct, exp, info, ctinfo, 
-						   hooknum, pskb);
-				if (ret != NF_ACCEPT) {
-					READ_UNLOCK(&ip_conntrack_lock);
-					return ret;
-				}
-				helper_called = 1;
-			}
-		}
-		/* Helper might want to manip the packet even when there is no
-		 * matching expectation for this packet */
-		if (!helper_called && helper->flags & IP_NAT_HELPER_F_ALWAYS) {
-			DEBUGP("calling nat helper for packet without expectation\n");
-			ret = helper->help(ct, NULL, info, ctinfo, 
-					   hooknum, pskb);
-			if (ret != NF_ACCEPT) {
-				READ_UNLOCK(&ip_conntrack_lock);
-				return ret;
-			}
-		}
-		READ_UNLOCK(&ip_conntrack_lock);
-		
-		/* Adjust sequence number only once per packet 
-		 * (helper is called at all hooks) */
-		if (proto == IPPROTO_TCP
-		    && (hooknum == NF_IP_POST_ROUTING
-			|| hooknum == NF_IP_LOCAL_IN)) {
-			DEBUGP("ip_nat_core: adjusting sequence number\n");
-			/* future: put this in a l4-proto specific function,
-			 * and call this function here. */
-			if (!ip_nat_seq_adjust(pskb, ct, ctinfo))
-				ret = NF_DROP;
-		}
-
-		return ret;
+		ret = info->helper->help(ct, NULL, info, ctinfo, hooknum,pskb);
+	}
+	READ_UNLOCK(&ip_nat_lock);
 
-	} else 
-		return NF_ACCEPT;
+	/* FIXME: NAT/conntrack helpers should set ctinfo &
+	 * CT_INFO_RESYNC on packets, so we don't have to adjust all
+	 * connections with conntrack helpers --RR */
+	if (ct->helper
+	    && proto == IPPROTO_TCP
+	    && (hooknum == NF_IP_POST_ROUTING || hooknum == NF_IP_LOCAL_IN)) {
+		DEBUGP("ip_nat_core: adjusting sequence number\n");
+		/* future: put this in a l4-proto specific function,
+		 * and call this function here. */
+		if (!ip_nat_seq_adjust(pskb, ct, ctinfo))
+			ret = NF_DROP;
+	}
 
-	/* not reached */
+	return ret;
 }
 
 static inline int tuple_src_equal_dst(const struct ip_conntrack_tuple *t1,
Index: linux-2.6.10-bk8-Netfilter/include/linux/netfilter_ipv4/ip_nat_helper.h
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/include/linux/netfilter_ipv4/ip_nat_helper.h	2005-01-05 18:46:49.000000000 +1100
+++ linux-2.6.10-bk8-Netfilter/include/linux/netfilter_ipv4/ip_nat_helper.h	2005-01-06 12:00:48.676244824 +1100
@@ -30,12 +30,6 @@
 			     enum ip_conntrack_info ctinfo,
 			     unsigned int hooknum,
 			     struct sk_buff **pskb);
-
-	/* Returns verdict and sets up NAT for this connection */
-	unsigned int (*expect)(struct sk_buff **pskb,
-			       unsigned int hooknum,
-			       struct ip_conntrack *ct,
-			       struct ip_nat_info *info);
 };
 
 extern int ip_nat_helper_register(struct ip_nat_helper *me);
@@ -65,4 +59,8 @@
 extern int ip_nat_seq_adjust(struct sk_buff **pskb, 
 			     struct ip_conntrack *ct, 
 			     enum ip_conntrack_info ctinfo);
+
+/* Setup NAT on this expected conntrack so it follows master, but goes
+ * to port ct->master->saved_proto. */
+extern void ip_nat_follow_master(struct ip_conntrack *ct);
 #endif
Index: linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_nat_helper.c
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/net/ipv4/netfilter/ip_nat_helper.c	2005-01-06 09:12:00.000000000 +1100
+++ linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_nat_helper.c	2005-01-06 12:00:48.676244824 +1100
@@ -196,6 +196,8 @@
 	adjust_tcp_sequence(ntohl(tcph->seq),
 			    (int)rep_len - (int)match_len,
 			    ct, ctinfo);
+	/* Tell connection tracking about seq change, to expand window */
+	ip_conntrack_tcp_update(*pskb, ct, CTINFO2DIR(ctinfo));
 	return 1;
 }
 			
@@ -404,6 +406,49 @@
 	return 1;
 }
 
+/* We look at the master's nat fields without ip_nat_lock.  This works
+   because the master's NAT must be fully initialized, because we
+   don't match expectations set up by unconfirmed connections.  We
+   can't grab the lock because we hold the ip_conntrack_lock, and that
+   would be backwards from other locking orders. */
+static void ip_nat_copy_manip(struct ip_nat_info *master,
+			      struct ip_conntrack_expect *exp,
+			      struct ip_conntrack *ct)
+{
+	struct ip_nat_range range;
+	unsigned int i;
+
+	range.flags = IP_NAT_RANGE_MAP_IPS;
+
+	/* Find what master is mapped to (if any), so we can do the same. */
+	for (i = 0; i < master->num_manips; i++) {
+		if (master->manips[i].direction != exp->dir)
+			continue;
+
+		range.min_ip = range.max_ip = master->manips[i].manip.ip;
+
+		/* If this is a DST manip, map port here to where it's
+		 * expected. */
+		if (master->manips[i].maniptype == IP_NAT_MANIP_DST) {
+			range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
+			range.min = range.max = exp->saved_proto;
+		}
+		ip_nat_setup_info(ct, &range, master->manips[i].hooknum);
+	}
+}
+
+/* Setup NAT on this expected conntrack so it follows master. */
+/* If we fail to get a free NAT slot, we'll get dropped on confirm */
+void ip_nat_follow_master(struct ip_conntrack *ct)
+{
+	struct ip_nat_info *master = &ct->master->expectant->nat.info;
+
+	/* This must be a fresh one. */
+	BUG_ON(ct->nat.info.initialized);
+
+	ip_nat_copy_manip(master, ct->master, ct);
+}
+
 static inline int
 helper_cmp(const struct ip_nat_helper *helper,
 	   const struct ip_conntrack_tuple *tuple)
Index: linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-06 09:12:00.000000000 +1100
+++ linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-06 12:00:48.677244672 +1100
@@ -364,8 +364,20 @@
 			       const struct net_device *out,
 			       int (*okfn)(struct sk_buff *))
 {
+	struct ip_conntrack *ct;
+	enum ip_conntrack_info ctinfo;
+
+	/* This is where we call the helper: as the packet goes out. */
+	ct = ip_conntrack_get(*pskb, &ctinfo);
+	if (ct && ct->helper) {
+		unsigned int ret;
+		ret = ct->helper->help(pskb, ct, ctinfo);
+		if (ret != NF_ACCEPT)
+			return ret;
+	}
+
 	/* We've seen it coming out the other side: confirm it */
-	return ip_conntrack_confirm(*pskb);
+	return ip_conntrack_confirm(pskb);
 }
 
 static unsigned int ip_conntrack_defrag(unsigned int hooknum,
@@ -899,7 +911,6 @@
 EXPORT_SYMBOL(ip_ct_find_helper);
 EXPORT_SYMBOL(ip_conntrack_expect_alloc);
 EXPORT_SYMBOL(ip_conntrack_expect_related);
-EXPORT_SYMBOL(ip_conntrack_change_expect);
 EXPORT_SYMBOL(ip_conntrack_unexpect_related);
 EXPORT_SYMBOL_GPL(ip_conntrack_expect_find_get);
 EXPORT_SYMBOL_GPL(ip_conntrack_expect_put);
Index: linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_nat_ftp.c
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/net/ipv4/netfilter/ip_nat_ftp.c	2005-01-06 09:12:00.000000000 +1100
+++ linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_nat_ftp.c	2005-01-06 12:00:48.677244672 +1100
@@ -1,13 +1,3 @@
-/* FTP extension for TCP NAT alteration. */
-
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
 #include <linux/module.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/ip.h>
@@ -30,71 +20,8 @@
 #define DEBUGP(format, args...)
 #endif
 
-#define MAX_PORTS 8
-static int ports[MAX_PORTS];
-static int ports_c;
-
-module_param_array(ports, int, &ports_c, 0400);
-
 /* FIXME: Time out? --RR */
 
-static unsigned int
-ftp_nat_expected(struct sk_buff **pskb,
-		 unsigned int hooknum,
-		 struct ip_conntrack *ct,
-		 struct ip_nat_info *info)
-{
-	struct ip_nat_range range;
-	u_int32_t newdstip, newsrcip, newip;
-	struct ip_ct_ftp_expect *exp_ftp_info;
-
-	struct ip_conntrack *master = master_ct(ct);
-	
-	IP_NF_ASSERT(info);
-	IP_NF_ASSERT(master);
-
-	IP_NF_ASSERT(!(info->initialized & (1<<HOOK2MANIP(hooknum))));
-
-	DEBUGP("nat_expected: We have a connection!\n");
-	exp_ftp_info = &ct->master->help.exp_ftp_info;
-
-	if (exp_ftp_info->ftptype == IP_CT_FTP_PORT
-	    || exp_ftp_info->ftptype == IP_CT_FTP_EPRT) {
-		/* PORT command: make connection go to the client. */
-		newdstip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
-		newsrcip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
-		DEBUGP("nat_expected: PORT cmd. %u.%u.%u.%u->%u.%u.%u.%u\n",
-		       NIPQUAD(newsrcip), NIPQUAD(newdstip));
-	} else {
-		/* PASV command: make the connection go to the server */
-		newdstip = master->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
-		newsrcip = master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
-		DEBUGP("nat_expected: PASV cmd. %u.%u.%u.%u->%u.%u.%u.%u\n",
-		       NIPQUAD(newsrcip), NIPQUAD(newdstip));
-	}
-
-	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC)
-		newip = newsrcip;
-	else
-		newip = newdstip;
-
-	DEBUGP("nat_expected: IP to %u.%u.%u.%u\n", NIPQUAD(newip));
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
-				{ .tcp = { htons(exp_ftp_info->port) } });
-	}
-	return ip_nat_setup_info(ct, &range, hooknum);
-}
-
 static int
 mangle_rfc959_packet(struct sk_buff **pskb,
 		     u_int32_t newip,
@@ -102,7 +29,8 @@
 		     unsigned int matchoff,
 		     unsigned int matchlen,
 		     struct ip_conntrack *ct,
-		     enum ip_conntrack_info ctinfo)
+		     enum ip_conntrack_info ctinfo,
+		     u32 *seq)
 {
 	char buffer[sizeof("nnn,nnn,nnn,nnn,nnn,nnn")];
 
@@ -111,6 +39,7 @@
 
 	DEBUGP("calling ip_nat_mangle_tcp_packet\n");
 
+	*seq += strlen(buffer) - matchlen;
 	return ip_nat_mangle_tcp_packet(pskb, ct, ctinfo, matchoff, 
 					matchlen, buffer, strlen(buffer));
 }
@@ -123,7 +52,8 @@
 		   unsigned int matchoff,
 		   unsigned int matchlen,
 		   struct ip_conntrack *ct,
-		   enum ip_conntrack_info ctinfo)
+		   enum ip_conntrack_info ctinfo,
+		   u32 *seq)
 {
 	char buffer[sizeof("|1|255.255.255.255|65535|")];
 
@@ -131,6 +61,7 @@
 
 	DEBUGP("calling ip_nat_mangle_tcp_packet\n");
 
+	*seq += strlen(buffer) - matchlen;
 	return ip_nat_mangle_tcp_packet(pskb, ct, ctinfo, matchoff, 
 					matchlen, buffer, strlen(buffer));
 }
@@ -143,7 +74,8 @@
 		   unsigned int matchoff,
 		   unsigned int matchlen,
 		   struct ip_conntrack *ct,
-		   enum ip_conntrack_info ctinfo)
+		   enum ip_conntrack_info ctinfo,
+		   u32 *seq)
 {
 	char buffer[sizeof("|||65535|")];
 
@@ -151,6 +83,7 @@
 
 	DEBUGP("calling ip_nat_mangle_tcp_packet\n");
 
+	*seq += strlen(buffer) - matchlen;
 	return ip_nat_mangle_tcp_packet(pskb, ct, ctinfo, matchoff, 
 					matchlen, buffer, strlen(buffer));
 }
@@ -159,181 +92,77 @@
 		     unsigned int,
 		     unsigned int,
 		     struct ip_conntrack *,
-		     enum ip_conntrack_info)
+		     enum ip_conntrack_info,
+		     u32 *seq)
 = { [IP_CT_FTP_PORT] = mangle_rfc959_packet,
     [IP_CT_FTP_PASV] = mangle_rfc959_packet,
     [IP_CT_FTP_EPRT] = mangle_eprt_packet,
     [IP_CT_FTP_EPSV] = mangle_epsv_packet
 };
 
-static int ftp_data_fixup(const struct ip_ct_ftp_expect *exp_ftp_info,
-			  struct ip_conntrack *ct,
-			  struct sk_buff **pskb,
-			  u32 tcp_seq,
-			  enum ip_conntrack_info ctinfo,
-			  struct ip_conntrack_expect *expect)
+/* So, this packet has hit the connection tracking matching code.
+   Mangle it, and change the expectation to match the new version. */
+static unsigned int ip_nat_ftp(struct sk_buff **pskb,
+			       struct ip_conntrack *ct,
+			       enum ip_conntrack_info ctinfo,
+			       enum ip_ct_ftp_type type,
+			       unsigned int matchoff,
+			       unsigned int matchlen,
+			       struct ip_conntrack_expect *exp,
+			       u32 *seq)
 {
 	u_int32_t newip;
 	u_int16_t port;
-	struct ip_conntrack_tuple newtuple;
+	int dir = CTINFO2DIR(ctinfo);
 
-	DEBUGP("FTP_NAT: seq %u + %u in %u\n",
-	       expect->seq, exp_ftp_info->len, tcp_seq);
+	DEBUGP("FTP_NAT: type %i, off %u len %u\n", type, matchoff, matchlen);
 
-	/* Change address inside packet to match way we're mapping
-	   this connection. */
-	if (exp_ftp_info->ftptype == IP_CT_FTP_PASV
-	    || exp_ftp_info->ftptype == IP_CT_FTP_EPSV) {
-		/* PASV/EPSV response: must be where client thinks server
-		   is */
-		newip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
-		/* Expect something from client->server */
-		newtuple.src.ip = 
-			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
-		newtuple.dst.ip = 
-			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
-	} else {
-		/* PORT command: must be where server thinks client is */
-		newip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
-		/* Expect something from server->client */
-		newtuple.src.ip = 
-			ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
-		newtuple.dst.ip = 
-			ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
-	}
-	newtuple.dst.protonum = IPPROTO_TCP;
-	newtuple.src.u.tcp.port = expect->tuple.src.u.tcp.port;
+	/* Connection will come from wherever this packet goes, hence !dir */
+	newip = ct->tuplehash[!dir].tuple.dst.ip;
+	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
+	exp->dir = !dir;
+
+	/* When you see the packet, we need to NAT it the same as the
+	 * this one. */
+	exp->expectfn = ip_nat_follow_master;
 
 	/* Try to get same port: if not, try to change it. */
-	for (port = exp_ftp_info->port; port != 0; port++) {
-		newtuple.dst.u.tcp.port = htons(port);
-
-		if (ip_conntrack_change_expect(expect, &newtuple) == 0)
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
-	if (!mangle[exp_ftp_info->ftptype](pskb, newip, port,
-					  expect->seq - tcp_seq,
-					  exp_ftp_info->len, ct, ctinfo))
-		return 0;
 
-	return 1;
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
-	struct tcphdr _tcph, *tcph;
-	unsigned int datalen;
-	int dir;
-	struct ip_ct_ftp_expect *exp_ftp_info;
-
-	if (!exp)
-		DEBUGP("ip_nat_ftp: no exp!!");
-
-	exp_ftp_info = &exp->help.exp_ftp_info;
-
-	/* Only mangle things once: original direction in POST_ROUTING
-	   and reply direction on PRE_ROUTING. */
-	dir = CTINFO2DIR(ctinfo);
-	if (!((hooknum == NF_IP_POST_ROUTING && dir == IP_CT_DIR_ORIGINAL)
-	      || (hooknum == NF_IP_PRE_ROUTING && dir == IP_CT_DIR_REPLY))) {
-		DEBUGP("nat_ftp: Not touching dir %s at hook %s\n",
-		       dir == IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
-		       hooknum == NF_IP_POST_ROUTING ? "POSTROUTING"
-		       : hooknum == NF_IP_PRE_ROUTING ? "PREROUTING"
-		       : hooknum == NF_IP_LOCAL_OUT ? "OUTPUT" : "???");
-		return NF_ACCEPT;
+	if (port == 0) {
+		ip_conntrack_expect_put(exp);
+		return NF_DROP;
 	}
 
-	/* We passed tcp tracking, plus ftp helper: this must succeed. */
-	tcph = skb_header_pointer(*pskb, iph->ihl * 4, sizeof(_tcph), &_tcph);
-	BUG_ON(!tcph);
-
-	datalen = (*pskb)->len - iph->ihl * 4 - tcph->doff * 4;
-	/* If it's in the right range... */
-	if (between(exp->seq + exp_ftp_info->len,
-		    ntohl(tcph->seq),
-		    ntohl(tcph->seq) + datalen)) {
-		if (!ftp_data_fixup(exp_ftp_info, ct, pskb, ntohl(tcph->seq),
-				    ctinfo, exp))
-			return NF_DROP;
-	} else {
-		/* Half a match?  This means a partial retransmisison.
-		   It's a cracker being funky. */
-		if (net_ratelimit()) {
-			printk("FTP_NAT: partial packet %u/%u in %u/%u\n",
-			       exp->seq, exp_ftp_info->len,
-			       ntohl(tcph->seq),
-			       ntohl(tcph->seq) + datalen);
-		}
+	if (!mangle[type](pskb, newip, port, matchoff, matchlen, ct, ctinfo,
+			  seq)) {
+		ip_conntrack_unexpect_related(exp);
 		return NF_DROP;
 	}
 	return NF_ACCEPT;
 }
 
-static struct ip_nat_helper ftp[MAX_PORTS];
-static char ftp_names[MAX_PORTS][10];
-
-/* Not __exit: called from init() */
-static void fini(void)
+static void __exit fini(void)
 {
-	int i;
-
-	for (i = 0; i < ports_c; i++) {
-		DEBUGP("ip_nat_ftp: unregistering port %d\n", ports[i]);
-		ip_nat_helper_unregister(&ftp[i]);
-	}
+	ip_nat_ftp_hook = NULL;
+	/* Make sure noone calls it, meanwhile. */
+	synchronize_net();
 }
 
 static int __init init(void)
 {
-	int i, ret = 0;
-	char *tmpname;
-
-	if (ports_c == 0)
-		ports[ports_c++] = FTP_PORT;
-
-	for (i = 0; i < ports_c; i++) {
-		ftp[i].tuple.dst.protonum = IPPROTO_TCP;
-		ftp[i].tuple.src.u.tcp.port = htons(ports[i]);
-		ftp[i].mask.dst.protonum = 0xFFFF;
-		ftp[i].mask.src.u.tcp.port = 0xFFFF;
-		ftp[i].help = help;
-		ftp[i].me = THIS_MODULE;
-		ftp[i].flags = 0;
-		ftp[i].expect = ftp_nat_expected;
-
-		tmpname = &ftp_names[i][0];
-		if (ports[i] == FTP_PORT)
-			sprintf(tmpname, "ftp");
-		else
-			sprintf(tmpname, "ftp-%d", i);
-		ftp[i].name = tmpname;
-
-		DEBUGP("ip_nat_ftp: Trying to register for port %d\n",
-				ports[i]);
-		ret = ip_nat_helper_register(&ftp[i]);
-
-		if (ret) {
-			printk("ip_nat_ftp: error registering "
-			       "helper for port %d\n", ports[i]);
-			fini();
-			return ret;
-		}
-	}
-
-	return ret;
+	BUG_ON(ip_nat_ftp_hook);
+	ip_nat_ftp_hook = ip_nat_ftp;
+	return 0;
 }
 
-NEEDS_CONNTRACK(ftp);
-
 module_init(init);
 module_exit(fini);
Index: linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-01-06 09:12:00.000000000 +1100
+++ linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-01-06 11:59:03.229275200 +1100
@@ -707,9 +707,9 @@
 
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 /* Update sender->td_end after NAT successfully mangled the packet */
-int ip_conntrack_tcp_update(struct sk_buff *skb,
-			    struct ip_conntrack *conntrack, 
-			    int dir)
+void ip_conntrack_tcp_update(struct sk_buff *skb,
+			     struct ip_conntrack *conntrack, 
+			     enum ip_conntrack_dir dir)
 {
 	struct iphdr *iph = skb->nh.iph;
 	struct tcphdr *tcph = (void *)skb->nh.iph + skb->nh.iph->ihl*4;
@@ -735,8 +735,6 @@
 		sender->td_scale, 
 		receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
 		receiver->td_scale);
-		
-	return 1;
 }
  
 #endif
@@ -1061,22 +1059,6 @@
 	return 1;
 }
   
-static int tcp_exp_matches_pkt(struct ip_conntrack_expect *exp,
-			       const struct sk_buff *skb)
-{
-	const struct iphdr *iph = skb->nh.iph;
-	struct tcphdr *th, _tcph;
-	unsigned int datalen;
-
-	th = skb_header_pointer(skb, iph->ihl * 4,
-				sizeof(_tcph), &_tcph);
-	if (th == NULL)
-		return 0;
-	datalen = skb->len - iph->ihl*4 - th->doff*4;
-
-	return between(exp->seq, ntohl(th->seq), ntohl(th->seq) + datalen);
-}
-
 struct ip_conntrack_protocol ip_conntrack_protocol_tcp =
 {
 	.proto 			= IPPROTO_TCP,
@@ -1087,6 +1069,5 @@
 	.print_conntrack 	= tcp_print_conntrack,
 	.packet 		= tcp_packet,
 	.new 			= tcp_new,
-	.exp_matches_pkt	= tcp_exp_matches_pkt,
 	.error			= tcp_error,
 };
Index: linux-2.6.10-bk8-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-06 09:11:56.000000000 +1100
+++ linux-2.6.10-bk8-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-06 12:02:22.074046200 +1100
@@ -3,13 +3,6 @@
 /* Connection state tracking for netfilter.  This is separated from,
    but required by, the NAT layer; it can also be used by an iptables
    extension. */
-
-#include <linux/config.h>
-#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
-#include <linux/bitops.h>
-#include <linux/compiler.h>
-#include <asm/atomic.h>
-
 enum ip_conntrack_info
 {
 	/* Part of an established connection (either direction). */
@@ -49,6 +42,13 @@
 	IPS_CONFIRMED = (1 << IPS_CONFIRMED_BIT),
 };
 
+#ifdef __KERNEL__
+#include <linux/config.h>
+#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
+#include <linux/bitops.h>
+#include <linux/compiler.h>
+#include <asm/atomic.h>
+
 #include <linux/netfilter_ipv4/ip_conntrack_tcp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_icmp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_sctp.h>
@@ -70,20 +70,6 @@
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_irc.h>
 
-/* per expectation: application helper private data */
-union ip_conntrack_expect_help {
-	/* insert conntrack helper private data (expect) here */
-	struct ip_ct_amanda_expect exp_amanda_info;
-	struct ip_ct_ftp_expect exp_ftp_info;
-	struct ip_ct_irc_expect exp_irc_info;
-
-#ifdef CONFIG_IP_NF_NAT_NEEDED
-	union {
-		/* insert nat helper private data (expect) here */
-	} nat;
-#endif
-};
-
 /* per conntrack: application helper private data */
 union ip_conntrack_help {
 	/* insert conntrack helper private data (master) here */
@@ -100,8 +86,6 @@
 };
 #endif
 
-#ifdef __KERNEL__
-
 #include <linux/types.h>
 #include <linux/skbuff.h>
 
@@ -148,14 +132,17 @@
 	struct ip_conntrack_tuple tuple, mask;
 
 	/* Function to call after setup and insertion */
-	int (*expectfn)(struct ip_conntrack *new);
+	void (*expectfn)(struct ip_conntrack *new);
 
-	/* At which sequence number did this expectation occur */
-	u_int32_t seq;
-  
-	union ip_conntrack_expect_proto proto;
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+	/* This is the original per-proto part, used to map the
+	 * expected connection the way the recipient expects. */
+	union ip_conntrack_manip_proto saved_proto;
+	/* Direction relative to the master connection. */
+	enum ip_conntrack_dir dir;
+#endif
 
-	union ip_conntrack_expect_help help;
+	union ip_conntrack_expect_proto proto;
 };
 
 struct ip_conntrack_counter
@@ -267,9 +254,9 @@
 
 /* These are for NAT.  Icky. */
 /* Update TCP window tracking data when NAT mangles the packet */
-extern int ip_conntrack_tcp_update(struct sk_buff *skb,
-				   struct ip_conntrack *conntrack,
-				   int dir);
+extern void ip_conntrack_tcp_update(struct sk_buff *skb,
+				    struct ip_conntrack *conntrack,
+				    enum ip_conntrack_dir dir);
 
 /* Call me when a conntrack is destroyed. */
 extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);
Index: linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_conntrack_ftp.c
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-01-05 18:46:49.000000000 +1100
+++ linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-01-06 12:00:48.677244672 +1100
@@ -39,6 +39,16 @@
 static int loose;
 module_param(loose, int, 0600);
 
+unsigned int (*ip_nat_ftp_hook)(struct sk_buff **pskb,
+				struct ip_conntrack *ct,
+				enum ip_conntrack_info ctinfo,
+				enum ip_ct_ftp_type type,
+				unsigned int matchoff,
+				unsigned int matchlen,
+				struct ip_conntrack_expect *exp,
+				u32 *seq);
+EXPORT_SYMBOL_GPL(ip_nat_ftp_hook);
+
 #if 0
 #define DEBUGP printk
 #else
@@ -243,24 +253,53 @@
 	return 1;
 }
 
-static int help(struct sk_buff *skb,
+/* Look up to see if we're just after a \n. */
+static int find_nl_seq(u16 seq, const struct ip_ct_ftp_master *info, int dir)
+{
+	unsigned int i;
+
+	for (i = 0; i < info->seq_aft_nl_num[dir]; i++)
+		if (info->seq_aft_nl[dir][i] == seq)
+			return 1;
+	return 0;
+}
+
+/* We don't update if it's older than what we have. */
+static void update_nl_seq(u16 nl_seq, struct ip_ct_ftp_master *info, int dir)
+{
+	unsigned int i, oldest = NUM_SEQ_TO_REMEMBER;
+
+	/* Look for oldest: if we find exact match, we're done. */
+	for (i = 0; i < info->seq_aft_nl_num[dir]; i++) {
+		if (info->seq_aft_nl[dir][i] == nl_seq)
+			return;
+
+		if (oldest == info->seq_aft_nl_num[dir]
+		    || before(info->seq_aft_nl[dir][i], oldest))
+			oldest = i;
+	}
+
+	if (info->seq_aft_nl_num[dir] < NUM_SEQ_TO_REMEMBER)
+		info->seq_aft_nl[dir][info->seq_aft_nl_num[dir]++] = nl_seq;
+	else if (oldest != NUM_SEQ_TO_REMEMBER)
+		info->seq_aft_nl[dir][oldest] = nl_seq;
+}
+
+static int help(struct sk_buff **pskb,
 		struct ip_conntrack *ct,
 		enum ip_conntrack_info ctinfo)
 {
 	unsigned int dataoff, datalen;
 	struct tcphdr _tcph, *th;
 	char *fb_ptr;
-	u_int32_t old_seq_aft_nl;
-	int old_seq_aft_nl_set, ret;
-	u_int32_t array[6] = { 0 };
+	int ret;
+	u32 seq, array[6] = { 0 };
 	int dir = CTINFO2DIR(ctinfo);
 	unsigned int matchlen, matchoff;
 	struct ip_ct_ftp_master *ct_ftp_info = &ct->help.ct_ftp_info;
 	struct ip_conntrack_expect *exp;
-	struct ip_ct_ftp_expect *exp_ftp_info;
-
 	unsigned int i;
-	int found = 0;
+	int found = 0, ends_in_nl;
 
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo != IP_CT_ESTABLISHED
@@ -269,46 +308,35 @@
 		return NF_ACCEPT;
 	}
 
-	th = skb_header_pointer(skb, skb->nh.iph->ihl*4,
+	th = skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl*4,
 				sizeof(_tcph), &_tcph);
 	if (th == NULL)
 		return NF_ACCEPT;
 
-	dataoff = skb->nh.iph->ihl*4 + th->doff*4;
+	dataoff = (*pskb)->nh.iph->ihl*4 + th->doff*4;
 	/* No data? */
-	if (dataoff >= skb->len) {
-		DEBUGP("ftp: skblen = %u\n", skb->len);
+	if (dataoff >= (*pskb)->len) {
+		DEBUGP("ftp: pskblen = %u\n", (*pskb)->len);
 		return NF_ACCEPT;
 	}
-	datalen = skb->len - dataoff;
+	datalen = (*pskb)->len - dataoff;
 
 	LOCK_BH(&ip_ftp_lock);
-	fb_ptr = skb_header_pointer(skb, dataoff,
-				    skb->len - dataoff, ftp_buffer);
+	fb_ptr = skb_header_pointer(*pskb, dataoff,
+				    (*pskb)->len - dataoff, ftp_buffer);
 	BUG_ON(fb_ptr == NULL);
 
-	old_seq_aft_nl_set = ct_ftp_info->seq_aft_nl_set[dir];
-	old_seq_aft_nl = ct_ftp_info->seq_aft_nl[dir];
-
-	DEBUGP("conntrack_ftp: datalen %u\n", datalen);
-	if (fb_ptr[datalen - 1] == '\n') {
-		DEBUGP("conntrack_ftp: datalen %u ends in \\n\n", datalen);
-		if (!old_seq_aft_nl_set
-		    || after(ntohl(th->seq) + datalen, old_seq_aft_nl)) {
-			DEBUGP("conntrack_ftp: updating nl to %u\n",
-			       ntohl(th->seq) + datalen);
-			ct_ftp_info->seq_aft_nl[dir] = 
-						ntohl(th->seq) + datalen;
-			ct_ftp_info->seq_aft_nl_set[dir] = 1;
-		}
-	}
+	ends_in_nl = (fb_ptr[datalen - 1] == '\n');
+	seq = ntohl(th->seq) + datalen;
 
-	if(!old_seq_aft_nl_set ||
-			(ntohl(th->seq) != old_seq_aft_nl)) {
-		DEBUGP("ip_conntrack_ftp_help: wrong seq pos %s(%u)\n",
+	/* Look up to see if we're just after a \n. */
+	if (!find_nl_seq(ntohl(th->seq), ct_ftp_info, dir)) {
+		/* Now if this ends in \n, update ftp info. */
+		DEBUGP("ip_conntrack_ftp_help: wrong seq pos %s(%u) or %s(%u)\n",
+		       ct_ftp_info->seq_aft_nl[0][dir] 
 		       old_seq_aft_nl_set ? "":"(UNSET) ", old_seq_aft_nl);
 		ret = NF_ACCEPT;
-		goto out;
+		goto out_update_nl;
 	}
 
 	/* Initialize IP array to expected address (it's not mentioned
@@ -321,7 +349,7 @@
 	for (i = 0; i < ARRAY_SIZE(search); i++) {
 		if (search[i].dir != dir) continue;
 
-		found = find_pattern(fb_ptr, skb->len - dataoff,
+		found = find_pattern(fb_ptr, (*pskb)->len - dataoff,
 				     search[i].pattern,
 				     search[i].plen,
 				     search[i].skip,
@@ -344,7 +372,7 @@
 		goto out;
 	} else if (found == 0) { /* No match */
 		ret = NF_ACCEPT;
-		goto out;
+		goto out_update_nl;
 	}
 
 	DEBUGP("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
@@ -354,20 +382,17 @@
 	/* Allocate expectation which will be inserted */
 	exp = ip_conntrack_expect_alloc();
 	if (exp == NULL) {
-		ret = NF_ACCEPT;
+		ret = NF_DROP;
 		goto out;
 	}
 
-	exp_ftp_info = &exp->help.exp_ftp_info;
+	/* We refer to the reverse direction ("!dir") tuples here,
+	 * because we're expecting something in the other direction.
+	 * Doesn't matter unless NAT is happening.  */
+	exp->tuple.dst.ip = ct->tuplehash[!dir].tuple.dst.ip;
 
-	/* Update the ftp info */
 	if (htonl((array[0] << 24) | (array[1] << 16) | (array[2] << 8) | array[3])
-	    == ct->tuplehash[dir].tuple.src.ip) {
-		exp->seq = ntohl(th->seq) + matchoff;
-		exp_ftp_info->len = matchlen;
-		exp_ftp_info->ftptype = search[i].ftptype;
-		exp_ftp_info->port = array[4] << 8 | array[5];
-	} else {
+	    != ct->tuplehash[dir].tuple.src.ip) {
 		/* Enrico Scholz's passive FTP to partially RNAT'd ftp
 		   server: it really wants us to connect to a
 		   different IP address.  Simply don't record it for
@@ -381,28 +406,42 @@
 		   problem (DMZ machines opening holes to internal
 		   networks, or the packet filter itself). */
 		if (!loose) {
-			ip_conntrack_expect_put(exp);
 			ret = NF_ACCEPT;
-			goto out;
+			ip_conntrack_expect_put(exp);
+			goto out_update_nl;
 		}
+		exp->tuple.dst.ip = htonl((array[0] << 24) | (array[1] << 16)
+					 | (array[2] << 8) | array[3]);
 	}
 
-	exp->tuple = ((struct ip_conntrack_tuple)
-		{ { ct->tuplehash[!dir].tuple.src.ip,
-		    { 0 } },
-		  { htonl((array[0] << 24) | (array[1] << 16)
-			  | (array[2] << 8) | array[3]),
-		    { .tcp = { htons(array[4] << 8 | array[5]) } },
-		    IPPROTO_TCP }});
+	exp->tuple.src.ip = ct->tuplehash[!dir].tuple.src.ip;
+	exp->tuple.dst.u.tcp.port = htons(array[4] << 8 | array[5]);
+	exp->tuple.src.u.tcp.port = 0; /* Don't care. */
+	exp->tuple.dst.protonum = IPPROTO_TCP;
 	exp->mask = ((struct ip_conntrack_tuple)
 		{ { 0xFFFFFFFF, { 0 } },
 		  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFFFF }});
 
 	exp->expectfn = NULL;
 
-	/* Ignore failure; should only happen with NAT */
-	ip_conntrack_expect_related(exp, ct);
-	ret = NF_ACCEPT;
+	/* Now, NAT might want to mangle the packet, and register the
+	 * (possibly changed) expectation itself. */
+	if (ip_nat_ftp_hook)
+		ret = ip_nat_ftp_hook(pskb, ct, ctinfo, search[i].ftptype,
+				      matchoff, matchlen, exp, &seq);
+	else {
+		/* Can't expect this?  Best to drop packet now. */
+		if (ip_conntrack_expect_related(exp, ct) != 0)
+			ret = NF_DROP;
+		else
+			ret = NF_ACCEPT;
+	}
+
+out_update_nl:
+	/* Now if this ends in \n, update ftp info.  Seq may have been
+	 * adjusted by NAT code. */
+	if (ends_in_nl)
+		update_nl_seq(seq, ct_ftp_info,dir);
  out:
 	UNLOCK_BH(&ip_ftp_lock);
 	return ret;
@@ -460,7 +499,5 @@
 	return 0;
 }
 
-PROVIDES_CONNTRACK(ftp);
-
 module_init(init);
 module_exit(fini);
Index: linux-2.6.10-bk8-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_ftp.h
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_ftp.h	2005-01-05 18:46:49.000000000 +1100
+++ linux-2.6.10-bk8-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_ftp.h	2005-01-06 12:00:48.676244824 +1100
@@ -20,24 +20,25 @@
 	IP_CT_FTP_EPSV,
 };
 
-/* This structure is per expected connection */
-struct ip_ct_ftp_expect
-{
-	/* We record seq number and length of ftp ip/port text here: all in
-	 * host order. */
-
- 	/* sequence number of IP address in packet is in ip_conntrack_expect */
-	u_int32_t len;			/* length of IP address */
-	enum ip_ct_ftp_type ftptype;	/* PORT or PASV ? */
-	u_int16_t port; 		/* TCP port that was to be used */
-};
-
+#define NUM_SEQ_TO_REMEMBER 2
 /* This structure exists only once per master */
 struct ip_ct_ftp_master {
-	/* Next valid seq position for cmd matching after newline */
-	u_int32_t seq_aft_nl[IP_CT_DIR_MAX];
+	/* Valid seq positions for cmd matching after newline */
+	u_int32_t seq_aft_nl[IP_CT_DIR_MAX][NUM_SEQ_TO_REMEMBER];
 	/* 0 means seq_match_aft_nl not set */
-	int seq_aft_nl_set[IP_CT_DIR_MAX];
+	int seq_aft_nl_num[IP_CT_DIR_MAX];
 };
 
+struct ip_conntrack_expect;
+
+/* For NAT to hook in when we find a packet which describes what other
+ * connection we should expect. */
+extern unsigned int (*ip_nat_ftp_hook)(struct sk_buff **pskb,
+				       struct ip_conntrack *ct,
+				       enum ip_conntrack_info ctinfo,
+				       enum ip_ct_ftp_type type,
+				       unsigned int matchoff,
+				       unsigned int matchlen,
+				       struct ip_conntrack_expect *exp,
+				       u32 *seq);
 #endif /* _IP_CONNTRACK_FTP_H */
Index: linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_nat_standalone.c
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/net/ipv4/netfilter/ip_nat_standalone.c	2005-01-06 09:12:00.000000000 +1100
+++ linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_nat_standalone.c	2005-01-06 11:59:03.231274896 +1100
@@ -55,15 +55,6 @@
 			         : ((hooknum) == NF_IP_LOCAL_IN ? "LOCAL_IN"  \
 				    : "*ERROR*")))
 
-static inline int call_expect(struct ip_conntrack *master,
-			      struct sk_buff **pskb,
-			      unsigned int hooknum,
-			      struct ip_conntrack *ct,
-			      struct ip_nat_info *info)
-{
-	return master->nat.info.helper->expect(pskb, hooknum, ct, info);
-}
-
 static unsigned int
 ip_nat_fn(unsigned int hooknum,
 	  struct sk_buff **pskb,
@@ -131,21 +122,13 @@
 		if (!(info->initialized & (1 << maniptype))) {
 			unsigned int ret;
 
-			if (ct->master
-			    && master_ct(ct)->nat.info.helper
-			    && master_ct(ct)->nat.info.helper->expect) {
-				ret = call_expect(master_ct(ct), pskb, 
-						  hooknum, ct, info);
-			} else {
-				/* LOCAL_IN hook doesn't have a chain!  */
-				if (hooknum == NF_IP_LOCAL_IN)
-					ret = alloc_null_binding(ct, info,
-								 hooknum);
-				else
-					ret = ip_nat_rule_find(pskb, hooknum,
-					                       in, out, ct,
-					                       info);
-			}
+			/* LOCAL_IN hook doesn't have a chain!  */
+			if (hooknum == NF_IP_LOCAL_IN)
+				ret = alloc_null_binding(ct, info, hooknum);
+			else
+				ret = ip_nat_rule_find(pskb, hooknum,
+						       in, out, ct,
+						       info);
 
 			if (ret != NF_ACCEPT) {
 				WRITE_UNLOCK(&ip_nat_lock);
@@ -396,4 +379,5 @@
 EXPORT_SYMBOL(ip_nat_used_tuple);
 EXPORT_SYMBOL(ip_nat_find_helper);
 EXPORT_SYMBOL(__ip_nat_find_helper);
+EXPORT_SYMBOL(ip_nat_follow_master);
 MODULE_LICENSE("GPL");
Index: linux-2.6.10-bk8-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_protocol.h
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2005-01-05 18:46:49.000000000 +1100
+++ linux-2.6.10-bk8-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2005-01-06 11:59:03.232274744 +1100
@@ -44,10 +44,6 @@
 	/* Called when a conntrack entry is destroyed */
 	void (*destroy)(struct ip_conntrack *conntrack);
 
-	/* Has to decide if a expectation matches one packet or not */
-	int (*exp_matches_pkt)(struct ip_conntrack_expect *exp,
-			       const struct sk_buff *skb);
-
 	int (*error)(struct sk_buff *skb, enum ip_conntrack_info *ctinfo,
 		     unsigned int hooknum);
 
Index: linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-01-06 09:12:00.000000000 +1100
+++ linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-01-06 11:59:03.232274744 +1100
@@ -494,13 +494,6 @@
 	return 1;
 }
 
-static int sctp_exp_matches_pkt(struct ip_conntrack_expect *exp,
-				const struct sk_buff *skb)
-{
-	/* To be implemented */
-	return 0;
-}
-
 struct ip_conntrack_protocol ip_conntrack_protocol_sctp = { 
 	.proto 		 = IPPROTO_SCTP, 
 	.name 		 = "sctp",
@@ -511,7 +504,6 @@
 	.packet 	 = sctp_packet, 
 	.new 		 = sctp_new, 
 	.destroy 	 = NULL, 
-	.exp_matches_pkt = sctp_exp_matches_pkt, 
 	.me 		 = THIS_MODULE 
 };
 
Index: linux-2.6.10-bk8-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_core.h
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-01-05 18:46:49.000000000 +1100
+++ linux-2.6.10-bk8-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-01-06 12:00:48.676244824 +1100
@@ -34,14 +34,14 @@
 ip_conntrack_find_get(const struct ip_conntrack_tuple *tuple,
 		      const struct ip_conntrack *ignored_conntrack);
 
-extern int __ip_conntrack_confirm(struct sk_buff *skb);
+extern int __ip_conntrack_confirm(struct sk_buff **pskb);
 
 /* Confirm a connection: returns NF_DROP if packet must be dropped. */
-static inline int ip_conntrack_confirm(struct sk_buff *skb)
+static inline int ip_conntrack_confirm(struct sk_buff **pskb)
 {
-	if (skb->nfct
-	    && !is_confirmed((struct ip_conntrack *)skb->nfct))
-		return __ip_conntrack_confirm(skb);
+	if ((*pskb)->nfct
+	    && !is_confirmed((struct ip_conntrack *)(*pskb)->nfct))
+		return __ip_conntrack_confirm(pskb);
 	return NF_ACCEPT;
 }
 
Index: linux-2.6.10-bk8-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_helper.h
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2005-01-05 18:46:49.000000000 +1100
+++ linux-2.6.10-bk8-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2005-01-06 12:00:48.676244824 +1100
@@ -25,7 +25,7 @@
 	
 	/* Function to call when data passes; return verdict, or -1 to
            invalidate. */
-	int (*help)(struct sk_buff *skb,
+	int (*help)(struct sk_buff **pskb,
 		    struct ip_conntrack *ct,
 		    enum ip_conntrack_info conntrackinfo);
 };
@@ -42,8 +42,6 @@
 /* Add an expected connection: can have more than one per connection */
 extern int ip_conntrack_expect_related(struct ip_conntrack_expect *exp,
 				       struct ip_conntrack *related_to);
-extern int ip_conntrack_change_expect(struct ip_conntrack_expect *expect,
-				      struct ip_conntrack_tuple *newtuple);
 extern void ip_conntrack_unexpect_related(struct ip_conntrack_expect *exp);
 
 #endif /*_IP_CONNTRACK_HELPER_H*/
Index: linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.10-bk8-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-06 11:59:03.153286752 +1100
+++ linux-2.6.10-bk8-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-06 12:02:38.174598544 +1100
@@ -394,13 +394,13 @@
 
 /* Confirm a connection given skb; places it in hash table */
 int
-__ip_conntrack_confirm(struct sk_buff *skb)
+__ip_conntrack_confirm(struct sk_buff **pskb)
 {
 	unsigned int hash, repl_hash;
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 
-	ct = ip_conntrack_get(skb, &ctinfo);
+	ct = ip_conntrack_get(*pskb, &ctinfo);
 
 	/* ipt_REJECT uses ip_conntrack_attach to attach related
 	   ICMP/TCP RST packets in other direction.  Actual packet
@@ -782,16 +782,6 @@
 		return -ret;
 	}
 
-	if (ret != NF_DROP && ct->helper) {
-		ret = ct->helper->help(*pskb, ct, ctinfo);
-		if (ret == -1) {
-			/* Invalid */
-			CONNTRACK_STAT_INC(invalid);
-			nf_conntrack_put((*pskb)->nfct);
-			(*pskb)->nfct = NULL;
-			return NF_ACCEPT;
-		}
-	}
 	if (set_reply)
 		set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
 
@@ -947,7 +937,7 @@
 				       related_to->helper->name,
  		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
  		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip));
-			ip_conntrack_expect_put(expect);	
+			ip_conntrack_expect_put(expect);
 			return -EPERM;
 		}
 		DEBUGP("ip_conntrack: max number of expected "
@@ -981,7 +971,7 @@
 		WRITE_UNLOCK(&ip_conntrack_lock);
 		DEBUGP("expect_related: busy!\n");
 
-		ip_conntrack_expect_put(expect);	
+		ip_conntrack_expect_put(expect);
 		return -EBUSY;
 	}
 
@@ -994,47 +984,6 @@
 	return ret;
 }
 
-/* Change tuple in an existing expectation */
-int ip_conntrack_change_expect(struct ip_conntrack_expect *expect,
-			       struct ip_conntrack_tuple *newtuple)
-{
-	int ret;
-
-	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
-	WRITE_LOCK(&ip_conntrack_expect_tuple_lock);
-
-	DEBUGP("change_expect:\n");
-	DEBUGP("exp tuple: "); DUMP_TUPLE(&expect->tuple);
-	DEBUGP("exp mask:  "); DUMP_TUPLE(&expect->mask);
-	DEBUGP("newtuple:  "); DUMP_TUPLE(newtuple);
-	if (expect->ct_tuple.dst.protonum == 0) {
-		/* Never seen before */
-		DEBUGP("change expect: never seen before\n");
-		if (!ip_ct_tuple_equal(&expect->tuple, newtuple) 
-		    && LIST_FIND(&ip_conntrack_expect_list, expect_clash,
-			         struct ip_conntrack_expect *, newtuple, &expect->mask)) {
-			/* Force NAT to find an unused tuple */
-			ret = -1;
-		} else {
-			memcpy(&expect->ct_tuple, &expect->tuple, sizeof(expect->tuple));
-			memcpy(&expect->tuple, newtuple, sizeof(expect->tuple));
-			ret = 0;
-		}
-	} else {
-		/* Resent packet */
-		DEBUGP("change expect: resent packet\n");
-		if (ip_ct_tuple_equal(&expect->tuple, newtuple)) {
-			ret = 0;
-		} else {
-			/* Force NAT to choose again the same port */
-			ret = -1;
-		}
-	}
-	WRITE_UNLOCK(&ip_conntrack_expect_tuple_lock);
-	
-	return ret;
-}
-
 /* Alter reply tuple (maybe alter helper).  This is for NAT, and is
    implicitly racy: see __ip_conntrack_confirm */
 void ip_conntrack_alter_reply(struct ip_conntrack *conntrack,
