Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0C717333A
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 16:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729096952; cv=none; b=i6Zuk9RnSpyQq3YIIrOU/yMrxC7OhB/u8fO/70C2T9qVD205TYQj3PMadpUgum+UfLjzHYdjOPMxX8+Udqv5DFYs3HtkSlPo7XSlzYAd/tsVE+TNdyDbIR/4etpvCJc3wP7QMdbDHfwBPahRSNHQ17HHtQr1reX1EBnse65C6r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729096952; c=relaxed/simple;
	bh=V/UQrKGuhAIBMAO9bn0B5hV2KEsMuslq8KnhH+r/t4w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BMAAHmumBO3vo49geVnn773REFa16sEOg3WImqPwuAkxqLK7acBD8bW5YvcZu9jErLHIgGuRwYVCoZSOWGF8g7HTeD06B0mJmQmmqGDjeMYP7Mel8KqxiWh88kF8N5x4oka5dzA3TLwSK1Ec5o9nFR/jtd0AJgFTL4dAyou59Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=OeBUe60F; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="OeBUe60F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9SZEH0Vh1YdZ1AFRH/iwz52iKuRK+BRc56Z7c31YT1c=; b=OeBUe60F0yt7K7qQoeE1SMN66Z
	51u08zRGfBMHsTkyDMSZcyimc7XVnoMzjThN1DVfkmERcKkW+gwwEF2d2zVDjOIg6KAG76x9WrlgU
	UtxQGFvFkK3A43+P7WO0JvnIWZbTahdKVTCHwglrGZtv8OSgUz8MWAC/dSWW6C9fwquTshdvn0oc9
	wKvYzLBT2BV///9FHHAVT6yVUluXyQB6a8m+FvqNPyKk0K4wzopCz+JGu23l463KuOrfNPt5eHtdg
	+gJiQ9ZzEiNbNuUY36RofVfVUfqmiZRrJsi5U1bsPpkoNQ3DyXRCzBJT1PukipK8U1mtciNk2kBv1
	i0b9Ggpw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t176R-000000005zB-1uFW;
	Wed, 16 Oct 2024 18:42:27 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [libnftnl PATCH] src/utils: Add a common dev_array parser
Date: Wed, 16 Oct 2024 18:42:23 +0200
Message-ID: <20241016164223.21280-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Parsing of dev_array fields in flowtable and chain are identical, merge
them into a shared function nftnl_parse_devs() which does a quick scan
through the nested attributes to check validity and calculate required
array size instead of calling realloc() as needed.

This required to align structs nftnl_chain and nftnl_flowtable field
dev_array_len types, though uint32_t should match the size of int on
both 32 and 64 bit architectures.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/utils.h |  4 ++++
 src/chain.c     | 41 +++--------------------------------------
 src/flowtable.c | 40 ++--------------------------------------
 src/utils.c     | 39 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 48 insertions(+), 76 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index eed61277595e2..dd8fbd05213b0 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -82,4 +82,8 @@ int nftnl_fprintf(FILE *fpconst, const void *obj, uint32_t cmd, uint32_t type,
 int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
 		       uint16_t attr, const void *data, uint32_t data_len);
 
+struct nlattr;
+int nftnl_parse_devs(struct nlattr *nest,
+		     const char ***dev_array_p, uint32_t *len_p);
+
 #endif
diff --git a/src/chain.c b/src/chain.c
index 0b68939fe21a7..5bd2fc45b2137 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -38,7 +38,7 @@ struct nftnl_chain {
 	const char	*table;
 	const char	*dev;
 	const char	**dev_array;
-	int		dev_array_len;
+	uint32_t	dev_array_len;
 	uint32_t	family;
 	uint32_t	policy;
 	uint32_t	hooknum;
@@ -664,42 +664,6 @@ static int nftnl_chain_parse_hook_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
-static int nftnl_chain_parse_devs(struct nlattr *nest, struct nftnl_chain *c)
-{
-	const char **dev_array, **tmp;
-	int len = 0, size = 8;
-	struct nlattr *attr;
-
-	dev_array = calloc(8, sizeof(char *));
-	if (!dev_array)
-		return -1;
-
-	mnl_attr_for_each_nested(attr, nest) {
-		if (mnl_attr_get_type(attr) != NFTA_DEVICE_NAME)
-			goto err;
-		dev_array[len++] = strdup(mnl_attr_get_str(attr));
-		if (len >= size) {
-			tmp = realloc(dev_array, size * 2 * sizeof(char *));
-			if (!tmp)
-				goto err;
-
-			size *= 2;
-			memset(&tmp[len], 0, (size - len) * sizeof(char *));
-			dev_array = tmp;
-		}
-	}
-
-	c->dev_array = dev_array;
-	c->dev_array_len = len;
-
-	return 0;
-err:
-	while (len--)
-		xfree(dev_array[len]);
-	xfree(dev_array);
-	return -1;
-}
-
 static int nftnl_chain_parse_hook(struct nlattr *attr, struct nftnl_chain *c)
 {
 	struct nlattr *tb[NFTA_HOOK_MAX+1] = {};
@@ -723,7 +687,8 @@ static int nftnl_chain_parse_hook(struct nlattr *attr, struct nftnl_chain *c)
 		c->flags |= (1 << NFTNL_CHAIN_DEV);
 	}
 	if (tb[NFTA_HOOK_DEVS]) {
-		ret = nftnl_chain_parse_devs(tb[NFTA_HOOK_DEVS], c);
+		ret = nftnl_parse_devs(tb[NFTA_HOOK_DEVS],
+				       &c->dev_array, &c->dev_array_len);
 		if (ret < 0)
 			return -1;
 		c->flags |= (1 << NFTNL_CHAIN_DEVICES);
diff --git a/src/flowtable.c b/src/flowtable.c
index 41a1456bb19b2..d54b3627371ef 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -402,43 +402,6 @@ static int nftnl_flowtable_parse_hook_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
-static int nftnl_flowtable_parse_devs(struct nlattr *nest,
-				      struct nftnl_flowtable *c)
-{
-	const char **dev_array, **tmp;
-	int len = 0, size = 8;
-	struct nlattr *attr;
-
-	dev_array = calloc(8, sizeof(char *));
-	if (!dev_array)
-		return -1;
-
-	mnl_attr_for_each_nested(attr, nest) {
-		if (mnl_attr_get_type(attr) != NFTA_DEVICE_NAME)
-			goto err;
-		dev_array[len++] = strdup(mnl_attr_get_str(attr));
-		if (len >= size) {
-			tmp = realloc(dev_array, size * 2 * sizeof(char *));
-			if (!tmp)
-				goto err;
-
-			size *= 2;
-			memset(&tmp[len], 0, (size - len) * sizeof(char *));
-			dev_array = tmp;
-		}
-	}
-
-	c->dev_array = dev_array;
-	c->dev_array_len = len;
-
-	return 0;
-err:
-	while (len--)
-		xfree(dev_array[len]);
-	xfree(dev_array);
-	return -1;
-}
-
 static int nftnl_flowtable_parse_hook(struct nlattr *attr, struct nftnl_flowtable *c)
 {
 	struct nlattr *tb[NFTA_FLOWTABLE_HOOK_MAX + 1] = {};
@@ -456,7 +419,8 @@ static int nftnl_flowtable_parse_hook(struct nlattr *attr, struct nftnl_flowtabl
 		c->flags |= (1 << NFTNL_FLOWTABLE_PRIO);
 	}
 	if (tb[NFTA_FLOWTABLE_HOOK_DEVS]) {
-		ret = nftnl_flowtable_parse_devs(tb[NFTA_FLOWTABLE_HOOK_DEVS], c);
+		ret = nftnl_parse_devs(tb[NFTA_FLOWTABLE_HOOK_DEVS],
+				       &c->dev_array, &c->dev_array_len);
 		if (ret < 0)
 			return -1;
 		c->flags |= (1 << NFTNL_FLOWTABLE_DEVICES);
diff --git a/src/utils.c b/src/utils.c
index 2f1ffd6227583..9235806b2c95e 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -19,6 +19,7 @@
 
 #include <libnftnl/common.h>
 
+#include <libmnl/libmnl.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 
@@ -150,3 +151,41 @@ int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
 	*flags |= (1 << attr);
 	return 0;
 }
+
+int nftnl_parse_devs(struct nlattr *nest,
+		     const char ***dev_array_p, uint32_t *len_p)
+{
+	struct nlattr *attr;
+	const char *dup;
+	int len = 0;
+
+	mnl_attr_for_each_nested(attr, nest) {
+		if (mnl_attr_get_type(attr) != NFTA_DEVICE_NAME)
+			return -1;
+		len++;
+	}
+
+	if (dev_array_p) {
+		*dev_array_p = calloc(len, sizeof(char *));
+		if (!*dev_array_p)
+			return -1;
+
+		len = 0;
+		mnl_attr_for_each_nested(attr, nest) {
+			dup = strdup(mnl_attr_get_str(attr));
+			if (!dup)
+				goto err_free;
+
+			(*dev_array_p)[len++] = dup;
+		}
+	}
+	if (len_p)
+		*len_p = len;
+
+	return 0;
+err_free:
+	while (len--)
+		xfree((*dev_array_p)[len]);
+	xfree(*dev_array_p);
+	return -1;
+}
-- 
2.47.0

