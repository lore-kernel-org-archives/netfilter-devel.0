From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 33/38]: nf_conntrack_sctp: replace magic value by symbolic constant
Date: Tue, 15 Jan 2008 07:19:56 +0100 (MET)
Message-ID: <20080115061951.3184.34414.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62262 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbYAOGT5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:57 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sctp: replace magic value by symbolic constant

Use SCTP_CHUNK_FLAG_T instead of 0x1.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 07f97b30ff30a5ce17377199ae32176b5dab5b08
tree 72dc2a95665128b415c457c3db4ab18d56ce149c
parent 5c06ef38713fa6bc6cb80f7834464e4761a383dc
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:29 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:29 +0100

 net/netfilter/nf_conntrack_proto_sctp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 177e8f6..14b1c02 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -341,7 +341,7 @@ static int sctp_packet(struct nf_conn *ct,
 			/* Sec 8.5.1 (C) */
 			if (sh->vtag != ct->proto.sctp.vtag[dir] &&
 			    sh->vtag != ct->proto.sctp.vtag[!dir] &&
-			    (sch->flags & 1))
+			    sch->flags & SCTP_CHUNK_FLAG_T)
 				goto out_unlock;
 		} else if (sch->type == SCTP_CID_COOKIE_ECHO) {
 			/* Sec 8.5.1 (D) */
