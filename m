Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324943233ED;
	Fri, 22 May 2026 10:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779446599; cv=none; b=YtP2bIkBoMP9Rl8heCeuKyBwrd8kwqPDbm9D46d2s6asq44r059W8kLPgY3qCk/YWNn0ED+RR9L2NwV5CnmBMz33c5TyBg4CTxCiamY0Z/3VdLY6EC+nuPA5SvZLiuKMktbmx0VZnjafvRgMh5nwS1MgWH+y8UiEzqkUUjoKAhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779446599; c=relaxed/simple;
	bh=drigChV9NqbmZq9fn16RO0iAR5QRrRPAhHZqYfMTN/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRyrdrG36V4gulV8CFTjAF+9AbuYbv47xMmo9pR/11eURkt9i34fJK/24QnKpek0j1CrUZTTAljXOxvF5LY3zDdwQopOOwNH/YOt816bv6kibueGcfzj42A3JQo7gTPtCqRf2kYJiYZYbStkbytPtV5vMTZ12kA5/dvQHYjMuf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B083760634; Fri, 22 May 2026 12:43:16 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 03/10] netfilter: nf_conntrack_gre: fix gre keymap list corruption
Date: Fri, 22 May 2026 12:42:50 +0200
Message-ID: <20260522104257.2008-4-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522104257.2008-1-fw@strlen.de>
References: <20260522104257.2008-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Quoting reporter:
  A race between GRE keymap insertion and destruction can corrupt the
  kernel list or use a freed object. `nf_ct_gre_keymap_add()` publishes a
  new keymap pointer before the embedded `list_head` is linked, while
  `nf_ct_gre_keymap_destroy()` can concurrently delete and free that
  same object. An unprivileged user can reach this through the PPTP
  conntrack helper by racing PPTP control messages or helper teardown,
  leading to KASAN-detectable list corruption/UAF in kernel context.

 ## Root Cause Analysis
 `exp_gre()` installs GRE expectations for a PPTP control flow and then
  adds two GRE keymap entries [..]

 The add path publishes `ct_pptp_info->keymap[dir]` before linking the
 embedded list node [..]
 Concurrent teardown deletes that partially initialized object.

Make add/destroy symmetric: install both, destroy both while under lock.

Furthermore, we should refuse to publish a new mapping in case ct is going
away, else we may leak the allocation.

The "retrans" detection is strange:  existing mapping is checked for key
equality with the new mapping, then for "is on the list" via list walk.

But I can't see how an existing keymap entry can be NOT on list.

Change this to only check if we're asked to map same tuple again -- if so,
   skip re-install, else signal failure.

Last, add a bug trap for the keymap list; it has to be empty when namespace
is going away.

Reported-by: Leo Lin <leo@depthfirst.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../linux/netfilter/nf_conntrack_proto_gre.h  |   7 +-
 net/netfilter/nf_conntrack_core.c             |   8 ++
 net/netfilter/nf_conntrack_pptp.c             |   8 +-
 net/netfilter/nf_conntrack_proto_gre.c        | 106 +++++++++++++-----
 4 files changed, 95 insertions(+), 34 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_proto_gre.h b/include/linux/netfilter/nf_conntrack_proto_gre.h
index 9ee7014400e8..ad5563f0f864 100644
--- a/include/linux/netfilter/nf_conntrack_proto_gre.h
+++ b/include/linux/netfilter/nf_conntrack_proto_gre.h
@@ -18,9 +18,10 @@ struct nf_ct_gre_keymap {
 	struct rcu_head rcu;
 };
 
-/* add new tuple->key_reply pair to keymap */
-int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
-			 struct nf_conntrack_tuple *t);
+/* add tuple->key_reply pairs to keymap */
+bool nf_ct_gre_keymap_add(struct nf_conn *ct,
+			  const struct nf_conntrack_tuple *orig,
+			  const struct nf_conntrack_tuple *repl);
 
 /* delete keymap entries */
 void nf_ct_gre_keymap_destroy(struct nf_conn *ct);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8ba5b22a1eef..b521b5ebd664 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -568,6 +568,13 @@ static void destroy_gre_conntrack(struct nf_conn *ct)
 #endif
 }
 
+static void warn_on_keymap_list_leak(const struct net *net)
+{
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	WARN_ON_ONCE(!list_empty(&net->ct.nf_ct_proto.gre.keymap_list));
+#endif
+}
+
 void nf_ct_destroy(struct nf_conntrack *nfct)
 {
 	struct nf_conn *ct = (struct nf_conn *)nfct;
@@ -2510,6 +2517,7 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 	}
 
 	list_for_each_entry(net, net_exit_list, exit_list) {
+		warn_on_keymap_list_leak(net);
 		nf_conntrack_ecache_pernet_fini(net);
 		nf_conntrack_expect_pernet_fini(net);
 		free_percpu(net->ct.stat);
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 4c679638df06..dc23e4181618 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -225,13 +225,9 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 	if (nf_ct_expect_related(exp_reply, 0) != 0)
 		goto out_unexpect_orig;
 
-	/* Add GRE keymap entries */
-	if (nf_ct_gre_keymap_add(ct, IP_CT_DIR_ORIGINAL, &exp_orig->tuple) != 0)
+	if (!nf_ct_gre_keymap_add(ct, &exp_orig->tuple,
+				  &exp_reply->tuple))
 		goto out_unexpect_both;
-	if (nf_ct_gre_keymap_add(ct, IP_CT_DIR_REPLY, &exp_reply->tuple) != 0) {
-		nf_ct_gre_keymap_destroy(ct);
-		goto out_unexpect_both;
-	}
 	ret = 0;
 
 out_put_both:
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 94c19bc4edc5..35e22082d65a 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -87,41 +87,97 @@ static __be16 gre_keymap_lookup(struct net *net, struct nf_conntrack_tuple *t)
 	return key;
 }
 
-/* add a single keymap entry, associate with specified master ct */
-int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
-			 struct nf_conntrack_tuple *t)
+enum nf_ct_gre_km_act {
+	NF_CT_GRE_KM_NEW,
+	NF_CT_GRE_KM_BAD,
+	NF_CT_GRE_KM_DUP
+};
+
+static enum nf_ct_gre_km_act
+nf_ct_gre_km_acceptable(const struct nf_ct_pptp_master *ct_pptp_info,
+			const struct nf_conntrack_tuple *orig,
+			const struct nf_conntrack_tuple *repl)
+{
+	struct nf_ct_gre_keymap *km_orig, *km_repl;
+
+	lockdep_assert_held(&keymap_lock);
+
+	km_orig = ct_pptp_info->keymap[IP_CT_DIR_ORIGINAL];
+	km_repl = ct_pptp_info->keymap[IP_CT_DIR_REPLY];
+
+	if (km_orig && km_repl) {
+		if (!gre_key_cmpfn(km_orig, orig))
+			return NF_CT_GRE_KM_BAD;
+
+		if (!gre_key_cmpfn(km_repl, repl))
+			return NF_CT_GRE_KM_BAD;
+
+		return NF_CT_GRE_KM_DUP;
+	}
+
+	DEBUG_NET_WARN_ON_ONCE(km_orig);
+	DEBUG_NET_WARN_ON_ONCE(km_repl);
+	return NF_CT_GRE_KM_NEW;
+}
+
+/* add keymap entries, associate with specified master ct */
+bool nf_ct_gre_keymap_add(struct nf_conn *ct,
+			  const struct nf_conntrack_tuple *orig,
+			  const struct nf_conntrack_tuple *repl)
 {
 	struct net *net = nf_ct_net(ct);
 	struct nf_gre_net *net_gre = gre_pernet(net);
 	struct nf_ct_pptp_master *ct_pptp_info = nfct_help_data(ct);
-	struct nf_ct_gre_keymap **kmp, *km;
-
-	kmp = &ct_pptp_info->keymap[dir];
-	if (*kmp) {
-		/* check whether it's a retransmission */
-		list_for_each_entry_rcu(km, &net_gre->keymap_list, list) {
-			if (gre_key_cmpfn(km, t) && km == *kmp)
-				return 0;
-		}
-		pr_debug("trying to override keymap_%s for ct %p\n",
-			 dir == IP_CT_DIR_REPLY ? "reply" : "orig", ct);
-		return -EEXIST;
-	}
+	struct nf_ct_gre_keymap *km_orig, *km_repl;
+	bool ret = false;
 
-	km = kmalloc_obj(*km, GFP_ATOMIC);
-	if (!km)
-		return -ENOMEM;
-	memcpy(&km->tuple, t, sizeof(*t));
-	*kmp = km;
+	km_orig = kmalloc_obj(*km_orig, GFP_ATOMIC);
+	if (!km_orig)
+		return false;
+	km_repl = kmalloc_obj(*km_repl, GFP_ATOMIC);
+	if (!km_repl)
+		goto km_free;
 
-	pr_debug("adding new entry %p: ", km);
-	nf_ct_dump_tuple(&km->tuple);
+	memcpy(&km_orig->tuple, orig, sizeof(*orig));
+	memcpy(&km_repl->tuple, repl, sizeof(*repl));
 
 	spin_lock_bh(&keymap_lock);
-	list_add_tail(&km->list, &net_gre->keymap_list);
+	if (nf_ct_is_dying(ct))
+		goto unlock_free;
+
+	switch (nf_ct_gre_km_acceptable(ct_pptp_info, orig, repl)) {
+	case NF_CT_GRE_KM_NEW:
+		break;
+	case NF_CT_GRE_KM_DUP:
+		ret = true;
+		goto unlock_free;
+	case NF_CT_GRE_KM_BAD:
+		pr_debug("trying to override keymap for ct %p\n", ct);
+		goto unlock_free;
+	}
+
+	if (ct_pptp_info->keymap[IP_CT_DIR_ORIGINAL] ||
+	    ct_pptp_info->keymap[IP_CT_DIR_REPLY])
+		goto unlock_free;
+
+	pr_debug("adding new entries %p,%p: ", km_orig, km_repl);
+	nf_ct_dump_tuple(&km_orig->tuple);
+	nf_ct_dump_tuple(&km_repl->tuple);
+
+	list_add_tail_rcu(&km_orig->list, &net_gre->keymap_list);
+	list_add_tail_rcu(&km_repl->list, &net_gre->keymap_list);
+	ct_pptp_info->keymap[IP_CT_DIR_ORIGINAL] = km_orig;
+	ct_pptp_info->keymap[IP_CT_DIR_REPLY] = km_repl;
 	spin_unlock_bh(&keymap_lock);
 
-	return 0;
+	return true;
+
+unlock_free:
+	spin_unlock_bh(&keymap_lock);
+km_free:
+	kfree(km_orig);
+	kfree(km_repl);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_ct_gre_keymap_add);
 
-- 
2.53.0

