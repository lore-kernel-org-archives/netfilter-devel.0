From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: rmmod ip_conntrack hangs.....
Date: Thu, 26 Apr 2007 20:05:08 +0900 (JST)
Message-ID: <200704261105.l3QB59O2008748@toshiba.co.jp>
References: <075601c78707$5d19c800$4c01a8c0@elitecore26>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: nishit@elitecore.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <075601c78707$5d19c800$4c01a8c0@elitecore26>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

From: "Nishit Shah" <nishit@elitecore.com>
Date: Wed, 25 Apr 2007 12:30:09 +0530

> Hi,
>         when I do rmmod ip_conntrack, rmmod hangs. It is not the case
> everytime but sometimes "rmmod ip_conntrack" hangs.

It has been already fixed by following patch, which is available in 2.6.21,
I think.

commit ec68e97dedacc1c7fb20a4b23b7fa76bee56b5ff
Author: Patrick McHardy <kaber@trash.net>
Date:   Sun Mar 4 15:57:01 2007 -0800

    [NETFILTER]: conntrack: fix {nf,ip}_ct_iterate_cleanup endless loops
    
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
index 7fdc72c..85634e1 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -64,7 +64,7 @@ static inline int nf_conntrack_confirm(struct sk_buff **pskb)
 	int ret = NF_ACCEPT;
 
 	if (ct) {
-		if (!nf_ct_is_confirmed(ct))
+		if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
 			ret = __nf_conntrack_confirm(pskb);
 		nf_ct_deliver_cached_events(ct);
 	}
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 07ba1dd..23b99ae 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1254,7 +1254,7 @@ get_next_corpse(int (*iter)(struct ip_conntrack *i, void *data),
 	list_for_each_entry(h, &unconfirmed, list) {
 		ct = tuplehash_to_ctrack(h);
 		if (iter(ct, data))
-			goto found;
+			set_bit(IPS_DYING_BIT, &ct->status);
 	}
 	write_unlock_bh(&ip_conntrack_lock);
 	return NULL;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 32891eb..4fdf484 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1070,7 +1070,7 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 	list_for_each_entry(h, &unconfirmed, list) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		if (iter(ct, data))
-			goto found;
+			set_bit(IPS_DYING_BIT, &ct->status);
 	}
 	write_unlock_bh(&nf_conntrack_lock);
 	return NULL;
