From: Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH nf] netfilter: conntrack: fix false CRC32c mismatch using paged skb
Date: Thu, 18 May 2017 18:01:43 +0200
Message-ID: <f156034b4975584477c319a0946eb7adfc8d1e36.1495119678.git.dcaratti@redhat.com>
Cc: pablo@netfilter.org, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20555 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755405AbdERQCO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2017 12:02:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

sctp_compute_cksum() implementation assumes that at least the SCTP header
is in the linear part of skb: modify conntrack error callback to avoid
false CRC32c mismatch, if the transport header is partially/entirely paged.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 13875d5..1c5b14a 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -512,16 +512,19 @@ static int sctp_error(struct net *net, struct nf_conn *tpl, struct sk_buff *skb,
 		      u8 pf, unsigned int hooknum)
 {
 	const struct sctphdr *sh;
-	struct sctphdr _sctph;
 	const char *logmsg;
 
-	sh = skb_header_pointer(skb, dataoff, sizeof(_sctph), &_sctph);
-	if (!sh) {
+	if (skb->len < dataoff + sizeof(struct sctphdr)) {
 		logmsg = "nf_ct_sctp: short packet ";
 		goto out_invalid;
 	}
 	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
 	    skb->ip_summed == CHECKSUM_NONE) {
+		if (!skb_make_writable(skb, dataoff + sizeof(struct sctphdr))) {
+			logmsg = "nf_ct_sctp: failed to read header ";
+			goto out_invalid;
+		}
+		sh = (const struct sctphdr *)(skb->data + dataoff);
 		if (sh->checksum != sctp_compute_cksum(skb, dataoff)) {
 			logmsg = "nf_ct_sctp: bad CRC ";
 			goto out_invalid;
-- 
2.7.4

