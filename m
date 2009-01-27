From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2] netfilter: ctnetlink: allow changing NAT sequence
	adjustment in creation
Date: Tue, 27 Jan 2009 22:14:57 +0100
Message-ID: <20090127211457.10412.29085.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45330 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752850AbZA0VPD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:15:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes an inconsistency in the current ctnetlink code
since NAT sequence adjustment bit can only be updated but not set
in the conntrack entry creation.

This patch is used by conntrackd to successfully recover newly
created entries that represent connections with helpers and NAT
payload mangling.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ef51e99..016fad5 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1212,6 +1212,16 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 		}
 	}
 
+#ifdef CONFIG_NF_NAT_NEEDED
+	if (cda[CTA_NAT_SEQ_ADJ_ORIG] || cda[CTA_NAT_SEQ_ADJ_REPLY]) {
+		err = ctnetlink_change_nat_seq_adj(ct, cda);
+		if (err < 0) {
+			rcu_read_unlock();
+			goto err;
+		}
+	}
+#endif
+
 	if (cda[CTA_PROTOINFO]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
 		if (err < 0) {

