Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DEE147C7F
	for <netfilter-devel@vger.kernel.org>; Fri,  3 May 2024 08:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714723464; cv=none; b=Y5cyaYWd+IaZC0uRTl07aOH2Tkz9/kMNeYcOa9nOiZqk3VyjXwyYU7jX1RjB4JA3Ebqos966m8hPwila0Fgcdm1nU3JGe+uIAG5QojHFmPw3KMm98a1T/jHSKNFSDZUit5cupHaaxmiRWqF6uYAn9rJPD5I19MIDUNenRBNie94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714723464; c=relaxed/simple;
	bh=sCW6Qb41kUyADcOUdkMFeGg661mOnzRAW5EENturCgg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=S4JLkDLnkxQ9Uu0r8yrNe3krejzBe7T163WB/MA9Yf/z+X37/MWHW01GYNXKJvGK7fln1lV3AoPAM7q3XwkXR0pZ13PPhiyciPX/pkPPnf4w8VZiAnDYNMhhS22fjMeeT4kKBlL3M7e4gL1Y6DWKwH6TGdwYVRj9toJ7Tjhznw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DtsJGAAp; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DtsJGAAp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714723462; x=1746259462;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=sCW6Qb41kUyADcOUdkMFeGg661mOnzRAW5EENturCgg=;
  b=DtsJGAApDMV/fpodrkw2GruvdTOcwliuvmLm+luStN9Je547FRUmo1cj
   7dyh1xTI+S6CHJN5sR5sWun7xhwKhMl6vdCEPSgpAhscp/r6DFwFHh1cl
   oV+JcecRMwNRdGJ7f+Cm1DhFDxcMTd/97MYmkCukx5MY96wVX1EGJbuA9
   Xa8T6/+fjIsz95dV9hO7gXAsCp+J+B/lq2sTluW3XgZCM4VE2LVNbSQXl
   f3UScpKfeRZNOqJLvLC12bBwtlAesyrnbcbz6lL49+E/TVfTWZFTOcH3B
   lCaf3o5woEh86dW7Pcx9GZK6MOp0y+9+h52egoLsxTxZmUULSqpekYpdm
   A==;
X-CSE-ConnectionGUID: LNizZ7dIR2OYx+Lp9qjEHw==
X-CSE-MsgGUID: r1+FlNBPTNe3YFgXEulRhg==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="10652110"
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="10652110"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2024 01:04:21 -0700
X-CSE-ConnectionGUID: uFXVRxnqSSaL7QqXfMHoQQ==
X-CSE-MsgGUID: xTRz1+BlRo2PbVwWMQhVXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="32197160"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 03 May 2024 01:04:20 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s2ntx-000BS4-1T;
	Fri, 03 May 2024 08:04:17 +0000
Date: Fri, 3 May 2024 16:03:53 +0800
From: kernel test robot <lkp@intel.com>
To: Florian Westphal <fw@strlen.de>
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Stefano Brivio <sbrivio@redhat.com>
Subject: [netfilter-nf:under-review 14/18]
 net/netfilter/nft_set_pipapo.c:2122: warning: expecting prototype for
 __nft_pipapo_walk(). Prototype was for nft_pipapo_do_walk() instead
Message-ID: <202405031522.nDHvTzEz-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git under-review
head:   7ab960ad3bd958ddbeabe9ab2287ac5d0a673f23
commit: cd491237776df450e99904b9408bfad35366a73f [14/18] netfilter: nft_set_pipapo: prepare walk function for on-demand clone
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20240503/202405031522.nDHvTzEz-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240503/202405031522.nDHvTzEz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405031522.nDHvTzEz-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/netfilter/nft_set_pipapo.c:2122: warning: expecting prototype for __nft_pipapo_walk(). Prototype was for nft_pipapo_do_walk() instead


vim +2122 net/netfilter/nft_set_pipapo.c

3c4287f62044a90 Stefano Brivio    2020-01-22  2107  
3c4287f62044a90 Stefano Brivio    2020-01-22  2108  /**
cd491237776df45 Florian Westphal  2024-04-25  2109   * __nft_pipapo_walk() - Walk over elements in m
3c4287f62044a90 Stefano Brivio    2020-01-22  2110   * @ctx:	nftables API context
3c4287f62044a90 Stefano Brivio    2020-01-22  2111   * @set:	nftables API set representation
cd491237776df45 Florian Westphal  2024-04-25  2112   * @m:		matching data pointing to key mapping array
3c4287f62044a90 Stefano Brivio    2020-01-22  2113   * @iter:	Iterator
3c4287f62044a90 Stefano Brivio    2020-01-22  2114   *
3c4287f62044a90 Stefano Brivio    2020-01-22  2115   * As elements are referenced in the mapping array for the last field, directly
3c4287f62044a90 Stefano Brivio    2020-01-22  2116   * scan that array: there's no need to follow rule mappings from the first
cd491237776df45 Florian Westphal  2024-04-25  2117   * field. @m is protected either by RCU read lock or by transaction mutex.
3c4287f62044a90 Stefano Brivio    2020-01-22  2118   */
cd491237776df45 Florian Westphal  2024-04-25  2119  static void nft_pipapo_do_walk(const struct nft_ctx *ctx, struct nft_set *set,
cd491237776df45 Florian Westphal  2024-04-25  2120  			       const struct nft_pipapo_match *m,
3c4287f62044a90 Stefano Brivio    2020-01-22  2121  			       struct nft_set_iter *iter)
3c4287f62044a90 Stefano Brivio    2020-01-22 @2122  {
f04df573faf90bb Florian Westphal  2024-02-13  2123  	const struct nft_pipapo_field *f;
aac14d516c2b575 Florian Westphal  2024-02-13  2124  	unsigned int i, r;
3c4287f62044a90 Stefano Brivio    2020-01-22  2125  
3c4287f62044a90 Stefano Brivio    2020-01-22  2126  	for (i = 0, f = m->f; i < m->field_count - 1; i++, f++)
3c4287f62044a90 Stefano Brivio    2020-01-22  2127  		;
3c4287f62044a90 Stefano Brivio    2020-01-22  2128  
3c4287f62044a90 Stefano Brivio    2020-01-22  2129  	for (r = 0; r < f->rules; r++) {
3c4287f62044a90 Stefano Brivio    2020-01-22  2130  		struct nft_pipapo_elem *e;
3c4287f62044a90 Stefano Brivio    2020-01-22  2131  
3c4287f62044a90 Stefano Brivio    2020-01-22  2132  		if (r < f->rules - 1 && f->mt[r + 1].e == f->mt[r].e)
3c4287f62044a90 Stefano Brivio    2020-01-22  2133  			continue;
3c4287f62044a90 Stefano Brivio    2020-01-22  2134  
3c4287f62044a90 Stefano Brivio    2020-01-22  2135  		if (iter->count < iter->skip)
3c4287f62044a90 Stefano Brivio    2020-01-22  2136  			goto cont;
3c4287f62044a90 Stefano Brivio    2020-01-22  2137  
3c4287f62044a90 Stefano Brivio    2020-01-22  2138  		e = f->mt[r].e;
3c4287f62044a90 Stefano Brivio    2020-01-22  2139  
0e1ea651c9717dd Pablo Neira Ayuso 2023-10-16  2140  		iter->err = iter->fn(ctx, set, iter, &e->priv);
3c4287f62044a90 Stefano Brivio    2020-01-22  2141  		if (iter->err < 0)
cd491237776df45 Florian Westphal  2024-04-25  2142  			return;
3c4287f62044a90 Stefano Brivio    2020-01-22  2143  
3c4287f62044a90 Stefano Brivio    2020-01-22  2144  cont:
3c4287f62044a90 Stefano Brivio    2020-01-22  2145  		iter->count++;
3c4287f62044a90 Stefano Brivio    2020-01-22  2146  	}
cd491237776df45 Florian Westphal  2024-04-25  2147  }
3c4287f62044a90 Stefano Brivio    2020-01-22  2148  

:::::: The code at line 2122 was first introduced by commit
:::::: 3c4287f62044a90e73a561aa05fc46e62da173da nf_tables: Add set type for arbitrary concatenation of ranges

:::::: TO: Stefano Brivio <sbrivio@redhat.com>
:::::: CC: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
