Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793462047;
	b=pcqti/yKHKDeKqhJJrfDQUKbQ8PODF7S0vfbv4lwVRcqgw3Xc+EwaCwCwF8QXYltGB0w
	 ugXbEe43uICkK3ADZ/oRqbQ6a9cWjFPpRJYAxmdqH6aiXWYtMTqHaGqNoOAspkGTEbo3S
	 /thNBDH7PES8MeuibgCEgMS2WQ3PrLRmuV8SxmWbPy5YuscXb9PRDp9fhtJr2MVe+oXNu
	 EW8eD/vjPzhNqU1booI83ZBttBFFHFU0yRrT2zxi2n3zJGkXz56e+3LjlzIo21XvUZ96e
	 KK/kpDM1/Tx9k4OyLGZ8euuDTZ/WWwymMyYvTezzGwm/QCaDvv9PgT1UtZ6j94knrZw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793462047;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Ap1THHwprcvvPpcpEr48EzhOSj8jQxbUx0lCFpj9fSg=;
	b=Tb/7ZkXkXlTnI+lf8m39xdvmjo99t8SoVinEtEZlvamMrerQY1jJqbYQTrAC8bGYGKHH
	 T2FM832Py9xonRQKk0secOQTWCH7tHMdgndpx3/nuEmnJL0VX8A6DnpZM7OepxI8nIPDn
	 3Vn89L78C5Hqp/rU/lLjXerdZszbzXEsXu7aZbZ2sChyP7QwLLDWP559La9VIpFBLkp6d
	 Frh3qJnm2zmfuYdz0bjWaklmdQnge19Qy0/rfRK3RolGLYGe/r97W/Qpf6YDRYWDwiURq
	 29hiWLYq3JSO3SfcgH46+7lacMbzBS10lyWnifOUuVUv6W3DpNfORigFH3HcvhvrEEg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rk4jeYmj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76EB606A31A;
	Sat, 31 Oct 2026 15:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rk4jeYmj
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793462046;
	b=qHCoqKyIud9ankdDKVPRv3kPaZWAkhwMw3gThypHx5nFNxXL9dNbXmHkZY9HZBk4dGni
	 Oqywbiab0fobzwjPEHQGTHbdmiKazSdXhvL9Mafe1kv5YxaIVzGnf2bhOTz+dP2K6Lvk5
	 zPKqYyT3FxlxOlEQ7C+SwuotL+SVgfeP6GrIyyCIW/esY1xtuRy3kN5hUM7NEZ4+T92pv
	 8NGthvWS6n8MdD3hd3T4QbKvQZq30LiCvjYxk7tJD96XDGKlZkDaRokSzrvIUkdg2g/MD
	 GTPe3yXf8p7ctKFstr0sFxYnMmvz/4ADVhOh/6P7vG7iA8yvozWCN8z3rkkwMhYHuHA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793462046;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=Ap1THHwprcvvPpcpEr48EzhOSj8jQxbUx0lCFpj9fSg=;
	b=yNbCEoa6JT0We21VPaABUiEr41AB+NTqbSBokZcVSQOoN7PovgW7SkVy9se/2ZvEaSbp
	 /6qQdhsJN9xtvN1OAIIgIvdbrTCzb77eeKQiaPqe1BbjFMRRf29okhDo00tbpArs5jFK/
	 vis/2Yni+BiHhOutACAvEr5BTUQOEDkUueT+6vH79kVLprLvC+OYUKwa9badsQfjRDmac
	 FX6FXdd9K40pxptuK4pG58YSHoq342XpFAObDcUnfAbeMNw+W3LL1+89kAayfPyvEe9Eq
	 q88Nwx97JGzkpWsftuPPu2ExCkIPxYRTWKig+Kp91GkRXXTluFf86FsxLfwCR1N075w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C25111F000C1;
	Sat, 31 Oct 2026 15:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793462046;
	bh=Ap1THHwprcvvPpcpEr48EzhOSj8jQxbUx0lCFpj9fSg=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=Rk4jeYmj2TqA8WYuJ7O5v4lxoitZ0tJRKLlflsDdldQxbttrnAbYX4NOk6wpm5t72
	 Uqku29GoLGMiag4okPBCSWCrQLqAI/ri6DzLXR6UJsSOFvAGvBUZzE7W2ZHWx/bZ2e
	 +o5GpEiSg2Nn9LlnHWooZdLZGqSXlfKOy7raB+KI3VvdSeR0ouhhmmh+4AM4K13zN6
	 NfWewSdDpCllFCOE1bPna6h2LDkauC334y+9ZlVEFo/3p9xM2G6cDdnCQnzGRVnr0e
	 4IcGVeojLxgKU+BXNqZPsoZ7pDRiiP3TSKMAlulaiElTyI7qCBnotUXaMwJn4jC7DM
	 rB9d6eoJiOfHA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 210B645F38;
	Sat, 31 Oct 2026 15:54:05 +0000 (UTC)
From: Joas Antonio dos Santos via B4 Relay <devnull+joasantonio108.gmail.com@kernel.org>
Date: Sat, 31 Oct 2026 15:54:05 +0000
Subject: [PATCH nf] netfilter: nft_set_rbtree: do not pair an expired start
 with another interval's end
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261031-b4-nft-rbtree-gc-v1-1-51d087c187a6@gmail.com>
X-B4-Tracking: v=1; b=H4sIABwP5moC/x3MPQqAMAxA4atIZgNtFUWvIg79SWuWKqmIIN7d4
 vgN7z1QSJgKzM0DQhcX3nOFbhvwm82JkEM1GGUGrTqNrsccTxR3ChEmjzpMfjTBWeMC1OwQinz
 /ywVyhPV9P2GHHG1mAAAA
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Joas Antonio dos Santos <joasantonio108@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793462044; l=6188;
 i=joasantonio108@gmail.com; s=20261031; h=from:subject:message-id;
 bh=TXKOw0AxzyY7cMw4G7eFALzoeAvz3Y6zIv9RayVZTE4=;
 b=/rn2K5I4dav/QPkX0MaECT7axMWE8jro/pg2Q2KvcLdtZwbnQSGzDkOufsj8iPvvWTppNgxGE
 dk97FoPqZCiC6VN2jy53gJEmH+KX3tZjDswEu4TfzD/oZHO8eBxe3Yt
X-Developer-Key: i=joasantonio108@gmail.com; a=ed25519;
 pk=ZxAznJT/FcPPdzLrDDFJQm4LLjjHVGBBqDSG3TXS23w=
X-Endpoint-Received: by B4 Relay for joasantonio108@gmail.com/20261031 with
 auth_id=1371
X-Original-From: Joas Antonio dos Santos <joasantonio108@gmail.com>
Reply-To: joasantonio108@gmail.com
Content-Transfer-Encoding: 7bit

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

Garbage collection of an expired interval start element also removes its
end element. Both the insertion path, nft_rbtree_gc_elem(), and the
commit path, nft_rbtree_gc_scan(), find that end element by its position
in the tree, and both can pick the end element of a different, live
interval:

- nft_rbtree_gc_elem() walks towards higher keys and skips end elements
  that are not active in both generations. If the end element of the
  expired interval is being deleted in the same transaction, the walk
  skips it, passes the start element of the next interval and takes that
  interval's end element instead.

- nft_rbtree_gc_scan() remembers the last end element it visited in
  rbe_end, but does not clear it when it visits a live start element. An
  expired start element without an end element (a start-only element, or
  an interval whose end element was already removed) then takes the end
  element of the live interval above it.

In both cases the live interval [S, E) loses E: the set no longer holds
the interval that userspace added, and deleting [S, E) later fails with
ENOENT.

In the insertion path, stop the walk at the first element that is active
in the current generation. Elements added by this transaction are still
skipped, as intended by commit 60c0c230c6f0 ("netfilter: nft_set_rbtree:
skip end interval element from gc"). If that element is a start element,
the expired interval has no end element. If it is an end element that
this transaction is removing, leave it to the transaction. In the commit
path, clear rbe_end when a live start element is visited.

Reproduced on current mainline under QEMU (arm64, KASAN), from an
unprivileged user in a new user and network namespace:

- insertion path: add [10,20) with a 50ms timeout and [30,40), wait,
  then in one batch delete the end element 20 and add [12,13).
  Before: a GET for 45 finds an element, the end element 40 is gone and
  deleting [30,40) fails with ENOENT. After: 45 is not found, 40 is
  present and the delete succeeds.

- commit path: add [30,40) and a start-only element 10 with a 50ms
  timeout to a set with a 100ms gc interval, wait, then add [200,201),
  whose insertion walk stops at the highest element, so only the
  commit-time scan reaches 10. Before: the end element 40 is gone and
  deleting [30,40) fails with ENOENT. After: both work.

Normal expiry, and a new interval whose end element shares the key of an
expired start element (the case handled by 60c0c230c6f0), behave the same
before and after. About 39000 random batches on interval sets with
timeouts, with and without slab/page allocation fault injection, showed
no KASAN, lockdep or WARN reports with the patch applied.

The insertion path issue was found with a small nfnetlink fuzzer. Both
paths had been pointed out earlier by the netdev AI review of commit
86b6471e690c ("netfilter: nft_set_rbtree: skip transaction elements
during GC"), see the Link below.

Fixes: f718863aca46 ("netfilter: nft_set_rbtree: fix overlap expiration walk")
Fixes: 8d8540c4f5e0 ("netfilter: nft_set_rbtree: add timeout support")
Link: https://lore.kernel.org/all/179063970372.3145.17414936987144600093@kernel.org/
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
---
Tool-use note: the fuzzer, the directed tests and the analysis were
prepared with help from an LLM-based assistant; I reviewed the change
and built and ran all tests myself. Test harness available on request.

This is a resend through the kernel.org web endpoint: my earlier
submission of this patch was blocked by my mail provider and never
reached the lists.
---
 net/netfilter/nft_set_rbtree.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index fbe1750f1..086823067 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -215,17 +215,25 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
 	struct nft_set *set = (struct nft_set *)__set;
 	struct rb_node *prev = rb_prev(&rbe->node);
 	struct net *net = read_pnet(&set->net);
+	u8 cur_genmask = nft_genmask_cur(net);
 	struct nft_rbtree_elem *rbe_prev;
 
 	/* search for end interval coming before this element.
 	 * end intervals don't carry a timeout extension, they
 	 * are coupled with the interval start element.
+	 *
+	 * Skip elements added in this transaction. The first element
+	 * that is active in the current generation is either the end
+	 * element of this interval or the start element of another
+	 * interval, in which case this interval has no end element.
 	 */
 	while (prev) {
 		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
-		if (nft_rbtree_interval_end(rbe_prev) &&
-		    nft_set_elem_active(&rbe_prev->ext, NFT_GENMASK_ANY))
+		if (nft_set_elem_active(&rbe_prev->ext, cur_genmask)) {
+			if (!nft_rbtree_interval_end(rbe_prev))
+				prev = NULL;
 			break;
+		}
 
 		prev = rb_prev(prev);
 	}
@@ -233,7 +241,11 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
 	rbe_prev = NULL;
 	if (prev) {
 		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
-		nft_rbtree_gc_elem_move(net, set, priv, rbe_prev);
+		/* end element is being removed by this transaction */
+		if (nft_set_elem_active(&rbe_prev->ext, NFT_GENMASK_ANY))
+			nft_rbtree_gc_elem_move(net, set, priv, rbe_prev);
+		else
+			rbe_prev = NULL;
 	}
 
 	nft_rbtree_gc_elem_move(net, set, priv, rbe);
@@ -911,8 +923,11 @@ static void nft_rbtree_gc_scan(struct nft_set *set)
 			rbe_end = rbe;
 			continue;
 		}
-		if (!__nft_set_elem_expired(&rbe->ext, tstamp))
+		if (!__nft_set_elem_expired(&rbe->ext, tstamp)) {
+			/* rbe_end belongs to this live interval */
+			rbe_end = NULL;
 			continue;
+		}
 
 		/* end element needs to be removed first, it has
 		 * no timeout extension.

---
base-commit: c339f4010dea8b0d754f84ace70cd1b089878ef8
change-id: 20261031-b4-nft-rbtree-gc-1d9c72dba2bd

Best regards,
-- 
Joas Antonio dos Santos <joasantonio108@gmail.com>


