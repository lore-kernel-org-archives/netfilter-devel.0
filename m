From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH] PPTP conntrack bugfixes
Date: Wed, 05 Feb 2003 18:20:14 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E40C93E.5080603@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050106000606020308060409"
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
--------------050106000606020308060409
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I've attached 2 patches for the pptp connection tracking.

The first patch changes the way we mangle the call ids.
Since the call id is in the data portion of the TCP packet,
we must make a copy of the skb first,  otherwise bad things
happen if TCP tries to retransmit this data.  I've used
ip_nat_mangle_tcp_packet() for this purpose, although it is
slightly less efficient than needed since it handles resizing
as well.

The second patch unexpects the related connections when a
CALL_DISCONNECT_NOTIFY is received.  I've had situations
where leaving these expectations caused subsequent attempts
to connect to fail.  I suspect this is partly due to a
buggy PPTP server reusing call IDs, but there is no need to
keep these expectations around any longer.

While making the second patch, I noticed that
pptp_timeout_related() has a comment asking if a lock is
needed.  I suspect that we need to hold a write lock on
ip_conntrack_lock here?

Harald, is this format for patches okay?  I can diff them
against the patch in patch-o-matic if needed.

-- 
Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
SnapGear - Custom Embedded Solutions and Security Appliances

--------------050106000606020308060409
Content-Type: text/plain;
 name="pptp-mangle.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pptp-mangle.patch"

diff -u -r1.8 -r1.8.2.1
--- linux-2.4.x/net/ipv4/netfilter/ip_nat_pptp.c	3 Dec 2002 04:05:36 -0000	1.8
+++ linux-2.4.x/net/ipv4/netfilter/ip_nat_pptp.c	5 Feb 2003 05:38:06 -0000	1.8.2.1
@@ -130,7 +130,8 @@
 		  size_t datalen,
 		  struct ip_conntrack *ct,
 		  enum ip_conntrack_info ctinfo,
-		  struct ip_conntrack_expect *exp)
+		  struct ip_conntrack_expect *exp,
+		  struct sk_buff **pskb)
 
 {
 	struct PptpControlHeader *ctlh;
@@ -138,7 +139,8 @@
 	struct ip_ct_pptp_master *ct_pptp_info = &ct->help.ct_pptp_info;
 	struct ip_nat_pptp *nat_pptp_info = &ct->nat.help.nat_pptp_info;
 
-	u_int16_t msg, *cid = NULL, new_callid;
+	u_int16_t msg, new_callid;
+	unsigned int cid = 0;
 
 	/* FIXME: size checks !!! */
 	ctlh = (struct PptpControlHeader *) ((void *) pptph + sizeof(*pptph));
@@ -148,7 +150,7 @@
 	
 	switch (msg = ntohs(ctlh->messageType)) {
 		case PPTP_OUT_CALL_REQUEST:
-			cid = &pptpReq.ocreq->callID;
+			cid = (void *)&pptpReq.ocreq->callID - (void *)pptph;
 			/* FIXME: ideally we would want to reserve a call ID
 			 * here.  current netfilter NAT core is not able to do
 			 * this :( For now we use TCP source port. This breaks
@@ -162,13 +164,13 @@
 			ct_pptp_info->pns_call_id = ntohs(new_callid);
 			break;
 		case PPTP_IN_CALL_REPLY:
-			cid = &pptpReq.icreq->callID;
+			cid = (void *)&pptpReq.icreq->callID - (void *)pptph;
 			break;
 		case PPTP_CALL_CLEAR_REQUEST:
-			cid = &pptpReq.clrreq->callID;
+			cid = (void *)&pptpReq.clrreq->callID - (void *)pptph;
 			break;
 		case PPTP_CALL_DISCONNECT_NOTIFY:
-			cid = &pptpReq.disc->callID;
+			cid = (void *)&pptpReq.disc->callID - (void *)pptph;
 			break;
 
 		default:
@@ -191,11 +193,10 @@
 	IP_NF_ASSERT(cid);
 
 	DEBUGP("altering call id from 0x%04x to 0x%04x\n",
-		ntohs(*cid), ntohs(new_callid));
+		ntohs(*(u_int16_t *)((void *)pptph + cid)), ntohs(new_callid));
 	/* mangle packet */
-	tcph->check = ip_nat_cheat_check(*cid^0xFFFF, 
-					 new_callid, tcph->check);
-	*cid = new_callid;
+	ip_nat_mangle_tcp_packet(pskb, ct, ctinfo, cid, sizeof(new_callid),
+			(char *)&new_callid, sizeof(new_callid));
 
 	return NF_ACCEPT;
 }
@@ -206,15 +207,17 @@
 		 size_t datalen,
 		 struct ip_conntrack *ct,
 		 enum ip_conntrack_info ctinfo,
-		 struct ip_conntrack_expect *oldexp)
+		 struct ip_conntrack_expect *oldexp,
+		 struct sk_buff **pskb)
 {
 	struct PptpControlHeader *ctlh;
 	union pptp_ctrl_union pptpReq;
 	struct ip_ct_pptp_master *ct_pptp_info = &ct->help.ct_pptp_info;
 	struct ip_nat_pptp *nat_pptp_info = &ct->nat.help.nat_pptp_info;
 
-	u_int16_t msg, new_cid = 0, new_pcid, *pcid = NULL, *cid = NULL;
+	u_int16_t msg, new_cid = 0, new_pcid;
 	u_int32_t old_dst_ip;
+	unsigned int pcid = 0, cid = 0;
 
 	struct ip_conntrack_tuple t, inv_t;
 	struct ip_conntrack_tuple *orig_t, *reply_t;
@@ -227,8 +230,8 @@
 
 	switch (msg = ntohs(ctlh->messageType)) {
 	case PPTP_OUT_CALL_REPLY:
-		pcid = &pptpReq.ocack->peersCallID;	
-		cid = &pptpReq.ocack->callID;
+		pcid = (void *)&pptpReq.ocack->peersCallID - (void *)pptph;
+		cid = (void *)&pptpReq.ocack->callID - (void *)pptph;
 		if (!oldexp) {
 			DEBUGP("outcall but no expectation\n");
 			break;
@@ -274,7 +277,7 @@
 		ip_ct_gre_keymap_change(oldexp->proto.gre.keymap_reply, &inv_t);
 		break;
 	case PPTP_IN_CALL_CONNECT:
-		pcid = &pptpReq.iccon->peersCallID;
+		pcid = (void *)&pptpReq.iccon->peersCallID - (void *)pptph;
 		if (!oldexp)
 			break;
 		old_dst_ip = oldexp->tuple.dst.ip;
@@ -299,7 +302,7 @@
 		/* only need to nat in case PAC is behind NAT box */
 		break;
 	case PPTP_WAN_ERROR_NOTIFY:
-		pcid = &pptpReq.wanerr->peersCallID;
+		pcid = (void *)&pptpReq.wanerr->peersCallID - (void *)pptph;
 		break;
 	default:
 		DEBUGP("unknown inbound packet %s\n",
@@ -318,18 +321,18 @@
 	/* mangle packet */
 	IP_NF_ASSERT(pcid);
 	DEBUGP("altering peer call id from 0x%04x to 0x%04x\n",
-		ntohs(*pcid), ntohs(new_pcid));
-	tcph->check = ip_nat_cheat_check(*pcid^0xFFFF, 
-					 new_pcid, tcph->check);
-	*pcid = new_pcid;
+		ntohs(*(u_int16_t *)((void *)pptph + pcid)), ntohs(new_pcid));
+	ip_nat_mangle_tcp_packet(pskb, ct, ctinfo, pcid, sizeof(new_pcid),
+			(char *)&new_pcid, sizeof(new_pcid));
 
 	if (new_cid) {
 		IP_NF_ASSERT(cid);
 		DEBUGP("altering call id from 0x%04x to 0x%04x\n",
-			ntohs(*cid), ntohs(new_cid));
-		tcph->check = ip_nat_cheat_check(*cid^0xFFFF,
-						new_cid, tcph->check);
-		*cid = new_cid;
+			ntohs(*(u_int16_t *)((void *)pptph + cid)),
+			ntohs(new_cid));
+		ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
+				cid, sizeof(new_cid),
+				(char *)&new_cid, sizeof(new_cid));
 	}
 
 	/* great, at least we don't need to resize packets */
@@ -347,7 +350,6 @@
 	struct tcphdr *tcph = (void *) iph + iph->ihl*4;
 	unsigned int datalen = (*pskb)->len - iph->ihl*4 - tcph->doff*4;
 	struct pptp_pkt_hdr *pptph;
-	void *datalimit;
 
 	int dir;
 
@@ -379,16 +381,15 @@
 	/* FIXME: checks on pptp version, magic cookie, etc. */
 
 	pptph = (struct pptp_pkt_hdr *) ((void *)tcph + tcph->doff*4);
-	datalimit = (void *) pptph + datalen;
 
 	LOCK_BH(&ip_pptp_lock);
 
 	if (dir == IP_CT_DIR_ORIGINAL) {
 		/* reuqests sent by client to server (PNS->PAC) */
-		pptp_outbound_pkt(tcph, pptph, datalen, ct, ctinfo, exp);
+		pptp_outbound_pkt(tcph, pptph, datalen, ct, ctinfo, exp, pskb);
 	} else {
 		/* response from the server to the client (PAC->PNS) */
-		pptp_inbound_pkt(tcph, pptph, datalen, ct, ctinfo, exp);
+		pptp_inbound_pkt(tcph, pptph, datalen, ct, ctinfo, exp, pskb);
 	}
 
 	UNLOCK_BH(&ip_pptp_lock);

--------------050106000606020308060409
Content-Type: text/plain;
 name="pptp-unexpect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pptp-unexpect.patch"

diff -u -r1.10 -r1.10.2.1
--- linux-2.4.x/net/ipv4/netfilter/ip_conntrack_pptp.c	29 Nov 2002 06:37:32 -0000	1.10
+++ linux-2.4.x/net/ipv4/netfilter/ip_conntrack_pptp.c	4 Feb 2003 07:10:46 -0000	1.10.2.1
@@ -96,16 +96,19 @@
 /* timeout GRE data connections */
 static int pptp_timeout_related(struct ip_conntrack *ct)
 {
-	struct list_head *cur_item;
+	struct list_head *cur_item, *next;
 	struct ip_conntrack_expect *exp;
 
 	/* FIXME: do we have to lock something ? */
-	list_for_each(cur_item, &ct->sibling_list) {
+	for (cur_item = ct->sibling_list.next;
+	    cur_item != &ct->sibling_list; cur_item = next) {
+		next = cur_item->next;
 		exp = list_entry(cur_item, struct ip_conntrack_expect,
 				 expected_list);
 
 		if (!exp->sibling) {
 			ip_ct_gre_keymap_destroy(exp);
+			ip_conntrack_unexpect_related(exp);
 			continue;
 		}
 
@@ -319,7 +322,6 @@
 
 		/* untrack this call id, unexpect GRE packets */
 		pptp_timeout_related(ct);
-		/* NEWNAT: look up exp for call id and unexpct_related */
 		break;
 
 	case PPTP_WAN_ERROR_NOTIFY:
@@ -481,8 +483,6 @@
 
 		/* untrack this call id, unexpect GRE packets */
 		pptp_timeout_related(ct);
-		/* no need to call unexpect_related since master conn
-		 * dies anyway */
 	}
 
 

--------------050106000606020308060409--
