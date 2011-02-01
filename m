From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: ecache: always set events bits,
	filter them later
Date: Tue, 01 Feb 2011 13:05:47 +0100
Message-ID: <20110201120547.3427.21721.stgit@decadence>
References: <20110201120116.3427.96097.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57718 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab1BAMFv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 07:05:51 -0500
In-Reply-To: <20110201120116.3427.96097.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For the following rule:

iptables -I PREROUTING -t raw -j CT --ctevents assured

The event delivered looks like the following:

 [UPDATE] tcp      6 src=192.168.0.2 dst=192.168.1.2 sport=37041 dport=80 src=192.168.1.2 dst=192.168.1.100 sport=80 dport=37041 [ASSURED]

Note that the TCP protocol state is not included. For that reason
the CT event filtering is not very useful for conntrackd.

To resolve this issue, instead of conditionally setting the CT events
bits based on the ctmask, we always set them and perform the filtering
in the late stage, just before the delivery.

Thus, the event delivered looks like the following:

 [UPDATE] tcp      6 432000 ESTABLISHED src=192.168.0.2 dst=192.168.1.2 sport=37041 dport=80 src=192.168.1.2 dst=192.168.1.100 sport=80 dport=37041 [ASSURED]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_ecache.h |    3 ---
 net/netfilter/nf_conntrack_ecache.c         |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 96ba5f7..349cefe 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -77,9 +77,6 @@ nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 	if (e == NULL)
 		return;
 
-	if (!(e->ctmask & (1 << event)))
-		return;
-
 	set_bit(event, &e->cache);
 }
 
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 5702de3..63a1b91 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -63,6 +63,9 @@ void nf_ct_deliver_cached_events(struct nf_conn *ct)
 		 * this does not harm and it happens very rarely. */
 		unsigned long missed = e->missed;
 
+		if (!((events | missed) & e->ctmask))
+			goto out_unlock;
+
 		ret = notify->fcn(events | missed, &item);
 		if (unlikely(ret < 0 || missed)) {
 			spin_lock_bh(&ct->lock);

