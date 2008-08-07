From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3] [PATCH] fix sleepable allocation with spin lock bh
Date: Thu, 07 Aug 2008 12:08:47 +0200
Message-ID: <20080807100846.8036.73172.stgit@Decadence>
References: <20080807100803.8036.8684.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38655 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751931AbYHGOgL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Aug 2008 10:36:11 -0400
In-Reply-To: <20080807100803.8036.8684.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes a GFP_KERNEL allocation while holding a spin lock with
bottom halves disabled in ctnetlink_change_helper().

This problem was introduced in 2.6.23 with the netfilter extension
infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 7707cbb..35e61e4 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -971,7 +971,7 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nlattr *cda[])
 		/* need to zero data of old helper */
 		memset(&help->help, 0, sizeof(help->help));
 	} else {
-		help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
+		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 		if (help == NULL)
 			return -ENOMEM;
 	}

