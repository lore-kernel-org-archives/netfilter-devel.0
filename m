Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17CEBA4A
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Nov 2024 01:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731029625; cv=none; b=nVp9Wq+tgu6+dQAaa/xnswMtg6r2DtEGiJytRRiJh93MRZWYW9CnZpuvvaZfuK0Vf3GKmXPzCjieuIreT1PcZMtE3Rq/K5WzoglslkFxkqgI72vqloxn8NI2Zpu41k8sPDEie0kWC3q7PWS7n/8EKALNpsZyQI99OdN+RGq3roI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731029625; c=relaxed/simple;
	bh=kfH0yePttyT4jDnySpMiIvEHtFcdV28M0rQJcuBhyuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o49UgoNFOGJlDQR2htPai0FUzFNlD/2jAlcpZOHUJp+9Tx6Sw65cLeSX4kbLQBhzGfhFvZ0daBqbIn/TAgOEr82fsgN91vfyf8paa38udgBzpq79L3Nhrc62q6UW1x7YuLF5y8yLvU7V7fUdMRSwelzQQJlKG4RH5GBZoQEBUCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tp8mmiCh; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tp8mmiCh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731029623; x=1762565623;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kfH0yePttyT4jDnySpMiIvEHtFcdV28M0rQJcuBhyuk=;
  b=Tp8mmiChsKe+Wyoi50KKQhyp+riRvi7Gw24DqzRgCykH3eVNoIoi07L0
   em9R2ECyP1Zs3Rhe//o2xSUmooLPn7BvC/EiEErHwGN+NVfifq8ZQCUHK
   EirNpmVI+M+ifi/cm9VRGUh56TXpdfYAdgzj74sjzgbX2MgkUnraFYI2+
   uQhetYgH3n9MKyUm7HyKWtHXNNe37UTcEd2a6/wPRf4yWzJWJe+SITTcS
   c+QqRTqTeb98FJlP+pKMGLZ9q2P+5PbMFh6j9F29sHdfppLOD138EGN0r
   rHRQ0D8tWriL1Hs7ACh5aYbDojjjb5+TPdCKzG6DsC2Uzs/UhZqXhJcjD
   A==;
X-CSE-ConnectionGUID: FWgZsDqWS/+1gX+5ne32wg==
X-CSE-MsgGUID: rXvg7qx+QwSdKti9HcKy1A==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31062957"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31062957"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 17:33:42 -0800
X-CSE-ConnectionGUID: 9gWxNCZGQwyDaccu8IEBRg==
X-CSE-MsgGUID: E4fVLfWiTaedKcESNb7n9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="85728721"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 07 Nov 2024 17:33:41 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t9DsY-000qsE-1f;
	Fri, 08 Nov 2024 01:33:38 +0000
Date: Fri, 8 Nov 2024 09:33:15 +0800
From: kernel test robot <lkp@intel.com>
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Florian Westphal <fw@strlen.de>,
	Nadia Pinaeva <n.m.pinaeva@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: add conntrack event
 timestamp
Message-ID: <202411080914.UxWFvWGn-lkp@intel.com>
References: <20241107194117.32116-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107194117.32116-1-fw@strlen.de>

Hi Florian,

kernel test robot noticed the following build errors:

[auto build test ERROR on netfilter-nf/main]
[also build test ERROR on linus/master v6.12-rc6 next-20241107]
[cannot apply to nf-next/master horms-ipvs/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Westphal/netfilter-conntrack-add-conntrack-event-timestamp/20241108-034444
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20241107194117.32116-1-fw%40strlen.de
patch subject: [PATCH nf-next] netfilter: conntrack: add conntrack event timestamp
config: openrisc-allyesconfig (https://download.01.org/0day-ci/archive/20241108/202411080914.UxWFvWGn-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241108/202411080914.UxWFvWGn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411080914.UxWFvWGn-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/net/netfilter/nf_conntrack_core.h:18,
                    from net/bridge/br_netfilter_hooks.c:49:
>> include/net/netfilter/nf_conntrack_ecache.h:24:9: error: unknown type name 'local64_t'; did you mean 'local_t'?
      24 |         local64_t timestamp;            /* event timestamp, in nanoseconds */
         |         ^~~~~~~~~
         |         local_t
   include/net/netfilter/nf_conntrack_ecache.h: In function 'nf_conntrack_event_cache':
>> include/net/netfilter/nf_conntrack_ecache.h:118:13: error: implicit declaration of function 'local64_read'; did you mean 'local_read'? [-Wimplicit-function-declaration]
     118 |         if (local64_read(&e->timestamp) && READ_ONCE(e->cache) == 0)
         |             ^~~~~~~~~~~~
         |             local_read
>> include/net/netfilter/nf_conntrack_ecache.h:119:17: error: implicit declaration of function 'local64_set'; did you mean 'local_set'? [-Wimplicit-function-declaration]
     119 |                 local64_set(&e->timestamp, ktime_get_real_ns());
         |                 ^~~~~~~~~~~
         |                 local_set

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for GET_FREE_REGION
   Depends on [n]: SPARSEMEM [=n]
   Selected by [y]:
   - RESOURCE_KUNIT_TEST [=y] && RUNTIME_TESTING_MENU [=y] && KUNIT [=y]


vim +24 include/net/netfilter/nf_conntrack_ecache.h

    20	
    21	struct nf_conntrack_ecache {
    22		unsigned long cache;		/* bitops want long */
    23	#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
  > 24		local64_t timestamp;		/* event timestamp, in nanoseconds */
    25	#endif
    26		u16 ctmask;			/* bitmask of ct events to be delivered */
    27		u16 expmask;			/* bitmask of expect events to be delivered */
    28		u32 missed;			/* missed events */
    29		u32 portid;			/* netlink portid of destroyer */
    30	};
    31	
    32	static inline struct nf_conntrack_ecache *
    33	nf_ct_ecache_find(const struct nf_conn *ct)
    34	{
    35	#ifdef CONFIG_NF_CONNTRACK_EVENTS
    36		return nf_ct_ext_find(ct, NF_CT_EXT_ECACHE);
    37	#else
    38		return NULL;
    39	#endif
    40	}
    41	
    42	static inline bool nf_ct_ecache_exist(const struct nf_conn *ct)
    43	{
    44	#ifdef CONFIG_NF_CONNTRACK_EVENTS
    45		return nf_ct_ext_exist(ct, NF_CT_EXT_ECACHE);
    46	#else
    47		return false;
    48	#endif
    49	}
    50	
    51	#ifdef CONFIG_NF_CONNTRACK_EVENTS
    52	
    53	/* This structure is passed to event handler */
    54	struct nf_ct_event {
    55		struct nf_conn *ct;
    56		u32 portid;
    57		int report;
    58	};
    59	
    60	struct nf_exp_event {
    61		struct nf_conntrack_expect *exp;
    62		u32 portid;
    63		int report;
    64	};
    65	
    66	struct nf_ct_event_notifier {
    67		int (*ct_event)(unsigned int events, const struct nf_ct_event *item);
    68		int (*exp_event)(unsigned int events, const struct nf_exp_event *item);
    69	};
    70	
    71	void nf_conntrack_register_notifier(struct net *net,
    72					   const struct nf_ct_event_notifier *nb);
    73	void nf_conntrack_unregister_notifier(struct net *net);
    74	
    75	void nf_ct_deliver_cached_events(struct nf_conn *ct);
    76	int nf_conntrack_eventmask_report(unsigned int eventmask, struct nf_conn *ct,
    77					  u32 portid, int report);
    78	
    79	bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp);
    80	#else
    81	
    82	static inline void nf_ct_deliver_cached_events(const struct nf_conn *ct)
    83	{
    84	}
    85	
    86	static inline int nf_conntrack_eventmask_report(unsigned int eventmask,
    87							struct nf_conn *ct,
    88							u32 portid,
    89							int report)
    90	{
    91		return 0;
    92	}
    93	
    94	static inline bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp)
    95	{
    96		return false;
    97	}
    98	#endif
    99	
   100	static inline void
   101	nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
   102	{
   103	#ifdef CONFIG_NF_CONNTRACK_EVENTS
   104		struct net *net = nf_ct_net(ct);
   105		struct nf_conntrack_ecache *e;
   106	
   107		if (!rcu_access_pointer(net->ct.nf_conntrack_event_cb))
   108			return;
   109	
   110		e = nf_ct_ecache_find(ct);
   111		if (e == NULL)
   112			return;
   113	
   114	#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
   115		/* renew only if this is the first cached event, so that the
   116		 * timestamp reflects the first, not the last, generated event.
   117		 */
 > 118		if (local64_read(&e->timestamp) && READ_ONCE(e->cache) == 0)
 > 119			local64_set(&e->timestamp, ktime_get_real_ns());
   120	#endif
   121	
   122		set_bit(event, &e->cache);
   123	#endif
   124	}
   125	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
