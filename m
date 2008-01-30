From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 61/69]: nf_{conntrack,nat}_proto_tcp: constify and annotate TCP modules
Date: Wed, 30 Jan 2008 21:18:27 +0100 (MET)
Message-ID: <20080130201825.29874.38579.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60818 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbYA3US3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:29 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_{conntrack,nat}_proto_tcp: constify and annotate TCP modules

Constify a few data tables use const qualifiers on variables where
possible in the nf_*_proto_tcp sources.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 86b8346c2ce0407e1712aefc6e4f9bb5c24fd238
tree a19302786670a00bea34bfa3180447bea60872c0
parent 5eb90087e67023fc3314f7a59702720e2ffe0fc4
author Jan Engelhardt <jengelh@computergmbh.de> Wed, 30 Jan 2008 21:03:16 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:16 +0100

 include/net/netfilter/nf_conntrack.h   |    2 +
 net/ipv4/netfilter/nf_nat_proto_tcp.c  |    2 +
 net/netfilter/nf_conntrack_proto_tcp.c |   44 +++++++++++++++++---------------
 3 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index bda78a2..90b3e7f 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -216,7 +216,7 @@ static inline void nf_ct_refresh(struct nf_conn *ct,
 
 /* These are for NAT.  Icky. */
 /* Update TCP window tracking data when NAT mangles the packet */
-extern void nf_conntrack_tcp_update(struct sk_buff *skb,
+extern void nf_conntrack_tcp_update(const struct sk_buff *skb,
 				    unsigned int dataoff,
 				    struct nf_conn *ct,
 				    int dir);
diff --git a/net/ipv4/netfilter/nf_nat_proto_tcp.c b/net/ipv4/netfilter/nf_nat_proto_tcp.c
index da23e9f..ffd5d15 100644
--- a/net/ipv4/netfilter/nf_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_tcp.c
@@ -93,7 +93,7 @@ tcp_manip_pkt(struct sk_buff *skb,
 	      const struct nf_conntrack_tuple *tuple,
 	      enum nf_nat_manip_type maniptype)
 {
-	struct iphdr *iph = (struct iphdr *)(skb->data + iphdroff);
+	const struct iphdr *iph = (struct iphdr *)(skb->data + iphdroff);
 	struct tcphdr *hdr;
 	unsigned int hdroff = iphdroff + iph->ihl*4;
 	__be32 oldip, newip;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 9807af6..3e0ccca 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -46,7 +46,7 @@ static int nf_ct_tcp_max_retrans __read_mostly = 3;
   /* FIXME: Examine ipfilter's timeouts and conntrack transitions more
      closely.  They're more complex. --RR */
 
-static const char *tcp_conntrack_names[] = {
+static const char *const tcp_conntrack_names[] = {
 	"NONE",
 	"SYN_SENT",
 	"SYN_RECV",
@@ -261,7 +261,8 @@ static int tcp_pkt_to_tuple(const struct sk_buff *skb,
 			    unsigned int dataoff,
 			    struct nf_conntrack_tuple *tuple)
 {
-	struct tcphdr _hdr, *hp;
+	const struct tcphdr *hp;
+	struct tcphdr _hdr;
 
 	/* Actually only need first 8 bytes. */
 	hp = skb_header_pointer(skb, dataoff, 8, &_hdr);
@@ -343,7 +344,7 @@ static unsigned int get_conntrack_index(const struct tcphdr *tcph)
 static inline __u32 segment_seq_plus_len(__u32 seq,
 					 size_t len,
 					 unsigned int dataoff,
-					 struct tcphdr *tcph)
+					 const struct tcphdr *tcph)
 {
 	/* XXX Should I use payload length field in IP/IPv6 header ?
 	 * - YK */
@@ -362,11 +363,11 @@ static inline __u32 segment_seq_plus_len(__u32 seq,
  */
 static void tcp_options(const struct sk_buff *skb,
 			unsigned int dataoff,
-			struct tcphdr *tcph,
+			const struct tcphdr *tcph,
 			struct ip_ct_tcp_state *state)
 {
 	unsigned char buff[(15 * 4) - sizeof(struct tcphdr)];
-	unsigned char *ptr;
+	const unsigned char *ptr;
 	int length = (tcph->doff*4) - sizeof(struct tcphdr);
 
 	if (!length)
@@ -417,10 +418,10 @@ static void tcp_options(const struct sk_buff *skb,
 }
 
 static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
-		     struct tcphdr *tcph, __u32 *sack)
+                     const struct tcphdr *tcph, __u32 *sack)
 {
 	unsigned char buff[(15 * 4) - sizeof(struct tcphdr)];
-	unsigned char *ptr;
+	const unsigned char *ptr;
 	int length = (tcph->doff*4) - sizeof(struct tcphdr);
 	__u32 tmp;
 
@@ -477,18 +478,18 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 	}
 }
 
-static int tcp_in_window(struct nf_conn *ct,
+static int tcp_in_window(const struct nf_conn *ct,
 			 struct ip_ct_tcp *state,
 			 enum ip_conntrack_dir dir,
 			 unsigned int index,
 			 const struct sk_buff *skb,
 			 unsigned int dataoff,
-			 struct tcphdr *tcph,
+			 const struct tcphdr *tcph,
 			 int pf)
 {
 	struct ip_ct_tcp_state *sender = &state->seen[dir];
 	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
-	struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
+	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
 	__u32 seq, ack, sack, end, win, swin;
 	int res;
 
@@ -686,14 +687,14 @@ static int tcp_in_window(struct nf_conn *ct,
 #ifdef CONFIG_NF_NAT_NEEDED
 /* Update sender->td_end after NAT successfully mangled the packet */
 /* Caller must linearize skb at tcp header. */
-void nf_conntrack_tcp_update(struct sk_buff *skb,
+void nf_conntrack_tcp_update(const struct sk_buff *skb,
 			     unsigned int dataoff,
 			     struct nf_conn *ct,
 			     int dir)
 {
-	struct tcphdr *tcph = (void *)skb->data + dataoff;
-	struct ip_ct_tcp_state *sender = &ct->proto.tcp.seen[dir];
-	struct ip_ct_tcp_state *receiver = &ct->proto.tcp.seen[!dir];
+	const struct tcphdr *tcph = (const void *)skb->data + dataoff;
+	const struct ip_ct_tcp_state *sender = &ct->proto.tcp.seen[dir];
+	const struct ip_ct_tcp_state *receiver = &ct->proto.tcp.seen[!dir];
 	__u32 end;
 
 	end = segment_seq_plus_len(ntohl(tcph->seq), skb->len, dataoff, tcph);
@@ -726,7 +727,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_tcp_update);
 #define	TH_CWR	0x80
 
 /* table of valid flag combinations - PUSH, ECE and CWR are always valid */
-static u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_ACK|TH_URG) + 1] =
+static const u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_ACK|TH_URG) + 1] =
 {
 	[TH_SYN]			= 1,
 	[TH_SYN|TH_URG]			= 1,
@@ -746,7 +747,8 @@ static int tcp_error(struct sk_buff *skb,
 		     int pf,
 		     unsigned int hooknum)
 {
-	struct tcphdr _tcph, *th;
+	const struct tcphdr *th;
+	struct tcphdr _tcph;
 	unsigned int tcplen = skb->len - dataoff;
 	u_int8_t tcpflags;
 
@@ -803,7 +805,8 @@ static int tcp_packet(struct nf_conn *ct,
 	struct nf_conntrack_tuple *tuple;
 	enum tcp_conntrack new_state, old_state;
 	enum ip_conntrack_dir dir;
-	struct tcphdr *th, _tcph;
+	const struct tcphdr *th;
+	struct tcphdr _tcph;
 	unsigned long timeout;
 	unsigned int index;
 
@@ -964,9 +967,10 @@ static int tcp_new(struct nf_conn *ct,
 		   unsigned int dataoff)
 {
 	enum tcp_conntrack new_state;
-	struct tcphdr *th, _tcph;
-	struct ip_ct_tcp_state *sender = &ct->proto.tcp.seen[0];
-	struct ip_ct_tcp_state *receiver = &ct->proto.tcp.seen[1];
+	const struct tcphdr *th;
+	struct tcphdr _tcph;
+	const struct ip_ct_tcp_state *sender = &ct->proto.tcp.seen[0];
+	const struct ip_ct_tcp_state *receiver = &ct->proto.tcp.seen[1];
 
 	th = skb_header_pointer(skb, dataoff, sizeof(_tcph), &_tcph);
 	BUG_ON(th == NULL);
