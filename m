Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0539F241679;
	Thu, 14 Aug 2025 06:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755152840; cv=none; b=rdlpG3f2NiujerHEheK3fH9g2JaO6SdTPSlbngwz4/+saX02JcxN6bD+jTjb2gdwfms/EFDEkw7P1ot8rN94YbsSTzeFl8Yyqv9vkPUH79LLlbul76agiixUqdbJcVnl3WNfkLCHsvG+dy/ZAQX4XOgoBot6rBdUqq+6JxgdrEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755152840; c=relaxed/simple;
	bh=7C2qXLNIBZ6eia/1W6IjTf5fHo1xJNSXNElLkOznFdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LdGlSJ8qS6XvDMc0kCcM3SoxKSWWT6TCuoettU8jL0KjS5OdiRyt56/5WbgDg/rPZfiZz2gjEp1xDW3nFSj46k+bDGyomMRZ667rdZiMgbXqNAPgHWsUUVJ3dQf6hDs94RdcpAWQXOJ+SfXYgfJXvfI06PMw4rUt+oR+hMetQ3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nG0ijTwW; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nG0ijTwW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755152838; x=1786688838;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7C2qXLNIBZ6eia/1W6IjTf5fHo1xJNSXNElLkOznFdA=;
  b=nG0ijTwWIozueZP9L1dLEdEj6bSsUmpJeKZFXe5pnhzdx3Y5LffuETXP
   o+MNrQjodDPSurM3Yh02el26tQ2Ia6wyqh/pdJW4q0S9mvwvR5N5Ifz+v
   onTd+EJ1TdMkXt7NS57S0zk/g5eSINU7Syn8B5gf0nyajPeJWgYoz2AH0
   tEyYIQ2sCSBjDsQuQg/f2IMkuF+QBYV7JXyT7yZJuD0HUV7j9/tWZi5RF
   QjZUI4TyCjAZIbGfLHWarbXECJOaqAWp3MB7vUwhbIcVtddcjkSbWo6mn
   Y+/2TP16LfISZhZg6JpWoB2H2Bv9xXQ1x6TYDMbFAkZ2+quzpMs88lG5x
   A==;
X-CSE-ConnectionGUID: E4/ikvMLSnGU8JBc3+sdjw==
X-CSE-MsgGUID: E11o1Kc+TuerEgkGhSKd+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="57327894"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="57327894"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 23:27:11 -0700
X-CSE-ConnectionGUID: Zk7z/qHCTD2YF91fhOt6KQ==
X-CSE-MsgGUID: 17rxyqDiSZSzZwKelRmI3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="197536124"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 13 Aug 2025 23:27:08 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1umRQY-000AeS-0E;
	Thu, 14 Aug 2025 06:27:06 +0000
Date: Thu, 14 Aug 2025 14:26:26 +0800
From: kernel test robot <lkp@intel.com>
To: Christophe Leroy <christophe.leroy@csgroup.eu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nft_payload: Use csum_replace4()
 instead of opencoding
Message-ID: <202508141336.K6vIBjy1-lkp@intel.com>
References: <e98467a942d65d2dc45dcf8ff809b43d4a3769eb.1754992552.git.christophe.leroy@csgroup.eu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e98467a942d65d2dc45dcf8ff809b43d4a3769eb.1754992552.git.christophe.leroy@csgroup.eu>

Hi Christophe,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Christophe-Leroy/netfilter-nft_payload-Use-csum_replace4-instead-of-opencoding/20250812-183440
base:   net-next/main
patch link:    https://lore.kernel.org/r/e98467a942d65d2dc45dcf8ff809b43d4a3769eb.1754992552.git.christophe.leroy%40csgroup.eu
patch subject: [PATCH net-next] netfilter: nft_payload: Use csum_replace4() instead of opencoding
config: x86_64-randconfig-122-20250814 (https://download.01.org/0day-ci/archive/20250814/202508141336.K6vIBjy1-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250814/202508141336.K6vIBjy1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508141336.K6vIBjy1-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> net/netfilter/nft_payload.c:687:28: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __be32 [usertype] from @@     got restricted __wsum [usertype] fsum @@
   net/netfilter/nft_payload.c:687:28: sparse:     expected restricted __be32 [usertype] from
   net/netfilter/nft_payload.c:687:28: sparse:     got restricted __wsum [usertype] fsum
>> net/netfilter/nft_payload.c:687:34: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __be32 [usertype] to @@     got restricted __wsum [usertype] tsum @@
   net/netfilter/nft_payload.c:687:34: sparse:     expected restricted __be32 [usertype] to
   net/netfilter/nft_payload.c:687:34: sparse:     got restricted __wsum [usertype] tsum
>> net/netfilter/nft_payload.c:687:28: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __be32 [usertype] from @@     got restricted __wsum [usertype] fsum @@
   net/netfilter/nft_payload.c:687:28: sparse:     expected restricted __be32 [usertype] from
   net/netfilter/nft_payload.c:687:28: sparse:     got restricted __wsum [usertype] fsum
>> net/netfilter/nft_payload.c:687:34: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __be32 [usertype] to @@     got restricted __wsum [usertype] tsum @@
   net/netfilter/nft_payload.c:687:34: sparse:     expected restricted __be32 [usertype] to
   net/netfilter/nft_payload.c:687:34: sparse:     got restricted __wsum [usertype] tsum

vim +687 net/netfilter/nft_payload.c

   684	
   685	static inline void nft_csum_replace(__sum16 *sum, __wsum fsum, __wsum tsum)
   686	{
 > 687		csum_replace4(sum, fsum, tsum);
   688		if (*sum == 0)
   689			*sum = CSUM_MANGLED_0;
   690	}
   691	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
