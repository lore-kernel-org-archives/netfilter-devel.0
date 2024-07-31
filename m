Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F2E1B140E
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 17:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722445762; cv=none; b=aNOcWpYQ3avYVlBNEmoFvmH15x3FKKzDOUbs5w6cqlmLX9XNr9bPZ6CjVKRz24/2RTSlRGbj+/sKrGaNQ0eKai037o/qvP1+QUsgHl+z5rH8QnSeocDVl2xaSL5FoFC1zFcQEfVxpyvo5OYwrHJpvZWu5tNckSpvTZb3jZY2TWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722445762; c=relaxed/simple;
	bh=q3/dbKuBZcdbbKoRJwP3uKyfbWbuxGKjzl56JRDpU54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoO0icB+xZ9L5YKn98Onl/V3lcEHmuBI4gpxP+M2lyrDR4Z/CGXWiY8muhHHDmUyxOdQ3y6uOUO5plqui7GOduTPxEC+hZpYASocVEpfyFRJfy6g+neXMQ5UlrkDqxmgvoVWzP+nRvQkZil0lB4A86mIM4c+kGjr7F3OFUvc/AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sZCp6-0006y1-KQ; Wed, 31 Jul 2024 19:09:12 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2 1/5] src: mnl: clean up hook listing code
Date: Wed, 31 Jul 2024 18:51:01 +0200
Message-ID: <20240731165111.32166-2-fw@strlen.de>
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

mnl_nft_dump_nf_hooks() can call itself for the UNSPEC case, this
avoids the second switch/case to handle printing for inet/unspec.

As for the error handling, 'nft list hooks' should not print an error,
even if nothing is printed, UNLESS there was also a lowlevel (syscall)
error from the kernel.

We don't want to indicate failure just because e.g. kernel doesn't support
NFPROTO_ARP.

This also fixes a display bug, 'nft list hooks device foo' would show hooks
registered for that device as 'bridge' family instead of the expected
'netdev' family.

This was because UNSPEC handling did not query 'netdev' family and did
pass the device name to the lowlevel function.  Add it, and pass NULL
device name for those families that don't support device attachment.

The lowelevel function currently always queries NFPROTO_NETDEV to handle
the 'inet' ingress case.

This is dubious, as 'inet ingress' is a pseudo-alias to netdev family
(inet itself is a pseudo-family that ends up registering for both ipv4
 and ipv6 hooks).

This is resolved in next patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/mnl.c | 98 ++++++++++++++++++++-----------------------------------
 1 file changed, 35 insertions(+), 63 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index ec7d2bd5defc..e4bbbcf6d536 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -2518,65 +2518,42 @@ static void print_hooks(struct netlink_ctx *ctx, int family, struct list_head *h
 	fprintf(fp, "}\n");
 }
 
-#define HOOK_FAMILY_MAX	5
-
-static uint8_t hook_family[HOOK_FAMILY_MAX] = {
-	NFPROTO_IPV4,
-	NFPROTO_IPV6,
-	NFPROTO_BRIDGE,
-	NFPROTO_ARP,
-};
-
 static int mnl_nft_dump_nf(struct netlink_ctx *ctx, int family, int hook,
-			   const char *devname, struct list_head *hook_list,
-			   int *ret)
+			   const char *devname, struct list_head *hook_list)
 {
 	int i, err;
 
 	/* show ingress in first place in hook listing. */
 	err = __mnl_nft_dump_nf_hooks(ctx, family, NFPROTO_NETDEV, NF_NETDEV_INGRESS, devname, hook_list);
-	if (err < 0)
-		*ret = err;
 
 	for (i = 0; i <= NF_INET_POST_ROUTING; i++) {
-		err = __mnl_nft_dump_nf_hooks(ctx, family, family, i, devname, hook_list);
-		if (err < 0)
-			*ret = err;
+		int tmp;
+
+		tmp = __mnl_nft_dump_nf_hooks(ctx, family, family, i, devname, hook_list);
+		if (tmp == 0)
+			err = 0;
 	}
 
 	return err;
 }
 
 static int mnl_nft_dump_nf_arp(struct netlink_ctx *ctx, int family, int hook,
-			       const char *devname, struct list_head *hook_list,
-			       int *ret)
+			       const char *devname, struct list_head *hook_list)
 {
-	int err;
-
-	/* show ingress in first place in hook listing. */
-	err = __mnl_nft_dump_nf_hooks(ctx, family, NFPROTO_NETDEV, NF_NETDEV_INGRESS, devname, hook_list);
-	if (err < 0)
-		*ret = err;
+	int err1, err2;
 
-	err = __mnl_nft_dump_nf_hooks(ctx, family, family, NF_ARP_IN, devname, hook_list);
-	if (err < 0)
-		*ret = err;
-	err = __mnl_nft_dump_nf_hooks(ctx, family, family, NF_ARP_OUT, devname, hook_list);
-	if (err < 0)
-		*ret = err;
+	err1 = __mnl_nft_dump_nf_hooks(ctx, family, family, NF_ARP_IN, devname, hook_list);
+	err2 = __mnl_nft_dump_nf_hooks(ctx, family, family, NF_ARP_OUT, devname, hook_list);
 
-	return err;
+	return err1 ? err2 : err1;
 }
 
 static int mnl_nft_dump_nf_netdev(struct netlink_ctx *ctx, int family, int hook,
-				  const char *devname, struct list_head *hook_list,
-				  int *ret)
+				  const char *devname, struct list_head *hook_list)
 {
 	int err;
 
 	err = __mnl_nft_dump_nf_hooks(ctx, family, NFPROTO_NETDEV, NF_NETDEV_INGRESS, devname, hook_list);
-	if (err < 0)
-		*ret = err;
 
 	return err;
 }
@@ -2592,51 +2569,46 @@ static void release_hook_list(struct list_head *hook_list)
 int mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, int family, int hook, const char *devname)
 {
 	LIST_HEAD(hook_list);
-	unsigned int i;
-	int ret;
+	int ret = -1, tmp;
 
 	errno = 0;
-	ret = 0;
 
 	switch (family) {
 	case NFPROTO_UNSPEC:
-		mnl_nft_dump_nf(ctx, NFPROTO_IPV4, hook, devname, &hook_list, &ret);
-		mnl_nft_dump_nf(ctx, NFPROTO_IPV6, hook, devname, &hook_list, &ret);
-		mnl_nft_dump_nf(ctx, NFPROTO_BRIDGE, hook, devname, &hook_list, &ret);
-		break;
+		ret = mnl_nft_dump_nf_hooks(ctx, NFPROTO_ARP, hook, NULL);
+		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_INET, hook, devname);
+		if (tmp == 0)
+			ret = 0;
+		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_BRIDGE, hook, NULL);
+		if (tmp == 0)
+			ret = 0;
+		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_NETDEV, hook, devname);
+		if (tmp == 0)
+			ret = 0;
+
+		return ret;
 	case NFPROTO_INET:
-		mnl_nft_dump_nf(ctx, NFPROTO_IPV4, hook, devname, &hook_list, &ret);
-		mnl_nft_dump_nf(ctx, NFPROTO_IPV6, hook, devname, &hook_list, &ret);
-		break;
+		ret = mnl_nft_dump_nf_hooks(ctx, NFPROTO_IPV4, hook, devname);
+		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_IPV6, hook, devname);
+		if (tmp == 0)
+			ret = 0;
+
+		return ret;
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6:
 	case NFPROTO_BRIDGE:
-		mnl_nft_dump_nf(ctx, family, hook, devname, &hook_list, &ret);
+		ret = mnl_nft_dump_nf(ctx, family, hook, devname, &hook_list);
 		break;
 	case NFPROTO_ARP:
-		mnl_nft_dump_nf_arp(ctx, family, hook, devname, &hook_list, &ret);
+		ret = mnl_nft_dump_nf_arp(ctx, family, hook, devname, &hook_list);
 		break;
 	case NFPROTO_NETDEV:
-		mnl_nft_dump_nf_netdev(ctx, family, hook, devname, &hook_list, &ret);
-		break;
-	}
-
-	switch (family) {
-	case NFPROTO_UNSPEC:
-		for (i = 0; i < HOOK_FAMILY_MAX; i++)
-			print_hooks(ctx, hook_family[i], &hook_list);
-		break;
-	case NFPROTO_INET:
-		print_hooks(ctx, NFPROTO_IPV4, &hook_list);
-		print_hooks(ctx, NFPROTO_IPV6, &hook_list);
-		break;
-	default:
-		print_hooks(ctx, family, &hook_list);
+		ret = mnl_nft_dump_nf_netdev(ctx, family, hook, devname, &hook_list);
 		break;
 	}
 
+	print_hooks(ctx, family, &hook_list);
 	release_hook_list(&hook_list);
-	ret = 0;
 
 	return ret;
 }
-- 
2.44.2

