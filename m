From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] netfilter: properly initialize xt_table_info structure
Date: Thu, 17 May 2018 10:44:42 +0200
Message-ID: <20180517084442.GA23981@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

When allocating a xt_table_info structure, we should be clearing out the
full amount of memory that was allocated, not just the "header" of the
structure.  Otherwise odd values could be passed to userspace, which is
not a good thing.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/x_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index cb7cb300c3bc..a300e8252bb6 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1187,7 +1187,7 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
 	if (!info)
 		return NULL;
 
-	memset(info, 0, sizeof(*info));
+	memset(info, 0, sz);
 	info->size = size;
 	return info;
 }
-- 
2.17.0
