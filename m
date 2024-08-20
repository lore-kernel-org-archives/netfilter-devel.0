Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042761C7B69
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 22:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724192024; cv=none; b=HvEr+qFMzLt9dji4lmp6FYsoWPUAlBbrsspMB49+QkiDN48UXgDskoaajQ0q6QGil0MnYgC5D1bM1//3EF21jEXarp7EYHLYCrEOOl5tayZXD2bs/pJ6xcmz7E1nOlHzFpl5rFZflrDQv/vEaAigzDJoqq5iJEvc1nDcyiFy08k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724192024; c=relaxed/simple;
	bh=2H+Lz2XQG4LH8RWfuiFrHl0ERWVV2LWXN4rpuoSmdkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhoiU+Vkanqw8DhnliEyLK2ZXudbn0Z9SggE/9gqNjx4rvI3rMplLKRkTkv/uo4fRCxc0UwmTEXTfzpd0lJw2t8u8lLU8opT28LHbM0eDCHa0WDWqdyEkF3uDeMj3/6zFa8d5ZJbdRa5lc+hCpWaHUqzyAxWb92gGH4asWTkgj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sgX6i-0002Mz-6z; Wed, 21 Aug 2024 00:13:40 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] src: mnl: always dump all netdev hooks if no interface name was given
Date: Wed, 21 Aug 2024 00:12:27 +0200
Message-ID: <20240820221230.7014-3-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240820221230.7014-1-fw@strlen.de>
References: <20240820221230.7014-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of not returning any results for
  nft list hooks netdev

Iterate all interfaces and then query all of them.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/additional-commands.txt |  8 ++++----
 include/iface.h             |  2 ++
 src/iface.c                 | 17 +++++++++++++++++
 src/mnl.c                   | 29 ++++++++++++++++++++++-------
 4 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/doc/additional-commands.txt b/doc/additional-commands.txt
index 9ad338f8c7d1..0f96fc354007 100644
--- a/doc/additional-commands.txt
+++ b/doc/additional-commands.txt
@@ -8,13 +8,13 @@ registered implicitly by kernel modules such as nf_conntrack. +
 [verse]
 ____
 *list hooks* ['family']
-*list hooks netdev device* 'DEVICE_NAME'
+*list hooks netdev  [ device* 'DEVICE_NAME' ]
 ____
 
 *list hooks* is enough to display everything that is active
-on the system, however, it does currently omit hooks that are
-tied to a specific network device (netdev family). To obtain
-those, the network device needs to be queried by name.
+on the system.  Hooks in the netdev family are tied to a network
+device.  If no device name is given, nft will query all network
+devices in the current network namespace.
 Example Usage:
 
 .List all active netfilter hooks in either the ip or ip6 stack
diff --git a/include/iface.h b/include/iface.h
index f41ee8be6c89..786b1dfc8f8f 100644
--- a/include/iface.h
+++ b/include/iface.h
@@ -2,6 +2,7 @@
 #define _NFTABLES_IFACE_H_
 
 #include <net/if.h>
+#include <list.h>
 
 struct iface {
 	struct list_head	list;
@@ -15,4 +16,5 @@ char *nft_if_indextoname(unsigned int ifindex, char *name);
 void iface_cache_update(void);
 void iface_cache_release(void);
 
+const struct iface *iface_cache_get_next_entry(const struct iface *prev);
 #endif
diff --git a/src/iface.c b/src/iface.c
index 428acaae2eac..a85341a1703a 100644
--- a/src/iface.c
+++ b/src/iface.c
@@ -171,3 +171,20 @@ char *nft_if_indextoname(unsigned int ifindex, char *name)
 	}
 	return NULL;
 }
+
+const struct iface *iface_cache_get_next_entry(const struct iface *prev)
+{
+	if (!iface_cache_init)
+		iface_cache_update();
+
+	if (list_empty(&iface_list))
+		return NULL;
+
+	if (!prev)
+		return list_first_entry(&iface_list, struct iface, list);
+
+	if (list_is_last(&prev->list, &iface_list))
+		return NULL;
+
+	return list_next_entry(prev, list);
+}
diff --git a/src/mnl.c b/src/mnl.c
index e585241d9395..12e145204ef5 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -9,6 +9,7 @@
  */
 
 #include <nft.h>
+#include <iface.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/common.h>
@@ -2205,7 +2206,7 @@ static void basehook_list_add_tail(struct basehook *b, struct list_head *head)
 	list_for_each_entry(hook, head, list) {
 		if (hook->family != b->family)
 			continue;
-		if (hook->num != b->num)
+		if (!basehook_eq(hook, b))
 			continue;
 		if (hook->prio < b->prio)
 			continue;
@@ -2591,11 +2592,9 @@ int mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, int family, const char *devna
 		if (tmp == 0)
 			ret = 0;
 
-		if (devname) {
-			tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_NETDEV, devname);
-			if (tmp == 0)
-				ret = 0;
-		}
+		tmp = mnl_nft_dump_nf_hooks(ctx, NFPROTO_NETDEV, devname);
+		if (tmp == 0)
+			ret = 0;
 
 		return ret;
 	case NFPROTO_INET:
@@ -2622,7 +2621,23 @@ int mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, int family, const char *devna
 		ret = mnl_nft_dump_nf_arp(ctx, family, devname, &hook_list);
 		break;
 	case NFPROTO_NETDEV:
-		ret = mnl_nft_dump_nf_netdev(ctx, family, devname, &hook_list);
+		if (devname) {
+			ret = mnl_nft_dump_nf_netdev(ctx, family, devname, &hook_list);
+		} else {
+			const struct iface *iface;
+
+			iface = iface_cache_get_next_entry(NULL);
+			ret = 0;
+
+			while (iface) {
+				tmp = mnl_nft_dump_nf_netdev(ctx, family, iface->name, &hook_list);
+				if (tmp == 0)
+					ret = 0;
+
+				iface = iface_cache_get_next_entry(iface);
+			}
+		}
+
 		break;
 	}
 
-- 
2.44.2

