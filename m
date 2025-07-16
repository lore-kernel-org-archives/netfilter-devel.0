Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B391A0BF1
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 13:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752672148; cv=none; b=hguy4Uf7BB6Clf/8lDuvqc4d8tDXe3DPeAB+AfQ4zTxHsfff0fYPutTDBfZcwVXvfA/o3r6YlshobwXZcNNOuV2tfAarsz9YNmqmkffx2UU5rU3kJKTbru6ROOXjSIuuYD/5VQb+YXU8Dkbj2T8wpIUuoBv0g3gz28NiKNCFmuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752672148; c=relaxed/simple;
	bh=cHAPQtH9ZrP9VUjREGZHfVD6mMO2cKSL5kibc2vY8Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VZ0cCT8+yMl3JhMMjudBF/jug50jV0K63BChWhB3K+Qcd6Q4aIfl1IvVLWe4D3zNgjHoeSeH5JMyV/SAyPJ+7xzdViGqTGf/jwIBkQ7p7GxwM+Ip927Pmk45u/gc+0fCG4W8AQsuMt5NP1O1NPiYfwznw6sEhlR9Fh0CagRSmbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YgZU2t4g; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YgZU2t4g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bxBwBygB2v7VC+t0XMH64/8wsxV6l84+TkG+pM31pmM=; b=YgZU2t4gZhGQIUDiM5+rYPrHEh
	sgofDnitq/mMQvyS/m7OviDViWwoUWgFaREJ3sCiUMRSiNAta7vKTacR+09+hfvbwvRKBQYgV2l+N
	oRsgyf56bC1zvFk2hr0wIDEFc6YmNBf9cyF+cHDx/9Uj/cElb/UArjdD2chix7nK6Z6keZ2cdFo9Z
	NXbDCGCtZ3CY5A/PN7/1xF39u+YCb0nVglYeqe/fdD2YkcBTGVe2fuber2lY4ZDthIWdchWGbVQWT
	RFW23byojl8wiOnn6c5qbrZpiDK94dghlNXuytDQCUyK3D0FbD87yt1PKmBLB3xXX4npq6l4t6VAa
	/Xo5mgTw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uc25Y-000000004rf-3c8A;
	Wed, 16 Jul 2025 15:22:24 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH] utils: Add helpers for interface name wildcards
Date: Wed, 16 Jul 2025 15:22:06 +0200
Message-ID: <20250716132209.20372-1-phil@nwl.cc>
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
Changes since v3:
- Use uint16_t for 'attr' parameter and size_t for internal 'len'
  variable
- nftnl_attr_get_ifname to return allocated buffer, 'attr' parameter may
  be const

Changes since v2:
- Use 'nftnl' prefix for introduced helpers
- Forward-declare struct nlattr to avoid extra include in utils.h
- Sanity-check array indexes to avoid out-of-bounds access
---
 include/utils.h |  6 ++++++
 src/chain.c     |  8 +++++---
 src/flowtable.c |  2 +-
 src/str_array.c |  2 +-
 src/utils.c     | 31 +++++++++++++++++++++++++++++++
 5 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 247d99d19dd7f..f232e7e2f3dd7 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -83,4 +83,10 @@ int nftnl_fprintf(FILE *fpconst, const void *obj, uint32_t cmd, uint32_t type,
 int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
 		       uint16_t attr, const void *data, uint32_t data_len);
 
+struct nlattr;
+
+void nftnl_attr_put_ifname(struct nlmsghdr *nlh,
+			   uint16_t attr, const char *ifname);
+char *nftnl_attr_get_ifname(const struct nlattr *attr);
+
 #endif
diff --git a/src/chain.c b/src/chain.c
index 895108cddad51..b401526c367fb 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -457,14 +457,14 @@ void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_ch
 		mnl_attr_put_u32(nlh, NFTA_HOOK_PRIORITY, htonl(c->prio));
 
 	if (c->flags & (1 << NFTNL_CHAIN_DEV))
-		mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, c->dev);
+		nftnl_attr_put_ifname(nlh, NFTA_HOOK_DEV, c->dev);
 	else if (c->flags & (1 << NFTNL_CHAIN_DEVICES)) {
 		struct nlattr *nest_dev;
 		const char *dev;
 
 		nest_dev = mnl_attr_nest_start(nlh, NFTA_HOOK_DEVS);
 		nftnl_str_array_foreach(dev, &c->dev_array, i)
-			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev);
+			nftnl_attr_put_ifname(nlh, NFTA_DEVICE_NAME, dev);
 		mnl_attr_nest_end(nlh, nest_dev);
 	}
 
@@ -648,7 +648,9 @@ static int nftnl_chain_parse_hook(struct nlattr *attr, struct nftnl_chain *c)
 		c->flags |= (1 << NFTNL_CHAIN_PRIO);
 	}
 	if (tb[NFTA_HOOK_DEV]) {
-		c->dev = strdup(mnl_attr_get_str(tb[NFTA_HOOK_DEV]));
+		if (c->flags & (1 << NFTNL_CHAIN_DEV))
+			xfree(c->dev);
+		c->dev = nftnl_attr_get_ifname(tb[NFTA_HOOK_DEV]);
 		if (!c->dev)
 			return -1;
 		c->flags |= (1 << NFTNL_CHAIN_DEV);
diff --git a/src/flowtable.c b/src/flowtable.c
index fbbe0a866368d..006d50743e78a 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -299,7 +299,7 @@ void nftnl_flowtable_nlmsg_build_payload(struct nlmsghdr *nlh,
 
 		nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
 		nftnl_str_array_foreach(dev, &c->dev_array, i)
-			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev);
+			nftnl_attr_put_ifname(nlh, NFTA_DEVICE_NAME, dev);
 		mnl_attr_nest_end(nlh, nest_dev);
 	}
 
diff --git a/src/str_array.c b/src/str_array.c
index 5669c6154d394..02501c0cbdd79 100644
--- a/src/str_array.c
+++ b/src/str_array.c
@@ -56,7 +56,7 @@ int nftnl_parse_devs(struct nftnl_str_array *sa, const struct nlattr *nest)
 		return -1;
 
 	mnl_attr_for_each_nested(attr, nest) {
-		sa->array[sa->len] = strdup(mnl_attr_get_str(attr));
+		sa->array[sa->len] = nftnl_attr_get_ifname(attr);
 		if (!sa->array[sa->len]) {
 			nftnl_str_array_clear(sa);
 			return -1;
diff --git a/src/utils.c b/src/utils.c
index 5f2c5bff7c650..2a8669c6242b7 100644
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
 
@@ -146,3 +149,31 @@ int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
 	*flags |= (1 << attr);
 	return 0;
 }
+
+void nftnl_attr_put_ifname(struct nlmsghdr *nlh,
+			   uint16_t attr, const char *ifname)
+{
+	size_t len = strlen(ifname) + 1;
+
+	if (len >= 2 && ifname[len - 2] == '*')
+		len -= 2;
+
+	mnl_attr_put(nlh, attr, len, ifname);
+}
+
+char *nftnl_attr_get_ifname(const struct nlattr *attr)
+{
+	size_t slen = mnl_attr_get_payload_len(attr);
+	const char *dev = mnl_attr_get_str(attr);
+	char buf[IFNAMSIZ];
+
+	if (slen > 0 && dev[slen - 1] == '\0')
+		return strdup(dev);
+
+	if (slen > IFNAMSIZ - 2)
+		slen = IFNAMSIZ - 2;
+
+	memcpy(buf, dev, slen);
+	memcpy(buf + slen, "*\0", 2);
+	return strdup(buf);
+}
-- 
2.49.0

