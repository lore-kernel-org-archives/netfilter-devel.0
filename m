Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF642190664
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Jul 2025 15:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752592537; cv=none; b=Op6RJdpSvpADq7lhxu3jjX3DQpotXh/+lMIHY+0qaMOfOxYLjwDSOjjiQVOVQhftc/2iCYyE/iL6iJcWW9K3dGriIoFpggpGBJkaxcpVrDq0esNF9jTrwwkAuS34TS32jWhjiiPOBLzL3MpesIVd86jmhZL8V9ex+SM0u6lWScs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752592537; c=relaxed/simple;
	bh=WUbGSFUvaxtrHzDcQZA0otYYEPcHteastoDvGSrhisU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h8GuzINHwLRkubCMU/lUYpJ2k2VOWpfRRK50kEipBiXV9XlNqduKUMlnLm83czcTXsAMtNwB9Y6SJ0nRe73qwHPQRIvRdDYMDR5pxb9AN5S058TXuKsf+mZlLbzO1O6yLjzHBG2vXFwgtcZ+CqJnZzCV5rbCLZc0NJsr3o+VlOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=iaQ8ZHyZ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="iaQ8ZHyZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fgEaCKJubxwePPrhUbw7SaBt7mWcRmpH+muDNIl9k00=; b=iaQ8ZHyZSLjbDRo+N2QXpOLkKN
	u4EMKcqvS4jSliDvC9YKuzMWTVNLUs2XmGWlimbOamNrjT3D3bEAJaSZ9BJggaAruG9Zngt8aJzkG
	5GQIjugbImd99bSJle209uV9vn4k93aTAtU1kakKbPHIqm/IM7/lhsR4o1ylF/6V1oNYVmo+r+OMC
	iJVdcWYpAnI1jMLyDncgb7Im1Yx1mjyTEQzx3JtUJ5a3TZCw1IoPchKPAwzdOKY0ABZNzO/5rniFM
	E8ZbiuoLMzm6BORZGEfSCWV/zF/5nRmn+t0mMWAYfyDKxO2KX6MXhKqv/0loSZEQuPWGKyMdJ8G9q
	8lezAvEA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ubhNT-000000003B1-2k4g;
	Tue, 15 Jul 2025 17:15:31 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH v2] utils: Add helpers for interface name wildcards
Date: Tue, 15 Jul 2025 17:15:26 +0200
Message-ID: <20250715151526.14573-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
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
No changes since v1 apart from a rebase onto current HEAD.
This single patch supersedes the previous series "Support wildcard
netdev hooks and events" as without NEWDEV/DELDEV kernel notifications,
this is the only change needed by libnftnl to support ifname-based
hooks.
---
 include/utils.h |  4 ++++
 src/chain.c     |  8 +++++---
 src/flowtable.c |  2 +-
 src/str_array.c |  2 +-
 src/utils.c     | 30 ++++++++++++++++++++++++++++++
 5 files changed, 41 insertions(+), 5 deletions(-)

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
index 895108cddad51..17ae5568609c4 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -457,14 +457,14 @@ void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_ch
 		mnl_attr_put_u32(nlh, NFTA_HOOK_PRIORITY, htonl(c->prio));
 
 	if (c->flags & (1 << NFTNL_CHAIN_DEV))
-		mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, c->dev);
+		mnl_attr_put_ifname(nlh, NFTA_HOOK_DEV, c->dev);
 	else if (c->flags & (1 << NFTNL_CHAIN_DEVICES)) {
 		struct nlattr *nest_dev;
 		const char *dev;
 
 		nest_dev = mnl_attr_nest_start(nlh, NFTA_HOOK_DEVS);
 		nftnl_str_array_foreach(dev, &c->dev_array, i)
-			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev);
+			mnl_attr_put_ifname(nlh, NFTA_DEVICE_NAME, dev);
 		mnl_attr_nest_end(nlh, nest_dev);
 	}
 
@@ -648,7 +648,9 @@ static int nftnl_chain_parse_hook(struct nlattr *attr, struct nftnl_chain *c)
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
index fbbe0a866368d..75e86fb6d1e55 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -299,7 +299,7 @@ void nftnl_flowtable_nlmsg_build_payload(struct nlmsghdr *nlh,
 
 		nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
 		nftnl_str_array_foreach(dev, &c->dev_array, i)
-			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev);
+			mnl_attr_put_ifname(nlh, NFTA_DEVICE_NAME, dev);
 		mnl_attr_nest_end(nlh, nest_dev);
 	}
 
diff --git a/src/str_array.c b/src/str_array.c
index 5669c6154d394..bb75e04cb20da 100644
--- a/src/str_array.c
+++ b/src/str_array.c
@@ -56,7 +56,7 @@ int nftnl_parse_devs(struct nftnl_str_array *sa, const struct nlattr *nest)
 		return -1;
 
 	mnl_attr_for_each_nested(attr, nest) {
-		sa->array[sa->len] = strdup(mnl_attr_get_str(attr));
+		sa->array[sa->len] = strdup(mnl_attr_get_ifname(attr));
 		if (!sa->array[sa->len]) {
 			nftnl_str_array_clear(sa);
 			return -1;
diff --git a/src/utils.c b/src/utils.c
index 5f2c5bff7c650..bcace0cd72788 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -13,8 +13,11 @@
 #include <errno.h>
 #include <inttypes.h>
 
+#include <libmnl/libmnl.h>
+
 #include <libnftnl/common.h>
 
+#include <linux/if.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 
@@ -146,3 +149,30 @@ int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
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
2.49.0

