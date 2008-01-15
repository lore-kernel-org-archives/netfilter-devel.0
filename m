From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 28/38]: nf_conntrack_sctp: reduce line length further
Date: Tue, 15 Jan 2008 07:19:50 +0100 (MET)
Message-ID: <20080115061945.3184.14065.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62241 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbYAOGTv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:51 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sctp: reduce line length further

Eliminate a few lines over 80 characters by using a local variable to
hold the conntrack direction instead of using CTINFO2DIR everywhere.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 813e62c43db7ec9a71df93147f422c0aa9b8fe67
tree 18269f6b89a5fc02b9418a56410c21a36924edb9
parent 1880ca6a51b7d8404a574db37e9fe1ad4349a580
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:27 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:27 +0100

 net/netfilter/nf_conntrack_proto_sctp.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 84e37e9..fdabef5 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -300,6 +300,7 @@ static int sctp_packet(struct nf_conn *ct,
 		       unsigned int hooknum)
 {
 	enum sctp_conntrack newconntrack, oldsctpstate;
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	sctp_sctphdr_t _sctph, *sh;
 	sctp_chunkhdr_t _sch, *sch;
 	u_int32_t offset, count;
@@ -318,7 +319,7 @@ static int sctp_packet(struct nf_conn *ct,
 	    !test_bit(SCTP_CID_COOKIE_ECHO, map) &&
 	    !test_bit(SCTP_CID_ABORT, map) &&
 	    !test_bit(SCTP_CID_SHUTDOWN_ACK, map) &&
-	    sh->vtag != ct->proto.sctp.vtag[CTINFO2DIR(ctinfo)]) {
+	    sh->vtag != ct->proto.sctp.vtag[dir]) {
 		pr_debug("Verification tag check failed\n");
 		return -1;
 	}
@@ -336,35 +337,35 @@ static int sctp_packet(struct nf_conn *ct,
 			}
 		} else if (sch->type == SCTP_CID_ABORT) {
 			/* Sec 8.5.1 (B) */
-			if (sh->vtag != ct->proto.sctp.vtag[CTINFO2DIR(ctinfo)] &&
-			    sh->vtag != ct->proto.sctp.vtag[1 - CTINFO2DIR(ctinfo)]) {
+			if (sh->vtag != ct->proto.sctp.vtag[dir] &&
+			    sh->vtag != ct->proto.sctp.vtag[!dir]) {
 				write_unlock_bh(&sctp_lock);
 				return -1;
 			}
 		} else if (sch->type == SCTP_CID_SHUTDOWN_COMPLETE) {
 			/* Sec 8.5.1 (C) */
-			if (sh->vtag != ct->proto.sctp.vtag[CTINFO2DIR(ctinfo)] &&
-			    sh->vtag != ct->proto.sctp.vtag[1 - CTINFO2DIR(ctinfo)] &&
+			if (sh->vtag != ct->proto.sctp.vtag[dir] &&
+			    sh->vtag != ct->proto.sctp.vtag[!dir] &&
 			    (sch->flags & 1)) {
 				write_unlock_bh(&sctp_lock);
 				return -1;
 			}
 		} else if (sch->type == SCTP_CID_COOKIE_ECHO) {
 			/* Sec 8.5.1 (D) */
-			if (sh->vtag != ct->proto.sctp.vtag[CTINFO2DIR(ctinfo)]) {
+			if (sh->vtag != ct->proto.sctp.vtag[dir]) {
 				write_unlock_bh(&sctp_lock);
 				return -1;
 			}
 		}
 
 		oldsctpstate = ct->proto.sctp.state;
-		newconntrack = new_state(CTINFO2DIR(ctinfo), oldsctpstate, sch->type);
+		newconntrack = new_state(dir, oldsctpstate, sch->type);
 
 		/* Invalid */
 		if (newconntrack == SCTP_CONNTRACK_MAX) {
 			pr_debug("nf_conntrack_sctp: Invalid dir=%i ctype=%u "
 				 "conntrack=%u\n",
-				 CTINFO2DIR(ctinfo), sch->type, oldsctpstate);
+				 dir, sch->type, oldsctpstate);
 			write_unlock_bh(&sctp_lock);
 			return -1;
 		}
@@ -381,8 +382,8 @@ static int sctp_packet(struct nf_conn *ct,
 				return -1;
 			}
 			pr_debug("Setting vtag %x for dir %d\n",
-				 ih->init_tag, !CTINFO2DIR(ctinfo));
-			ct->proto.sctp.vtag[!CTINFO2DIR(ctinfo)] = ih->init_tag;
+				 ih->init_tag, !dir);
+			ct->proto.sctp.vtag[!dir] = ih->init_tag;
 		}
 
 		ct->proto.sctp.state = newconntrack;
@@ -394,7 +395,7 @@ static int sctp_packet(struct nf_conn *ct,
 	nf_ct_refresh_acct(ct, ctinfo, skb, *sctp_timeouts[newconntrack]);
 
 	if (oldsctpstate == SCTP_CONNTRACK_COOKIE_ECHOED &&
-	    CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY &&
+	    dir == IP_CT_DIR_REPLY &&
 	    newconntrack == SCTP_CONNTRACK_ESTABLISHED) {
 		pr_debug("Setting assured bit\n");
 		set_bit(IPS_ASSURED_BIT, &ct->status);
