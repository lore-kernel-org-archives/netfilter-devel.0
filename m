From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH] PPTP conntrack enhancements
Date: Tue, 03 Dec 2002 16:09:29 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DEC4A99.9090805@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050509040906020400080302"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------050509040906020400080302
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I've attached a diff against the PPTP conntrack patch to fix
various issues.  The major changes are that it now works in
the presence of DNAT, and uses GRE expectations in both
directions.

Here's some more detailed descriptions of the changes, kind
of in the order they appear in the diff:

* removed master field from ip_ct_gre_keymap.  It was being
initialized to point to a stack variable and never used again.

* add ip_ct_gre_keymap_destroy(), and call it from
pptp_timeout_related otherwise keymaps are never destroyed for
expectations that never arrive.

* ip_conntrack_change_expect now uses the tuple mask to
compare the old expect to the new expect.  This is because the
source key may need changing, but this is not included in the
mask, so expect_clash then fails when doing the check against
the old expect.

* GRE expectations are created for both directions.  Only one
will be matched, the other hangs around until the call is
disconnected.

* DNAT is now supported, although it doesn't do NAT of the
PAC call id since I can't see any situations in which that
would be useful.

* pptp_inbound_pkt and pptp_outbound_pkt are called for the
INPUT and OUTPUT hooks as well, otherwise fields in
nat_pptp_info are uninitialized for local connections.

Regards,
Phil

-- 
Philip Craig     Software Engineer     http://www.SnapGear.com
philipc@snapgear.com  Ph: +61 7 3435 2821  Fx: +61 7 3891 3630
SnapGear  -  Custom Embedded Solutions and Security Appliances

--------------050509040906020400080302
Content-Type: text/plain;
 name="pptp-conntrack-nat.patch.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pptp-conntrack-nat.patch.diff"

diff -u -r1.11 pptp-conntrack-nat.patch
--- pptp-conntrack-nat.patch	12 Nov 2002 20:17:22 -0000	1.11
+++ pptp-conntrack-nat.patch	3 Dec 2002 05:18:00 -0000
@@ -316,7 +316,7 @@
 +#endif /* _CONNTRACK_PPTP_H */
 --- linuxppc-020802-newnat/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h	Thu Jan  1 01:00:00 1970
 +++ linuxppc-020802-newnat14-h323/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h	Fri Aug  2 14:37:28 2002
-@@ -0,0 +1,121 @@
+@@ -0,0 +1,123 @@
 +#ifndef _CONNTRACK_PROTO_GRE_H
 +#define _CONNTRACK_PROTO_GRE_H
 +#include <asm/byteorder.h>
@@ -396,13 +396,13 @@
 +};
 +
 +#ifdef __KERNEL__
++struct ip_conntrack_expect;
 +
 +/* structure for original <-> reply keymap */
 +struct ip_ct_gre_keymap {
 +	struct list_head list;
 +
 +	struct ip_conntrack_tuple tuple;
-+	struct ip_conntrack_expect *master;
 +};
 +
 +
@@ -415,6 +415,8 @@
 +void ip_ct_gre_keymap_change(struct ip_ct_gre_keymap *km,
 +			     struct ip_conntrack_tuple *t);
 +
++/* delete keymap entries */
++void ip_ct_gre_keymap_destroy(struct ip_conntrack_expect *exp);
 +
 +
 +/* get pointer to gre key, if present */
@@ -545,7 +547,7 @@
  
  	new = LIST_FIND(&expect_list, resent_expect,
  		        struct ip_conntrack_expect *, &expect->tuple, &expect->mask);
-@@ -971,11 +976,10 @@
+@@ -1064,15 +1068,14 @@
 
  	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
  	WRITE_LOCK(&ip_conntrack_expect_tuple_lock);
@@ -560,9 +562,14 @@
  	if (expect->ct_tuple.dst.protonum == 0) {
  		/* Never seen before */
  		DEBUGP("change expect: never seen before\n");
+-		if (!ip_ct_tuple_equal(&expect->tuple, newtuple) 
++		if (!ip_ct_tuple_mask_cmp(&expect->tuple, newtuple, &expect->mask)
+ 		    && LIST_FIND(&ip_conntrack_expect_list, expect_clash,
+ 			         struct ip_conntrack_expect *, newtuple, &expect->mask)) {
+ 			/* Force NAT to find an unused tuple */
 --- linux-2.4.18-newnat/net/ipv4/netfilter/ip_conntrack_pptp.c	Thu Jan  1 01:00:00 1970
 +++ linux-2.4.18-pptp3.01//net/ipv4/netfilter/ip_conntrack_pptp.c	Mon Apr  8 16:40:37 2002
-@@ -0,0 +1,540 @@
+@@ -0,0 +1,558 @@
 +/*
 + * ip_conntrack_pptp.c	- Version $Revision: 1.11 $
 + *
@@ -652,7 +659,7 @@
 +		ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.gre.key =
 +			htonl(master->help.ct_pptp_info.pac_call_id);
 +		ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.gre.key =
-+			htonl(master->help.ct_pptp_info.pns_call_id);
++			htonl(master->help.ct_pptp_info.pac_call_id);
 +	}
 +
 +	return 0;
@@ -669,8 +676,10 @@
 +		exp = list_entry(cur_item, struct ip_conntrack_expect,
 +				 expected_list);
 +
-+		if (!exp->sibling)
++		if (!exp->sibling) {
++			ip_ct_gre_keymap_destroy(exp);
 +			continue;
++		}
 +
 +		DEBUGP("setting timeout of conntrack %p to 0\n",
 +			exp->sibling);
@@ -693,7 +702,7 @@
 +	struct ip_conntrack_tuple inv_tuple;
 +
 +	memset(&exp, 0, sizeof(exp));
-+	/* tuple in original direction, PAC->PNS */
++	/* tuple in original direction, PNS->PAC */
 +	exp.tuple.src.ip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
 +	exp.tuple.src.u.gre.key = htonl(ntohs(peer_callid));
 +	exp.tuple.dst.ip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
@@ -727,6 +736,22 @@
 +	
 +	ip_conntrack_expect_related(master, &exp);
 +
++	/* tuple in reply direction, PAC->PNS */
++	exp.tuple.src.ip = master->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
++	exp.tuple.src.u.gre.key = htonl(ntohs(callid));
++	exp.tuple.dst.ip = master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
++	exp.tuple.dst.u.gre.key = htonl(ntohs(peer_callid));
++
++	DEBUGP("calling expect_related ");
++	DUMP_TUPLE_RAW(&exp.tuple);
++	
++	/* Add GRE keymap entries */
++	ip_ct_gre_keymap_add(&exp, &exp.tuple, 0);
++	invert_tuplepr(&inv_tuple, &exp.tuple);
++	ip_ct_gre_keymap_add(&exp, &inv_tuple, 1);
++	
++	ip_conntrack_expect_related(master, &exp);
++
 +	return 0;
 +}
 +
@@ -1132,7 +1157,7 @@
 +#endif
 --- linux-2.4.18-pptp3.01//net/ipv4/netfilter/ip_conntrack_proto_gre.c	Mon Apr  8 16:40:23 2002
 +++ linux-2.4.18-pptp3.01/net/ipv4/netfilter/ip_conntrack_proto_gre.c	2002-08-29 13:01:00.000000000 +0200
-@@ -0,0 +1,334 @@
+@@ -0,0 +1,341 @@
 +/*
 + * ip_conntrack_proto_gre.c - Version $Revision: 1.11 $
 + *
@@ -1248,7 +1273,6 @@
 +	memset(km, 0, sizeof(*km));
 +
 +	memcpy(&km->tuple, t, sizeof(*t));
-+	km->master = exp;
 +
 +	if (!reply)
 +		exp->proto.gre.keymap_orig = km;
@@ -1277,6 +1301,25 @@
 +	WRITE_UNLOCK(&ip_ct_gre_lock);
 +}
 +
++/* destroy the keymap entries associated with specified expect */
++void ip_ct_gre_keymap_destroy(struct ip_conntrack_expect *exp)
++{
++	WRITE_LOCK(&ip_ct_gre_lock);
++	if (exp->proto.gre.keymap_orig) {
++		DEBUGP("removing %p from list\n", exp->proto.gre.keymap_orig);
++		list_del(&exp->proto.gre.keymap_orig->list);
++		kfree(exp->proto.gre.keymap_orig);
++		exp->proto.gre.keymap_orig = NULL;
++	}
++	if (exp->proto.gre.keymap_reply) {
++		DEBUGP("removing %p from list\n", exp->proto.gre.keymap_reply);
++		list_del(&exp->proto.gre.keymap_reply->list);
++		kfree(exp->proto.gre.keymap_reply);
++		exp->proto.gre.keymap_reply = NULL;
++	}
++	WRITE_UNLOCK(&ip_ct_gre_lock);
++}
++
 +
 +/* PUBLIC CONNTRACK PROTO HELPER FUNCTIONS */
 +
@@ -1405,18 +1448,7 @@
 +		return;
 +	}
 +
-+	WRITE_LOCK(&ip_ct_gre_lock);
-+	if (master->proto.gre.keymap_orig) {
-+		DEBUGP("removing %p from list\n", master->proto.gre.keymap_orig);
-+		list_del(&master->proto.gre.keymap_orig->list);
-+		kfree(master->proto.gre.keymap_orig);
-+	}
-+	if (master->proto.gre.keymap_reply) {
-+		DEBUGP("removing %p from list\n", master->proto.gre.keymap_reply);
-+		list_del(&master->proto.gre.keymap_reply->list);
-+		kfree(master->proto.gre.keymap_reply);
-+	}
-+	WRITE_UNLOCK(&ip_ct_gre_lock);
++	ip_ct_gre_keymap_destroy(master);
 +}
 +
 +/* protocol helper struct */
@@ -1498,7 +1530,7 @@
  		/* We now have two tuples (SRCIP/SRCPT/DSTIP/DSTPT):
 --- linux-2.4.18-newnat/net/ipv4/netfilter/ip_nat_pptp.c	Thu Jan  1 01:00:00 1970
 +++ linux-2.4.18-pptp3.01//net/ipv4/netfilter/ip_nat_pptp.c	Mon Apr  8 16:40:47 2002
-@@ -0,0 +1,425 @@
+@@ -0,0 +1,427 @@
 +/*
 + * ip_nat_pptp.c	- Version $Revision: 1.11 $
 + *
@@ -1558,7 +1590,7 @@
 +	struct ip_nat_multi_range mr;
 +	struct ip_ct_pptp_master *ct_pptp_info;
 +	struct ip_nat_pptp *nat_pptp_info;
-+	u_int32_t newsrcip, newdstip, newcid;
++	u_int32_t newip, newcid;
 +	int ret;
 +
 +	IP_NF_ASSERT(info);
@@ -1573,7 +1605,7 @@
 +
 +	/* need to alter GRE tuple because conntrack expectfn() used 'wrong'
 +	 * (unmanipulated) values */
-+	if (hooknum == NF_IP_PRE_ROUTING) {
++	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_DST) {
 +		DEBUGP("completing tuples with NAT info \n");
 +		/* we can do this, since we're unconfirmed */
 +		if (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.gre.key ==
@@ -1581,51 +1613,44 @@
 +			/* assume PNS->PAC */
 +			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.gre.key =
 +				htonl(nat_pptp_info->pns_call_id);
-+//			ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.gre.key =
-+//				htonl(nat_pptp_info->pac_call_id);
 +			ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.gre.key =
 +				htonl(nat_pptp_info->pns_call_id);
++			newip = master->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
++			newcid = htonl(nat_pptp_info->pac_call_id);
 +		} else {
 +			/* assume PAC->PNS */
-+			DEBUGP("WRONG DIRECTION\n");
 +			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.gre.key =
 +				htonl(nat_pptp_info->pac_call_id);
 +			ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.gre.key =
-+				htonl(nat_pptp_info->pns_call_id);
++				htonl(nat_pptp_info->pac_call_id);
++			newip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
++			newcid = htonl(nat_pptp_info->pns_call_id);
 +		}
 +	}
-+
-+	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_DST) {
-+		newdstip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
-+		newcid = htonl(master->nat.help.nat_pptp_info.pac_call_id);
-+
-+		mr.rangesize = 1;
-+		mr.range[0].flags = IP_NAT_RANGE_MAP_IPS | IP_NAT_RANGE_PROTO_SPECIFIED;
-+		mr.range[0].min_ip = mr.range[0].max_ip = newdstip;
-+		mr.range[0].min = mr.range[0].max = 
-+			((union ip_conntrack_manip_proto ) { newcid }); 
-+		DEBUGP("change dest ip to %u.%u.%u.%u\n", 
-+			NIPQUAD(newdstip));
-+		DEBUGP("change dest key to 0x%x\n", ntohl(newcid));
-+		ret = ip_nat_setup_info(ct, &mr, hooknum);
-+	} else {
-+		newsrcip = master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
-+		/* nat_multi_range is in network byte order, and GRE tuple
-+		 * is 32 bits, not 16 like callID */
-+		newcid = htonl(master->help.ct_pptp_info.pns_call_id);
-+
-+		mr.rangesize = 1;
-+		mr.range[0].flags = IP_NAT_RANGE_MAP_IPS
-+			            |IP_NAT_RANGE_PROTO_SPECIFIED;
-+		mr.range[0].min_ip = mr.range[0].max_ip = newsrcip;
-+		mr.range[0].min = mr.range[0].max = 
-+			((union ip_conntrack_manip_proto ) { newcid });
-+		DEBUGP("change src ip to %u.%u.%u.%u\n", 
-+			NIPQUAD(newsrcip));
-+		DEBUGP("change 'src' key to 0x%x\n", ntohl(newcid));
-+		ret = ip_nat_setup_info(ct, &mr, hooknum);
++	else {
++		if (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.gre.key ==
++			htonl(ct_pptp_info->pac_call_id)) {	
++			/* assume PNS->PAC */
++			newip = master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
++			newcid = htonl(ct_pptp_info->pns_call_id);
++		}
++		else {
++			/* assume PAC->PNS */
++			newip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
++			newcid = htonl(ct_pptp_info->pac_call_id);
++		}
 +	}
 +
++	mr.rangesize = 1;
++	mr.range[0].flags = IP_NAT_RANGE_MAP_IPS | IP_NAT_RANGE_PROTO_SPECIFIED;
++	mr.range[0].min_ip = mr.range[0].max_ip = newip;
++	mr.range[0].min = mr.range[0].max = 
++		((union ip_conntrack_manip_proto ) { newcid }); 
++	DEBUGP("change ip to %u.%u.%u.%u\n", 
++		NIPQUAD(newip));
++	DEBUGP("change key to 0x%x\n", ntohl(newcid));
++	ret = ip_nat_setup_info(ct, &mr, hooknum);
++
 +	UNLOCK_BH(&ip_pptp_lock);
 +
 +	return ret;
@@ -1724,7 +1749,8 @@
 +	u_int16_t msg, new_cid = 0, new_pcid, *pcid = NULL, *cid = NULL;
 +	u_int32_t old_dst_ip;
 +
-+	struct ip_conntrack_tuple t;
++	struct ip_conntrack_tuple t, inv_t;
++	struct ip_conntrack_tuple *orig_t, *reply_t;
 +
 +	/* FIXME: size checks !!! */
 +	ctlh = (struct PptpControlHeader *) ((void *) pptph + sizeof(*pptph));
@@ -1742,6 +1768,7 @@
 +		}
 +		old_dst_ip = oldexp->tuple.dst.ip;
 +		t = oldexp->tuple;
++		invert_tuplepr(&inv_t, &t);
 +
 +		/* save original PAC call ID in nat_info */
 +		nat_pptp_info->pac_call_id = ct_pptp_info->pac_call_id;
@@ -1751,14 +1778,24 @@
 +		//new_cid = htons(ct_pptp_info->pac_call_id);
 +
 +		/* alter expectation */
-+		if (t.dst.ip == ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip) {
++		orig_t = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
++		reply_t = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
++		if (t.src.ip == orig_t->src.ip && t.dst.ip == orig_t->dst.ip) {
 +			/* expectation for PNS->PAC direction */
-+			t.dst.u.gre.key = htonl(ct_pptp_info->pac_call_id);
 +			t.src.u.gre.key = htonl(nat_pptp_info->pns_call_id);
++			t.dst.u.gre.key = htonl(ct_pptp_info->pac_call_id);
++			inv_t.src.ip = reply_t->src.ip;
++			inv_t.dst.ip = reply_t->dst.ip;
++			inv_t.src.u.gre.key = htonl(nat_pptp_info->pac_call_id);
++			inv_t.dst.u.gre.key = htonl(ct_pptp_info->pns_call_id);
 +		} else {
 +			/* expectation for PAC->PNS direction */
-+			t.dst.ip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
-+			DEBUGP("EXPECTATION IN WRONG DIRECTION!!!\n");
++			t.src.u.gre.key = htonl(nat_pptp_info->pac_call_id);
++			t.dst.u.gre.key = htonl(ct_pptp_info->pns_call_id);
++			inv_t.src.ip = orig_t->src.ip;
++			inv_t.dst.ip = orig_t->dst.ip;
++			inv_t.src.u.gre.key = htonl(nat_pptp_info->pns_call_id);
++			inv_t.dst.u.gre.key = htonl(ct_pptp_info->pac_call_id);
 +		}
 +
 +		if (!ip_conntrack_change_expect(oldexp, &t)) {
@@ -1767,13 +1804,7 @@
 +			DEBUGP("can't change expect\n");
 +		}
 +		ip_ct_gre_keymap_change(oldexp->proto.gre.keymap_orig, &t);
-+		/* reply keymap */
-+		t.src.ip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
-+		t.dst.ip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
-+		t.src.u.gre.key = htonl(nat_pptp_info->pac_call_id);
-+		t.dst.u.gre.key = htonl(ct_pptp_info->pns_call_id);
-+		ip_ct_gre_keymap_change(oldexp->proto.gre.keymap_reply, &t);
-+
++		ip_ct_gre_keymap_change(oldexp->proto.gre.keymap_reply, &inv_t);
 +		break;
 +	case PPTP_IN_CALL_CONNECT:
 +		pcid = &pptpReq.iccon->peersCallID;
@@ -1855,16 +1886,19 @@
 +
 +	DEBUGP("entering\n");
 +
-+	/* Only mangle things once: original direction in POST_ROUTING
-+	   and reply direction on PRE_ROUTING. */
++	/* Only mangle things once: DST for original direction
++	   and SRC for reply direction. */
 +	dir = CTINFO2DIR(ctinfo);
-+	if (!((hooknum == NF_IP_POST_ROUTING && dir == IP_CT_DIR_ORIGINAL)
-+	      || (hooknum == NF_IP_PRE_ROUTING && dir == IP_CT_DIR_REPLY))) {
++	if (!((HOOK2MANIP(hooknum) == IP_NAT_MANIP_DST
++	          && dir == IP_CT_DIR_ORIGINAL)
++	      || (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC
++	          && dir == IP_CT_DIR_REPLY))) {
 +		DEBUGP("Not touching dir %s at hook %s\n",
 +		       dir == IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
 +		       hooknum == NF_IP_POST_ROUTING ? "POSTROUTING"
 +		       : hooknum == NF_IP_PRE_ROUTING ? "PREROUTING"
-+		       : hooknum == NF_IP_LOCAL_OUT ? "OUTPUT" : "???");
++		       : hooknum == NF_IP_LOCAL_OUT ? "OUTPUT"
++		       : hooknum == NF_IP_LOCAL_IN ? "INPUT" : "???");
 +		return NF_ACCEPT;
 +	}
 +
@@ -1926,7 +1960,7 @@
 +module_exit(fini);
 --- linux-2.4.18-newnat/net/ipv4/netfilter/ip_nat_proto_gre.c	Thu Jan  1 01:00:00 1970
 +++ linux-2.4.18-pptp3.01//net/ipv4/netfilter/ip_nat_proto_gre.c	Mon Apr  8 16:40:56 2002
-@@ -0,0 +1,218 @@
+@@ -0,0 +1,225 @@
 +/*
 + * ip_nat_proto_gre.c - Version $Revision: 1.11 $
 + *
@@ -1978,8 +2012,15 @@
 +	     const union ip_conntrack_manip_proto *min,
 +	     const union ip_conntrack_manip_proto *max)
 +{
-+	return ntohl(tuple->src.u.gre.key) >= ntohl(min->gre.key)
-+		&& ntohl(tuple->src.u.gre.key) <= ntohl(max->gre.key);
++	u_int32_t key;
++
++	if (maniptype == IP_NAT_MANIP_SRC)
++		key = tuple->src.u.gre.key;
++	else
++		key = tuple->dst.u.gre.key;
++
++	return ntohl(key) >= ntohl(min->gre.key)
++		&& ntohl(key) <= ntohl(max->gre.key);
 +}
 +
 +/* generate unique tuple ... */

--------------050509040906020400080302--
