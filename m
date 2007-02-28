From: Patrick McHardy <kaber@trash.net>
Subject: Re: Soft lockup on shutdown in nf_ct_iterate_cleanup()
Date: Wed, 28 Feb 2007 19:09:13 +0100
Message-ID: <45E5C549.2030009@trash.net>
References: <45DB9C1F.1080605@redhat.com> <45DCEA47.5080100@redhat.com>
	<45E04468.7020001@trash.net> <45E06546.504@redhat.com>
	<45E1C7E0.9070102@trash.net> <45E31572.4040108@redhat.com>
	<45E31EB5.6000809@trash.net> <45E34F74.8050807@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030902070508090902050403"
Cc: netfilter-devel@lists.netfilter.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Chuck Ebbert <cebbert@redhat.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45E34F74.8050807@redhat.com>
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

This is a multi-part message in MIME format.
--------------030902070508090902050403
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Chuck Ebbert wrote:
> Patrick McHardy wrote:
> 
>>This patch is against current stable-2.6.20, it applies
>>cleanly to 2.6.20 as well.
>
>
> Everything works OK, but I get:
> 
> BUG: warning: (!list_empty(&unconfirmed)) at
> net/netfilter/nf_conntrack_core.c:1068/nf_ct_cleanup()
> 
> <> nf_ct_cleanup+0x66/0x122 [nf_conntrack]
> <> kill_l4proto+0x0 [nf_conntrack]
> <> nf_conntrack_l4proto_unregister+0x7d/0x82 [nf_conntrack]
> <> nf_conntrack_l3proto_ipv4_fini+0x3c/0x46 [nf_conntrack_ipv4]
> <> sys_delete_module+0x18a/0x1b1


Thanks, the previous approach doesn't seem to work properly without
unpleasant event cache hacks. This patch takes a simpler approach
and keeps the unconfirmed list iteration, but makes sure to make
forward progress.


--------------030902070508090902050403
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

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

--------------030902070508090902050403--
