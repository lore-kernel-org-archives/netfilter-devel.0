Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC6A1891A4
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2024 17:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718645919; cv=none; b=jH4q/muW2pvQd60LEPeTmtYkCUW+sQNGS4WU1CiSwGIjRk5wsiyIhDBtMLeS9t3r35xuzzZ6IP6NK4fdgw8JXBC9RiLK0LR2NpWzDnzimEpbjHHdMr3kUM1nIVzbk0x3BP+Rebit8t71fxiTjNnO3LimDmhLv0e5A4DUGXXn6Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718645919; c=relaxed/simple;
	bh=ohF55oU0RYpuXbvAuI/ketm5NP7zWNWqe6VRHyy+bFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tRNowsWIGTOG4VIwkBl230QRSbOxsUE/Q+J3cV2rEzrZUCF14MyhAyY8PMKQrAtPGVoGsDz4TNaM5nOcHoZTBYFlkNiG3YsZlcMpTaxmV1Ye8S6EBY5YMckapN2WvhRB+ySa7ay6j39HnxGJ6ViEZkmqgD7ptqXf0xbUCT1mkd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iuc42EFg; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iuc42EFg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718645917; x=1750181917;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ohF55oU0RYpuXbvAuI/ketm5NP7zWNWqe6VRHyy+bFo=;
  b=iuc42EFg3YOHTHZa7PHijRrVEJ7h6SsTv0YvYuYsACAZh3yIYAJZB/2q
   44sv5/+pNR+K0Q66e1UdrLQEIMYm+ssOXzNWPO3sfOd43RZ+0xZ4b6v9n
   82/WandrkBndAUfffwtwKLewrIbyDuW7g6eFubjV8MbCM624VIVc+G0XB
   UZh5T/KEYHR78p3vNNlrf6MXMimc2rm0tRebkyfvDfUDgoB0ZaencfyO5
   IQppqtMzxPQc19GqpQ02oSwY51ldSTOoQeR/mh8T1T/HMTQV6qstQ0XYb
   l3d5nXkKhVYuMCDQwo7SZZrFxuMmP/VG7zej9Y51bNROKoAB9Y4mYD6/U
   Q==;
X-CSE-ConnectionGUID: Jj3qwOxkQ4mJ8TSWYMJGHw==
X-CSE-MsgGUID: 7lrih/gVQk6MGKi7q0bj+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11106"; a="26116021"
X-IronPort-AV: E=Sophos;i="6.08,245,1712646000"; 
   d="scan'208";a="26116021"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 10:38:36 -0700
X-CSE-ConnectionGUID: K/D4Rkz+RGqS8+tHM0+C4Q==
X-CSE-MsgGUID: aAoqCE02Qey1QD61Rrs23Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,245,1712646000"; 
   d="scan'208";a="46386307"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 17 Jun 2024 10:38:34 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sJGJM-0004jp-1P;
	Mon, 17 Jun 2024 17:38:32 +0000
Date: Tue, 18 Jun 2024 01:38:12 +0800
From: kernel test robot <lkp@intel.com>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netfilter-devel@vger.kernel.org, Fabio <pedretti.fabio@gmail.com>
Subject: Re: [nf-next PATCH 2/2] netfilter: xt_recent: Largely lift
 restrictions on max hitcount value
Message-ID: <202406180137.ATtQZimm-lkp@intel.com>
References: <20240613143254.26622-3-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613143254.26622-3-phil@nwl.cc>

Hi Phil,

kernel test robot noticed the following build warnings:

[auto build test WARNING on nf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Phil-Sutter/netfilter-xt_reent-Reduce-size-of-struct-recent_entry-nstamps/20240613-223955
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git master
patch link:    https://lore.kernel.org/r/20240613143254.26622-3-phil%40nwl.cc
patch subject: [nf-next PATCH 2/2] netfilter: xt_recent: Largely lift restrictions on max hitcount value
config: s390-defconfig (https://download.01.org/0day-ci/archive/20240618/202406180137.ATtQZimm-lkp@intel.com/config)
compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project 78ee473784e5ef6f0b19ce4cb111fb6e4d23c6b2)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240618/202406180137.ATtQZimm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406180137.ATtQZimm-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from net/netfilter/xt_recent.c:14:
   In file included from include/linux/ip.h:16:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:9:
   In file included from include/linux/mm.h:1719:
   include/linux/vmstat.h:508:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     508 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     509 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:515:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     515 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     516 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:522:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     522 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:527:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     527 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     528 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:536:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     536 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     537 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   In file included from net/netfilter/xt_recent.c:14:
   In file included from include/linux/ip.h:16:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:464:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     464 |         val = __raw_readb(PCI_IOBASE + addr);
         |                           ~~~~~~~~~~ ^
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     477 |         val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
         |                                                           ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
     102 | #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
         |                                                      ^
   In file included from net/netfilter/xt_recent.c:14:
   In file included from include/linux/ip.h:16:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     490 |         val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
      35 | #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
         |                                                           ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
     115 | #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
         |                                                      ^
   In file included from net/netfilter/xt_recent.c:14:
   In file included from include/linux/ip.h:16:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:501:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     501 |         __raw_writeb(value, PCI_IOBASE + addr);
         |                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:511:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     511 |         __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:521:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     521 |         __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:609:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     609 |         readsb(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:617:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     617 |         readsw(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:625:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     625 |         readsl(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:634:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     634 |         writesb(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
   include/asm-generic/io.h:643:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     643 |         writesw(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
   include/asm-generic/io.h:652:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     652 |         writesl(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
>> net/netfilter/xt_recent.c:738:38: warning: result of comparison of constant 4294967296 with expression of type 'unsigned int' is always false [-Wtautological-constant-out-of-range-compare]
     738 |         if (!ip_list_tot || ip_pkt_list_tot >= XT_RECENT_MAX_NSTAMPS)
         |                             ~~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~~~~~~~~
   18 warnings generated.


vim +738 net/netfilter/xt_recent.c

^1da177e4c3f41 net/ipv4/netfilter/ipt_recent.c Linus Torvalds   2005-04-16  731  
d3c5ee6d545b53 net/ipv4/netfilter/ipt_recent.c Jan Engelhardt   2007-12-04  732  static int __init recent_mt_init(void)
^1da177e4c3f41 net/ipv4/netfilter/ipt_recent.c Linus Torvalds   2005-04-16  733  {
404bdbfd242cb9 net/ipv4/netfilter/ipt_recent.c Patrick McHardy  2006-05-29  734  	int err;
^1da177e4c3f41 net/ipv4/netfilter/ipt_recent.c Linus Torvalds   2005-04-16  735  
abc86d0f99242b net/netfilter/xt_recent.c       Florian Westphal 2014-11-24  736  	BUILD_BUG_ON_NOT_POWER_OF_2(XT_RECENT_MAX_NSTAMPS);
abc86d0f99242b net/netfilter/xt_recent.c       Florian Westphal 2014-11-24  737  
abc86d0f99242b net/netfilter/xt_recent.c       Florian Westphal 2014-11-24 @738  	if (!ip_list_tot || ip_pkt_list_tot >= XT_RECENT_MAX_NSTAMPS)
404bdbfd242cb9 net/ipv4/netfilter/ipt_recent.c Patrick McHardy  2006-05-29  739  		return -EINVAL;
404bdbfd242cb9 net/ipv4/netfilter/ipt_recent.c Patrick McHardy  2006-05-29  740  	ip_list_hash_size = 1 << fls(ip_list_tot);
^1da177e4c3f41 net/ipv4/netfilter/ipt_recent.c Linus Torvalds   2005-04-16  741  
7d07d5632b672c net/netfilter/xt_recent.c       Alexey Dobriyan  2010-01-18  742  	err = register_pernet_subsys(&recent_net_ops);
^1da177e4c3f41 net/ipv4/netfilter/ipt_recent.c Linus Torvalds   2005-04-16  743  	if (err)
404bdbfd242cb9 net/ipv4/netfilter/ipt_recent.c Patrick McHardy  2006-05-29  744  		return err;
7d07d5632b672c net/netfilter/xt_recent.c       Alexey Dobriyan  2010-01-18  745  	err = xt_register_matches(recent_mt_reg, ARRAY_SIZE(recent_mt_reg));
7d07d5632b672c net/netfilter/xt_recent.c       Alexey Dobriyan  2010-01-18  746  	if (err)
7d07d5632b672c net/netfilter/xt_recent.c       Alexey Dobriyan  2010-01-18  747  		unregister_pernet_subsys(&recent_net_ops);
^1da177e4c3f41 net/ipv4/netfilter/ipt_recent.c Linus Torvalds   2005-04-16  748  	return err;
^1da177e4c3f41 net/ipv4/netfilter/ipt_recent.c Linus Torvalds   2005-04-16  749  }
^1da177e4c3f41 net/ipv4/netfilter/ipt_recent.c Linus Torvalds   2005-04-16  750  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
