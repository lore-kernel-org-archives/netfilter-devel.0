Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB1B1991B0;
	Thu,  5 Sep 2024 11:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725537225; cv=none; b=RHTAYYV/tIalIoVgeRTC4eoZumhdUIjIuyXPojLyumyRDdgZbfOWeujKmUhTDHDmDkFcffUCpyCtunYUN28GboVKFkY/LtJ6vW6EsGiEjqu4xrjUd/33rM2SBqqK5nugmFB/UigAS6DLdLfTYCAFbtOoMWuVhzhHfar2cp63mSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725537225; c=relaxed/simple;
	bh=x266MoN0XRzRxav9cY5RfKQfTkJHTT/H29UUQ2jj11w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TxIKbpb3BzaPgV+ii3dZeXErnsphVjGM8vdnXPQZIcZ+PdmOAxfROZwgioyQR8Yrg/efHQOrkkpEXfW7+GtsffAR7f7964cTUCVQJrgJ7rQ3Sr8PIVQmpYQzuKY5sbdb9BFj0YRxK/nKvOpEGEK1al1i/eI6EmdQVdabZH002jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mr/nJ2di; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mr/nJ2di"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725537223; x=1757073223;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=x266MoN0XRzRxav9cY5RfKQfTkJHTT/H29UUQ2jj11w=;
  b=Mr/nJ2diyPog/G3R1yssiaa14g8fh2MoXMtDPTdoJcASr74cIbsiWhI8
   gduqLwhH88ZpPN3EIUJvqitXMWWzpHnz3E1iLAD80Nv+oTSLwzD1ecFac
   vEsJJ/lRduPgfwSzpBIzfuX8yOqGVC/sxbAT/3bTSqFlXLb5hMRylXpdu
   wNdSJaHFXRfos2JRaUr4eO14KU8copqOS4D6bpKq9nFGpZoXuwA1drvcx
   aqbLe/ttXJKSy7YZ0H3LpaVN2LX81+/l8TCRIKYDy6bgQm3EXHlL2/D6q
   xq+GHX6MU94zmZaDcbUqRpKhPnhRdqbWTjzlFNhUU1U4YNwxoUaIUiFv0
   w==;
X-CSE-ConnectionGUID: dApO7wsyTamlrcNr6jQuLw==
X-CSE-MsgGUID: Gljb8JSkTA6B2ErrMQ9ftQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="24406142"
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="24406142"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 04:53:42 -0700
X-CSE-ConnectionGUID: 7tTwUzIFSZSpbSu5e082hw==
X-CSE-MsgGUID: GxrgnUfmQRmzcypMHIZRSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="65582612"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 05 Sep 2024 04:53:39 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1smB3Q-0009n9-1E;
	Thu, 05 Sep 2024 11:53:36 +0000
Date: Thu, 5 Sep 2024 19:53:12 +0800
From: kernel test robot <lkp@intel.com>
To: Jiawei Ye <jiawei.ye@foxmail.com>, pablo@netfilter.org,
	kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	fw@strlen.de
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: tproxy: Add RCU protection in nf_tproxy_laddr4
Message-ID: <202409051900.8A3Mf8i7-lkp@intel.com>
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
[also build test WARNING on linus/master v6.11-rc6 next-20240904]
[cannot apply to nf-next/master horms-ipvs/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiawei-Ye/netfilter-tproxy-Add-RCU-protection-in-nf_tproxy_laddr4/20240904-202126
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/tencent_DE4D2D0FE82F3CA9294AEEB3A949A44F6008%40qq.com
patch subject: [PATCH] netfilter: tproxy: Add RCU protection in nf_tproxy_laddr4
config: arm-randconfig-001-20240905 (https://download.01.org/0day-ci/archive/20240905/202409051900.8A3Mf8i7-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240905/202409051900.8A3Mf8i7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409051900.8A3Mf8i7-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/ipv4/netfilter/nf_tproxy_ipv4.c:64:3: warning: misleading indentation; statement is not part of the previous 'if' [-Wmisleading-indentation]
                   return daddr;
                   ^
   net/ipv4/netfilter/nf_tproxy_ipv4.c:62:2: note: previous statement is here
           if (!indev)
           ^
   1 warning generated.


vim +/if +64 net/ipv4/netfilter/nf_tproxy_ipv4.c

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
21a673bddc8fd4 Florian Westphal 2024-05-13  62  	if (!indev)
2729675b33a93a Jiawei Ye        2024-09-04  63  		rcu_read_unlock();
21a673bddc8fd4 Florian Westphal 2024-05-13 @64  		return daddr;
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
