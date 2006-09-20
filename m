From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 27/39]: PPTP conntrack: get rid of unnecessary byte
	order conversions
Date: Wed, 20 Sep 2006 10:24:26 +0200 (MEST)
Message-ID: <20060920082517.14636.25440.sendpatchset@localhost.localdomain>
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

[NETFILTER]: PPTP conntrack: get rid of unnecessary byte order conversions

The conntrack structure contains the call ID in host byte order for no
reason, get rid of back and forth conversions.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a1495e7210e4ed162b958b06ffe11623bd0a2b0a
tree d072ce1843019e49bd9c41ba49d6e714f457746f
parent fdb933d1bab11555cfd4e89823329deabec5a44b
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:38:50 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:38:50 +0200

 include/linux/netfilter_ipv4/ip_conntrack_pptp.h   |    8 ++--
 .../linux/netfilter_ipv4/ip_conntrack_proto_gre.h  |   22 ++++++------
 include/linux/netfilter_ipv4/ip_nat_pptp.h         |    4 +-
 net/ipv4/netfilter/ip_conntrack_helper_pptp.c      |   22 +++++-----
 net/ipv4/netfilter/ip_nat_helper_pptp.c            |   42 ++++++++++----------
 net/ipv4/netfilter/ip_nat_proto_gre.c              |    2 -
 6 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack_pptp.h b/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
index 88f66d3..0d35623 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
@@ -31,8 +31,8 @@ struct ip_ct_pptp_master {
 	/* everything below is going to be per-expectation in newnat,
 	 * since there could be more than one call within one session */
 	enum pptp_ctrlcall_state cstate;	/* call state */
-	u_int16_t pac_call_id;			/* call id of PAC, host byte order */
-	u_int16_t pns_call_id;			/* call id of PNS, host byte order */
+	__be16 pac_call_id;			/* call id of PAC, host byte order */
+	__be16 pns_call_id;			/* call id of PNS, host byte order */
 
 	/* in pre-2.6.11 this used to be per-expect. Now it is per-conntrack
 	 * and therefore imposes a fixed limit on the number of maps */
@@ -42,8 +42,8 @@ struct ip_ct_pptp_master {
 /* conntrack_expect private member */
 struct ip_ct_pptp_expect {
 	enum pptp_ctrlcall_state cstate; 	/* call state */
-	u_int16_t pac_call_id;			/* call id of PAC */
-	u_int16_t pns_call_id;			/* call id of PNS */
+	__be16 pac_call_id;			/* call id of PAC */
+	__be16 pns_call_id;			/* call id of PNS */
 };
 
 
diff --git a/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h b/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h
index 8d090ef..1d853aa 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h
@@ -49,18 +49,18 @@ #elif defined(__BIG_ENDIAN_BITFIELD)
 #else
 #error "Adjust your <asm/byteorder.h> defines"
 #endif
-	__u16	protocol;
+	__be16	protocol;
 };
 
 /* modified GRE header for PPTP */
 struct gre_hdr_pptp {
-	__u8  flags;		/* bitfield */
-	__u8  version;		/* should be GRE_VERSION_PPTP */
-	__u16 protocol;		/* should be GRE_PROTOCOL_PPTP */
-	__u16 payload_len;	/* size of ppp payload, not inc. gre header */
-	__u16 call_id;		/* peer's call_id for this session */
-	__u32 seq;		/* sequence number.  Present if S==1 */
-	__u32 ack;		/* seq number of highest packet recieved by */
+	__u8   flags;		/* bitfield */
+	__u8   version;		/* should be GRE_VERSION_PPTP */
+	__be16 protocol;	/* should be GRE_PROTOCOL_PPTP */
+	__be16 payload_len;	/* size of ppp payload, not inc. gre header */
+	__be16 call_id;		/* peer's call_id for this session */
+	__be32 seq;		/* sequence number.  Present if S==1 */
+	__be32 ack;		/* seq number of highest packet recieved by */
 				/*  sender in this session */
 };
 
@@ -92,13 +92,13 @@ void ip_ct_gre_keymap_destroy(struct ip_
 
 
 /* get pointer to gre key, if present */
-static inline u_int32_t *gre_key(struct gre_hdr *greh)
+static inline __be32 *gre_key(struct gre_hdr *greh)
 {
 	if (!greh->key)
 		return NULL;
 	if (greh->csum || greh->routing)
-		return (u_int32_t *) (greh+sizeof(*greh)+4);
-	return (u_int32_t *) (greh+sizeof(*greh));
+		return (__be32 *) (greh+sizeof(*greh)+4);
+	return (__be32 *) (greh+sizeof(*greh));
 }
 
 /* get pointer ot gre csum, if present */
diff --git a/include/linux/netfilter_ipv4/ip_nat_pptp.h b/include/linux/netfilter_ipv4/ip_nat_pptp.h
index eaf66c2..36668bf 100644
--- a/include/linux/netfilter_ipv4/ip_nat_pptp.h
+++ b/include/linux/netfilter_ipv4/ip_nat_pptp.h
@@ -4,8 +4,8 @@ #define _NAT_PPTP_H
 
 /* conntrack private data */
 struct ip_nat_pptp {
-	u_int16_t pns_call_id;		/* NAT'ed PNS call id */
-	u_int16_t pac_call_id;		/* NAT'ed PAC call id */
+	__be16 pns_call_id;		/* NAT'ed PNS call id */
+	__be16 pac_call_id;		/* NAT'ed PAC call id */
 };
 
 #endif /* _NAT_PPTP_H */
diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
index 6c94dd5..57637ca 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -201,8 +201,8 @@ static void pptp_destroy_siblings(struct
 	/* try original (pns->pac) tuple */
 	memcpy(&t, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, sizeof(t));
 	t.dst.protonum = IPPROTO_GRE;
-	t.src.u.gre.key = htons(ct->help.ct_pptp_info.pns_call_id);
-	t.dst.u.gre.key = htons(ct->help.ct_pptp_info.pac_call_id);
+	t.src.u.gre.key = ct->help.ct_pptp_info.pns_call_id;
+	t.dst.u.gre.key = ct->help.ct_pptp_info.pac_call_id;
 
 	if (!destroy_sibling_or_exp(&t))
 		DEBUGP("failed to timeout original pns->pac ct/exp\n");
@@ -210,8 +210,8 @@ static void pptp_destroy_siblings(struct
 	/* try reply (pac->pns) tuple */
 	memcpy(&t, &ct->tuplehash[IP_CT_DIR_REPLY].tuple, sizeof(t));
 	t.dst.protonum = IPPROTO_GRE;
-	t.src.u.gre.key = htons(ct->help.ct_pptp_info.pac_call_id);
-	t.dst.u.gre.key = htons(ct->help.ct_pptp_info.pns_call_id);
+	t.src.u.gre.key = ct->help.ct_pptp_info.pac_call_id;
+	t.dst.u.gre.key = ct->help.ct_pptp_info.pns_call_id;
 
 	if (!destroy_sibling_or_exp(&t))
 		DEBUGP("failed to timeout reply pac->pns ct/exp\n");
@@ -419,9 +419,9 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		cid = &pptpReq->ocack.callID;
 		pcid = &pptpReq->ocack.peersCallID;
 
-		info->pac_call_id = ntohs(*cid);
+		info->pac_call_id = *cid;
 
-		if (htons(info->pns_call_id) != *pcid) {
+		if (info->pns_call_id != *pcid) {
 			DEBUGP("%s for unknown callid %u\n",
 				pptp_msg_name[msg], ntohs(*pcid));
 			break;
@@ -454,7 +454,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		pcid = &pptpReq->icack.peersCallID;
 		DEBUGP("%s, PCID=%X\n", pptp_msg_name[msg], ntohs(*pcid));
 		info->cstate = PPTP_CALL_IN_REQ;
-		info->pac_call_id = ntohs(*pcid);
+		info->pac_call_id = *pcid;
 		break;
 
 	case PPTP_IN_CALL_CONNECT:
@@ -478,7 +478,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		pcid = &pptpReq->iccon.peersCallID;
 		cid = &info->pac_call_id;
 
-		if (info->pns_call_id != ntohs(*pcid)) {
+		if (info->pns_call_id != *pcid) {
 			DEBUGP("%s for unknown CallID %u\n",
 				pptp_msg_name[msg], ntohs(*pcid));
 			break;
@@ -595,7 +595,7 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		/* track PNS call id */
 		cid = &pptpReq->ocreq.callID;
 		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(*cid));
-		info->pns_call_id = ntohs(*cid);
+		info->pns_call_id = *cid;
 		break;
 	case PPTP_IN_CALL_REPLY:
 		if (reqlen < sizeof(_pptpReq.icack)) {
@@ -615,7 +615,7 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 			break;
 		}
 		pcid = &pptpReq->icack.peersCallID;
-		if (info->pac_call_id != ntohs(*pcid)) {
+		if (info->pac_call_id != *pcid) {
 			DEBUGP("%s for unknown call %u\n",
 				pptp_msg_name[msg], ntohs(*pcid));
 			break;
@@ -623,7 +623,7 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(*pcid));
 		/* part two of the three-way handshake */
 		info->cstate = PPTP_CALL_IN_REP;
-		info->pns_call_id = ntohs(pptpReq->icack.callID);
+		info->pns_call_id = pptpReq->icack.callID;
 		break;
 
 	case PPTP_CALL_CLEAR_REQUEST:
diff --git a/net/ipv4/netfilter/ip_nat_helper_pptp.c b/net/ipv4/netfilter/ip_nat_helper_pptp.c
index 5dde1da..6e8bd6b 100644
--- a/net/ipv4/netfilter/ip_nat_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_nat_helper_pptp.c
@@ -85,19 +85,17 @@ static void pptp_nat_expected(struct ip_
 		DEBUGP("we are PNS->PAC\n");
 		/* therefore, build tuple for PAC->PNS */
 		t.src.ip = master->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
-		t.src.u.gre.key = htons(master->help.ct_pptp_info.pac_call_id);
+		t.src.u.gre.key = master->help.ct_pptp_info.pac_call_id;
 		t.dst.ip = master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
-		t.dst.u.gre.key = htons(master->help.ct_pptp_info.pns_call_id);
+		t.dst.u.gre.key = master->help.ct_pptp_info.pns_call_id;
 		t.dst.protonum = IPPROTO_GRE;
 	} else {
 		DEBUGP("we are PAC->PNS\n");
 		/* build tuple for PNS->PAC */
 		t.src.ip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
-		t.src.u.gre.key =
-			htons(master->nat.help.nat_pptp_info.pns_call_id);
+		t.src.u.gre.key = master->nat.help.nat_pptp_info.pns_call_id;
 		t.dst.ip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
-		t.dst.u.gre.key =
-			htons(master->nat.help.nat_pptp_info.pac_call_id);
+		t.dst.u.gre.key = master->nat.help.nat_pptp_info.pac_call_id;
 		t.dst.protonum = IPPROTO_GRE;
 	}
 
@@ -149,10 +147,11 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 {
 	struct ip_ct_pptp_master *ct_pptp_info = &ct->help.ct_pptp_info;
 	struct ip_nat_pptp *nat_pptp_info = &ct->nat.help.nat_pptp_info;
-	u_int16_t msg, new_callid;
+	u_int16_t msg;
+	__be16 new_callid;
 	unsigned int cid_off;
 
-	new_callid = htons(ct_pptp_info->pns_call_id);
+	new_callid = ct_pptp_info->pns_call_id;
 
 	switch (msg = ntohs(ctlh->messageType)) {
 	case PPTP_OUT_CALL_REQUEST:
@@ -170,7 +169,7 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		new_callid = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.tcp.port;
 
 		/* save new call ID in ct info */
-		ct_pptp_info->pns_call_id = ntohs(new_callid);
+		ct_pptp_info->pns_call_id = new_callid;
 		break;
 	case PPTP_IN_CALL_REPLY:
 		cid_off = offsetof(union pptp_ctrl_union, icreq.callID);
@@ -235,14 +234,14 @@ pptp_exp_gre(struct ip_conntrack_expect 
 
 	/* alter expectation for PNS->PAC direction */
 	invert_tuplepr(&inv_t, &expect_orig->tuple);
-	expect_orig->saved_proto.gre.key = htons(ct_pptp_info->pns_call_id);
-	expect_orig->tuple.src.u.gre.key = htons(nat_pptp_info->pns_call_id);
-	expect_orig->tuple.dst.u.gre.key = htons(ct_pptp_info->pac_call_id);
+	expect_orig->saved_proto.gre.key = ct_pptp_info->pns_call_id;
+	expect_orig->tuple.src.u.gre.key = nat_pptp_info->pns_call_id;
+	expect_orig->tuple.dst.u.gre.key = ct_pptp_info->pac_call_id;
 	expect_orig->dir = IP_CT_DIR_ORIGINAL;
 	inv_t.src.ip = reply_t->src.ip;
 	inv_t.dst.ip = reply_t->dst.ip;
-	inv_t.src.u.gre.key = htons(nat_pptp_info->pac_call_id);
-	inv_t.dst.u.gre.key = htons(ct_pptp_info->pns_call_id);
+	inv_t.src.u.gre.key = nat_pptp_info->pac_call_id;
+	inv_t.dst.u.gre.key = ct_pptp_info->pns_call_id;
 
 	if (!ip_conntrack_expect_related(expect_orig)) {
 		DEBUGP("successfully registered expect\n");
@@ -253,14 +252,14 @@ pptp_exp_gre(struct ip_conntrack_expect 
 
 	/* alter expectation for PAC->PNS direction */
 	invert_tuplepr(&inv_t, &expect_reply->tuple);
-	expect_reply->saved_proto.gre.key = htons(nat_pptp_info->pns_call_id);
-	expect_reply->tuple.src.u.gre.key = htons(nat_pptp_info->pac_call_id);
-	expect_reply->tuple.dst.u.gre.key = htons(ct_pptp_info->pns_call_id);
+	expect_reply->saved_proto.gre.key = nat_pptp_info->pns_call_id;
+	expect_reply->tuple.src.u.gre.key = nat_pptp_info->pac_call_id;
+	expect_reply->tuple.dst.u.gre.key = ct_pptp_info->pns_call_id;
 	expect_reply->dir = IP_CT_DIR_REPLY;
 	inv_t.src.ip = orig_t->src.ip;
 	inv_t.dst.ip = orig_t->dst.ip;
-	inv_t.src.u.gre.key = htons(nat_pptp_info->pns_call_id);
-	inv_t.dst.u.gre.key = htons(ct_pptp_info->pac_call_id);
+	inv_t.src.u.gre.key = nat_pptp_info->pns_call_id;
+	inv_t.dst.u.gre.key = ct_pptp_info->pac_call_id;
 
 	if (!ip_conntrack_expect_related(expect_reply)) {
 		DEBUGP("successfully registered expect\n");
@@ -297,10 +296,11 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		 union pptp_ctrl_union *pptpReq)
 {
 	struct ip_nat_pptp *nat_pptp_info = &ct->nat.help.nat_pptp_info;
-	u_int16_t msg, new_cid = 0, new_pcid;
+	u_int16_t msg, new_cid = 0;
+	__be16 new_pcid;
 	unsigned int pcid_off, cid_off = 0;
 
-	new_pcid = htons(nat_pptp_info->pns_call_id);
+	new_pcid = nat_pptp_info->pns_call_id;
 
 	switch (msg = ntohs(ctlh->messageType)) {
 	case PPTP_OUT_CALL_REPLY:
diff --git a/net/ipv4/netfilter/ip_nat_proto_gre.c b/net/ipv4/netfilter/ip_nat_proto_gre.c
index a522669..bf91f93 100644
--- a/net/ipv4/netfilter/ip_nat_proto_gre.c
+++ b/net/ipv4/netfilter/ip_nat_proto_gre.c
@@ -67,7 +67,7 @@ gre_unique_tuple(struct ip_conntrack_tup
 		 const struct ip_conntrack *conntrack)
 {
 	static u_int16_t key;
-	u_int16_t *keyptr;
+	__be16 *keyptr;
 	unsigned int min, i, range_size;
 
 	if (maniptype == IP_NAT_MANIP_SRC)
