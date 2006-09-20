From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 26/39]: PPTP conntrack: fix whitespace errors
Date: Wed, 20 Sep 2006 10:24:25 +0200 (MEST)
Message-ID: <20060920082516.14636.7148.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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

[NETFILTER]: PPTP conntrack: fix whitespace errors

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fdb933d1bab11555cfd4e89823329deabec5a44b
tree c0f568e1aeb6f1f92265aad748942ebd313333a4
parent 6e24611afad533e7fe460dafcb14812a5591ce17
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:38:49 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:38:49 +0200

 include/linux/netfilter_ipv4/ip_conntrack_pptp.h |   26 +++---
 net/ipv4/netfilter/ip_conntrack_helper_pptp.c    |   76 +++++++++---------
 net/ipv4/netfilter/ip_conntrack_proto_gre.c      |   28 +++----
 net/ipv4/netfilter/ip_nat_helper_pptp.c          |   92 +++++++++++-----------
 net/ipv4/netfilter/ip_nat_proto_gre.c            |   20 ++---
 5 files changed, 121 insertions(+), 121 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack_pptp.h b/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
index 816144c..88f66d3 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
@@ -285,19 +285,19 @@ struct PptpSetLinkInfo {
 };
 
 union pptp_ctrl_union {
-		struct PptpStartSessionRequest	sreq;
-		struct PptpStartSessionReply	srep;
-		struct PptpStopSessionRequest	streq;
-		struct PptpStopSessionReply	strep;
-                struct PptpOutCallRequest       ocreq;
-                struct PptpOutCallReply         ocack;
-                struct PptpInCallRequest        icreq;
-                struct PptpInCallReply          icack;
-                struct PptpInCallConnected      iccon;
-		struct PptpClearCallRequest	clrreq;
-                struct PptpCallDisconnectNotify disc;
-                struct PptpWanErrorNotify       wanerr;
-                struct PptpSetLinkInfo          setlink;
+	struct PptpStartSessionRequest	sreq;
+	struct PptpStartSessionReply	srep;
+	struct PptpStopSessionRequest	streq;
+	struct PptpStopSessionReply	strep;
+	struct PptpOutCallRequest	ocreq;
+	struct PptpOutCallReply		ocack;
+	struct PptpInCallRequest	icreq;
+	struct PptpInCallReply		icack;
+	struct PptpInCallConnected	iccon;
+	struct PptpClearCallRequest	clrreq;
+	struct PptpCallDisconnectNotify disc;
+	struct PptpWanErrorNotify	wanerr;
+	struct PptpSetLinkInfo		setlink;
 };
 
 extern int
diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
index b020a33..6c94dd5 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -20,11 +20,11 @@
  * 	 - We can only support one single call within each session
  *
  * TODO:
- *	 - testing of incoming PPTP calls 
+ *	 - testing of incoming PPTP calls
  *
- * Changes: 
+ * Changes:
  * 	2002-02-05 - Version 1.3
- * 	  - Call ip_conntrack_unexpect_related() from 
+ * 	  - Call ip_conntrack_unexpect_related() from
  * 	    pptp_destroy_siblings() to destroy expectations in case
  * 	    CALL_DISCONNECT_NOTIFY or tcp fin packet was seen
  * 	    (Philip Craig <philipc@snapgear.com>)
@@ -141,7 +141,7 @@ static void pptp_expectfn(struct ip_conn
 		invert_tuplepr(&inv_t, &exp->tuple);
 		DEBUGP("trying to unexpect other dir: ");
 		DUMP_TUPLE(&inv_t);
-	
+
 		exp_other = ip_conntrack_expect_find(&inv_t);
 		if (exp_other) {
 			/* delete other expectation.  */
@@ -194,7 +194,7 @@ static void pptp_destroy_siblings(struct
 {
 	struct ip_conntrack_tuple t;
 
-	/* Since ct->sibling_list has literally rusted away in 2.6.11, 
+	/* Since ct->sibling_list has literally rusted away in 2.6.11,
 	 * we now need another way to find out about our sibling
 	 * contrack and expects... -HW */
 
@@ -264,7 +264,7 @@ exp_gre(struct ip_conntrack *master,
 	exp_orig->mask.dst.u.gre.key = htons(0xffff);
 	exp_orig->mask.dst.ip = 0xffffffff;
 	exp_orig->mask.dst.protonum = 0xff;
-		
+
 	exp_orig->master = master;
 	exp_orig->expectfn = pptp_expectfn;
 	exp_orig->flags = 0;
@@ -322,7 +322,7 @@ out_unexpect_orig:
 	goto out_put_both;
 }
 
-static inline int 
+static inline int
 pptp_inbound_pkt(struct sk_buff **pskb,
 		 struct tcphdr *tcph,
 		 unsigned int nexthdr_off,
@@ -336,7 +336,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 	struct ip_ct_pptp_master *info = &ct->help.ct_pptp_info;
 	u_int16_t msg;
 	__be16 *cid, *pcid;
-	u_int32_t seq;	
+	u_int32_t seq;
 
 	ctlh = skb_header_pointer(*pskb, nexthdr_off, sizeof(_ctlh), &_ctlh);
 	if (!ctlh) {
@@ -373,7 +373,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		}
 		if (pptpReq->srep.resultCode == PPTP_START_OK)
 			info->sstate = PPTP_SESSION_CONFIRMED;
-		else 
+		else
 			info->sstate = PPTP_SESSION_ERROR;
 		break;
 
@@ -420,22 +420,22 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		pcid = &pptpReq->ocack.peersCallID;
 
 		info->pac_call_id = ntohs(*cid);
-		
+
 		if (htons(info->pns_call_id) != *pcid) {
 			DEBUGP("%s for unknown callid %u\n",
 				pptp_msg_name[msg], ntohs(*pcid));
 			break;
 		}
 
-		DEBUGP("%s, CID=%X, PCID=%X\n", pptp_msg_name[msg], 
+		DEBUGP("%s, CID=%X, PCID=%X\n", pptp_msg_name[msg],
 			ntohs(*cid), ntohs(*pcid));
-		
+
 		info->cstate = PPTP_CALL_OUT_CONF;
 
 		seq = ntohl(tcph->seq) + sizeof(struct pptp_pkt_hdr)
 				       + sizeof(struct PptpControlHeader)
 				       + ((void *)pcid - (void *)pptpReq);
-			
+
 		if (exp_gre(ct, seq, *cid, *pcid) != 0)
 			printk("ip_conntrack_pptp: error during exp_gre\n");
 		break;
@@ -479,7 +479,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		cid = &info->pac_call_id;
 
 		if (info->pns_call_id != ntohs(*pcid)) {
-			DEBUGP("%s for unknown CallID %u\n", 
+			DEBUGP("%s for unknown CallID %u\n",
 				pptp_msg_name[msg], ntohs(*pcid));
 			break;
 		}
@@ -491,7 +491,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		seq = ntohl(tcph->seq) + sizeof(struct pptp_pkt_hdr)
 				       + sizeof(struct PptpControlHeader)
 				       + ((void *)pcid - (void *)pptpReq);
-			
+
 		if (exp_gre(ct, seq, *cid, *pcid) != 0)
 			printk("ip_conntrack_pptp: error during exp_gre\n");
 
@@ -554,7 +554,7 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		return NF_ACCEPT;
 	nexthdr_off += sizeof(_ctlh);
 	datalen -= sizeof(_ctlh);
-	
+
 	reqlen = datalen;
 	if (reqlen > sizeof(*pptpReq))
 		reqlen = sizeof(*pptpReq);
@@ -606,7 +606,7 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		/* client answers incoming call */
 		if (info->cstate != PPTP_CALL_IN_REQ
 		    && info->cstate != PPTP_CALL_IN_REP) {
-			DEBUGP("%s without incall_req\n", 
+			DEBUGP("%s without incall_req\n",
 				pptp_msg_name[msg]);
 			break;
 		}
@@ -616,7 +616,7 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		}
 		pcid = &pptpReq->icack.peersCallID;
 		if (info->pac_call_id != ntohs(*pcid)) {
-			DEBUGP("%s for unknown call %u\n", 
+			DEBUGP("%s for unknown call %u\n",
 				pptp_msg_name[msg], ntohs(*pcid));
 			break;
 		}
@@ -644,12 +644,12 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		/* I don't have to explain these ;) */
 		break;
 	default:
-		DEBUGP("invalid %s (TY=%d)\n", (msg <= PPTP_MSG_MAX)? 
+		DEBUGP("invalid %s (TY=%d)\n", (msg <= PPTP_MSG_MAX)?
 			pptp_msg_name[msg]:pptp_msg_name[0], msg);
 		/* unknown: no need to create GRE masq table entry */
 		break;
 	}
-	
+
 	if (ip_nat_pptp_hook_outbound)
 		return ip_nat_pptp_hook_outbound(pskb, ct, ctinfo, ctlh,
 						 pptpReq);
@@ -659,7 +659,7 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 
 
 /* track caller id inside control connection, call expect_related */
-static int 
+static int
 conntrack_pptp_help(struct sk_buff **pskb,
 		    struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
 
@@ -676,12 +676,12 @@ conntrack_pptp_help(struct sk_buff **psk
 	int ret;
 
 	/* don't do any tracking before tcp handshake complete */
-	if (ctinfo != IP_CT_ESTABLISHED 
+	if (ctinfo != IP_CT_ESTABLISHED
 	    && ctinfo != IP_CT_ESTABLISHED+IP_CT_IS_REPLY) {
 		DEBUGP("ctinfo = %u, skipping\n", ctinfo);
 		return NF_ACCEPT;
 	}
-	
+
 	nexthdr_off = (*pskb)->nh.iph->ihl*4;
 	tcph = skb_header_pointer(*pskb, nexthdr_off, sizeof(_tcph), &_tcph);
 	BUG_ON(!tcph);
@@ -735,28 +735,28 @@ conntrack_pptp_help(struct sk_buff **psk
 }
 
 /* control protocol helper */
-static struct ip_conntrack_helper pptp = { 
+static struct ip_conntrack_helper pptp = {
 	.list = { NULL, NULL },
-	.name = "pptp", 
+	.name = "pptp",
 	.me = THIS_MODULE,
 	.max_expected = 2,
 	.timeout = 5 * 60,
-	.tuple = { .src = { .ip = 0, 
-		 	    .u = { .tcp = { .port =  
-				    __constant_htons(PPTP_CONTROL_PORT) } } 
-			  }, 
-		   .dst = { .ip = 0, 
+	.tuple = { .src = { .ip = 0,
+		 	    .u = { .tcp = { .port =
+				    __constant_htons(PPTP_CONTROL_PORT) } }
+			  },
+		   .dst = { .ip = 0,
 			    .u = { .all = 0 },
 			    .protonum = IPPROTO_TCP
-			  } 
+			  }
 		 },
-	.mask = { .src = { .ip = 0, 
-			   .u = { .tcp = { .port = __constant_htons(0xffff) } } 
-			 }, 
-		  .dst = { .ip = 0, 
+	.mask = { .src = { .ip = 0,
+			   .u = { .tcp = { .port = __constant_htons(0xffff) } }
+			 },
+		  .dst = { .ip = 0,
 			   .u = { .all = 0 },
-			   .protonum = 0xff 
-		 	 } 
+			   .protonum = 0xff
+		 	 }
 		},
 	.help = conntrack_pptp_help
 };
@@ -768,7 +768,7 @@ extern int __init ip_ct_proto_gre_init(v
 static int __init ip_conntrack_helper_pptp_init(void)
 {
 	int retcode;
- 
+
 	retcode = ip_ct_proto_gre_init();
 	if (retcode < 0)
 		return retcode;
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_gre.c b/net/ipv4/netfilter/ip_conntrack_proto_gre.c
index 92c6d8b..5fe026f 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_gre.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_gre.c
@@ -1,15 +1,15 @@
 /*
- * ip_conntrack_proto_gre.c - Version 3.0 
+ * ip_conntrack_proto_gre.c - Version 3.0
  *
  * Connection tracking protocol helper module for GRE.
  *
  * GRE is a generic encapsulation protocol, which is generally not very
  * suited for NAT, as it has no protocol-specific part as port numbers.
  *
- * It has an optional key field, which may help us distinguishing two 
+ * It has an optional key field, which may help us distinguishing two
  * connections between the same two hosts.
  *
- * GRE is defined in RFC 1701 and RFC 1702, as well as RFC 2784 
+ * GRE is defined in RFC 1701 and RFC 1702, as well as RFC 2784
  *
  * PPTP is built on top of a modified version of GRE, and has a mandatory
  * field called "CallID", which serves us for the same purpose as the key
@@ -61,7 +61,7 @@ #else
 #define DEBUGP(x, args...)
 #define DUMP_TUPLE_GRE(x)
 #endif
-				
+
 /* GRE KEYMAP HANDLING FUNCTIONS */
 static LIST_HEAD(gre_keymap_list);
 
@@ -88,7 +88,7 @@ static __be16 gre_keymap_lookup(struct i
 		}
 	}
 	read_unlock_bh(&ip_ct_gre_lock);
-	
+
 	DEBUGP("lookup src key 0x%x up key for ", key);
 	DUMP_TUPLE_GRE(t);
 
@@ -107,7 +107,7 @@ ip_ct_gre_keymap_add(struct ip_conntrack
 		return -1;
 	}
 
-	if (!reply) 
+	if (!reply)
 		exist_km = &ct->help.ct_pptp_info.keymap_orig;
 	else
 		exist_km = &ct->help.ct_pptp_info.keymap_reply;
@@ -118,7 +118,7 @@ ip_ct_gre_keymap_add(struct ip_conntrack
 			if (gre_key_cmpfn(km, t) && km == *exist_km)
 				return 0;
 		}
-		DEBUGP("trying to override keymap_%s for ct %p\n", 
+		DEBUGP("trying to override keymap_%s for ct %p\n",
 			reply? "reply":"orig", ct);
 		return -EEXIST;
 	}
@@ -152,7 +152,7 @@ void ip_ct_gre_keymap_destroy(struct ip_
 
 	write_lock_bh(&ip_ct_gre_lock);
 	if (ct->help.ct_pptp_info.keymap_orig) {
-		DEBUGP("removing %p from list\n", 
+		DEBUGP("removing %p from list\n",
 			ct->help.ct_pptp_info.keymap_orig);
 		list_del(&ct->help.ct_pptp_info.keymap_orig->list);
 		kfree(ct->help.ct_pptp_info.keymap_orig);
@@ -220,7 +220,7 @@ static int gre_pkt_to_tuple(const struct
 static int gre_print_tuple(struct seq_file *s,
 			   const struct ip_conntrack_tuple *tuple)
 {
-	return seq_printf(s, "srckey=0x%x dstkey=0x%x ", 
+	return seq_printf(s, "srckey=0x%x dstkey=0x%x ",
 			  ntohs(tuple->src.u.gre.key),
 			  ntohs(tuple->dst.u.gre.key));
 }
@@ -250,14 +250,14 @@ static int gre_packet(struct ip_conntrac
 	} else
 		ip_ct_refresh_acct(ct, conntrackinfo, skb,
 				   ct->proto.gre.timeout);
-	
+
 	return NF_ACCEPT;
 }
 
 /* Called when a new connection for this protocol found. */
 static int gre_new(struct ip_conntrack *ct,
 		   const struct sk_buff *skb)
-{ 
+{
 	DEBUGP(": ");
 	DUMP_TUPLE_GRE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 
@@ -283,9 +283,9 @@ static void gre_destroy(struct ip_conntr
 }
 
 /* protocol helper struct */
-static struct ip_conntrack_protocol gre = { 
+static struct ip_conntrack_protocol gre = {
 	.proto		 = IPPROTO_GRE,
-	.name		 = "gre", 
+	.name		 = "gre",
 	.pkt_to_tuple	 = gre_pkt_to_tuple,
 	.invert_tuple	 = gre_invert_tuple,
 	.print_tuple	 = gre_print_tuple,
@@ -323,7 +323,7 @@ void ip_ct_proto_gre_fini(void)
 	}
 	write_unlock_bh(&ip_ct_gre_lock);
 
-	ip_conntrack_protocol_unregister(&gre); 
+	ip_conntrack_protocol_unregister(&gre);
 }
 
 EXPORT_SYMBOL(ip_ct_gre_keymap_add);
diff --git a/net/ipv4/netfilter/ip_nat_helper_pptp.c b/net/ipv4/netfilter/ip_nat_helper_pptp.c
index 1d14996..5dde1da 100644
--- a/net/ipv4/netfilter/ip_nat_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_nat_helper_pptp.c
@@ -32,7 +32,7 @@
  *     2005-06-10 - Version 3.0
  *       - kernel >= 2.6.11 version,
  *	   funded by Oxcoda NetBox Blue (http://www.netboxblue.com/)
- * 
+ *
  */
 
 #include <linux/module.h>
@@ -93,10 +93,10 @@ static void pptp_nat_expected(struct ip_
 		DEBUGP("we are PAC->PNS\n");
 		/* build tuple for PNS->PAC */
 		t.src.ip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
-		t.src.u.gre.key = 
+		t.src.u.gre.key =
 			htons(master->nat.help.nat_pptp_info.pns_call_id);
 		t.dst.ip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
-		t.dst.u.gre.key = 
+		t.dst.u.gre.key =
 			htons(master->nat.help.nat_pptp_info.pac_call_id);
 		t.dst.protonum = IPPROTO_GRE;
 	}
@@ -153,47 +153,47 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 	unsigned int cid_off;
 
 	new_callid = htons(ct_pptp_info->pns_call_id);
-	
+
 	switch (msg = ntohs(ctlh->messageType)) {
-		case PPTP_OUT_CALL_REQUEST:
-			cid_off = offsetof(union pptp_ctrl_union, ocreq.callID);
-			/* FIXME: ideally we would want to reserve a call ID
-			 * here.  current netfilter NAT core is not able to do
-			 * this :( For now we use TCP source port. This breaks
-			 * multiple calls within one control session */
-
-			/* save original call ID in nat_info */
-			nat_pptp_info->pns_call_id = ct_pptp_info->pns_call_id;
-
-			/* don't use tcph->source since we are at a DSTmanip
-			 * hook (e.g. PREROUTING) and pkt is not mangled yet */
-			new_callid = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.tcp.port;
-
-			/* save new call ID in ct info */
-			ct_pptp_info->pns_call_id = ntohs(new_callid);
-			break;
-		case PPTP_IN_CALL_REPLY:
-			cid_off = offsetof(union pptp_ctrl_union, icreq.callID);
-			break;
-		case PPTP_CALL_CLEAR_REQUEST:
-			cid_off = offsetof(union pptp_ctrl_union, clrreq.callID);
-			break;
-		default:
-			DEBUGP("unknown outbound packet 0x%04x:%s\n", msg,
-			      (msg <= PPTP_MSG_MAX)? 
-			      pptp_msg_name[msg]:pptp_msg_name[0]);
-			/* fall through */
-
-		case PPTP_SET_LINK_INFO:
-			/* only need to NAT in case PAC is behind NAT box */
-		case PPTP_START_SESSION_REQUEST:
-		case PPTP_START_SESSION_REPLY:
-		case PPTP_STOP_SESSION_REQUEST:
-		case PPTP_STOP_SESSION_REPLY:
-		case PPTP_ECHO_REQUEST:
-		case PPTP_ECHO_REPLY:
-			/* no need to alter packet */
-			return NF_ACCEPT;
+	case PPTP_OUT_CALL_REQUEST:
+		cid_off = offsetof(union pptp_ctrl_union, ocreq.callID);
+		/* FIXME: ideally we would want to reserve a call ID
+		 * here.  current netfilter NAT core is not able to do
+		 * this :( For now we use TCP source port. This breaks
+		 * multiple calls within one control session */
+
+		/* save original call ID in nat_info */
+		nat_pptp_info->pns_call_id = ct_pptp_info->pns_call_id;
+
+		/* don't use tcph->source since we are at a DSTmanip
+		 * hook (e.g. PREROUTING) and pkt is not mangled yet */
+		new_callid = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.tcp.port;
+
+		/* save new call ID in ct info */
+		ct_pptp_info->pns_call_id = ntohs(new_callid);
+		break;
+	case PPTP_IN_CALL_REPLY:
+		cid_off = offsetof(union pptp_ctrl_union, icreq.callID);
+		break;
+	case PPTP_CALL_CLEAR_REQUEST:
+		cid_off = offsetof(union pptp_ctrl_union, clrreq.callID);
+		break;
+	default:
+		DEBUGP("unknown outbound packet 0x%04x:%s\n", msg,
+		      (msg <= PPTP_MSG_MAX)?
+		      pptp_msg_name[msg]:pptp_msg_name[0]);
+		/* fall through */
+
+	case PPTP_SET_LINK_INFO:
+		/* only need to NAT in case PAC is behind NAT box */
+	case PPTP_START_SESSION_REQUEST:
+	case PPTP_START_SESSION_REPLY:
+	case PPTP_STOP_SESSION_REQUEST:
+	case PPTP_STOP_SESSION_REPLY:
+	case PPTP_ECHO_REQUEST:
+	case PPTP_ECHO_REPLY:
+		/* no need to alter packet */
+		return NF_ACCEPT;
 	}
 
 	/* only OUT_CALL_REQUEST, IN_CALL_REPLY, CALL_CLEAR_REQUEST pass
@@ -216,9 +216,9 @@ static int
 pptp_exp_gre(struct ip_conntrack_expect *expect_orig,
 	     struct ip_conntrack_expect *expect_reply)
 {
-	struct ip_ct_pptp_master *ct_pptp_info = 
+	struct ip_ct_pptp_master *ct_pptp_info =
 				&expect_orig->master->help.ct_pptp_info;
-	struct ip_nat_pptp *nat_pptp_info = 
+	struct ip_nat_pptp *nat_pptp_info =
 				&expect_orig->master->nat.help.nat_pptp_info;
 
 	struct ip_conntrack *ct = expect_orig->master;
@@ -324,7 +324,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		break;
 
 	default:
-		DEBUGP("unknown inbound packet %s\n", (msg <= PPTP_MSG_MAX)? 
+		DEBUGP("unknown inbound packet %s\n", (msg <= PPTP_MSG_MAX)?
 			pptp_msg_name[msg]:pptp_msg_name[0]);
 		/* fall through */
 
diff --git a/net/ipv4/netfilter/ip_nat_proto_gre.c b/net/ipv4/netfilter/ip_nat_proto_gre.c
index 70a6537..a522669 100644
--- a/net/ipv4/netfilter/ip_nat_proto_gre.c
+++ b/net/ipv4/netfilter/ip_nat_proto_gre.c
@@ -6,10 +6,10 @@
  * GRE is a generic encapsulation protocol, which is generally not very
  * suited for NAT, as it has no protocol-specific part as port numbers.
  *
- * It has an optional key field, which may help us distinguishing two 
+ * It has an optional key field, which may help us distinguishing two
  * connections between the same two hosts.
  *
- * GRE is defined in RFC 1701 and RFC 1702, as well as RFC 2784 
+ * GRE is defined in RFC 1701 and RFC 1702, as well as RFC 2784
  *
  * PPTP is built on top of a modified version of GRE, and has a mandatory
  * field called "CallID", which serves us for the same purpose as the key
@@ -60,7 +60,7 @@ gre_in_range(const struct ip_conntrack_t
 }
 
 /* generate unique tuple ... */
-static int 
+static int
 gre_unique_tuple(struct ip_conntrack_tuple *tuple,
 		 const struct ip_nat_range *range,
 		 enum ip_nat_manip_type maniptype,
@@ -84,7 +84,7 @@ gre_unique_tuple(struct ip_conntrack_tup
 		range_size = ntohs(range->max.gre.key) - min + 1;
 	}
 
-	DEBUGP("min = %u, range_size = %u\n", min, range_size); 
+	DEBUGP("min = %u, range_size = %u\n", min, range_size);
 
 	for (i = 0; i < range_size; i++, key++) {
 		*keyptr = htons(min + key % range_size);
@@ -117,7 +117,7 @@ gre_manip_pkt(struct sk_buff **pskb,
 	greh = (void *)(*pskb)->data + hdroff;
 	pgreh = (struct gre_hdr_pptp *) greh;
 
-	/* we only have destination manip of a packet, since 'source key' 
+	/* we only have destination manip of a packet, since 'source key'
 	 * is not present in the packet itself */
 	if (maniptype == IP_NAT_MANIP_DST) {
 		/* key manipulation is always dest */
@@ -129,7 +129,7 @@ gre_manip_pkt(struct sk_buff **pskb,
 			}
 			if (greh->csum) {
 				/* FIXME: Never tested this code... */
-				*(gre_csum(greh)) = 
+				*(gre_csum(greh)) =
 					nf_proto_csum_update(*pskb,
 							~*(gre_key(greh)),
 							tuple->dst.u.gre.key,
@@ -138,7 +138,7 @@ gre_manip_pkt(struct sk_buff **pskb,
 			*(gre_key(greh)) = tuple->dst.u.gre.key;
 			break;
 		case GRE_VERSION_PPTP:
-			DEBUGP("call_id -> 0x%04x\n", 
+			DEBUGP("call_id -> 0x%04x\n",
 				ntohs(tuple->dst.u.gre.key));
 			pgreh->call_id = tuple->dst.u.gre.key;
 			break;
@@ -152,8 +152,8 @@ gre_manip_pkt(struct sk_buff **pskb,
 }
 
 /* nat helper struct */
-static struct ip_nat_protocol gre = { 
-	.name		= "GRE", 
+static struct ip_nat_protocol gre = {
+	.name		= "GRE",
 	.protonum	= IPPROTO_GRE,
 	.manip_pkt	= gre_manip_pkt,
 	.in_range	= gre_in_range,
@@ -164,7 +164,7 @@ #if defined(CONFIG_IP_NF_CONNTRACK_NETLI
 	.nfattr_to_range	= ip_nat_port_nfattr_to_range,
 #endif
 };
-				  
+
 int __init ip_nat_proto_gre_init(void)
 {
 	return ip_nat_protocol_register(&gre);
