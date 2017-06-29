From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/29] netfilter: ctnetlink: delete extra spaces
Date: Fri, 30 Jun 2017 00:52:59 +0200
Message-ID: <1498776807-11124-2-git-send-email-pablo@netfilter.org>
References: <1498776807-11124-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1498776807-11124-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: linzhang <xiaolou4617@gmail.com>

This patch cleans up extra spaces.

Signed-off-by: linzhang <xiaolou4617@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9799a50bc604..f08604dd1a59 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -636,11 +636,11 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	if (events & (1 << IPCT_DESTROY)) {
 		type = IPCTNL_MSG_CT_DELETE;
 		group = NFNLGRP_CONNTRACK_DESTROY;
-	} else  if (events & ((1 << IPCT_NEW) | (1 << IPCT_RELATED))) {
+	} else if (events & ((1 << IPCT_NEW) | (1 << IPCT_RELATED))) {
 		type = IPCTNL_MSG_CT_NEW;
 		flags = NLM_F_CREATE|NLM_F_EXCL;
 		group = NFNLGRP_CONNTRACK_NEW;
-	} else  if (events) {
+	} else if (events) {
 		type = IPCTNL_MSG_CT_NEW;
 		group = NFNLGRP_CONNTRACK_UPDATE;
 	} else
-- 
2.1.4
