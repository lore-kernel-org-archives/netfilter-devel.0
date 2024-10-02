Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D97E212F1F
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 19:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727896797; cv=none; b=SPsb/FAJHN+tR6ammTd4gj1HGKGbGfB8BFOiDFnpDvbS8Nx+znWpW0wioEcBRTUN2W9jyOW4uw9N4F7CgGL0Tx5kYm+iArnJBrc/r/59ER3y10HuwURQzhgMy1uf2/AZVMt1MVX5b0J26wDLIN81tdCxJHWD5EqNUjLeRYgPqXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727896797; c=relaxed/simple;
	bh=uzvB/mXhRudW9Q37tp6fJBSV4jHuuD6wUwmsESSdUMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EL1SYvREiglRRkegfSxBcrIy0IH9dqRtIt/yOecLpHQvUI0PTdGuNHlBRAcKaxMtqRBlHx7lwploE3h9vosnuuWZxZXfYNPMz+dBLGTzCfxIcp0NQLLM2jg96XvqY1Knyf7la2fqkrdxA7kM+78z66XtPY/Xf8f+tuFX2/MPjpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=NxhfB7kX; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="NxhfB7kX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=B+ZLFQ8ZSxflsGf9fTJti9pPMC0gMus5JFLK32eDZXo=; b=NxhfB7kX1epWfD+nEo0oFEMsS/
	+QLQIrM+GcM1UtGEBcwhT+sjKRPjL3NpiP2dxr92tpg+BGmaE0Lpr5GO+3s6IAw4bO2n11vHjvo7c
	scED5WXfdsMGSBio9i0RE/PtoebGmLAyelIMEasKQXiu6V58dAYf9ZUWHBW3ob5iKszWTJtjRHJtE
	PQC0SxVz/7exxyTzTz0mHRgOs/FjhhfY4BAmTO1zjyDW6RAYOl2vNVnv5eyw0OoUsQhAoRStV1n6X
	d6SD7alwmf7NeY3AVQC0CaT/Ql6chJcNFBZY24RaSw/9LfRUCZgbHX/kIYSN/sfGRczS7gQatI+zE
	/Z529BOA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sw4sz-000000002lD-1jLA;
	Wed, 02 Oct 2024 21:19:45 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 2/4] utils: Add helpers for interface name wildcards
Date: Wed,  2 Oct 2024 21:19:39 +0200
Message-ID: <20241002191941.8410-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241002191941.8410-1-phil@nwl.cc>
References: <20241002191941.8410-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Support simple (suffix) wildcards in NFTNL_CHAIN_DEV(ICES) and
NFTA_FLOWTABLE_HOOK_DEVS identified by non-NUL-terminated strings. Add
helpers converting to and from the human-readable asterisk-suffix
notation.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/utils.h |  4 ++++
 src/chain.c     | 16 ++++++++++------
 src/flowtable.c | 10 ++++++----
 src/utils.c     | 30 ++++++++++++++++++++++++++++++
 4 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 247d99d19dd7f..c8e890eae2ffd 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -6,6 +6,7 @@
 #include <stdint.h>
 #include <string.h>
 #include <stdlib.h>
+#include <libmnl/libmnl.h>
 #include <libnftnl/common.h>
 
 #include "config.h"
@@ -83,4 +84,7 @@ int nftnl_fprintf(FILE *fpconst, const void *obj, uint32_t cmd, uint32_t type,
 int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
 		       uint16_t attr, const void *data, uint32_t data_len);
 
+void mnl_attr_put_ifname(struct nlmsghdr *nlh, int attr, const char *ifname);
+const char *mnl_attr_get_ifname(struct nlattr *attr);
+
 #endif
diff --git a/src/chain.c b/src/chain.c
index 0b68939fe21a7..830e09fcfbbb1 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -490,14 +490,14 @@ void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_ch
 		mnl_attr_put_u32(nlh, NFTA_HOOK_PRIORITY, htonl(c->prio));
 
 	if (c->flags & (1 << NFTNL_CHAIN_DEV))
-		mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, c->dev);
+		mnl_attr_put_ifname(nlh, NFTA_HOOK_DEV, c->dev);
 	else if (c->flags & (1 << NFTNL_CHAIN_DEVICES)) {
 		struct nlattr *nest_dev;
 
 		nest_dev = mnl_attr_nest_start(nlh, NFTA_HOOK_DEVS);
 		for (i = 0; i < c->dev_array_len; i++)
-			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME,
-					  c->dev_array[i]);
+			mnl_attr_put_ifname(nlh, NFTA_DEVICE_NAME,
+					    c->dev_array[i]);
 		mnl_attr_nest_end(nlh, nest_dev);
 	}
 
@@ -677,8 +677,10 @@ static int nftnl_chain_parse_devs(struct nlattr *nest, struct nftnl_chain *c)
 	mnl_attr_for_each_nested(attr, nest) {
 		if (mnl_attr_get_type(attr) != NFTA_DEVICE_NAME)
 			goto err;
-		dev_array[len++] = strdup(mnl_attr_get_str(attr));
-		if (len >= size) {
+		dev_array[len] = strdup(mnl_attr_get_ifname(attr));
+		if (!dev_array[len])
+			goto err;
+		if (++len >= size) {
 			tmp = realloc(dev_array, size * 2 * sizeof(char *));
 			if (!tmp)
 				goto err;
@@ -717,7 +719,9 @@ static int nftnl_chain_parse_hook(struct nlattr *attr, struct nftnl_chain *c)
 		c->flags |= (1 << NFTNL_CHAIN_PRIO);
 	}
 	if (tb[NFTA_HOOK_DEV]) {
-		c->dev = strdup(mnl_attr_get_str(tb[NFTA_HOOK_DEV]));
+		if (c->flags & (1 << NFTNL_CHAIN_DEV))
+			xfree(c->dev);
+		c->dev = strdup(mnl_attr_get_ifname(tb[NFTA_HOOK_DEV]));
 		if (!c->dev)
 			return -1;
 		c->flags |= (1 << NFTNL_CHAIN_DEV);
diff --git a/src/flowtable.c b/src/flowtable.c
index 41a1456bb19b2..74cffc812996c 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -328,8 +328,8 @@ void nftnl_flowtable_nlmsg_build_payload(struct nlmsghdr *nlh,
 
 		nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
 		for (i = 0; i < c->dev_array_len; i++) {
-			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME,
-					  c->dev_array[i]);
+			mnl_attr_put_ifname(nlh, NFTA_DEVICE_NAME,
+					    c->dev_array[i]);
 		}
 		mnl_attr_nest_end(nlh, nest_dev);
 	}
@@ -416,8 +416,10 @@ static int nftnl_flowtable_parse_devs(struct nlattr *nest,
 	mnl_attr_for_each_nested(attr, nest) {
 		if (mnl_attr_get_type(attr) != NFTA_DEVICE_NAME)
 			goto err;
-		dev_array[len++] = strdup(mnl_attr_get_str(attr));
-		if (len >= size) {
+		dev_array[len] = strdup(mnl_attr_get_ifname(attr));
+		if (!dev_array[len])
+			goto err;
+		if (++len >= size) {
 			tmp = realloc(dev_array, size * 2 * sizeof(char *));
 			if (!tmp)
 				goto err;
diff --git a/src/utils.c b/src/utils.c
index 2f1ffd6227583..df00ce04b32ea 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -17,8 +17,11 @@
 #include <errno.h>
 #include <inttypes.h>
 
+#include <libmnl/libmnl.h>
+
 #include <libnftnl/common.h>
 
+#include <linux/if.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 
@@ -150,3 +153,30 @@ int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
 	*flags |= (1 << attr);
 	return 0;
 }
+
+void mnl_attr_put_ifname(struct nlmsghdr *nlh, int attr, const char *ifname)
+{
+	int len = strlen(ifname) + 1;
+
+	if (ifname[len - 2] == '*')
+		len -= 2;
+
+	mnl_attr_put(nlh, attr, len, ifname);
+}
+
+const char *mnl_attr_get_ifname(struct nlattr *attr)
+{
+	size_t slen = mnl_attr_get_payload_len(attr);
+	const char *dev = mnl_attr_get_str(attr);
+	static char buf[IFNAMSIZ];
+
+	if (dev[slen - 1] == '\0')
+		return dev;
+
+	if (slen > IFNAMSIZ - 2)
+		slen = IFNAMSIZ - 2;
+
+	memcpy(buf, dev, slen);
+	memcpy(buf + slen, "*\0", 2);
+	return buf;
+}
-- 
2.43.0

