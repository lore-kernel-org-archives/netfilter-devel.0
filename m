From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3] [PATCH] fix sleep in read-side lock section
Date: Thu, 07 Aug 2008 12:08:25 +0200
Message-ID: <20080807100825.8036.88782.stgit@Decadence>
References: <20080807100803.8036.8684.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38843 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752257AbYHGPZW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:25:22 -0400
In-Reply-To: <20080807100803.8036.8684.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix allocation with GFP_KERNEL in ctnetlink_create_conntrack() under
read-side lock sections.

This problem was introduced in 2.6.25.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index a984b1c..7707cbb 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1142,7 +1142,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 	rcu_read_lock();
 	helper = __nf_ct_helper_find(rtuple);
 	if (helper) {
-		help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
+		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 		if (help == NULL) {
 			rcu_read_unlock();
 			err = -ENOMEM;

