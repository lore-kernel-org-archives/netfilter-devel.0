Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681B8456E0E
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 11:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785324958; cv=none; b=J7YjSCYUBtbs49Q9dH28r6ApArOzMccc2j71+ZbnFk2G60nqsxiB7SVFehbJK33KqzTUP0n7wLvLhmN+LRqRm5s1+NTDrK+n2ZwDb+QDjm6hNPwXQhullOxIUm8Ym7VL3UURL8411siwywtok+8VBlRxKwCoA6pRjEs2VDKYXgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785324958; c=relaxed/simple;
	bh=MKGLqI2SrclB8DAfSyBa7WQIX1pDVq/EL4q6KlMxsvA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHArOpbwb6wX1AA0ZTG5ym+27h2Z9k6vZcU2nQhAyGBEhSuaEagirPJCVY9I7fQrmmSWwGH7+hiE43+eJ2lFqOGLhQ1R4wsV4ubkIYaH6QBmWoaVPKuSGzDV9PAKD8nG9VpC8EQVEEVKhJZHPMdcKEMDmq2yNTzSSfUkII+FXGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dKCdXmS+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dKCdXmS+"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 70A14602B4
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 13:35:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785324954;
	bh=wyfBmrjndTqhkrTU10o3Q+io/JL2ByA7b7Wh+sUg9X8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dKCdXmS+2Mu3rZ0slzzmYPwALiqVBqGb2J220HkTk5NpZBvJM3rYVYbrkfR3BsXxi
	 K1xCrSMV3MbKSiYKpQMdG5bqv/8sn90gZdLWHSf66PtAJGPVyQLu1xIrqG91jz0+6Z
	 P8wlbV3hIxTB2Gg4Y9pvEin6PC0QGuzq+ihX5wp1leu/puZmoICtNLdQh8wtgIkQWq
	 3hNq3hOI5gPS30fS1G8l+RDuPVpPzCb6WOxh99283E7o66fWjImBy7So1gOPcpUmOh
	 tZIO3Bhu17DiOmabNPxUr/Lt4Hs6tkcLwez6OgOMrRYi5v++RyONd6rBV0DSKgX/Nb
	 dzI+5mdLoSaQQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 2/2] netfilter: nf_conntrack: move expectation hlist_head on ct extension realloc
Date: Wed, 29 Jul 2026 13:35:48 +0200
Message-ID: <20260729113548.389791-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729113548.389791-1-pablo@netfilter.org>
References: <20260729113548.389791-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 7c9664351980 ("netfilter: move nat hlist_head to nf_conn") moved
the nat hlist_head to nf_conn and it removes the .move callback for ct
extensions. This commit description already points to the same problem
that is being addressed for expectations by this patch:

 1. ...
 2. When reallocation of extension area occurs we need to fixup the
    bysource hash head via hlist_replace_rcu.

This means that the .pprev pointer of the first expectation might refer
to a stale hlist_head after reallocation.

This bug is now easier to trigger since the introduction of the commit
857b46027d6f ("netfilter: nft_ct: add ct expectations support") which
allows to create expectations before the ct extension area have been
fully set up for unconfirmed conntracks.

This patch uses hlist_move_list() because this conntrack is unconfirmed,
ie. not yet in the hashes, and it is neither visible to the conntrack
garbage collector nor ctnetlink.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Reported-by: Jaeyeong Lee <iostreampy@proton.me>
Link: https://patch.msgid.link/20260715144755.00ea7dfcd9f@proton.me
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 net/netfilter/nf_conntrack_extend.c | 33 ++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 0da105e1ded9..ea7795a2461f 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -87,9 +87,34 @@ static __always_inline unsigned int total_extension_size(void)
 	;
 }
 
+static void nf_ct_ext_helper_save(struct nf_conn *ct,
+				  struct hlist_head *expectations)
+{
+	struct nf_conn_help *help;
+
+	help = nf_ct_ext_find(ct, NF_CT_EXT_HELPER);
+	if (!help)
+		return;
+
+	hlist_move_list(&help->expectations, expectations);
+}
+
+static void nf_ct_ext_helper_restore(struct nf_conn *ct,
+				     struct hlist_head *expectations)
+{
+	struct nf_conn_help *help;
+
+	help = nf_ct_ext_find(ct, NF_CT_EXT_HELPER);
+	if (!help)
+		return;
+
+	hlist_move_list(expectations, &help->expectations);
+}
+
 void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 {
 	unsigned int newlen, newoff, oldlen, alloc;
+	HLIST_HEAD(expectations);
 	struct nf_ct_ext *new;
 
 	/* Conntrack must not be confirmed to avoid races on reallocation. */
@@ -108,13 +133,17 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 		oldlen = sizeof(*new);
 	}
 
+	nf_ct_ext_helper_save(ct, &expectations);
+
 	newoff = ALIGN(oldlen, __alignof__(struct nf_ct_ext));
 	newlen = newoff + nf_ct_ext_type_len[id];
 
 	alloc = max(newlen, NF_CT_EXT_PREALLOC);
 	new = krealloc(ct->ext, alloc, gfp);
-	if (!new)
+	if (!new) {
+		nf_ct_ext_helper_restore(ct, &expectations);
 		return NULL;
+	}
 
 	if (!ct->ext)
 		memset(new->offset, 0, sizeof(new->offset));
@@ -124,6 +153,8 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	memset((void *)new + newoff, 0, newlen - newoff);
 
 	ct->ext = new;
+	nf_ct_ext_helper_restore(ct, &expectations);
+
 	return (void *)new + newoff;
 }
 EXPORT_SYMBOL(nf_ct_ext_add);
-- 
2.47.3

