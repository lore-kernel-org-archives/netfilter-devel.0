From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: ctnetlink: fix (really) race condition between
	dump_table and destroy
Date: Mon, 24 Jan 2011 00:16:02 +0100
Message-ID: <20110123231602.3383.31480.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44445 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab1AWXQJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Jan 2011 18:16:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In 13ee6ac579574a2a95e982b19920fd2495dce8cd, we recovered spinlocks
to protect the dump of the conntrack table according to reports from
Stephen and acknowledgments on the issue from Eric.

However, Stephen removed the refcount bump in that patch that allows
to keep a reference to the current ct object we are interating over.
That code avoids race conditions between ct object destruction and
the iteration itself. This patch reintroduces these lines since the
ct object may vanish between two recvmgs() invocations.

This patch fixes ocasional crashes while dumping the conntrack table
intensively.

Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 93297aa..519e245 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -654,14 +654,16 @@ restart:
 			if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
 			ct = nf_ct_tuplehash_to_ctrack(h);
+			if (!atomic_inc_not_zero(&ct->ct_general.use))
+				continue;
 			/* Dump entries of a given L3 protocol number.
 			 * If it is not specified, ie. l3proto == 0,
 			 * then dump everything. */
 			if (l3proto && nf_ct_l3num(ct) != l3proto)
-				continue;
+				goto releasect;
 			if (cb->args[1]) {
 				if (ct != last)
-					continue;
+					goto releasect;
 				cb->args[1] = 0;
 			}
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
@@ -679,6 +681,8 @@ restart:
 				if (acct)
 					memset(acct, 0, sizeof(struct nf_conn_counter[IP_CT_DIR_MAX]));
 			}
+releasect:
+		nf_ct_put(ct);
 		}
 		if (cb->args[1]) {
 			cb->args[1] = 0;

