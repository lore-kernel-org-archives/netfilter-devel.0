From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/23] netfilter: x_tables: assert minimum target size
Date: Fri, 22 Apr 2016 15:39:36 +0200
Message-ID: <1461332394-3994-6-git-send-email-pablo@netfilter.org>
References: <1461332394-3994-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1461332394-3994-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The target size includes the size of the xt_entry_target struct.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 1f44bfa..ec1b718 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -568,6 +568,9 @@ int xt_check_entry_offsets(const void *base,
 		return -EINVAL;
 
 	t = (void *)(e + target_offset);
+	if (t->u.target_size < sizeof(*t))
+		return -EINVAL;
+
 	if (target_offset + t->u.target_size > next_offset)
 		return -EINVAL;
 
-- 
2.1.4
