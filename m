From: Colin King <colin.king@canonical.com>
Subject: [PATCH][V2] netfilter: remove redundant assignment to e
Date: Tue,  7 Nov 2017 10:08:01 +0000
Message-ID: <20171107100801.10056-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The assignment to variable e is redundant since the same assignment
occurs just a few lines later, hence it can be removed.  Cleans up
clang warning for arp_tables, ip_tables and ip6_tables:

warning: Value stored to 'e' is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/ipv4/netfilter/arp_tables.c | 1 -
 net/ipv4/netfilter/ip_tables.c  | 1 -
 net/ipv6/netfilter/ip6_tables.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index f88221aebc9d..0c3c944a7b72 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -373,7 +373,6 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
 						return 0;
-					e = entry0 + newpos;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 4cbe5e80f3bf..2e0d339028bb 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -439,7 +439,6 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
 						return 0;
-					e = entry0 + newpos;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index f06e25065a34..1d7ae9366335 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -458,7 +458,6 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
 						return 0;
-					e = entry0 + newpos;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
-- 
2.14.1
