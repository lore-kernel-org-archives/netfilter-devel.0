Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEF934C815;
	Fri, 31 Jul 2026 15:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785511103; cv=none; b=BMzn6mwePRpgxjVx/Zzst5sMOjbTrixIskw31jcXYsTDwAHoU9B0wYkwhZEE46y0oiIRNatoWgPVm113ZsCf8sYbfdGb6VGmShGbaCRhIx++5HhvweKTaQIW7UH8+AQNtZyrwYkRkQMQQTRwLik6tmiChhqw/7+2+wRJN+zMArU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785511103; c=relaxed/simple;
	bh=J2MLHdlOR6qdkIVDXnz10AxuzAWeeEN8iqoHudiOueQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cQYxs3ap6+6K/VBoJXv6/GJ227Sr3zcGGq+F/S+22L/eidzeSDqSU0FWgLT5sW6VK7yUmquGEmYprSSDcGcWJ+eVzp3S6cak6C96TkEQ86Ws0shYk2b6SJNmy+3uWME2mD/mpgUATu0rtvwtF4gt1IT1P5KRofL05wBIDGRhCA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Vch6cAGq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Vch6cAGq"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A816D6018F;
	Fri, 31 Jul 2026 17:18:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785511092;
	bh=6T46QkAmOkJGduJ1x+B1Fxmy8sfsV+9B+TFLBxKGMXc=;
	h=From:To:Cc:Subject:Date:From;
	b=Vch6cAGqII2dqxEneUa5yM5xs6ZbnH8scyyIp62vH5HGFjOkRowgu0pARuiBbMl1K
	 OFWF0hiwa3NG9rRisi7D9RWFGCNt0Zthh+/SfUU/AUPVAH5PSm3ERUVl4jR2NjJp8d
	 +rEVjrn2YzUzaxgR+wwkCQWwrkHPTS2x/JVxQ/LK0q5zVILfYow38WM8V8JeJLTWe2
	 nz/KmPkCuT5BKxSRZeb9U3/cL8zoD655K5gtlLOHfIIzgLyHJ920j27SdFrEPBs7pL
	 TmE4D/md9O1jkLMnXm6nfitTUltXDMi9kj0qcQMLaXOsSe/TcqFms3Q4Q296X6ZVEd
	 +eXb1XiPmwq9A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 00/10] Netfilter/IPVS fixes for net
Date: Fri, 31 Jul 2026 17:17:56 +0200
Message-ID: <20260731151806.849724-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter/IPVS fixes net, this
includes fixes for ebtables nflog target, ipset hash type,
IPVS kthread estimator 

1) Prevent IPVS kthread estimator from draining the est_temp_list
   when netns is being dismantled. From Zhiling Zou.

2) Missing module nflog refcount bump from ebtables nflog target from
   .checkentry path. Similar dependency exists already in xt_NFLOG and
   nft_log. From Chengfeng Ye.

3) Use RCU to fix ipset bookkeeping of cidr values on weakly-ordered
   architectures. From Jozsef Kadlecsik.

4) Use atomic64_t for set->ext_size in ipset to fix parallel inserts
   and deletes racing on updating it. From Jozsef Kadlecsik.

5) Add small wrappers for hash and bucket size to prepare the update
   of ipset hash set types to rhashtable, from Florian Westphal.

6) Add mtype_del_cidr_all() and use it to prepare the migration of
   ipset hash types to rhashtable. From Florian Westphal.

7) Replace existing ipset call_rcu() based destruction with rcu_work
   api also to ease the transition to rhashtable. Also from Florian.

8) Avoid reading the IPv4 ihl field multiple times to prevent local
   attacker to cause out-of-bounds write in ip_vs_nat_icmp(), from
   Julian Anastasov.
 
9) Restore the checksum validations that could be needed by the IPVS
   FORWARD hook. Also from Julian.

10) Move custom ct expectation support to a helper. This is to address
    a report of possible reallocation of the ct extension while the
    expectations list contains entries, leading to stale .pprev.

Sashiko reports that more follow ups are needed for the ipset patches as
well as the ipset checksum fixes this is already known, but we consider
that this is improving the situation and those can be addressed
incrementally. Regarding patch #10, sashiko points to pre-existing
issues in this custom ct expectation feature that I plan to address in
net-next.

When merging this PR into net.git, there will be a conflict between
net.git and net-next.git related to patch #10 and d4beefc90a66
("netfilter: nft_ct: support expectation creation for natted flows")
in net-next, that can be address with the following patch:

diff --cc net/netfilter/nft_ct.c
index 30c9358dbf48,358b9287e12e..339e0c98fd70
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@@ -1228,73 -1226,6 +1228,91 @@@ static int nft_ct_expect_timeout_get(co
  	return 0;
  }
  
++#if IS_ENABLED(CONFIG_NF_NAT)
++static void nft_ct_nat_follow_master(struct nf_conn *ct, struct nf_conntrack_expect *this)
++{
++	const struct nf_ct_helper_expectfn *expfn;
++
++	expfn = nf_ct_helper_expectfn_find_by_name("nat-follow-master");
++	if (expfn)
++		expfn->expectfn(ct, this);
++}
++#endif
++
 +struct nft_ct_expect_data {
 +	struct nft_ct_expect_obj	obj;
 +	enum ip_conntrack_dir		dir;
 +	atomic_t			num_expects;
 +};
 +
 +static int ct_expect_help(struct sk_buff *skb, unsigned int protoff,
 +			  struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 +{
 +	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 +	struct nft_ct_expect_data *expect_data;
 +	struct nf_conntrack_expect *exp;
 +	int ret = NF_ACCEPT;
 +
 +	expect_data = nfct_help_data(ct);
 +	if (!expect_data)
 +		return NF_ACCEPT;
 +
 +	if (expect_data->dir != dir)
 +		return NF_ACCEPT;
 +
 +	if (!atomic_add_unless(&expect_data->num_expects, 1, expect_data->obj.size))
 +		return NF_ACCEPT;
 +
 +	exp = nf_ct_expect_alloc(ct);
 +	if (!exp) {
 +		atomic_dec(&expect_data->num_expects);
 +		return NF_DROP;
 +	}
 +
 +	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 +			  &ct->tuplehash[!dir].tuple.src.u3,
 +			  &ct->tuplehash[!dir].tuple.dst.u3,
 +			  expect_data->obj.l4proto, NULL, &expect_data->obj.dport);
 +	exp->timeout += expect_data->obj.timeout;
 +
++#if IS_ENABLED(CONFIG_NF_NAT)
++	if (ct->status & IPS_NAT_MASK) {
++		exp->saved_proto.tcp.port = expect_data->obj.dport;
++		exp->dir = !dir;
++		exp->expectfn = nft_ct_nat_follow_master;
++	}
++#endif
 +	if (nf_ct_expect_related(exp, 0) != 0) {
 +		atomic_dec(&expect_data->num_expects);
 +		ret = NF_DROP;
 +	}
 +
 +	nf_ct_expect_put(exp);
 +
 +	return ret;
 +}
 +
 +static int nft_ct_expect_helper_alloc(struct nft_ct_expect_obj *priv)
 +{
 +	struct nf_conntrack_helper *ct_expect_helper;
 +
 +	ct_expect_helper = kzalloc_obj(struct nf_conntrack_helper);
 +	if (!ct_expect_helper)
 +		return -ENOMEM;
 +
 +	snprintf(ct_expect_helper->name, sizeof(ct_expect_helper->name), "%s",
 +		 "nft_ct_expect");
 +	ct_expect_helper->me = THIS_MODULE;
 +	ct_expect_helper->expect_policy[NF_CT_EXPECT_CLASS_DEFAULT].max_expected = priv->size;
 +	rcu_assign_pointer(ct_expect_helper->help, ct_expect_help);
 +	refcount_set(&ct_expect_helper->ct_refcnt, 1);
 +
 +	/* No need to register this helper, this is internal. */
 +	priv->helper = ct_expect_helper;
 +
 +	return 0;
 +}
 +
  static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
  				  const struct nlattr * const tb[],
  				  struct nft_object *obj)


Apologies for the extra work that the conflict resolution brings,
I was planning to merge this fix to net-next but I just saw a second
reporter finding exactly the same bug in net.git, so I am inclined
towards expediting inclusion upstream of patch #10 in this series.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-07-31

Thanks.

----------------------------------------------------------------

The following changes since commit 2195424c3da2ef1829a63b807e3a900a90e57d85:

  net/x25: fix use-after-free of the socket by its timers (2026-07-30 18:46:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-07-31

for you to fetch changes up to 0b541313c8a8ee49ab8bb1f620204720a83eb7fd:

  netfilter: nft_ct: move custom expectation support to helper (2026-07-31 16:46:55 +0200)

----------------------------------------------------------------
netfilter pull request 26-07-31

----------------------------------------------------------------
Chengfeng Ye (1):
      netfilter: ebt_nflog: pin the NFLOG backend

Florian Westphal (3):
      netfilter: ipset: add small wrappers for hash and bucket sizes
      netfilter: ipset: add and use mtype_del_cidr_all helper
      netfilter: ipset: switch to rcu work

Jozsef Kadlecsik (2):
      netfilter: ipset: rework cidr bookkeeping
      netfilter: ipset: switch ext_size to atomic64_t

Julian Anastasov (2):
      ipvs: avoid out-of-bounds write in ip_vs_nat_icmp
      ipvs: return the csum validation for forward hook

Pablo Neira Ayuso (1):
      netfilter: nft_ct: move custom expectation support to helper

Zhiling Zou (1):
      ipvs: stop estimator after disabled calc phase

 include/linux/netfilter/ipset/ip_set.h       |   6 +-
 include/net/ip_vs.h                          |  21 +-
 include/net/netfilter/nf_conntrack_helper.h  |   2 +
 net/bridge/netfilter/ebt_nflog.c             |  17 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h      |   4 +-
 net/netfilter/ipset/ip_set_core.c            |  52 +++--
 net/netfilter/ipset/ip_set_hash_gen.h        | 304 ++++++++++++++++++---------
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |   4 +-
 net/netfilter/ipset/ip_set_hash_net.c        |   4 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |   4 +-
 net/netfilter/ipset/ip_set_hash_netnet.c     |  12 +-
 net/netfilter/ipset/ip_set_hash_netport.c    |   4 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c |  12 +-
 net/netfilter/ipset/ip_set_list_set.c        |   4 +-
 net/netfilter/ipvs/ip_vs_core.c              |  67 +++---
 net/netfilter/ipvs/ip_vs_est.c               |  10 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c        |   2 +-
 net/netfilter/ipvs/ip_vs_xmit.c              |   2 +-
 net/netfilter/nf_conntrack_helper.c          |  18 +-
 net/netfilter/nft_ct.c                       | 127 ++++++++---
 20 files changed, 445 insertions(+), 231 deletions(-)
d4beefc90a66 ("netfilter: nft_ct: support expectation creation for natted flows")
