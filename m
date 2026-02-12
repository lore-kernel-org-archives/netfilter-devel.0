Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041F71448E0
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2026 22:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770936449; cv=none; b=ChTaY9iRMAJJ6mqNmbn78VLN+s5giXg5cOxw+kZpSZG7wN+QoItEcAztVqsZcdsOhcgHqQLdzXQ3pgzA1rn8MBUExa1DDs5ExJUaBXYLin2W0Mfp/MaqzKLQgiZyPcj2EGIg1pspM+e8724tsHjakohsAMtJo+ozqeJZRgEw6bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770936449; c=relaxed/simple;
	bh=vi7J78blCk3qcQ+pNhnSWBOtOElaBi+6mBJthe0qdyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iYrRsPLrSYi0SnHzvs6dxSH3dXmi5KWsIx3COxxqsgLPqTdErA8fPV5tduGWYOui2jH4FhwpdN9xhjhcy5Fi9jEmR8DIL+SbxfPRNsMEIzAbRdwCSysT5Q2ghnZR76G5bZ+qojBl0KDoC3FyuU0NdBncE70C5roWIDCJYsE90Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QQhet260; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QQhet260"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770936448; x=1802472448;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vi7J78blCk3qcQ+pNhnSWBOtOElaBi+6mBJthe0qdyU=;
  b=QQhet260cgksGIE6mwqDzN/B/3rHloZFscTU6j4UWIKkTjuBb3Yddzzh
   kBLepQnfxB31EmrbKnjh/a1eKAC47HMVVTbv3svFij/ejkEa7sg9Pp8Kt
   iqLCROAy5N1WbiloxFwu4k5kCEh+hAsrEhv01I9zNtNPOd4Uv1wMcxLBj
   V9Vc2AMjo5dN8cu7fBDgGtaGyYXUWjwJuON2efEqMQgADAOllKLvY7ZYO
   sQGpVgED2dxONoFoVeT3wnoQ6r5V4U7NHU16nGG0+DBRik3EK0ZoUWAxK
   s8Ym1r0RZ6Qu9g2SpToGDbYPKvWr8Sb7SM+j5eJc98n5KYfoshHGNlSlK
   w==;
X-CSE-ConnectionGUID: JOke+meDREuM1fI3S3N/pw==
X-CSE-MsgGUID: LuL3TPOBSqmTvpD+UG8oWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="72193907"
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="72193907"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 14:47:28 -0800
X-CSE-ConnectionGUID: agl0x8jsTBq2E7K9Tfzbqw==
X-CSE-MsgGUID: YGFrk2FqSSS509aHQ0ElFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="211954700"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 12 Feb 2026 14:47:26 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vqfT2-00000000tvc-2UpD;
	Thu, 12 Feb 2026 22:47:24 +0000
Date: Fri, 13 Feb 2026 06:46:58 +0800
From: kernel test robot <lkp@intel.com>
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 2/2] netfilter: nft_fib_ipv6: switch to
 fib6_lookup
Message-ID: <202602130602.s8coK6As-lkp@intel.com>
References: <20260212122547.10437-3-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212122547.10437-3-fw@strlen.de>

Hi Florian,

kernel test robot noticed the following build errors:

[auto build test ERROR on netfilter-nf/main]
[also build test ERROR on linus/master v6.19 next-20260212]
[cannot apply to nf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Westphal/ipv6-export-fib6_lookup-for-nft_fib_ipv6/20260212-202753
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20260212122547.10437-3-fw%40strlen.de
patch subject: [PATCH nf-next 2/2] netfilter: nft_fib_ipv6: switch to fib6_lookup
config: arm-omap2plus_defconfig (https://download.01.org/0day-ci/archive/20260213/202602130602.s8coK6As-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260213/202602130602.s8coK6As-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602130602.s8coK6As-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "fib6_lookup" [net/ipv6/netfilter/nft_fib_ipv6.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
