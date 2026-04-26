Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBAA212566
	for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2026 03:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777175887; cv=none; b=l97t1PYARFopHgCMjFYhlegKX5qwyFC1+9XC9Xz9kUB1gNDQskE6xDgAH18rRNK3Ls7vaCusxZfmrdPCjZvlGgi5d11KwrHRnKjYD+6ev8PzR9cGOn85mLNMW+CSzWFm2XIaVt5OpwPe/PCwVG8U7rdcc1HuyqNJR27keIyY7Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777175887; c=relaxed/simple;
	bh=VGxtZ9ar+uvsR+vlryGBq0+VyCDxifzNLJAXv+pO7Gg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VdRKEsTV7efAjF6tV31+rdNxECmy6AVipTpEvEx/Sz0twfB/s1d5JD/kaQPMaqws7DdGxR0kzruHEubl4RxRlaqMOHHLCFeOSFaL27LkpwHHs+sktDrB+MxSaz/AHkrIg/14xPSiGtK3m+GiCYYmYI/Uvrh1Y86MDggzpOGh9zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=au4siWtN; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="au4siWtN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777175885; x=1808711885;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VGxtZ9ar+uvsR+vlryGBq0+VyCDxifzNLJAXv+pO7Gg=;
  b=au4siWtNejxkgtQNFxhPRW7AixjUghkZQJN47NLMmOjRRrSFNu6AtAD+
   URDB8z7QBYWLh2Qn2dTCVXXk3w0lvHVPcmU8pyhPYeqdT5UAN86ZWLsZ/
   6Q6QLXfPd8FhWlhvkod42hZ85/uYu0PDU8x/SkHZ0drek6bbdCP1+yUVp
   9D2Z0jUwftH8Hd4ga6Eiwe9gmuCreFBQiZzkL9zbZinqufAImL7/3tX/J
   C/ZEcnfQtYf953WT6dx4/v7I8WFOHjmYtj6aJWBD45ficNOn8+k3B5gwf
   wZQwFakH+fGGJJDwb0cJ9pIia706TLSvEMmu7UAT9C7CelJDSY2aa5g7F
   w==;
X-CSE-ConnectionGUID: +t2ynXiKSkiLYnTI70naZA==
X-CSE-MsgGUID: S5lGK4xETuCM/OzlFRMpLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11767"; a="89483424"
X-IronPort-AV: E=Sophos;i="6.23,199,1770624000"; 
   d="scan'208";a="89483424"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2026 20:58:04 -0700
X-CSE-ConnectionGUID: BSj3F6ajQwGXoRvK2LPqqA==
X-CSE-MsgGUID: nMht+eWrR/WafHeEGhbyxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,199,1770624000"; 
   d="scan'208";a="230680103"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 25 Apr 2026 20:58:02 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wGqd6-000000007SD-0Pdr;
	Sun, 26 Apr 2026 03:58:00 +0000
Date: Sun, 26 Apr 2026 11:57:59 +0800
From: kernel test robot <lkp@intel.com>
To: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, coreteam@netfilter.org, phil@nwl.cc,
	fw@strlen.de, pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: Re: [PATCH nf-next v5] netfilter: nf_tables: add math expression
 support
Message-ID: <202604261140.gX71SoJp-lkp@intel.com>
References: <20260421155859.7049-2-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421155859.7049-2-fmancera@suse.de>

Hi Fernando,

kernel test robot noticed the following build errors:

[auto build test ERROR on nf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Fernando-Fernandez-Mancera/netfilter-nf_tables-add-math-expression-support/20260424-055358
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git master
patch link:    https://lore.kernel.org/r/20260421155859.7049-2-fmancera%40suse.de
patch subject: [PATCH nf-next v5] netfilter: nf_tables: add math expression support
config: nios2-allmodconfig (https://download.01.org/0day-ci/archive/20260426/202604261140.gX71SoJp-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260426/202604261140.gX71SoJp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604261140.gX71SoJp-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   net/netfilter/nft_math.c: In function 'nft_math_eval_bitmask':
   net/netfilter/nft_math.c:49:17: error: implicit declaration of function 'DEBUG_NET_WARN_ONCE'; did you mean 'DEBUG_NET_WARN_ON_ONCE'? [-Werror=implicit-function-declaration]
      49 |                 DEBUG_NET_WARN_ONCE(true, "unknown operation path in nft_math");
         |                 ^~~~~~~~~~~~~~~~~~~
         |                 DEBUG_NET_WARN_ON_ONCE
   net/netfilter/nft_math.c: In function 'nft_math_init':
   net/netfilter/nft_math.c:95:39: error: passing argument 1 of 'nft_parse_register_load' from incompatible pointer type [-Werror=incompatible-pointer-types]
      95 |         err = nft_parse_register_load(ctx, tb[NFTA_MATH_SREG], &priv->sreg,
         |                                       ^~~
         |                                       |
         |                                       const struct nft_ctx *
   In file included from net/netfilter/nft_math.c:4:
   include/net/netfilter/nf_tables.h:235:50: note: expected 'const struct nlattr *' but argument is of type 'const struct nft_ctx *'
     235 | int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
         |                             ~~~~~~~~~~~~~~~~~~~~~^~~~
   net/netfilter/nft_math.c:95:46: error: passing argument 2 of 'nft_parse_register_load' from incompatible pointer type [-Werror=incompatible-pointer-types]
      95 |         err = nft_parse_register_load(ctx, tb[NFTA_MATH_SREG], &priv->sreg,
         |                                            ~~^~~~~~~~~~~~~~~~
         |                                              |
         |                                              const struct nlattr *
   In file included from net/netfilter/nft_math.c:4:
   include/net/netfilter/nf_tables.h:235:60: note: expected 'u8 *' {aka 'unsigned char *'} but argument is of type 'const struct nlattr *'
     235 | int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
         |                                                        ~~~~^~~~
>> net/netfilter/nft_math.c:95:64: warning: passing argument 3 of 'nft_parse_register_load' makes integer from pointer without a cast [-Wint-conversion]
      95 |         err = nft_parse_register_load(ctx, tb[NFTA_MATH_SREG], &priv->sreg,
         |                                                                ^~~~~~~~~~~
         |                                                                |
         |                                                                u8 * {aka unsigned char *}
   In file included from net/netfilter/nft_math.c:4:
   include/net/netfilter/nf_tables.h:235:70: note: expected 'u32' {aka 'unsigned int'} but argument is of type 'u8 *' {aka 'unsigned char *'}
     235 | int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
         |                                                                  ~~~~^~~
>> net/netfilter/nft_math.c:95:15: error: too many arguments to function 'nft_parse_register_load'
      95 |         err = nft_parse_register_load(ctx, tb[NFTA_MATH_SREG], &priv->sreg,
         |               ^~~~~~~~~~~~~~~~~~~~~~~
   In file included from net/netfilter/nft_math.c:4:
   include/net/netfilter/nf_tables.h:235:5: note: declared here
     235 | int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
         |     ^~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nft_math.c: At top level:
   net/netfilter/nft_math.c:129:27: error: initialization of 'int (*)(struct sk_buff *, const struct nft_expr *)' from incompatible pointer type 'int (*)(struct sk_buff *, const struct nft_expr *, bool)' {aka 'int (*)(struct sk_buff *, const struct nft_expr *, _Bool)'} [-Werror=incompatible-pointer-types]
     129 |         .dump           = nft_math_dump,
         |                           ^~~~~~~~~~~~~
   net/netfilter/nft_math.c:129:27: note: (near initialization for 'nft_math_op.dump')
   cc1: some warnings being treated as errors


vim +/nft_parse_register_load +95 net/netfilter/nft_math.c

    65	
    66	static int nft_math_init(const struct nft_ctx *ctx,
    67				 const struct nft_expr *expr,
    68				 const struct nlattr * const tb[])
    69	{
    70		struct nft_math *priv = nft_expr_priv(expr);
    71		u32 bitmask_check;
    72		int err;
    73		u32 op;
    74	
    75		if (!tb[NFTA_MATH_SREG] ||
    76		    !tb[NFTA_MATH_DREG] ||
    77		    !tb[NFTA_MATH_BITMASK] ||
    78		    !tb[NFTA_MATH_OP])
    79			return -EINVAL;
    80	
    81		op = nla_get_u32(tb[NFTA_MATH_OP]);
    82		if (op > NFT_MATH_OP_MAX)
    83			return -EOPNOTSUPP;
    84		priv->op = op;
    85	
    86		priv->bitmask = nla_get_u32(tb[NFTA_MATH_BITMASK]);
    87		if (!priv->bitmask)
    88			return -EINVAL;
    89	
    90		/* check if the bitmask is contiguous, otherwise reject it */
    91		bitmask_check = priv->bitmask + (priv->bitmask & -priv->bitmask);
    92		if (bitmask_check & (bitmask_check - 1))
    93			return -EINVAL;
    94	
  > 95		err = nft_parse_register_load(ctx, tb[NFTA_MATH_SREG], &priv->sreg,
    96					      sizeof(u32));
    97		if (err < 0)
    98			return err;
    99	
   100		return nft_parse_register_store(ctx, tb[NFTA_MATH_DREG],
   101						&priv->dreg, NULL, NFT_DATA_VALUE,
   102						sizeof(u32));
   103	}
   104	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
