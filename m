From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2] netfilter: properly initialize xt_table_info structure
Date: Thu, 17 May 2018 11:34:10 +0200
Message-ID: <20180517093410.GB17597@kroah.com>
References: <20180517084442.GA23981@kroah.com>
 <20180517085951.2wxvcg5herkjaxda@unicorn.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michal Kubecek <mkubecek@suse.cz>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180517085951.2wxvcg5herkjaxda@unicorn.suse.cz>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

When allocating a xt_table_info structure, we should be clearing out the
full amount of memory that was allocated, not just the "header" of the
structure.  Otherwise odd values could be passed to userspace, which is
not a good thing.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2: use kvzalloc instead of kvmalloc/memset pair, as suggested by Michal Kubecek

 net/netfilter/x_tables.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index cb7cb300c3bc..cd22bb9b66f3 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1183,11 +1183,10 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
 	 * than shoot all processes down before realizing there is nothing
 	 * more to reclaim.
 	 */
-	info = kvmalloc(sz, GFP_KERNEL | __GFP_NORETRY);
+	info = kvzalloc(sz, GFP_KERNEL | __GFP_NORETRY);
 	if (!info)
 		return NULL;
 
-	memset(info, 0, sizeof(*info));
 	info->size = size;
 	return info;
 }
-- 
2.17.0
