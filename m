From: Joerg Marx <joerg.marx@secunet.com>
Subject: Re: [PATCH] nf_conntrack_core.c: fix for dead connection after flushing
 conntrack cache
Date: Mon, 10 May 2010 19:08:35 +0200
Message-ID: <4BE83D93.8080909@secunet.com>
References: <4BE3D31F.6000607@secunet.com> <4BE73DE3.6080304@netfilter.org> <4BE824EA.6000303@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Mail List - Netfilter <netfilter@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:56600 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab0EJRJF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 May 2010 13:09:05 -0400
In-Reply-To: <4BE824EA.6000303@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/10/2010 05:23 PM, Patrick McHardy wrote:

...
> 
> I think this should be fine since the race you describe only affects
> unconfirmed conntracks, but it took me a while to realize that all
> the other spots where the DYING bit is set are fine without holding
> the conntrack lock.
> 
> Could you please add a comment to the check in __nf_conntrack_confirm()
> stating that the dying check is supposed to prevent races against
> nf_ct_get_next_corpse()? The semantic of the DYING bit is unfortunately
> a bit overloaded.
> 
> Also, since the condition unconfirmed + dying in nf_conntrack_confirm()
> is highly unlikely, I'd suggest to remove the dying check there and only
> perform it in __nf_conntrack_confirm().
> 

I hope the comment is clearly pointing to the (solved) problem now. I
also removed the obsolete check in nf_conntrack_confirm.

diff --git a/include/net/netfilter/nf_conntrack_core.h
b/include/net/netfilter/nf_conntrack_core.h
index dffde8e..3d7524f 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -61,7 +61,7 @@ static inline int nf_conntrack_confirm(struct sk_buff
*skb)
 	int ret = NF_ACCEPT;

 	if (ct && ct != &nf_conntrack_untracked) {
-		if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
+		if (!nf_ct_is_confirmed(ct))
 			ret = __nf_conntrack_confirm(skb);
 		if (likely(ret == NF_ACCEPT))
 			nf_ct_deliver_cached_events(ct);
diff --git a/net/netfilter/nf_conntrack_core.c
b/net/netfilter/nf_conntrack_core.c
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

