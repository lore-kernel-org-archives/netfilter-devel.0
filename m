From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 37/37] netfilter: netns: shrink netns_ct struct
Date: Fri, 21 Dec 2018 01:28:41 +0100
Message-ID: <20181221002841.28587-38-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

remove the obsolete sysctl anchors and move auto_assign_helper_warned
to avoid/cover a hole.  Reduces size by 40 bytes on 64 bit.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/conntrack.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 9795d628a127..51cba0b8adf5 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -97,18 +97,14 @@ struct netns_ct {
 	struct delayed_work ecache_dwork;
 	bool ecache_dwork_pending;
 #endif
+	bool			auto_assign_helper_warned;
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*sysctl_header;
-	struct ctl_table_header	*acct_sysctl_header;
-	struct ctl_table_header	*tstamp_sysctl_header;
-	struct ctl_table_header	*event_sysctl_header;
-	struct ctl_table_header	*helper_sysctl_header;
 #endif
 	unsigned int		sysctl_log_invalid; /* Log invalid packets */
 	int			sysctl_events;
 	int			sysctl_acct;
 	int			sysctl_auto_assign_helper;
-	bool			auto_assign_helper_warned;
 	int			sysctl_tstamp;
 	int			sysctl_checksum;
 
-- 
2.11.0
