Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2113F57C73F
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 22:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790201229; cv=none; b=TsYOnEJ8anPvQKkdv4THSHK2bNCJ1qHcrBcPiz8IoJ/FH8NKrs1DCTFK0IPAVTqDRExy/+mFyiUgJIm9Zj/c1k7Whwz5wdvz2R0+ImysAzbSSjPnebRvWe8FbNULGZfT3DWicwcCDKHbklBHrD7wR+IrvKPnIe001HrJ3a5JZy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790201229; c=relaxed/simple;
	bh=yK/yXkASRxIsYTnvD8vH6zazE3XFm4WzWgKc0CpmxKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tko1Mp3t86/I44DSVpLfuqxK2/uor/+hXbALYlzBOAyisfb+Z8C7+rEIlGk+En8Oueqlv5K2LbNpPeGSSM2cmTHu4oZVn++qNdDZR9vpgCwhNxSTFX0IQWDDxASipKsyWjz4f4kE15wAF4F8w5v6lffDKTo/Az65fb0FD5vP34k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E/cK3b01; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E/cK3b01"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790201223; x=1821737223;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yK/yXkASRxIsYTnvD8vH6zazE3XFm4WzWgKc0CpmxKo=;
  b=E/cK3b01oFNZJU7/HP4RanEISucndy9qLdRTm29+jDAI5YvVareta8Dt
   L+PDuju5QV8H5su6e7/NKc8P1aaJcfHtSF0Cb/f8Vbko1uTE3HnqTLQ7j
   NxlfcIzsmfr2+pr+eMq8T/LF0q4FuxGKE7gKUBALe4Wo5sII2847T28rw
   teezU/wbDKSBjwIXcnYacycbLZesKXzyW6v+QxkAINPTXF8h/3sUPLB2R
   hhW9zgV6uUT9zcE4BtyeOCpEWCDVgUk2akr29wrnGVpB+MkNW9O+wEz/Y
   zifXnIsN48j5cpKBAQqM/2O/m7qS2yF3XNXPUHzz8z7VpH80gXLXuKNSq
   g==;
X-CSE-ConnectionGUID: XRPMq0d7RRGX62j0IKsoJg==
X-CSE-MsgGUID: E4XPiUdYS/OILYzDDmeEIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="94765097"
X-IronPort-AV: E=Sophos;i="6.27,119,1787036400"; 
   d="scan'208";a="94765097"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 15:06:43 -0700
X-CSE-ConnectionGUID: Fm1hWdSISnCVeTbU9HcRKw==
X-CSE-MsgGUID: UubW0czlQKu8bdX65YRmVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,119,1787036400"; 
   d="scan'208";a="5056501"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa013.fm.intel.com with ESMTP; 23 Sep 2026 15:06:40 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x9V6q-00000000Hr4-3qgT;
	Wed, 23 Sep 2026 22:06:36 +0000
Date: Thu, 24 Sep 2026 06:06:15 +0800
From: kernel test robot <lkp@intel.com>
To: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	coreteam@netfilter.org, pablo@netfilter.org, fw@strlen.de,
	phil@nwl.cc, eric@regit.org,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Yu Junzhe <junzheyu1@gmail.com>
Subject: Re: [PATCH nf v2] netfilter: nft_reject: prevent unbounded recursion
 in output hooks
Message-ID: <202609240611.MRXjmn1k-lkp@intel.com>
References: <20260922092503.3238-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922092503.3238-1-fmancera@suse.de>

Hi Fernando,

kernel test robot noticed the following build errors:

[auto build test ERROR on netfilter-nf/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Fernando-Fernandez-Mancera/netfilter-nft_reject-prevent-unbounded-recursion-in-output-hooks/20260922-112503
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20260922092503.3238-1-fmancera%40suse.de
patch subject: [PATCH nf v2] netfilter: nft_reject: prevent unbounded recursion in output hooks
config: i386-defconfig (https://download.01.org/0day-ci/archive/20260924/202609240611.MRXjmn1k-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260924/202609240611.MRXjmn1k-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609240611.MRXjmn1k-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
>> include/net/netfilter/nf_recursion.h:12:52: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      12 |         return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                         ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:432:15: note: expanded from macro '__this_cpu_read'
     432 |         raw_cpu_read(pcp);                                              \
         |                      ^~~
   include/linux/percpu-defs.h:407:67: note: expanded from macro 'raw_cpu_read'
     407 | #define raw_cpu_read(pcp)               __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                                                                                ^~~
   include/linux/percpu-defs.h:317:16: note: expanded from macro '__pcpu_size_call_return'
     317 |         TYPEOF_UNQUAL(variable) pscr_ret__;                             \
         |                       ^~~~~~~~
   include/linux/compiler.h:237:47: note: expanded from macro 'TYPEOF_UNQUAL'
     237 | # define TYPEOF_UNQUAL(exp) __typeof_unqual__(exp)
         |                                               ^~~
   include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
>> include/net/netfilter/nf_recursion.h:12:52: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      12 |         return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                         ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:432:15: note: expanded from macro '__this_cpu_read'
     432 |         raw_cpu_read(pcp);                                              \
         |                      ^~~
   include/linux/percpu-defs.h:407:67: note: expanded from macro 'raw_cpu_read'
     407 | #define raw_cpu_read(pcp)               __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                                                                                ^~~
   include/linux/percpu-defs.h:318:22: note: expanded from macro '__pcpu_size_call_return'
     318 |         __verify_pcpu_ptr(&(variable));                                 \
         |                             ^~~~~~~~
   include/linux/percpu-defs.h:216:47: note: expanded from macro '__verify_pcpu_ptr'
     216 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                                      ^~~
   include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
>> include/net/netfilter/nf_recursion.h:12:52: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      12 |         return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                         ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:432:15: note: expanded from macro '__this_cpu_read'
     432 |         raw_cpu_read(pcp);                                              \
         |                      ^~~
   include/linux/percpu-defs.h:407:67: note: expanded from macro 'raw_cpu_read'
     407 | #define raw_cpu_read(pcp)               __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                                                                                ^~~
   include/linux/percpu-defs.h:319:16: note: expanded from macro '__pcpu_size_call_return'
     319 |         switch(sizeof(variable)) {                                      \
         |                       ^~~~~~~~
   include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
>> include/net/netfilter/nf_recursion.h:12:52: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      12 |         return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                         ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:432:15: note: expanded from macro '__this_cpu_read'
     432 |         raw_cpu_read(pcp);                                              \
         |                      ^~~
   include/linux/percpu-defs.h:407:67: note: expanded from macro 'raw_cpu_read'
     407 | #define raw_cpu_read(pcp)               __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                                                                                ^~~
   include/linux/percpu-defs.h:320:31: note: expanded from macro '__pcpu_size_call_return'
     320 |         case 1: pscr_ret__ = stem##1(variable); break;                  \
         |                                      ^~~~~~~~
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   arch/x86/include/asm/percpu.h:94:45: note: expanded from macro '__my_cpu_ptr'
      94 | # define __my_cpu_ptr(ptr)      (__my_cpu_type(*(ptr))*)(__force uintptr_t)(ptr)
         |                                                  ^~~
   arch/x86/include/asm/percpu.h:93:36: note: expanded from macro '__my_cpu_type'
      93 | # define __my_cpu_type(var)     typeof(var) __percpu_seg_override
         |                                        ^~~
   include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
>> include/net/netfilter/nf_recursion.h:12:52: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      12 |         return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                         ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:432:15: note: expanded from macro '__this_cpu_read'
     432 |         raw_cpu_read(pcp);                                              \
         |                      ^~~
   include/linux/percpu-defs.h:407:67: note: expanded from macro 'raw_cpu_read'
     407 | #define raw_cpu_read(pcp)               __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                                                                                ^~~
   include/linux/percpu-defs.h:320:31: note: expanded from macro '__pcpu_size_call_return'
     320 |         case 1: pscr_ret__ = stem##1(variable); break;                  \
         |                                      ^~~~~~~~
   note: (skipping 2 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   arch/x86/include/asm/percpu.h:95:45: note: expanded from macro '__my_cpu_var'
      95 | # define __my_cpu_var(var)      (*__my_cpu_ptr(&(var)))
         |                                                  ^~~
   arch/x86/include/asm/percpu.h:94:72: note: expanded from macro '__my_cpu_ptr'
      94 | # define __my_cpu_ptr(ptr)      (__my_cpu_type(*(ptr))*)(__force uintptr_t)(ptr)
         |                                                                             ^~~
   include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
>> include/net/netfilter/nf_recursion.h:12:52: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      12 |         return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                         ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:432:15: note: expanded from macro '__this_cpu_read'
     432 |         raw_cpu_read(pcp);                                              \
         |                      ^~~
   include/linux/percpu-defs.h:407:67: note: expanded from macro 'raw_cpu_read'
     407 | #define raw_cpu_read(pcp)               __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                                                                                ^~~
   include/linux/percpu-defs.h:320:31: note: expanded from macro '__pcpu_size_call_return'
     320 |         case 1: pscr_ret__ = stem##1(variable); break;                  \
         |                                      ^~~~~~~~
   arch/x86/include/asm/percpu.h:450:52: note: expanded from macro 'raw_cpu_read_1'
     450 | #define raw_cpu_read_1(pcp)                             __raw_cpu_read(1, , pcp)
         |                                                                             ^~~
   arch/x86/include/asm/percpu.h:156:10: note: expanded from macro '__raw_cpu_read'
     156 |         (typeof(_var))(unsigned long) pfo_val__;                        \
         |                 ^~~~
   include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
>> include/net/netfilter/nf_recursion.h:12:52: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      12 |         return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                         ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:432:15: note: expanded from macro '__this_cpu_read'
     432 |         raw_cpu_read(pcp);                                              \
         |                      ^~~
   include/linux/percpu-defs.h:407:67: note: expanded from macro 'raw_cpu_read'
     407 | #define raw_cpu_read(pcp)               __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                                                                                ^~~
   include/linux/percpu-defs.h:321:31: note: expanded from macro '__pcpu_size_call_return'
     321 |         case 2: pscr_ret__ = stem##2(variable); break;                  \
         |                                      ^~~~~~~~
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   arch/x86/include/asm/percpu.h:94:45: note: expanded from macro '__my_cpu_ptr'
      94 | # define __my_cpu_ptr(ptr)      (__my_cpu_type(*(ptr))*)(__force uintptr_t)(ptr)
         |                                                  ^~~
   arch/x86/include/asm/percpu.h:93:36: note: expanded from macro '__my_cpu_type'
      93 | # define __my_cpu_type(var)     typeof(var) __percpu_seg_override
         |                                        ^~~
   include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
>> include/net/netfilter/nf_recursion.h:12:52: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      12 |         return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                         ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:432:15: note: expanded from macro '__this_cpu_read'
     432 |         raw_cpu_read(pcp);                                              \
         |                      ^~~
   include/linux/percpu-defs.h:407:67: note: expanded from macro 'raw_cpu_read'
     407 | #define raw_cpu_read(pcp)               __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                                                                                ^~~
   include/linux/percpu-defs.h:321:31: note: expanded from macro '__pcpu_size_call_return'
     321 |         case 2: pscr_ret__ = stem##2(variable); break;                  \
         |                                      ^~~~~~~~
   note: (skipping 2 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   arch/x86/include/asm/percpu.h:95:45: note: expanded from macro '__my_cpu_var'
      95 | # define __my_cpu_var(var)      (*__my_cpu_ptr(&(var)))
         |                                                  ^~~
   arch/x86/include/asm/percpu.h:94:72: note: expanded from macro '__my_cpu_ptr'
      94 | # define __my_cpu_ptr(ptr)      (__my_cpu_type(*(ptr))*)(__force uintptr_t)(ptr)
         |                                                                             ^~~
   include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
>> include/net/netfilter/nf_recursion.h:12:52: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      12 |         return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                         ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:432:15: note: expanded from macro '__this_cpu_read'
     432 |         raw_cpu_read(pcp);                                              \
         |                      ^~~
   include/linux/percpu-defs.h:407:67: note: expanded from macro 'raw_cpu_read'
     407 | #define raw_cpu_read(pcp)               __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                                                                                ^~~
   include/linux/percpu-defs.h:321:31: note: expanded from macro '__pcpu_size_call_return'
     321 |         case 2: pscr_ret__ = stem##2(variable); break;                  \
         |                                      ^~~~~~~~
   arch/x86/include/asm/percpu.h:451:52: note: expanded from macro 'raw_cpu_read_2'
     451 | #define raw_cpu_read_2(pcp)                             __raw_cpu_read(2, , pcp)
         |                                                                             ^~~
   arch/x86/include/asm/percpu.h:156:10: note: expanded from macro '__raw_cpu_read'
     156 |         (typeof(_var))(unsigned long) pfo_val__;                        \
         |                 ^~~~
   include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
>> include/net/netfilter/nf_recursion.h:12:52: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      12 |         return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                         ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:432:15: note: expanded from macro '__this_cpu_read'
     432 |         raw_cpu_read(pcp);                                              \
         |                      ^~~
   include/linux/percpu-defs.h:407:67: note: expanded from macro 'raw_cpu_read'
     407 | #define raw_cpu_read(pcp)               __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                                                                                ^~~
   include/linux/percpu-defs.h:322:31: note: expanded from macro '__pcpu_size_call_return'
     322 |         case 4: pscr_ret__ = stem##4(variable); break;                  \
         |                                      ^~~~~~~~
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   arch/x86/include/asm/percpu.h:94:45: note: expanded from macro '__my_cpu_ptr'
      94 | # define __my_cpu_ptr(ptr)      (__my_cpu_type(*(ptr))*)(__force uintptr_t)(ptr)
         |                                                  ^~~
   arch/x86/include/asm/percpu.h:93:36: note: expanded from macro '__my_cpu_type'
      93 | # define __my_cpu_type(var)     typeof(var) __percpu_seg_override
         |                                        ^~~
   include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
>> include/net/netfilter/nf_recursion.h:12:52: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      12 |         return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                         ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:432:15: note: expanded from macro '__this_cpu_read'
     432 |         raw_cpu_read(pcp);                                              \
         |                      ^~~
   include/linux/percpu-defs.h:407:67: note: expanded from macro 'raw_cpu_read'
     407 | #define raw_cpu_read(pcp)               __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                                                                                ^~~
   include/linux/percpu-defs.h:322:31: note: expanded from macro '__pcpu_size_call_return'
     322 |         case 4: pscr_ret__ = stem##4(variable); break;                  \
         |                                      ^~~~~~~~
   note: (skipping 2 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   arch/x86/include/asm/percpu.h:95:45: note: expanded from macro '__my_cpu_var'
      95 | # define __my_cpu_var(var)      (*__my_cpu_ptr(&(var)))
         |                                                  ^~~
   arch/x86/include/asm/percpu.h:94:72: note: expanded from macro '__my_cpu_ptr'
      94 | # define __my_cpu_ptr(ptr)      (__my_cpu_type(*(ptr))*)(__force uintptr_t)(ptr)
         |                                                                             ^~~
   include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
>> include/net/netfilter/nf_recursion.h:12:52: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      12 |         return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                         ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:432:15: note: expanded from macro '__this_cpu_read'
     432 |         raw_cpu_read(pcp);                                              \
         |                      ^~~
   include/linux/percpu-defs.h:407:67: note: expanded from macro 'raw_cpu_read'
     407 | #define raw_cpu_read(pcp)               __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                                                                                ^~~
   include/linux/percpu-defs.h:322:31: note: expanded from macro '__pcpu_size_call_return'
     322 |         case 4: pscr_ret__ = stem##4(variable); break;                  \
         |                                      ^~~~~~~~
   arch/x86/include/asm/percpu.h:452:52: note: expanded from macro 'raw_cpu_read_4'
     452 | #define raw_cpu_read_4(pcp)                             __raw_cpu_read(4, , pcp)
         |                                                                             ^~~
   arch/x86/include/asm/percpu.h:156:10: note: expanded from macro '__raw_cpu_read'
     156 |         (typeof(_var))(unsigned long) pfo_val__;                        \
         |                 ^~~~
   include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
>> include/net/netfilter/nf_recursion.h:12:52: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      12 |         return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                         ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:432:15: note: expanded from macro '__this_cpu_read'
     432 |         raw_cpu_read(pcp);                                              \
         |                      ^~~
   include/linux/percpu-defs.h:407:67: note: expanded from macro 'raw_cpu_read'
     407 | #define raw_cpu_read(pcp)               __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                                                                                ^~~
   include/linux/percpu-defs.h:323:31: note: expanded from macro '__pcpu_size_call_return'
     323 |         case 8: pscr_ret__ = stem##8(variable); break;                  \
         |                                      ^~~~~~~~
   note: (skipping 2 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/percpu-defs.h:240:20: note: expanded from macro 'raw_cpu_ptr'
     240 |         __verify_pcpu_ptr(ptr);                                         \
         |                           ^~~
   include/linux/percpu-defs.h:216:47: note: expanded from macro '__verify_pcpu_ptr'
     216 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                                      ^~~
   include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
>> include/net/netfilter/nf_recursion.h:12:52: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      12 |         return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                         ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:432:15: note: expanded from macro '__this_cpu_read'
     432 |         raw_cpu_read(pcp);                                              \
         |                      ^~~
   include/linux/percpu-defs.h:407:67: note: expanded from macro 'raw_cpu_read'
     407 | #define raw_cpu_read(pcp)               __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                                                                                ^~~
   include/linux/percpu-defs.h:323:31: note: expanded from macro '__pcpu_size_call_return'
     323 |         case 8: pscr_ret__ = stem##8(variable); break;                  \
         |                                      ^~~~~~~~
   note: (skipping 2 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/percpu-defs.h:241:19: note: expanded from macro 'raw_cpu_ptr'
     241 |         arch_raw_cpu_ptr(ptr);                                          \
         |                          ^~~
   arch/x86/include/asm/percpu.h:66:39: note: expanded from macro 'arch_raw_cpu_ptr'
      66 |         tcp_ptr__ += (__force unsigned long)(_ptr);                     \
         |                                              ^~~~
   include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
>> include/net/netfilter/nf_recursion.h:12:52: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      12 |         return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                         ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:432:15: note: expanded from macro '__this_cpu_read'
     432 |         raw_cpu_read(pcp);                                              \
         |                      ^~~
   include/linux/percpu-defs.h:407:67: note: expanded from macro 'raw_cpu_read'
     407 | #define raw_cpu_read(pcp)               __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                                                                                ^~~
   include/linux/percpu-defs.h:323:31: note: expanded from macro '__pcpu_size_call_return'
     323 |         case 8: pscr_ret__ = stem##8(variable); break;                  \
         |                                      ^~~~~~~~
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   arch/x86/include/asm/percpu.h:67:19: note: expanded from macro 'arch_raw_cpu_ptr'
      67 |         (TYPEOF_UNQUAL(*(_ptr)) __force __kernel *)tcp_ptr__;           \
         |                          ^~~~
   include/linux/compiler.h:237:47: note: expanded from macro 'TYPEOF_UNQUAL'
     237 | # define TYPEOF_UNQUAL(exp) __typeof_unqual__(exp)
         |                                               ^~~
   include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
   include/net/netfilter/nf_recursion.h:18:35: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      18 |         __this_cpu_inc(softnet_data.xmit.nf_dup_skb_recursion);
         |                        ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:484:45: note: expanded from macro '__this_cpu_inc'
     484 | #define __this_cpu_inc(pcp)             __this_cpu_add(pcp, 1)
         |                                                        ^~~
   include/linux/percpu-defs.h:444:14: note: expanded from macro '__this_cpu_add'
     444 |         raw_cpu_add(pcp, val);                                          \
         |                     ^~~
   include/linux/percpu-defs.h:409:63: note: expanded from macro 'raw_cpu_add'
     409 | #define raw_cpu_add(pcp, val)           __pcpu_size_call(raw_cpu_add_, pcp, val)
         |                                                                        ^~~
   include/linux/percpu-defs.h:362:22: note: expanded from macro '__pcpu_size_call'
     362 |         __verify_pcpu_ptr(&(variable));                                 \
         |                             ^~~~~~~~
   include/linux/percpu-defs.h:216:47: note: expanded from macro '__verify_pcpu_ptr'
     216 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                                      ^~~
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
   include/net/netfilter/nf_recursion.h:18:35: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      18 |         __this_cpu_inc(softnet_data.xmit.nf_dup_skb_recursion);
         |                        ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:484:45: note: expanded from macro '__this_cpu_inc'
     484 | #define __this_cpu_inc(pcp)             __this_cpu_add(pcp, 1)
         |                                                        ^~~
   include/linux/percpu-defs.h:444:14: note: expanded from macro '__this_cpu_add'
     444 |         raw_cpu_add(pcp, val);                                          \
         |                     ^~~
   include/linux/percpu-defs.h:409:63: note: expanded from macro 'raw_cpu_add'
     409 | #define raw_cpu_add(pcp, val)           __pcpu_size_call(raw_cpu_add_, pcp, val)
         |                                                                        ^~~
   include/linux/percpu-defs.h:363:16: note: expanded from macro '__pcpu_size_call'
     363 |         switch(sizeof(variable)) {                                      \
         |                       ^~~~~~~~
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
   include/net/netfilter/nf_recursion.h:18:35: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      18 |         __this_cpu_inc(softnet_data.xmit.nf_dup_skb_recursion);
         |                        ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:484:45: note: expanded from macro '__this_cpu_inc'
     484 | #define __this_cpu_inc(pcp)             __this_cpu_add(pcp, 1)
         |                                                        ^~~
   include/linux/percpu-defs.h:444:14: note: expanded from macro '__this_cpu_add'
     444 |         raw_cpu_add(pcp, val);                                          \
         |                     ^~~
   include/linux/percpu-defs.h:409:63: note: expanded from macro 'raw_cpu_add'
     409 | #define raw_cpu_add(pcp, val)           __pcpu_size_call(raw_cpu_add_, pcp, val)
         |                                                                        ^~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   arch/x86/include/asm/percpu.h:468:56: note: expanded from macro 'raw_cpu_add_1'
     468 | #define raw_cpu_add_1(pcp, val)                         percpu_add_op(1, , (pcp), val)
         |                                                                             ^~~
   arch/x86/include/asm/percpu.h:226:17: note: expanded from macro 'percpu_add_op'
     226 |                 TYPEOF_UNQUAL(var) pao_tmp__;                           \
         |                               ^~~
   include/linux/compiler.h:237:47: note: expanded from macro 'TYPEOF_UNQUAL'
     237 | # define TYPEOF_UNQUAL(exp) __typeof_unqual__(exp)
         |                                               ^~~
   In file included from net/ipv4/netfilter/nf_reject_ipv4.c:13:
   include/net/netfilter/nf_recursion.h:18:35: error: no member named 'nf_dup_skb_recursion' in 'struct netdev_xmit'
      18 |         __this_cpu_inc(softnet_data.xmit.nf_dup_skb_recursion);
         |                        ~~~~~~~~~~~~~~~~~ ^
   include/linux/percpu-defs.h:484:45: note: expanded from macro '__this_cpu_inc'
     484 | #define __this_cpu_inc(pcp)             __this_cpu_add(pcp, 1)
         |                                                        ^~~
   include/linux/percpu-defs.h:444:14: note: expanded from macro '__this_cpu_add'
     444 |         raw_cpu_add(pcp, val);                                          \
         |                     ^~~
   include/linux/percpu-defs.h:409:63: note: expanded from macro 'raw_cpu_add'
     409 | #define raw_cpu_add(pcp, val)           __pcpu_size_call(raw_cpu_add_, pcp, val)
         |                                                                        ^~~
   note: (skipping 4 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   arch/x86/include/asm/percpu.h:95:45: note: expanded from macro '__my_cpu_var'
      95 | # define __my_cpu_var(var)      (*__my_cpu_ptr(&(var)))
         |                                                  ^~~
   arch/x86/include/asm/percpu.h:94:45: note: expanded from macro '__my_cpu_ptr'
      94 | # define __my_cpu_ptr(ptr)      (__my_cpu_type(*(ptr))*)(__force uintptr_t)(ptr)
         |                                                  ^~~
   arch/x86/include/asm/percpu.h:93:36: note: expanded from macro '__my_cpu_type'


vim +12 include/net/netfilter/nf_recursion.h

     8	
     9	#ifndef CONFIG_PREEMPT_RT
    10	static inline bool nf_dev_xmit_recursion(void)
    11	{
  > 12		return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
    13				NF_RECURSION_LIMIT);
    14	}
    15	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
