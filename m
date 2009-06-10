From: Patrick McHardy <kaber@trash.net>
Subject: RFC: conntrack: use mod_timer_pending()
Date: Wed, 10 Jun 2009 15:05:56 +0200
Message-ID: <4A2FAFB4.1050100@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090405040506020708010205"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Martin Josefsson <gandalf@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58107 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbZFJNF5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:05:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090405040506020708010205
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This patch changes conntrack to use the new mod_timer_pending()
function, which only rearms the timer if it was still active.
This allows to only grab the lock in __nf_ct_refresh_acct when
accounting is used.

Anyone seing anything wrong with this?

--------------090405040506020708010205
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index edf9569..2737f5d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -807,8 +807,6 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 	NF_CT_ASSERT(ct->timeout.data == (unsigned long)ct);
 	NF_CT_ASSERT(skb);
 
-	spin_lock_bh(&nf_conntrack_lock);
-
 	/* Only update if this is not a fixed timeout */
 	if (test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status))
 		goto acct;
@@ -822,11 +820,8 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 		/* Only update the timeout if the new timeout is at least
 		   HZ jiffies from the old timeout. Need del_timer for race
 		   avoidance (may already be dying). */
-		if (newtime - ct->timeout.expires >= HZ
-		    && del_timer(&ct->timeout)) {
-			ct->timeout.expires = newtime;
-			add_timer(&ct->timeout);
-		}
+		if (newtime - ct->timeout.expires >= HZ)
+			mod_timer_pending(&ct->timeout, newtime);
 	}
 
 acct:
@@ -835,13 +830,13 @@ acct:
 
 		acct = nf_conn_acct_find(ct);
 		if (acct) {
+			spin_lock_bh(&nf_conntrack_lock);
 			acct[CTINFO2DIR(ctinfo)].packets++;
 			acct[CTINFO2DIR(ctinfo)].bytes +=
 				skb->len - skb_network_offset(skb);
+			spin_unlock_bh(&nf_conntrack_lock);
 		}
 	}
-
-	spin_unlock_bh(&nf_conntrack_lock);
 }
 EXPORT_SYMBOL_GPL(__nf_ct_refresh_acct);
 

--------------090405040506020708010205--
