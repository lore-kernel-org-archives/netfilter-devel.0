Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B851D63E4
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Aug 2025 05:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754544807; cv=none; b=MohDFnJ6Zkt0fLSCqDWIxBifLslMCKy9AYujecCXKf+nkeXsLU/yqmthX4a5OAMcGIE2GoPlxpxVvkJjzOVQozwSEiY75BXgOe0wzcNyosGSMkTpYNSFvIJNmortQJ00oN1b5Q7M4Kbyww2hb2LGbfTL+1qBTogpMXQ8IrvKOjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754544807; c=relaxed/simple;
	bh=C0YXY365WmIF8rT0yhiRIO1le32KxX0SaNycmmiGgk4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=sGySq14kqNBq9SqMXTqEltoPaG+xkddz2/JH504aS7bc42o/pnYO9Qv/xif3S9C8aVudQ3U20ehlghzFrgZkqiqi8tvBeqDDlfhGSExBH80GC9qmfo/8j3HGUMqzr4omoYEXSCujVdkJ4fre0qDGlwLDK4ePPpbqzf/Dy6FUIwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lUcXCswo; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lUcXCswo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754544805; x=1786080805;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=C0YXY365WmIF8rT0yhiRIO1le32KxX0SaNycmmiGgk4=;
  b=lUcXCswotgWDV6bRvgku51bmggB63lzHxOA/KPl9/exVofwmJVZ9oiCT
   AGV0qWrusGJdCSqIbvdsrR8VK7tn/O8CMMaODmJRyFDOnfQSmZybNAwUG
   p6zPwZ6drW5Pzb2q0Pw8ipPY+lbZocdIcQ/lYt748l+VaOI2ciH3uM2VN
   qghGLbb81hhy7zipKfuigO6iIPoSzZXBaQeOP00gW8DA2UmN6ZSuDZUe4
   XYB+2Y/QwLnDdKlehsmew7s1KpOdv59UxWoe33eDJcKjbZ6iY43lijSYw
   secEjDtMpku3lJT8AjoF8cMmw4x2sRWOLCyykYCMV8pANU7prYlKmVNJs
   A==;
X-CSE-ConnectionGUID: PpVNr2jLTs+KhAtZSEGGlA==
X-CSE-MsgGUID: z644YPI/S1mNDoHyBjWVww==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="74330258"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="74330258"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 22:33:25 -0700
X-CSE-ConnectionGUID: 7PtI9j6CRhmldOkCRwgptQ==
X-CSE-MsgGUID: WtlO+1lCTfm1TX0+lTKUEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="165330725"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 06 Aug 2025 22:33:22 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ujtFg-0002Pl-1w;
	Thu, 07 Aug 2025 05:33:20 +0000
Date: Thu, 7 Aug 2025 13:32:46 +0800
From: kernel test robot <lkp@intel.com>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [netfilter-nf:main 37/38] ERROR: modpost: __ex_table+0x2280
 references non-executable section '.data..Lubsan_type5'
Message-ID: <202508071348.PVzTqOI5-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
head:   d942fe13f72bec92f6c689fbd74c5ec38228c16a
commit: e6d76268813dc64cc0b74ea9c274501f2de05344 [37/38] net: Update threaded state in napi config in netif_set_threaded
config: riscv-randconfig-002-20250807 (https://download.01.org/0day-ci/archive/20250807/202508071348.PVzTqOI5-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250807/202508071348.PVzTqOI5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508071348.PVzTqOI5-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

ERROR: modpost: __ex_table+0x204c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2050 (section: __ex_table) -> .LASF2360 (section: .debug_str)
ERROR: modpost: __ex_table+0x2050 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2058 (section: __ex_table) -> .LASF2362 (section: .debug_str)
ERROR: modpost: __ex_table+0x2058 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x205c (section: __ex_table) -> .LASF2356 (section: .debug_str)
ERROR: modpost: __ex_table+0x205c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2064 (section: __ex_table) -> .LASF2365 (section: .debug_str)
ERROR: modpost: __ex_table+0x2064 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2068 (section: __ex_table) -> .LASF2367 (section: .debug_str)
ERROR: modpost: __ex_table+0x2068 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2070 (section: __ex_table) -> .LASF2369 (section: .debug_str)
ERROR: modpost: __ex_table+0x2070 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2074 (section: __ex_table) -> .LASF2371 (section: .debug_str)
ERROR: modpost: __ex_table+0x2074 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x207c (section: __ex_table) -> .LASF2373 (section: .debug_str)
ERROR: modpost: __ex_table+0x207c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2080 (section: __ex_table) -> .LASF2375 (section: .debug_str)
ERROR: modpost: __ex_table+0x2080 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2088 (section: __ex_table) -> .LASF4128 (section: .debug_str)
ERROR: modpost: __ex_table+0x2088 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x208c (section: __ex_table) -> .LASF4130 (section: .debug_str)
ERROR: modpost: __ex_table+0x208c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2094 (section: __ex_table) -> .LASF4132 (section: .debug_str)
ERROR: modpost: __ex_table+0x2094 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2098 (section: __ex_table) -> .LASF4134 (section: .debug_str)
ERROR: modpost: __ex_table+0x2098 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x20a0 (section: __ex_table) -> .LASF1881 (section: .debug_str)
ERROR: modpost: __ex_table+0x20a0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x20a4 (section: __ex_table) -> .LASF1883 (section: .debug_str)
ERROR: modpost: __ex_table+0x20a4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x20ac (section: __ex_table) -> .LASF1885 (section: .debug_str)
ERROR: modpost: __ex_table+0x20ac references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x20b0 (section: __ex_table) -> .LASF1887 (section: .debug_str)
ERROR: modpost: __ex_table+0x20b0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x20b8 (section: __ex_table) -> .LASF1889 (section: .debug_str)
ERROR: modpost: __ex_table+0x20b8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x20bc (section: __ex_table) -> .LASF1891 (section: .debug_str)
ERROR: modpost: __ex_table+0x20bc references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x20c4 (section: __ex_table) -> .LASF1893 (section: .debug_str)
ERROR: modpost: __ex_table+0x20c4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x20c8 (section: __ex_table) -> .LASF1895 (section: .debug_str)
ERROR: modpost: __ex_table+0x20c8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x20d0 (section: __ex_table) -> .LASF112 (section: .debug_str)
ERROR: modpost: __ex_table+0x20d0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x20d4 (section: __ex_table) -> .LASF114 (section: .debug_str)
ERROR: modpost: __ex_table+0x20d4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x20dc (section: __ex_table) -> .LASF116 (section: .debug_str)
ERROR: modpost: __ex_table+0x20dc references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x20e0 (section: __ex_table) -> .LASF118 (section: .debug_str)
ERROR: modpost: __ex_table+0x20e0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x20e8 (section: __ex_table) -> .LASF3001 (section: .debug_str)
ERROR: modpost: __ex_table+0x20e8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x20ec (section: __ex_table) -> .LASF3003 (section: .debug_str)
ERROR: modpost: __ex_table+0x20ec references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x20f4 (section: __ex_table) -> .LASF3005 (section: .debug_str)
ERROR: modpost: __ex_table+0x20f4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x20f8 (section: __ex_table) -> .LASF3007 (section: .debug_str)
ERROR: modpost: __ex_table+0x20f8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2100 (section: __ex_table) -> .LASF3009 (section: .debug_str)
ERROR: modpost: __ex_table+0x2100 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2104 (section: __ex_table) -> .LASF3007 (section: .debug_str)
ERROR: modpost: __ex_table+0x2104 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x210c (section: __ex_table) -> .LASF3012 (section: .debug_str)
ERROR: modpost: __ex_table+0x210c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2110 (section: __ex_table) -> .LASF3007 (section: .debug_str)
ERROR: modpost: __ex_table+0x2110 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2124 (section: __ex_table) -> .LASF1306 (section: .debug_str)
ERROR: modpost: __ex_table+0x2124 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2128 (section: __ex_table) -> .LASF1308 (section: .debug_str)
ERROR: modpost: __ex_table+0x2128 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2130 (section: __ex_table) -> .LASF1310 (section: .debug_str)
ERROR: modpost: __ex_table+0x2130 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2134 (section: __ex_table) -> .LASF1312 (section: .debug_str)
ERROR: modpost: __ex_table+0x2134 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x213c (section: __ex_table) -> .LASF1314 (section: .debug_str)
ERROR: modpost: __ex_table+0x213c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2140 (section: __ex_table) -> .LASF1312 (section: .debug_str)
ERROR: modpost: __ex_table+0x2140 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2190 (section: __ex_table) -> .LASF2147 (section: .debug_str)
ERROR: modpost: __ex_table+0x2190 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2194 (section: __ex_table) -> .LASF2149 (section: .debug_str)
ERROR: modpost: __ex_table+0x2194 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x219c (section: __ex_table) -> .LASF2151 (section: .debug_str)
ERROR: modpost: __ex_table+0x219c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x21a0 (section: __ex_table) -> .LASF2153 (section: .debug_str)
ERROR: modpost: __ex_table+0x21a0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x21a8 (section: __ex_table) -> .LASF2155 (section: .debug_str)
ERROR: modpost: __ex_table+0x21a8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x21ac (section: __ex_table) -> .LASF2153 (section: .debug_str)
ERROR: modpost: __ex_table+0x21ac references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x21b4 (section: __ex_table) -> .LASF2158 (section: .debug_str)
ERROR: modpost: __ex_table+0x21b4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x21b8 (section: __ex_table) -> .LASF2153 (section: .debug_str)
ERROR: modpost: __ex_table+0x21b8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x21c0 (section: __ex_table) -> .LASF4569 (section: .debug_str)
ERROR: modpost: __ex_table+0x21c0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x21c4 (section: __ex_table) -> .LASF4571 (section: .debug_str)
ERROR: modpost: __ex_table+0x21c4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2280 (section: __ex_table) -> .Lubsan_type5 (section: .data..Lubsan_type5)
>> ERROR: modpost: __ex_table+0x2280 references non-executable section '.data..Lubsan_type5'
WARNING: modpost: vmlinux: section mismatch in reference: 0x228c (section: __ex_table) -> .LC7 (section: .rodata.str1.4)
ERROR: modpost: __ex_table+0x228c references non-executable section '.rodata.str1.4'
WARNING: modpost: vmlinux: section mismatch in reference: 0x2298 (section: __ex_table) -> .LASF4651 (section: .debug_str)
ERROR: modpost: __ex_table+0x2298 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x22a4 (section: __ex_table) -> .Ldebug_ranges0 (section: .debug_ranges)
ERROR: modpost: __ex_table+0x22a4 references non-executable section '.debug_ranges'
WARNING: modpost: vmlinux: section mismatch in reference: 0x22b0 (section: __ex_table) -> .LASF1 (section: .debug_str)
ERROR: modpost: __ex_table+0x22b0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x22bc (section: __ex_table) -> .LASF5 (section: .debug_str)
ERROR: modpost: __ex_table+0x22bc references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x22c8 (section: __ex_table) -> .LASF7 (section: .debug_str)
ERROR: modpost: __ex_table+0x22c8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x22d4 (section: __ex_table) -> .LASF10 (section: .debug_str)
ERROR: modpost: __ex_table+0x22d4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x22e0 (section: __ex_table) -> .LASF13 (section: .debug_str)
ERROR: modpost: __ex_table+0x22e0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x22e4 (section: __ex_table) -> .LASF15 (section: .debug_str)
ERROR: modpost: __ex_table+0x22e4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x22ec (section: __ex_table) -> .LASF17 (section: .debug_str)
ERROR: modpost: __ex_table+0x22ec references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x22f0 (section: __ex_table) -> .LASF15 (section: .debug_str)
ERROR: modpost: __ex_table+0x22f0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x22f8 (section: __ex_table) -> .LASF20 (section: .debug_str)
ERROR: modpost: __ex_table+0x22f8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x22fc (section: __ex_table) -> .LASF15 (section: .debug_str)
ERROR: modpost: __ex_table+0x22fc references non-executable section '.debug_str'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
