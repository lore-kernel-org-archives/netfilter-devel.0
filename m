From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3] netfilter: ctnetlink: cleanup conntrack update
	preliminary checkings
Date: Thu, 05 Mar 2009 17:07:37 +0100
Message-ID: <20090305160736.13755.30397.stgit@Decadence>
References: <20090305160714.13755.83435.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53201 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751933AbZCEQHn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:07:43 -0500
In-Reply-To: <20090305160714.13755.83435.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch moves the preliminary checkings that must be fulfilled
to update a conntrack, which are the following:

 * NAT manglings cannot be updated
 * Changing the master conntrack is not allowed.

This patch is a cleanup.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index a240a66..d229370 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1168,6 +1168,10 @@ ctnetlink_change_conntrack(struct nf_conn *ct, struct nlattr *cda[])
 {
 	int err;
 
+	/* only allow NAT changes and master assignation for new conntracks */
+	if (cda[CTA_NAT_SRC] || cda[CTA_NAT_DST] || cda[CTA_TUPLE_MASTER])
+		return -EOPNOTSUPP;
+
 	if (cda[CTA_HELP]) {
 		err = ctnetlink_change_helper(ct, cda);
 		if (err < 0)
@@ -1429,17 +1433,6 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	if (!(nlh->nlmsg_flags & NLM_F_EXCL)) {
 		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
 
-		/* we only allow nat config for new conntracks */
-		if (cda[CTA_NAT_SRC] || cda[CTA_NAT_DST]) {
-			err = -EOPNOTSUPP;
-			goto out_unlock;
-		}
-		/* can't link an existing conntrack to a master */
-		if (cda[CTA_TUPLE_MASTER]) {
-			err = -EOPNOTSUPP;
-			goto out_unlock;
-		}
-
 		err = ctnetlink_change_conntrack(ct, cda);
 		if (err == 0) {
 			nf_conntrack_get(&ct->ct_general);

