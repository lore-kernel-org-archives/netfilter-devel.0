From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/12] netfilter: ebtables: don't attempt to allocate 0-sized compat array
Date: Mon, 23 Apr 2018 19:57:05 +0200
Message-ID: <20180423175714.9794-4-pablo@netfilter.org>
References: <20180423175714.9794-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180423175714.9794-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Dmitry reports 32bit ebtables on 64bit kernel got broken by
a recent change that returns -EINVAL when ruleset has no entries.

ebtables however only counts user-defined chains, so for the
initial table nentries will be 0.

Don't try to allocate the compat array in this case, as no user
defined rules exist no rule will need 64bit translation.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Fixes: 7d7d7e02111e9 ("netfilter: compat: reject huge allocation requests")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 032e0fe45940..28a4c3490359 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1825,13 +1825,14 @@ static int compat_table_info(const struct ebt_table_info *info,
 {
 	unsigned int size = info->entries_size;
 	const void *entries = info->entries;
-	int ret;
 
 	newinfo->entries_size = size;
-
-	ret = xt_compat_init_offsets(NFPROTO_BRIDGE, info->nentries);
-	if (ret)
-		return ret;
+	if (info->nentries) {
+		int ret = xt_compat_init_offsets(NFPROTO_BRIDGE,
+						 info->nentries);
+		if (ret)
+			return ret;
+	}
 
 	return EBT_ENTRY_ITERATE(entries, size, compat_calc_entry, info,
 							entries, newinfo);
-- 
2.11.0
