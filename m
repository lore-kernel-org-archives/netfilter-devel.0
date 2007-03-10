From: Greg KH <gregkh@suse.de>
Subject: [patch 01/20] conntrack: fix {nf,
	ip}_ct_iterate_cleanup endless loops
Date: Fri, 9 Mar 2007 22:16:21 -0800
Message-ID: <20070310061621.GB31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	netfilter-devel@lists.netfilter.org, Justin Forbes <jmforbes@linuxtx.org>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>, davem@davemloft.net,
	Randy Dunlap <rdunlap@xenotime.net>, Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	akpm@linux-foundation.org, torvalds@linux-foundation.org,
	Patrick McHardy <kaber@trash.net>, alan@lxorguk.ukuu.org.uk
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline;
	filename="conntrack-fix-nf-ip-_ct_iterate_cleanup-endless-loops.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
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

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/netfilter_ipv4/ip_conntrack_core.h |    2 +-
 include/net/netfilter/nf_conntrack_core.h        |    2 +-
 net/ipv4/netfilter/ip_conntrack_core.c           |    2 +-
 net/netfilter/nf_conntrack_core.c                |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

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

-- 
