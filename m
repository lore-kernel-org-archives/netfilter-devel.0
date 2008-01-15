From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 25/38]: nf_conntrack_sctp: basic cleanups
Date: Tue, 15 Jan 2008 07:19:46 +0100 (MET)
Message-ID: <20080115061941.3184.20654.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62232 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbYAOGTr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:47 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sctp: basic cleanups

Reindent switch cases properly, get rid of weird constructs like "!(x == y)",
put logical operations on the end of the line instead of the next line, get
rid of superfluous braces.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2138af0660d4043c80aa13caa07e50ebeb1996d9
tree 4bebb98df91217146aea4a55f4df6ed84122addd
parent e11744f0b9408e74f920463e52d59460e9c2b2b2
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:26 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:26 +0100

 net/netfilter/nf_conntrack_proto_sctp.c |  140 ++++++++++++++++---------------
 1 files changed, 72 insertions(+), 68 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 9a5ec53..689cc50 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -206,28 +206,26 @@ static int do_basic_checks(struct nf_conn *conntrack,
 	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
 		pr_debug("Chunk Num: %d  Type: %d\n", count, sch->type);
 
-		if (sch->type == SCTP_CID_INIT
-			|| sch->type == SCTP_CID_INIT_ACK
-			|| sch->type == SCTP_CID_SHUTDOWN_COMPLETE) {
+		if (sch->type == SCTP_CID_INIT ||
+		    sch->type == SCTP_CID_INIT_ACK ||
+		    sch->type == SCTP_CID_SHUTDOWN_COMPLETE)
 			flag = 1;
-		}
 
 		/*
 		 * Cookie Ack/Echo chunks not the first OR
 		 * Init / Init Ack / Shutdown compl chunks not the only chunks
 		 * OR zero-length.
 		 */
-		if (((sch->type == SCTP_CID_COOKIE_ACK
-			|| sch->type == SCTP_CID_COOKIE_ECHO
-			|| flag)
-		      && count !=0) || !sch->length) {
+		if (((sch->type == SCTP_CID_COOKIE_ACK ||
+		      sch->type == SCTP_CID_COOKIE_ECHO ||
+		      flag) &&
+		     count != 0) || !sch->length) {
 			pr_debug("Basic checks failed\n");
 			return 1;
 		}
 
-		if (map) {
+		if (map)
 			set_bit(sch->type, (void *)map);
-		}
 	}
 
 	pr_debug("Basic checks passed\n");
@@ -243,39 +241,48 @@ static int new_state(enum ip_conntrack_dir dir,
 	pr_debug("Chunk type: %d\n", chunk_type);
 
 	switch (chunk_type) {
-		case SCTP_CID_INIT:
-			pr_debug("SCTP_CID_INIT\n");
-			i = 0; break;
-		case SCTP_CID_INIT_ACK:
-			pr_debug("SCTP_CID_INIT_ACK\n");
-			i = 1; break;
-		case SCTP_CID_ABORT:
-			pr_debug("SCTP_CID_ABORT\n");
-			i = 2; break;
-		case SCTP_CID_SHUTDOWN:
-			pr_debug("SCTP_CID_SHUTDOWN\n");
-			i = 3; break;
-		case SCTP_CID_SHUTDOWN_ACK:
-			pr_debug("SCTP_CID_SHUTDOWN_ACK\n");
-			i = 4; break;
-		case SCTP_CID_ERROR:
-			pr_debug("SCTP_CID_ERROR\n");
-			i = 5; break;
-		case SCTP_CID_COOKIE_ECHO:
-			pr_debug("SCTP_CID_COOKIE_ECHO\n");
-			i = 6; break;
-		case SCTP_CID_COOKIE_ACK:
-			pr_debug("SCTP_CID_COOKIE_ACK\n");
-			i = 7; break;
-		case SCTP_CID_SHUTDOWN_COMPLETE:
-			pr_debug("SCTP_CID_SHUTDOWN_COMPLETE\n");
-			i = 8; break;
-		default:
-			/* Other chunks like DATA, SACK, HEARTBEAT and
-			its ACK do not cause a change in state */
-			pr_debug("Unknown chunk type, Will stay in %s\n",
-				 sctp_conntrack_names[cur_state]);
-			return cur_state;
+	case SCTP_CID_INIT:
+		pr_debug("SCTP_CID_INIT\n");
+		i = 0;
+		break;
+	case SCTP_CID_INIT_ACK:
+		pr_debug("SCTP_CID_INIT_ACK\n");
+		i = 1;
+		break;
+	case SCTP_CID_ABORT:
+		pr_debug("SCTP_CID_ABORT\n");
+		i = 2;
+		break;
+	case SCTP_CID_SHUTDOWN:
+		pr_debug("SCTP_CID_SHUTDOWN\n");
+		i = 3;
+		break;
+	case SCTP_CID_SHUTDOWN_ACK:
+		pr_debug("SCTP_CID_SHUTDOWN_ACK\n");
+		i = 4;
+		break;
+	case SCTP_CID_ERROR:
+		pr_debug("SCTP_CID_ERROR\n");
+		i = 5;
+		break;
+	case SCTP_CID_COOKIE_ECHO:
+		pr_debug("SCTP_CID_COOKIE_ECHO\n");
+		i = 6;
+		break;
+	case SCTP_CID_COOKIE_ACK:
+		pr_debug("SCTP_CID_COOKIE_ACK\n");
+		i = 7;
+		break;
+	case SCTP_CID_SHUTDOWN_COMPLETE:
+		pr_debug("SCTP_CID_SHUTDOWN_COMPLETE\n");
+		i = 8;
+		break;
+	default:
+		/* Other chunks like DATA, SACK, HEARTBEAT and
+		its ACK do not cause a change in state */
+		pr_debug("Unknown chunk type, Will stay in %s\n",
+			 sctp_conntrack_names[cur_state]);
+		return cur_state;
 	}
 
 	pr_debug("dir: %d   cur_state: %s  chunk_type: %d  new_state: %s\n",
@@ -307,12 +314,12 @@ static int sctp_packet(struct nf_conn *conntrack,
 		return -1;
 
 	/* Check the verification tag (Sec 8.5) */
-	if (!test_bit(SCTP_CID_INIT, (void *)map)
-		&& !test_bit(SCTP_CID_SHUTDOWN_COMPLETE, (void *)map)
-		&& !test_bit(SCTP_CID_COOKIE_ECHO, (void *)map)
-		&& !test_bit(SCTP_CID_ABORT, (void *)map)
-		&& !test_bit(SCTP_CID_SHUTDOWN_ACK, (void *)map)
-		&& (sh->vtag != conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])) {
+	if (!test_bit(SCTP_CID_INIT, (void *)map) &&
+	    !test_bit(SCTP_CID_SHUTDOWN_COMPLETE, (void *)map) &&
+	    !test_bit(SCTP_CID_COOKIE_ECHO, (void *)map) &&
+	    !test_bit(SCTP_CID_ABORT, (void *)map) &&
+	    !test_bit(SCTP_CID_SHUTDOWN_ACK, (void *)map) &&
+	    sh->vtag != conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)]) {
 		pr_debug("Verification tag check failed\n");
 		return -1;
 	}
@@ -330,24 +337,22 @@ static int sctp_packet(struct nf_conn *conntrack,
 			}
 		} else if (sch->type == SCTP_CID_ABORT) {
 			/* Sec 8.5.1 (B) */
-			if (!(sh->vtag == conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])
-				&& !(sh->vtag == conntrack->proto.sctp.vtag
-							[1 - CTINFO2DIR(ctinfo)])) {
+			if (sh->vtag != conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)] &&
+			    sh->vtag != conntrack->proto.sctp.vtag[1 - CTINFO2DIR(ctinfo)]) {
 				write_unlock_bh(&sctp_lock);
 				return -1;
 			}
 		} else if (sch->type == SCTP_CID_SHUTDOWN_COMPLETE) {
 			/* Sec 8.5.1 (C) */
-			if (!(sh->vtag == conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])
-				&& !(sh->vtag == conntrack->proto.sctp.vtag
-							[1 - CTINFO2DIR(ctinfo)]
-					&& (sch->flags & 1))) {
+			if (sh->vtag != conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)] &&
+			    sh->vtag != conntrack->proto.sctp.vtag[1 - CTINFO2DIR(ctinfo)] &&
+			    (sch->flags & 1)) {
 				write_unlock_bh(&sctp_lock);
 				return -1;
 			}
 		} else if (sch->type == SCTP_CID_COOKIE_ECHO) {
 			/* Sec 8.5.1 (D) */
-			if (!(sh->vtag == conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])) {
+			if (sh->vtag != conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)]) {
 				write_unlock_bh(&sctp_lock);
 				return -1;
 			}
@@ -366,15 +371,15 @@ static int sctp_packet(struct nf_conn *conntrack,
 		}
 
 		/* If it is an INIT or an INIT ACK note down the vtag */
-		if (sch->type == SCTP_CID_INIT
-			|| sch->type == SCTP_CID_INIT_ACK) {
+		if (sch->type == SCTP_CID_INIT ||
+		    sch->type == SCTP_CID_INIT_ACK) {
 			sctp_inithdr_t _inithdr, *ih;
 
 			ih = skb_header_pointer(skb, offset + sizeof(sctp_chunkhdr_t),
 						sizeof(_inithdr), &_inithdr);
 			if (ih == NULL) {
-					write_unlock_bh(&sctp_lock);
-					return -1;
+				write_unlock_bh(&sctp_lock);
+				return -1;
 			}
 			pr_debug("Setting vtag %x for dir %d\n",
 				 ih->init_tag, !CTINFO2DIR(ctinfo));
@@ -389,9 +394,9 @@ static int sctp_packet(struct nf_conn *conntrack,
 
 	nf_ct_refresh_acct(conntrack, ctinfo, skb, *sctp_timeouts[newconntrack]);
 
-	if (oldsctpstate == SCTP_CONNTRACK_COOKIE_ECHOED
-		&& CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
-		&& newconntrack == SCTP_CONNTRACK_ESTABLISHED) {
+	if (oldsctpstate == SCTP_CONNTRACK_COOKIE_ECHOED &&
+	    CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY &&
+	    newconntrack == SCTP_CONNTRACK_ESTABLISHED) {
 		pr_debug("Setting assured bit\n");
 		set_bit(IPS_ASSURED_BIT, &conntrack->status);
 		nf_conntrack_event_cache(IPCT_STATUS, skb);
@@ -418,11 +423,10 @@ static int sctp_new(struct nf_conn *conntrack, const struct sk_buff *skb,
 		return 0;
 
 	/* If an OOTB packet has any of these chunks discard (Sec 8.4) */
-	if ((test_bit (SCTP_CID_ABORT, (void *)map))
-		|| (test_bit (SCTP_CID_SHUTDOWN_COMPLETE, (void *)map))
-		|| (test_bit (SCTP_CID_COOKIE_ACK, (void *)map))) {
+	if (test_bit (SCTP_CID_ABORT, (void *)map) ||
+	    test_bit (SCTP_CID_SHUTDOWN_COMPLETE, (void *)map) ||
+	    test_bit (SCTP_CID_COOKIE_ACK, (void *)map))
 		return 0;
-	}
 
 	newconntrack = SCTP_CONNTRACK_MAX;
 	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
