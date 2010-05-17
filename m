From: Joerg Marx <joerg.marx@secunet.com>
Subject: Re: [PATCH] nf_conntrack_core.c: fix for dead connection after flushing
 conntrack cache
Date: Mon, 17 May 2010 10:48:20 +0200
Message-ID: <4BF102D4.9050304@secunet.com>
References: <4BE3D31F.6000607@secunet.com> <4BE73DE3.6080304@netfilter.org> <4BE824EA.6000303@trash.net> <4BE83D93.8080909@secunet.com> <4BED2E93.1030004@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Mail List - Netfilter <netfilter@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4BED2E93.1030004@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 05/14/2010 01:05 PM, Patrick McHardy wrote:

...
>>
>> I hope the comment is clearly pointing to the (solved) problem now. I
>> also removed the obsolete check in nf_conntrack_confirm.
> 
> Thanks, this looks fine. But I need a formal submission, including
> a changelog and Signed-off-by: line. Thanks!

>From 97913752bc65b2aa4a091a73c3569dc8221a1f25 Mon Sep 17 00:00:00 2001
From: Joerg Marx <joerg.marx@secunet.com>
Date: Mon, 10 May 2010 18:39:47 +0200
Subject: [PATCH] Fix a race in __nf_conntrack_confirm against nf_ct_get_next_corpse()

This race was triggered by a 'conntrack -F' command running in parallel
to the insertion of a hash for a new connection.
Losing this race led to a dead conntrack entry effectively blocking
traffic for a particular connection until timeout or flushing the conntrack
hashes again.
Now the check for an already dying connection is done inside the lock.

Signed-off-by: Joerg Marx <joerg.marx@secunet.com>
---
 include/net/netfilter/nf_conntrack_core.h |    2 +-
 net/netfilter/nf_conntrack_core.c         |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index dffde8e..3d7524f 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -61,7 +61,7 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	int ret = NF_ACCEPT;
 
 	if (ct && ct != &nf_conntrack_untracked) {
-		if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
+		if (!nf_ct_is_confirmed(ct))
 			ret = __nf_conntrack_confirm(skb);
 		if (likely(ret == NF_ACCEPT))
 			nf_ct_deliver_cached_events(ct);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0c9bbe9..7ff9a40 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -422,6 +422,16 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 
 	spin_lock_bh(&nf_conntrack_lock);
 
+	/* We have to check the DYING flag inside the lock to prevent
+	   a race against nf_ct_get_next_corpse() possibly called from
+	   user context, else we insert an already 'dead' hash, blocking
+	   further use of that particular connection -JM */
+
+	if (unlikely(nf_ct_is_dying(ct))) {
+		spin_unlock_bh(&nf_conntrack_lock);
+		return NF_ACCEPT;
+	}
+
 	/* See if there's one in the list already, including reverse:
 	   NAT could have grabbed it without realizing, since we're
 	   not in the hash.  If there is, we lost race. */
-- 
1.5.6.5



-- 
