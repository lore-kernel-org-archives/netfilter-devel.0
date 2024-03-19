Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BAD1CAB2
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868355; cv=none; b=fk2IBw5ivrZ4Su2gIWSnhFxewaAbEVspN2IRSGDJzTYwwZDYV29b2QNLqJ4wUIfnSAI47aQuAcq3A4qT13xu9m1fq23+IRm0Y2k4f8zV8U7Q/SJxIVCKKQlXqZTXNY1/Xqi6/0y6SkjTH26nV3AN2yagdKmTiPrfiv7FwYl2L5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868355; c=relaxed/simple;
	bh=Wxd81wS0WC/FmtFY5/vqav0dVwlMZj25tNBI5IqqbLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quWttRygiC/WDaJpd5klZG6ItIVWsIZ0wqmNDtcfC82pLl3uCJZKhKRoLawegic3VM1JP/Gv0TtV00JigiXGdqQmT4C2rnJVhKmvR1+8mI0UHUtD7+938/FARe4+QTmOG68n8zbpVqZE2mfb+AsG7mUGqgmw33UcFCPDfG4uXgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=mqkTPfqk; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mqkTPfqk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=c5AdaJLBn4gd5mSFLpbQds1B5EMt2+mfJWR1LJx8cbQ=; b=mqkTPfqkWiBaUpna+iPsQoM5Ee
	Lf0TmdtwFzmHCjZVR9gZjvyrtXqAKMe03VNK2jvaYQhv+RSMMB3ZJHYGFEG2wTTcZ0I5ObJJMuY/t
	8KvAjSR0c0QQomWSeMVgr/ka5NulyhwAz7hqTU1b2rOZ0VPaPNOdUmmCwKj5nlFLEDkC4edI0jaqG
	9LfzJLC5TnWc+ULs8GL6A4zYQ/KDa6HmHnSLOk8jKJsb6EGepBT8fegs2/COKTZR2aZb1X06rKRu+
	wg3VACmsHzICtKtoJciQt+o8SD0+r9Ze/aKzuyBAedS/ObD7ATRMucEoIhcllK04I5qDc8B4PH4cr
	o2x/ifJQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0r-000000007g9-0hXQ;
	Tue, 19 Mar 2024 18:12:33 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 10/17] obj: Return value on setters
Date: Tue, 19 Mar 2024 18:12:17 +0100
Message-ID: <20240319171224.18064-11-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240319171224.18064-1-phil@nwl.cc>
References: <20240319171224.18064-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to other setters, let callers know if memory allocation fails.
Though return value with all setters, as all of them may be used to set
object type-specific attributes which may fail (e.g. if NFTNL_OBJ_TYPE
was not set before).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/libnftnl/object.h | 14 ++++++-------
 src/object.c              | 41 +++++++++++++++++++++++----------------
 2 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
index 4b2d90fbe0a4e..e235fdf3b4d45 100644
--- a/include/libnftnl/object.h
+++ b/include/libnftnl/object.h
@@ -123,14 +123,14 @@ void nftnl_obj_free(const struct nftnl_obj *ne);
 
 bool nftnl_obj_is_set(const struct nftnl_obj *ne, uint16_t attr);
 void nftnl_obj_unset(struct nftnl_obj *ne, uint16_t attr);
-void nftnl_obj_set_data(struct nftnl_obj *ne, uint16_t attr, const void *data,
-			uint32_t data_len);
+int nftnl_obj_set_data(struct nftnl_obj *ne, uint16_t attr, const void *data,
+		       uint32_t data_len);
 void nftnl_obj_set(struct nftnl_obj *ne, uint16_t attr, const void *data) __attribute__((deprecated));
-void nftnl_obj_set_u8(struct nftnl_obj *ne, uint16_t attr, uint8_t val);
-void nftnl_obj_set_u16(struct nftnl_obj *ne, uint16_t attr, uint16_t val);
-void nftnl_obj_set_u32(struct nftnl_obj *ne, uint16_t attr, uint32_t val);
-void nftnl_obj_set_u64(struct nftnl_obj *obj, uint16_t attr, uint64_t val);
-void nftnl_obj_set_str(struct nftnl_obj *ne, uint16_t attr, const char *str);
+int nftnl_obj_set_u8(struct nftnl_obj *ne, uint16_t attr, uint8_t val);
+int nftnl_obj_set_u16(struct nftnl_obj *ne, uint16_t attr, uint16_t val);
+int nftnl_obj_set_u32(struct nftnl_obj *ne, uint16_t attr, uint32_t val);
+int nftnl_obj_set_u64(struct nftnl_obj *obj, uint16_t attr, uint64_t val);
+int nftnl_obj_set_str(struct nftnl_obj *ne, uint16_t attr, const char *str);
 const void *nftnl_obj_get_data(const struct nftnl_obj *ne, uint16_t attr,
 			       uint32_t *data_len);
 const void *nftnl_obj_get(const struct nftnl_obj *ne, uint16_t attr);
diff --git a/src/object.c b/src/object.c
index b518a675c2fb0..d363725e10fb8 100644
--- a/src/object.c
+++ b/src/object.c
@@ -105,8 +105,8 @@ static uint32_t nftnl_obj_validate[NFTNL_OBJ_MAX + 1] = {
 };
 
 EXPORT_SYMBOL(nftnl_obj_set_data);
-void nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
-			const void *data, uint32_t data_len)
+int nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
+		       const void *data, uint32_t data_len)
 {
 	if (attr < NFTNL_OBJ_MAX)
 		nftnl_assert_validate(data, nftnl_obj_validate, attr, data_len);
@@ -115,15 +115,19 @@ void nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
 	case NFTNL_OBJ_TABLE:
 		xfree(obj->table);
 		obj->table = strdup(data);
+		if (!obj->table)
+			return -1;
 		break;
 	case NFTNL_OBJ_NAME:
 		xfree(obj->name);
 		obj->name = strdup(data);
+		if (!obj->name)
+			return -1;
 		break;
 	case NFTNL_OBJ_TYPE:
 		obj->ops = nftnl_obj_ops_lookup(*((uint32_t *)data));
 		if (!obj->ops)
-			return;
+			return -1;
 		break;
 	case NFTNL_OBJ_FAMILY:
 		memcpy(&obj->family, data, sizeof(obj->family));
@@ -140,16 +144,19 @@ void nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
 
 		obj->user.data = malloc(data_len);
 		if (!obj->user.data)
-			return;
+			return -1;
 		memcpy(obj->user.data, data, data_len);
 		obj->user.len = data_len;
 		break;
 	default:
-		if (obj->ops)
-			obj->ops->set(obj, attr, data, data_len);
-		break;
+		if (!obj->ops)
+			return -1;
+
+		if (obj->ops->set(obj, attr, data, data_len) < 0)
+			return -1;
 	}
 	obj->flags |= (1 << attr);
+	return 0;
 }
 
 void nftnl_obj_set(struct nftnl_obj *obj, uint16_t attr, const void *data) __visible;
@@ -159,33 +166,33 @@ void nftnl_obj_set(struct nftnl_obj *obj, uint16_t attr, const void *data)
 }
 
 EXPORT_SYMBOL(nftnl_obj_set_u8);
-void nftnl_obj_set_u8(struct nftnl_obj *obj, uint16_t attr, uint8_t val)
+int nftnl_obj_set_u8(struct nftnl_obj *obj, uint16_t attr, uint8_t val)
 {
-	nftnl_obj_set_data(obj, attr, &val, sizeof(uint8_t));
+	return nftnl_obj_set_data(obj, attr, &val, sizeof(uint8_t));
 }
 
 EXPORT_SYMBOL(nftnl_obj_set_u16);
-void nftnl_obj_set_u16(struct nftnl_obj *obj, uint16_t attr, uint16_t val)
+int nftnl_obj_set_u16(struct nftnl_obj *obj, uint16_t attr, uint16_t val)
 {
-	nftnl_obj_set_data(obj, attr, &val, sizeof(uint16_t));
+	return nftnl_obj_set_data(obj, attr, &val, sizeof(uint16_t));
 }
 
 EXPORT_SYMBOL(nftnl_obj_set_u32);
-void nftnl_obj_set_u32(struct nftnl_obj *obj, uint16_t attr, uint32_t val)
+int nftnl_obj_set_u32(struct nftnl_obj *obj, uint16_t attr, uint32_t val)
 {
-	nftnl_obj_set_data(obj, attr, &val, sizeof(uint32_t));
+	return nftnl_obj_set_data(obj, attr, &val, sizeof(uint32_t));
 }
 
 EXPORT_SYMBOL(nftnl_obj_set_u64);
-void nftnl_obj_set_u64(struct nftnl_obj *obj, uint16_t attr, uint64_t val)
+int nftnl_obj_set_u64(struct nftnl_obj *obj, uint16_t attr, uint64_t val)
 {
-	nftnl_obj_set_data(obj, attr, &val, sizeof(uint64_t));
+	return nftnl_obj_set_data(obj, attr, &val, sizeof(uint64_t));
 }
 
 EXPORT_SYMBOL(nftnl_obj_set_str);
-void nftnl_obj_set_str(struct nftnl_obj *obj, uint16_t attr, const char *str)
+int nftnl_obj_set_str(struct nftnl_obj *obj, uint16_t attr, const char *str)
 {
-	nftnl_obj_set_data(obj, attr, str, strlen(str) + 1);
+	return nftnl_obj_set_data(obj, attr, str, strlen(str) + 1);
 }
 
 EXPORT_SYMBOL(nftnl_obj_get_data);
-- 
2.43.0

