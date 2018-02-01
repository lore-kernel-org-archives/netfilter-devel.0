From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/6] netfilter: x_tables: fix int overflow in xt_alloc_table_info()
Date: Thu,  1 Feb 2018 19:02:12 +0100
Message-ID: <20180201180217.24356-2-pablo@netfilter.org>
References: <20180201180217.24356-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180201180217.24356-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Dmitry Vyukov <dvyukov@google.com>

syzkaller triggered OOM kills by passing ipt_replace.size = -1
to IPT_SO_SET_REPLACE. The root cause is that SMP_ALIGN() in
xt_alloc_table_info() causes int overflow and the size check passes
when it should not. SMP_ALIGN() is no longer needed leftover.

Remove SMP_ALIGN() call in xt_alloc_table_info().

Reported-by: syzbot+4396883fa8c4f64e0175@syzkaller.appspotmail.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 55802e97f906..e02a21549c99 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -39,7 +39,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("{ip,ip6,arp,eb}_tables backend module");
 
-#define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
 #define XT_PCPU_BLOCK_SIZE 4096
 
 struct compat_delta {
@@ -1000,7 +999,7 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
 		return NULL;
 
 	/* Pedantry: prevent them from hitting BUG() in vmalloc.c --RR */
-	if ((SMP_ALIGN(size) >> PAGE_SHIFT) + 2 > totalram_pages)
+	if ((size >> PAGE_SHIFT) + 2 > totalram_pages)
 		return NULL;
 
 	info = kvmalloc(sz, GFP_KERNEL);
-- 
2.11.0
