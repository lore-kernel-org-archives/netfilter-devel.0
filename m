Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04BB22A1C5
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2025 03:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755229767; cv=none; b=p92qoIpSO+qQpWQvuC4so0Hdk/r5Os9vETwsuvm7zD06PiMP9ogx7sur/mueYrpzfYsBTTg1Xe8do7u08ICRDLstPeFqY0o4AwRMHMXx1oVpY5cS6YNwg9lqkfncNjQlJqtS/tQeetOEM38PkzSCHVK+daW2tQUXYPU85JYKsFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755229767; c=relaxed/simple;
	bh=l4iplhoglaXFKgg0/GPISAxQBnSA5jM1Eg/0eFalrP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C+KM7byDOuL4NhsVpiEJbQ83CxVV8tjKSoEUPKg1ge/m1MP4pFhYy8jvDmiFxZ40QeArf6S7klFORBPQdzdr4S9Oum9ZxiWM4eAF9E8YOmsAXGJvmHrmuJlfmogGz8Fw6Izjhp+oarJltMaFh1Ccj+T5F8Ncp5XLSM5L6XGs+NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZBDpe+Fq; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZBDpe+Fq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755229766; x=1786765766;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=l4iplhoglaXFKgg0/GPISAxQBnSA5jM1Eg/0eFalrP0=;
  b=ZBDpe+FqNiGiYOEnX+XvQi3zoDNjQRZfvreDilqs461iLr6Nlu+mvkso
   DwoBU/6vSetgimbVwivmjJBvVzRANLCai2u1eufzmLOJa9m3B66LNotmD
   nCGUnV84uGeTTnF/i5eQ5VzTyTh8LuilQnCpqeDdYqep5zvVhcM/4hgdW
   DGaCATsx33iYO5DXy6P+avIssLhFUDw/d8/SEME5Lp5mFAvIGLqyHLrT4
   QtSFeZO6LvCjBNdERT94+pdrHoJMrMAO19foQvzcda8gy2Nitd598Wasg
   LfHWkIrHO8zckXwRANfDxtkz/rTGwrKPDTi1PLb61ukj7VEavI5JtnZoJ
   g==;
X-CSE-ConnectionGUID: GSW9LRurSb26lScU2wzsFw==
X-CSE-MsgGUID: 5yWzq7W4T9S+k7O5Oyz+0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="68642023"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="68642023"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 20:49:25 -0700
X-CSE-ConnectionGUID: EXUlgcz4QfeBkRBTKTot6g==
X-CSE-MsgGUID: NmJGOVEjQqOMaByOkMKOkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="172257323"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 14 Aug 2025 20:49:24 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1umlRD-000BWS-1w;
	Fri, 15 Aug 2025 03:49:11 +0000
Date: Fri, 15 Aug 2025 11:47:50 +0800
From: kernel test robot <lkp@intel.com>
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: ctnetlink: remove refcounting in
 dying list dumping
Message-ID: <202508151104.eDVcRAdD-lkp@intel.com>
References: <20250814162307.26029-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814162307.26029-1-fw@strlen.de>

Hi Florian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on netfilter-nf/main]
[also build test WARNING on linus/master v6.17-rc1 next-20250814]
[cannot apply to nf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Westphal/netfilter-ctnetlink-remove-refcounting-in-dying-list-dumping/20250815-003116
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20250814162307.26029-1-fw%40strlen.de
patch subject: [PATCH nf-next] netfilter: ctnetlink: remove refcounting in dying list dumping
config: hexagon-randconfig-001-20250815 (https://download.01.org/0day-ci/archive/20250815/202508151104.eDVcRAdD-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 3769ce013be2879bf0b329c14a16f5cb766f26ce)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250815/202508151104.eDVcRAdD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508151104.eDVcRAdD-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/netfilter/nf_conntrack_netlink.c:1785:16: warning: unused variable 'last_id' [-Wunused-variable]
    1785 |         unsigned long last_id = ctx->last_id;
         |                       ^~~~~~~
   1 warning generated.


vim +/last_id +1785 net/netfilter/nf_conntrack_netlink.c

  1780	
  1781	static int
  1782	ctnetlink_dump_dying(struct sk_buff *skb, struct netlink_callback *cb)
  1783	{
  1784		struct ctnetlink_list_dump_ctx *ctx = (void *)cb->ctx;
> 1785		unsigned long last_id = ctx->last_id;
  1786	#ifdef CONFIG_NF_CONNTRACK_EVENTS
  1787		const struct net *net = sock_net(skb->sk);
  1788		struct nf_conntrack_net_ecache *ecache_net;
  1789		struct nf_conntrack_tuple_hash *h;
  1790		struct hlist_nulls_node *n;
  1791	#endif
  1792	
  1793		if (ctx->done)
  1794			return 0;
  1795	
  1796		ctx->last_id = 0;
  1797	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
