Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854873B7764
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 09:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911182; cv=none; b=mVqRFpsszzKjxgGzCie7kQVBJhkQm/GR4/URYJjDMeWDEplpLEyUkFHRW03YJUrE9Q162utk/PfTJzL+POc47gubjzSesJJbKDVYTe0yyC3E3iof+2ONio7vZFY7wD2YJQV/R1XeqqLfaENmXKVqdLcGqO+zj4rfzsJOBEkGU1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911182; c=relaxed/simple;
	bh=EW28Ih1sQQKgBYLGD5qRtURBEvXJCypJSAIGcfs8+7E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C2os/RnNGwYGBEPT3Iv5lfcS050FYzzWLPHTHBVY1w5ZV/YfKqvn/JNPW7mDHE+E7USx+PvdHTWBekE59JXhFvCgB9mAuLVdiRJhusJ1zOQzmMGQOyCOccWqz9GQ5e0H1a7BFI6BEnJ+ePWl71+dwgjaBjX6l1e/xFkROSrgwdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MD9lDc2t; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MD9lDc2t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FboqeNgbwySXNw1JjSaqOP19KBj/T1qDq9WmO8CXWFM=; b=MD9lDc2t1fe/wftsjt+Mi/OW+2
	fOTj2FccrmhMnX2nhWIqMxbBhK7Ta32OjnQDGqxC+GSpFhcGVOjijqpb6EUE2uRmjmtdpRF1oND8L
	2UNYOxTspnTA6gi9vWYqhFdccWCHKMQccTuJiUJ0Y/wq2I81mugGTmEE+jd4c9B2jE8uY8GqDnBLD
	9qgrVKLdH/NT9sTxmKQ4zPqOcICcul0zWEOr843SK+oaIdkmN4id/7CN/4pLU/MzwmLGWYr3e9nqG
	nqYEqboTqyfZDDsM+CGVKL3pnsVq/+GGHf/qRn3FyZ/11MNlC1YVkv9SdVpvSfX4g8vJ5Z+Ql3crY
	RuBHEeJQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w39Kc-000000000YJ-3Umv;
	Thu, 19 Mar 2026 10:06:18 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Chloro Dose <chlorodose@gmail.com>
Subject: [libnftnl PATCH] set{,_elem}: Drop nftnl_set{,_elem}_clone()
Date: Thu, 19 Mar 2026 10:06:13 +0100
Message-ID: <20260319090613.13874-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These functions were never exported and are not used internally anymore.
Maybe due to that, they became incorrect (e.g., they ignore expr_list)
so drop them altogether.

Fixes: 80077787f8f21 ("src: remove json support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/libnftnl/set.h |  4 ----
 src/set.c              | 39 ---------------------------------------
 src/set_elem.c         | 22 ----------------------
 3 files changed, 65 deletions(-)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index f2edca20f9e07..c21079f123984 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -42,8 +42,6 @@ struct nftnl_set;
 struct nftnl_set *nftnl_set_alloc(void);
 void nftnl_set_free(const struct nftnl_set *s);
 
-struct nftnl_set *nftnl_set_clone(const struct nftnl_set *set);
-
 bool nftnl_set_is_set(const struct nftnl_set *s, uint16_t attr);
 void nftnl_set_unset(struct nftnl_set *s, uint16_t attr);
 int nftnl_set_set(struct nftnl_set *s, uint16_t attr, const void *data) __attribute__((deprecated));
@@ -125,8 +123,6 @@ struct nftnl_set_elem;
 struct nftnl_set_elem *nftnl_set_elem_alloc(void);
 void nftnl_set_elem_free(struct nftnl_set_elem *s);
 
-struct nftnl_set_elem *nftnl_set_elem_clone(struct nftnl_set_elem *elem);
-
 void nftnl_set_elem_add(struct nftnl_set *s, struct nftnl_set_elem *elem);
 
 void nftnl_set_elem_unset(struct nftnl_set_elem *s, uint16_t attr);
diff --git a/src/set.c b/src/set.c
index 54674bca709fd..a017017e1fb6d 100644
--- a/src/set.c
+++ b/src/set.c
@@ -360,45 +360,6 @@ uint64_t nftnl_set_get_u64(const struct nftnl_set *s, uint16_t attr)
 	return val ? *val : 0;
 }
 
-struct nftnl_set *nftnl_set_clone(const struct nftnl_set *set)
-{
-	struct nftnl_set *newset;
-	struct nftnl_set_elem *elem, *newelem;
-
-	newset = nftnl_set_alloc();
-	if (newset == NULL)
-		return NULL;
-
-	memcpy(newset, set, sizeof(*set));
-
-	if (set->flags & (1 << NFTNL_SET_TABLE)) {
-		newset->table = strdup(set->table);
-		if (!newset->table)
-			goto err;
-	}
-	if (set->flags & (1 << NFTNL_SET_NAME)) {
-		newset->name = strdup(set->name);
-		if (!newset->name)
-			goto err;
-	}
-
-	INIT_LIST_HEAD(&newset->element_list);
-	list_for_each_entry(elem, &set->element_list, head) {
-		newelem = nftnl_set_elem_clone(elem);
-		if (newelem == NULL)
-			goto err;
-
-		list_add_tail(&newelem->head, &newset->element_list);
-	}
-
-	newset->type = NULL;
-
-	return newset;
-err:
-	nftnl_set_free(newset);
-	return NULL;
-}
-
 static void nftnl_set_nlmsg_build_desc_size_payload(struct nlmsghdr *nlh,
 						    struct nftnl_set *s)
 {
diff --git a/src/set_elem.c b/src/set_elem.c
index 3e0ab0cf50876..83c65ee33548d 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -292,28 +292,6 @@ uint64_t nftnl_set_elem_get_u64(struct nftnl_set_elem *s, uint16_t attr)
 	return val;
 }
 
-struct nftnl_set_elem *nftnl_set_elem_clone(struct nftnl_set_elem *elem)
-{
-	struct nftnl_set_elem *newelem;
-
-	newelem = nftnl_set_elem_alloc();
-	if (newelem == NULL)
-		return NULL;
-
-	memcpy(newelem, elem, sizeof(*elem));
-
-	if (elem->flags & (1 << NFTNL_SET_ELEM_CHAIN)) {
-		newelem->data.chain = strdup(elem->data.chain);
-		if (!newelem->data.chain)
-			goto err;
-	}
-
-	return newelem;
-err:
-	nftnl_set_elem_free(newelem);
-	return NULL;
-}
-
 EXPORT_SYMBOL(nftnl_set_elem_nlmsg_build_payload);
 void nftnl_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh,
 				      struct nftnl_set_elem *e)
-- 
2.51.0

