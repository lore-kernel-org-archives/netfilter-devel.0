Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9387B1B140E
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 17:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722445764; cv=none; b=oOohtukZbuO5ZzvdokRL9SBFaLpsGoNuC3NTUp7QesVBbvUuTgiANP+O8z3key63qay5pnsk2H+wwjRl/swz4swrc39C8PG7JzQeq6uYj3LChjD+kR8GfriNgfxaQGGhFMQKxhv6K8siQA/T+MFH8WMjgOZ8LjnET+aVF2F6dsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722445764; c=relaxed/simple;
	bh=KM5o8XRuAZbYRTPOCkP0/esRLYeu8uINnz1JTpcXN3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIZbv2PUEVwF83V9/O5Qz6oViZMkFKQHSQYGV4WOUM+ChlDnzcXqRGAd4guMniurn4x8VubdL7RWqTi4BO0Fe+SzYxdmJ+R/vuvkPh/n6+h1ROi6eMUV0sXPAtMuR1I8+aorbPi0b65d7Pmwit615/uHiKMGC4BGI/XATc+o8M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sZCpE-0006yL-Pr; Wed, 31 Jul 2024 19:09:20 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2 3/5] src: drop obsolete hook argument form hook dump functions
Date: Wed, 31 Jul 2024 18:51:03 +0200
Message-ID: <20240731165111.32166-4-fw@strlen.de>
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

since commit b98fee20bfe2 ("mnl: revisit hook listing"), handle.chain is
never set in this path, so 'hook' is always set to -1, so the hook arg
can be dropped.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/mnl.h |  2 +-
 src/mnl.c     | 26 +++++++++++++-------------
 src/rule.c    |  6 +-----
 3 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index cd5a2053b166..c9502f328f1c 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -90,7 +90,7 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			  unsigned int flags);
 int mnl_nft_flowtable_del(struct netlink_ctx *ctx, struct cmd *cmd);
 
-int mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, int family, int hook,
+int mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, int family,
 			  const char *devname);
 
 int mnl_nft_event_listener(struct mnl_socket *nf_sock, unsigned int debug_mask,
diff --git a/src/mnl.c b/src/mnl.c
index 88475ef4c25e..1b424e427124 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -2499,7 +2499,7 @@ static void print_hooks(struct netlink_ctx *ctx, int family, struct list_head *h
 	fprintf(fp, "}\n");
 }
 
-static int mnl_nft_dump_nf(struct netlink_ctx *ctx, int family, int hook,
+static int mnl_nft_dump_nf(struct netlink_ctx *ctx, int family,
 			   const char *devname, struct list_head *hook_list)
 {
 	int i, err;
@@ -2515,7 +2515,7 @@ static int mnl_nft_dump_nf(struct netlink_ctx *ctx, int family, int hook,
 	return err;
 }
 
-static int mnl_nft_dump_nf_arp(struct netlink_ctx *ctx, int family, int hook,
+static int mnl_nft_dump_nf_arp(struct netlink_ctx *ctx, int family,
 			       const char *devname, struct list_head *hook_list)
 {
 	int err1, err2;
@@ -2526,7 +2526,7 @@ static int mnl_nft_dump_nf_arp(struct netlink_ctx *ctx, int family, int hook,
 	return err1 ? err2 : err1;
 }
 
-static int mnl_nft_dump_nf_netdev(struct netlink_ctx *ctx, int family, int hook,
+static int mnl_nft_dump_nf_netdev(struct netlink_ctx *ctx, int family,
 				  const char *devname, struct list_head *hook_list)
 {
 	int err;
@@ -2550,7 +2550,7 @@ static void warn_if_device(struct nft_ctx *nft, const char *devname)
 		nft_print(&nft->output, "# device keyword (%s) unexpected for this family\n", devname);
 }
 
-int mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, int family, int hook, const char *devname)
+int mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, int family, const char *devname)
 {
 	LIST_HEAD(hook_list);
 	int ret = -1, tmp;
@@ -2559,16 +2559,16 @@ int mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, int family, int hook, const c
 
 	switch (family) {
 	case NFPROTO_UNSPEC:
-		ret = mnl_nft_dump_nf_hooks(ctx, NFPROTO_ARP, hook, NULL);
-		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_INET, hook, NULL);
+		ret = mnl_nft_dump_nf_hooks(ctx, NFPROTO_ARP, NULL);
+		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_INET, NULL);
 		if (tmp == 0)
 			ret = 0;
-		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_BRIDGE, hook, NULL);
+		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_BRIDGE, NULL);
 		if (tmp == 0)
 			ret = 0;
 
 		if (devname) {
-			tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_NETDEV, hook, devname);
+			tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_NETDEV, devname);
 			if (tmp == 0)
 				ret = 0;
 		}
@@ -2579,10 +2579,10 @@ int mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, int family, int hook, const c
 		if (devname)
 			ret = __mnl_nft_dump_nf_hooks(ctx, family, NFPROTO_NETDEV,
 						      NF_NETDEV_INGRESS, devname, &hook_list);
-		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_IPV4, hook, NULL);
+		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_IPV4, NULL);
 		if (tmp == 0)
 			ret = 0;
-		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_IPV6, hook, NULL);
+		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_IPV6, NULL);
 		if (tmp == 0)
 			ret = 0;
 
@@ -2591,14 +2591,14 @@ int mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, int family, int hook, const c
 	case NFPROTO_IPV6:
 	case NFPROTO_BRIDGE:
 		warn_if_device(ctx->nft, devname);
-		ret = mnl_nft_dump_nf(ctx, family, hook, devname, &hook_list);
+		ret = mnl_nft_dump_nf(ctx, family, devname, &hook_list);
 		break;
 	case NFPROTO_ARP:
 		warn_if_device(ctx->nft, devname);
-		ret = mnl_nft_dump_nf_arp(ctx, family, hook, devname, &hook_list);
+		ret = mnl_nft_dump_nf_arp(ctx, family, devname, &hook_list);
 		break;
 	case NFPROTO_NETDEV:
-		ret = mnl_nft_dump_nf_netdev(ctx, family, hook, devname, &hook_list);
+		ret = mnl_nft_dump_nf_netdev(ctx, family, devname, &hook_list);
 		break;
 	}
 
diff --git a/src/rule.c b/src/rule.c
index 545f9b2b5463..0f92ef532ece 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2341,12 +2341,8 @@ static int do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
 static int do_list_hooks(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	const char *devname = cmd->handle.obj.name;
-	int hooknum = -1;
 
-	if (cmd->handle.chain.name)
-		hooknum = cmd->handle.chain_id;
-
-	return mnl_nft_dump_nf_hooks(ctx, cmd->handle.family, hooknum, devname);
+	return mnl_nft_dump_nf_hooks(ctx, cmd->handle.family, devname);
 }
 
 static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
-- 
2.44.2

