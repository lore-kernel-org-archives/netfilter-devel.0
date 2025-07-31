Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A292550CF
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2025 22:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754000287; cv=none; b=ineItLPpLfrzCKASCZdVJJRgVaxYMKOQjNu95a5DN97BL5EEoJXK32uAgDZyY9lVQH3pbYrbSUB0FrfDGInZemEAaGr9WdENrMkC6f1DS6LM40OTef7DqjFKy9WM7yvddWtDiX/BvzXQoLPGHIo7lZcUtVZ7V/3z1m+S/Abh32w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754000287; c=relaxed/simple;
	bh=gWoyFt7NWLpwlSnUBhP3enRk3wygGL0lbn8k2OfoG7w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SEPM+LqNyH1VxxkcqlS3iefHiyAjiENdVE+h+DI5G0+rG4EOC9ODpEGHf790+2z3XyWv1ZW1hqNWZ1xnAroK1UFuXX8+QVk9xRR9UhMypp5jBS1XjHw1czTDVu7/DDL6AFGdMZzF6Av3HjvRB16bkBJXxwxLwmhFu5ct71PGKzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YFapXfr/; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YFapXfr/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=q1Dw6DW9woSPWgSirWNFs+0cU+V3VWUZKEKxIVcp9rM=; b=YFapXfr/286W4iYGC2gnMpmGYj
	Phj7zqMm2dxiqkWtqhTD3fKONhk3WY2PbJCBsmNjNYjVLu5qV+aVK3A4aSDHcp4Wpvmw7LNU3t/nE
	780mR0zw9a160xt8tefdxyFJHTxGi1+uAMOV+g5naBM3aFuZ4TLkZN6XJzniV8Qo5dXq55vbPUtjr
	7sQrfuB2SgJtJfpcMyU0kMGwhLoq8Z5TZgC4oJRQyRlpqvZrajnC/vBbSUEFR4Y74X6MxUMIDTzfl
	uXLyTj2URrchELbFF7Ehtlln94bMeTbGAIXpS1knAbpf7M+QpdQPIyMkPqGsExXAzYcUaJFtg/BTX
	E2V1muhw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uhbb7-000000000sn-1A33;
	Fri, 01 Aug 2025 00:18:01 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH v4] utils: Add helpers for interface name wildcards
Date: Fri,  1 Aug 2025 00:17:48 +0200
Message-ID: <20250731221756.24340-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Support simple (suffix) wildcards in NFTNL_{CHAIN,FLOWTABLE}_DEVICES
identified by NFTA_DEVICE_PREFIX attribute. Add helpers converting to
and from the human-readable asterisk-suffix notation.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v4:
- Adjust code to NFTA_DEVICE_PREFIX attribute

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
 include/linux/netfilter/nf_tables.h |  2 ++
 include/utils.h                     |  5 ++++
 src/chain.c                         |  4 ++-
 src/flowtable.c                     |  2 +-
 src/str_array.c                     | 10 +++++---
 src/utils.c                         | 39 +++++++++++++++++++++++++++++
 6 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 2beb30be2c5f8..8e0eb832bc01e 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1784,10 +1784,12 @@ enum nft_synproxy_attributes {
  * enum nft_device_attributes - nf_tables device netlink attributes
  *
  * @NFTA_DEVICE_NAME: name of this device (NLA_STRING)
+ * @NFTA_DEVICE_PREFIX: device name prefix, a simple wildcard (NLA_STRING)
  */
 enum nft_devices_attributes {
 	NFTA_DEVICE_UNSPEC,
 	NFTA_DEVICE_NAME,
+	NFTA_DEVICE_PREFIX,
 	__NFTA_DEVICE_MAX
 };
 #define NFTA_DEVICE_MAX		(__NFTA_DEVICE_MAX - 1)
diff --git a/include/utils.h b/include/utils.h
index 247d99d19dd7f..5a3379fb501e1 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -83,4 +83,9 @@ int nftnl_fprintf(FILE *fpconst, const void *obj, uint32_t cmd, uint32_t type,
 int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
 		       uint16_t attr, const void *data, uint32_t data_len);
 
+struct nlattr;
+
+void nftnl_attr_put_ifname(struct nlmsghdr *nlh, const char *ifname);
+char *nftnl_attr_get_ifname(const struct nlattr *attr);
+
 #endif
diff --git a/src/chain.c b/src/chain.c
index 895108cddad51..8396114439ff7 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -464,7 +464,7 @@ void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_ch
 
 		nest_dev = mnl_attr_nest_start(nlh, NFTA_HOOK_DEVS);
 		nftnl_str_array_foreach(dev, &c->dev_array, i)
-			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev);
+			nftnl_attr_put_ifname(nlh, dev);
 		mnl_attr_nest_end(nlh, nest_dev);
 	}
 
@@ -648,6 +648,8 @@ static int nftnl_chain_parse_hook(struct nlattr *attr, struct nftnl_chain *c)
 		c->flags |= (1 << NFTNL_CHAIN_PRIO);
 	}
 	if (tb[NFTA_HOOK_DEV]) {
+		if (c->flags & (1 << NFTNL_CHAIN_DEV))
+			xfree(c->dev);
 		c->dev = strdup(mnl_attr_get_str(tb[NFTA_HOOK_DEV]));
 		if (!c->dev)
 			return -1;
diff --git a/src/flowtable.c b/src/flowtable.c
index fbbe0a866368d..59991d694f602 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -299,7 +299,7 @@ void nftnl_flowtable_nlmsg_build_payload(struct nlmsghdr *nlh,
 
 		nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
 		nftnl_str_array_foreach(dev, &c->dev_array, i)
-			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev);
+			nftnl_attr_put_ifname(nlh, dev);
 		mnl_attr_nest_end(nlh, nest_dev);
 	}
 
diff --git a/src/str_array.c b/src/str_array.c
index 5669c6154d394..4292c98a9debd 100644
--- a/src/str_array.c
+++ b/src/str_array.c
@@ -45,9 +45,13 @@ int nftnl_parse_devs(struct nftnl_str_array *sa, const struct nlattr *nest)
 	int len = 0;
 
 	mnl_attr_for_each_nested(attr, nest) {
-		if (mnl_attr_get_type(attr) != NFTA_DEVICE_NAME)
+		switch(mnl_attr_get_type(attr)) {
+		default:
 			return -1;
-		len++;
+		case NFTA_DEVICE_NAME:
+		case NFTA_DEVICE_PREFIX:
+			len++;
+		}
 	}
 
 	nftnl_str_array_clear(sa);
@@ -56,7 +60,7 @@ int nftnl_parse_devs(struct nftnl_str_array *sa, const struct nlattr *nest)
 		return -1;
 
 	mnl_attr_for_each_nested(attr, nest) {
-		sa->array[sa->len] = strdup(mnl_attr_get_str(attr));
+		sa->array[sa->len] = nftnl_attr_get_ifname(attr);
 		if (!sa->array[sa->len]) {
 			nftnl_str_array_clear(sa);
 			return -1;
diff --git a/src/utils.c b/src/utils.c
index 5f2c5bff7c650..c4bbd4f7ed171 100644
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
 
@@ -146,3 +149,39 @@ int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
 	*flags |= (1 << attr);
 	return 0;
 }
+
+static bool is_wildcard_str(const char *str)
+{
+	size_t len = strlen(str);
+
+	if (len < 1 || str[len - 1] != '*')
+		return false;
+	if (len < 2 || str[len - 2] != '\\')
+		return true;
+	/* XXX: ignore backslash escaping for now */
+	return false;
+}
+
+void nftnl_attr_put_ifname(struct nlmsghdr *nlh, const char *ifname)
+{
+	uint16_t attr = is_wildcard_str(ifname) ?
+			NFTA_DEVICE_PREFIX : NFTA_DEVICE_NAME;
+
+	mnl_attr_put_strz(nlh, attr, ifname);
+}
+
+char *nftnl_attr_get_ifname(const struct nlattr *attr)
+{
+	const char *dev = mnl_attr_get_str(attr);
+	char buf[IFNAMSIZ];
+
+	switch (mnl_attr_get_type(attr)) {
+	case NFTA_DEVICE_NAME:
+		return strdup(dev);
+	case NFTA_DEVICE_PREFIX:
+		snprintf(buf, IFNAMSIZ, "%s*", dev);
+		return strdup(buf);
+	default:
+		return NULL;
+	}
+}
-- 
2.49.0

