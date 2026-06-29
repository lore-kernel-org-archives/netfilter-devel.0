Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5613C4B9B;
	Mon, 29 Jun 2026 21:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782767477; cv=none; b=rRFimtr1YC/bgUWnL69RR4KfTEjn6d9+QWTc2lttHwerOKFqIC0PzsodA8RfqOI80vO4KuUEiFcatYmfPxiKy+Kpi8VbnxQlEar0d4OrDnrpq2Lf8Peax9hZp1P2l46vOfOAGF3vKs5u7duAj29APXHy0XXxz6Xe7kwkUaBldLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782767477; c=relaxed/simple;
	bh=QCv23orYfmj+39HvVUtEgBCVVNhDYOBaErD6pCq+jxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jyZOXmHL6smTzzVBnj4NauJF3G4OvZJchKmIk6Ofm8Et37DTUHo5+n9pAD0shIUNTCCTUe/Fn3RvbD9bzvnO1ws+8uK4ksGJJo4EBp/exc5Vra0GrcKUt7v/fIajfG6i0K2YeDsSaUf26KdQ/0l1jGiXOJM0muSa+FfnEi8sau0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KoZBzmuW; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KoZBzmuW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782767464; x=1814303464;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QCv23orYfmj+39HvVUtEgBCVVNhDYOBaErD6pCq+jxY=;
  b=KoZBzmuWtfqCnP04MeimsKZqZFaWzIZV9Hz+6E2kAsm0Lp/6MTmIOcyF
   BGgiN756yp2RcSFVnen9f4CHqD6lw9GZ6S754nFRjktBmbIqouLi3bZ0k
   jyxEP7F4+KG6OD3OlOzUxPV8uly4pRalcVJj0PZNFL9uS1LdczcqB8Oj6
   3bUfWhgRzK3KD/BjD1+TNfj1PEVlpJmBii2bxEvISGcZXgEj5tRbpuQFZ
   IdK/oj2gNuD4Ct4Zxni/bRefl/ZOqy7P6YOPwqEYKrdRg82EbabvW1ElG
   gqksUmwWqQgTAXSdY/PKFDISPbojpu2nPjxk7jT453baeQiJlGrIrv7JY
   w==;
X-CSE-ConnectionGUID: FY70OiNxQ0y4+05TA7dtAA==
X-CSE-MsgGUID: jv3ysrJzSgqptuM+mbbWwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="82583934"
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="82583934"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 14:10:57 -0700
X-CSE-ConnectionGUID: vgnLbmsMSmy2DPed4xFb6w==
X-CSE-MsgGUID: ZTlDUNgpRkmf/NWsTjvSwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="248699222"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 29 Jun 2026 14:10:53 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1weJFi-000000007lV-0yVb;
	Mon, 29 Jun 2026 21:10:50 +0000
Date: Tue, 30 Jun 2026 05:10:35 +0800
From: kernel test robot <lkp@intel.com>
To: xietangxin <xietangxin@h-partners.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, gaoxingwang <gaoxingwang1@huawei.com>,
	huyizhen <huyizhen2@huawei.com>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_nat_masquerade: recalculate TCP TS
 offset when port is randomized
Message-ID: <202606300522.3jMZ6dLb-lkp@intel.com>
References: <20260629093408.3927103-1-xietangxin@h-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629093408.3927103-1-xietangxin@h-partners.com>

Hi xietangxin,

kernel test robot noticed the following build errors:

[auto build test ERROR on net/main]

url:    https://github.com/intel-lab-lkp/linux/commits/xietangxin/netfilter-nf_nat_masquerade-recalculate-TCP-TS-offset-when-port-is-randomized/20260629-173037
base:   net/main
patch link:    https://lore.kernel.org/r/20260629093408.3927103-1-xietangxin%40h-partners.com
patch subject: [PATCH net] netfilter: nf_nat_masquerade: recalculate TCP TS offset when port is randomized
config: arm-randconfig-004-20260630 (https://download.01.org/0day-ci/archive/20260630/202606300522.3jMZ6dLb-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260630/202606300522.3jMZ6dLb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606300522.3jMZ6dLb-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "secure_tcpv6_seq_and_ts_off" [net/netfilter/nf_nat.ko] undefined!

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
