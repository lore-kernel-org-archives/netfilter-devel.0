Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E2A3A8732
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 21:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790197304; cv=none; b=BQXxe4CXcgZi3h+Jh7g+O8/XatXj/2xu8IwfHOHoYJxqF2zOZPN93R6QSJNYVdhX+zW2fRI+o78O1nvVH9T9sFDn+CdP+2AVu0R5veqc02w/I/lVWRQaRNCHbs4u5kSK7b4+2G6XIVNplnsSrkib9sICvoQH/BQXYgYwPKcIKZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790197304; c=relaxed/simple;
	bh=55evk6ILTJtGTCyARw0tnvQAAfyTGi70IgWjlC5X3m0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c6QIHhhkRnVvTM/aCBkbBpPjuNXyat7QXpWgbnyXT5LxSKtW7aaGA4hPwey/s/m8sd5UBk06a6Ovqljeo+epvpNjcPUWF2dcp4Aq6KEL18l6lJEHioN2z0kLJ9xLlEKsfugQPhGvS/Xi38LPd1VEEIULqJ14c4wDm975h+Wpms0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CKfrDVtx; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CKfrDVtx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790197299; x=1821733299;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=55evk6ILTJtGTCyARw0tnvQAAfyTGi70IgWjlC5X3m0=;
  b=CKfrDVtx/mVd+R2kwjf7GcTiiWabBrZz10ncUDfJupOS/HqwfwK1JB0S
   gI6Elx2jcV9i41i4NPleVXGs/9FiyNQZPT3XGckzqDV6LjP63Rropg7Zo
   xW7dCNp4gCrIdV8yAq5N8BKmyWnViZBy5ird6oaKzc9vopqALREJodo3S
   sHtBpyyePhYc41tYSQLNZkPfQoPNmHt2bJjDtv3qzKfE5++hIIFSNYMa/
   BQdalPOcTj0rHp6d0aKNg1y2bagAQlYYTGzNhg0OvmGCIWP20hvrB2R+8
   4idBCn0LIQ5fnT5kXdsO3gmLmhdrnMZDtX+l6q2IlhIw+CVlBGq6hN/n7
   w==;
X-CSE-ConnectionGUID: 0/BGSsvOTNOBa+2jUPslww==
X-CSE-MsgGUID: uPeuI9EiT+a3dGMal05Ygw==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="93440303"
X-IronPort-AV: E=Sophos;i="6.27,119,1787036400"; 
   d="scan'208";a="93440303"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 14:01:36 -0700
X-CSE-ConnectionGUID: oXEXX0/ITuKBpaYwF4wTvA==
X-CSE-MsgGUID: bDFFiaC6SCe8ADXe6ntrFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,119,1787036400"; 
   d="scan'208";a="278513345"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 23 Sep 2026 14:01:33 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x9U5q-00000000Hja-04uJ;
	Wed, 23 Sep 2026 21:01:30 +0000
Date: Thu, 24 Sep 2026 05:00:59 +0800
From: kernel test robot <lkp@intel.com>
To: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, coreteam@netfilter.org,
	pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, eric@regit.org,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Yu Junzhe <junzheyu1@gmail.com>
Subject: Re: [PATCH nf v2] netfilter: nft_reject: prevent unbounded recursion
 in output hooks
Message-ID: <202609240424.i9W3b2H2-lkp@intel.com>
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
config: arm-randconfig-1000-20260924 (https://download.01.org/0day-ci/archive/20260924/202609240424.i9W3b2H2-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260924/202609240424.i9W3b2H2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609240424.i9W3b2H2-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/build_bug.h:5,
                    from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/module.h:12,
                    from net/ipv4/netfilter/nf_reject_ipv4.c:6:
   include/net/netfilter/nf_recursion.h: In function 'nf_dev_xmit_recursion':
>> include/net/netfilter/nf_recursion.h:12:51: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                                   ^
   include/linux/compiler.h:77:42: note: in definition of macro 'unlikely'
      77 | # define unlikely(x) __builtin_expect(!!(x), 0)
         |                                          ^
   include/linux/percpu-defs.h:317:2: note: in expansion of macro 'TYPEOF_UNQUAL'
     317 |  TYPEOF_UNQUAL(variable) pscr_ret__;    \
         |  ^~~~~~~~~~~~~
   include/linux/percpu-defs.h:407:28: note: in expansion of macro '__pcpu_size_call_return'
     407 | #define raw_cpu_read(pcp)  __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                            ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:432:2: note: in expansion of macro 'raw_cpu_read'
     432 |  raw_cpu_read(pcp);      \
         |  ^~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:12:18: note: in expansion of macro '__this_cpu_read'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                  ^~~~~~~~~~~~~~~
>> include/net/netfilter/nf_recursion.h:12:51: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                                   ^
   include/linux/compiler.h:77:42: note: in definition of macro 'unlikely'
      77 | # define unlikely(x) __builtin_expect(!!(x), 0)
         |                                          ^
   include/linux/percpu-defs.h:318:2: note: in expansion of macro '__verify_pcpu_ptr'
     318 |  __verify_pcpu_ptr(&(variable));     \
         |  ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:407:28: note: in expansion of macro '__pcpu_size_call_return'
     407 | #define raw_cpu_read(pcp)  __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                            ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:432:2: note: in expansion of macro 'raw_cpu_read'
     432 |  raw_cpu_read(pcp);      \
         |  ^~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:12:18: note: in expansion of macro '__this_cpu_read'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                  ^~~~~~~~~~~~~~~
>> include/net/netfilter/nf_recursion.h:12:51: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                                   ^
   include/linux/compiler.h:77:42: note: in definition of macro 'unlikely'
      77 | # define unlikely(x) __builtin_expect(!!(x), 0)
         |                                          ^
   include/linux/percpu-defs.h:407:28: note: in expansion of macro '__pcpu_size_call_return'
     407 | #define raw_cpu_read(pcp)  __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                            ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:432:2: note: in expansion of macro 'raw_cpu_read'
     432 |  raw_cpu_read(pcp);      \
         |  ^~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:12:18: note: in expansion of macro '__this_cpu_read'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                  ^~~~~~~~~~~~~~~
>> include/net/netfilter/nf_recursion.h:12:51: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                                   ^
   include/linux/compiler.h:77:42: note: in definition of macro 'unlikely'
      77 | # define unlikely(x) __builtin_expect(!!(x), 0)
         |                                          ^
   include/linux/percpu-defs.h:259:2: note: in expansion of macro '__verify_pcpu_ptr'
     259 |  __verify_pcpu_ptr(ptr);      \
         |  ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:263:26: note: in expansion of macro 'per_cpu_ptr'
     263 | #define raw_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
         |                          ^~~~~~~~~~~
   include/asm-generic/percpu.h:82:3: note: in expansion of macro 'raw_cpu_ptr'
      82 |  *raw_cpu_ptr(&(pcp));      \
         |   ^~~~~~~~~~~
   include/asm-generic/percpu.h:217:30: note: in expansion of macro 'raw_cpu_generic_read'
     217 | #define raw_cpu_read_1(pcp)  raw_cpu_generic_read(pcp)
         |                              ^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:320:23: note: in expansion of macro 'raw_cpu_read_1'
     320 |  case 1: pscr_ret__ = stem##1(variable); break;   \
         |                       ^~~~
   include/linux/percpu-defs.h:407:28: note: in expansion of macro '__pcpu_size_call_return'
     407 | #define raw_cpu_read(pcp)  __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                            ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:432:2: note: in expansion of macro 'raw_cpu_read'
     432 |  raw_cpu_read(pcp);      \
         |  ^~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:12:18: note: in expansion of macro '__this_cpu_read'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                  ^~~~~~~~~~~~~~~
>> include/net/netfilter/nf_recursion.h:12:51: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                                   ^
   include/linux/compiler.h:77:42: note: in definition of macro 'unlikely'
      77 | # define unlikely(x) __builtin_expect(!!(x), 0)
         |                                          ^
   include/linux/percpu-defs.h:221:3: note: in expansion of macro 'TYPEOF_UNQUAL'
     221 |  (TYPEOF_UNQUAL(*(__p)) __force __kernel *)((__force unsigned long)(__p))
         |   ^~~~~~~~~~~~~
   include/linux/percpu-defs.h:260:2: note: in expansion of macro 'PERCPU_PTR'
     260 |  PERCPU_PTR(ptr);      \
         |  ^~~~~~~~~~
   include/linux/percpu-defs.h:263:26: note: in expansion of macro 'per_cpu_ptr'
     263 | #define raw_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
         |                          ^~~~~~~~~~~
   include/asm-generic/percpu.h:82:3: note: in expansion of macro 'raw_cpu_ptr'
      82 |  *raw_cpu_ptr(&(pcp));      \
         |   ^~~~~~~~~~~
   include/asm-generic/percpu.h:217:30: note: in expansion of macro 'raw_cpu_generic_read'
     217 | #define raw_cpu_read_1(pcp)  raw_cpu_generic_read(pcp)
         |                              ^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:320:23: note: in expansion of macro 'raw_cpu_read_1'
     320 |  case 1: pscr_ret__ = stem##1(variable); break;   \
         |                       ^~~~
   include/linux/percpu-defs.h:407:28: note: in expansion of macro '__pcpu_size_call_return'
     407 | #define raw_cpu_read(pcp)  __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                            ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:432:2: note: in expansion of macro 'raw_cpu_read'
     432 |  raw_cpu_read(pcp);      \
         |  ^~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:12:18: note: in expansion of macro '__this_cpu_read'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                  ^~~~~~~~~~~~~~~
>> include/net/netfilter/nf_recursion.h:12:51: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                                   ^
   include/linux/compiler.h:77:42: note: in definition of macro 'unlikely'
      77 | # define unlikely(x) __builtin_expect(!!(x), 0)
         |                                          ^
   include/linux/percpu-defs.h:260:2: note: in expansion of macro 'PERCPU_PTR'
     260 |  PERCPU_PTR(ptr);      \
         |  ^~~~~~~~~~
   include/linux/percpu-defs.h:263:26: note: in expansion of macro 'per_cpu_ptr'
     263 | #define raw_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
         |                          ^~~~~~~~~~~
   include/asm-generic/percpu.h:82:3: note: in expansion of macro 'raw_cpu_ptr'
      82 |  *raw_cpu_ptr(&(pcp));      \
         |   ^~~~~~~~~~~
   include/asm-generic/percpu.h:217:30: note: in expansion of macro 'raw_cpu_generic_read'
     217 | #define raw_cpu_read_1(pcp)  raw_cpu_generic_read(pcp)
         |                              ^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:320:23: note: in expansion of macro 'raw_cpu_read_1'
     320 |  case 1: pscr_ret__ = stem##1(variable); break;   \
         |                       ^~~~
   include/linux/percpu-defs.h:407:28: note: in expansion of macro '__pcpu_size_call_return'
     407 | #define raw_cpu_read(pcp)  __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                            ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:432:2: note: in expansion of macro 'raw_cpu_read'
     432 |  raw_cpu_read(pcp);      \
         |  ^~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:12:18: note: in expansion of macro '__this_cpu_read'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                  ^~~~~~~~~~~~~~~
>> include/net/netfilter/nf_recursion.h:12:51: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                                   ^
   include/linux/compiler.h:77:42: note: in definition of macro 'unlikely'
      77 | # define unlikely(x) __builtin_expect(!!(x), 0)
         |                                          ^
   include/linux/percpu-defs.h:259:2: note: in expansion of macro '__verify_pcpu_ptr'
     259 |  __verify_pcpu_ptr(ptr);      \
         |  ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:263:26: note: in expansion of macro 'per_cpu_ptr'
     263 | #define raw_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
         |                          ^~~~~~~~~~~
   include/asm-generic/percpu.h:82:3: note: in expansion of macro 'raw_cpu_ptr'
      82 |  *raw_cpu_ptr(&(pcp));      \
         |   ^~~~~~~~~~~
   include/asm-generic/percpu.h:220:30: note: in expansion of macro 'raw_cpu_generic_read'
     220 | #define raw_cpu_read_2(pcp)  raw_cpu_generic_read(pcp)
         |                              ^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:321:23: note: in expansion of macro 'raw_cpu_read_2'
     321 |  case 2: pscr_ret__ = stem##2(variable); break;   \
         |                       ^~~~
   include/linux/percpu-defs.h:407:28: note: in expansion of macro '__pcpu_size_call_return'
     407 | #define raw_cpu_read(pcp)  __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                            ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:432:2: note: in expansion of macro 'raw_cpu_read'
     432 |  raw_cpu_read(pcp);      \
         |  ^~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:12:18: note: in expansion of macro '__this_cpu_read'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                  ^~~~~~~~~~~~~~~
>> include/net/netfilter/nf_recursion.h:12:51: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                                   ^
   include/linux/compiler.h:77:42: note: in definition of macro 'unlikely'
      77 | # define unlikely(x) __builtin_expect(!!(x), 0)
         |                                          ^
   include/linux/percpu-defs.h:221:3: note: in expansion of macro 'TYPEOF_UNQUAL'
     221 |  (TYPEOF_UNQUAL(*(__p)) __force __kernel *)((__force unsigned long)(__p))
         |   ^~~~~~~~~~~~~
   include/linux/percpu-defs.h:260:2: note: in expansion of macro 'PERCPU_PTR'
     260 |  PERCPU_PTR(ptr);      \
         |  ^~~~~~~~~~
   include/linux/percpu-defs.h:263:26: note: in expansion of macro 'per_cpu_ptr'
     263 | #define raw_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
         |                          ^~~~~~~~~~~
   include/asm-generic/percpu.h:82:3: note: in expansion of macro 'raw_cpu_ptr'
      82 |  *raw_cpu_ptr(&(pcp));      \
         |   ^~~~~~~~~~~
   include/asm-generic/percpu.h:220:30: note: in expansion of macro 'raw_cpu_generic_read'
     220 | #define raw_cpu_read_2(pcp)  raw_cpu_generic_read(pcp)
         |                              ^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:321:23: note: in expansion of macro 'raw_cpu_read_2'
     321 |  case 2: pscr_ret__ = stem##2(variable); break;   \
         |                       ^~~~
   include/linux/percpu-defs.h:407:28: note: in expansion of macro '__pcpu_size_call_return'
     407 | #define raw_cpu_read(pcp)  __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                            ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:432:2: note: in expansion of macro 'raw_cpu_read'
     432 |  raw_cpu_read(pcp);      \
         |  ^~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:12:18: note: in expansion of macro '__this_cpu_read'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                  ^~~~~~~~~~~~~~~
>> include/net/netfilter/nf_recursion.h:12:51: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                                   ^
   include/linux/compiler.h:77:42: note: in definition of macro 'unlikely'
      77 | # define unlikely(x) __builtin_expect(!!(x), 0)
         |                                          ^
   include/linux/percpu-defs.h:260:2: note: in expansion of macro 'PERCPU_PTR'
     260 |  PERCPU_PTR(ptr);      \
         |  ^~~~~~~~~~
   include/linux/percpu-defs.h:263:26: note: in expansion of macro 'per_cpu_ptr'
     263 | #define raw_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
         |                          ^~~~~~~~~~~
   include/asm-generic/percpu.h:82:3: note: in expansion of macro 'raw_cpu_ptr'
      82 |  *raw_cpu_ptr(&(pcp));      \
         |   ^~~~~~~~~~~
   include/asm-generic/percpu.h:220:30: note: in expansion of macro 'raw_cpu_generic_read'
     220 | #define raw_cpu_read_2(pcp)  raw_cpu_generic_read(pcp)
         |                              ^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:321:23: note: in expansion of macro 'raw_cpu_read_2'
     321 |  case 2: pscr_ret__ = stem##2(variable); break;   \
         |                       ^~~~
   include/linux/percpu-defs.h:407:28: note: in expansion of macro '__pcpu_size_call_return'
     407 | #define raw_cpu_read(pcp)  __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                            ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:432:2: note: in expansion of macro 'raw_cpu_read'
     432 |  raw_cpu_read(pcp);      \
         |  ^~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:12:18: note: in expansion of macro '__this_cpu_read'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                  ^~~~~~~~~~~~~~~
>> include/net/netfilter/nf_recursion.h:12:51: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                                   ^
   include/linux/compiler.h:77:42: note: in definition of macro 'unlikely'
      77 | # define unlikely(x) __builtin_expect(!!(x), 0)
         |                                          ^
   include/linux/percpu-defs.h:259:2: note: in expansion of macro '__verify_pcpu_ptr'
     259 |  __verify_pcpu_ptr(ptr);      \
         |  ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:263:26: note: in expansion of macro 'per_cpu_ptr'
     263 | #define raw_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
         |                          ^~~~~~~~~~~
   include/asm-generic/percpu.h:82:3: note: in expansion of macro 'raw_cpu_ptr'
      82 |  *raw_cpu_ptr(&(pcp));      \
         |   ^~~~~~~~~~~
   include/asm-generic/percpu.h:223:30: note: in expansion of macro 'raw_cpu_generic_read'
     223 | #define raw_cpu_read_4(pcp)  raw_cpu_generic_read(pcp)
         |                              ^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:322:23: note: in expansion of macro 'raw_cpu_read_4'
     322 |  case 4: pscr_ret__ = stem##4(variable); break;   \
         |                       ^~~~
   include/linux/percpu-defs.h:407:28: note: in expansion of macro '__pcpu_size_call_return'
     407 | #define raw_cpu_read(pcp)  __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                            ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:432:2: note: in expansion of macro 'raw_cpu_read'
     432 |  raw_cpu_read(pcp);      \
         |  ^~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:12:18: note: in expansion of macro '__this_cpu_read'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                  ^~~~~~~~~~~~~~~
>> include/net/netfilter/nf_recursion.h:12:51: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                                   ^
   include/linux/compiler.h:77:42: note: in definition of macro 'unlikely'
      77 | # define unlikely(x) __builtin_expect(!!(x), 0)
         |                                          ^
   include/linux/percpu-defs.h:221:3: note: in expansion of macro 'TYPEOF_UNQUAL'
     221 |  (TYPEOF_UNQUAL(*(__p)) __force __kernel *)((__force unsigned long)(__p))
         |   ^~~~~~~~~~~~~
   include/linux/percpu-defs.h:260:2: note: in expansion of macro 'PERCPU_PTR'
     260 |  PERCPU_PTR(ptr);      \
         |  ^~~~~~~~~~
   include/linux/percpu-defs.h:263:26: note: in expansion of macro 'per_cpu_ptr'
     263 | #define raw_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
         |                          ^~~~~~~~~~~
   include/asm-generic/percpu.h:82:3: note: in expansion of macro 'raw_cpu_ptr'
      82 |  *raw_cpu_ptr(&(pcp));      \
         |   ^~~~~~~~~~~
   include/asm-generic/percpu.h:223:30: note: in expansion of macro 'raw_cpu_generic_read'
     223 | #define raw_cpu_read_4(pcp)  raw_cpu_generic_read(pcp)
         |                              ^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:322:23: note: in expansion of macro 'raw_cpu_read_4'
     322 |  case 4: pscr_ret__ = stem##4(variable); break;   \
         |                       ^~~~
   include/linux/percpu-defs.h:407:28: note: in expansion of macro '__pcpu_size_call_return'
     407 | #define raw_cpu_read(pcp)  __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                            ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:432:2: note: in expansion of macro 'raw_cpu_read'
     432 |  raw_cpu_read(pcp);      \
         |  ^~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:12:18: note: in expansion of macro '__this_cpu_read'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                  ^~~~~~~~~~~~~~~
>> include/net/netfilter/nf_recursion.h:12:51: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                                   ^
   include/linux/compiler.h:77:42: note: in definition of macro 'unlikely'
      77 | # define unlikely(x) __builtin_expect(!!(x), 0)
         |                                          ^
   include/linux/percpu-defs.h:260:2: note: in expansion of macro 'PERCPU_PTR'
     260 |  PERCPU_PTR(ptr);      \
         |  ^~~~~~~~~~
   include/linux/percpu-defs.h:263:26: note: in expansion of macro 'per_cpu_ptr'
     263 | #define raw_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
         |                          ^~~~~~~~~~~
   include/asm-generic/percpu.h:82:3: note: in expansion of macro 'raw_cpu_ptr'
      82 |  *raw_cpu_ptr(&(pcp));      \
         |   ^~~~~~~~~~~
   include/asm-generic/percpu.h:223:30: note: in expansion of macro 'raw_cpu_generic_read'
     223 | #define raw_cpu_read_4(pcp)  raw_cpu_generic_read(pcp)
         |                              ^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:322:23: note: in expansion of macro 'raw_cpu_read_4'
     322 |  case 4: pscr_ret__ = stem##4(variable); break;   \
         |                       ^~~~
   include/linux/percpu-defs.h:407:28: note: in expansion of macro '__pcpu_size_call_return'
     407 | #define raw_cpu_read(pcp)  __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                            ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:432:2: note: in expansion of macro 'raw_cpu_read'
     432 |  raw_cpu_read(pcp);      \
         |  ^~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:12:18: note: in expansion of macro '__this_cpu_read'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                  ^~~~~~~~~~~~~~~
>> include/net/netfilter/nf_recursion.h:12:51: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                                   ^
   include/linux/compiler.h:77:42: note: in definition of macro 'unlikely'
      77 | # define unlikely(x) __builtin_expect(!!(x), 0)
         |                                          ^
   include/linux/percpu-defs.h:259:2: note: in expansion of macro '__verify_pcpu_ptr'
     259 |  __verify_pcpu_ptr(ptr);      \
         |  ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:263:26: note: in expansion of macro 'per_cpu_ptr'
     263 | #define raw_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
         |                          ^~~~~~~~~~~
   include/asm-generic/percpu.h:82:3: note: in expansion of macro 'raw_cpu_ptr'
      82 |  *raw_cpu_ptr(&(pcp));      \
         |   ^~~~~~~~~~~
   include/asm-generic/percpu.h:226:30: note: in expansion of macro 'raw_cpu_generic_read'
     226 | #define raw_cpu_read_8(pcp)  raw_cpu_generic_read(pcp)
         |                              ^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:323:23: note: in expansion of macro 'raw_cpu_read_8'
     323 |  case 8: pscr_ret__ = stem##8(variable); break;   \
         |                       ^~~~
   include/linux/percpu-defs.h:407:28: note: in expansion of macro '__pcpu_size_call_return'
     407 | #define raw_cpu_read(pcp)  __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                            ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:432:2: note: in expansion of macro 'raw_cpu_read'
     432 |  raw_cpu_read(pcp);      \
         |  ^~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:12:18: note: in expansion of macro '__this_cpu_read'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                  ^~~~~~~~~~~~~~~
>> include/net/netfilter/nf_recursion.h:12:51: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                                   ^
   include/linux/compiler.h:77:42: note: in definition of macro 'unlikely'
      77 | # define unlikely(x) __builtin_expect(!!(x), 0)
         |                                          ^
   include/linux/percpu-defs.h:221:3: note: in expansion of macro 'TYPEOF_UNQUAL'
     221 |  (TYPEOF_UNQUAL(*(__p)) __force __kernel *)((__force unsigned long)(__p))
         |   ^~~~~~~~~~~~~
   include/linux/percpu-defs.h:260:2: note: in expansion of macro 'PERCPU_PTR'
     260 |  PERCPU_PTR(ptr);      \
         |  ^~~~~~~~~~
   include/linux/percpu-defs.h:263:26: note: in expansion of macro 'per_cpu_ptr'
     263 | #define raw_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
         |                          ^~~~~~~~~~~
   include/asm-generic/percpu.h:82:3: note: in expansion of macro 'raw_cpu_ptr'
      82 |  *raw_cpu_ptr(&(pcp));      \
         |   ^~~~~~~~~~~
   include/asm-generic/percpu.h:226:30: note: in expansion of macro 'raw_cpu_generic_read'
     226 | #define raw_cpu_read_8(pcp)  raw_cpu_generic_read(pcp)
         |                              ^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:323:23: note: in expansion of macro 'raw_cpu_read_8'
     323 |  case 8: pscr_ret__ = stem##8(variable); break;   \
         |                       ^~~~
   include/linux/percpu-defs.h:407:28: note: in expansion of macro '__pcpu_size_call_return'
     407 | #define raw_cpu_read(pcp)  __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                            ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:432:2: note: in expansion of macro 'raw_cpu_read'
     432 |  raw_cpu_read(pcp);      \
         |  ^~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:12:18: note: in expansion of macro '__this_cpu_read'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                  ^~~~~~~~~~~~~~~
>> include/net/netfilter/nf_recursion.h:12:51: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                                                   ^
   include/linux/compiler.h:77:42: note: in definition of macro 'unlikely'
      77 | # define unlikely(x) __builtin_expect(!!(x), 0)
         |                                          ^
   include/linux/percpu-defs.h:260:2: note: in expansion of macro 'PERCPU_PTR'
     260 |  PERCPU_PTR(ptr);      \
         |  ^~~~~~~~~~
   include/linux/percpu-defs.h:263:26: note: in expansion of macro 'per_cpu_ptr'
     263 | #define raw_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
         |                          ^~~~~~~~~~~
   include/asm-generic/percpu.h:82:3: note: in expansion of macro 'raw_cpu_ptr'
      82 |  *raw_cpu_ptr(&(pcp));      \
         |   ^~~~~~~~~~~
   include/asm-generic/percpu.h:226:30: note: in expansion of macro 'raw_cpu_generic_read'
     226 | #define raw_cpu_read_8(pcp)  raw_cpu_generic_read(pcp)
         |                              ^~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:323:23: note: in expansion of macro 'raw_cpu_read_8'
     323 |  case 8: pscr_ret__ = stem##8(variable); break;   \
         |                       ^~~~
   include/linux/percpu-defs.h:407:28: note: in expansion of macro '__pcpu_size_call_return'
     407 | #define raw_cpu_read(pcp)  __pcpu_size_call_return(raw_cpu_read_, pcp)
         |                            ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:432:2: note: in expansion of macro 'raw_cpu_read'
     432 |  raw_cpu_read(pcp);      \
         |  ^~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:12:18: note: in expansion of macro '__this_cpu_read'
      12 |  return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
         |                  ^~~~~~~~~~~~~~~
   In file included from include/asm-generic/percpu.h:9,
                    from arch/arm/include/asm/percpu.h:68,
                    from include/linux/irqflags.h:19,
                    from arch/arm/include/asm/bitops.h:28,
                    from include/linux/bitops.h:67,
                    from include/linux/log2.h:12,
                    from include/asm-generic/div64.h:55,
                    from arch/arm/include/asm/div64.h:114,
                    from include/linux/math.h:6,
                    from include/linux/math64.h:6,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13,
                    from net/ipv4/netfilter/nf_reject_ipv4.c:6:
   include/net/netfilter/nf_recursion.h: In function 'nf_dev_xmit_recursion_inc':
   include/net/netfilter/nf_recursion.h:18:34: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      18 |  __this_cpu_inc(softnet_data.xmit.nf_dup_skb_recursion);
         |                                  ^
   include/linux/percpu-defs.h:216:47: note: in definition of macro '__verify_pcpu_ptr'
     216 |  const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL; \
         |                                               ^~~
   include/linux/percpu-defs.h:409:32: note: in expansion of macro '__pcpu_size_call'
     409 | #define raw_cpu_add(pcp, val)  __pcpu_size_call(raw_cpu_add_, pcp, val)
         |                                ^~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:444:2: note: in expansion of macro 'raw_cpu_add'
     444 |  raw_cpu_add(pcp, val);      \
         |  ^~~~~~~~~~~
   include/linux/percpu-defs.h:484:30: note: in expansion of macro '__this_cpu_add'
     484 | #define __this_cpu_inc(pcp)  __this_cpu_add(pcp, 1)
         |                              ^~~~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:18:2: note: in expansion of macro '__this_cpu_inc'
      18 |  __this_cpu_inc(softnet_data.xmit.nf_dup_skb_recursion);
         |  ^~~~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:18:34: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      18 |  __this_cpu_inc(softnet_data.xmit.nf_dup_skb_recursion);
         |                                  ^
   include/linux/percpu-defs.h:363:16: note: in definition of macro '__pcpu_size_call'
     363 |  switch(sizeof(variable)) {     \
         |                ^~~~~~~~
   include/linux/percpu-defs.h:444:2: note: in expansion of macro 'raw_cpu_add'
     444 |  raw_cpu_add(pcp, val);      \
         |  ^~~~~~~~~~~
   include/linux/percpu-defs.h:484:30: note: in expansion of macro '__this_cpu_add'
     484 | #define __this_cpu_inc(pcp)  __this_cpu_add(pcp, 1)
         |                              ^~~~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:18:2: note: in expansion of macro '__this_cpu_inc'
      18 |  __this_cpu_inc(softnet_data.xmit.nf_dup_skb_recursion);
         |  ^~~~~~~~~~~~~~
   include/net/netfilter/nf_recursion.h:18:34: error: 'struct netdev_xmit' has no member named 'nf_dup_skb_recursion'
      18 |  __this_cpu_inc(softnet_data.xmit.nf_dup_skb_recursion);
         |                                  ^
   include/linux/percpu-defs.h:216:47: note: in definition of macro '__verify_pcpu_ptr'
     216 |  const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL; \
         |                                               ^~~
   include/linux/percpu-defs.h:263:26: note: in expansion of macro 'per_cpu_ptr'
     263 | #define raw_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
         |                          ^~~~~~~~~~~
   include/asm-generic/percpu.h:87:3: note: in expansion of macro 'raw_cpu_ptr'
      87 |  *raw_cpu_ptr(&(pcp)) op val;     \
         |   ^~~~~~~~~~~
   include/asm-generic/percpu.h:243:34: note: in expansion of macro 'raw_cpu_generic_to_op'
     243 | #define raw_cpu_add_1(pcp, val)  raw_cpu_generic_to_op(pcp, val, +=)
         |                                  ^~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:364:11: note: in expansion of macro 'raw_cpu_add_1'
     364 |   case 1: stem##1(variable, __VA_ARGS__);break;  \
         |           ^~~~
   include/linux/percpu-defs.h:409:32: note: in expansion of macro '__pcpu_size_call'
     409 | #define raw_cpu_add(pcp, val)  __pcpu_size_call(raw_cpu_add_, pcp, val)
         |                                ^~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:444:2: note: in expansion of macro 'raw_cpu_add'
     444 |  raw_cpu_add(pcp, val);      \


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
