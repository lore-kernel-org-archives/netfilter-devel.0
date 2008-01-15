From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 31/38]: nf_conntrack_sctp: don't take sctp_lock once per chunk
Date: Tue, 15 Jan 2008 07:19:54 +0100 (MET)
Message-ID: <20080115061949.3184.38199.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62254 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbYAOGTz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:55 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sctp: don't take sctp_lock once per chunk

Don't take and release the lock once per SCTP chunk, simply hold it
the entire time while iterating through the chunks.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit febaa2eab0d9efc458d9cbefef7fa7f9859250d1
tree b8062780663c6d45112f973ae2d8b51da74969b8
parent 426d981e95c0171858e0e4658373986717739fa5
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:28 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:28 +0100

 net/netfilter/nf_conntrack_proto_sctp.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 7baabc0..177e8f6 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -325,9 +325,8 @@ static int sctp_packet(struct nf_conn *ct,
 	}
 
 	old_state = new_state = SCTP_CONNTRACK_MAX;
+	write_lock_bh(&sctp_lock);
 	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
-		write_lock_bh(&sctp_lock);
-
 		/* Special cases of Verification tag check (Sec 8.5.1) */
 		if (sch->type == SCTP_CID_INIT) {
 			/* Sec 8.5.1 (A) */
@@ -378,8 +377,8 @@ static int sctp_packet(struct nf_conn *ct,
 		ct->proto.sctp.state = new_state;
 		if (old_state != new_state)
 			nf_conntrack_event_cache(IPCT_PROTOINFO, skb);
-		write_unlock_bh(&sctp_lock);
 	}
+	write_unlock_bh(&sctp_lock);
 
 	nf_ct_refresh_acct(ct, ctinfo, skb, *sctp_timeouts[new_state]);
 
