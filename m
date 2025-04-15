Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7155220DF4
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 17:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.252.153.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744739826; cv=none; b=VeuRWHqQQsWGodxyjgGwk4XGcb+SxY3XZ/I9nXyGZl1oyWbF4FI2fV/BKYdGEIBb0NXSaRsk02ZJbW9Dkda2Q3iwJ36FAYUPVxa2cV0KjZZaBjbcHHb5hkdmFpdJaOpeUOqAvpnixN8rAeeKtpIb1l7cUiXOBO9eczTCvihfNVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744739826; c=relaxed/simple;
	bh=jDuuepAtwx4CUf+yzSquyhgI+hE0PwWySiyQ63JneKo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h+HIbCuSPVvis8KmtlIAI6MMaUWScwB3kYDyWxz0kHl/HnMp98EneKFJPmveLkQV+3UgJuA1KEuFI6np97aGS/3PTffI6L/cE4EJqkg3z2AZe/8/jOG4iBkzRWvwUHAfWYGmd6lL9Yu6+z4AahUpR8HYwpFA3Nf73JwOCznSdxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net; spf=pass smtp.mailfrom=riseup.net; dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b=pyquptUc; arc=none smtp.client-ip=198.252.153.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riseup.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="pyquptUc"
Received: from fews02-sea.riseup.net (fews02-sea-pn.riseup.net [10.0.1.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx1.riseup.net (Postfix) with ESMTPS id 4ZcX0p4xWSzDqkY;
	Tue, 15 Apr 2025 17:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
	t=1744739818; bh=jDuuepAtwx4CUf+yzSquyhgI+hE0PwWySiyQ63JneKo=;
	h=From:To:Cc:Subject:Date:From;
	b=pyquptUcqzdeypBnTvaxLFDVyj+n9DRe2GkGuPIByuoAnHzk/Mspq5xhKsgraYXs2
	 Qd1hYBZp1TgCnuBmbsh/8cpBwb/MnQqwURD02/ucSLQRXO8JkFTkyayvTCKFR2Ju+0
	 exiO1Hmr3+XaWM0rkE6Gxz6qu5OV2bsttiHc+wKE=
X-Riseup-User-ID: 06F3669B98B2B359C9E4CBC41239850F3A85EFFA382378B83FA0ABBA04E2E938
Received: from [127.0.0.1] (localhost [127.0.0.1])
	 by fews02-sea.riseup.net (Postfix) with ESMTPSA id 4ZcX0n44nvzFwq9;
	Tue, 15 Apr 2025 17:56:57 +0000 (UTC)
From: Fernando Fernandez Mancera <ffmancera@riseup.net>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 1/2 libnftnl] src: use uint64_t for flags fields
Date: Tue, 15 Apr 2025 19:56:42 +0200
Message-ID: <20250415175643.4060-1-ffmancera@riseup.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The flags for the object tunnel already reach out 31, therefore, in
order to be able to extend the flags field must be uint64_t. Otherwise,
we will shift by more of the type size.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/obj.h   |  2 +-
 include/rule.h  |  2 +-
 include/set.h   |  2 +-
 include/utils.h |  2 +-
 src/chain.c     |  2 +-
 src/flowtable.c |  2 +-
 src/object.c    | 10 +++++-----
 src/table.c     |  2 +-
 src/utils.c     |  2 +-
 9 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/obj.h b/include/obj.h
index d217737..fc78e2a 100644
--- a/include/obj.h
+++ b/include/obj.h
@@ -19,7 +19,7 @@ struct nftnl_obj {
 	uint32_t		family;
 	uint32_t		use;
 
-	uint32_t		flags;
+	uint64_t		flags;
 	uint64_t		handle;
 
 	struct {
diff --git a/include/rule.h b/include/rule.h
index 036c722..6432786 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -4,7 +4,7 @@
 struct nftnl_rule {
 	struct list_head head;
 
-	uint32_t	flags;
+	uint64_t	flags;
 	uint32_t	family;
 	const char	*table;
 	const char	*chain;
diff --git a/include/set.h b/include/set.h
index 55018b6..179f6ad 100644
--- a/include/set.h
+++ b/include/set.h
@@ -30,7 +30,7 @@ struct nftnl_set {
 	} desc;
 	struct list_head	element_list;
 
-	uint32_t		flags;
+	uint64_t		flags;
 	uint32_t		gc_interval;
 	uint64_t		timeout;
 	struct list_head	expr_list;
diff --git a/include/utils.h b/include/utils.h
index eed6127..5da2ddb 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -79,7 +79,7 @@ int nftnl_fprintf(FILE *fpconst, const void *obj, uint32_t cmd, uint32_t type,
 			  	     uint32_t cmd, uint32_t type,
 				     uint32_t flags));
 
-int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
+int nftnl_set_str_attr(const char **dptr, uint64_t *flags,
 		       uint16_t attr, const void *data, uint32_t data_len);
 
 #endif
diff --git a/src/chain.c b/src/chain.c
index 895108c..a9e18dc 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -43,7 +43,7 @@ struct nftnl_chain {
 	uint64_t	packets;
 	uint64_t	bytes;
 	uint64_t	handle;
-	uint32_t	flags;
+	uint64_t	flags;
 	uint32_t	chain_id;
 
 	struct {
diff --git a/src/flowtable.c b/src/flowtable.c
index fbbe0a8..c52ba0e 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -29,7 +29,7 @@ struct nftnl_flowtable {
 	struct nftnl_str_array	dev_array;
 	uint32_t		ft_flags;
 	uint32_t		use;
-	uint32_t		flags;
+	uint64_t		flags;
 	uint64_t		handle;
 };
 
diff --git a/src/object.c b/src/object.c
index bfcceb9..f307815 100644
--- a/src/object.c
+++ b/src/object.c
@@ -62,13 +62,13 @@ void nftnl_obj_free(const struct nftnl_obj *obj)
 EXPORT_SYMBOL(nftnl_obj_is_set);
 bool nftnl_obj_is_set(const struct nftnl_obj *obj, uint16_t attr)
 {
-	return obj->flags & (1 << attr);
+	return obj->flags & (1ULL << attr);
 }
 
 EXPORT_SYMBOL(nftnl_obj_unset);
 void nftnl_obj_unset(struct nftnl_obj *obj, uint16_t attr)
 {
-	if (!(obj->flags & (1 << attr)))
+	if (!(obj->flags & (1ULL << attr)))
 		return;
 
 	switch (attr) {
@@ -90,7 +90,7 @@ void nftnl_obj_unset(struct nftnl_obj *obj, uint16_t attr)
 		break;
 	}
 
-	obj->flags &= ~(1 << attr);
+	obj->flags &= ~(1ULL << attr);
 }
 
 static uint32_t nftnl_obj_validate[NFTNL_OBJ_MAX + 1] = {
@@ -153,7 +153,7 @@ int nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
 		if (obj->ops->set(obj, attr, data, data_len) < 0)
 			return -1;
 	}
-	obj->flags |= (1 << attr);
+	obj->flags |= (1ULL << attr);
 	return 0;
 }
 
@@ -197,7 +197,7 @@ EXPORT_SYMBOL(nftnl_obj_get_data);
 const void *nftnl_obj_get_data(const struct nftnl_obj *obj, uint16_t attr,
 			       uint32_t *data_len)
 {
-	if (!(obj->flags & (1 << attr)))
+	if (!(obj->flags & (1ULL << attr)))
 		return NULL;
 
 	switch(attr) {
diff --git a/src/table.c b/src/table.c
index 9870dca..e183e2e 100644
--- a/src/table.c
+++ b/src/table.c
@@ -29,7 +29,7 @@ struct nftnl_table {
 	uint32_t	table_flags;
 	uint64_t 	handle;
 	uint32_t	use;
-	uint32_t	flags;
+	uint64_t	flags;
 	uint32_t	owner;
 	struct {
 		void		*data;
diff --git a/src/utils.c b/src/utils.c
index 5f2c5bf..7942d67 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -133,7 +133,7 @@ void __noreturn __abi_breakage(const char *file, int line, const char *reason)
        exit(EXIT_FAILURE);
 }
 
-int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
+int nftnl_set_str_attr(const char **dptr, uint64_t *flags,
 		       uint16_t attr, const void *data, uint32_t data_len)
 {
 	if (*flags & (1 << attr))
-- 
2.49.0

