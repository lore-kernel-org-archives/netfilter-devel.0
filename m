From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/18]: Decrease number of pointer derefs in
	nfnetlink_queue.c
Date: Thu,  5 Jan 2006 05:06:31 +0100 (MET)
Message-ID: <20060105040555.23512.60162.sendpatchset@localhost.localdomain>
References: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Decrease number of pointer derefs in nfnetlink_queue.c

Benefits of the patch:
 - Fewer pointer dereferences should make the code slightly faster.
 - Size of generated code is smaller
 - improved readability

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d0fc264ffbc6c3886020dc2ef60d4aa1cecec51c
tree 5ff03f582e6f3e9f8e82e8032f4141cd8c9db727
parent 4f1291de22905b4c0c029dd6f682d2b7bf28b9c1
author Jesper Juhl <jesper.juhl@gmail.com> Thu, 05 Jan 2006 02:51:36 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 02:51:36 +0100

 net/netfilter/nfnetlink_queue.c |   79 ++++++++++++++++++++++-----------------
 1 files changed, 44 insertions(+), 35 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index f28460b..9216231 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -345,6 +345,10 @@ nfqnl_build_packet_message(struct nfqnl_
 	struct nfqnl_msg_packet_hdr pmsg;
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
+	struct nf_info *entinf = entry->info;
+	struct sk_buff *entskb = entry->skb;
+	struct net_device *indev;
+	struct net_device *outdev;
 	unsigned int tmp_uint;
 
 	QDEBUG("entered\n");
@@ -361,6 +365,8 @@ nfqnl_build_packet_message(struct nfqnl_
 		+ NLMSG_SPACE(sizeof(struct nfqnl_msg_packet_hw))
 		+ NLMSG_SPACE(sizeof(struct nfqnl_msg_packet_timestamp));
 
+	outdev = entinf->outdev;
+
 	spin_lock_bh(&queue->lock);
 	
 	switch (queue->copy_mode) {
@@ -370,15 +376,15 @@ nfqnl_build_packet_message(struct nfqnl_
 		break;
 	
 	case NFQNL_COPY_PACKET:
-		if (entry->skb->ip_summed == CHECKSUM_HW &&
-		    (*errp = skb_checksum_help(entry->skb,
-		                               entry->info->outdev == NULL))) {
+		if (entskb->ip_summed == CHECKSUM_HW &&
+		    (*errp = skb_checksum_help(entskb,
+		                               outdev == NULL))) {
 			spin_unlock_bh(&queue->lock);
 			return NULL;
 		}
 		if (queue->copy_range == 0 
-		    || queue->copy_range > entry->skb->len)
-			data_len = entry->skb->len;
+		    || queue->copy_range > entskb->len)
+			data_len = entskb->len;
 		else
 			data_len = queue->copy_range;
 		
@@ -402,29 +408,30 @@ nfqnl_build_packet_message(struct nfqnl_
 			NFNL_SUBSYS_QUEUE << 8 | NFQNL_MSG_PACKET,
 			sizeof(struct nfgenmsg));
 	nfmsg = NLMSG_DATA(nlh);
-	nfmsg->nfgen_family = entry->info->pf;
+	nfmsg->nfgen_family = entinf->pf;
 	nfmsg->version = NFNETLINK_V0;
 	nfmsg->res_id = htons(queue->queue_num);
 
 	pmsg.packet_id 		= htonl(entry->id);
-	pmsg.hw_protocol	= htons(entry->skb->protocol);
-	pmsg.hook		= entry->info->hook;
+	pmsg.hw_protocol	= htons(entskb->protocol);
+	pmsg.hook		= entinf->hook;
 
 	NFA_PUT(skb, NFQA_PACKET_HDR, sizeof(pmsg), &pmsg);
 
-	if (entry->info->indev) {
-		tmp_uint = htonl(entry->info->indev->ifindex);
+	indev = entinf->indev;
+	if (indev) {
+		tmp_uint = htonl(indev->ifindex);
 #ifndef CONFIG_BRIDGE_NETFILTER
 		NFA_PUT(skb, NFQA_IFINDEX_INDEV, sizeof(tmp_uint), &tmp_uint);
 #else
-		if (entry->info->pf == PF_BRIDGE) {
+		if (entinf->pf == PF_BRIDGE) {
 			/* Case 1: indev is physical input device, we need to
 			 * look for bridge group (when called from 
 			 * netfilter_bridge) */
 			NFA_PUT(skb, NFQA_IFINDEX_PHYSINDEV, sizeof(tmp_uint), 
 				&tmp_uint);
 			/* this is the bridge group "brX" */
-			tmp_uint = htonl(entry->info->indev->br_port->br->dev->ifindex);
+			tmp_uint = htonl(indev->br_port->br->dev->ifindex);
 			NFA_PUT(skb, NFQA_IFINDEX_INDEV, sizeof(tmp_uint),
 				&tmp_uint);
 		} else {
@@ -432,9 +439,9 @@ nfqnl_build_packet_message(struct nfqnl_
 			 * physical device (when called from ipv4) */
 			NFA_PUT(skb, NFQA_IFINDEX_INDEV, sizeof(tmp_uint),
 				&tmp_uint);
-			if (entry->skb->nf_bridge
-			    && entry->skb->nf_bridge->physindev) {
-				tmp_uint = htonl(entry->skb->nf_bridge->physindev->ifindex);
+			if (entskb->nf_bridge
+			    && entskb->nf_bridge->physindev) {
+				tmp_uint = htonl(entskb->nf_bridge->physindev->ifindex);
 				NFA_PUT(skb, NFQA_IFINDEX_PHYSINDEV,
 					sizeof(tmp_uint), &tmp_uint);
 			}
@@ -442,19 +449,19 @@ nfqnl_build_packet_message(struct nfqnl_
 #endif
 	}
 
-	if (entry->info->outdev) {
-		tmp_uint = htonl(entry->info->outdev->ifindex);
+	if (outdev) {
+		tmp_uint = htonl(outdev->ifindex);
 #ifndef CONFIG_BRIDGE_NETFILTER
 		NFA_PUT(skb, NFQA_IFINDEX_OUTDEV, sizeof(tmp_uint), &tmp_uint);
 #else
-		if (entry->info->pf == PF_BRIDGE) {
+		if (entinf->pf == PF_BRIDGE) {
 			/* Case 1: outdev is physical output device, we need to
 			 * look for bridge group (when called from 
 			 * netfilter_bridge) */
 			NFA_PUT(skb, NFQA_IFINDEX_PHYSOUTDEV, sizeof(tmp_uint),
 				&tmp_uint);
 			/* this is the bridge group "brX" */
-			tmp_uint = htonl(entry->info->outdev->br_port->br->dev->ifindex);
+			tmp_uint = htonl(outdev->br_port->br->dev->ifindex);
 			NFA_PUT(skb, NFQA_IFINDEX_OUTDEV, sizeof(tmp_uint),
 				&tmp_uint);
 		} else {
@@ -462,9 +469,9 @@ nfqnl_build_packet_message(struct nfqnl_
 			 * physical output device (when called from ipv4) */
 			NFA_PUT(skb, NFQA_IFINDEX_OUTDEV, sizeof(tmp_uint),
 				&tmp_uint);
-			if (entry->skb->nf_bridge
-			    && entry->skb->nf_bridge->physoutdev) {
-				tmp_uint = htonl(entry->skb->nf_bridge->physoutdev->ifindex);
+			if (entskb->nf_bridge
+			    && entskb->nf_bridge->physoutdev) {
+				tmp_uint = htonl(entskb->nf_bridge->physoutdev->ifindex);
 				NFA_PUT(skb, NFQA_IFINDEX_PHYSOUTDEV,
 					sizeof(tmp_uint), &tmp_uint);
 			}
@@ -472,27 +479,27 @@ nfqnl_build_packet_message(struct nfqnl_
 #endif
 	}
 
-	if (entry->skb->nfmark) {
-		tmp_uint = htonl(entry->skb->nfmark);
+	if (entskb->nfmark) {
+		tmp_uint = htonl(entskb->nfmark);
 		NFA_PUT(skb, NFQA_MARK, sizeof(u_int32_t), &tmp_uint);
 	}
 
-	if (entry->info->indev && entry->skb->dev
-	    && entry->skb->dev->hard_header_parse) {
+	if (indev && entskb->dev
+	    && entskb->dev->hard_header_parse) {
 		struct nfqnl_msg_packet_hw phw;
 
 		phw.hw_addrlen =
-			entry->skb->dev->hard_header_parse(entry->skb,
+			entskb->dev->hard_header_parse(entskb,
 			                                   phw.hw_addr);
 		phw.hw_addrlen = htons(phw.hw_addrlen);
 		NFA_PUT(skb, NFQA_HWADDR, sizeof(phw), &phw);
 	}
 
-	if (entry->skb->tstamp.off_sec) {
+	if (entskb->tstamp.off_sec) {
 		struct nfqnl_msg_packet_timestamp ts;
 
-		ts.sec = cpu_to_be64(entry->skb->tstamp.off_sec);
-		ts.usec = cpu_to_be64(entry->skb->tstamp.off_usec);
+		ts.sec = cpu_to_be64(entskb->tstamp.off_sec);
+		ts.usec = cpu_to_be64(entskb->tstamp.off_usec);
 
 		NFA_PUT(skb, NFQA_TIMESTAMP, sizeof(ts), &ts);
 	}
@@ -510,7 +517,7 @@ nfqnl_build_packet_message(struct nfqnl_
 		nfa->nfa_type = NFQA_PAYLOAD;
 		nfa->nfa_len = size;
 
-		if (skb_copy_bits(entry->skb, 0, NFA_DATA(nfa), data_len))
+		if (skb_copy_bits(entskb, 0, NFA_DATA(nfa), data_len))
 			BUG();
 	}
 		
@@ -667,12 +674,14 @@ nfqnl_set_mode(struct nfqnl_instance *qu
 static int
 dev_cmp(struct nfqnl_queue_entry *entry, unsigned long ifindex)
 {
-	if (entry->info->indev)
-		if (entry->info->indev->ifindex == ifindex)
+	struct nf_info *entinf = entry->info;
+	
+	if (entinf->indev)
+		if (entinf->indev->ifindex == ifindex)
 			return 1;
 			
-	if (entry->info->outdev)
-		if (entry->info->outdev->ifindex == ifindex)
+	if (entinf->outdev)
+		if (entinf->outdev->ifindex == ifindex)
 			return 1;
 
 	return 0;
