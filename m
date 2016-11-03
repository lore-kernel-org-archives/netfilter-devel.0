From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 10/10] netfilter: handle NF_REPEAT from nf_conntrack_in()
Date: Thu,  3 Nov 2016 13:37:52 +0100
Message-ID: <1478176672-1334-10-git-send-email-pablo@netfilter.org>
References: <1478176672-1334-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42866 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754285AbcKCMiI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Nov 2016 08:38:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E1C598D050E
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 13:38:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CECFEDA86B
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 13:38:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AB6FFDA811
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 13:38:03 +0100 (CET)
In-Reply-To: <1478176672-1334-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NF_REPEAT is only needed from nf_conntrack_in() under a very specific
case required by the TCP protocol tracker, we can handle this case
without returning to the core hook path. Handling of NF_REPEAT from the
nf_reinject() is left untouched.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v1: New patch, not posted before, to get rid of NF_REPEAT handling from the
    core.

 net/netfilter/core.c              |  2 --
 net/netfilter/nf_conntrack_core.c | 11 ++++++-----
 net/openvswitch/conntrack.c       |  8 ++------
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index bd9272eeccb5..de30e08d58f2 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -322,8 +322,6 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 			if (ret == 0)
 				ret = -EPERM;
 			return ret;
-		case NF_REPEAT:
-			continue;
 		case NF_QUEUE:
 			ret = nf_queue(skb, state, &entry, verdict);
 			if (ret == 1 && entry)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index df2f5a3901df..de4b8a75f30b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1305,7 +1305,7 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 		if (skb->nfct)
 			goto out;
 	}
-
+repeat:
 	ct = resolve_normal_ct(net, tmpl, skb, dataoff, pf, protonum,
 			       l3proto, l4proto, &set_reply, &ctinfo);
 	if (!ct) {
@@ -1345,11 +1345,12 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 		nf_conntrack_event_cache(IPCT_REPLY, ct);
 out:
 	if (tmpl) {
-		/* Special case: we have to repeat this hook, assign the
-		 * template again to this packet. We assume that this packet
-		 * has no conntrack assigned. This is used by nf_ct_tcp. */
+		/* Special case: TCP tracker reports an attempt to reopen a
+		 * closed/aborted connection. We have to go back and create a
+		 * fresh conntrack.
+		 */
 		if (ret == NF_REPEAT)
-			skb->nfct = (struct nf_conntrack *)tmpl;
+			goto repeat;
 		else
 			nf_ct_put(tmpl);
 	}
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 31045ef44a82..9b8a028b7dad 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -725,12 +725,8 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 			skb->nfctinfo = IP_CT_NEW;
 		}
 
-		/* Repeat if requested, see nf_iterate(). */
-		do {
-			err = nf_conntrack_in(net, info->family,
-					      NF_INET_PRE_ROUTING, skb);
-		} while (err == NF_REPEAT);
-
+		err = nf_conntrack_in(net, info->family,
+				      NF_INET_PRE_ROUTING, skb);
 		if (err != NF_ACCEPT)
 			return -ENOENT;
 
-- 
2.1.4

