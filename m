From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 29/38]: nf_conntrack_sctp: consolidate sctp_packet() error paths
Date: Tue, 15 Jan 2008 07:19:51 +0100 (MET)
Message-ID: <20080115061946.3184.3356.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62245 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbYAOGTw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:52 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sctp: consolidate sctp_packet() error paths

Consolidate error paths and use proper symbolic return value instead
of magic values.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 55c98e3af141112533dfc4365b9b03997893a33f
tree d1ca354781c0848cef5964e1bf0e69fe8ceab627
parent 813e62c43db7ec9a71df93147f422c0aa9b8fe67
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:27 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:27 +0100

 net/netfilter/nf_conntrack_proto_sctp.c |   46 +++++++++++++------------------
 1 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index fdabef5..e52b6b9 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -291,7 +291,7 @@ static int new_state(enum ip_conntrack_dir dir,
 	return sctp_conntracks[dir][i][cur_state];
 }
 
-/* Returns verdict for packet, or -1 for invalid. */
+/* Returns verdict for packet, or -NF_ACCEPT for invalid. */
 static int sctp_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
 		       unsigned int dataoff,
@@ -308,10 +308,10 @@ static int sctp_packet(struct nf_conn *ct,
 
 	sh = skb_header_pointer(skb, dataoff, sizeof(_sctph), &_sctph);
 	if (sh == NULL)
-		return -1;
+		goto out;
 
 	if (do_basic_checks(ct, skb, dataoff, map) != 0)
-		return -1;
+		goto out;
 
 	/* Check the verification tag (Sec 8.5) */
 	if (!test_bit(SCTP_CID_INIT, map) &&
@@ -321,7 +321,7 @@ static int sctp_packet(struct nf_conn *ct,
 	    !test_bit(SCTP_CID_SHUTDOWN_ACK, map) &&
 	    sh->vtag != ct->proto.sctp.vtag[dir]) {
 		pr_debug("Verification tag check failed\n");
-		return -1;
+		goto out;
 	}
 
 	oldsctpstate = newconntrack = SCTP_CONNTRACK_MAX;
@@ -331,31 +331,23 @@ static int sctp_packet(struct nf_conn *ct,
 		/* Special cases of Verification tag check (Sec 8.5.1) */
 		if (sch->type == SCTP_CID_INIT) {
 			/* Sec 8.5.1 (A) */
-			if (sh->vtag != 0) {
-				write_unlock_bh(&sctp_lock);
-				return -1;
-			}
+			if (sh->vtag != 0)
+				goto out_unlock;
 		} else if (sch->type == SCTP_CID_ABORT) {
 			/* Sec 8.5.1 (B) */
 			if (sh->vtag != ct->proto.sctp.vtag[dir] &&
-			    sh->vtag != ct->proto.sctp.vtag[!dir]) {
-				write_unlock_bh(&sctp_lock);
-				return -1;
-			}
+			    sh->vtag != ct->proto.sctp.vtag[!dir])
+				goto out_unlock;
 		} else if (sch->type == SCTP_CID_SHUTDOWN_COMPLETE) {
 			/* Sec 8.5.1 (C) */
 			if (sh->vtag != ct->proto.sctp.vtag[dir] &&
 			    sh->vtag != ct->proto.sctp.vtag[!dir] &&
-			    (sch->flags & 1)) {
-				write_unlock_bh(&sctp_lock);
-				return -1;
-			}
+			    (sch->flags & 1))
+				goto out_unlock;
 		} else if (sch->type == SCTP_CID_COOKIE_ECHO) {
 			/* Sec 8.5.1 (D) */
-			if (sh->vtag != ct->proto.sctp.vtag[dir]) {
-				write_unlock_bh(&sctp_lock);
-				return -1;
-			}
+			if (sh->vtag != ct->proto.sctp.vtag[dir])
+				goto out_unlock;
 		}
 
 		oldsctpstate = ct->proto.sctp.state;
@@ -366,8 +358,7 @@ static int sctp_packet(struct nf_conn *ct,
 			pr_debug("nf_conntrack_sctp: Invalid dir=%i ctype=%u "
 				 "conntrack=%u\n",
 				 dir, sch->type, oldsctpstate);
-			write_unlock_bh(&sctp_lock);
-			return -1;
+			goto out_unlock;
 		}
 
 		/* If it is an INIT or an INIT ACK note down the vtag */
@@ -377,10 +368,8 @@ static int sctp_packet(struct nf_conn *ct,
 
 			ih = skb_header_pointer(skb, offset + sizeof(sctp_chunkhdr_t),
 						sizeof(_inithdr), &_inithdr);
-			if (ih == NULL) {
-				write_unlock_bh(&sctp_lock);
-				return -1;
-			}
+			if (ih == NULL)
+				goto out_unlock;
 			pr_debug("Setting vtag %x for dir %d\n",
 				 ih->init_tag, !dir);
 			ct->proto.sctp.vtag[!dir] = ih->init_tag;
@@ -403,6 +392,11 @@ static int sctp_packet(struct nf_conn *ct,
 	}
 
 	return NF_ACCEPT;
+
+out_unlock:
+	write_unlock_bh(&sctp_lock);
+out:
+	return -NF_ACCEPT;
 }
 
 /* Called when a new connection for this protocol found. */
