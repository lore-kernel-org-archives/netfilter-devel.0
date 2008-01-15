From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 26/38]: nf_conntrack_sctp: use proper types for bitops
Date: Tue, 15 Jan 2008 07:19:47 +0100 (MET)
Message-ID: <20080115061942.3184.68824.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62235 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYAOGTs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:48 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sctp: use proper types for bitops

Use unsigned long instead of char for the bitmap and removed lots
of casts.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7b4d31af2b7c66345df8c9147468076c6cb8ab8e
tree 6818c02035633d2a911a7fd414bea3009de56119
parent 2138af0660d4043c80aa13caa07e50ebeb1996d9
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:26 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:26 +0100

 net/netfilter/nf_conntrack_proto_sctp.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 689cc50..5166bb3 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -195,7 +195,7 @@ for ((offset) = (dataoff) + sizeof(sctp_sctphdr_t), (count) = 0;	\
 static int do_basic_checks(struct nf_conn *conntrack,
 			   const struct sk_buff *skb,
 			   unsigned int dataoff,
-			   char *map)
+			   unsigned long *map)
 {
 	u_int32_t offset, count;
 	sctp_chunkhdr_t _sch, *sch;
@@ -225,7 +225,7 @@ static int do_basic_checks(struct nf_conn *conntrack,
 		}
 
 		if (map)
-			set_bit(sch->type, (void *)map);
+			set_bit(sch->type, map);
 	}
 
 	pr_debug("Basic checks passed\n");
@@ -304,7 +304,7 @@ static int sctp_packet(struct nf_conn *conntrack,
 	sctp_sctphdr_t _sctph, *sh;
 	sctp_chunkhdr_t _sch, *sch;
 	u_int32_t offset, count;
-	char map[256 / sizeof (char)] = {0};
+	unsigned long map[256 / sizeof(unsigned long)] = { 0 };
 
 	sh = skb_header_pointer(skb, dataoff, sizeof(_sctph), &_sctph);
 	if (sh == NULL)
@@ -314,11 +314,11 @@ static int sctp_packet(struct nf_conn *conntrack,
 		return -1;
 
 	/* Check the verification tag (Sec 8.5) */
-	if (!test_bit(SCTP_CID_INIT, (void *)map) &&
-	    !test_bit(SCTP_CID_SHUTDOWN_COMPLETE, (void *)map) &&
-	    !test_bit(SCTP_CID_COOKIE_ECHO, (void *)map) &&
-	    !test_bit(SCTP_CID_ABORT, (void *)map) &&
-	    !test_bit(SCTP_CID_SHUTDOWN_ACK, (void *)map) &&
+	if (!test_bit(SCTP_CID_INIT, map) &&
+	    !test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) &&
+	    !test_bit(SCTP_CID_COOKIE_ECHO, map) &&
+	    !test_bit(SCTP_CID_ABORT, map) &&
+	    !test_bit(SCTP_CID_SHUTDOWN_ACK, map) &&
 	    sh->vtag != conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)]) {
 		pr_debug("Verification tag check failed\n");
 		return -1;
@@ -413,7 +413,7 @@ static int sctp_new(struct nf_conn *conntrack, const struct sk_buff *skb,
 	sctp_sctphdr_t _sctph, *sh;
 	sctp_chunkhdr_t _sch, *sch;
 	u_int32_t offset, count;
-	char map[256 / sizeof (char)] = {0};
+	unsigned long map[256 / sizeof(unsigned long)] = { 0 };
 
 	sh = skb_header_pointer(skb, dataoff, sizeof(_sctph), &_sctph);
 	if (sh == NULL)
@@ -423,9 +423,9 @@ static int sctp_new(struct nf_conn *conntrack, const struct sk_buff *skb,
 		return 0;
 
 	/* If an OOTB packet has any of these chunks discard (Sec 8.4) */
-	if (test_bit (SCTP_CID_ABORT, (void *)map) ||
-	    test_bit (SCTP_CID_SHUTDOWN_COMPLETE, (void *)map) ||
-	    test_bit (SCTP_CID_COOKIE_ACK, (void *)map))
+	if (test_bit(SCTP_CID_ABORT, map) ||
+	    test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) ||
+	    test_bit(SCTP_CID_COOKIE_ACK, map))
 		return 0;
 
 	newconntrack = SCTP_CONNTRACK_MAX;
