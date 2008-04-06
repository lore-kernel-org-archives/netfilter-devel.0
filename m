From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 7/8] [NETFILTER]: const annotations in nf_conntrack_{sctp,dccp},
 nf_nat_proto_gre
Date: Sun, 6 Apr 2008 05:48:06 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804060547240.30794@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804060541590.30794@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34567 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbYDFDsJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 23:48:09 -0400
In-Reply-To: <alpine.LNX.1.10.0804060541590.30794@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit e43b5ee04535e4809e2f24dc8de7a15e6baf0dee
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sat Mar 8 15:38:13 2008 +0100

     [NETFILTER]: const annotations in nf_conntrack_{sctp,dccp}, nf_nat_proto_gre

     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
  net/ipv4/netfilter/nf_nat_proto_dccp.c  |    2 +-
  net/ipv4/netfilter/nf_nat_proto_gre.c   |    2 +-
  net/netfilter/nf_conntrack_proto_dccp.c |   18 +++++++++++-------
  net/netfilter/nf_conntrack_proto_sctp.c |   17 +++++++++++------
  4 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_proto_dccp.c b/net/ipv4/netfilter/nf_nat_proto_dccp.c
index d4b43ac..38bd8e8 100644
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
index 3b5ec55..7da9244 100644
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
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index c66e882..8617262 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -77,7 +77,7 @@ static unsigned int dccp_timeout[CT_DCCP_MAX] __read_mostly = {
  	[CT_DCCP_TIMEWAIT]	= 2 * DCCP_MSL,
  };

-static const char *dccp_state_names[] = {
+static const char *const dccp_state_names[] = {
  	[CT_DCCP_NONE]		= "NONE",
  	[CT_DCCP_REQUEST]	= "REQUEST",
  	[CT_DCCP_RESPOND]	= "RESPOND",
@@ -132,7 +132,7 @@ static const char *dccp_state_names[] = {
   * already) and the server may send back a connection closing DCCP_RESET
   * or a DCCP_RESPONSE.
   */
-static u_int8_t dccp_state_table[IP_CT_DIR_MAX][DCCP_PKT_SYNCACK + 1][CT_DCCP_MAX] = {
+static const u_int8_t dccp_state_table[IP_CT_DIR_MAX][DCCP_PKT_SYNCACK + 1][CT_DCCP_MAX] = {
  	[IP_CT_DIR_ORIGINAL] = {
  		[DCCP_PKT_REQUEST] = {
  		/*
@@ -374,7 +374,8 @@ static u_int8_t dccp_state_table[IP_CT_DIR_MAX][DCCP_PKT_SYNCACK + 1][CT_DCCP_MA
  static bool dccp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
  			      struct nf_conntrack_tuple *tuple)
  {
-	struct dccp_hdr _hdr, *dh;
+	const struct dccp_hdr *dh;
+	struct dccp_hdr _hdr;

  	dh = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
  	if (dh == NULL)
@@ -397,8 +398,9 @@ static bool dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
  		     unsigned int dataoff)
  {
  	u_int16_t pf = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
-	struct dccp_hdr _dh, *dh;
-	char *msg;
+	const struct dccp_hdr *dh;
+	struct dccp_hdr _dh;
+	const char *msg;
  	u_int8_t state;

  	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);
@@ -440,7 +442,8 @@ static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
  		       unsigned int dataoff, enum ip_conntrack_info ctinfo,
  		       u_int16_t pf, unsigned int hooknum)
  {
-	struct dccp_hdr _dh, *dh;
+	const struct dccp_hdr *dh;
+	struct dccp_hdr _dh;
  	u_int8_t type, old_state, new_state;

  	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);
@@ -496,7 +499,8 @@ static int dccp_error(struct sk_buff *skb, unsigned int dataoff,
  		      enum ip_conntrack_info *ctinfo, u_int16_t pf,
  		      unsigned int hooknum)
  {
-	struct dccp_hdr _dh, *dh;
+	const struct dccp_hdr *dh;
+	struct dccp_hdr _dh;
  	unsigned int dccp_len = skb->len - dataoff;
  	unsigned int cscov;
  	const char *msg;
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 87fc707..e2f7974 100644
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

