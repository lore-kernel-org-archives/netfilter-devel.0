From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 01/14] net: sched: use rcu for action cookie update
Date: Tue, 15 May 2018 07:39:51 +0800
Message-ID: <201805150730.DS1Zaq1G%fengguang.wu@intel.com>
References: <1526308035-12484-2-git-send-email-vladbu@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netdev@vger.kernel.org, davem@davemloft.net,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        ast@kernel.org, daniel@iogearbox.net, edumazet@google.com,
        vladbu@mellanox.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: Vlad Buslov <vladbu@mellanox.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1526308035-12484-2-git-send-email-vladbu@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Vlad,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]
[also build test WARNING on v4.17-rc5 next-20180514]
[cannot apply to net-next/master]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Vlad-Buslov/Modify-action-API-for-implementing-lockless-actions/20180515-025420
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> net/sched/act_api.c:71:15: sparse: incorrect type in initializer (different address spaces) @@    expected struct tc_cookie [noderef] <asn:4>*__ret @@    got [noderef] <asn:4>*__ret @@
   net/sched/act_api.c:71:15:    expected struct tc_cookie [noderef] <asn:4>*__ret
   net/sched/act_api.c:71:15:    got struct tc_cookie *new_cookie
>> net/sched/act_api.c:71:13: sparse: incorrect type in assignment (different address spaces) @@    expected struct tc_cookie *old @@    got struct tc_cookie [noderef] <struct tc_cookie *old @@
   net/sched/act_api.c:71:13:    expected struct tc_cookie *old
   net/sched/act_api.c:71:13:    got struct tc_cookie [noderef] <asn:4>*[assigned] __ret
>> net/sched/act_api.c:132:48: sparse: dereference of noderef expression

vim +71 net/sched/act_api.c

    65	
    66	static void tcf_set_action_cookie(struct tc_cookie __rcu **old_cookie,
    67					  struct tc_cookie *new_cookie)
    68	{
    69		struct tc_cookie *old;
    70	
  > 71		old = xchg(old_cookie, new_cookie);
    72		if (old)
    73			call_rcu(&old->rcu, tcf_free_cookie_rcu);
    74	}
    75	
    76	/* XXX: For standalone actions, we don't need a RCU grace period either, because
    77	 * actions are always connected to filters and filters are already destroyed in
    78	 * RCU callbacks, so after a RCU grace period actions are already disconnected
    79	 * from filters. Readers later can not find us.
    80	 */
    81	static void free_tcf(struct tc_action *p)
    82	{
    83		free_percpu(p->cpu_bstats);
    84		free_percpu(p->cpu_qstats);
    85	
    86		tcf_set_action_cookie(&p->act_cookie, NULL);
    87		if (p->goto_chain)
    88			tcf_action_goto_chain_fini(p);
    89	
    90		kfree(p);
    91	}
    92	
    93	static void tcf_idr_remove(struct tcf_idrinfo *idrinfo, struct tc_action *p)
    94	{
    95		spin_lock_bh(&idrinfo->lock);
    96		idr_remove(&idrinfo->action_idr, p->tcfa_index);
    97		spin_unlock_bh(&idrinfo->lock);
    98		gen_kill_estimator(&p->tcfa_rate_est);
    99		free_tcf(p);
   100	}
   101	
   102	int __tcf_idr_release(struct tc_action *p, bool bind, bool strict)
   103	{
   104		int ret = 0;
   105	
   106		ASSERT_RTNL();
   107	
   108		if (p) {
   109			if (bind)
   110				p->tcfa_bindcnt--;
   111			else if (strict && p->tcfa_bindcnt > 0)
   112				return -EPERM;
   113	
   114			p->tcfa_refcnt--;
   115			if (p->tcfa_bindcnt <= 0 && p->tcfa_refcnt <= 0) {
   116				if (p->ops->cleanup)
   117					p->ops->cleanup(p);
   118				tcf_idr_remove(p->idrinfo, p);
   119				ret = ACT_P_DELETED;
   120			}
   121		}
   122	
   123		return ret;
   124	}
   125	EXPORT_SYMBOL(__tcf_idr_release);
   126	
   127	static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
   128	{
   129		u32 cookie_len = 0;
   130	
   131		if (act->act_cookie)
 > 132			cookie_len = nla_total_size(act->act_cookie->len);
   133	
   134		return  nla_total_size(0) /* action number nested */
   135			+ nla_total_size(IFNAMSIZ) /* TCA_ACT_KIND */
   136			+ cookie_len /* TCA_ACT_COOKIE */
   137			+ nla_total_size(0) /* TCA_ACT_STATS nested */
   138			/* TCA_STATS_BASIC */
   139			+ nla_total_size_64bit(sizeof(struct gnet_stats_basic))
   140			/* TCA_STATS_QUEUE */
   141			+ nla_total_size_64bit(sizeof(struct gnet_stats_queue))
   142			+ nla_total_size(0) /* TCA_OPTIONS nested */
   143			+ nla_total_size(sizeof(struct tcf_t)); /* TCA_GACT_TM */
   144	}
   145	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
