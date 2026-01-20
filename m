Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4C1477E48;
	Tue, 20 Jan 2026 19:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768936714; cv=none; b=Q5A50XYGnXzZuX47WU9ML0afxVyRbj4TITRvAvG2JHp69cbsdW6NExewcRodSfI1EdvxCVRZozUz+0/HynX0PexOAOWx3lISw+717p3VuaF7PoKBH1IF4aMDILLRxnVemLejZkEjN1Q0v2b8mvsD0Gafz703yKn9tp2uDb0uoe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768936714; c=relaxed/simple;
	bh=3zIMelwwPQ/+GFOhvJNs/ebaBr4hWV1kO4NI9Jd/ScQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3ipimElhaNd23KiUcXDxzoNIqMz9YkawnJKtvzkPojsESvJ/9PqWnSRdJq2CBPB2ZaLfggPVcHvTFpJlg5QsbrH5bsOTYwZbSopjVDa75OJb01HNkbM0auC/3bGRn6ngtuuJZW7vOu0i/AMvRTD/Ag8jW6qx4P8Dse6XWPafOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E9F3B602AB; Tue, 20 Jan 2026 20:18:28 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 05/10] netfilter: don't include xt and nftables.h in unrelated subsystems
Date: Tue, 20 Jan 2026 20:17:58 +0100
Message-ID: <20260120191803.22208-6-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260120191803.22208-1-fw@strlen.de>
References: <20260120191803.22208-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

conntrack, xtables and nftables are distinct subsystems, don't use them
in other subystems.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/audit.h                      | 1 -
 include/net/netfilter/nf_conntrack_tuple.h | 2 +-
 include/net/netfilter/nf_tables.h          | 1 -
 net/bridge/netfilter/nf_conntrack_bridge.c | 3 +--
 net/netfilter/nf_conntrack_h323_main.c     | 1 +
 net/netfilter/nf_synproxy_core.c           | 1 +
 net/netfilter/nf_tables_api.c              | 1 +
 net/netfilter/nft_synproxy.c               | 1 +
 8 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 536f8ee8da81..14df25095e19 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -13,7 +13,6 @@
 #include <linux/ptrace.h>
 #include <linux/audit_arch.h>
 #include <uapi/linux/audit.h>
-#include <uapi/linux/netfilter/nf_tables.h>
 #include <uapi/linux/fanotify.h>
 
 #define AUDIT_INO_UNSET ((unsigned long)-1)
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index f7dd950ff250..4d55b7325707 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -11,7 +11,7 @@
 #ifndef _NF_CONNTRACK_TUPLE_H
 #define _NF_CONNTRACK_TUPLE_H
 
-#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 #include <linux/list_nulls.h>
 
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0e266c2d0e7f..2597077442e5 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -6,7 +6,6 @@
 #include <linux/list.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
-#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/rhashtable.h>
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 6482de4d8750..3b28b84191be 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -16,8 +16,7 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_bridge.h>
 
-#include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables.h>
+#include <linux/netfilter_ipv4.h>
 
 #include "../br_private.h"
 
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 14f73872f647..17f1f453d481 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -23,6 +23,7 @@
 #include <linux/skbuff.h>
 #include <net/route.h>
 #include <net/ip6_route.h>
+#include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
 
 #include <net/netfilter/nf_conntrack.h>
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 3fa3f5dfb264..57f57e2fc80a 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -10,6 +10,7 @@
 #include <net/netns/generic.h>
 #include <linux/proc_fs.h>
 
+#include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter/nf_synproxy.h>
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 027bab30c238..e7247363c643 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -14,6 +14,7 @@
 #include <linux/rhashtable.h>
 #include <linux/audit.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_flow_table.h>
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 4d3e5a31b412..b71ef18b0e8c 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -7,6 +7,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_synproxy.h>
 #include <net/netfilter/nf_synproxy.h>
+#include <linux/netfilter_ipv4.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_synproxy.h>
 
-- 
2.52.0

