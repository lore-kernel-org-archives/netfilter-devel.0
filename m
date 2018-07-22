From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netlink: fix memory leak of dump
Date: Sun, 22 Jul 2018 20:09:10 +0200
Message-ID: <20180722180910.wcwhantwpm2nfxet@breakpoint.cc>
References: <20180722143354.23722-1-cscnull@gmail.com>
 <20180722163925.gdfkndldatsoae6x@breakpoint.cc>
 <20180722.100755.19840167505550163.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, cscnull@gmail.com, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, johannes.berg@intel.com, Jason@zx2c4.com,
        ktkhai@virtuozzo.com, lucien.xin@gmail.com,
        xiyou.wangcong@gmail.com, dsahern@gmail.com,
        netfilter-devel@vger.kernel.org, tom@quantonium.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180722.100755.19840167505550163.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> From: Florian Westphal <fw@strlen.de>
> Date: Sun, 22 Jul 2018 18:39:25 +0200
> 
> > 3. change meaning of ->done() so its always called once ->start()
> >    was invoked (and returned 0), this requires audit of all
> >    places that provide .done to make sure they won't trip.
> > 
> > 3) seems to be what Tom intended when he added .start, so probably
> > best to investigate that first.
> 
> Hmmm...
> 
> Any time ->start() succeeds, we set cb_running to true.

Right.

> From that point forward, ->done() will be called at some point at all
> of the locations that check if cb_running is true and set it to false.

Also right, thanks for pointing this out, I missed fact that netlink
core restarts a dump after this.

So 3) is already true which means we should try to see if we can move
all dump-related extra magic into ->start().

Shaochun, can you see if this is possible?

Something along these lines (totally untested), which makes this
a netfilter fix:

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5010,6 +5013,22 @@ nft_obj_filter_alloc(const struct nlattr * const nla[])
 	return filter;
 }
 
+static int nf_tables_dump_obj_start(struct netlink_callback *cb)
+{
+	const struct nlattr * const *nla = cb->data;
+	struct nft_obj_filter *filter = NULL;
+
+	if (nla[NFTA_OBJ_TABLE] ||
+	    nla[NFTA_OBJ_TYPE]) {
+		filter = nft_obj_filter_alloc(nla);
+		if (IS_ERR(filter))
+			return -ENOMEM;
+	}
+
+	cb->data = filter;
+	return 0;
+}
+
 /* called with rcu_read_lock held */
 static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 			    struct sk_buff *skb, const struct nlmsghdr *nlh,
@@ -5028,21 +5047,13 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
+			.start = nf_tables_dump_obj_start,
 			.dump = nf_tables_dump_obj,
 			.done = nf_tables_dump_obj_done,
 			.module = THIS_MODULE,
+			.data = (void *)nla,
 		};
 
-		if (nla[NFTA_OBJ_TABLE] ||
-		    nla[NFTA_OBJ_TYPE]) {
-			struct nft_obj_filter *filter;
-
-			filter = nft_obj_filter_alloc(nla);
-			if (IS_ERR(filter))
-				return -ENOMEM;
-
-			c.data = filter;
-		}
 		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
 	}
 
