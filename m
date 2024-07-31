Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0891B5AA
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 17:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722445761; cv=none; b=tDQ6xwbQQ8a33sdPjcTFEImnjoUldj7oI5SkJJ7C0EbFJJgsFR61127abGVZwZQ/3H3N+65VZwhs29s5sZaHwGZEJ7MWVnpmMWA7Edh3wOhBoaViLCqaBfQwo7Ex7BYaXAEXjoZnkIUB6w1kZHFcnscAWbjZSzefylWRkN5KMDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722445761; c=relaxed/simple;
	bh=WhnxOdOOeSa1kYMK+vys83ostf4P5diFMchWfyHsp5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oj74DjkF28X7xW/KL3nKfah0tqSBKmEw2wMvdsCOyzSE4RT+gVoDXIaXIHVQ8X9dahYz/oXN9+WF89+AhiY/ryQcvedxg2YLmW49rAWkHbX36mqpNNLf15ew+qUcdFxzSN/7ZW2Ffl19Qu2B9P0wm0xa8m/JIa3hvZ5xH0wRVkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sZCpA-0006yA-Mx; Wed, 31 Jul 2024 19:09:16 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2 2/5] src: mnl: make family specification more strict when listing
Date: Wed, 31 Jul 2024 18:51:02 +0200
Message-ID: <20240731165111.32166-3-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240731165111.32166-1-fw@strlen.de>
References: <20240731165111.32166-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

make "nft list hooks <family>" more strict.

nft list hooks: query/list all NFPROTO_XXX values, i.e.
arp, bridge, ipv4, ipv6.

If a device is also given, then do include the netdev family for
the given device as well.

"nft list hooks arp" will only dump the hooks registered
for NFPROTO_ARP (or nothing at all if none are active).

"bridge", "ip", "ip6" will list the pre/in/forward/output/postrouting
hooks for these families, if any.

"inet" serves as an alias for "ip" and "ip6".

Link: https://lore.kernel.org/netfilter-devel/20240729153211.GA26048@breakpoint.cc/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/mnl.c | 53 ++++++++++++++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 29 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index e4bbbcf6d536..88475ef4c25e 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -2391,25 +2391,6 @@ static int dump_nf_hooks(const struct nlmsghdr *nlh, void *_data)
 
 	hook->family = nfg->nfgen_family;
 
-	/* Netdev hooks potentially interfer with this family datapath. */
-	if (hook->family == NFPROTO_NETDEV) {
-		switch (data->family) {
-		case NFPROTO_IPV4:
-		case NFPROTO_IPV6:
-		case NFPROTO_INET:
-		case NFPROTO_BRIDGE:
-			hook->family = data->family;
-			hook->num = NF_INET_INGRESS;
-			break;
-		case NFPROTO_ARP:
-			if (hook->chain_family == NFPROTO_NETDEV) {
-				hook->family = data->family;
-				hook->num = __NF_ARP_INGRESS;
-			}
-			break;
-		}
-	}
-
 	basehook_list_add_tail(hook, data->hook_list);
 
 	return MNL_CB_OK;
@@ -2523,9 +2504,6 @@ static int mnl_nft_dump_nf(struct netlink_ctx *ctx, int family, int hook,
 {
 	int i, err;
 
-	/* show ingress in first place in hook listing. */
-	err = __mnl_nft_dump_nf_hooks(ctx, family, NFPROTO_NETDEV, NF_NETDEV_INGRESS, devname, hook_list);
-
 	for (i = 0; i <= NF_INET_POST_ROUTING; i++) {
 		int tmp;
 
@@ -2566,6 +2544,12 @@ static void release_hook_list(struct list_head *hook_list)
 		basehook_free(hook);
 }
 
+static void warn_if_device(struct nft_ctx *nft, const char *devname)
+{
+	if (devname)
+		nft_print(&nft->output, "# device keyword (%s) unexpected for this family\n", devname);
+}
+
 int mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, int family, int hook, const char *devname)
 {
 	LIST_HEAD(hook_list);
@@ -2576,30 +2560,41 @@ int mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, int family, int hook, const c
 	switch (family) {
 	case NFPROTO_UNSPEC:
 		ret = mnl_nft_dump_nf_hooks(ctx, NFPROTO_ARP, hook, NULL);
-		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_INET, hook, devname);
+		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_INET, hook, NULL);
 		if (tmp == 0)
 			ret = 0;
 		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_BRIDGE, hook, NULL);
 		if (tmp == 0)
 			ret = 0;
-		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_NETDEV, hook, devname);
-		if (tmp == 0)
-			ret = 0;
+
+		if (devname) {
+			tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_NETDEV, hook, devname);
+			if (tmp == 0)
+				ret = 0;
+		}
 
 		return ret;
 	case NFPROTO_INET:
-		ret = mnl_nft_dump_nf_hooks(ctx, NFPROTO_IPV4, hook, devname);
-		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_IPV6, hook, devname);
+		ret = 0;
+		if (devname)
+			ret = __mnl_nft_dump_nf_hooks(ctx, family, NFPROTO_NETDEV,
+						      NF_NETDEV_INGRESS, devname, &hook_list);
+		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_IPV4, hook, NULL);
+		if (tmp == 0)
+			ret = 0;
+		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_IPV6, hook, NULL);
 		if (tmp == 0)
 			ret = 0;
 
-		return ret;
+		break;
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6:
 	case NFPROTO_BRIDGE:
+		warn_if_device(ctx->nft, devname);
 		ret = mnl_nft_dump_nf(ctx, family, hook, devname, &hook_list);
 		break;
 	case NFPROTO_ARP:
+		warn_if_device(ctx->nft, devname);
 		ret = mnl_nft_dump_nf_arp(ctx, family, hook, devname, &hook_list);
 		break;
 	case NFPROTO_NETDEV:
-- 
2.44.2

