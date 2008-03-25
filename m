From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: commit 720350a38b1dbd43c907d5d81decd6edd6725d81
Date: Tue, 25 Mar 2008 19:06:24 +0100
Message-ID: <1206468391-368-22-git-send-email-jengelh@computergmbh.de>
References: <alpine.LNX.1.10.0803251903230.31276@fbirervta.pbzchgretzou.qr>
 <1206468391-368-1-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-2-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-3-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-4-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-5-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-6-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-7-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-8-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-9-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-10-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-11-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-12-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-13-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-14-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-15-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-16-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-17-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-18-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-19-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-20-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-21-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52539 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759271AbYCYSGi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:06:38 -0400
In-Reply-To: <1206468391-368-21-git-send-email-jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

    [NETFILTER]: nf_conntrack_sctp: const annotations
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/netfilter/nf_conntrack_proto_sctp.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index e7dab58..ea86de4 100644
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
 
