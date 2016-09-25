From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/53] netfilter: ftp: Remove the useless code
Date: Mon, 26 Sep 2016 01:06:16 +0200
Message-ID: <1474844823-2026-7-git-send-email-pablo@netfilter.org>
References: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Gao Feng <fgao@ikuai8.com>

There are some debug code which are commented out in find_pattern by #if 0.
Now remove them.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_ftp.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index d49a2d410813..e3ed20060878 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -309,19 +309,8 @@ static int find_pattern(const char *data, size_t dlen,
 		else return 0;
 	}
 
-	if (strncasecmp(data, pattern, plen) != 0) {
-#if 0
-		size_t i;
-
-		pr_debug("ftp: string mismatch\n");
-		for (i = 0; i < plen; i++) {
-			pr_debug("ftp:char %u `%c'(%u) vs `%c'(%u)\n",
-				 i, data[i], data[i],
-				 pattern[i], pattern[i]);
-		}
-#endif
+	if (strncasecmp(data, pattern, plen) != 0)
 		return 0;
-	}
 
 	pr_debug("Pattern matches!\n");
 	/* Now we've found the constant string, try to skip
-- 
2.1.4
