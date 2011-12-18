From: pablo@netfilter.org
Subject: [PATCH 2/2] netfilter: ctnetlink: support individual atomic-get-and-reset of counters
Date: Sun, 18 Dec 2011 01:34:29 +0100
Message-ID: <1324168469-11204-2-git-send-email-pablo@netfilter.org>
References: <1324168469-11204-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, jengelh@medozas.de, kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42771 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab1LRAel (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 19:34:41 -0500
In-Reply-To: <1324168469-11204-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This allows to use the get operation to atomically get-and-reset
counters.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 81a0f11..4b6b570 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1011,6 +1011,17 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	if (err < 0)
 		goto out;
 
+	if (NFNL_MSG_TYPE(nlh->nlmsg_type) == IPCTNL_MSG_CT_GET_CTRZERO) {
+		struct nf_conn_counter *acct;
+
+		acct = nf_conn_acct_find(ct);
+		if (acct) {
+			atomic64_set(&acct[IP_CT_DIR_ORIGINAL].bytes, 0);
+			atomic64_set(&acct[IP_CT_DIR_ORIGINAL].packets, 0);
+			atomic64_set(&acct[IP_CT_DIR_REPLY].bytes, 0);
+			atomic64_set(&acct[IP_CT_DIR_REPLY].packets, 0);
+		}
+	}
 	return 0;
 
 free:
-- 
1.7.2.5

