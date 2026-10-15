Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C706931A07F
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 11:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792065460; cv=none; b=rTVEae+R9OC6dtktEwbWoWAjcrAJ4iLHNVx+tHIIqngH+HzdLFP2TCexZk8OcfxGrqzCLM48RnhqL2AONNApN5zRbfoBJ5cblii2WUXuC62JEso1jN8tave8ngtO4iNmZxRvzC4M4trgfhnv/+4jQYcNgywC9SMWz84CKCLnDbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792065460; c=relaxed/simple;
	bh=qVoDELV7/wz8BFwL+CpDaC2qjwrEDHz3zBmCDRZt2h8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B7eeXlScYvA9c6n2Dtk8BOIlYZ/B8iCRK4G1z7jU6hZIwx/JOLRQB/aJhZ8FUts6UdPZbEot78BMuE0zhzOmk3g7L4PLElXz9y4WG+B3WW9470lfiu11Uk8t8xy7Lr8wKrTeRKOakAxVnLRo/5qm9CIEf9KUv5s37PVba7aK+7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KjE99vAy; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KjE99vAy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792065459; x=1823601459;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qVoDELV7/wz8BFwL+CpDaC2qjwrEDHz3zBmCDRZt2h8=;
  b=KjE99vAyOHi2XY/ss7HacB/LjH+WwRpHIfjN272kTmZFBaJ4JjctZAaD
   IuZJwqnuE8xaWdY1x0c3adR1iRKF+Xl2+5ustrVjL0reymE/xWVpTJnkw
   jmCMGSsqBJYzG9zG2qGtVLgn8WXCmX8+hPwE6BhyQOpSW9sdEqzmDhuCG
   +z7YE30Z7XbQe+jZoMbLGBfgqJB27ulcQMbGxucSq3PJHt/3RygeuEav5
   85Cmjvzgm4Y1X+dG28uSOHEq5WHQ82+aC9U3cvunVYGcS6WqK2hO4rr9y
   i4Pscc6xtTvMJzp74kVq/EP7h7BED1dPeoqqUNChGh52N4IljzTieVBu7
   Q==;
X-CSE-ConnectionGUID: RZYOgXGLRBmNt/rIxDFCAg==
X-CSE-MsgGUID: JD2nflvqSsebs3pXobs1Jg==
X-IronPort-AV: E=McAfee;i="6800,10657,11935"; a="720764"
X-IronPort-AV: E=Sophos;i="6.27,159,1787036400"; 
   d="scan'208";a="720764"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 04:57:38 -0700
X-CSE-ConnectionGUID: ZFS2XrjHSjGGzkGvnuM90w==
X-CSE-MsgGUID: yJTBZwoWShSGaA4Y95wiNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,159,1787036400"; 
   d="scan'208";a="1757220"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 15 Oct 2026 04:57:36 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xHK5V-00000000GOY-3ngc;
	Thu, 15 Oct 2026 11:57:33 +0000
Date: Thu, 15 Oct 2026 19:56:44 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, julius@bairaktaris.de,
	ericwouds@gmail.com, razor@blackwall.org
Subject: Re: [PATCH nf-next] netfilter: flowtable: teardown flow reaching
 bridge port on fdb updates
Message-ID: <202610151944.1oSb04pC-lkp@intel.com>
References: <20261014210256.1573072-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014210256.1573072-1-pablo@netfilter.org>

Hi Pablo,

kernel test robot noticed the following build errors:

[auto build test ERROR on nf-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Pablo-Neira-Ayuso/netfilter-flowtable-teardown-flow-reaching-bridge-port-on-fdb-updates/20261014-230256
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git main
patch link:    https://lore.kernel.org/r/20261014210256.1573072-1-pablo%40netfilter.org
patch subject: [PATCH nf-next] netfilter: flowtable: teardown flow reaching bridge port on fdb updates
config: nios2-randconfig-1000-20261015 (https://download.01.org/0day-ci/archive/20261015/202610151944.1oSb04pC-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261015/202610151944.1oSb04pC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610151944.1oSb04pC-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from ./arch/nios2/include/generated/asm/rwonce.h:1,
                    from include/linux/compiler.h:369,
                    from include/linux/build_bug.h:5,
                    from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/module.h:12,
                    from net/bridge/br_nf_utils.c:2:
   net/bridge/br_nf_utils.c: In function 'nf_br_fdb_valid_dst':
>> include/asm-generic/rwonce.h:48:1: error: incompatible types when assigning to type 'const struct net_bridge_port *' from type 'struct net_bridge_dst'
      48 | ({                                                                      \
         | ^
   net/bridge/br_nf_utils.c:32:15: note: in expansion of macro 'READ_ONCE'
      32 |         dst = READ_ONCE(f->dst);
         |               ^~~~~~~~~


vim +48 include/asm-generic/rwonce.h

e506ea451254ab Will Deacon 2019-10-15  46  
e506ea451254ab Will Deacon 2019-10-15  47  #define READ_ONCE(x)							\
e506ea451254ab Will Deacon 2019-10-15 @48  ({									\
e506ea451254ab Will Deacon 2019-10-15  49  	compiletime_assert_rwonce_type(x);				\
3c9184109e78ea Will Deacon 2019-10-30  50  	__READ_ONCE(x);							\
e506ea451254ab Will Deacon 2019-10-15  51  })
e506ea451254ab Will Deacon 2019-10-15  52  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
