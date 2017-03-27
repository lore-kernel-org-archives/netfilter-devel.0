From: gfree.wind@foxmail.com
Subject: [PATCH nf-next v2 1/1] netfilter: nat: Correct the return value check for nat mangled packet
Date: Mon, 27 Mar 2017 23:12:08 +0800
Message-ID: <1490627528-32491-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG8.QQ.COM ([183.60.61.201]:46361 "EHLO smtpbg8.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753296AbdC0PYq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 11:24:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

The return value type of function nf_nat_mangle_tcp/udp_packet is
int, but actually it is used as bool type. And most codes follow
this rule, for example, the sip, h323, and ftp. But some codes treat
the return value as NF_ACCEPT and NF_DROP, like amanda and irc.

Now use the bool type instead of the int to make it clear.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v2: Merge two patches into one, and enhance the subject, per Pablo
 v1: init version

 include/net/netfilter/nf_nat_helper.h | 14 ++++++------
 net/ipv4/netfilter/nf_nat_pptp.c      | 20 +++++++++---------
 net/netfilter/nf_nat_amanda.c         | 11 +++++-----
 net/netfilter/nf_nat_helper.c         | 40 +++++++++++++++++------------------
 net/netfilter/nf_nat_irc.c            |  9 ++++----
 5 files changed, 46 insertions(+), 48 deletions(-)

diff --git a/include/net/netfilter/nf_nat_helper.h b/include/net/netfilter/nf_nat_helper.h
index 01bcc6b..b27c391 100644
--- a/include/net/netfilter/nf_nat_helper.h
+++ b/include/net/netfilter/nf_nat_helper.h
@@ -7,13 +7,13 @@
 struct sk_buff;
 
 /* These return true or false. */
-int __nf_nat_mangle_tcp_packet(struct sk_buff *skb, struct nf_conn *ct,
+bool __nf_nat_mangle_tcp_packet(struct sk_buff *skb, struct nf_conn *ct,
 			       enum ip_conntrack_info ctinfo,
 			       unsigned int protoff, unsigned int match_offset,
 			       unsigned int match_len, const char *rep_buffer,
 			       unsigned int rep_len, bool adjust);
 
-static inline int nf_nat_mangle_tcp_packet(struct sk_buff *skb,
+static inline bool nf_nat_mangle_tcp_packet(struct sk_buff *skb,
 					   struct nf_conn *ct,
 					   enum ip_conntrack_info ctinfo,
 					   unsigned int protoff,
@@ -27,11 +27,11 @@ static inline int nf_nat_mangle_tcp_packet(struct sk_buff *skb,
 					  rep_buffer, rep_len, true);
 }
 
-int nf_nat_mangle_udp_packet(struct sk_buff *skb, struct nf_conn *ct,
-			     enum ip_conntrack_info ctinfo,
-			     unsigned int protoff, unsigned int match_offset,
-			     unsigned int match_len, const char *rep_buffer,
-			     unsigned int rep_len);
+bool nf_nat_mangle_udp_packet(struct sk_buff *skb, struct nf_conn *ct,
+			      enum ip_conntrack_info ctinfo,
+			      unsigned int protoff, unsigned int match_offset,
+			      unsigned int match_len, const char *rep_buffer,
+			      unsigned int rep_len);
 
 /* Setup NAT on this expected conntrack so it follows master, but goes
  * to port ct->master->saved_proto. */
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index b3ca21b..211fee5 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -177,11 +177,11 @@ pptp_outbound_pkt(struct sk_buff *skb,
 		 ntohs(REQ_CID(pptpReq, cid_off)), ntohs(new_callid));
 
 	/* mangle packet */
-	if (nf_nat_mangle_tcp_packet(skb, ct, ctinfo, protoff,
-				     cid_off + sizeof(struct pptp_pkt_hdr) +
-				     sizeof(struct PptpControlHeader),
-				     sizeof(new_callid), (char *)&new_callid,
-				     sizeof(new_callid)) == 0)
+	if (!nf_nat_mangle_tcp_packet(skb, ct, ctinfo, protoff,
+				      cid_off + sizeof(struct pptp_pkt_hdr) +
+				      sizeof(struct PptpControlHeader),
+				      sizeof(new_callid), (char *)&new_callid,
+				      sizeof(new_callid)))
 		return NF_DROP;
 	return NF_ACCEPT;
 }
@@ -271,11 +271,11 @@ pptp_inbound_pkt(struct sk_buff *skb,
 	pr_debug("altering peer call id from 0x%04x to 0x%04x\n",
 		 ntohs(REQ_CID(pptpReq, pcid_off)), ntohs(new_pcid));
 
-	if (nf_nat_mangle_tcp_packet(skb, ct, ctinfo, protoff,
-				     pcid_off + sizeof(struct pptp_pkt_hdr) +
-				     sizeof(struct PptpControlHeader),
-				     sizeof(new_pcid), (char *)&new_pcid,
-				     sizeof(new_pcid)) == 0)
+	if (!nf_nat_mangle_tcp_packet(skb, ct, ctinfo, protoff,
+				      pcid_off + sizeof(struct pptp_pkt_hdr) +
+				      sizeof(struct PptpControlHeader),
+				      sizeof(new_pcid), (char *)&new_pcid,
+				      sizeof(new_pcid)))
 		return NF_DROP;
 	return NF_ACCEPT;
 }
diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index eb77238..e4d61a7 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -33,7 +33,6 @@ static unsigned int help(struct sk_buff *skb,
 {
 	char buffer[sizeof("65535")];
 	u_int16_t port;
-	unsigned int ret;
 
 	/* Connection comes from client. */
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
@@ -63,14 +62,14 @@ static unsigned int help(struct sk_buff *skb,
 	}
 
 	sprintf(buffer, "%u", port);
-	ret = nf_nat_mangle_udp_packet(skb, exp->master, ctinfo,
-				       protoff, matchoff, matchlen,
-				       buffer, strlen(buffer));
-	if (ret != NF_ACCEPT) {
+	if (!nf_nat_mangle_udp_packet(skb, exp->master, ctinfo,
+				      protoff, matchoff, matchlen,
+				      buffer, strlen(buffer))) {
 		nf_ct_helper_log(skb, exp->master, "cannot mangle packet");
 		nf_ct_unexpect_related(exp);
+		return NF_DROP;
 	}
-	return ret;
+	return NF_ACCEPT;
 }
 
 static void __exit nf_nat_amanda_fini(void)
diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
index 211661c..607a373 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -70,15 +70,15 @@ static void mangle_contents(struct sk_buff *skb,
 }
 
 /* Unusual, but possible case. */
-static int enlarge_skb(struct sk_buff *skb, unsigned int extra)
+static bool enlarge_skb(struct sk_buff *skb, unsigned int extra)
 {
 	if (skb->len + extra > 65535)
-		return 0;
+		return false;
 
 	if (pskb_expand_head(skb, 0, extra - skb_tailroom(skb), GFP_ATOMIC))
-		return 0;
+		return false;
 
-	return 1;
+	return true;
 }
 
 /* Generic function for mangling variable-length address changes inside
@@ -89,26 +89,26 @@ static int enlarge_skb(struct sk_buff *skb, unsigned int extra)
  * skb enlargement, ...
  *
  * */
-int __nf_nat_mangle_tcp_packet(struct sk_buff *skb,
-			       struct nf_conn *ct,
-			       enum ip_conntrack_info ctinfo,
-			       unsigned int protoff,
-			       unsigned int match_offset,
-			       unsigned int match_len,
-			       const char *rep_buffer,
-			       unsigned int rep_len, bool adjust)
+bool __nf_nat_mangle_tcp_packet(struct sk_buff *skb,
+				struct nf_conn *ct,
+				enum ip_conntrack_info ctinfo,
+				unsigned int protoff,
+				unsigned int match_offset,
+				unsigned int match_len,
+				const char *rep_buffer,
+				unsigned int rep_len, bool adjust)
 {
 	const struct nf_nat_l3proto *l3proto;
 	struct tcphdr *tcph;
 	int oldlen, datalen;
 
 	if (!skb_make_writable(skb, skb->len))
-		return 0;
+		return false;
 
 	if (rep_len > match_len &&
 	    rep_len - match_len > skb_tailroom(skb) &&
 	    !enlarge_skb(skb, rep_len - match_len))
-		return 0;
+		return false;
 
 	SKB_LINEAR_ASSERT(skb);
 
@@ -128,7 +128,7 @@ int __nf_nat_mangle_tcp_packet(struct sk_buff *skb,
 		nf_ct_seqadj_set(ct, ctinfo, tcph->seq,
 				 (int)rep_len - (int)match_len);
 
-	return 1;
+	return true;
 }
 EXPORT_SYMBOL(__nf_nat_mangle_tcp_packet);
 
@@ -142,7 +142,7 @@ EXPORT_SYMBOL(__nf_nat_mangle_tcp_packet);
  * XXX - This function could be merged with nf_nat_mangle_tcp_packet which
  *       should be fairly easy to do.
  */
-int
+bool
 nf_nat_mangle_udp_packet(struct sk_buff *skb,
 			 struct nf_conn *ct,
 			 enum ip_conntrack_info ctinfo,
@@ -157,12 +157,12 @@ nf_nat_mangle_udp_packet(struct sk_buff *skb,
 	int datalen, oldlen;
 
 	if (!skb_make_writable(skb, skb->len))
-		return 0;
+		return false;
 
 	if (rep_len > match_len &&
 	    rep_len - match_len > skb_tailroom(skb) &&
 	    !enlarge_skb(skb, rep_len - match_len))
-		return 0;
+		return false;
 
 	udph = (void *)skb->data + protoff;
 
@@ -176,13 +176,13 @@ nf_nat_mangle_udp_packet(struct sk_buff *skb,
 
 	/* fix udp checksum if udp checksum was previously calculated */
 	if (!udph->check && skb->ip_summed != CHECKSUM_PARTIAL)
-		return 1;
+		return true;
 
 	l3proto = __nf_nat_l3proto_find(nf_ct_l3num(ct));
 	l3proto->csum_recalc(skb, IPPROTO_UDP, udph, &udph->check,
 			     datalen, oldlen);
 
-	return 1;
+	return true;
 }
 EXPORT_SYMBOL(nf_nat_mangle_udp_packet);
 
diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index 1fb2258..0648cb0 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -37,7 +37,6 @@ static unsigned int help(struct sk_buff *skb,
 	struct nf_conn *ct = exp->master;
 	union nf_inet_addr newaddr;
 	u_int16_t port;
-	unsigned int ret;
 
 	/* Reply comes from server. */
 	newaddr = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3;
@@ -83,14 +82,14 @@ static unsigned int help(struct sk_buff *skb,
 	pr_debug("nf_nat_irc: inserting '%s' == %pI4, port %u\n",
 		 buffer, &newaddr.ip, port);
 
-	ret = nf_nat_mangle_tcp_packet(skb, ct, ctinfo, protoff, matchoff,
-				       matchlen, buffer, strlen(buffer));
-	if (ret != NF_ACCEPT) {
+	if (!nf_nat_mangle_tcp_packet(skb, ct, ctinfo, protoff, matchoff,
+				      matchlen, buffer, strlen(buffer))) {
 		nf_ct_helper_log(skb, ct, "cannot mangle packet");
 		nf_ct_unexpect_related(exp);
+		return NF_DROP;
 	}
 
-	return ret;
+	return NF_ACCEPT;
 }
 
 static void __exit nf_nat_irc_fini(void)
-- 
2.7.4



