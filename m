From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_conntrack: set conntrack templates again if we
	return NF_REPEAT
Date: Mon, 07 Feb 2011 12:40:51 +0100
Message-ID: <20110207114051.32414.65019.stgit@decadence>
References: <20110207113905.32414.94829.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33864 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab1BGMky (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Feb 2011 07:40:54 -0500
In-Reply-To: <20110207113905.32414.94829.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The TCP tracking code has a special case that allows to return
NF_REPEAT if we receive a new SYN packet while in TIME_WAIT state.

In this situation, the TCP tracking code destroys the existing
conntrack to start a new clean session.

[DESTROY] tcp      6 src=192.168.0.2 dst=192.168.1.2 sport=38925 dport=8000 src=192.168.1.2 dst=192.168.1.100 sport=8000 dport=38925 [ASSURED]
    [NEW] tcp      6 120 SYN_SENT src=192.168.0.2 dst=192.168.1.2 sport=38925 dport=8000 [UNREPLIED] src=192.168.1.2 dst=192.168.1.100 sport=8000 dport=38925

However, this is a problem for the iptables' CT target event filtering
which will not work in this case since the conntrack template will not
be there for the new session. To fix this, we reassign the conntrack
template to the packet if we return NF_REPEAT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e615119..84f4fcc 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -942,8 +942,15 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 	if (set_reply && !test_and_set_bit(IPS_SEEN_REPLY_BIT, &ct->status))
 		nf_conntrack_event_cache(IPCT_REPLY, ct);
 out:
-	if (tmpl)
-		nf_ct_put(tmpl);
+	if (tmpl) {
+		/* Special case: we have to repeat this hook, assign the
+		 * template again to this packet. We assume that this packet
+		 * has no conntrack assigned. This is used by nf_ct_tcp. */
+		if (ret == NF_REPEAT)
+			skb->nfct = (struct nf_conntrack *)tmpl;
+		else
+			nf_ct_put(tmpl);
+	}
 
 	return ret;
 }

