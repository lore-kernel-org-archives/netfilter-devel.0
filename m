From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: conntrack: add weak IPV6 dependency
Date: Fri, 6 Jul 2018 20:35:48 +0200
Message-ID: <20180706183548.hk7jwobomkqdccs5@breakpoint.cc>
References: <20180706130005.3640993-1-arnd@arndb.de>
 <20180706135516.viz6pjtkdmcoqq2l@breakpoint.cc>
 <CAK8P3a1o6+dcZuW_iMGzwBBw_dcW41QAQ2Mu4A5Ru9ScnwaYDA@mail.gmail.com>
 <20180706150037.knqt736uq6uyh3bs@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnd Bergmann <arnd@arndb.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        =?iso-8859-15?Q?M=E1t=E9?= Eckl <ecklm94@gmail.com>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        "Pablo M. Bermudo Garay" <pablombg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180706150037.knqt736uq6uyh3bs@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> Arnd Bergmann <arnd@arndb.de> wrote:
> > and that resulted in a new build failure:
> > 
> > net/netfilter/nf_conntrack_proto.o:(.rodata+0x788): undefined
> > reference to `nf_conntrack_l4proto_icmpv6'
> > net/ipv6/netfilter/nf_conntrack_reasm.o: In function `nf_ct_frag6_expire':
> > nf_conntrack_reasm.c:(.text+0x2320): undefined reference to
> > `ip6_expire_frag_queue'
> > net/ipv6/netfilter/nf_conntrack_reasm.o: In function `nf_ct_frag6_init':
> > nf_conntrack_reasm.c:(.text+0x2384): undefined reference to `ip6_frag_init'
> > nf_conntrack_reasm.c:(.text+0x2394): undefined reference to `ip6_frag_init'
> > nf_conntrack_reasm.c:(.text+0x2398): undefined reference to `ip6_rhash_params'
> > net/ipv6/netfilter/nf_conntrack_reasm.o: In function `nf_ct_frag6_expire':
> > nf_conntrack_reasm.c:(.text+0x10bc): undefined reference to
> > `ip6_expire_frag_queue'
> > 
> > I don't think we can get CONFIG_NF_DEFRAG_IPV6=y to work with IPV6=m.
> 
> Yes, not with current implementation, but I still don't think this
> is unavoidable.
> 
> In case this is urgent I'm fine with the patch that adds the dependency,
> otherwise I'd like to try and disentangle nf_conntrack_reasm and ipv6.

This links fine for me with IPV6=m:

Pablo, do you think this is too ugly?
It requires some copypastry from ipv6 defrag into nfct ipv6 defrag
to avoid the link errors outlined above.

Rest of defrag uses generic inet_defrag routines.

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 07516d5c2f80..339d0762b027 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -5,10 +5,6 @@
 menu "IPv6: Netfilter Configuration"
 	depends on INET && IPV6 && NETFILTER
 
-config NF_DEFRAG_IPV6
-	tristate
-	default n
-
 config NF_SOCKET_IPV6
 	tristate "IPv6 socket lookup support"
 	help
@@ -349,6 +345,7 @@ config IP6_NF_TARGET_NPT
 endif # IP6_NF_NAT
 
 endif # IP6_NF_IPTABLES
-
 endmenu
 
+config NF_DEFRAG_IPV6
+	tristate
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 5e0332014c17..9973aadc6b71 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -142,6 +142,50 @@ static inline u8 ip6_frag_ecn(const struct ipv6hdr *ipv6h)
 	return 1 << (ipv6_get_dsfield(ipv6h) & INET_ECN_MASK);
 }
 
+static void nfct_expire_frag_queue(struct net *net, struct frag_queue *fq)
+{
+	struct net_device *dev = NULL;
+	struct sk_buff *head;
+
+	rcu_read_lock();
+	spin_lock(&fq->q.lock);
+
+	if (fq->q.flags & INET_FRAG_COMPLETE)
+		goto out;
+
+	inet_frag_kill(&fq->q);
+
+	dev = dev_get_by_index_rcu(net, fq->iif);
+	if (!dev)
+		goto out;
+
+	__IP6_INC_STATS(net, __in6_dev_get(dev), IPSTATS_MIB_REASMFAILS);
+	__IP6_INC_STATS(net, __in6_dev_get(dev), IPSTATS_MIB_REASMTIMEOUT);
+
+	/* Don't send error if the first segment did not arrive. */
+	head = fq->q.fragments;
+	if (!(fq->q.flags & INET_FRAG_FIRST_IN) || !head)
+		goto out;
+
+	/* But use as source device on which LAST ARRIVED
+	 * segment was received. And do not use fq->dev
+	 * pointer directly, device might already disappeared.
+	 */
+	head->dev = dev;
+	skb_get(head);
+	spin_unlock(&fq->q.lock);
+
+	icmpv6_send(head, ICMPV6_TIME_EXCEED, ICMPV6_EXC_FRAGTIME, 0);
+	kfree_skb(head);
+	goto out_rcu_unlock;
+
+out:
+	spin_unlock(&fq->q.lock);
+out_rcu_unlock:
+	rcu_read_unlock();
+	inet_frag_put(&fq->q);
+}
+
 static void nf_ct_frag6_expire(struct timer_list *t)
 {
 	struct inet_frag_queue *frag = from_timer(frag, t, timer);
@@ -151,7 +195,7 @@ static void nf_ct_frag6_expire(struct timer_list *t)
 	fq = container_of(frag, struct frag_queue, q);
 	net = container_of(fq->q.net, struct net, nf_frag.frags);
 
-	ip6_expire_frag_queue(net, fq);
+	nfct_expire_frag_queue(net, fq);
 }
 
 /* Creation primitives. */
@@ -622,16 +666,55 @@ static struct pernet_operations nf_ct_net_ops = {
 	.exit = nf_ct_net_exit,
 };
 
+static u32 ip6_key_hashfn(const void *data, u32 len, u32 seed)
+{
+	return jhash2(data,
+		      sizeof(struct frag_v6_compare_key) / sizeof(u32), seed);
+}
+
+static u32 ip6_obj_hashfn(const void *data, u32 len, u32 seed)
+{
+	const struct inet_frag_queue *fq = data;
+
+	return jhash2((const u32 *)&fq->key.v6,
+		      sizeof(struct frag_v6_compare_key) / sizeof(u32), seed);
+}
+
+static int ip6_obj_cmpfn(struct rhashtable_compare_arg *arg, const void *ptr)
+{
+	const struct frag_v6_compare_key *key = arg->key;
+	const struct inet_frag_queue *fq = ptr;
+
+	return !!memcmp(&fq->key, key, sizeof(*key));
+}
+
+static const struct rhashtable_params nfct_rhash_params = {
+	.head_offset		= offsetof(struct inet_frag_queue, node),
+	.hashfn			= ip6_key_hashfn,
+	.obj_hashfn		= ip6_obj_hashfn,
+	.obj_cmpfn		= ip6_obj_cmpfn,
+	.automatic_shrinking	= true,
+};
+
+static void nfct_frag_init(struct inet_frag_queue *q, const void *a)
+{
+	struct frag_queue *fq = container_of(q, struct frag_queue, q);
+	const struct frag_v6_compare_key *key = a;
+
+	q->key.v6 = *key;
+	fq->ecn = 0;
+}
+
 int nf_ct_frag6_init(void)
 {
 	int ret = 0;
 
-	nf_frags.constructor = ip6_frag_init;
+	nf_frags.constructor = nfct_frag_init;
 	nf_frags.destructor = NULL;
 	nf_frags.qsize = sizeof(struct frag_queue);
 	nf_frags.frag_expire = nf_ct_frag6_expire;
 	nf_frags.frags_cache_name = nf_frags_cache_name;
-	nf_frags.rhash_params = ip6_rhash_params;
+	nf_frags.rhash_params = nfct_rhash_params;
 	ret = inet_frags_init(&nf_frags);
 	if (ret)
 		goto out;
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 6c65d756e603..e0ab50c58dc4 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -50,7 +50,7 @@ config NF_CONNTRACK
 	tristate "Netfilter connection tracking support"
 	default m if NETFILTER_ADVANCED=n
 	select NF_DEFRAG_IPV4
-	select NF_DEFRAG_IPV6 if IPV6
+	select NF_DEFRAG_IPV6 if IPV6 != n
 	help
 	  Connection tracking keeps a record of what packets have passed
 	  through your machine, in order to figure out how they are related
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 0b3851e825fa..53bd1ed1228a 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -6,7 +6,7 @@ nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_exp
 		   nf_conntrack_proto_icmp.o \
 		   nf_conntrack_extend.o nf_conntrack_acct.o nf_conntrack_seqadj.o
 
-nf_conntrack-$(CONFIG_IPV6) += nf_conntrack_proto_icmpv6.o
+nf_conntrack-$(subst m,y,$(CONFIG_IPV6)) += nf_conntrack_proto_icmpv6.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMEOUT) += nf_conntrack_timeout.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMESTAMP) += nf_conntrack_timestamp.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
