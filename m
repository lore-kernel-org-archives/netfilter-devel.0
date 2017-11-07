From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [net-next] netfilter: add ifdef around ctnetlink_proto_size
Date: Tue,  7 Nov 2017 15:11:51 +0100
Message-ID: <20171107141214.3312784-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Liping Zhang <zlpnobody@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This function is no longer marked 'inline', so we now get a warning
when it is unused:

net/netfilter/nf_conntrack_netlink.c:536:15: error: 'ctnetlink_proto_size' defined but not used [-Werror=unused-function]

We could mark it inline again, mark it __maybe_unused, or add an #ifdef
around the definition. I'm picking the third approach here since that
seems to be what the rest of the file has.

Fixes: 5caaed151a68 ("netfilter: conntrack: don't cache nlattr_tuple_size result in nla_size")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/netfilter/nf_conntrack_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6e0adfefb9ed..59c08997bfdf 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -533,6 +533,7 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	return -1;
 }
 
+#if defined(CONFIG_NETFILTER_NETLINK_GLUE_CT) || defined(CONFIG_NF_CONNTRACK_EVENTS)
 static size_t ctnetlink_proto_size(const struct nf_conn *ct)
 {
 	const struct nf_conntrack_l3proto *l3proto;
@@ -552,6 +553,7 @@ static size_t ctnetlink_proto_size(const struct nf_conn *ct)
 
 	return len + len4;
 }
+#endif
 
 static inline size_t ctnetlink_acct_size(const struct nf_conn *ct)
 {
-- 
2.9.0
