Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E931FB4;
	Tue, 24 Sep 2024 08:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727166985; cv=none; b=jEYoR7HBV5UYFIW50cVW+9dHeiUDXjB8tfnqgutfbpxn7G++p3VAyVbWIef7Q9MYaTAsYemB96ErbnFFb6zMr1lz/u2Xm0WbgcKhwK881eflGJoC/aIFLefiUzJuCCOPapF7Z+2H8HxbmBRtbUkFPuoMO3HyvJd8Y/IFNAw1zWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727166985; c=relaxed/simple;
	bh=PvzIDLbN8wYzUdxseQkJ7a5/7NPNZ7NDS7H743Xb3Q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UmXAdzFukg0hQ5Rzd9m11tP7ZBFZETBFVtPZixSBJk0QUGTbSddxKTaW2btFtw29FJhTxQA01rm02y+6kxbUkRhvc+Pdj/V8k3EAz4cNGiXJglKDBT6IAgAa5KcYOQFSdxUupNl39LYIxN42ykVKDgww7HGLB3wGzwOnBD/TkdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=efvIKDxP; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="efvIKDxP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727166983; x=1758702983;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PvzIDLbN8wYzUdxseQkJ7a5/7NPNZ7NDS7H743Xb3Q8=;
  b=efvIKDxP4rdwHZUEYjxudP+1WjCiut4xPds8qDquNJdewipp/Ncq0COf
   frMTrJr9aPzuU760ZqGy8dAkbSgPDDMO/Xfh7gLxgKwHNzoz6+oHaXjib
   5rFKUdfy9AMH0IuBmaCL3BCoYs0S37XsKS+J36UrrN4eyRNRYeWlXPFYs
   jTyW2GX9fWpeMzEqg/fM+/ddYuvIO9TKUTXYg/NulSP5A3eREiRty8kFc
   HVQqfUQivXwmVqViLQq5+Prsy01FAERttuV/f5TB6POJcLWIPAXw0Exx+
   Ktu49qRwjNhrkV37W9YZxo2Zow/ve51FuGKGE8xSmhryukXMViPdfvc4T
   Q==;
X-CSE-ConnectionGUID: tu73SWk1SOyi1bEvs1i+JQ==
X-CSE-MsgGUID: UMlEyxPxTqiTAeKdMjxKKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="26265860"
X-IronPort-AV: E=Sophos;i="6.10,253,1719903600"; 
   d="scan'208";a="26265860"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 01:36:14 -0700
X-CSE-ConnectionGUID: mR6sbNqWTsmmqkMgOlNOkQ==
X-CSE-MsgGUID: +RdeeoJkSHCaXSPHQDPqUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="76114021"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 24 Sep 2024 01:36:09 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1st11i-000I7N-1b;
	Tue, 24 Sep 2024 08:36:06 +0000
Date: Tue, 24 Sep 2024 16:35:51 +0800
From: kernel test robot <lkp@intel.com>
To: yushengjin <yushengjin@uniontech.com>, pablo@netfilter.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kadlec@netfilter.org, roopa@nvidia.com, razor@blackwall.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	yushengjin <yushengjin@uniontech.com>
Subject: Re: [PATCH v2] net/bridge: Optimizing read-write locks in ebtables.c
Message-ID: <202409241627.NkoKxMEE-lkp@intel.com>
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
config: mips-bmips_stb_defconfig (https://download.01.org/0day-ci/archive/20240924/202409241627.NkoKxMEE-lkp@intel.com/config)
compiler: clang version 20.0.0git (https://github.com/llvm/llvm-project 8663a75fa2f31299ab8d1d90288d9df92aadee88)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240924/202409241627.NkoKxMEE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409241627.NkoKxMEE-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from net/bridge/netfilter/ebtables.c:17:
   In file included from include/linux/netfilter/x_tables.h:6:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:8:
   In file included from include/linux/cacheflush.h:5:
   In file included from arch/mips/include/asm/cacheflush.h:13:
   In file included from include/linux/mm.h:2232:
   include/linux/vmstat.h:517:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     517 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
>> net/bridge/netfilter/ebtables.c:1006:16: error: use of undeclared identifier 'ebt_recseq'; did you mean 'xt_recseq'?
    1006 |                 s = &per_cpu(ebt_recseq, cpu);
         |                              ^~~~~~~~~~
         |                              xt_recseq
   include/linux/percpu-defs.h:269:43: note: expanded from macro 'per_cpu'
     269 | #define per_cpu(var, cpu)       (*per_cpu_ptr(&(var), cpu))
         |                                                 ^
   include/linux/percpu-defs.h:235:20: note: expanded from macro 'per_cpu_ptr'
     235 |         __verify_pcpu_ptr(ptr);                                         \
         |                           ^
   include/linux/percpu-defs.h:219:47: note: expanded from macro '__verify_pcpu_ptr'
     219 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                                      ^
   include/linux/netfilter/x_tables.h:346:29: note: 'xt_recseq' declared here
     346 | DECLARE_PER_CPU(seqcount_t, xt_recseq);
         |                             ^
>> net/bridge/netfilter/ebtables.c:1006:16: error: use of undeclared identifier 'ebt_recseq'; did you mean 'xt_recseq'?
    1006 |                 s = &per_cpu(ebt_recseq, cpu);
         |                              ^~~~~~~~~~
         |                              xt_recseq
   include/linux/percpu-defs.h:269:43: note: expanded from macro 'per_cpu'
     269 | #define per_cpu(var, cpu)       (*per_cpu_ptr(&(var), cpu))
         |                                                 ^
   include/linux/percpu-defs.h:236:20: note: expanded from macro 'per_cpu_ptr'
     236 |         SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)));                 \
         |                           ^
   include/linux/percpu-defs.h:231:23: note: expanded from macro 'SHIFT_PERCPU_PTR'
     231 |         RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset))
         |                              ^
   include/linux/compiler.h:177:31: note: expanded from macro 'RELOC_HIDE'
     177 |      __ptr = (unsigned long) (ptr);                             \
         |                               ^
   include/linux/netfilter/x_tables.h:346:29: note: 'xt_recseq' declared here
     346 | DECLARE_PER_CPU(seqcount_t, xt_recseq);
         |                             ^
>> net/bridge/netfilter/ebtables.c:1006:16: error: use of undeclared identifier 'ebt_recseq'; did you mean 'xt_recseq'?
    1006 |                 s = &per_cpu(ebt_recseq, cpu);
         |                              ^~~~~~~~~~
         |                              xt_recseq
   include/linux/percpu-defs.h:269:43: note: expanded from macro 'per_cpu'
     269 | #define per_cpu(var, cpu)       (*per_cpu_ptr(&(var), cpu))
         |                                                 ^
   include/linux/percpu-defs.h:236:20: note: expanded from macro 'per_cpu_ptr'
     236 |         SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)));                 \
         |                           ^
   include/linux/percpu-defs.h:231:49: note: expanded from macro 'SHIFT_PERCPU_PTR'
     231 |         RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset))
         |                                                        ^
   include/linux/compiler.h:177:31: note: expanded from macro 'RELOC_HIDE'
     177 |      __ptr = (unsigned long) (ptr);                             \
         |                               ^
   include/linux/netfilter/x_tables.h:346:29: note: 'xt_recseq' declared here
     346 | DECLARE_PER_CPU(seqcount_t, xt_recseq);
         |                             ^
>> net/bridge/netfilter/ebtables.c:1006:16: error: use of undeclared identifier 'ebt_recseq'; did you mean 'xt_recseq'?
    1006 |                 s = &per_cpu(ebt_recseq, cpu);
         |                              ^~~~~~~~~~
         |                              xt_recseq
   include/linux/percpu-defs.h:269:43: note: expanded from macro 'per_cpu'
     269 | #define per_cpu(var, cpu)       (*per_cpu_ptr(&(var), cpu))
         |                                                 ^
   include/linux/percpu-defs.h:236:20: note: expanded from macro 'per_cpu_ptr'
     236 |         SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)));                 \
         |                           ^
   include/linux/percpu-defs.h:231:23: note: expanded from macro 'SHIFT_PERCPU_PTR'
     231 |         RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset))
         |                              ^
   include/linux/compiler.h:178:13: note: expanded from macro 'RELOC_HIDE'
     178 |     (typeof(ptr)) (__ptr + (off)); })
         |             ^
   include/linux/netfilter/x_tables.h:346:29: note: 'xt_recseq' declared here
     346 | DECLARE_PER_CPU(seqcount_t, xt_recseq);
         |                             ^
>> net/bridge/netfilter/ebtables.c:1006:16: error: use of undeclared identifier 'ebt_recseq'; did you mean 'xt_recseq'?
    1006 |                 s = &per_cpu(ebt_recseq, cpu);
         |                              ^~~~~~~~~~
         |                              xt_recseq
   include/linux/percpu-defs.h:269:43: note: expanded from macro 'per_cpu'
     269 | #define per_cpu(var, cpu)       (*per_cpu_ptr(&(var), cpu))
         |                                                 ^
   include/linux/percpu-defs.h:236:20: note: expanded from macro 'per_cpu_ptr'
     236 |         SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)));                 \
         |                           ^
   include/linux/percpu-defs.h:231:49: note: expanded from macro 'SHIFT_PERCPU_PTR'
     231 |         RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset))
         |                                                        ^
   include/linux/compiler.h:178:13: note: expanded from macro 'RELOC_HIDE'
     178 |     (typeof(ptr)) (__ptr + (off)); })
         |             ^
   include/linux/netfilter/x_tables.h:346:29: note: 'xt_recseq' declared here
     346 | DECLARE_PER_CPU(seqcount_t, xt_recseq);
         |                             ^
   net/bridge/netfilter/ebtables.c:1111:28: error: use of undeclared identifier 'ebt_recseq'; did you mean 'xt_recseq'?
    1111 |                 seqcount_t *s = &per_cpu(ebt_recseq, cpu);
         |                                          ^~~~~~~~~~
         |                                          xt_recseq
   include/linux/percpu-defs.h:269:43: note: expanded from macro 'per_cpu'
     269 | #define per_cpu(var, cpu)       (*per_cpu_ptr(&(var), cpu))
         |                                                 ^
   include/linux/percpu-defs.h:235:20: note: expanded from macro 'per_cpu_ptr'
     235 |         __verify_pcpu_ptr(ptr);                                         \
         |                           ^
   include/linux/percpu-defs.h:219:47: note: expanded from macro '__verify_pcpu_ptr'
     219 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                                      ^
   include/linux/netfilter/x_tables.h:346:29: note: 'xt_recseq' declared here
     346 | DECLARE_PER_CPU(seqcount_t, xt_recseq);
         |                             ^
   net/bridge/netfilter/ebtables.c:1111:28: error: use of undeclared identifier 'ebt_recseq'; did you mean 'xt_recseq'?
    1111 |                 seqcount_t *s = &per_cpu(ebt_recseq, cpu);
         |                                          ^~~~~~~~~~
         |                                          xt_recseq
   include/linux/percpu-defs.h:269:43: note: expanded from macro 'per_cpu'
     269 | #define per_cpu(var, cpu)       (*per_cpu_ptr(&(var), cpu))
         |                                                 ^
   include/linux/percpu-defs.h:236:20: note: expanded from macro 'per_cpu_ptr'
     236 |         SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)));                 \
         |                           ^
   include/linux/percpu-defs.h:231:23: note: expanded from macro 'SHIFT_PERCPU_PTR'
     231 |         RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset))
         |                              ^
   include/linux/compiler.h:177:31: note: expanded from macro 'RELOC_HIDE'
     177 |      __ptr = (unsigned long) (ptr);                             \
         |                               ^
   include/linux/netfilter/x_tables.h:346:29: note: 'xt_recseq' declared here
     346 | DECLARE_PER_CPU(seqcount_t, xt_recseq);
         |                             ^
   net/bridge/netfilter/ebtables.c:1111:28: error: use of undeclared identifier 'ebt_recseq'; did you mean 'xt_recseq'?
    1111 |                 seqcount_t *s = &per_cpu(ebt_recseq, cpu);
         |                                          ^~~~~~~~~~
         |                                          xt_recseq
   include/linux/percpu-defs.h:269:43: note: expanded from macro 'per_cpu'
     269 | #define per_cpu(var, cpu)       (*per_cpu_ptr(&(var), cpu))
         |                                                 ^
   include/linux/percpu-defs.h:236:20: note: expanded from macro 'per_cpu_ptr'
     236 |         SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)));                 \
         |                           ^
   include/linux/percpu-defs.h:231:49: note: expanded from macro 'SHIFT_PERCPU_PTR'
     231 |         RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset))
         |                                                        ^
   include/linux/compiler.h:177:31: note: expanded from macro 'RELOC_HIDE'
     177 |      __ptr = (unsigned long) (ptr);                             \
         |                               ^
   include/linux/netfilter/x_tables.h:346:29: note: 'xt_recseq' declared here
     346 | DECLARE_PER_CPU(seqcount_t, xt_recseq);
         |                             ^
   net/bridge/netfilter/ebtables.c:1111:28: error: use of undeclared identifier 'ebt_recseq'; did you mean 'xt_recseq'?
    1111 |                 seqcount_t *s = &per_cpu(ebt_recseq, cpu);
         |                                          ^~~~~~~~~~
         |                                          xt_recseq
   include/linux/percpu-defs.h:269:43: note: expanded from macro 'per_cpu'
     269 | #define per_cpu(var, cpu)       (*per_cpu_ptr(&(var), cpu))
         |                                                 ^
   include/linux/percpu-defs.h:236:20: note: expanded from macro 'per_cpu_ptr'
     236 |         SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)));                 \
         |                           ^
   include/linux/percpu-defs.h:231:23: note: expanded from macro 'SHIFT_PERCPU_PTR'
     231 |         RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset))
         |                              ^
   include/linux/compiler.h:178:13: note: expanded from macro 'RELOC_HIDE'
     178 |     (typeof(ptr)) (__ptr + (off)); })
         |             ^
   include/linux/netfilter/x_tables.h:346:29: note: 'xt_recseq' declared here
     346 | DECLARE_PER_CPU(seqcount_t, xt_recseq);
         |                             ^
   net/bridge/netfilter/ebtables.c:1111:28: error: use of undeclared identifier 'ebt_recseq'; did you mean 'xt_recseq'?
    1111 |                 seqcount_t *s = &per_cpu(ebt_recseq, cpu);
         |                                          ^~~~~~~~~~
         |                                          xt_recseq
   include/linux/percpu-defs.h:269:43: note: expanded from macro 'per_cpu'
     269 | #define per_cpu(var, cpu)       (*per_cpu_ptr(&(var), cpu))
         |                                                 ^
   include/linux/percpu-defs.h:236:20: note: expanded from macro 'per_cpu_ptr'
     236 |         SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)));                 \


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
