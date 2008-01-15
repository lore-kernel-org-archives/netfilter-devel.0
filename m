From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 27/38]: nf_conntrack_sctp: reduce line length
Date: Tue, 15 Jan 2008 07:19:48 +0100 (MET)
Message-ID: <20080115061943.3184.2346.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62238 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYAOGTu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:50 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sctp: reduce line length

Reduce the length of some overly long lines by renaming all
"conntrack" variables to "ct".

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1880ca6a51b7d8404a574db37e9fe1ad4349a580
tree fca5c1d067d27d65a9013be777e7cc3fce21ac6f
parent 7b4d31af2b7c66345df8c9147468076c6cb8ab8e
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:27 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:27 +0100

 net/netfilter/nf_conntrack_proto_sctp.c |   43 +++++++++++++++----------------
 1 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 5166bb3..84e37e9 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -173,13 +173,12 @@ static int sctp_print_tuple(struct seq_file *s,
 }
 
 /* Print out the private part of the conntrack. */
-static int sctp_print_conntrack(struct seq_file *s,
-				const struct nf_conn *conntrack)
+static int sctp_print_conntrack(struct seq_file *s, const struct nf_conn *ct)
 {
 	enum sctp_conntrack state;
 
 	read_lock_bh(&sctp_lock);
-	state = conntrack->proto.sctp.state;
+	state = ct->proto.sctp.state;
 	read_unlock_bh(&sctp_lock);
 
 	return seq_printf(s, "%s ", sctp_conntrack_names[state]);
@@ -192,7 +191,7 @@ for ((offset) = (dataoff) + sizeof(sctp_sctphdr_t), (count) = 0;	\
 	(offset) += (ntohs((sch)->length) + 3) & ~3, (count)++)
 
 /* Some validity checks to make sure the chunks are fine */
-static int do_basic_checks(struct nf_conn *conntrack,
+static int do_basic_checks(struct nf_conn *ct,
 			   const struct sk_buff *skb,
 			   unsigned int dataoff,
 			   unsigned long *map)
@@ -293,7 +292,7 @@ static int new_state(enum ip_conntrack_dir dir,
 }
 
 /* Returns verdict for packet, or -1 for invalid. */
-static int sctp_packet(struct nf_conn *conntrack,
+static int sctp_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
 		       unsigned int dataoff,
 		       enum ip_conntrack_info ctinfo,
@@ -310,7 +309,7 @@ static int sctp_packet(struct nf_conn *conntrack,
 	if (sh == NULL)
 		return -1;
 
-	if (do_basic_checks(conntrack, skb, dataoff, map) != 0)
+	if (do_basic_checks(ct, skb, dataoff, map) != 0)
 		return -1;
 
 	/* Check the verification tag (Sec 8.5) */
@@ -319,7 +318,7 @@ static int sctp_packet(struct nf_conn *conntrack,
 	    !test_bit(SCTP_CID_COOKIE_ECHO, map) &&
 	    !test_bit(SCTP_CID_ABORT, map) &&
 	    !test_bit(SCTP_CID_SHUTDOWN_ACK, map) &&
-	    sh->vtag != conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)]) {
+	    sh->vtag != ct->proto.sctp.vtag[CTINFO2DIR(ctinfo)]) {
 		pr_debug("Verification tag check failed\n");
 		return -1;
 	}
@@ -337,28 +336,28 @@ static int sctp_packet(struct nf_conn *conntrack,
 			}
 		} else if (sch->type == SCTP_CID_ABORT) {
 			/* Sec 8.5.1 (B) */
-			if (sh->vtag != conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)] &&
-			    sh->vtag != conntrack->proto.sctp.vtag[1 - CTINFO2DIR(ctinfo)]) {
+			if (sh->vtag != ct->proto.sctp.vtag[CTINFO2DIR(ctinfo)] &&
+			    sh->vtag != ct->proto.sctp.vtag[1 - CTINFO2DIR(ctinfo)]) {
 				write_unlock_bh(&sctp_lock);
 				return -1;
 			}
 		} else if (sch->type == SCTP_CID_SHUTDOWN_COMPLETE) {
 			/* Sec 8.5.1 (C) */
-			if (sh->vtag != conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)] &&
-			    sh->vtag != conntrack->proto.sctp.vtag[1 - CTINFO2DIR(ctinfo)] &&
+			if (sh->vtag != ct->proto.sctp.vtag[CTINFO2DIR(ctinfo)] &&
+			    sh->vtag != ct->proto.sctp.vtag[1 - CTINFO2DIR(ctinfo)] &&
 			    (sch->flags & 1)) {
 				write_unlock_bh(&sctp_lock);
 				return -1;
 			}
 		} else if (sch->type == SCTP_CID_COOKIE_ECHO) {
 			/* Sec 8.5.1 (D) */
-			if (sh->vtag != conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)]) {
+			if (sh->vtag != ct->proto.sctp.vtag[CTINFO2DIR(ctinfo)]) {
 				write_unlock_bh(&sctp_lock);
 				return -1;
 			}
 		}
 
-		oldsctpstate = conntrack->proto.sctp.state;
+		oldsctpstate = ct->proto.sctp.state;
 		newconntrack = new_state(CTINFO2DIR(ctinfo), oldsctpstate, sch->type);
 
 		/* Invalid */
@@ -383,22 +382,22 @@ static int sctp_packet(struct nf_conn *conntrack,
 			}
 			pr_debug("Setting vtag %x for dir %d\n",
 				 ih->init_tag, !CTINFO2DIR(ctinfo));
-			conntrack->proto.sctp.vtag[!CTINFO2DIR(ctinfo)] = ih->init_tag;
+			ct->proto.sctp.vtag[!CTINFO2DIR(ctinfo)] = ih->init_tag;
 		}
 
-		conntrack->proto.sctp.state = newconntrack;
+		ct->proto.sctp.state = newconntrack;
 		if (oldsctpstate != newconntrack)
 			nf_conntrack_event_cache(IPCT_PROTOINFO, skb);
 		write_unlock_bh(&sctp_lock);
 	}
 
-	nf_ct_refresh_acct(conntrack, ctinfo, skb, *sctp_timeouts[newconntrack]);
+	nf_ct_refresh_acct(ct, ctinfo, skb, *sctp_timeouts[newconntrack]);
 
 	if (oldsctpstate == SCTP_CONNTRACK_COOKIE_ECHOED &&
 	    CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY &&
 	    newconntrack == SCTP_CONNTRACK_ESTABLISHED) {
 		pr_debug("Setting assured bit\n");
-		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		set_bit(IPS_ASSURED_BIT, &ct->status);
 		nf_conntrack_event_cache(IPCT_STATUS, skb);
 	}
 
@@ -406,7 +405,7 @@ static int sctp_packet(struct nf_conn *conntrack,
 }
 
 /* Called when a new connection for this protocol found. */
-static int sctp_new(struct nf_conn *conntrack, const struct sk_buff *skb,
+static int sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 		    unsigned int dataoff)
 {
 	enum sctp_conntrack newconntrack;
@@ -419,7 +418,7 @@ static int sctp_new(struct nf_conn *conntrack, const struct sk_buff *skb,
 	if (sh == NULL)
 		return 0;
 
-	if (do_basic_checks(conntrack, skb, dataoff, map) != 0)
+	if (do_basic_checks(ct, skb, dataoff, map) != 0)
 		return 0;
 
 	/* If an OOTB packet has any of these chunks discard (Sec 8.4) */
@@ -454,7 +453,7 @@ static int sctp_new(struct nf_conn *conntrack, const struct sk_buff *skb,
 				pr_debug("Setting vtag %x for new conn\n",
 					 ih->init_tag);
 
-				conntrack->proto.sctp.vtag[IP_CT_DIR_REPLY] =
+				ct->proto.sctp.vtag[IP_CT_DIR_REPLY] =
 								ih->init_tag;
 			} else {
 				/* Sec 8.5.1 (A) */
@@ -466,10 +465,10 @@ static int sctp_new(struct nf_conn *conntrack, const struct sk_buff *skb,
 		else {
 			pr_debug("Setting vtag %x for new conn OOTB\n",
 				 sh->vtag);
-			conntrack->proto.sctp.vtag[IP_CT_DIR_REPLY] = sh->vtag;
+			ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = sh->vtag;
 		}
 
-		conntrack->proto.sctp.state = newconntrack;
+		ct->proto.sctp.state = newconntrack;
 	}
 
 	return 1;
