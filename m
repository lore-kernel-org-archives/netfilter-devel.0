Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688BE29AB05
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 20:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751573434; cv=none; b=uYskdUHoJ/KMe/LJomEUqR/i3iQH7rmOoedQAlp7A08GiWfZqQKdNv4QPNJex+CbrmHrIz+chLvHPaL28tZyHE+l3UQWocfV+DU8P9RDUxX6eS/3t0IsirnGpb/3f0vhpGjNt1+bQ9lFFfGR3XEm9JftjT2vw7X6KVYxdnDVK9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751573434; c=relaxed/simple;
	bh=xJ2z63JdUsZ/AF42IL1kECDF8LzO/ozTnpXNkQElxBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BWwHUGxGwUMCGkXZL+DdubtVvghX7YQgGN1yr4DBap9v08Mkzderlk3KsRqCRsYNu/EGbpR9l2mgDY9Sg2/6sO4aFD4WUFWTYwEvVBvZrsMcSXlFdn4DmalT9kNqBxCG2AuUfmAbystIYXjWHqOyUBbflKhjySspR0dbS9mfwdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AxYijwT8; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AxYijwT8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751573432; x=1783109432;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xJ2z63JdUsZ/AF42IL1kECDF8LzO/ozTnpXNkQElxBY=;
  b=AxYijwT8NTAtOdcMqV9PZjmOsA78c+gbYfordhPN+yC40hc/CWE4zJLT
   WBwWZEePJH29dsMPxaRJwxBQ/qDHk/qj/fP7ALFdy2f3q1TivZoJ1t34D
   9MybPNrv2VRJL/8QPIWETX55MYTZ3ExAz+/dBjpKQOo8FiF8FC0jCI6cU
   ChKELDe7ylGR7B4yHI5fR8t5xs9Yu9axV4BMXvKKKyaQUHJ63kHhYHpsm
   5bshYpR/RxL4fXBAcTtHnJfDYa43MGANS6ULc6YRdMrgun/jREGZt9xzg
   fR2EyuX/GQP6AtUtaZTaQ7wxKOHKAngvLkpCr1vtHuYurG2bc30uTXxG/
   Q==;
X-CSE-ConnectionGUID: mkK5P/MUQbOeq2q128foCA==
X-CSE-MsgGUID: AkSrd+iRQKigSmhV3NI0cQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="53039458"
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="53039458"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 13:10:32 -0700
X-CSE-ConnectionGUID: cvITvHHtSK+pP46l91vm5Q==
X-CSE-MsgGUID: gLMbTGc7TeqQFf+zoan8LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="159977768"
Received: from lkp-server01.sh.intel.com (HELO 0b2900756c14) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 03 Jul 2025 13:10:30 -0700
Received: from kbuild by 0b2900756c14 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uXQGK-0002yR-1e;
	Thu, 03 Jul 2025 20:10:28 +0000
Date: Fri, 4 Jul 2025 04:10:17 +0800
From: kernel test robot <lkp@intel.com>
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 2/5] netfilter: nft_set: remove one argument from
 lookup and update functions
Message-ID: <202507040336.yrd8Mop2-lkp@intel.com>
References: <20250701185245.31370-3-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701185245.31370-3-fw@strlen.de>

Hi Florian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on netfilter-nf/main]
[also build test WARNING on linus/master v6.16-rc4 next-20250703]
[cannot apply to nf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Westphal/netfilter-nft_set_pipapo-remove-unused-arguments/20250702-025433
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20250701185245.31370-3-fw%40strlen.de
patch subject: [PATCH nf-next 2/5] netfilter: nft_set: remove one argument from lookup and update functions
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20250704/202507040336.yrd8Mop2-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250704/202507040336.yrd8Mop2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507040336.yrd8Mop2-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: net/netfilter/nft_set_pipapo_avx2.c:1151 Excess function parameter 'ext' description in 'nft_pipapo_avx2_lookup'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
