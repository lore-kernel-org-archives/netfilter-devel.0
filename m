Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235C415688C
	for <netfilter-devel@vger.kernel.org>; Sun,  6 Oct 2024 07:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728200754; cv=none; b=d/1HntcVmHsH/hfQF1EYtnfSb1kfoiZNwFuWbRg+pfjrto4QfsNMOqlsLQXAZdGUwDPVCfPyBv4jnN8iAD8XIHqS898/lfM9DytnZoAacYK706HRX7/wXCSQWgV+6VCKnzcB74Md1zuvwyBjyeXJK/ddmk+BWjXUVZvH13KuFe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728200754; c=relaxed/simple;
	bh=6Lic0jWLHB7UOx+VHK3LyDFGYyG5mbHmPUgOoyIeObg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gHiOeI9r+hMhc7BlUG34t0WvyOrIm3tOXsWY5pq34r+Zp6ot/4MdjuCZ/9LxYjXHqzuxVmSn9q9ESiEIojECWNwDHVlJpTX/WUXMWvKIvu4+0jj/HYAQg4FwrLzUCMPW7D50yeZoJzXaWwtBaEfhR0ybK+Tyi9TGwI0adAEKdic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AI18gi4u; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AI18gi4u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728200753; x=1759736753;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6Lic0jWLHB7UOx+VHK3LyDFGYyG5mbHmPUgOoyIeObg=;
  b=AI18gi4ubaMmTCxsqk+aypPTu0KDzOJeTUbnuh9RAQlsNJLDSIdv6EDb
   p/59eneBeGvufqatzCW/rrYqpB0dDEAPeJMFyaBFGaMwGX2hQQnGFCwJe
   y0ooK987dlB5ymHE6jFszsENmPZtI0qm40FHBURAESI5lkXWSZ/10NJ4z
   yzf0UC+N+9I0WEIRPGa495VIVA4mU6wlfVUvdVjmLr+eGQFbBwlItinkr
   rfvPsHACM8FeVFGp7KHqyuZkYrD/NiUG8p6R03wSh3BCqzm7Xb4ImtmFX
   jrgHEqCJ4y+DvU9nt4+BKpVJDZErtmg+v7ThRSetg9oafe8ruHSvL8g0a
   g==;
X-CSE-ConnectionGUID: TfljWvwVSqKpYJ9UxLaEig==
X-CSE-MsgGUID: w0KK4hEdRPKYwqaJe7WMNA==
X-IronPort-AV: E=McAfee;i="6700,10204,11216"; a="31164190"
X-IronPort-AV: E=Sophos;i="6.11,182,1725346800"; 
   d="scan'208";a="31164190"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2024 00:45:52 -0700
X-CSE-ConnectionGUID: AwbqTxnBQEyWAGgemMHYXA==
X-CSE-MsgGUID: 6yg73ueKQA+qtFvebIpFiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,182,1725346800"; 
   d="scan'208";a="75385942"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 06 Oct 2024 00:45:50 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sxLxb-0003hs-1V;
	Sun, 06 Oct 2024 07:45:47 +0000
Date: Sun, 6 Oct 2024 15:45:28 +0800
From: kernel test robot <lkp@intel.com>
To: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, syzkaller-bugs@googlegroups.com,
	Florian Westphal <fw@strlen.de>,
	syzbot+256c348558aa5cf611a9@syzkaller.appspotmail.com,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v2] netfilter: xtables: avoid NFPROTO_UNSPEC where
 needed
Message-ID: <202410061557.72ec7vqP-lkp@intel.com>
References: <20241004230134.75274-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004230134.75274-1-fw@strlen.de>

Hi Florian,

kernel test robot noticed the following build errors:

[auto build test ERROR on netfilter-nf/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Westphal/netfilter-xtables-avoid-NFPROTO_UNSPEC-where-needed/20241005-070222
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20241004230134.75274-1-fw%40strlen.de
patch subject: [PATCH nf v2] netfilter: xtables: avoid NFPROTO_UNSPEC where needed
config: sh-randconfig-r071-20241006 (https://download.01.org/0day-ci/archive/20241006/202410061557.72ec7vqP-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241006/202410061557.72ec7vqP-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410061557.72ec7vqP-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/netfilter/xt_connlimit.c:145:1: error: expected ',' or ';' before '}' token
     145 | };
         | ^


vim +145 net/netfilter/xt_connlimit.c

370786f9cfd430 Jan Engelhardt   2007-07-14  119  
c43803e262643c Florian Westphal 2024-10-05  120  static struct xt_match connlimit_mt_reg[] __read_mostly = {
c43803e262643c Florian Westphal 2024-10-05  121  	{
cc4fc022571376 Jan Engelhardt   2011-01-18  122  		.name       = "connlimit",
cc4fc022571376 Jan Engelhardt   2011-01-18  123  		.revision   = 1,
c43803e262643c Florian Westphal 2024-10-05  124  		.family     = NFPROTO_IPV4,
cc4fc022571376 Jan Engelhardt   2011-01-18  125  		.checkentry = connlimit_mt_check,
cc4fc022571376 Jan Engelhardt   2011-01-18  126  		.match      = connlimit_mt,
cc4fc022571376 Jan Engelhardt   2011-01-18  127  		.matchsize  = sizeof(struct xt_connlimit_info),
ec23189049651b Willem de Bruijn 2017-01-02  128  		.usersize   = offsetof(struct xt_connlimit_info, data),
cc4fc022571376 Jan Engelhardt   2011-01-18  129  		.destroy    = connlimit_mt_destroy,
cc4fc022571376 Jan Engelhardt   2011-01-18  130  		.me         = THIS_MODULE,
c43803e262643c Florian Westphal 2024-10-05  131  	},
c43803e262643c Florian Westphal 2024-10-05  132  #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
c43803e262643c Florian Westphal 2024-10-05  133  	{
c43803e262643c Florian Westphal 2024-10-05  134  		.name       = "connlimit",
c43803e262643c Florian Westphal 2024-10-05  135  		.revision   = 1,
c43803e262643c Florian Westphal 2024-10-05  136  		.family     = NFPROTO_IPV6,
c43803e262643c Florian Westphal 2024-10-05  137  		.checkentry = connlimit_mt_check,
c43803e262643c Florian Westphal 2024-10-05  138  		.match      = connlimit_mt,
c43803e262643c Florian Westphal 2024-10-05  139  		.matchsize  = sizeof(struct xt_connlimit_info),
c43803e262643c Florian Westphal 2024-10-05  140  		.usersize   = offsetof(struct xt_connlimit_info, data),
c43803e262643c Florian Westphal 2024-10-05  141  		.destroy    = connlimit_mt_destroy,
c43803e262643c Florian Westphal 2024-10-05  142  		.me         = THIS_MODULE,
c43803e262643c Florian Westphal 2024-10-05  143  #endif
c43803e262643c Florian Westphal 2024-10-05  144  	}
370786f9cfd430 Jan Engelhardt   2007-07-14 @145  };
370786f9cfd430 Jan Engelhardt   2007-07-14  146  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
