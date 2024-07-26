Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D1B1BC46
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2024 02:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721959204; cv=none; b=Rnsp3vXyksv4vtvrTgM3qAHBobmddtnFQ5UdGB2m+PzrGBtE6yFEN5P5sWPxIiVEOOa4rzP3O+YlRW/ZZPbGpmzFclpWOGrcNrC1EzjI/LayfMwKZW15QCrlLG3iLRKXEQQtXq5TBCFWokR2kodWgQQ/r6oyJ5SsSMd9rEUT7UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721959204; c=relaxed/simple;
	bh=qLVc87/jibDzuasr6cp5AgYsmgRt4f+NyIiazLHon3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmRz08BtLPugH7o/fZ0pmhaLzl/X8/rJCrpHkOljMxWime4xHxciGjV4Pz+L4IpcP/yDA6bm0pgWfjIlQWF5nPOQS7Q2EiND5XDufECbmTetYf9H/rkN1GRPzTAvEFzpo6OIN7GxBzn9eyZYshiqusmXbSF/fi+uvkXGxbGfV10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sXAFU-0004IQ-Qh; Fri, 26 Jul 2024 04:00:00 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/4] src: remove decnet support
Date: Fri, 26 Jul 2024 03:58:29 +0200
Message-ID: <20240726015837.14572-3-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240726015837.14572-1-fw@strlen.de>
References: <20240726015837.14572-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Removed 2 years ago with v6.1, so we can ditch this from
hook list code too.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Makefile.am                      |  1 -
 include/linux/netfilter_decnet.h | 72 --------------------------------
 src/mnl.c                        | 27 ------------
 3 files changed, 100 deletions(-)
 delete mode 100644 include/linux/netfilter_decnet.h

diff --git a/Makefile.am b/Makefile.am
index ef198dafcbc8..fb64105dda88 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -57,7 +57,6 @@ noinst_HEADERS = \
 	include/linux/netfilter_arp/arp_tables.h \
 	include/linux/netfilter_bridge.h \
 	include/linux/netfilter_bridge/ebtables.h \
-	include/linux/netfilter_decnet.h \
 	include/linux/netfilter_ipv4.h \
 	include/linux/netfilter_ipv4/ip_tables.h \
 	include/linux/netfilter_ipv6.h \
diff --git a/include/linux/netfilter_decnet.h b/include/linux/netfilter_decnet.h
deleted file mode 100644
index ca70c6cd8ef9..000000000000
--- a/include/linux/netfilter_decnet.h
+++ /dev/null
@@ -1,72 +0,0 @@
-#ifndef __LINUX_DECNET_NETFILTER_H
-#define __LINUX_DECNET_NETFILTER_H
-
-/* DECnet-specific defines for netfilter. 
- * This file (C) Steve Whitehouse 1999 derived from the
- * ipv4 netfilter header file which is
- * (C)1998 Rusty Russell -- This code is GPL.
- */
-
-#include <linux/netfilter.h>
-
-/* only for userspace compatibility */
-/* IP Cache bits. */
-/* Src IP address. */
-#define NFC_DN_SRC		0x0001
-/* Dest IP address. */
-#define NFC_DN_DST		0x0002
-/* Input device. */
-#define NFC_DN_IF_IN		0x0004
-/* Output device. */
-#define NFC_DN_IF_OUT		0x0008
-
-/* DECnet Hooks */
-/* After promisc drops, checksum checks. */
-#define NF_DN_PRE_ROUTING	0
-/* If the packet is destined for this box. */
-#define NF_DN_LOCAL_IN		1
-/* If the packet is destined for another interface. */
-#define NF_DN_FORWARD		2
-/* Packets coming from a local process. */
-#define NF_DN_LOCAL_OUT		3
-/* Packets about to hit the wire. */
-#define NF_DN_POST_ROUTING	4
-/* Input Hello Packets */
-#define NF_DN_HELLO		5
-/* Input Routing Packets */
-#define NF_DN_ROUTE		6
-#define NF_DN_NUMHOOKS		7
-
-enum nf_dn_hook_priorities {
-	NF_DN_PRI_FIRST = INT_MIN,
-	NF_DN_PRI_CONNTRACK = -200,
-	NF_DN_PRI_MANGLE = -150,
-	NF_DN_PRI_NAT_DST = -100,
-	NF_DN_PRI_FILTER = 0,
-	NF_DN_PRI_NAT_SRC = 100,
-	NF_DN_PRI_DNRTMSG = 200,
-	NF_DN_PRI_LAST = INT_MAX,
-};
-
-struct nf_dn_rtmsg {
-	int nfdn_ifindex;
-};
-
-#define NFDN_RTMSG(r) ((unsigned char *)(r) + NLMSG_ALIGN(sizeof(struct nf_dn_rtmsg)))
-
-/* backwards compatibility for userspace */
-#define DNRMG_L1_GROUP 0x01
-#define DNRMG_L2_GROUP 0x02
-
-enum {
-	DNRNG_NLGRP_NONE,
-#define DNRNG_NLGRP_NONE	DNRNG_NLGRP_NONE
-	DNRNG_NLGRP_L1,
-#define DNRNG_NLGRP_L1		DNRNG_NLGRP_L1
-	DNRNG_NLGRP_L2,
-#define DNRNG_NLGRP_L2		DNRNG_NLGRP_L2
-	__DNRNG_NLGRP_MAX
-};
-#define DNRNG_NLGRP_MAX	(__DNRNG_NLGRP_MAX - 1)
-
-#endif /*__LINUX_DECNET_NETFILTER_H*/
diff --git a/src/mnl.c b/src/mnl.c
index 9e4bfcd9a030..ec7d2bd5defc 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -2581,29 +2581,6 @@ static int mnl_nft_dump_nf_netdev(struct netlink_ctx *ctx, int family, int hook,
 	return err;
 }
 
-static int mnl_nft_dump_nf_decnet(struct netlink_ctx *ctx, int family, int hook,
-				  const char *devname, struct list_head *hook_list,
-				  int *ret)
-{
-	int i, err;
-
-	/* show ingress in first place in hook listing. */
-	err = __mnl_nft_dump_nf_hooks(ctx, family, NFPROTO_NETDEV, NF_NETDEV_INGRESS, devname, hook_list);
-	if (err < 0)
-		*ret = err;
-
-#define NF_DN_NUMHOOKS		7
-	for (i = 0; i < NF_DN_NUMHOOKS; i++) {
-		err = __mnl_nft_dump_nf_hooks(ctx, family, family, i, devname, hook_list);
-		if (err < 0) {
-			*ret = err;
-			return err;
-		}
-	}
-
-	return err;
-}
-
 static void release_hook_list(struct list_head *hook_list)
 {
 	struct basehook *hook, *next;
@@ -2626,7 +2603,6 @@ int mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, int family, int hook, const c
 		mnl_nft_dump_nf(ctx, NFPROTO_IPV4, hook, devname, &hook_list, &ret);
 		mnl_nft_dump_nf(ctx, NFPROTO_IPV6, hook, devname, &hook_list, &ret);
 		mnl_nft_dump_nf(ctx, NFPROTO_BRIDGE, hook, devname, &hook_list, &ret);
-		mnl_nft_dump_nf_decnet(ctx, NFPROTO_DECNET, hook, devname, &hook_list, &ret);
 		break;
 	case NFPROTO_INET:
 		mnl_nft_dump_nf(ctx, NFPROTO_IPV4, hook, devname, &hook_list, &ret);
@@ -2643,9 +2619,6 @@ int mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, int family, int hook, const c
 	case NFPROTO_NETDEV:
 		mnl_nft_dump_nf_netdev(ctx, family, hook, devname, &hook_list, &ret);
 		break;
-	case NFPROTO_DECNET:
-		mnl_nft_dump_nf_decnet(ctx, family, hook, devname, &hook_list, &ret);
-		break;
 	}
 
 	switch (family) {
-- 
2.44.2

