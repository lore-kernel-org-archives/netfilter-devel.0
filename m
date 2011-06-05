From: pablo@netfilter.org
Subject: [PATCH 16/20] netfilter: nf_conntrack: remove one synchronize_net()
Date: Mon,  6 Jun 2011 01:09:06 +0200
Message-ID: <1307315350-17782-16-git-send-email-pablo@netfilter.org>
References: <1307315350-17782-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Eric Dumazet <eric.dumazet@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52242 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756491Ab1FEXJu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jun 2011 19:09:50 -0400
In-Reply-To: <1307315350-17782-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric Dumazet <eric.dumazet@gmail.com>

No point to wait a rcu grace period before the unregisters.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index db10075..9efd274 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -435,7 +435,6 @@ static int __init nf_conntrack_l3proto_ipv4_init(void)
 
 static void __exit nf_conntrack_l3proto_ipv4_fini(void)
 {
-	synchronize_net();
 #if defined(CONFIG_PROC_FS) && defined(CONFIG_NF_CONNTRACK_PROC_COMPAT)
 	nf_conntrack_ipv4_compat_fini();
 #endif
-- 
1.7.2.5

