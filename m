Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526C028F5
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Nov 2024 06:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731047698; cv=none; b=JsYL3QXlHU2DKzfWQWbnNcsgkMV/Ih1y0BL0DJyXbT4FMnHMsWfgiZFyM6QnTOm2DAKi3W47CoZAstI/8k+jFeg3GDHwB/KBlleR1AU3P2PVpWqSi9WcR1yQJnEj7l4FIXkIliqmSrnKJExWcOt8IDYpQkBiBC6K0GKhlOiw4Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731047698; c=relaxed/simple;
	bh=qcJepw3kzuGhsqbdPfpdXYinNejlVwGzf3p+yU7vB70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Il2amB14rbXzBO4vd5Qj+SNjkSPPZAG4yE6m2ARLLb0s6zTLB/BMsFHyQ2CBOzkvt1VI8mS9WenfKLhrqKCDO93egBLubPmiea7PDwcMgTaUxpTKkD2RHbk97rWUuLmGSfTF7r77nERVv56NXwFig/IAzJ4LxdbN6Gu2Px6SqBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nkPCGGEp; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nkPCGGEp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731047695; x=1762583695;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qcJepw3kzuGhsqbdPfpdXYinNejlVwGzf3p+yU7vB70=;
  b=nkPCGGEpH/DsGR15qadZl+AO6oVknVFM6LSiKw8lAEUWkzRhBi5r7Zwv
   ZqiQ94oBPF1fAl5FOL7R8Zev7NjMmJy+PNqyq0eul1mp6BLi2mo+0m3hh
   kry63PNAydkTqEh23Zx8Z3ZvX/+iWhaKTyKfUrNevQX7uMTEnfq0xCaXO
   l6x5LjmxR+2nTBBIruRCWK7T8uZcorLYkOb4zxDwAMuyQ172EDsTp3Lfd
   CyP71/a0onFGTSQASY2l6mCxVoAXZoNLdGbS3i53PDWhmUSEld6sFDZGi
   eDwVQ1IyCHNNvzFPPJULMW1iCPlIZNaGkDZKco9XJKTK6P4sP/1SRM5qr
   A==;
X-CSE-ConnectionGUID: DTgxBUr/R3a8+DxacUixTA==
X-CSE-MsgGUID: n9dzzSs9R1+yOmzMmrJa4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="31022749"
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="31022749"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 22:34:54 -0800
X-CSE-ConnectionGUID: gRpwQlKFRBy1Uxpk0HPmDg==
X-CSE-MsgGUID: /GugtLWPTYumiRZOWTS7cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="85325910"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 07 Nov 2024 22:34:53 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t9Ia2-000r6R-00;
	Fri, 08 Nov 2024 06:34:50 +0000
Date: Fri, 8 Nov 2024 14:34:43 +0800
From: kernel test robot <lkp@intel.com>
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Nadia Pinaeva <n.m.pinaeva@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: add conntrack event
 timestamp
Message-ID: <202411081404.HNJI5WdG-lkp@intel.com>
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
config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20241108/202411081404.HNJI5WdG-lkp@intel.com/config)
compiler: clang version 20.0.0git (https://github.com/llvm/llvm-project 592c0fe55f6d9a811028b5f3507be91458ab2713)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241108/202411081404.HNJI5WdG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411081404.HNJI5WdG-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from net/netfilter/nf_conntrack_core.c:15:
   In file included from include/linux/netfilter.h:6:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:10:
   In file included from include/linux/mm.h:2213:
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   In file included from net/netfilter/nf_conntrack_core.c:15:
   In file included from include/linux/netfilter.h:6:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/hexagon/include/asm/io.h:328:
   include/asm-generic/io.h:548:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     548 |         val = __raw_readb(PCI_IOBASE + addr);
         |                           ~~~~~~~~~~ ^
   include/asm-generic/io.h:561:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     561 |         val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   In file included from net/netfilter/nf_conntrack_core.c:15:
   In file included from include/linux/netfilter.h:6:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/hexagon/include/asm/io.h:328:
   include/asm-generic/io.h:574:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     574 |         val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
      35 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
         |                                                   ^
   In file included from net/netfilter/nf_conntrack_core.c:15:
   In file included from include/linux/netfilter.h:6:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/hexagon/include/asm/io.h:328:
   include/asm-generic/io.h:585:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     585 |         __raw_writeb(value, PCI_IOBASE + addr);
         |                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:595:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     595 |         __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:605:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     605 |         __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   In file included from net/netfilter/nf_conntrack_core.c:41:
   In file included from include/net/netfilter/nf_conntrack_core.h:18:
   include/net/netfilter/nf_conntrack_ecache.h:24:2: error: unknown type name 'local64_t'; did you mean 'local_t'?
      24 |         local64_t timestamp;            /* event timestamp, in nanoseconds */
         |         ^~~~~~~~~
         |         local_t
   include/asm-generic/local.h:25:3: note: 'local_t' declared here
      25 | } local_t;
         |   ^
   In file included from net/netfilter/nf_conntrack_core.c:41:
   In file included from include/net/netfilter/nf_conntrack_core.h:18:
>> include/net/netfilter/nf_conntrack_ecache.h:118:6: error: call to undeclared function 'local64_read'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     118 |         if (local64_read(&e->timestamp) && READ_ONCE(e->cache) == 0)
         |             ^
>> include/net/netfilter/nf_conntrack_ecache.h:119:3: error: call to undeclared function 'local64_set'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     119 |                 local64_set(&e->timestamp, ktime_get_real_ns());
         |                 ^
   7 warnings and 3 errors generated.
--
   In file included from net/netfilter/nf_conntrack_ecache.c:14:
   In file included from include/linux/netfilter.h:6:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:10:
   In file included from include/linux/mm.h:2213:
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   In file included from net/netfilter/nf_conntrack_ecache.c:14:
   In file included from include/linux/netfilter.h:6:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/hexagon/include/asm/io.h:328:
   include/asm-generic/io.h:548:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     548 |         val = __raw_readb(PCI_IOBASE + addr);
         |                           ~~~~~~~~~~ ^
   include/asm-generic/io.h:561:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     561 |         val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   In file included from net/netfilter/nf_conntrack_ecache.c:14:
   In file included from include/linux/netfilter.h:6:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/hexagon/include/asm/io.h:328:
   include/asm-generic/io.h:574:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     574 |         val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
      35 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
         |                                                   ^
   In file included from net/netfilter/nf_conntrack_ecache.c:14:
   In file included from include/linux/netfilter.h:6:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/hexagon/include/asm/io.h:328:
   include/asm-generic/io.h:585:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     585 |         __raw_writeb(value, PCI_IOBASE + addr);
         |                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:595:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     595 |         __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:605:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     605 |         __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   In file included from net/netfilter/nf_conntrack_ecache.c:25:
   In file included from include/net/netfilter/nf_conntrack_core.h:18:
   include/net/netfilter/nf_conntrack_ecache.h:24:2: error: unknown type name 'local64_t'; did you mean 'local_t'?
      24 |         local64_t timestamp;            /* event timestamp, in nanoseconds */
         |         ^~~~~~~~~
         |         local_t
   include/asm-generic/local.h:25:3: note: 'local_t' declared here
      25 | } local_t;
         |   ^
   In file included from net/netfilter/nf_conntrack_ecache.c:25:
   In file included from include/net/netfilter/nf_conntrack_core.h:18:
>> include/net/netfilter/nf_conntrack_ecache.h:118:6: error: call to undeclared function 'local64_read'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     118 |         if (local64_read(&e->timestamp) && READ_ONCE(e->cache) == 0)
         |             ^
>> include/net/netfilter/nf_conntrack_ecache.h:119:3: error: call to undeclared function 'local64_set'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     119 |                 local64_set(&e->timestamp, ktime_get_real_ns());
         |                 ^
>> net/netfilter/nf_conntrack_ecache.c:168:6: error: call to undeclared function 'local64_read'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     168 |         if (local64_read(&e->timestamp))
         |             ^
>> net/netfilter/nf_conntrack_ecache.c:169:3: error: call to undeclared function 'local64_set'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     169 |                 local64_set(&e->timestamp, ktime_get_real_ns());
         |                 ^
   net/netfilter/nf_conntrack_ecache.c:318:2: error: call to undeclared function 'local64_set'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     318 |         local64_set(&e->timestamp, ts);
         |         ^
   7 warnings and 6 errors generated.
--
   In file included from net/netfilter/nf_conntrack_netlink.c:25:
   In file included from include/linux/security.h:33:
   In file included from include/linux/mm.h:2213:
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   In file included from net/netfilter/nf_conntrack_netlink.c:25:
   In file included from include/linux/security.h:35:
   In file included from include/linux/bpf.h:31:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:26:
   In file included from include/linux/kernel_stat.h:8:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/hexagon/include/asm/io.h:328:
   include/asm-generic/io.h:548:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     548 |         val = __raw_readb(PCI_IOBASE + addr);
         |                           ~~~~~~~~~~ ^
   include/asm-generic/io.h:561:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     561 |         val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   In file included from net/netfilter/nf_conntrack_netlink.c:25:
   In file included from include/linux/security.h:35:
   In file included from include/linux/bpf.h:31:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:26:
   In file included from include/linux/kernel_stat.h:8:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/hexagon/include/asm/io.h:328:
   include/asm-generic/io.h:574:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     574 |         val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
      35 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
         |                                                   ^
   In file included from net/netfilter/nf_conntrack_netlink.c:25:
   In file included from include/linux/security.h:35:
   In file included from include/linux/bpf.h:31:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:26:
   In file included from include/linux/kernel_stat.h:8:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/hexagon/include/asm/io.h:328:
   include/asm-generic/io.h:585:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     585 |         __raw_writeb(value, PCI_IOBASE + addr);
         |                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:595:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     595 |         __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:605:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     605 |         __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   In file included from net/netfilter/nf_conntrack_netlink.c:38:
   In file included from include/net/netfilter/nf_conntrack_core.h:18:
   include/net/netfilter/nf_conntrack_ecache.h:24:2: error: unknown type name 'local64_t'; did you mean 'local_t'?
      24 |         local64_t timestamp;            /* event timestamp, in nanoseconds */
         |         ^~~~~~~~~
         |         local_t
   include/asm-generic/local.h:25:3: note: 'local_t' declared here
      25 | } local_t;
         |   ^
   In file included from net/netfilter/nf_conntrack_netlink.c:38:
   In file included from include/net/netfilter/nf_conntrack_core.h:18:
>> include/net/netfilter/nf_conntrack_ecache.h:118:6: error: call to undeclared function 'local64_read'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     118 |         if (local64_read(&e->timestamp) && READ_ONCE(e->cache) == 0)
         |             ^
>> include/net/netfilter/nf_conntrack_ecache.h:119:3: error: call to undeclared function 'local64_set'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     119 |                 local64_set(&e->timestamp, ktime_get_real_ns());
         |                 ^
>> net/netfilter/nf_conntrack_netlink.c:392:12: error: call to undeclared function 'local64_read'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     392 |                 u64 ts = local64_read(&e->timestamp);
         |                          ^
   7 warnings and 4 errors generated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for GET_FREE_REGION
   Depends on [n]: SPARSEMEM [=n]
   Selected by [m]:
   - RESOURCE_KUNIT_TEST [=m] && RUNTIME_TESTING_MENU [=y] && KUNIT [=m]


vim +/local64_read +118 include/net/netfilter/nf_conntrack_ecache.h

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
