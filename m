From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -next] netfilter: conntrack: drop new packets that lose race against get_next_corpse()
Date: Mon, 24 Nov 2014 18:27:59 +0100
Message-ID: <1416850079-5791-1-git-send-email-pablo@netfilter.org>
Cc: joerg.marx@secunet.com, brouer@redhat.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42056 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbaKXR0A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:26:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

__nf_conntrack_confirm() is only called for the first packet that we
see in a flow. If you just invoked conntrack -F once (which should be
the common case), then this is likely to be the first packet of the
flow (unless you already called flush anytime soon in the past).
This should be hard to trigger, but better drop this packet, otherwise
we leave things in inconsistent state since the destination will likely
reply to this packet, but it will find no conntrack, unless the origin
retransmits.

See: https://www.marc.info/?l=linux-netdev&m=141588039530056&w=2

This was introduced in fc35077 ("netfilter: nf_conntrack: fix a race in
__nf_conntrack_confirm against nf_ct_get_next_corpse()").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2c69975..d293fe22 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -623,7 +623,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		nf_ct_add_to_dying_list(ct);
 		nf_conntrack_double_unlock(hash, reply_hash);
 		local_bh_enable();
-		return NF_ACCEPT;
+		return NF_DROP;
 	}
 
 	/* See if there's one in the list already, including reverse:
-- 
1.7.10.4

