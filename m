From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/10]: conntrack: fix {nf,
	ip}_ct_iterate_cleanup endless loops
Date: Sun,  4 Mar 2007 21:19:59 +0100 (MET)
Message-ID: <20070304201907.28582.32005.sendpatchset@localhost.localdomain>
References: <20070304201906.28582.51903.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070304201906.28582.51903.sendpatchset@localhost.localdomain>
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

Reported and tested by Chuck Ebbert <cebbert@redhat.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3b0f1308568d67be761a89c95354cce8617e6715
tree ab83a08e8daa26e2bb1051314e36da6a76cb0219
parent 2ff7354fe888f46f6629b57e463b0a1eb956c02b
author Patrick McHardy <kaber@trash.net> Thu, 01 Mar 2007 15:15:49 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 01 Mar 2007 15:15:49 +0100

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
index 07ba1dd..23b99ae 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1254,7 +1254,7 @@ get_next_corpse(int (*iter)(struct ip_co
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
@@ -1070,7 +1070,7 @@ get_next_corpse(int (*iter)(struct nf_co
 	list_for_each_entry(h, &unconfirmed, list) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		if (iter(ct, data))
-			goto found;
+			set_bit(IPS_DYING_BIT, &ct->status);
 	}
 	write_unlock_bh(&nf_conntrack_lock);
 	return NULL;
