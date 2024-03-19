Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB29818AE4
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868354; cv=none; b=SHcgaQcMmdWc2PH7TneQPSJOfgS5RCbY9+2W0o0M/NootYb7JsUFBQ99nBmafpQZzihaVBq/7uT0YzlTtY+NGRb0R4/3InVM4Pxz2mrsafpnFw8kLGFa9uiBYyVzm5UGIwmW4TZJC/4sb4K5kdDGC/GS4orbll/pG3eA08nhttw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868354; c=relaxed/simple;
	bh=K6BhCarnA7grzJf3VqlUjJHLUv6I0JNh1T2W4rnxUdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQXNxbRHaPATWwG5sYsx5tpcp0qO1QUgdzSJd3TSjfRDWDAei1QauxpaU6d37G3DyIoQK+Pyb1etExsRoddoC7QvIAxjVMMGV0trRGzZL3GECMdAYUAebzr4ycS4ctyELNqq4AyCNHwv9S3DkRr2ptFHHQJDMrw+KfOEZi9Nc7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aErB5ve+; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aErB5ve+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Zph+M0lbEAcqWDaa9tzEehB3w1TKtCZgF5SQP8gjMGU=; b=aErB5ve+ExnHLxWRi8v0C//+nA
	zinKAfrnJrF57l3w/HcKJMcxtJ/g0qwFnJR5ujuhckvnSG9GHVmn5/bQfuSpU7Oh+0oqYoe4uXVtv
	GCuhfjld38KBRtJtQjHLro8X1DpMt7c+5hewSQ1wouYanOcD/d6R6K9SybhUkcjsczomst4WKDPoA
	1XaBy+z/jGoCW6xBORcA+zaxTMtzkp8lu/h6cMCTSlLJt1iINsZjoE82TijrusLWLLC1g7SWVtFKU
	dZzx0JQflPWG44qoeKQCkHXKyLskUnSMuWKta02jk38qYT8wLtA1oLSF5ybN8vNFWFzdaeJKSZIKC
	qsA7ZKHw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0p-000000007fr-090b;
	Tue, 19 Mar 2024 18:12:31 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 15/17] utils: Introduce and use nftnl_set_str_attr()
Date: Tue, 19 Mar 2024 18:12:22 +0100
Message-ID: <20240319171224.18064-16-phil@nwl.cc>
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

The function consolidates the necessary code when assigning to string
pointer attributes, namely:

* Conditional free of the previous value
* Allocation of new value
* Checking for memory allocation errors
* Setting respective flag bit

A new feature previously missing in all call sites is respecting
data_len in case the buffer up to that point did not contain a NUL-char.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/chain.c     | 36 ++++++++----------------------------
 src/flowtable.c | 17 ++++-------------
 src/object.c    | 13 ++++---------
 src/rule.c      | 18 ++++--------------
 src/set.c       | 18 ++++--------------
 src/table.c     |  9 ++-------
 src/utils.c     | 14 ++++++++++++++
 7 files changed, 40 insertions(+), 85 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index e0b1eaf6d73bc..c7026f486b104 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -217,21 +217,11 @@ int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 
 	switch(attr) {
 	case NFTNL_CHAIN_NAME:
-		if (c->flags & (1 << NFTNL_CHAIN_NAME))
-			xfree(c->name);
-
-		c->name = strdup(data);
-		if (!c->name)
-			return -1;
-		break;
+		return nftnl_set_str_attr(&c->name, &c->flags,
+					  attr, data, data_len);
 	case NFTNL_CHAIN_TABLE:
-		if (c->flags & (1 << NFTNL_CHAIN_TABLE))
-			xfree(c->table);
-
-		c->table = strdup(data);
-		if (!c->table)
-			return -1;
-		break;
+		return nftnl_set_str_attr(&c->table, &c->flags,
+					  attr, data, data_len);
 	case NFTNL_CHAIN_HOOKNUM:
 		memcpy(&c->hooknum, data, sizeof(c->hooknum));
 		break;
@@ -257,21 +247,11 @@ int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 		memcpy(&c->family, data, sizeof(c->family));
 		break;
 	case NFTNL_CHAIN_TYPE:
-		if (c->flags & (1 << NFTNL_CHAIN_TYPE))
-			xfree(c->type);
-
-		c->type = strdup(data);
-		if (!c->type)
-			return -1;
-		break;
+		return nftnl_set_str_attr(&c->type, &c->flags,
+					  attr, data, data_len);
 	case NFTNL_CHAIN_DEV:
-		if (c->flags & (1 << NFTNL_CHAIN_DEV))
-			xfree(c->dev);
-
-		c->dev = strdup(data);
-		if (!c->dev)
-			return -1;
-		break;
+		return nftnl_set_str_attr(&c->dev, &c->flags,
+					  attr, data, data_len);
 	case NFTNL_CHAIN_DEVICES:
 		dev_array = (const char **)data;
 		while (dev_array[len] != NULL)
diff --git a/src/flowtable.c b/src/flowtable.c
index 2f37cd4c7f04a..41a1456bb19b2 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -119,20 +119,11 @@ int nftnl_flowtable_set_data(struct nftnl_flowtable *c, uint16_t attr,
 
 	switch(attr) {
 	case NFTNL_FLOWTABLE_NAME:
-		if (c->flags & (1 << NFTNL_FLOWTABLE_NAME))
-			xfree(c->name);
-
-		c->name = strdup(data);
-		if (!c->name)
-			return -1;
-		break;
+		return nftnl_set_str_attr(&c->name, &c->flags,
+					  attr, data, data_len);
 	case NFTNL_FLOWTABLE_TABLE:
-		if (c->flags & (1 << NFTNL_FLOWTABLE_TABLE))
-			xfree(c->table);
-
-		c->table = strdup(data);
-		if (!c->table)
-			return -1;
+		return nftnl_set_str_attr(&c->table, &c->flags,
+					  attr, data, data_len);
 		break;
 	case NFTNL_FLOWTABLE_HOOKNUM:
 		memcpy(&c->hooknum, data, sizeof(c->hooknum));
diff --git a/src/object.c b/src/object.c
index 2ddaa29cda0be..19cb7d0dbf73d 100644
--- a/src/object.c
+++ b/src/object.c
@@ -113,17 +113,12 @@ int nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
 
 	switch (attr) {
 	case NFTNL_OBJ_TABLE:
-		xfree(obj->table);
-		obj->table = strdup(data);
-		if (!obj->table)
-			return -1;
+		return nftnl_set_str_attr(&obj->table, &obj->flags,
+					  attr, data, data_len);
 		break;
 	case NFTNL_OBJ_NAME:
-		xfree(obj->name);
-		obj->name = strdup(data);
-		if (!obj->name)
-			return -1;
-		break;
+		return nftnl_set_str_attr(&obj->name, &obj->flags,
+					  attr, data, data_len);
 	case NFTNL_OBJ_TYPE:
 		obj->ops = nftnl_obj_ops_lookup(*((uint32_t *)data));
 		if (!obj->ops)
diff --git a/src/rule.c b/src/rule.c
index a52012b2177bb..e16e2c1aa5bf8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -115,21 +115,11 @@ int nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
 
 	switch(attr) {
 	case NFTNL_RULE_TABLE:
-		if (r->flags & (1 << NFTNL_RULE_TABLE))
-			xfree(r->table);
-
-		r->table = strdup(data);
-		if (!r->table)
-			return -1;
-		break;
+		return nftnl_set_str_attr(&r->table, &r->flags,
+					  attr, data, data_len);
 	case NFTNL_RULE_CHAIN:
-		if (r->flags & (1 << NFTNL_RULE_CHAIN))
-			xfree(r->chain);
-
-		r->chain = strdup(data);
-		if (!r->chain)
-			return -1;
-		break;
+		return nftnl_set_str_attr(&r->chain, &r->flags,
+					  attr, data, data_len);
 	case NFTNL_RULE_HANDLE:
 		memcpy(&r->handle, data, sizeof(r->handle));
 		break;
diff --git a/src/set.c b/src/set.c
index a732bc032267a..07e332dcd6732 100644
--- a/src/set.c
+++ b/src/set.c
@@ -146,21 +146,11 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 
 	switch(attr) {
 	case NFTNL_SET_TABLE:
-		if (s->flags & (1 << NFTNL_SET_TABLE))
-			xfree(s->table);
-
-		s->table = strdup(data);
-		if (!s->table)
-			return -1;
-		break;
+		return nftnl_set_str_attr(&s->table, &s->flags,
+					  attr, data, data_len);
 	case NFTNL_SET_NAME:
-		if (s->flags & (1 << NFTNL_SET_NAME))
-			xfree(s->name);
-
-		s->name = strdup(data);
-		if (!s->name)
-			return -1;
-		break;
+		return nftnl_set_str_attr(&s->name, &s->flags,
+					  attr, data, data_len);
 	case NFTNL_SET_HANDLE:
 		memcpy(&s->handle, data, sizeof(s->handle));
 		break;
diff --git a/src/table.c b/src/table.c
index 4f48e8c9e73e1..13f01cfbf1e6f 100644
--- a/src/table.c
+++ b/src/table.c
@@ -101,13 +101,8 @@ int nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
 
 	switch (attr) {
 	case NFTNL_TABLE_NAME:
-		if (t->flags & (1 << NFTNL_TABLE_NAME))
-			xfree(t->name);
-
-		t->name = strdup(data);
-		if (!t->name)
-			return -1;
-		break;
+		return nftnl_set_str_attr(&t->name, &t->flags,
+					  attr, data, data_len);
 	case NFTNL_TABLE_HANDLE:
 		memcpy(&t->handle, data, sizeof(t->handle));
 		break;
diff --git a/src/utils.c b/src/utils.c
index ffbad89a0dade..2f1ffd6227583 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -136,3 +136,17 @@ void __noreturn __abi_breakage(const char *file, int line, const char *reason)
 		       "%s:%d reason: %s\n", file, line, reason);
        exit(EXIT_FAILURE);
 }
+
+int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
+		       uint16_t attr, const void *data, uint32_t data_len)
+{
+	if (*flags & (1 << attr))
+		xfree(*dptr);
+
+	*dptr = strndup(data, data_len);
+	if (!*dptr)
+		return -1;
+
+	*flags |= (1 << attr);
+	return 0;
+}
-- 
2.43.0

