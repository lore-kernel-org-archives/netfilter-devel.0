Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A00E17D6
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 00:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785284217; cv=none; b=RfGRBplJ2te39spnLlKOzMt7S9ZZbFTci6NH0yjxu2VVnmDzqrQDXCRiF6ipE/BHUuwaAevRLZLEe04ZfVQk1knTOtVRgqQKOvd4isEf1+4JPkJES6dpZOOJ1UmTsOuO3tLriLpQqiZs3vut/vQC/b1zDCX12rXrT/8nAfxHqyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785284217; c=relaxed/simple;
	bh=xP3nFhVSG//yA0GlcNz1ReKO3ArSVA/l0fx/eKg8xac=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=XdrNIjf5I++fxE/vCFUxWdmhzsjdjYoh/B7kVOrcDLuUGCikt/emHNnqDUngsdJQCMgRiePOdDrOSbOO7HGPYBQF/CPoPhmNcDSObmSsbOlE0Q0b9IZUFKORe/dSTBBjQ/IOkI7jQXRZClrbry01yNf0ezLb5/C1/cCxNxua0Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kqlej/71; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kqlej/71"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 096B86018F
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 02:16:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785284212;
	bh=AWNeTVtbv+X/tV9cE5Btz/HMoLR9bSXjOPMldxaPWTU=;
	h=From:To:Subject:Date:From;
	b=kqlej/71C8TxeorN1znUJUb1l2h6QZmKbzQMfVP0/xm7sBpRaitGRltxmETm2O1d9
	 HmqfrQMpq6IcJ6MM4baULH37/iTrOyyLSrAZI4rTv/+SiPytxP0PnZeYVW20gHNXDX
	 HP8QOjC3cL+73X3SrTWyAeoHu7HjtmNC/dWly0HyRsZpw2mSUT6SD6tT44sq/bMLkK
	 VvX89M5Ugc2KTa8D8K0m/FEvqdN8nQ1EAc83J0EOmUf1UegwNJ38HUL96TSLTtai+E
	 qJGGii8oLqJA89KLyPH8lArdW4flAUafVRPwR/po5hOlte7jnqK0gFBVpYwkUUFDoh
	 YRgnPdhRp74xA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_conntrack: move expectation hlist_head on ct extension realloc
Date: Wed, 29 Jul 2026 02:16:45 +0200
Message-ID: <20260729001645.254396-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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

