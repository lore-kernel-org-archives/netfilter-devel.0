From: kaber@trash.net
Subject: [PATCH 2/6] netfilter: ip_tables: fix compile with debug
Date: Thu, 16 Jun 2011 21:41:37 +0200
Message-ID: <1308253301-29894-3-git-send-email-kaber@trash.net>
References: <1308253301-29894-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1308253301-29894-1-git-send-email-kaber@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/ipv4/netfilter/ip_tables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 7647438..24e556e 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -566,7 +566,7 @@ check_entry(const struct ipt_entry *e, const char *name)
 	const struct xt_entry_target *t;
 
 	if (!ip_checkentry(&e->ip)) {
-		duprintf("ip check failed %p %s.\n", e, par->match->name);
+		duprintf("ip check failed %p %s.\n", e, name);
 		return -EINVAL;
 	}
 
-- 
1.7.2.3

