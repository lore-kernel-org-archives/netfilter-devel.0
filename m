From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/13]: conntrack: fix {nf,
	ip}_ct_iterate_cleanup endless loops
Date: Wed,  7 Mar 2007 22:34:27 +0100 (MET)
Message-ID: <20070307213348.22306.24109.sendpatchset@localhost.localdomain>
References: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
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

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 841de8621862a5406d2a236dd142a5e5db167d25
tree 347d137f0d6466f0b4da83256bfbeaa4150f105a
parent 8d1117a9f5d302d8d460fbe7ef322b382e45c9ce
author Patrick McHardy <kaber@trash.net> Mon, 26 Feb 2007 18:48:05 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 28 Feb 2007 19:02:00 +0100

 include/linux/netfilter_ipv4/ip_conntrack_core.h |    2 +-
 include/net/netfilter/nf_conntrack_core.h        |    2 +-
 net/ipv4/netfilter/ip_conntrack_core.c           |    2 +-
 net/netfilter/nf_conntrack_core.c                |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack_core.h b/include/linux/netfilter_ipv4/ip_conntrack_core.h
index 907d4f5..e3a6df0 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack_core.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_core.h
@@ -45,7 +45,7 @@ static inline int ip_conntrack_confirm(s
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
@@ -64,7 +64,7 @@ static inline int nf_conntrack_confirm(s
 	int ret = NF_ACCEPT;
 
 	if (ct) {
-		if (!nf_ct_is_confirmed(ct))
+		if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
 			ret = __nf_conntrack_confirm(pskb);
 		nf_ct_deliver_cached_events(ct);
 	}
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 8556a4f..f8b3009 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1242,7 +1242,7 @@ get_next_corpse(int (*iter)(struct ip_co
 	list_for_each_entry(h, &unconfirmed, list) {
 		ct = tuplehash_to_ctrack(h);
 		if (iter(ct, data))
-			goto found;
+			set_bit(IPS_DYING_BIT, &ct->status);
 	}
 	write_unlock_bh(&ip_conntrack_lock);
 	return NULL;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9b02ec4..cb29ba7 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1052,7 +1052,7 @@ get_next_corpse(int (*iter)(struct nf_co
 	list_for_each_entry(h, &unconfirmed, list) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		if (iter(ct, data))
-			goto found;
+			set_bit(IPS_DYING_BIT, &ct->status);
 	}
 	write_unlock_bh(&nf_conntrack_lock);
 	return NULL;
