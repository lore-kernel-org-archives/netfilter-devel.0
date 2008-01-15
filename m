From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 30/38]: nf_conntrack_sctp: rename "newconntrack" variable
Date: Tue, 15 Jan 2008 07:19:52 +0100 (MET)
Message-ID: <20080115061947.3184.15110.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62249 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbYAOGTy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:54 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sctp: rename "newconntrack" variable

The name is misleading, it holds the new connection state, so rename it
to "newstate". Also rename "oldsctpstate" to "oldstate" for consistency.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 426d981e95c0171858e0e4658373986717739fa5
tree 2b13b2c192919d8c5f155d1d4ba18cdb0069082b
parent 55c98e3af141112533dfc4365b9b03997893a33f
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:28 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:28 +0100

 net/netfilter/nf_conntrack_proto_sctp.c |   42 ++++++++++++++++---------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index e52b6b9..7baabc0 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -231,9 +231,9 @@ static int do_basic_checks(struct nf_conn *ct,
 	return count == 0;
 }
 
-static int new_state(enum ip_conntrack_dir dir,
-		     enum sctp_conntrack cur_state,
-		     int chunk_type)
+static int sctp_new_state(enum ip_conntrack_dir dir,
+			  enum sctp_conntrack cur_state,
+			  int chunk_type)
 {
 	int i;
 
@@ -299,7 +299,7 @@ static int sctp_packet(struct nf_conn *ct,
 		       int pf,
 		       unsigned int hooknum)
 {
-	enum sctp_conntrack newconntrack, oldsctpstate;
+	enum sctp_conntrack new_state, old_state;
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	sctp_sctphdr_t _sctph, *sh;
 	sctp_chunkhdr_t _sch, *sch;
@@ -324,7 +324,7 @@ static int sctp_packet(struct nf_conn *ct,
 		goto out;
 	}
 
-	oldsctpstate = newconntrack = SCTP_CONNTRACK_MAX;
+	old_state = new_state = SCTP_CONNTRACK_MAX;
 	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
 		write_lock_bh(&sctp_lock);
 
@@ -350,14 +350,14 @@ static int sctp_packet(struct nf_conn *ct,
 				goto out_unlock;
 		}
 
-		oldsctpstate = ct->proto.sctp.state;
-		newconntrack = new_state(dir, oldsctpstate, sch->type);
+		old_state = ct->proto.sctp.state;
+		new_state = sctp_new_state(dir, old_state, sch->type);
 
 		/* Invalid */
-		if (newconntrack == SCTP_CONNTRACK_MAX) {
+		if (new_state == SCTP_CONNTRACK_MAX) {
 			pr_debug("nf_conntrack_sctp: Invalid dir=%i ctype=%u "
 				 "conntrack=%u\n",
-				 dir, sch->type, oldsctpstate);
+				 dir, sch->type, old_state);
 			goto out_unlock;
 		}
 
@@ -375,17 +375,17 @@ static int sctp_packet(struct nf_conn *ct,
 			ct->proto.sctp.vtag[!dir] = ih->init_tag;
 		}
 
-		ct->proto.sctp.state = newconntrack;
-		if (oldsctpstate != newconntrack)
+		ct->proto.sctp.state = new_state;
+		if (old_state != new_state)
 			nf_conntrack_event_cache(IPCT_PROTOINFO, skb);
 		write_unlock_bh(&sctp_lock);
 	}
 
-	nf_ct_refresh_acct(ct, ctinfo, skb, *sctp_timeouts[newconntrack]);
+	nf_ct_refresh_acct(ct, ctinfo, skb, *sctp_timeouts[new_state]);
 
-	if (oldsctpstate == SCTP_CONNTRACK_COOKIE_ECHOED &&
+	if (old_state == SCTP_CONNTRACK_COOKIE_ECHOED &&
 	    dir == IP_CT_DIR_REPLY &&
-	    newconntrack == SCTP_CONNTRACK_ESTABLISHED) {
+	    new_state == SCTP_CONNTRACK_ESTABLISHED) {
 		pr_debug("Setting assured bit\n");
 		set_bit(IPS_ASSURED_BIT, &ct->status);
 		nf_conntrack_event_cache(IPCT_STATUS, skb);
@@ -403,7 +403,7 @@ out:
 static int sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 		    unsigned int dataoff)
 {
-	enum sctp_conntrack newconntrack;
+	enum sctp_conntrack new_state;
 	sctp_sctphdr_t _sctph, *sh;
 	sctp_chunkhdr_t _sch, *sch;
 	u_int32_t offset, count;
@@ -422,15 +422,15 @@ static int sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	    test_bit(SCTP_CID_COOKIE_ACK, map))
 		return 0;
 
-	newconntrack = SCTP_CONNTRACK_MAX;
+	new_state = SCTP_CONNTRACK_MAX;
 	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
 		/* Don't need lock here: this conntrack not in circulation yet */
-		newconntrack = new_state(IP_CT_DIR_ORIGINAL,
-					 SCTP_CONNTRACK_NONE, sch->type);
+		new_state = sctp_new_state(IP_CT_DIR_ORIGINAL,
+					   SCTP_CONNTRACK_NONE, sch->type);
 
 		/* Invalid: delete conntrack */
-		if (newconntrack == SCTP_CONNTRACK_NONE ||
-		    newconntrack == SCTP_CONNTRACK_MAX) {
+		if (new_state == SCTP_CONNTRACK_NONE ||
+		    new_state == SCTP_CONNTRACK_MAX) {
 			pr_debug("nf_conntrack_sctp: invalid new deleting.\n");
 			return 0;
 		}
@@ -463,7 +463,7 @@ static int sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 			ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = sh->vtag;
 		}
 
-		ct->proto.sctp.state = newconntrack;
+		ct->proto.sctp.state = new_state;
 	}
 
 	return 1;
