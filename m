From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/37] netfilter: ipset: replace a strncpy() with strscpy()
Date: Fri, 21 Dec 2018 01:28:15 +0100
Message-ID: <20181221002841.28587-12-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Qian Cai <cai@gmx.us>

To make overflows as obvious as possible and to prevent code from blithely
proceeding with a truncated string. This also has a side-effect to fix a
compilation warning when using GCC 8.2.1.

net/netfilter/ipset/ip_set_core.c: In function 'ip_set_sockfn_get':
net/netfilter/ipset/ip_set_core.c:2027:3: warning: 'strncpy' writing 32 bytes into a region of size 2 overflows the destination [-Wstringop-overflow=]

Signed-off-by: Qian Cai <cai@gmx.us>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index e3113aa1a975..45a257695bef 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -2154,9 +2154,11 @@ ip_set_sockfn_get(struct sock *sk, int optval, void __user *user, int *len)
 		}
 		nfnl_lock(NFNL_SUBSYS_IPSET);
 		set = ip_set(inst, req_get->set.index);
-		strncpy(req_get->set.name, set ? set->name : "",
-			IPSET_MAXNAMELEN);
+		ret = strscpy(req_get->set.name, set ? set->name : "",
+			      IPSET_MAXNAMELEN);
 		nfnl_unlock(NFNL_SUBSYS_IPSET);
+		if (ret < 0)
+			goto done;
 		goto copy;
 	}
 	default:
-- 
2.11.0
