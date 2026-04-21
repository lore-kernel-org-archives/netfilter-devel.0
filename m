Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AB937FF49;
	Tue, 21 Apr 2026 11:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776772196; cv=none; b=j386PO8BIBHd74eXQ59zY/n9L62uSkyyvvUlC4bsNvrSza3KIY7bDrW/pHe2og1PkTbTYcK234D0Ge6suWoyLaU8c4nqKdEJf4GSd8Wr+wlJhvOC1xmk2jRLuUXZIXt1/G5e7j5qyHzt3yDLz96ykwd70uH91kbP/6B/iNp4Vy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776772196; c=relaxed/simple;
	bh=uuRDbH7KRxOKKZlcf1KF1ZvZpDGq5h2ULvk6YWb9YpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oX2Jy8r2d3y9XaOTMW3elwQN9C/RssGwF7pmCfKymvRN2L2z2ZRWBLMQPVG3dCo46wl0I71hpNLjJYvHuVZzyIBAbu1fl88Vf83Pz0Z83JOfO3gVmNeNSRKur5uJZZ2KbIc3HsrQ4poAekcjAwl+oErI9ey25sRA0h1fn8SzahY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E0t9BphM; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E0t9BphM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776772194; x=1808308194;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uuRDbH7KRxOKKZlcf1KF1ZvZpDGq5h2ULvk6YWb9YpA=;
  b=E0t9BphMD8FUqCw9mK3xlD9RxmbRezLoXvNKvUINq7ZlZMhffzGJMOkV
   OA/dqwZEw6dg5GPRzxjNGWu3HWcrHYZq46p/LCxVszMTdBF6cXO+H3LHh
   eQOLJUt6sVqzvnylnshd1IvbAwNXlfsZwLMzS13L8ZNC9o0Cdvt9jecA1
   /sY6tqrgViTymCAIbp8yyT9s+d6VhJqF3rhnhzax9NThfdzIxl/qifSNU
   CUaVAaoN+wTvTfba14Mn4C/JRraKQ5hFAES/Q492trHwOf/pSlMP3nQs+
   hB6+yU0d+AngJT361qiAKO1QTkmpo44dRxlblw6biqqB6TgRbirKXUa4t
   A==;
X-CSE-ConnectionGUID: HqOYzKmGQV+cC+gBgd55NA==
X-CSE-MsgGUID: k8xRjuQMQiKZov8hkqmg2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11762"; a="81570450"
X-IronPort-AV: E=Sophos;i="6.23,191,1770624000"; 
   d="scan'208";a="81570450"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2026 04:49:53 -0700
X-CSE-ConnectionGUID: ddKaYSOzS0qlHzI1zxETiw==
X-CSE-MsgGUID: i5VMa8ZhS4+kSj9vA0U/YA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,191,1770624000"; 
   d="scan'208";a="270102600"
Received: from lkp-server01.sh.intel.com (HELO 7e48d0ff8e22) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 21 Apr 2026 04:49:50 -0700
Received: from kbuild by 7e48d0ff8e22 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wF9bw-000000003Sa-1KoJ;
	Tue, 21 Apr 2026 11:49:48 +0000
Date: Tue, 21 Apr 2026 19:48:50 +0800
From: kernel test robot <lkp@intel.com>
To: Marino Dzalto <marino.dzalto@gmail.com>, pablo@netfilter.org,
	fw@strlen.de
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Marino Dzalto <marino.dzalto@gmail.com>
Subject: Re: [PATCH] netfilter: xt_HL: add pr_fmt, default case and NULL
 checks
Message-ID: <202604211905.6ZPE3dFs-lkp@intel.com>
References: <20260403193929.89449-1-marino.dzalto@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403193929.89449-1-marino.dzalto@gmail.com>

Hi Marino,

kernel test robot noticed the following build errors:

[auto build test ERROR on netfilter-nf/main]
[also build test ERROR on nf-next/master horms-ipvs/master linus/master v7.0 next-20260420]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Marino-Dzalto/netfilter-xt_HL-add-pr_fmt-default-case-and-NULL-checks/20260420-185652
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20260403193929.89449-1-marino.dzalto%40gmail.com
patch subject: [PATCH] netfilter: xt_HL: add pr_fmt, default case and NULL checks
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20260421/202604211905.6ZPE3dFs-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260421/202604211905.6ZPE3dFs-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604211905.6ZPE3dFs-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/netfilter/xt_hl.c: In function 'ttl_mt':
>> net/netfilter/xt_hl.c:34:13: error: assignment of read-only variable 'ttl'
      34 |         ttl = ip_hdr(skb)->ttl;
         |             ^


vim +/ttl +34 net/netfilter/xt_hl.c

    25	
    26	static bool ttl_mt(const struct sk_buff *skb, struct xt_action_param *par)
    27	{
    28		const struct ipt_ttl_info *info = par->matchinfo;
    29		const u8 ttl;
    30	
    31		if (!skb)
    32			return false;
    33	
  > 34		ttl = ip_hdr(skb)->ttl;
    35	
    36		switch (info->mode) {
    37		case IPT_TTL_EQ:
    38			return ttl == info->ttl;
    39		case IPT_TTL_NE:
    40			return ttl != info->ttl;
    41		case IPT_TTL_LT:
    42			return ttl < info->ttl;
    43		case IPT_TTL_GT:
    44			return ttl > info->ttl;
    45		default:
    46			pr_warn("Unknown TTL match mode: %d\n", info->mode);
    47			return false;
    48		}
    49	}
    50	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
