From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.6.16]: conntrack: fix {nf,ip}_ct_iterate_cleanup endless
 loops
Date: Wed, 08 Oct 2008 12:27:18 +0200
Message-ID: <48EC8B06.90101@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040101050208020905070609"
Cc: Nishit Shah <nishit@elitecore.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Adrian Bunk <bunk@kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45300 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbYJHK1V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:27:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040101050208020905070609
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Adrian,

Nishit asked me to push this backport of a fix for an endless
loop during conntrack module unload to you for 2.6.16.

Please apply, thanks.

--------------040101050208020905070609
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 35c5076aae0ba350f27af52881d856e3997005c5
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed Oct 8 12:25:33 2008 +0200

    [NETFILTER]: conntrack: fix {nf,ip}_ct_iterate_cleanup endless loops
    
    Upstream commit ec68e97d:
    ----
    Fix {nf,ip}_ct_iterate_cleanup unconfirmed list handling:
    
    - unconfirmed entries can not be killed manually, they are removed on
      confirmation or final destruction of the conntrack entry, which means
      we might iterate forever without making forward progress.
    
      This can happen in combination with the conntrack event cache, which
      holds a reference to the conntrack entry, which is only released when
      the packet makes it all the way through the stack or a different
      packet is handled.
    
    - taking references to an unconfirmed entry and using it outside the
      locked section doesn't work, the list entries are not refcounted and
      another CPU might already be waiting to destroy the entry
    
    What the code really wants to do is make sure the references of the hash
    table to the selected conntrack entries are released, so they will be
    destroyed once all references from skbs and the event cache are dropped.
    
    Since unconfirmed entries haven't even entered the hash yet, simply mark
    them as dying and skip confirmation based on that.
    
    Reported and tested by Chuck Ebbert <cebbert@redhat.com>
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>
    ---

diff --git a/include/linux/netfilter_ipv4/ip_conntrack_core.h b/include/linux/netfilter_ipv4/ip_conntrack_core.h
index 907d4f5..e3a6df0 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack_core.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_core.h
@@ -45,7 +45,7 @@ static inline int ip_conntrack_confirm(struct sk_buff **pskb)
 	int ret = NF_ACCEPT;
 
 	if (ct) {
-		if (!is_confirmed(ct))
+		if (!is_confirmed(ct) && !is_dying(ct))
 			ret = __ip_conntrack_confirm(pskb);
 		ip_ct_deliver_cached_events(ct);
 	}
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index da25452..7b01393 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -61,7 +61,7 @@ static inline int nf_conntrack_confirm(struct sk_buff **pskb)
 	int ret = NF_ACCEPT;
 
 	if (ct) {
-		if (!nf_ct_is_confirmed(ct))
+		if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
 			ret = __nf_conntrack_confirm(pskb);
 		nf_ct_deliver_cached_events(ct);
 	}
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 43f6b45..d6c2890 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1251,11 +1251,17 @@ get_next_corpse(int (*iter)(struct ip_conntrack *i, void *data),
 		if (h)
 			break;
 	}
-	if (!h)
+	if (!h) {
 		h = LIST_FIND_W(&unconfirmed, do_iter,
 				struct ip_conntrack_tuple_hash *, iter, data);
-	if (h)
+		if (h) {
+			struct ip_conntrack * ct = tuplehash_to_ctrack(h);
+			set_bit(IPS_DYING_BIT, &ct->status);
+		}
+		h = NULL;
+	} else {
 		atomic_inc(&tuplehash_to_ctrack(h)->ct_general.use);
+	}
 	write_unlock_bh(&ip_conntrack_lock);
 
 	return h;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d622ddf..308cda1 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1504,11 +1504,17 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 		if (h)
 			break;
  	}
-	if (!h)
+	if (!h) {
 		h = LIST_FIND_W(&unconfirmed, do_iter,
 				struct nf_conntrack_tuple_hash *, iter, data);
-	if (h)
+		if (h) {
+			struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
+			set_bit(IPS_DYING_BIT, &ct->status);
+		}
+		h = NULL;
+	} else {
 		atomic_inc(&nf_ct_tuplehash_to_ctrack(h)->ct_general.use);
+	}
 	write_unlock_bh(&nf_conntrack_lock);
 
 	return h;

--------------040101050208020905070609--
