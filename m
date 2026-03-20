Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A50731B828
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 19:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774033721; cv=none; b=sAbvt31TrgpQ5vZhK+EW7hvvcE1sop8TcWH2Z/aZGTINS60dLxXMHJaCIUWxMdQuQq9cldJZ7+aSGZIR+GjlZjAJ4pL5Jcli0urMN0DUwDncnKkdzQbL9KRjE7oX47pZ2d1ealpX3yqtPBIaABgQpGVLkOBYgFdPKVfkmqLBXC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774033721; c=relaxed/simple;
	bh=dxlNpXWg82H4v+fYv7bZtktS+KBJ4JqBfmgfowx9nTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=O5dB47KMIs73P4Tvu4HMOwDDWRvjF7HhssLXfGNV4Za+1OYM19iKJo7jGUQj9brGiJeoYfC0spgyGpBghAwCFwoVX+sOTUU9PxpsSY/uwDjDJEm4fsEwcxb+fk2Vzs0vupUQN0WRg6yuLXC444Y+KccRN08En1T8LEv4SONx+jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rj505pTV; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rj505pTV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774033718; x=1805569718;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=dxlNpXWg82H4v+fYv7bZtktS+KBJ4JqBfmgfowx9nTQ=;
  b=Rj505pTV5dYV023zl2hCzwr0AetNkL0j7AhA32zpk/fM/Ujt8pmUEWrS
   wF4TWpP3CzJQLDBF3L+SUi4Ni2GhY/HGTfWuCld8mt7Z3ZdyceWioiqBz
   0VA4ez8CQPpoZW5g1TfMf41VIA91GmTn9drHrMXk0QPzaAtfXcu/SM2BO
   X9BgSzZKR3D/o4pCHZcuc9kewZ/HqKSgsDKdzFuO20pEAUOEJyvyqvCln
   B0je8U1hrQCeXbYQMXGjWiVs/IATDKwHBT6AjeJwz5QcDUJZ1ZDYG2AIn
   V+9ZNOJqLQnagpUUCJcBiV1FqZMlXfzYu3leXVMvfFwPNRTf4zPHz6UYC
   A==;
X-CSE-ConnectionGUID: YUnJyHngS3OdTxOHSojQlw==
X-CSE-MsgGUID: tVMn2Gz+QyCN70rcAZS/SA==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="97748297"
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="97748297"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 12:08:37 -0700
X-CSE-ConnectionGUID: 7mZy/otoSJ2YcwvIeMQd4w==
X-CSE-MsgGUID: FayXFKjQSJKtTpGJj14Gug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="222466229"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa006.jf.intel.com with ESMTP; 20 Mar 2026 12:08:35 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3fCz-00000000569-2U9s;
	Fri, 20 Mar 2026 19:08:33 +0000
Date: Fri, 20 Mar 2026 20:07:57 +0100
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, Florian Westphal <fw@strlen.de>
Subject: [netfilter-nf:testing 7/9] net/sched/act_connmark.c:98:12:
 error: invalid storage class for function 'tcf_connmark_init'
Message-ID: <202603201919.Sx7L8wtQ-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git te=
sting
head:   b1bad43d8b00ab31c8f93145a4c8db1567f0d2fe
commit: 20d564bba6b3806c26498061299a88330561efa5 [7/9] netfilter: ctnetlink=
: ensure safe access to master conntrack
config: x86_64-rhel-9.4-kselftests (https://download.01.org/0day-ci/archive=
/20260320/202603201919.Sx7L8wtQ-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archive=
/20260320/202603201919.Sx7L8wtQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new versio=
n of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603201919.Sx7L8wtQ-lkp@i=
ntel.com/

All error/warnings (new ones prefixed by >>):

   In file included from net/sched/act_connmark.c:26:
   include/net/netfilter/nf_conntrack_core.h: In function 'lockdep_nfct_exp=
ect_lock_not_held':
   include/net/netfilter/nf_conntrack_core.h:111: error: unterminated argum=
ent list invoking macro "WARN_ON_ONCE"
     111 | #endif /* _NF_CONNTRACK_CORE_H */
   include/net/netfilter/nf_conntrack_core.h:90:17: error: 'WARN_ON_ONCE' u=
ndeclared (first use in this function)
      90 |                 WARN_ON_ONCE(lockdep_is_held(&nf_conntrack_expec=
t_lock);
         |                 ^~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_core.h:90:17: note: each undeclared i=
dentifier is reported only once for each function it appears in
   include/net/netfilter/nf_conntrack_core.h:90:29: error: expected ';' bef=
ore 'static'
      90 |                 WARN_ON_ONCE(lockdep_is_held(&nf_conntrack_expec=
t_lock);
         |                             ^
         |                             ;
>> net/sched/act_connmark.c:98:12: error: invalid storage class for functio=
n 'tcf_connmark_init'
      98 | static int tcf_connmark_init(struct net *net, struct nlattr *nla,
         |            ^~~~~~~~~~~~~~~~~
   net/sched/act_connmark.c: In function 'tcf_connmark_init':
>> net/sched/act_connmark.c:103:53: error: 'act_connmark_ops' undeclared (f=
irst use in this function); did you mean 'tcf_connmark_act'?
     103 |         struct tc_action_net *tn =3D net_generic(net, act_connma=
rk_ops.net_id);
         |                                                     ^~~~~~~~~~~~=
~~~~
         |                                                     tcf_connmark=
_act
   net/sched/act_connmark.c: In function 'lockdep_nfct_expect_lock_not_held=
':
>> net/sched/act_connmark.c:192:19: error: invalid storage class for functi=
on 'tcf_connmark_dump'
     192 | static inline int tcf_connmark_dump(struct sk_buff *skb, struct =
tc_action *a,
         |                   ^~~~~~~~~~~~~~~~~
>> net/sched/act_connmark.c:229:13: error: invalid storage class for functi=
on 'tcf_connmark_cleanup'
     229 | static void tcf_connmark_cleanup(struct tc_action *a)
         |             ^~~~~~~~~~~~~~~~~~~~
>> net/sched/act_connmark.c:243:33: error: initializer element is not const=
ant
     243 |         .act            =3D       tcf_connmark_act,
         |                                 ^~~~~~~~~~~~~~~~
   net/sched/act_connmark.c:243:33: note: (near initialization for 'act_con=
nmark_ops.act')
   net/sched/act_connmark.c:244:33: error: initializer element is not const=
ant
     244 |         .dump           =3D       tcf_connmark_dump,
         |                                 ^~~~~~~~~~~~~~~~~
   net/sched/act_connmark.c:244:33: note: (near initialization for 'act_con=
nmark_ops.dump')
   net/sched/act_connmark.c:245:33: error: initializer element is not const=
ant
     245 |         .init           =3D       tcf_connmark_init,
         |                                 ^~~~~~~~~~~~~~~~~
   net/sched/act_connmark.c:245:33: note: (near initialization for 'act_con=
nmark_ops.init')
   net/sched/act_connmark.c:246:33: error: initializer element is not const=
ant
     246 |         .cleanup        =3D       tcf_connmark_cleanup,
         |                                 ^~~~~~~~~~~~~~~~~~~~
   net/sched/act_connmark.c:246:33: note: (near initialization for 'act_con=
nmark_ops.cleanup')
>> net/sched/act_connmark.c:251:23: error: invalid storage class for functi=
on 'connmark_init_net'
     251 | static __net_init int connmark_init_net(struct net *net)
         |                       ^~~~~~~~~~~~~~~~~
>> net/sched/act_connmark.c:258:24: error: invalid storage class for functi=
on 'connmark_exit_net'
     258 | static void __net_exit connmark_exit_net(struct list_head *net_l=
ist)
         |                        ^~~~~~~~~~~~~~~~~
   net/sched/act_connmark.c:264:17: error: initializer element is not const=
ant
     264 |         .init =3D connmark_init_net,
         |                 ^~~~~~~~~~~~~~~~~
   net/sched/act_connmark.c:264:17: note: (near initialization for 'connmar=
k_net_ops.init')
   net/sched/act_connmark.c:265:23: error: initializer element is not const=
ant
     265 |         .exit_batch =3D connmark_exit_net,
         |                       ^~~~~~~~~~~~~~~~~
   net/sched/act_connmark.c:265:23: note: (near initialization for 'connmar=
k_net_ops.exit_batch')
>> net/sched/act_connmark.c:270:19: error: invalid storage class for functi=
on 'connmark_init_module'
     270 | static int __init connmark_init_module(void)
         |                   ^~~~~~~~~~~~~~~~~~~~
>> net/sched/act_connmark.c:275:20: error: invalid storage class for functi=
on 'connmark_cleanup_module'
     275 | static void __exit connmark_cleanup_module(void)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~
   In file included from net/sched/act_connmark.c:9:
   include/linux/module.h:132:49: error: invalid storage class for function=
 '__inittest'
     132 |         static inline initcall_t __maybe_unused __inittest(void)=
                \
         |                                                 ^~~~~~~~~~
   net/sched/act_connmark.c:280:1: note: in expansion of macro 'module_init'
     280 | module_init(connmark_init_module);
         | ^~~~~~~~~~~
>> net/sched/act_connmark.c:280:1: warning: 'alias' attribute ignored [-Wat=
tributes]
   include/linux/module.h:140:49: error: invalid storage class for function=
 '__exittest'
     140 |         static inline exitcall_t __maybe_unused __exittest(void)=
                \
         |                                                 ^~~~~~~~~~
   net/sched/act_connmark.c:281:1: note: in expansion of macro 'module_exit'
     281 | module_exit(connmark_cleanup_module);
         | ^~~~~~~~~~~
   net/sched/act_connmark.c:281:1: warning: 'alias' attribute ignored [-Wat=
tributes]
>> net/sched/act_connmark.c:284:1: error: expected declaration or statement=
 at end of input
     284 | MODULE_LICENSE("GPL");
         | ^~~~~~~~~~~~~~


vim +/tcf_connmark_init +98 net/sched/act_connmark.c

22a5dc0e5e3e8f Felix Fietkau    2015-01-18   97 =20
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  @98  static int tcf_connmark_in=
it(struct net *net, struct nlattr *nla,
a85a970af265f1 WANG Cong        2016-07-25   99  			     struct nlattr *est=
, struct tc_action **a,
abbb0d33632ce9 Vlad Buslov      2019-10-30  100  			     struct tcf_proto *=
tp, u32 flags,
589dad6d71a72d Alexander Aring  2018-02-15  101  			     struct netlink_ext=
_ack *extack)
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  102  {
acd0a7ab6334f3 Zhengchao Shao   2022-09-08 @103  	struct tc_action_net *tn =
=3D net_generic(net, act_connmark_ops.net_id);
288864effe3388 Pedro Tammela    2023-02-14  104  	struct tcf_connmark_parms=
 *nparms, *oparms;
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  105  	struct nlattr *tb[TCA_CON=
NMARK_MAX + 1];
695176bfe5dec2 Cong Wang        2021-07-29  106  	bool bind =3D flags & TCA=
_ACT_FLAGS_BIND;
c53075ea5d3c44 Davide Caratti   2019-03-20  107  	struct tcf_chain *goto_ch=
 =3D NULL;
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  108  	struct tcf_connmark_info =
*ci;
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  109  	struct tc_connmark *parm;
c53075ea5d3c44 Davide Caratti   2019-03-20  110  	int ret =3D 0, err;
7be8ef2cdbfe41 Dmytro Linkin    2019-08-01  111  	u32 index;
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  112 =20
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  113  	if (!nla)
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  114  		return -EINVAL;
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  115 =20
8cb081746c031f Johannes Berg    2019-04-26  116  	ret =3D nla_parse_nested_=
deprecated(tb, TCA_CONNMARK_MAX, nla,
8cb081746c031f Johannes Berg    2019-04-26  117  					  connmark_policy, NU=
LL);
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  118  	if (ret < 0)
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  119  		return ret;
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  120 =20
52491c7607c552 Etienne Noss     2017-03-10  121  	if (!tb[TCA_CONNMARK_PARM=
S])
52491c7607c552 Etienne Noss     2017-03-10  122  		return -EINVAL;
52491c7607c552 Etienne Noss     2017-03-10  123 =20
bf4afc53b77aea Linus Torvalds   2026-02-21  124  	nparms =3D kzalloc_obj(*n=
parms);
288864effe3388 Pedro Tammela    2023-02-14  125  	if (!nparms)
288864effe3388 Pedro Tammela    2023-02-14  126  		return -ENOMEM;
288864effe3388 Pedro Tammela    2023-02-14  127 =20
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  128  	parm =3D nla_data(tb[TCA_=
CONNMARK_PARMS]);
7be8ef2cdbfe41 Dmytro Linkin    2019-08-01  129  	index =3D parm->index;
7be8ef2cdbfe41 Dmytro Linkin    2019-08-01  130  	ret =3D tcf_idr_check_all=
oc(tn, &index, a, bind);
0190c1d452a91c Vlad Buslov      2018-07-05  131  	if (!ret) {
288864effe3388 Pedro Tammela    2023-02-14  132  		ret =3D tcf_idr_create_f=
rom_flags(tn, index, est, a,
288864effe3388 Pedro Tammela    2023-02-14  133  						&act_connmark_ops, b=
ind, flags);
0190c1d452a91c Vlad Buslov      2018-07-05  134  		if (ret) {
7be8ef2cdbfe41 Dmytro Linkin    2019-08-01  135  			tcf_idr_cleanup(tn, ind=
ex);
288864effe3388 Pedro Tammela    2023-02-14  136  			err =3D ret;
288864effe3388 Pedro Tammela    2023-02-14  137  			goto out_free;
0190c1d452a91c Vlad Buslov      2018-07-05  138  		}
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  139 =20
a85a970af265f1 WANG Cong        2016-07-25  140  		ci =3D to_connmark(*a);
288864effe3388 Pedro Tammela    2023-02-14  141 =20
288864effe3388 Pedro Tammela    2023-02-14  142  		nparms->net =3D net;
288864effe3388 Pedro Tammela    2023-02-14  143  		nparms->zone =3D parm->z=
one;
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  144 =20
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  145  		ret =3D ACT_P_CREATED;
0190c1d452a91c Vlad Buslov      2018-07-05  146  	} else if (ret > 0) {
a85a970af265f1 WANG Cong        2016-07-25  147  		ci =3D to_connmark(*a);
288864effe3388 Pedro Tammela    2023-02-14  148  		if (bind) {
c2a67de9bb5433 Pedro Tammela    2023-12-29  149  			err =3D ACT_P_BOUND;
288864effe3388 Pedro Tammela    2023-02-14  150  			goto out_free;
288864effe3388 Pedro Tammela    2023-02-14  151  		}
695176bfe5dec2 Cong Wang        2021-07-29  152  		if (!(flags & TCA_ACT_FL=
AGS_REPLACE)) {
288864effe3388 Pedro Tammela    2023-02-14  153  			err =3D -EEXIST;
288864effe3388 Pedro Tammela    2023-02-14  154  			goto release_idr;
288864effe3388 Pedro Tammela    2023-02-14  155  		}
288864effe3388 Pedro Tammela    2023-02-14  156 =20
288864effe3388 Pedro Tammela    2023-02-14  157  		nparms->net =3D rtnl_der=
eference(ci->parms)->net;
288864effe3388 Pedro Tammela    2023-02-14  158  		nparms->zone =3D parm->z=
one;
288864effe3388 Pedro Tammela    2023-02-14  159 =20
288864effe3388 Pedro Tammela    2023-02-14  160  		ret =3D 0;
fb07390463c95e Pedro Tammela    2023-02-27  161  	} else {
fb07390463c95e Pedro Tammela    2023-02-27  162  		err =3D ret;
fb07390463c95e Pedro Tammela    2023-02-27  163  		goto out_free;
4e8ddd7f1758ca Vlad Buslov      2018-07-05  164  	}
288864effe3388 Pedro Tammela    2023-02-14  165 =20
288864effe3388 Pedro Tammela    2023-02-14  166  	err =3D tcf_action_check_=
ctrlact(parm->action, tp, &goto_ch, extack);
c53075ea5d3c44 Davide Caratti   2019-03-20  167  	if (err < 0)
c53075ea5d3c44 Davide Caratti   2019-03-20  168  		goto release_idr;
288864effe3388 Pedro Tammela    2023-02-14  169 =20
0d752877705c02 Eric Dumazet     2025-07-09  170  	nparms->action =3D parm->=
action;
0d752877705c02 Eric Dumazet     2025-07-09  171 =20
506a03aa04deed Cong Wang        2018-08-29  172  	spin_lock_bh(&ci->tcf_loc=
k);
c53075ea5d3c44 Davide Caratti   2019-03-20  173  	goto_ch =3D tcf_action_se=
t_ctrlact(*a, parm->action, goto_ch);
288864effe3388 Pedro Tammela    2023-02-14  174  	oparms =3D rcu_replace_po=
inter(ci->parms, nparms, lockdep_is_held(&ci->tcf_lock));
506a03aa04deed Cong Wang        2018-08-29  175  	spin_unlock_bh(&ci->tcf_l=
ock);
288864effe3388 Pedro Tammela    2023-02-14  176 =20
c53075ea5d3c44 Davide Caratti   2019-03-20  177  	if (goto_ch)
c53075ea5d3c44 Davide Caratti   2019-03-20  178  		tcf_chain_put_by_act(got=
o_ch);
288864effe3388 Pedro Tammela    2023-02-14  179 =20
288864effe3388 Pedro Tammela    2023-02-14  180  	if (oparms)
288864effe3388 Pedro Tammela    2023-02-14  181  		kfree_rcu(oparms, rcu);
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  182 =20
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  183  	return ret;
288864effe3388 Pedro Tammela    2023-02-14  184 =20
c53075ea5d3c44 Davide Caratti   2019-03-20  185  release_idr:
c53075ea5d3c44 Davide Caratti   2019-03-20  186  	tcf_idr_release(*a, bind);
288864effe3388 Pedro Tammela    2023-02-14  187  out_free:
288864effe3388 Pedro Tammela    2023-02-14  188  	kfree(nparms);
c53075ea5d3c44 Davide Caratti   2019-03-20  189  	return err;
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  190  }
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  191 =20
22a5dc0e5e3e8f Felix Fietkau    2015-01-18 @192  static inline int tcf_conn=
mark_dump(struct sk_buff *skb, struct tc_action *a,
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  193  				    int bind, int ref)
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  194  {
0d752877705c02 Eric Dumazet     2025-07-09  195  	const struct tcf_connmark=
_info *ci =3D to_connmark(a);
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  196  	unsigned char *b =3D skb_=
tail_pointer(skb);
0d752877705c02 Eric Dumazet     2025-07-09  197  	const struct tcf_connmark=
_parms *parms;
62b656e43eaeae Ranganath V N    2025-11-09  198  	struct tc_connmark opt;
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  199  	struct tcf_t t;
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  200 =20
62b656e43eaeae Ranganath V N    2025-11-09  201  	memset(&opt, 0, sizeof(op=
t));
62b656e43eaeae Ranganath V N    2025-11-09  202 =20
62b656e43eaeae Ranganath V N    2025-11-09  203  	opt.index   =3D ci->tcf_i=
ndex;
62b656e43eaeae Ranganath V N    2025-11-09  204  	opt.refcnt  =3D refcount_=
read(&ci->tcf_refcnt) - ref;
62b656e43eaeae Ranganath V N    2025-11-09  205  	opt.bindcnt =3D atomic_re=
ad(&ci->tcf_bindcnt) - bind;
62b656e43eaeae Ranganath V N    2025-11-09  206 =20
0d752877705c02 Eric Dumazet     2025-07-09  207  	rcu_read_lock();
0d752877705c02 Eric Dumazet     2025-07-09  208  	parms =3D rcu_dereference=
(ci->parms);
288864effe3388 Pedro Tammela    2023-02-14  209 =20
0d752877705c02 Eric Dumazet     2025-07-09  210  	opt.action =3D parms->act=
ion;
288864effe3388 Pedro Tammela    2023-02-14  211  	opt.zone =3D parms->zone;
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  212  	if (nla_put(skb, TCA_CONN=
MARK_PARMS, sizeof(opt), &opt))
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  213  		goto nla_put_failure;
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  214 =20
48d8ee1694dd1a Jamal Hadi Salim 2016-06-06  215  	tcf_tm_dump(&t, &ci->tcf_=
tm);
9854518ea04db3 Nicolas Dichtel  2016-04-26  216  	if (nla_put_64bit(skb, TC=
A_CONNMARK_TM, sizeof(t), &t,
9854518ea04db3 Nicolas Dichtel  2016-04-26  217  			  TCA_CONNMARK_PAD))
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  218  		goto nla_put_failure;
0d752877705c02 Eric Dumazet     2025-07-09  219  	rcu_read_unlock();
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  220 =20
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  221  	return skb->len;
506a03aa04deed Cong Wang        2018-08-29  222 =20
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  223  nla_put_failure:
0d752877705c02 Eric Dumazet     2025-07-09  224  	rcu_read_unlock();
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  225  	nlmsg_trim(skb, b);
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  226  	return -1;
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  227  }
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  228 =20
288864effe3388 Pedro Tammela    2023-02-14 @229  static void tcf_connmark_c=
leanup(struct tc_action *a)
288864effe3388 Pedro Tammela    2023-02-14  230  {
288864effe3388 Pedro Tammela    2023-02-14  231  	struct tcf_connmark_info =
*ci =3D to_connmark(a);
288864effe3388 Pedro Tammela    2023-02-14  232  	struct tcf_connmark_parms=
 *parms;
288864effe3388 Pedro Tammela    2023-02-14  233 =20
288864effe3388 Pedro Tammela    2023-02-14  234  	parms =3D rcu_dereference=
_protected(ci->parms, 1);
288864effe3388 Pedro Tammela    2023-02-14  235  	if (parms)
288864effe3388 Pedro Tammela    2023-02-14  236  		kfree_rcu(parms, rcu);
288864effe3388 Pedro Tammela    2023-02-14  237  }
288864effe3388 Pedro Tammela    2023-02-14  238 =20
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  239  static struct tc_action_op=
s act_connmark_ops =3D {
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  240  	.kind		=3D	"connmark",
eddd2cf195d6fb Eli Cohen        2019-02-10  241  	.id		=3D	TCA_ID_CONNMARK,
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  242  	.owner		=3D	THIS_MODULE,
962ad1f937d864 Jamal Hadi Salim 2018-08-12 @243  	.act		=3D	tcf_connmark_ac=
t,
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  244  	.dump		=3D	tcf_connmark_d=
ump,
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  245  	.init		=3D	tcf_connmark_i=
nit,
288864effe3388 Pedro Tammela    2023-02-14  246  	.cleanup	=3D	tcf_connmark=
_cleanup,
a85a970af265f1 WANG Cong        2016-07-25  247  	.size		=3D	sizeof(struct =
tcf_connmark_info),
ddf97ccdd7cb7e WANG Cong        2016-02-22  248  };
241a94abcf465b Michal Koutn=C3=BD    2024-02-01  249  MODULE_ALIAS_NET_ACT(=
"connmark");
ddf97ccdd7cb7e WANG Cong        2016-02-22  250 =20
ddf97ccdd7cb7e WANG Cong        2016-02-22 @251  static __net_init int conn=
mark_init_net(struct net *net)
ddf97ccdd7cb7e WANG Cong        2016-02-22  252  {
acd0a7ab6334f3 Zhengchao Shao   2022-09-08  253  	struct tc_action_net *tn =
=3D net_generic(net, act_connmark_ops.net_id);
ddf97ccdd7cb7e WANG Cong        2016-02-22  254 =20
981471bd3abf4d Cong Wang        2019-08-25  255  	return tc_action_net_init=
(net, tn, &act_connmark_ops);
ddf97ccdd7cb7e WANG Cong        2016-02-22  256  }
ddf97ccdd7cb7e WANG Cong        2016-02-22  257 =20
039af9c66b9315 Cong Wang        2017-12-11 @258  static void __net_exit con=
nmark_exit_net(struct list_head *net_list)
ddf97ccdd7cb7e WANG Cong        2016-02-22  259  {
acd0a7ab6334f3 Zhengchao Shao   2022-09-08  260  	tc_action_net_exit(net_li=
st, act_connmark_ops.net_id);
ddf97ccdd7cb7e WANG Cong        2016-02-22  261  }
ddf97ccdd7cb7e WANG Cong        2016-02-22  262 =20
ddf97ccdd7cb7e WANG Cong        2016-02-22  263  static struct pernet_opera=
tions connmark_net_ops =3D {
ddf97ccdd7cb7e WANG Cong        2016-02-22  264  	.init =3D connmark_init_n=
et,
039af9c66b9315 Cong Wang        2017-12-11  265  	.exit_batch =3D connmark_=
exit_net,
acd0a7ab6334f3 Zhengchao Shao   2022-09-08  266  	.id   =3D &act_connmark_o=
ps.net_id,
ddf97ccdd7cb7e WANG Cong        2016-02-22  267  	.size =3D sizeof(struct t=
c_action_net),
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  268  };
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  269 =20
22a5dc0e5e3e8f Felix Fietkau    2015-01-18 @270  static int __init connmark=
_init_module(void)
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  271  {
ddf97ccdd7cb7e WANG Cong        2016-02-22  272  	return tcf_register_actio=
n(&act_connmark_ops, &connmark_net_ops);
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  273  }
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  274 =20
22a5dc0e5e3e8f Felix Fietkau    2015-01-18 @275  static void __exit connmar=
k_cleanup_module(void)
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  276  {
ddf97ccdd7cb7e WANG Cong        2016-02-22  277  	tcf_unregister_action(&ac=
t_connmark_ops, &connmark_net_ops);
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  278  }
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  279 =20
22a5dc0e5e3e8f Felix Fietkau    2015-01-18 @280  module_init(connmark_init_=
module);
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  281  module_exit(connmark_clean=
up_module);
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  282  MODULE_AUTHOR("Felix Fietk=
au <nbd@openwrt.org>");
22a5dc0e5e3e8f Felix Fietkau    2015-01-18  283  MODULE_DESCRIPTION("Connec=
tion tracking mark restoring");
22a5dc0e5e3e8f Felix Fietkau    2015-01-18 @284  MODULE_LICENSE("GPL");

:::::: The code at line 98 was first introduced by commit
:::::: 22a5dc0e5e3e8fef804230cd73ed7b0afd4c7bae net: sched: Introduce connm=
ark action

:::::: TO: Felix Fietkau <nbd@openwrt.org>
:::::: CC: David S. Miller <davem@davemloft.net>

--=20
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
