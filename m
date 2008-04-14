From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 38/41]: nf_conntrack: const annotations in nf_conntrack_sctp, nf_nat_proto_gre
Date: Mon, 14 Apr 2008 12:17:10 +0200 (MEST)
Message-ID: <20080414101707.32717.95388.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36366 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbYDNKRM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:17:12 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: const annotations in nf_conntrack_sctp, nf_nat_proto_gre

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 956beed156a5deb0f47dcb139aa4831339dea867
tree abb2151bdb5ba4feceae922e7a7156b1b76e8f71
parent e5e2afebff27cfd1368d39f089831d0921778c0d
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Apr 2008 12:10:57 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:57 +0200

 net/ipv4/netfilter/nf_nat_proto_dccp.c  |    2 +-
 net/ipv4/netfilter/nf_nat_proto_gre.c   |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c |   17 +++++++++++------
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_proto_dccp.c b/net/ipv4/netfilter/nf_nat_proto_dccp.c
index f78eb26..22485ce 100644
--- a/net/ipv4/netfilter/nf_nat_proto_dccp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_dccp.c
@@ -38,7 +38,7 @@ dccp_manip_pkt(struct sk_buff *skb,
 	       const struct nf_conntrack_tuple *tuple,
 	       enum nf_nat_manip_type maniptype)
 {
-	struct iphdr *iph = (struct iphdr *)(skb->data + iphdroff);
+	const struct iphdr *iph = (const void *)(skb->data + iphdroff);
 	struct dccp_hdr *hdr;
 	unsigned int hdroff = iphdroff + iph->ihl * 4;
 	__be32 oldip, newip;
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index 4c4af5a..d7e8920 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -84,7 +84,7 @@ gre_manip_pkt(struct sk_buff *skb, unsigned int iphdroff,
 	      const struct nf_conntrack_tuple *tuple,
 	      enum nf_nat_manip_type maniptype)
 {
-	struct gre_hdr *greh;
+	const struct gre_hdr *greh;
 	struct gre_hdr_pptp *pgreh;
 	const struct iphdr *iph = (struct iphdr *)(skb->data + iphdroff);
 	unsigned int hdroff = iphdroff + iph->ihl * 4;
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 2d47351..cbf2e27 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -33,7 +33,7 @@ static DEFINE_RWLOCK(sctp_lock);
 
    And so for me for SCTP :D -Kiran */
 
-static const char *sctp_conntrack_names[] = {
+static const char *const sctp_conntrack_names[] = {
 	"NONE",
 	"CLOSED",
 	"COOKIE_WAIT",
@@ -133,7 +133,8 @@ static const u8 sctp_conntracks[2][9][SCTP_CONNTRACK_MAX] = {
 static bool sctp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
 			      struct nf_conntrack_tuple *tuple)
 {
-	sctp_sctphdr_t _hdr, *hp;
+	const struct sctphdr *hp;
+	struct sctphdr _hdr;
 
 	/* Actually only need first 8 bytes. */
 	hp = skb_header_pointer(skb, dataoff, 8, &_hdr);
@@ -291,8 +292,10 @@ static int sctp_packet(struct nf_conn *ct,
 {
 	enum sctp_conntrack new_state, old_state;
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	sctp_sctphdr_t _sctph, *sh;
-	sctp_chunkhdr_t _sch, *sch;
+	const struct sctphdr *sh;
+	struct sctphdr _sctph;
+	const struct sctp_chunkhdr *sch;
+	struct sctp_chunkhdr _sch;
 	u_int32_t offset, count;
 	unsigned long map[256 / sizeof(unsigned long)] = { 0 };
 
@@ -393,8 +396,10 @@ static bool sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 		     unsigned int dataoff)
 {
 	enum sctp_conntrack new_state;
-	sctp_sctphdr_t _sctph, *sh;
-	sctp_chunkhdr_t _sch, *sch;
+	const struct sctphdr *sh;
+	struct sctphdr _sctph;
+	const struct sctp_chunkhdr *sch;
+	struct sctp_chunkhdr _sch;
 	u_int32_t offset, count;
 	unsigned long map[256 / sizeof(unsigned long)] = { 0 };
 
