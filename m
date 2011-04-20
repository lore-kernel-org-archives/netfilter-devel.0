From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: ctnetlink: fix timestamp support for new conntracks
Date: Wed, 20 Apr 2011 14:22:14 +0200
Message-ID: <20110420122213.3000.14349.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41169 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab1DTMWT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Apr 2011 08:22:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes the missing initialization of the start time if
the timestamp support is enabled.

libnetfilter_conntrack/utils# conntrack -E &
libnetfilter_conntrack/utils# ./conntrack_create
tcp      6 109 ESTABLISHED src=1.1.1.1 dst=2.2.2.2 sport=1025 dport=21 packets=0 bytes=0 [UNREPLIED] src=2.2.2.2 dst=1.1.1.1 sport=21 dport=1025 packets=0 bytes=0 mark=0 delta-time=1303296401 use=2

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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

