Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8733053363;
	Tue, 24 Sep 2024 07:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727164340; cv=none; b=BqkEHd4ENYb+/yWBFTqRQhG98RSbe/gfx3TnJlWYKEyYM9xx19S2801mVGCQpDd9jM+f59qxedg7VFXc1oNTyLilzVoYa2xq48huu7Jg/a7BpUn5Eaw/vvsZY6QhJvHcFY7Bx/tG7HDPp7cAESlih4yrguk3j8WJnlTfZwM6y+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727164340; c=relaxed/simple;
	bh=NTd0t+qinWQnAX++9XFkj7T7aFD7zwdrKxyLLskJXwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hwxicUhYl9uU23u32/pKbmrCz8LO1Wssjp1FyuPnw/Darlge4cMMWZs4ELbWH6C0CJkgTVwuc106Obb0p57SvcUkylSYZVLkdkRbB97oHYXLUmUyOauGe1+bxgA2rAboOHLUBRQyixKgWFN5RNV2n0IwJkEsv/XK4xo/a/Al+74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=mLh+uCTk; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="mLh+uCTk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1727164291;
	bh=r4eemh7jZj2u6TNqRwGZf/axJNehP4EjeRUes5xaZV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=mLh+uCTkQYHY3mIY4MbpASl/f4UJAoGy6MVuh0YpU2PnNY9q6ZaoZx7zQgCrNPipr
	 1lcU5fVR+A7MD+lXLHV3wynSq/vIHbKxAyihnqA33WcNLrKIE8Bve22ufF9z9DnZ2p
	 zqvQjIfoYvLndwp2q70cuvqV0rlMkcb+nGgLAx+k=
X-QQ-mid: bizesmtpsz10t1727164282tr3jcg
X-QQ-Originating-IP: bxMDDNVv5FlXn95gHGJiW5i+8i6XkpIgylBUVnSSyfg=
Received: from [10.20.254.18] ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 24 Sep 2024 15:51:19 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4963312410890576946
Message-ID: <14E46687CBDB8037+8f5455b2-89a5-483b-902d-c6977ee71b02@uniontech.com>
Date: Tue, 24 Sep 2024 15:51:20 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] net/bridge: Optimizing read-write locks in ebtables.c
To: kernel test robot <lkp@intel.com>, pablo@netfilter.org
Cc: oe-kbuild-all@lists.linux.dev, kadlec@netfilter.org, roopa@nvidia.com,
 razor@blackwall.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <2860814445452DE8+20240924022437.119730-1-yushengjin@uniontech.com>
 <202409241543.F99I82u3-lkp@intel.com>
From: yushengjin <yushengjin@uniontech.com>
In-Reply-To: <202409241543.F99I82u3-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4a-0


在 24/9/2024 下午3:43, kernel test robot 写道:
> Hi yushengjin,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on netfilter-nf/main]
> [also build test ERROR on horms-ipvs/master linus/master v6.11 next-20240924]
> [cannot apply to nf-next/master]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:https://github.com/intel-lab-lkp/linux/commits/yushengjin/net-bridge-Optimizing-read-write-locks-in-ebtables-c/20240924-102547
> base:https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
> patch link:https://lore.kernel.org/r/2860814445452DE8%2B20240924022437.119730-1-yushengjin%40uniontech.com
> patch subject: [PATCH v2] net/bridge: Optimizing read-write locks in ebtables.c
> config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20240924/202409241543.F99I82u3-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 14.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240924/202409241543.F99I82u3-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot<lkp@intel.com>
> | Closes:https://lore.kernel.org/oe-kbuild-all/202409241543.F99I82u3-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>     In file included from include/asm-generic/percpu.h:7,
>                      from ./arch/sh/include/generated/asm/percpu.h:1,
>                      from include/linux/irqflags.h:19,
>                      from arch/sh/include/asm/cmpxchg-irq.h:5,
>                      from arch/sh/include/asm/cmpxchg.h:20,
>                      from arch/sh/include/asm/atomic.h:19,
>                      from include/linux/atomic.h:7,
>                      from include/asm-generic/bitops/atomic.h:5,
>                      from arch/sh/include/asm/bitops.h:23,
>                      from include/linux/bitops.h:68,
>                      from include/linux/thread_info.h:27,
>                      from include/asm-generic/preempt.h:5,
>                      from ./arch/sh/include/generated/asm/preempt.h:1,
>                      from include/linux/preempt.h:79,
>                      from include/linux/spinlock.h:56,
>                      from include/linux/mmzone.h:8,
>                      from include/linux/gfp.h:7,
>                      from include/linux/umh.h:4,
>                      from include/linux/kmod.h:9,
>                      from net/bridge/netfilter/ebtables.c:14:
>     net/bridge/netfilter/ebtables.c: In function 'get_counters':
>>> net/bridge/netfilter/ebtables.c:1006:30: error: 'ebt_recseq' undeclared (first use in this function); did you mean 'xt_recseq'?
>      1006 |                 s = &per_cpu(ebt_recseq, cpu);
>           |                              ^~~~~~~~~~
>     include/linux/percpu-defs.h:219:54: note: in definition of macro '__verify_pcpu_ptr'
>       219 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
>           |                                                      ^~~
>     include/linux/percpu-defs.h:263:49: note: in expansion of macro 'VERIFY_PERCPU_PTR'
>       263 | #define per_cpu_ptr(ptr, cpu)   ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
>           |                                                 ^~~~~~~~~~~~~~~~~
>     include/linux/percpu-defs.h:269:35: note: in expansion of macro 'per_cpu_ptr'
>       269 | #define per_cpu(var, cpu)       (*per_cpu_ptr(&(var), cpu))
>           |                                   ^~~~~~~~~~~
>     net/bridge/netfilter/ebtables.c:1006:22: note: in expansion of macro 'per_cpu'
>      1006 |                 s = &per_cpu(ebt_recseq, cpu);
>           |                      ^~~~~~~
>     net/bridge/netfilter/ebtables.c:1006:30: note: each undeclared identifier is reported only once for each function it appears in
>      1006 |                 s = &per_cpu(ebt_recseq, cpu);
>           |                              ^~~~~~~~~~
>     include/linux/percpu-defs.h:219:54: note: in definition of macro '__verify_pcpu_ptr'
>       219 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
>           |                                                      ^~~
>     include/linux/percpu-defs.h:263:49: note: in expansion of macro 'VERIFY_PERCPU_PTR'
>       263 | #define per_cpu_ptr(ptr, cpu)   ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
>           |                                                 ^~~~~~~~~~~~~~~~~
>     include/linux/percpu-defs.h:269:35: note: in expansion of macro 'per_cpu_ptr'
>       269 | #define per_cpu(var, cpu)       (*per_cpu_ptr(&(var), cpu))
>           |                                   ^~~~~~~~~~~
>     net/bridge/netfilter/ebtables.c:1006:22: note: in expansion of macro 'per_cpu'
>      1006 |                 s = &per_cpu(ebt_recseq, cpu);
>           |                      ^~~~~~~
>     net/bridge/netfilter/ebtables.c: In function 'do_replace_finish':
>     net/bridge/netfilter/ebtables.c:1111:42: error: 'ebt_recseq' undeclared (first use in this function); did you mean 'xt_recseq'?
>      1111 |                 seqcount_t *s = &per_cpu(ebt_recseq, cpu);
>           |                                          ^~~~~~~~~~
>     include/linux/percpu-defs.h:219:54: note: in definition of macro '__verify_pcpu_ptr'
>       219 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
>           |                                                      ^~~
>     include/linux/percpu-defs.h:263:49: note: in expansion of macro 'VERIFY_PERCPU_PTR'
>       263 | #define per_cpu_ptr(ptr, cpu)   ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
>           |                                                 ^~~~~~~~~~~~~~~~~
>     include/linux/percpu-defs.h:269:35: note: in expansion of macro 'per_cpu_ptr'
>       269 | #define per_cpu(var, cpu)       (*per_cpu_ptr(&(var), cpu))
>           |                                   ^~~~~~~~~~~
>     net/bridge/netfilter/ebtables.c:1111:34: note: in expansion of macro 'per_cpu'
>      1111 |                 seqcount_t *s = &per_cpu(ebt_recseq, cpu);
>           |                                  ^~~~~~~
>
>
> vim +1006 net/bridge/netfilter/ebtables.c
>
>     987	
>     988	
>     989	static void get_counters(const struct ebt_counter *oldcounters,
>     990				 struct ebt_counter *counters, unsigned int nentries)
>     991	{
>     992		int i, cpu;
>     993		struct ebt_counter *counter_base;
>     994		seqcount_t *s;
>     995	
>     996		/* counters of cpu 0 */
>     997		memcpy(counters, oldcounters,
>     998		       sizeof(struct ebt_counter) * nentries);
>     999	
>    1000		/* add other counters to those of cpu 0 */
>    1001		for_each_possible_cpu(cpu) {
>    1002	
>    1003			if (cpu == 0)
>    1004				continue;
>    1005	
>> 1006			s = &per_cpu(ebt_recseq, cpu);
>    1007			counter_base = COUNTER_BASE(oldcounters, nentries, cpu);
>    1008			for (i = 0; i < nentries; i++) {
>    1009				u64 bcnt, pcnt;
>    1010				unsigned int start;
>    1011	
>    1012				do {
>    1013					start = read_seqcount_begin(s);
>    1014					bcnt = counter_base[i].bcnt;
>    1015					pcnt = counter_base[i].pcnt;
>    1016				} while (read_seqcount_retry(s, start));
>    1017	
>    1018				ADD_COUNTER(counters[i], bcnt, pcnt);
>    1019				cond_resched();
>    1020			}
>    1021		}
>    1022	}
>    1023	

Sorry, it's my fault, I will test it again.


> -- 0-DAY CI Kernel Test Service https://github.com/intel/lkp-tests/wiki
