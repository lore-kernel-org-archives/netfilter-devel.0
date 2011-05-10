From: pablo@netfilter.org
Subject: [PATCH 1/8] netfilter: ctnetlink: fix timestamp support for new conntracks
Date: Tue, 10 May 2011 12:05:52 +0200
Message-ID: <1305021959-2980-2-git-send-email-pablo@netfilter.org>
References: <1305021959-2980-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48503 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755377Ab1EJKGQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 May 2011 06:06:16 -0400
In-Reply-To: <1305021959-2980-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch fixes the missing initialization of the start time if
the timestamp support is enabled.

libnetfilter_conntrack/utils# conntrack -E &
libnetfilter_conntrack/utils# ./conntrack_create
tcp      6 109 ESTABLISHED src=1.1.1.1 dst=2.2.2.2 sport=1025 dport=21 packets=0 bytes=0 [UNREPLIED] src=2.2.2.2 dst=1.1.1.1 sport=21 dport=1025 packets=0 bytes=0 mark=0 delta-time=1303296401 use=2

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_conntrack_netlink.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 30bf8a1..482e90c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1334,6 +1334,7 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
 	struct nf_conn *ct;
 	int err = -EINVAL;
 	struct nf_conntrack_helper *helper;
+	struct nf_conn_tstamp *tstamp;
 
 	ct = nf_conntrack_alloc(net, zone, otuple, rtuple, GFP_ATOMIC);
 	if (IS_ERR(ct))
@@ -1451,6 +1452,9 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
 		__set_bit(IPS_EXPECTED_BIT, &ct->status);
 		ct->master = master_ct;
 	}
+	tstamp = nf_conn_tstamp_find(ct);
+	if (tstamp)
+		tstamp->start = ktime_to_ns(ktime_get_real());
 
 	add_timer(&ct->timeout);
 	nf_conntrack_hash_insert(ct);
-- 
1.7.2.3

