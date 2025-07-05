Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FB6211A11;
	Sat,  5 Jul 2025 17:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751736867; cv=none; b=jWZ16/QACqACY6iDINIP7YWO2Sig/7rzFVxBPRszPEtR2wpPAtiiAM9RJzjtxc0td5Qw70yEY1GLOu1uGoOMOwfujjrj+WkhrClyOxcEbdss075FqK/z7UfJ784e1ddIrUYfMHQ6rWXYnWUJbO5C+9+eTSZMAu+2+NTru/tWncg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751736867; c=relaxed/simple;
	bh=jwjO89dAruZlxXW25Yo8Gimm/KsplfgPKs8KiTMRLJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F6d/WcHweaH1ntRcLbqr7kEEp0smKMzXPwEeB8wzJUTrWkliNFnD4EPDnVzXlMwFiHqvbHNEcM7BT/1sj0m1gc0fi2reh2/ZbEY9UmE2ULAowjdwM+63s1TVwVfdaAVyzuqZLIPIo3LtqdN1OudXr18g4rxle1U+uaP6HWcMARg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M2whp148; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M2whp148"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751736865; x=1783272865;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jwjO89dAruZlxXW25Yo8Gimm/KsplfgPKs8KiTMRLJE=;
  b=M2whp148BT5+IzXAvu8sRCsJtENR53e+ztomc6V8mGhAxrAGkMQJWhXC
   UjeYT2h43kfVTgbrNhz5lnmSQezhLM1PffT1TBqszY4UkfjixDDpjZKco
   yI9N1KZ5Pa36r/vGGy2SMEEC2Tq1odYQ3Vx8E+tVaDAAFPSVXZBrcOH7X
   rIYyMQAQX06R95aB9+CPUawr2+vSxzCNvBtuw0hlpyofejjwxs+A7Pot2
   FgjWAY8nWXOBTD1fNCB85vhbLslN+Cia/zlPJsm0rmyRTFEllkqCUHWUR
   IgumbMHyzseey8n5htqmonZQIhZ9qs9kfitiBjHE45YVYjZb6L/uKfgBu
   w==;
X-CSE-ConnectionGUID: Q5JnjcN3QAGLQZAG0Qanzw==
X-CSE-MsgGUID: OvzkN3D+SZ++SDkYJzxmqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11485"; a="57790097"
X-IronPort-AV: E=Sophos;i="6.16,290,1744095600"; 
   d="scan'208";a="57790097"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2025 10:34:25 -0700
X-CSE-ConnectionGUID: UjlxWgo5RW6vclon7VAVJQ==
X-CSE-MsgGUID: whd9aa+uQ8m2unXGIE7e1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,290,1744095600"; 
   d="scan'208";a="159203564"
Received: from lkp-server01.sh.intel.com (HELO 0b2900756c14) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 05 Jul 2025 10:34:22 -0700
Received: from kbuild by 0b2900756c14 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uY6mJ-0004dz-2F;
	Sat, 05 Jul 2025 17:34:19 +0000
Date: Sun, 6 Jul 2025 01:33:21 +0800
From: kernel test robot <lkp@intel.com>
To: Eric Woudstra <ericwouds@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: Re: [PATCH v13 nf-next 1/3] netfilter: utils: nf_checksum(_partial)
 correct data!=networkheader
Message-ID: <202507060106.A5xgr1Rs-lkp@intel.com>
References: <20250704191135.1815969-2-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704191135.1815969-2-ericwouds@gmail.com>

Hi Eric,

kernel test robot noticed the following build warnings:

[auto build test WARNING on netfilter-nf/main]
[also build test WARNING on horms-ipvs/master linus/master v6.16-rc4 next-20250704]
[cannot apply to nf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Woudstra/netfilter-utils-nf_checksum-_partial-correct-data-networkheader/20250705-031418
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20250704191135.1815969-2-ericwouds%40gmail.com
patch subject: [PATCH v13 nf-next 1/3] netfilter: utils: nf_checksum(_partial) correct data!=networkheader
config: x86_64-randconfig-121-20250705 (https://download.01.org/0day-ci/archive/20250706/202507060106.A5xgr1Rs-lkp@intel.com/config)
compiler: clang version 20.1.7 (https://github.com/llvm/llvm-project 6146a88f60492b520a36f8f8f3231e15f3cc6082)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250706/202507060106.A5xgr1Rs-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507060106.A5xgr1Rs-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> net/netfilter/utils.c:131:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted __sum16 @@     got int @@
   net/netfilter/utils.c:131:24: sparse:     expected restricted __sum16
   net/netfilter/utils.c:131:24: sparse:     got int
   net/netfilter/utils.c:155:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted __sum16 @@     got int @@
   net/netfilter/utils.c:155:24: sparse:     expected restricted __sum16
   net/netfilter/utils.c:155:24: sparse:     got int

vim +131 net/netfilter/utils.c

   122	
   123	__sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
   124			    unsigned int dataoff, u8 protocol,
   125			    unsigned short family)
   126	{
   127		unsigned int nhpull = skb_network_header(skb) - skb->data;
   128		__sum16 csum = 0;
   129	
   130		if (!pskb_may_pull(skb, nhpull))
 > 131			return -ENOMEM;
   132		__skb_pull(skb, nhpull);
   133		switch (family) {
   134		case AF_INET:
   135			csum = nf_ip_checksum(skb, hook, dataoff - nhpull, protocol);
   136			break;
   137		case AF_INET6:
   138			csum = nf_ip6_checksum(skb, hook, dataoff - nhpull, protocol);
   139			break;
   140		}
   141		__skb_push(skb, nhpull);
   142	
   143		return csum;
   144	}
   145	EXPORT_SYMBOL_GPL(nf_checksum);
   146	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
