From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 2/2] netfilter: nf_log: get rid of XT_LOG_* macros
Date: Sun, 25 Sep 2016 16:47:05 +0800
Message-ID: <1474793225-4065-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:52056 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938606AbcIYIrq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 04:47:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

nf_log is used by both nftables and iptables, so use XT_LOG_XXX macros
here is not appropriate. Replace them with NF_LOG_XXX.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 I received the reject msg: "The capital Triple-X in subject is way too
 often associated  with junk email, please rephrase ..."
 So I rename LOG_XXX to LOG_*, and resend this patch again!

 net/ipv4/netfilter/nf_log_ipv4.c |  6 +++---
 net/ipv6/netfilter/nf_log_ipv6.c | 14 +++++++-------
 net/netfilter/nf_log_common.c    |  4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/netfilter/nf_log_ipv4.c b/net/ipv4/netfilter/nf_log_ipv4.c
index 5b571e1..8566489 100644
--- a/net/ipv4/netfilter/nf_log_ipv4.c
+++ b/net/ipv4/netfilter/nf_log_ipv4.c
@@ -76,7 +76,7 @@ static void dump_ipv4_packet(struct nf_log_buf *m,
 	if (ntohs(ih->frag_off) & IP_OFFSET)
 		nf_log_buf_add(m, "FRAG:%u ", ntohs(ih->frag_off) & IP_OFFSET);
 
-	if ((logflags & XT_LOG_IPOPT) &&
+	if ((logflags & NF_LOG_IPOPT) &&
 	    ih->ihl * 4 > sizeof(struct iphdr)) {
 		const unsigned char *op;
 		unsigned char _opt[4 * 15 - sizeof(struct iphdr)];
@@ -250,7 +250,7 @@ static void dump_ipv4_packet(struct nf_log_buf *m,
 	}
 
 	/* Max length: 15 "UID=4294967295 " */
-	if ((logflags & XT_LOG_UID) && !iphoff)
+	if ((logflags & NF_LOG_UID) && !iphoff)
 		nf_log_dump_sk_uid_gid(m, skb->sk);
 
 	/* Max length: 16 "MARK=0xFFFFFFFF " */
@@ -282,7 +282,7 @@ static void dump_ipv4_mac_header(struct nf_log_buf *m,
 	if (info->type == NF_LOG_TYPE_LOG)
 		logflags = info->u.log.logflags;
 
-	if (!(logflags & XT_LOG_MACDECODE))
+	if (!(logflags & NF_LOG_MACDECODE))
 		goto fallback;
 
 	switch (dev->type) {
diff --git a/net/ipv6/netfilter/nf_log_ipv6.c b/net/ipv6/netfilter/nf_log_ipv6.c
index f6aee28..57d8606 100644
--- a/net/ipv6/netfilter/nf_log_ipv6.c
+++ b/net/ipv6/netfilter/nf_log_ipv6.c
@@ -84,7 +84,7 @@ static void dump_ipv6_packet(struct nf_log_buf *m,
 		}
 
 		/* Max length: 48 "OPT (...) " */
-		if (logflags & XT_LOG_IPOPT)
+		if (logflags & NF_LOG_IPOPT)
 			nf_log_buf_add(m, "OPT ( ");
 
 		switch (currenthdr) {
@@ -121,7 +121,7 @@ static void dump_ipv6_packet(struct nf_log_buf *m,
 		case IPPROTO_ROUTING:
 		case IPPROTO_HOPOPTS:
 			if (fragment) {
-				if (logflags & XT_LOG_IPOPT)
+				if (logflags & NF_LOG_IPOPT)
 					nf_log_buf_add(m, ")");
 				return;
 			}
@@ -129,7 +129,7 @@ static void dump_ipv6_packet(struct nf_log_buf *m,
 			break;
 		/* Max Length */
 		case IPPROTO_AH:
-			if (logflags & XT_LOG_IPOPT) {
+			if (logflags & NF_LOG_IPOPT) {
 				struct ip_auth_hdr _ahdr;
 				const struct ip_auth_hdr *ah;
 
@@ -161,7 +161,7 @@ static void dump_ipv6_packet(struct nf_log_buf *m,
 			hdrlen = (hp->hdrlen+2)<<2;
 			break;
 		case IPPROTO_ESP:
-			if (logflags & XT_LOG_IPOPT) {
+			if (logflags & NF_LOG_IPOPT) {
 				struct ip_esp_hdr _esph;
 				const struct ip_esp_hdr *eh;
 
@@ -194,7 +194,7 @@ static void dump_ipv6_packet(struct nf_log_buf *m,
 			nf_log_buf_add(m, "Unknown Ext Hdr %u", currenthdr);
 			return;
 		}
-		if (logflags & XT_LOG_IPOPT)
+		if (logflags & NF_LOG_IPOPT)
 			nf_log_buf_add(m, ") ");
 
 		currenthdr = hp->nexthdr;
@@ -277,7 +277,7 @@ static void dump_ipv6_packet(struct nf_log_buf *m,
 	}
 
 	/* Max length: 15 "UID=4294967295 " */
-	if ((logflags & XT_LOG_UID) && recurse)
+	if ((logflags & NF_LOG_UID) && recurse)
 		nf_log_dump_sk_uid_gid(m, skb->sk);
 
 	/* Max length: 16 "MARK=0xFFFFFFFF " */
@@ -295,7 +295,7 @@ static void dump_ipv6_mac_header(struct nf_log_buf *m,
 	if (info->type == NF_LOG_TYPE_LOG)
 		logflags = info->u.log.logflags;
 
-	if (!(logflags & XT_LOG_MACDECODE))
+	if (!(logflags & NF_LOG_MACDECODE))
 		goto fallback;
 
 	switch (dev->type) {
diff --git a/net/netfilter/nf_log_common.c b/net/netfilter/nf_log_common.c
index a5aa596..119fe1c 100644
--- a/net/netfilter/nf_log_common.c
+++ b/net/netfilter/nf_log_common.c
@@ -77,7 +77,7 @@ int nf_log_dump_tcp_header(struct nf_log_buf *m, const struct sk_buff *skb,
 	nf_log_buf_add(m, "SPT=%u DPT=%u ",
 		       ntohs(th->source), ntohs(th->dest));
 	/* Max length: 30 "SEQ=4294967295 ACK=4294967295 " */
-	if (logflags & XT_LOG_TCPSEQ) {
+	if (logflags & NF_LOG_TCPSEQ) {
 		nf_log_buf_add(m, "SEQ=%u ACK=%u ",
 			       ntohl(th->seq), ntohl(th->ack_seq));
 	}
@@ -107,7 +107,7 @@ int nf_log_dump_tcp_header(struct nf_log_buf *m, const struct sk_buff *skb,
 	/* Max length: 11 "URGP=65535 " */
 	nf_log_buf_add(m, "URGP=%u ", ntohs(th->urg_ptr));
 
-	if ((logflags & XT_LOG_TCPOPT) && th->doff*4 > sizeof(struct tcphdr)) {
+	if ((logflags & NF_LOG_TCPOPT) && th->doff*4 > sizeof(struct tcphdr)) {
 		u_int8_t _opt[60 - sizeof(struct tcphdr)];
 		const u_int8_t *op;
 		unsigned int i;
-- 
2.5.5


