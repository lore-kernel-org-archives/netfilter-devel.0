Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06322154BE0
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2024 20:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729714885; cv=none; b=mgj3flh4TcvfTrfcrlMXMTFHG3fbaiBAtQxtLhrKJTzEzDhyKIMj6miCsp54jxFXFOjCBdbyRsdKzg8zPxi254bdjkFjsyMzjnrGhpuzWbSr1H62cOZr0ua5GDsTtvOE8A82ns0ErMGvtFJh+GUqeGfR6oOYKpxEQSX5Ui94I/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729714885; c=relaxed/simple;
	bh=Eh5bHU9TfcgJ+rEGqlJ/PZLRhXV+pxaV7Ma75vd2aTg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EfUBBYb5jBFo47dQxkGoe5jzYgzieTxsvfm3tyDAU/FxGkF600PV18tTlKRMlTNVkj7ZL+1YgBWd9BfA3l50TzDUhaFW0SqLMvKIgJMi0DGrBJG8qGO3BUDRCxip+bdxMKN01hXbjDaGxP7kx5IfgjDlEO2GZrPQDF4FRytoVDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=B/ubpft2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="B/ubpft2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7EtdqkRn5q2tXPp8ndd362g9TwcJGeDFmF4woZj3zlk=; b=B/ubpft2ushnEnbUPJ8uubi1Ae
	uZRfxX12R+tISso28maIGY9hPu0hbLChWatNKHjEJd3c+leSfd6tSyiHwwlCxBaOHxcyDU5oV3tvA
	voNgTIU81HsSrwIHkZ6HySL0ogyx0TAaX+i3E8ej2kTW9PY2xNOMYhdAp4u+BpVM+rFc9xsfw6lYy
	xzc/v1ax/L+njk548PtjgqYNzGHCXulxGx5uQAs3GBxDYiQEia7Doe8wNSX5n86r3qfIvZPgWH/8G
	s6kxdu45M3L37+zYpX5Xq4ZH7elrr12+bC8R9+e4udmmj4SybCZudbVAsQBJfl487Jf+0VbpKaAHF
	XGLHTcxg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t3hr7-000000000zt-0pP1;
	Wed, 23 Oct 2024 22:21:21 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [libnftnl PATCH v2] Introduce struct nftnl_str_array
Date: Wed, 23 Oct 2024 22:21:04 +0200
Message-ID: <20241023202119.27681-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This data structure holds an array of allocated strings for use in
nftnl_chain and nftnl_flowtable structs. For convenience, implement
functions to clear, populate and iterate over contents.

While at it, extend chain and flowtable tests to cover these attributes,
too.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Add missing src/str_array.c
---
 include/internal.h         |  1 +
 src/Makefile.am            |  1 +
 src/chain.c                | 90 ++++++------------------------------
 src/flowtable.c            | 94 ++++++--------------------------------
 src/str_array.c            | 69 ++++++++++++++++++++++++++++
 src/utils.c                |  1 +
 tests/nft-chain-test.c     | 37 ++++++++++++++-
 tests/nft-flowtable-test.c | 21 +++++++++
 8 files changed, 155 insertions(+), 159 deletions(-)
 create mode 100644 src/str_array.c

diff --git a/include/internal.h b/include/internal.h
index 1f96731589c04..b8fc7f129c76e 100644
--- a/include/internal.h
+++ b/include/internal.h
@@ -12,5 +12,6 @@
 #include "expr.h"
 #include "expr_ops.h"
 #include "rule.h"
+#include "str_array.h"
 
 #endif /* _LIBNFTNL_INTERNAL_H_ */
diff --git a/src/Makefile.am b/src/Makefile.am
index 3cd259c04d1c3..1c38d00c4e180 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -17,6 +17,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      rule.c		\
 		      set.c		\
 		      set_elem.c	\
+		      str_array.c	\
 		      ruleset.c		\
 		      udata.c		\
 		      expr.c		\
diff --git a/src/chain.c b/src/chain.c
index 0b68939fe21a7..c9fbc3a87314b 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -37,8 +37,7 @@ struct nftnl_chain {
 	const char	*type;
 	const char	*table;
 	const char	*dev;
-	const char	**dev_array;
-	int		dev_array_len;
+	struct nftnl_str_array	dev_array;
 	uint32_t	family;
 	uint32_t	policy;
 	uint32_t	hooknum;
@@ -117,7 +116,6 @@ EXPORT_SYMBOL(nftnl_chain_free);
 void nftnl_chain_free(const struct nftnl_chain *c)
 {
 	struct nftnl_rule *r, *tmp;
-	int i;
 
 	list_for_each_entry_safe(r, tmp, &c->rule_list, head)
 		nftnl_rule_free(r);
@@ -132,12 +130,8 @@ void nftnl_chain_free(const struct nftnl_chain *c)
 		xfree(c->dev);
 	if (c->flags & (1 << NFTNL_CHAIN_USERDATA))
 		xfree(c->user.data);
-	if (c->flags & (1 << NFTNL_CHAIN_DEVICES)) {
-		for (i = 0; i < c->dev_array_len; i++)
-			xfree(c->dev_array[i]);
-
-		xfree(c->dev_array);
-	}
+	if (c->flags & (1 << NFTNL_CHAIN_DEVICES))
+		nftnl_str_array_clear((struct nftnl_str_array *)&c->dev_array);
 	xfree(c);
 }
 
@@ -150,8 +144,6 @@ bool nftnl_chain_is_set(const struct nftnl_chain *c, uint16_t attr)
 EXPORT_SYMBOL(nftnl_chain_unset);
 void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr)
 {
-	int i;
-
 	if (!(c->flags & (1 << attr)))
 		return;
 
@@ -181,9 +173,7 @@ void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr)
 		xfree(c->dev);
 		break;
 	case NFTNL_CHAIN_DEVICES:
-		for (i = 0; i < c->dev_array_len; i++)
-			xfree(c->dev_array[i]);
-		xfree(c->dev_array);
+		nftnl_str_array_clear(&c->dev_array);
 		break;
 	case NFTNL_CHAIN_USERDATA:
 		xfree(c->user.data);
@@ -212,9 +202,6 @@ EXPORT_SYMBOL(nftnl_chain_set_data);
 int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 			 const void *data, uint32_t data_len)
 {
-	const char **dev_array;
-	int len = 0, i;
-
 	nftnl_assert_attr_exists(attr, NFTNL_CHAIN_MAX);
 	nftnl_assert_validate(data, nftnl_chain_validate, attr, data_len);
 
@@ -256,24 +243,8 @@ int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 		return nftnl_set_str_attr(&c->dev, &c->flags,
 					  attr, data, data_len);
 	case NFTNL_CHAIN_DEVICES:
-		dev_array = (const char **)data;
-		while (dev_array[len] != NULL)
-			len++;
-
-		if (c->flags & (1 << NFTNL_CHAIN_DEVICES)) {
-			for (i = 0; i < c->dev_array_len; i++)
-				xfree(c->dev_array[i]);
-			xfree(c->dev_array);
-		}
-
-		c->dev_array = calloc(len + 1, sizeof(char *));
-		if (!c->dev_array)
+		if (nftnl_str_array_set(&c->dev_array, data) < 0)
 			return -1;
-
-		for (i = 0; i < len; i++)
-			c->dev_array[i] = strdup(dev_array[i]);
-
-		c->dev_array_len = len;
 		break;
 	case NFTNL_CHAIN_FLAGS:
 		memcpy(&c->chain_flags, data, sizeof(c->chain_flags));
@@ -385,7 +356,7 @@ const void *nftnl_chain_get_data(const struct nftnl_chain *c, uint16_t attr,
 		return c->dev;
 	case NFTNL_CHAIN_DEVICES:
 		*data_len = 0;
-		return &c->dev_array[0];
+		return c->dev_array.array;
 	case NFTNL_CHAIN_FLAGS:
 		*data_len = sizeof(uint32_t);
 		return &c->chain_flags;
@@ -493,11 +464,11 @@ void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_ch
 		mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, c->dev);
 	else if (c->flags & (1 << NFTNL_CHAIN_DEVICES)) {
 		struct nlattr *nest_dev;
+		const char *dev;
 
 		nest_dev = mnl_attr_nest_start(nlh, NFTA_HOOK_DEVS);
-		for (i = 0; i < c->dev_array_len; i++)
-			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME,
-					  c->dev_array[i]);
+		nftnl_str_array_foreach(dev, &c->dev_array, i)
+			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev);
 		mnl_attr_nest_end(nlh, nest_dev);
 	}
 
@@ -664,42 +635,6 @@ static int nftnl_chain_parse_hook_cb(const struct nlattr *attr, void *data)
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
@@ -723,7 +658,7 @@ static int nftnl_chain_parse_hook(struct nlattr *attr, struct nftnl_chain *c)
 		c->flags |= (1 << NFTNL_CHAIN_DEV);
 	}
 	if (tb[NFTA_HOOK_DEVS]) {
-		ret = nftnl_chain_parse_devs(tb[NFTA_HOOK_DEVS], c);
+		ret = nftnl_parse_devs(&c->dev_array, tb[NFTA_HOOK_DEVS]);
 		if (ret < 0)
 			return -1;
 		c->flags |= (1 << NFTNL_CHAIN_DEVICES);
@@ -823,6 +758,7 @@ static int nftnl_chain_snprintf_default(char *buf, size_t remain,
 					const struct nftnl_chain *c)
 {
 	int ret, offset = 0, i;
+	const char *dev;
 
 	ret = snprintf(buf, remain, "%s %s %s use %u",
 		       nftnl_family2str(c->family), c->table, c->name, c->use);
@@ -854,9 +790,9 @@ static int nftnl_chain_snprintf_default(char *buf, size_t remain,
 			ret = snprintf(buf + offset, remain, " dev { ");
 			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-			for (i = 0; i < c->dev_array_len; i++) {
+			nftnl_str_array_foreach(dev, &c->dev_array, i) {
 				ret = snprintf(buf + offset, remain, " %s ",
-					       c->dev_array[i]);
+					       dev);
 				SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 			}
 			ret = snprintf(buf + offset, remain, " } ");
diff --git a/src/flowtable.c b/src/flowtable.c
index 41a1456bb19b2..2a8d374541b0b 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -26,8 +26,7 @@ struct nftnl_flowtable {
 	uint32_t		hooknum;
 	int32_t			prio;
 	uint32_t		size;
-	const char		**dev_array;
-	uint32_t		dev_array_len;
+	struct nftnl_str_array	dev_array;
 	uint32_t		ft_flags;
 	uint32_t		use;
 	uint32_t		flags;
@@ -43,18 +42,12 @@ struct nftnl_flowtable *nftnl_flowtable_alloc(void)
 EXPORT_SYMBOL(nftnl_flowtable_free);
 void nftnl_flowtable_free(const struct nftnl_flowtable *c)
 {
-	int i;
-
 	if (c->flags & (1 << NFTNL_FLOWTABLE_NAME))
 		xfree(c->name);
 	if (c->flags & (1 << NFTNL_FLOWTABLE_TABLE))
 		xfree(c->table);
-	if (c->flags & (1 << NFTNL_FLOWTABLE_DEVICES)) {
-		for (i = 0; i < c->dev_array_len; i++)
-			xfree(c->dev_array[i]);
-
-		xfree(c->dev_array);
-	}
+	if (c->flags & (1 << NFTNL_FLOWTABLE_DEVICES))
+		nftnl_str_array_clear((struct nftnl_str_array *)&c->dev_array);
 	xfree(c);
 }
 
@@ -67,8 +60,6 @@ bool nftnl_flowtable_is_set(const struct nftnl_flowtable *c, uint16_t attr)
 EXPORT_SYMBOL(nftnl_flowtable_unset);
 void nftnl_flowtable_unset(struct nftnl_flowtable *c, uint16_t attr)
 {
-	int i;
-
 	if (!(c->flags & (1 << attr)))
 		return;
 
@@ -87,9 +78,7 @@ void nftnl_flowtable_unset(struct nftnl_flowtable *c, uint16_t attr)
 	case NFTNL_FLOWTABLE_HANDLE:
 		break;
 	case NFTNL_FLOWTABLE_DEVICES:
-		for (i = 0; i < c->dev_array_len; i++)
-			xfree(c->dev_array[i]);
-		xfree(c->dev_array);
+		nftnl_str_array_clear(&c->dev_array);
 		break;
 	default:
 		return;
@@ -111,9 +100,6 @@ EXPORT_SYMBOL(nftnl_flowtable_set_data);
 int nftnl_flowtable_set_data(struct nftnl_flowtable *c, uint16_t attr,
 			     const void *data, uint32_t data_len)
 {
-	const char **dev_array;
-	int len = 0, i;
-
 	nftnl_assert_attr_exists(attr, NFTNL_FLOWTABLE_MAX);
 	nftnl_assert_validate(data, nftnl_flowtable_validate, attr, data_len);
 
@@ -135,24 +121,8 @@ int nftnl_flowtable_set_data(struct nftnl_flowtable *c, uint16_t attr,
 		memcpy(&c->family, data, sizeof(c->family));
 		break;
 	case NFTNL_FLOWTABLE_DEVICES:
-		dev_array = (const char **)data;
-		while (dev_array[len] != NULL)
-			len++;
-
-		if (c->flags & (1 << NFTNL_FLOWTABLE_DEVICES)) {
-			for (i = 0; i < c->dev_array_len; i++)
-				xfree(c->dev_array[i]);
-			xfree(c->dev_array);
-		}
-
-		c->dev_array = calloc(len + 1, sizeof(char *));
-		if (!c->dev_array)
+		if (nftnl_str_array_set(&c->dev_array, data) < 0)
 			return -1;
-
-		for (i = 0; i < len; i++)
-			c->dev_array[i] = strdup(dev_array[i]);
-
-		c->dev_array_len = len;
 		break;
 	case NFTNL_FLOWTABLE_SIZE:
 		memcpy(&c->size, data, sizeof(c->size));
@@ -230,7 +200,7 @@ const void *nftnl_flowtable_get_data(const struct nftnl_flowtable *c,
 		return &c->family;
 	case NFTNL_FLOWTABLE_DEVICES:
 		*data_len = 0;
-		return &c->dev_array[0];
+		return c->dev_array.array;
 	case NFTNL_FLOWTABLE_SIZE:
 		*data_len = sizeof(int32_t);
 		return &c->size;
@@ -325,12 +295,11 @@ void nftnl_flowtable_nlmsg_build_payload(struct nlmsghdr *nlh,
 
 	if (c->flags & (1 << NFTNL_FLOWTABLE_DEVICES)) {
 		struct nlattr *nest_dev;
+		const char *dev;
 
 		nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
-		for (i = 0; i < c->dev_array_len; i++) {
-			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME,
-					  c->dev_array[i]);
-		}
+		nftnl_str_array_foreach(dev, &c->dev_array, i)
+			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev);
 		mnl_attr_nest_end(nlh, nest_dev);
 	}
 
@@ -402,43 +371,6 @@ static int nftnl_flowtable_parse_hook_cb(const struct nlattr *attr, void *data)
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
@@ -456,7 +388,8 @@ static int nftnl_flowtable_parse_hook(struct nlattr *attr, struct nftnl_flowtabl
 		c->flags |= (1 << NFTNL_FLOWTABLE_PRIO);
 	}
 	if (tb[NFTA_FLOWTABLE_HOOK_DEVS]) {
-		ret = nftnl_flowtable_parse_devs(tb[NFTA_FLOWTABLE_HOOK_DEVS], c);
+		ret = nftnl_parse_devs(&c->dev_array,
+				       tb[NFTA_FLOWTABLE_HOOK_DEVS]);
 		if (ret < 0)
 			return -1;
 		c->flags |= (1 << NFTNL_FLOWTABLE_DEVICES);
@@ -587,6 +520,7 @@ static int nftnl_flowtable_snprintf_default(char *buf, size_t remain,
 					    const struct nftnl_flowtable *c)
 {
 	int ret, offset = 0, i;
+	const char *dev;
 
 	ret = snprintf(buf, remain, "flow table %s %s use %u size %u flags %x",
 		       c->table, c->name, c->use, c->size, c->ft_flags);
@@ -602,9 +536,9 @@ static int nftnl_flowtable_snprintf_default(char *buf, size_t remain,
 			ret = snprintf(buf + offset, remain, " dev { ");
 			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-			for (i = 0; i < c->dev_array_len; i++) {
+			nftnl_str_array_foreach(dev, &c->dev_array, i) {
 				ret = snprintf(buf + offset, remain, " %s ",
-					       c->dev_array[i]);
+					       dev);
 				SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 			}
 			ret = snprintf(buf + offset, remain, " } ");
diff --git a/src/str_array.c b/src/str_array.c
new file mode 100644
index 0000000000000..2ffc158569000
--- /dev/null
+++ b/src/str_array.c
@@ -0,0 +1,69 @@
+/*
+ * (C) 2024 Red Hat GmbH
+ * Author: Phil Sutter <phil@nwl.cc>
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+#include <libmnl/libmnl.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include "str_array.h"
+#include "utils.h"
+
+void nftnl_str_array_clear(struct nftnl_str_array *sa)
+{
+	while (sa->len > 0)
+		free(sa->array[--sa->len]);
+	free(sa->array);
+	sa->array = NULL;
+}
+
+int nftnl_str_array_set(struct nftnl_str_array *sa, const char * const *array)
+{
+	int len = 0;
+
+	while (array[len])
+		len++;
+
+	nftnl_str_array_clear(sa);
+	sa->array = calloc(len + 1, sizeof(char *));
+	if (!sa->array)
+		return -1;
+
+	while (sa->len < len) {
+		sa->array[sa->len] = strdup(array[sa->len]);
+		if (!sa->array[sa->len]) {
+			nftnl_str_array_clear(sa);
+			return -1;
+		}
+		sa->len++;
+	}
+	return 0;
+}
+
+int nftnl_parse_devs(struct nftnl_str_array *sa, const struct nlattr *nest)
+{
+	struct nlattr *attr;
+	int len = 0;
+
+	mnl_attr_for_each_nested(attr, nest) {
+		if (mnl_attr_get_type(attr) != NFTA_DEVICE_NAME)
+			return -1;
+		len++;
+	}
+
+	nftnl_str_array_clear(sa);
+	sa->array = calloc(len + 1, sizeof(char *));
+	if (!sa->array)
+		return -1;
+
+	mnl_attr_for_each_nested(attr, nest) {
+		sa->array[sa->len] = strdup(mnl_attr_get_str(attr));
+		if (!sa->array[sa->len]) {
+			nftnl_str_array_clear(sa);
+			return -1;
+		}
+		sa->len++;
+	}
+	return 0;
+}
diff --git a/src/utils.c b/src/utils.c
index 2f1ffd6227583..157b15f7afe8d 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -19,6 +19,7 @@
 
 #include <libnftnl/common.h>
 
+#include <libmnl/libmnl.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 
diff --git a/tests/nft-chain-test.c b/tests/nft-chain-test.c
index 35a65be8d1587..64c506eb62a15 100644
--- a/tests/nft-chain-test.c
+++ b/tests/nft-chain-test.c
@@ -23,9 +23,25 @@ static void print_err(const char *msg)
 	printf("\033[31mERROR:\e[0m %s\n", msg);
 }
 
-static void cmp_nftnl_chain(struct nftnl_chain *a, struct nftnl_chain *b)
+static void cmp_devices(const char * const *adevs,
+			const char * const *bdevs)
 {
+	int i;
+
+	if (!adevs && !bdevs)
+		return;
+	if (!!adevs ^ !!bdevs)
+		print_err("Chain devices mismatches");
+	for (i = 0; adevs[i] && bdevs[i]; i++) {
+		if (strcmp(adevs[i], bdevs[i]))
+			break;
+	}
+	if (adevs[i] || bdevs[i])
+		print_err("Chain devices mismatches");
+}
 
+static void cmp_nftnl_chain(struct nftnl_chain *a, struct nftnl_chain *b)
+{
 	if (strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_NAME),
 		   nftnl_chain_get_str(b, NFTNL_CHAIN_NAME)) != 0)
 		print_err("Chain name mismatches");
@@ -59,13 +75,17 @@ static void cmp_nftnl_chain(struct nftnl_chain *a, struct nftnl_chain *b)
 	if (strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_TYPE),
 		   nftnl_chain_get_str(b, NFTNL_CHAIN_TYPE)) != 0)
 		print_err("Chain type mismatches");
-	if (strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_DEV),
+	if (nftnl_chain_is_set(a, NFTNL_CHAIN_DEV) &&
+	    strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_DEV),
 		   nftnl_chain_get_str(b, NFTNL_CHAIN_DEV)) != 0)
 		print_err("Chain device mismatches");
+	cmp_devices(nftnl_chain_get_array(a, NFTNL_CHAIN_DEVICES),
+		    nftnl_chain_get_array(b, NFTNL_CHAIN_DEVICES));
 }
 
 int main(int argc, char *argv[])
 {
+	const char *devs[] = { "eth0", "eth1", "eth2", NULL };
 	struct nftnl_chain *a, *b;
 	char buf[4096];
 	struct nlmsghdr *nlh;
@@ -97,6 +117,19 @@ int main(int argc, char *argv[])
 
 	cmp_nftnl_chain(a, b);
 
+	/* repeat test with multiple devices */
+
+	nftnl_chain_unset(a, NFTNL_CHAIN_DEV);
+	nftnl_chain_set_array(a, NFTNL_CHAIN_DEVICES, devs);
+
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, AF_INET, 0, 1234);
+	nftnl_chain_nlmsg_build_payload(nlh, a);
+
+	if (nftnl_chain_nlmsg_parse(nlh, b) < 0)
+		print_err("parsing problems");
+
+	cmp_nftnl_chain(a, b);
+
 	nftnl_chain_free(a);
 	nftnl_chain_free(b);
 
diff --git a/tests/nft-flowtable-test.c b/tests/nft-flowtable-test.c
index 8ab8d4c5347a4..49bc0a1c5e043 100644
--- a/tests/nft-flowtable-test.c
+++ b/tests/nft-flowtable-test.c
@@ -13,6 +13,23 @@ static void print_err(const char *msg)
 	printf("\033[31mERROR:\e[0m %s\n", msg);
 }
 
+static void cmp_devices(const char * const *adevs,
+			const char * const *bdevs)
+{
+	int i;
+
+	if (!adevs && !bdevs)
+		return;
+	if (!!adevs ^ !!bdevs)
+		print_err("Flowtable devices mismatches");
+	for (i = 0; adevs[i] && bdevs[i]; i++) {
+		if (strcmp(adevs[i], bdevs[i]))
+			break;
+	}
+	if (adevs[i] || bdevs[i])
+		print_err("Flowtable devices mismatches");
+}
+
 static void cmp_nftnl_flowtable(struct nftnl_flowtable *a, struct nftnl_flowtable *b)
 {
 	if (strcmp(nftnl_flowtable_get_str(a, NFTNL_FLOWTABLE_NAME),
@@ -44,10 +61,13 @@ static void cmp_nftnl_flowtable(struct nftnl_flowtable *a, struct nftnl_flowtabl
 	if (nftnl_flowtable_get_u64(a, NFTNL_FLOWTABLE_HANDLE) !=
 	    nftnl_flowtable_get_u64(b, NFTNL_FLOWTABLE_HANDLE))
 		print_err("Flowtable handle mismatches");
+	cmp_devices(nftnl_flowtable_get_array(a, NFTNL_FLOWTABLE_DEVICES),
+		    nftnl_flowtable_get_array(b, NFTNL_FLOWTABLE_DEVICES));
 }
 
 int main(int argc, char *argv[])
 {
+	const char *devs[] = { "eth0", "eth1", "eth2", NULL };
 	struct nftnl_flowtable *a, *b;
 	char buf[4096];
 	struct nlmsghdr *nlh;
@@ -66,6 +86,7 @@ int main(int argc, char *argv[])
 	nftnl_flowtable_set_u32(a, NFTNL_FLOWTABLE_SIZE, 0x89016745);
 	nftnl_flowtable_set_u32(a, NFTNL_FLOWTABLE_FLAGS, 0x45016723);
 	nftnl_flowtable_set_u64(a, NFTNL_FLOWTABLE_HANDLE, 0x2345016789);
+	nftnl_flowtable_set_array(a, NFTNL_FLOWTABLE_DEVICES, devs);
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWFLOWTABLE, AF_INET,
 				    0, 1234);
-- 
2.47.0

