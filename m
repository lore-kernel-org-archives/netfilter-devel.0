Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F323783A4;
	Wed,  4 Mar 2026 17:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772645400; cv=none; b=Dl5CJ8X6FEzxtgjgp+KQXetuWeXw/mbpMQOaByfRl3AJBiQAltOeuQlXigF9Cs2Mj5YA/vZHOnJ4Hyd7ROJSW1GNdmeV0NAoBm3ACteiuddSRft9hXw3DCEmDLAP7n2UF+BHk5hvD27jtDQgJJwVByGbbzffGfhJJpUMAL9fp0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772645400; c=relaxed/simple;
	bh=8jnpwIKf/AqtXX7/ntMvMcMaDxEd4U69V/yGaSEhgLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHqcDP6qx7PL4x+d5sRYVc0kmCpfmlRY/xQak95usW/SOIvbS21smHEGT2r6Vw+Iyn6L3NxDaTdX3ques64G8Q/bA61AyXo8jqZBTtaS89lqCMjaG2YsdxeC1S/0xsE0fQtwTMnZJrH3urWMeDsGR2zGb83apvnplxipaj0mJ6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 736896024F; Wed, 04 Mar 2026 18:29:56 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 3/4] netfilter: nf_tables: clone set on flush only
Date: Wed,  4 Mar 2026 18:29:39 +0100
Message-ID: <20260304172940.24948-4-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260304172940.24948-1-fw@strlen.de>
References: <20260304172940.24948-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

Syzbot with fault injection triggered a failing memory allocation with
GFP_KERNEL which results in a WARN splat:

iter.err
WARNING: net/netfilter/nf_tables_api.c:845 at nft_map_deactivate+0x34e/0x3c0 net/netfilter/nf_tables_api.c:845, CPU#0: syz.0.17/5992
Modules linked in:
CPU: 0 UID: 0 PID: 5992 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
RIP: 0010:nft_map_deactivate+0x34e/0x3c0 net/netfilter/nf_tables_api.c:845
Code: 8b 05 86 5a 4e 09 48 3b 84 24 a0 00 00 00 75 62 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 63 6d fa f7 90 <0f> 0b 90 43
+80 7c 35 00 00 0f 85 23 fe ff ff e9 26 fe ff ff 89 d9
RSP: 0018:ffffc900045af780 EFLAGS: 00010293
RAX: ffffffff89ca45bd RBX: 00000000fffffff4 RCX: ffff888028111e40
RDX: 0000000000000000 RSI: 00000000fffffff4 RDI: 0000000000000000
RBP: ffffc900045af870 R08: 0000000000400dc0 R09: 00000000ffffffff
R10: dffffc0000000000 R11: fffffbfff1d141db R12: ffffc900045af7e0
R13: 1ffff920008b5f24 R14: dffffc0000000000 R15: ffffc900045af920
FS:  000055557a6a5500(0000) GS:ffff888125496000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb5ea271fc0 CR3: 000000003269e000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __nft_release_table+0xceb/0x11f0 net/netfilter/nf_tables_api.c:12115
 nft_rcv_nl_event+0xc25/0xdb0 net/netfilter/nf_tables_api.c:12187
 notifier_call_chain+0x19d/0x3a0 kernel/notifier.c:85
 blocking_notifier_call_chain+0x6a/0x90 kernel/notifier.c:380
 netlink_release+0x123b/0x1ad0 net/netlink/af_netlink.c:761
 __sock_release net/socket.c:662 [inline]
 sock_close+0xc3/0x240 net/socket.c:1455

Restrict set clone to the flush set command in the preparation phase.
Add NFT_ITER_UPDATE_CLONE and use it for this purpose, update the rbtree
and pipapo backends to only clone the set when this iteration type is
used.

As for the existing NFT_ITER_UPDATE type, update the pipapo backend to
use the existing set clone if available, otherwise use the existing set
representation. After this update, there is no need to clone a set that
is being deleted, this includes bound anonymous set.

An alternative approach to NFT_ITER_UPDATE_CLONE is to add a .clone
interface and call it from the flush set path.

Reported-by: syzbot+4924a0edc148e8b4b342@syzkaller.appspotmail.com
Fixes: 3f1d886cc7c3 ("netfilter: nft_set_pipapo: move cloning of match info to insert/removal path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 10 +++++++++-
 net/netfilter/nft_set_hash.c      |  1 +
 net/netfilter/nft_set_pipapo.c    | 11 +++++++++--
 net/netfilter/nft_set_rbtree.c    |  8 +++++---
 5 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 426534a711b0..ea6f29ad7888 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -320,11 +320,13 @@ static inline void *nft_elem_priv_cast(const struct nft_elem_priv *priv)
  * @NFT_ITER_UNSPEC: unspecified, to catch errors
  * @NFT_ITER_READ: read-only iteration over set elements
  * @NFT_ITER_UPDATE: iteration under mutex to update set element state
+ * @NFT_ITER_UPDATE_CLONE: clone set before iteration under mutex to update element
  */
 enum nft_iter_type {
 	NFT_ITER_UNSPEC,
 	NFT_ITER_READ,
 	NFT_ITER_UPDATE,
+	NFT_ITER_UPDATE_CLONE,
 };
 
 struct nft_set;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index df67932d3e09..058f7004cb2b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -833,6 +833,11 @@ static void nft_map_catchall_deactivate(const struct nft_ctx *ctx,
 	}
 }
 
+/* Use NFT_ITER_UPDATE iterator even if this may be called from the preparation
+ * phase, the set clone might already exist from a previous command, or it might
+ * be a set that is going away and does not require a clone. The netns and
+ * netlink release paths also need to work on the live set.
+ */
 static void nft_map_deactivate(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	struct nft_set_iter iter = {
@@ -7903,9 +7908,12 @@ static int nft_set_catchall_flush(const struct nft_ctx *ctx,
 
 static int nft_set_flush(struct nft_ctx *ctx, struct nft_set *set, u8 genmask)
 {
+	/* The set backend might need to clone the set, do it now from the
+	 * preparation phase, use NFT_ITER_UPDATE_CLONE iterator type.
+	 */
 	struct nft_set_iter iter = {
 		.genmask	= genmask,
-		.type		= NFT_ITER_UPDATE,
+		.type		= NFT_ITER_UPDATE_CLONE,
 		.fn		= nft_setelem_flush,
 	};
 
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 739b992bde59..b0e571c8e3f3 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -374,6 +374,7 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 {
 	switch (iter->type) {
 	case NFT_ITER_UPDATE:
+	case NFT_ITER_UPDATE_CLONE:
 		/* only relevant for netlink dumps which use READ type */
 		WARN_ON_ONCE(iter->skip != 0);
 
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 7ef4b44471d3..c091898df710 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2144,13 +2144,20 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 	const struct nft_pipapo_match *m;
 
 	switch (iter->type) {
-	case NFT_ITER_UPDATE:
+	case NFT_ITER_UPDATE_CLONE:
 		m = pipapo_maybe_clone(set);
 		if (!m) {
 			iter->err = -ENOMEM;
 			return;
 		}
-
+		nft_pipapo_do_walk(ctx, set, m, iter);
+		break;
+	case NFT_ITER_UPDATE:
+		if (priv->clone)
+			m = priv->clone;
+		else
+			m = rcu_dereference_protected(priv->match,
+						      nft_pipapo_transaction_mutex_held(set));
 		nft_pipapo_do_walk(ctx, set, m, iter);
 		break;
 	case NFT_ITER_READ:
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 3f02e4478216..ee3d4f5b9ff7 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -861,13 +861,15 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 	struct nft_rbtree *priv = nft_set_priv(set);
 
 	switch (iter->type) {
-	case NFT_ITER_UPDATE:
-		lockdep_assert_held(&nft_pernet(ctx->net)->commit_mutex);
-
+	case NFT_ITER_UPDATE_CLONE:
 		if (nft_array_may_resize(set) < 0) {
 			iter->err = -ENOMEM;
 			break;
 		}
+		fallthrough;
+	case NFT_ITER_UPDATE:
+		lockdep_assert_held(&nft_pernet(ctx->net)->commit_mutex);
+
 		nft_rbtree_do_walk(ctx, set, iter);
 		break;
 	case NFT_ITER_READ:
-- 
2.52.0

