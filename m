Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47E419D895;
	Thu,  5 Sep 2024 15:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725550875; cv=none; b=KksYEZCCWXNdmO1NX+qnDC98vQ17+WioodFmZikehcCLgkZNT0MAyqGLHBVy1rJtOW8rwF6TUlJ0XuSo36rFtNSOh8IvOtgOGmr+IanP5yoDlFUxUGLuE2upX6ScKfnubnkbZ9mZDc8ycbfUceBh+LG4+//XVuePz0ZJuKLad/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725550875; c=relaxed/simple;
	bh=0lhN4otTy7QSxzdkPVwPy7/OVynmUzkxInghg6gLakU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rQQbODrMbsImZzYxCZKynd0qRu93VIXwJjKl+/CFHS4/5D7/kXMoPqd5Wg/CLp1FMDCwD3dNZNUKrUNmlZbRS+j5MRZ8NYbXhTo8lDzDIzscmOBA436QyxIizMgZ7nCb8r5roNd4jQxvwVbrhu+F8nFmf4kmDuvYzjGOBSnfmWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LjXlGToV; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LjXlGToV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725550874; x=1757086874;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=0lhN4otTy7QSxzdkPVwPy7/OVynmUzkxInghg6gLakU=;
  b=LjXlGToVd3O/luWb55dCMTBzO2SFDbUUSL2mWNi2NHw7Iy7L2wKnPGVv
   VCKjmLSf6I+qjexchXwP1EuPkExnbBMXarTzrTEaTaoWmb/v+RwzB968D
   57xyhTEW6NtnnuZ1ZL/NLskTlyyj2sl9tylImdUqYxm5eLjAY/JWOTPDo
   2hpNRYKNWb3ZvAMjek9fZLtPd+B6U3Q64BF3ksuhfqU1wjtYkUdAKgczs
   UYMny8fYFUadBXSV8HdV4bzMf01URG6ni/aodbPnhgTEtONA/+LvfqLr0
   HFB7t2xVzV/f05PyziCT6wQoZn+o1uCp1hjJw26qPvzal4jZQhYm06YMP
   A==;
X-CSE-ConnectionGUID: QAL4cesyQUO0+Ffs7NH8DA==
X-CSE-MsgGUID: 8MSWqY8GR5ClhxzZZfPEkA==
X-IronPort-AV: E=McAfee;i="6700,10204,11186"; a="28070234"
X-IronPort-AV: E=Sophos;i="6.10,205,1719903600"; 
   d="scan'208";a="28070234"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 08:41:13 -0700
X-CSE-ConnectionGUID: PlwpGZl0Q3CsGdu7ktgQ0A==
X-CSE-MsgGUID: S8Q8InSvQwWZRQ7gpnyBbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,205,1719903600"; 
   d="scan'208";a="70242032"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 05 Sep 2024 08:41:10 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1smEbb-000A3D-2C;
	Thu, 05 Sep 2024 15:41:07 +0000
Date: Thu, 5 Sep 2024 23:41:03 +0800
From: kernel test robot <lkp@intel.com>
To: Jiawei Ye <jiawei.ye@foxmail.com>, pablo@netfilter.org,
	kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	fw@strlen.de
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: tproxy: Add RCU protection in nf_tproxy_laddr4
Message-ID: <202409052334.kT8sZWuh-lkp@intel.com>
References: <tencent_DE4D2D0FE82F3CA9294AEEB3A949A44F6008@qq.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_DE4D2D0FE82F3CA9294AEEB3A949A44F6008@qq.com>

Hi Jiawei,

kernel test robot noticed the following build warnings:

[auto build test WARNING on netfilter-nf/main]
[also build test WARNING on linus/master v6.11-rc6 next-20240905]
[cannot apply to nf-next/master horms-ipvs/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiawei-Ye/netfilter-tproxy-Add-RCU-protection-in-nf_tproxy_laddr4/20240904-202126
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/tencent_DE4D2D0FE82F3CA9294AEEB3A949A44F6008%40qq.com
patch subject: [PATCH] netfilter: tproxy: Add RCU protection in nf_tproxy_laddr4
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20240905/202409052334.kT8sZWuh-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240905/202409052334.kT8sZWuh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409052334.kT8sZWuh-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/ipv4/netfilter/nf_tproxy_ipv4.c: In function 'nf_tproxy_laddr4':
>> net/ipv4/netfilter/nf_tproxy_ipv4.c:62:9: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
      62 |         if (!indev)
         |         ^~
   net/ipv4/netfilter/nf_tproxy_ipv4.c:64:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
      64 |                 return daddr;
         |                 ^~~~~~


vim +/if +62 net/ipv4/netfilter/nf_tproxy_ipv4.c

45ca4e0cf2734f Máté Eckl        2018-06-01  49  
45ca4e0cf2734f Máté Eckl        2018-06-01  50  __be32 nf_tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr)
45ca4e0cf2734f Máté Eckl        2018-06-01  51  {
b8d19572367bb0 Florian Westphal 2019-05-31  52  	const struct in_ifaddr *ifa;
45ca4e0cf2734f Máté Eckl        2018-06-01  53  	struct in_device *indev;
45ca4e0cf2734f Máté Eckl        2018-06-01  54  	__be32 laddr;
45ca4e0cf2734f Máté Eckl        2018-06-01  55  
45ca4e0cf2734f Máté Eckl        2018-06-01  56  	if (user_laddr)
45ca4e0cf2734f Máté Eckl        2018-06-01  57  		return user_laddr;
45ca4e0cf2734f Máté Eckl        2018-06-01  58  
45ca4e0cf2734f Máté Eckl        2018-06-01  59  	laddr = 0;
2729675b33a93a Jiawei Ye        2024-09-04  60  	rcu_read_lock();
45ca4e0cf2734f Máté Eckl        2018-06-01  61  	indev = __in_dev_get_rcu(skb->dev);
21a673bddc8fd4 Florian Westphal 2024-05-13 @62  	if (!indev)
2729675b33a93a Jiawei Ye        2024-09-04  63  		rcu_read_unlock();
21a673bddc8fd4 Florian Westphal 2024-05-13  64  		return daddr;
b8d19572367bb0 Florian Westphal 2019-05-31  65  
b8d19572367bb0 Florian Westphal 2019-05-31  66  	in_dev_for_each_ifa_rcu(ifa, indev) {
b8d19572367bb0 Florian Westphal 2019-05-31  67  		if (ifa->ifa_flags & IFA_F_SECONDARY)
b8d19572367bb0 Florian Westphal 2019-05-31  68  			continue;
b8d19572367bb0 Florian Westphal 2019-05-31  69  
45ca4e0cf2734f Máté Eckl        2018-06-01  70  		laddr = ifa->ifa_local;
45ca4e0cf2734f Máté Eckl        2018-06-01  71  		break;
b8d19572367bb0 Florian Westphal 2019-05-31  72  	}
2729675b33a93a Jiawei Ye        2024-09-04  73  	rcu_read_unlock();
45ca4e0cf2734f Máté Eckl        2018-06-01  74  
45ca4e0cf2734f Máté Eckl        2018-06-01  75  	return laddr ? laddr : daddr;
45ca4e0cf2734f Máté Eckl        2018-06-01  76  }
45ca4e0cf2734f Máté Eckl        2018-06-01  77  EXPORT_SYMBOL_GPL(nf_tproxy_laddr4);
45ca4e0cf2734f Máté Eckl        2018-06-01  78  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
