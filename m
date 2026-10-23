Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792746899;
	b=kke6npQpIFWD5GlUhyLAtaADeopSYl770QDsvIwSvomEtsvqbWAJ53lnPY/0i9cKS8w/
	 YXPSQXbjUPcficUOdO+YAvXJYSt52QaFDQntHNVgnZiWNTtJduIVFg4LeEZWrTGQI/nmj
	 aPTRWcLNeeYXjdHlAYCUf26klNm+MifzlumOoefjfqmKfB15rjWh9NQYG2/xbQpDcxppS
	 EDOK2dzEf8jKRz14+J7IfziX/xhTABude/24PDgocpBMPxUR0labLRP2G1t6LSquqRduj
	 XEqtG4Mum/9r0fH8c8DR965nlRTqecwD3C8MD5gXyhOOVtOtzxJljXmpJnzo6rhQNDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792746899;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=2LxzQwsMxGbz7W5YCRGfzImWlOH7daeKKaYXpVIxKig=;
	b=35dEctwfUAUe257PmhKX1ueexs/wxMjyZW3GLIlrHObXa+rWc2zRK6r1HkcbiGq4GQxk
	 qMTqifaanfF2IlA0khBjEOEx3ah25dDqSSdbwXQmdkx72tI5yZiY/w2O631HeqPZNSlaj
	 l71JMiJWGtFVqNtRir5MgthQEBwbgGaGIeM76MttZpZNZyikA6cpwLA7Yl4kYir2gtpvG
	 1xbSaCXWWp+YJr3WeLLXxb4SLugp3+bcouzGEcUr+GCZOvvgboFU2atL8JyQnpH5afyh/
	 NDiDVIDD6GEDCeqcHBQjgGhFZTq1aTwwgs7IKVifw+YH4cmNjGRJgd1EG8w6UYZVXLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fh0w2OQY;
	arc=none smtp.remote-ip=192.198.163.16
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09265606A320
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 09:14:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09265606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fh0w2OQY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792746899; x=1824282899;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F/Z+W+LAQZDRym2rr3OOprG0rMKYeGdm5AsWNhVd56w=;
  b=fh0w2OQYFeqsAhGfGT3n2JqY8tltEovUV2iXMgy14sAsRvJX4oyWqV3J
   ET2ZQk3yDYaDlYsn7wlZIDa3hB5efYkd20egFbB+2/nuz3NHX2f999fmv
   dGm8otgBARvbTYtOvDqIZaFOB1olhl3MCI7W6/zF4LYbSxn4XxwIYnsPJ
   auCgclGEb33PFkLTusaQXrE3d92Y548ZymZa29PaLXBQZ42Q3YX6Hm3Zi
   fo/Jey227TjDOJEwaDiXNUUrh7qnyWHjRdHED3BG1WD/70Ltl036ALvnh
   PlBU63TIHfuSeMXhL7MBPlOO79EfN98RFDLNwgl671uWG9Ov7HBVGABQ+
   A==;
X-CSE-ConnectionGUID: jG5y7AaGTMGJY16fB4Y5ZA==
X-CSE-MsgGUID: waQ23BrARii1HTWAeIqLFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11943"; a="1512594"
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="1512594"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 02:14:58 -0700
X-CSE-ConnectionGUID: bO0DWwUASuW/RVMcEHKMHA==
X-CSE-MsgGUID: pDBoURfpRx6KlEcKx2IrPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="3494899"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 23 Oct 2026 02:14:57 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xKBMT-00000000SSM-3sjI;
	Fri, 23 Oct 2026 09:14:53 +0000
Date: Fri, 23 Oct 2026 17:13:54 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH nf,v3 3/3] netfilter: nfnetlink_queue: restrict NFQA_EXP
 to userspace helpers
Message-ID: <202610231734.BpEmIh4g-lkp@intel.com>
References: <20261022155129.2003363-3-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022155129.2003363-3-pablo@netfilter.org>

Hi Pablo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on netfilter-nf/main]
[also build test WARNING on nf-next/main linus/master v7.3 next-20261022]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pablo-Neira-Ayuso/netfilter-ctnetlink-restrict-expectation-creation-glue-to-userspace-helpers/20261022-175128
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20261022155129.2003363-3-pablo%40netfilter.org
patch subject: [PATCH nf,v3 3/3] netfilter: nfnetlink_queue: restrict NFQA_EXP to userspace helpers
config: i386-buildonly-randconfig-1003-20261023 (https://download.01.org/0day-ci/archive/20261023/202610231734.BpEmIh4g-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261023/202610231734.BpEmIh4g-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610231734.BpEmIh4g-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/netfilter/nfnetlink_queue.c:1752:13: warning: 'nfqnl_hook_exp_support' defined but not used [-Wunused-function]
    1752 | static bool nfqnl_hook_exp_support(struct nf_hook_ops *ops)
         |             ^~~~~~~~~~~~~~~~~~~~~~


vim +/nfqnl_hook_exp_support +1752 net/netfilter/nfnetlink_queue.c

  1751	
> 1752	static bool nfqnl_hook_exp_support(struct nf_hook_ops *ops)
  1753	{
  1754		return (ops->pf == NFPROTO_IPV4 &&
  1755			(ops->hooknum == NF_INET_POST_ROUTING ||
  1756			 ops->hooknum == NF_INET_LOCAL_IN) &&
  1757			ops->priority == NF_IP_PRI_CONNTRACK_CONFIRM) ||
  1758		       (ops->pf == NFPROTO_IPV6 &&
  1759			((ops->hooknum == NF_INET_POST_ROUTING &&
  1760			 ops->priority == NF_IP6_PRI_LAST) ||
  1761			 (ops->hooknum == NF_INET_LOCAL_IN &&
  1762			  ops->priority == NF_IP6_PRI_LAST - 1))) ||
  1763		       (ops->pf == NFPROTO_BRIDGE &&
  1764			(ops->hooknum == NF_BR_POST_ROUTING ||
  1765			 ops->priority == NF_IP_PRI_CONNTRACK_CONFIRM));
  1766	}
  1767	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
