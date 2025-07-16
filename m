Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55432F5086
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 12:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752669217; cv=none; b=QcqAUNaZXKu3p58aWqxCGCOSJUgZgqyrtK3v1GhtgZgcqQq15fOj6D/NTGcSbX7l2vbLDJWhVVT1AS7PfPxwIuMnu1iiYRa1tAfLHqlRHCbUIN/wy518q/9amH+82+HUWFxk/7tfmrJQn9PxgKzdMbJUWM9htLQsDps0FnShULA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752669217; c=relaxed/simple;
	bh=ZxK3BROLVHixt0pv7lgca1aa/unClCDC/1EEF5TLmCg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qfCaa7O1wMbdC7ZtAFIjuCZn+3a4Ru++/y96WerfAvo/Pxfv5WkeFVFLRPoqlcYg45MP93i7q8LDde5+x1Y/hjkp9CncQLXZ/PwuzaLrwOVIxqNSXPPDJMU+H68XCYnCEcd31ha0nyurZtR+OtyFgS0v5F2JNtI7AjTNZUwWkYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FYa1Waxm; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FYa1Waxm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OD4/pxk0DXB9AiqpB1VPDzwwXrQmOrSD/krCnsU5LCc=; b=FYa1Waxm0UOBFzNN+Nsa+sKuOo
	Ulys9ePsjjlGvJhQeMys7Baz7az7A2jGJ/PJU+bqpU5+LvMT3TUcRNqFR0thUhBjqGSzehjJ1kQwY
	TpiVK8pnJOQbFYMlAU4tmf8SK7DS1mugNtXeytAcjHswYHloBWfzBDUt8sMplnd+UZ96979Tgs665
	E8ESXkoQRAKFEsDy0D3MbHSq2TWJMts9Ra+/qZrjYPcZj4d6v7WNhiYUQqmK27zP0TJxrKSrGADgz
	N1wbGJ1UwA+aFseNRPDyDW4QFYmh/b6js4i5vx1HiSH6Ta8dvamSGIvN9ZoVVccbQKPGbNzJRkRe6
	jnvwTQ2w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uc1KF-000000003vY-0LvL;
	Wed, 16 Jul 2025 14:33:31 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH v3] utils: Add helpers for interface name wildcards
Date: Wed, 16 Jul 2025 14:32:49 +0200
Message-ID: <20250716123325.3230-1-phil@nwl.cc>
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
Changes since v2:
- Use 'nftnl' prefix for introduced helpers
- Forward-declare struct nlattr to avoid extra include in utils.h
- Sanity-check array indexes to avoid out-of-bounds access
---
 include/utils.h |  5 +++++
 src/chain.c     |  8 +++++---
 src/flowtable.c |  2 +-
 src/str_array.c |  2 +-
 src/utils.c     | 30 ++++++++++++++++++++++++++++++
 5 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 247d99d19dd7f..16468a31cb166 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -83,4 +83,9 @@ int nftnl_fprintf(FILE *fpconst, const void *obj, uint32_t cmd, uint32_t type,
 int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
 		       uint16_t attr, const void *data, uint32_t data_len);
 
+struct nlattr;
+
+void nftnl_attr_put_ifname(struct nlmsghdr *nlh, int attr, const char *ifname);
+const char *nftnl_attr_get_ifname(struct nlattr *attr);
+
 #endif
diff --git a/src/chain.c b/src/chain.c
index 895108cddad51..9dcdfb9c95337 100644
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
+		c->dev = strdup(nftnl_attr_get_ifname(tb[NFTA_HOOK_DEV]));
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
index 5669c6154d394..c9d0472d28212 100644
--- a/src/str_array.c
+++ b/src/str_array.c
@@ -56,7 +56,7 @@ int nftnl_parse_devs(struct nftnl_str_array *sa, const struct nlattr *nest)
 		return -1;
 
 	mnl_attr_for_each_nested(attr, nest) {
-		sa->array[sa->len] = strdup(mnl_attr_get_str(attr));
+		sa->array[sa->len] = strdup(nftnl_attr_get_ifname(attr));
 		if (!sa->array[sa->len]) {
 			nftnl_str_array_clear(sa);
 			return -1;
diff --git a/src/utils.c b/src/utils.c
index 5f2c5bff7c650..ccea60b58e797 100644
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
+void nftnl_attr_put_ifname(struct nlmsghdr *nlh, int attr, const char *ifname)
+{
+	int len = strlen(ifname) + 1;
+
+	if (len >= 2 && ifname[len - 2] == '*')
+		len -= 2;
+
+	mnl_attr_put(nlh, attr, len, ifname);
+}
+
+const char *nftnl_attr_get_ifname(struct nlattr *attr)
+{
+	size_t slen = mnl_attr_get_payload_len(attr);
+	const char *dev = mnl_attr_get_str(attr);
+	static char buf[IFNAMSIZ];
+
+	if (slen > 0 && dev[slen - 1] == '\0')
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

