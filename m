From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: conntrack: add missing DCCP protocol changes in
	event cache
Date: Sat, 09 May 2009 20:46:03 +0200
Message-ID: <20090509184603.7636.66528.stgit@Decadence>
References: <20090509184316.7636.12044.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59828 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbZEISqL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 May 2009 14:46:11 -0400
In-Reply-To: <20090509184316.7636.12044.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the missing protocol state-change event reporting
for DCCP.

$ sudo conntrack -E
    [NEW] dccp     33 240 src=192.168.0.2 dst=192.168.1.2 sport=57040 dport=5001 [UNREPLIED] src=192.168.1.2 dst=192.168.1.100 sport=5001 dport=57040

With this patch:

$ sudo conntrack -E
    [NEW] dccp     33 240 REQUEST src=192.168.0.2 dst=192.168.1.2 sport=57040 dport=5001 [UNREPLIED] src=192.168.1.2 dst=192.168.1.100 sport=5001 dport=57040

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_proto_dccp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 8e757dd..aee0d6b 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -22,6 +22,7 @@
 #include <linux/netfilter/nfnetlink_conntrack.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_log.h>
 
 static DEFINE_RWLOCK(dccp_lock);
@@ -553,6 +554,9 @@ static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
 	ct->proto.dccp.state = new_state;
 	write_unlock_bh(&dccp_lock);
 
+	if (new_state != old_state)
+		nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
+
 	dn = dccp_pernet(net);
 	nf_ct_refresh_acct(ct, ctinfo, skb, dn->dccp_timeout[new_state]);
 

