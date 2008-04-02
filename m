From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 16/24] [NETFILTER]: nf_conntrack_sctp: const annotations
Date: Wed,  2 Apr 2008 13:11:58 +0200
Message-ID: <94ef8ba61ffd1ce530dfa84fba8946f2456edd10.1207134547.git.jengelh@computergmbh.de>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43170 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbYDBLMK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:12:10 -0400
In-Reply-To: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
References: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
 
-- 
1.5.4.4

