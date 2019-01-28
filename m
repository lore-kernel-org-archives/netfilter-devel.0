From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/7] netfilter: ebtables: compat: un-break 32bit setsockopt when no rules are present
Date: Mon, 28 Jan 2019 15:04:03 +0100
Message-ID: <20190128140405.15020-6-pablo@netfilter.org>
References: <20190128140405.15020-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128140405.15020-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Unlike ip(6)tables ebtables only counts user-defined chains.

The effect is that a 32bit ebtables binary on a 64bit kernel can do
'ebtables -N FOO' only after adding at least one rule, else the request
fails with -EINVAL.

This is a similar fix as done in
3f1e53abff84 ("netfilter: ebtables: don't attempt to allocate 0-sized compat array").

Fixes: 7d7d7e02111e9 ("netfilter: compat: reject huge allocation requests")
Reported-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 5e55cef0cec3..6693e209efe8 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2293,9 +2293,12 @@ static int compat_do_replace(struct net *net, void __user *user,
 
 	xt_compat_lock(NFPROTO_BRIDGE);
 
-	ret = xt_compat_init_offsets(NFPROTO_BRIDGE, tmp.nentries);
-	if (ret < 0)
-		goto out_unlock;
+	if (tmp.nentries) {
+		ret = xt_compat_init_offsets(NFPROTO_BRIDGE, tmp.nentries);
+		if (ret < 0)
+			goto out_unlock;
+	}
+
 	ret = compat_copy_entries(entries_tmp, tmp.entries_size, &state);
 	if (ret < 0)
 		goto out_unlock;
-- 
2.11.0
