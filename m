Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAC4363C6D;
	Wed,  7 Jan 2026 15:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767799572; cv=none; b=KdWQUiFk7yglLhADWa7FI2pvIR+eBA+CcRg86olHOX1GBgdvxV7bk66qayzko81NsdQrp/t5ptATtOwb0YuHbt9u5AM6HTQP5hgAR8kwJatlh+UAR4DTJZjMOejqALBAERhkz1DeesFUrVC31RtnNuQeAZHLpKpB2jLjYcf/IK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767799572; c=relaxed/simple;
	bh=4tlw2ZrHL7ioVxXGuUPVlPiwyqnTn0tbuztktX8L+EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gnmo5h4z6nDrwRCRABu20AeIMn818NwVf65nO/AgUb/dUvVwSYzAlYu39jkOpnE+rznY1k/J0D9CgIL/lVwgfPoGC5U4GffIF8ScVnjeZztvHTa98Cs8hVnmhsruYh/DNsW8Ru7hu0wny3h/iSbZvZr5GUtrdDQG/HZ5jabWv1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7AC0D602A9; Wed, 07 Jan 2026 16:26:07 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: jhs@mojatatu.com,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	audit@vger.kernel.org,
	bridge@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: don't include xt and nftables.h in unrelated subsystems
Date: Wed,  7 Jan 2026 16:24:09 +0100
Message-ID: <20260107152548.31769-3-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107152548.31769-1-fw@strlen.de>
References: <20260107152548.31769-1-fw@strlen.de>
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
index e76af31f6a61..cb606eeadeed 100644
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
index 5d3e51825985..84d6c79ad889 100644
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

