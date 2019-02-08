From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH net-next] netfilter: xt_recent: Use struct_size() in
 kvzalloc()
Date: Thu, 7 Feb 2019 18:56:08 -0600
Message-ID: <20190208005608.GA16399@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct foo {
    int stuff;
    void *entry[];
};

size = sizeof(struct foo) + count * sizeof(void *);
instance = alloc(size, GFP_KERNEL)

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

size = struct_size(instance, entry, count);
instance = alloc(size, GFP_KERNEL)

Notice that, in this case, variable sz is not necessary, hence it is
removed.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/netfilter/xt_recent.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index f44de4bc2100..1664d2ec8b2f 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -337,7 +337,6 @@ static int recent_mt_check(const struct xt_mtchk_param *par,
 	unsigned int nstamp_mask;
 	unsigned int i;
 	int ret = -EINVAL;
-	size_t sz;
 
 	net_get_random_once(&hash_rnd, sizeof(hash_rnd));
 
@@ -387,8 +386,7 @@ static int recent_mt_check(const struct xt_mtchk_param *par,
 		goto out;
 	}
 
-	sz = sizeof(*t) + sizeof(t->iphash[0]) * ip_list_hash_size;
-	t = kvzalloc(sz, GFP_KERNEL);
+	t = kvzalloc(struct_size(t, iphash, ip_list_hash_size), GFP_KERNEL);
 	if (t == NULL) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.20.1
