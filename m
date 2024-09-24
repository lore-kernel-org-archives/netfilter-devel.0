Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1637045026;
	Tue, 24 Sep 2024 07:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727163854; cv=none; b=ID5hAFaRvCSRBgO6JuOWXRgs+JjOwko0vh+hxrAjC8F9Xky6OLGJcDgilIKIHKh6LJfK2ANpPgfKDAgaYB3lLqpgfHxmYWAVjYLPQqqV2Br8G/7RpLnuuwxzeaC4pORyYgn12hLMdOQxjH+9K36dd2yqIHmtjZfv4EUcbcStJSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727163854; c=relaxed/simple;
	bh=7DQinbWJYr9pz315R5995DNBrONlOziueyWnA2vSf7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XU7+/kXxVS4M3jdyd0wXd9x9j01zq9f2yrPiGmZlaHjwiriTRP1YkZ3rMjrpaYoBn3+Mnol9z5f016/Ax8EbDZDBbvrQ9EZS/MsVBtAyj5uE+6sIjXhXdabEEPfIJ0rma+ucrz5q+XYca2Bk7jfTzcLx9hpKz20OwFSYoPCSXmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S/77Miam; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S/77Miam"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727163852; x=1758699852;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7DQinbWJYr9pz315R5995DNBrONlOziueyWnA2vSf7Y=;
  b=S/77MiamptjOHyeV2CxlRVyWX80VOHEZQl+l6ljLxqAGNqFeJ4vH8Zy2
   b99TA24jSX2J/Dj/GVfKpZWhQfPDumLd+DuK+mNJhZYPyrxeYby8gj+32
   jz4H4OnR80NWRztfiesARMq2w9mEI1fj0RX8iyaj4TdntmBUS2uFhooKw
   SJe9rSggCv//K6J/b59GlfYGT3gvKQdL2TefL1Iqaf7jGYK/nKC63BhC3
   /lWGq1ldzip5Dt3WjJgTIp8pykSu26RQGmNAOMTXixXeMhVljBygoc3Gl
   0dTptf1dnk9gL2IWdm7IRcOtRmZOS3bu5uPqrfe7hdgDbs4JSPSe2Dkje
   A==;
X-CSE-ConnectionGUID: xWTz+P/9Rbe3gTbG5tlV6Q==
X-CSE-MsgGUID: iWB7V3/BQda2o6Cwp9LjZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="43612059"
X-IronPort-AV: E=Sophos;i="6.10,253,1719903600"; 
   d="scan'208";a="43612059"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 00:44:11 -0700
X-CSE-ConnectionGUID: l0KGYaohRO2ptv92GxYnow==
X-CSE-MsgGUID: 02PQ56D/QzWtzGAnYGRXVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,253,1719903600"; 
   d="scan'208";a="75433442"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 24 Sep 2024 00:44:07 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1st0DN-000I5P-1V;
	Tue, 24 Sep 2024 07:44:05 +0000
Date: Tue, 24 Sep 2024 15:43:30 +0800
From: kernel test robot <lkp@intel.com>
To: yushengjin <yushengjin@uniontech.com>, pablo@netfilter.org
Cc: oe-kbuild-all@lists.linux.dev, kadlec@netfilter.org, roopa@nvidia.com,
	razor@blackwall.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	yushengjin <yushengjin@uniontech.com>
Subject: Re: [PATCH v2] net/bridge: Optimizing read-write locks in ebtables.c
Message-ID: <202409241543.F99I82u3-lkp@intel.com>
References: <2860814445452DE8+20240924022437.119730-1-yushengjin@uniontech.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2860814445452DE8+20240924022437.119730-1-yushengjin@uniontech.com>

Hi yushengjin,

kernel test robot noticed the following build errors:

[auto build test ERROR on netfilter-nf/main]
[also build test ERROR on horms-ipvs/master linus/master v6.11 next-20240924]
[cannot apply to nf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/yushengjin/net-bridge-Optimizing-read-write-locks-in-ebtables-c/20240924-102547
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/2860814445452DE8%2B20240924022437.119730-1-yushengjin%40uniontech.com
patch subject: [PATCH v2] net/bridge: Optimizing read-write locks in ebtables.c
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20240924/202409241543.F99I82u3-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240924/202409241543.F99I82u3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409241543.F99I82u3-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/asm-generic/percpu.h:7,
                    from ./arch/sh/include/generated/asm/percpu.h:1,
                    from include/linux/irqflags.h:19,
                    from arch/sh/include/asm/cmpxchg-irq.h:5,
                    from arch/sh/include/asm/cmpxchg.h:20,
                    from arch/sh/include/asm/atomic.h:19,
                    from include/linux/atomic.h:7,
                    from include/asm-generic/bitops/atomic.h:5,
                    from arch/sh/include/asm/bitops.h:23,
                    from include/linux/bitops.h:68,
                    from include/linux/thread_info.h:27,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/sh/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:79,
                    from include/linux/spinlock.h:56,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/umh.h:4,
                    from include/linux/kmod.h:9,
                    from net/bridge/netfilter/ebtables.c:14:
   net/bridge/netfilter/ebtables.c: In function 'get_counters':
>> net/bridge/netfilter/ebtables.c:1006:30: error: 'ebt_recseq' undeclared (first use in this function); did you mean 'xt_recseq'?
    1006 |                 s = &per_cpu(ebt_recseq, cpu);
         |                              ^~~~~~~~~~
   include/linux/percpu-defs.h:219:54: note: in definition of macro '__verify_pcpu_ptr'
     219 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                                      ^~~
   include/linux/percpu-defs.h:263:49: note: in expansion of macro 'VERIFY_PERCPU_PTR'
     263 | #define per_cpu_ptr(ptr, cpu)   ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
         |                                                 ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:269:35: note: in expansion of macro 'per_cpu_ptr'
     269 | #define per_cpu(var, cpu)       (*per_cpu_ptr(&(var), cpu))
         |                                   ^~~~~~~~~~~
   net/bridge/netfilter/ebtables.c:1006:22: note: in expansion of macro 'per_cpu'
    1006 |                 s = &per_cpu(ebt_recseq, cpu);
         |                      ^~~~~~~
   net/bridge/netfilter/ebtables.c:1006:30: note: each undeclared identifier is reported only once for each function it appears in
    1006 |                 s = &per_cpu(ebt_recseq, cpu);
         |                              ^~~~~~~~~~
   include/linux/percpu-defs.h:219:54: note: in definition of macro '__verify_pcpu_ptr'
     219 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                                      ^~~
   include/linux/percpu-defs.h:263:49: note: in expansion of macro 'VERIFY_PERCPU_PTR'
     263 | #define per_cpu_ptr(ptr, cpu)   ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
         |                                                 ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:269:35: note: in expansion of macro 'per_cpu_ptr'
     269 | #define per_cpu(var, cpu)       (*per_cpu_ptr(&(var), cpu))
         |                                   ^~~~~~~~~~~
   net/bridge/netfilter/ebtables.c:1006:22: note: in expansion of macro 'per_cpu'
    1006 |                 s = &per_cpu(ebt_recseq, cpu);
         |                      ^~~~~~~
   net/bridge/netfilter/ebtables.c: In function 'do_replace_finish':
   net/bridge/netfilter/ebtables.c:1111:42: error: 'ebt_recseq' undeclared (first use in this function); did you mean 'xt_recseq'?
    1111 |                 seqcount_t *s = &per_cpu(ebt_recseq, cpu);
         |                                          ^~~~~~~~~~
   include/linux/percpu-defs.h:219:54: note: in definition of macro '__verify_pcpu_ptr'
     219 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                                      ^~~
   include/linux/percpu-defs.h:263:49: note: in expansion of macro 'VERIFY_PERCPU_PTR'
     263 | #define per_cpu_ptr(ptr, cpu)   ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
         |                                                 ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:269:35: note: in expansion of macro 'per_cpu_ptr'
     269 | #define per_cpu(var, cpu)       (*per_cpu_ptr(&(var), cpu))
         |                                   ^~~~~~~~~~~
   net/bridge/netfilter/ebtables.c:1111:34: note: in expansion of macro 'per_cpu'
    1111 |                 seqcount_t *s = &per_cpu(ebt_recseq, cpu);
         |                                  ^~~~~~~


vim +1006 net/bridge/netfilter/ebtables.c

   987	
   988	
   989	static void get_counters(const struct ebt_counter *oldcounters,
   990				 struct ebt_counter *counters, unsigned int nentries)
   991	{
   992		int i, cpu;
   993		struct ebt_counter *counter_base;
   994		seqcount_t *s;
   995	
   996		/* counters of cpu 0 */
   997		memcpy(counters, oldcounters,
   998		       sizeof(struct ebt_counter) * nentries);
   999	
  1000		/* add other counters to those of cpu 0 */
  1001		for_each_possible_cpu(cpu) {
  1002	
  1003			if (cpu == 0)
  1004				continue;
  1005	
> 1006			s = &per_cpu(ebt_recseq, cpu);
  1007			counter_base = COUNTER_BASE(oldcounters, nentries, cpu);
  1008			for (i = 0; i < nentries; i++) {
  1009				u64 bcnt, pcnt;
  1010				unsigned int start;
  1011	
  1012				do {
  1013					start = read_seqcount_begin(s);
  1014					bcnt = counter_base[i].bcnt;
  1015					pcnt = counter_base[i].pcnt;
  1016				} while (read_seqcount_retry(s, start));
  1017	
  1018				ADD_COUNTER(counters[i], bcnt, pcnt);
  1019				cond_resched();
  1020			}
  1021		}
  1022	}
  1023	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
