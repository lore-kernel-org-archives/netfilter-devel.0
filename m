Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3D635F195
	for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2026 01:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777946166; cv=none; b=Msm8LiG3F5zb1Ei+XG9qmcuZuiRv7JiCHnAcjqith5IupQJWDEU+jjACuVaX9+smwTl14h9ZGS8at0m+xyUH0NI94qFt8XzjgKxMPXyaUH3kQH2i+/8H4Qty86qB2qKW12tL5kUMGR1/zmq4Ck1noiGk7CXhVousDIn09PqgoGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777946166; c=relaxed/simple;
	bh=q0F2mpqwHxaZMFwNbS2gb8O51HQZyEq7sZDL9uGk2lU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XDiN8l5jSfCUglGQXhKxGiUwi4RxhTXENwN9EEr48yFqc9xHhdNQzimSFHDfkiXLmnfmZykClaYRVVUYRNqSvTi3lSCNtiaZCpTjCG00KwhnnoyezmGaAcVjFtmOGkzEEC73q9ENSI+ZE94I/waKt5Hmp5jDMhlT50sL0k1+GCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CcoJ39/y; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CcoJ39/y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777946165; x=1809482165;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=q0F2mpqwHxaZMFwNbS2gb8O51HQZyEq7sZDL9uGk2lU=;
  b=CcoJ39/yUcxaAntUjlZguLza1Q5i9xx7op5xPS6vsibiCt5htg9qj5v1
   QWTeu3G8hQQKbBqP0jfCF9scDRAtdlpkDrgzYBtG1CTv034YcST7fLg8Q
   +vL94gH/TT4v8QJZZzlMODD7y0CLZxgKwNEcJ4TYI8UM2O5jGXwT6Y994
   4rGQCOXtBZIPn232DMPIYzdLRx64fr4QRCNB6BmHi8DQp02Aa9WKR/Kbz
   ZaKRnEg2fpCr069azoLqOGHDlpG+onmMw57KE43nE0WSx5fkUqCMZHnvC
   o6nKsybtj3P9ZuR5DUI6GZ9vEoQHc64UOFJFxN/0ow8HRqzXXrwarFKYb
   Q==;
X-CSE-ConnectionGUID: RPTK90XeQJ++Js5Q0W7Jxg==
X-CSE-MsgGUID: 4oeeff0hTYWF9JP6SIIYVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="101476802"
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="101476802"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 18:56:04 -0700
X-CSE-ConnectionGUID: 9wYmG9eBRwy9iAKqAvjAwQ==
X-CSE-MsgGUID: p9nTE8P2S8CEy0s+Q2H16w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="266026483"
Received: from lkp-server01.sh.intel.com (HELO 781826d00641) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 04 May 2026 18:56:02 -0700
Received: from kbuild by 781826d00641 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wK50q-0000000048f-1F4S;
	Tue, 05 May 2026 01:55:54 +0000
Date: Tue, 5 May 2026 09:55:25 +0800
From: kernel test robot <lkp@intel.com>
To: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, coreteam@netfilter.org, phil@nwl.cc,
	fw@strlen.de, pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: Re: [PATCH nf-next v5] netfilter: nf_tables: add math expression
 support
Message-ID: <202605050928.BM8aFWgX-lkp@intel.com>
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
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20260505/202605050928.BM8aFWgX-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260505/202605050928.BM8aFWgX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605050928.BM8aFWgX-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/netfilter/nft_math.c: In function 'nft_math_eval_bitmask':
>> net/netfilter/nft_math.c:49:17: error: implicit declaration of function 'DEBUG_NET_WARN_ONCE'; did you mean 'DEBUG_NET_WARN_ON_ONCE'? [-Wimplicit-function-declaration]
      49 |                 DEBUG_NET_WARN_ONCE(true, "unknown operation path in nft_math");
         |                 ^~~~~~~~~~~~~~~~~~~
         |                 DEBUG_NET_WARN_ON_ONCE
   net/netfilter/nft_math.c: In function 'nft_math_init':
>> net/netfilter/nft_math.c:95:39: error: passing argument 1 of 'nft_parse_register_load' from incompatible pointer type [-Wincompatible-pointer-types]
      95 |         err = nft_parse_register_load(ctx, tb[NFTA_MATH_SREG], &priv->sreg,
         |                                       ^~~
         |                                       |
         |                                       const struct nft_ctx *
   In file included from net/netfilter/nft_math.c:4:
   include/net/netfilter/nf_tables.h:235:50: note: expected 'const struct nlattr *' but argument is of type 'const struct nft_ctx *'
     235 | int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
         |                             ~~~~~~~~~~~~~~~~~~~~~^~~~
   net/netfilter/nft_math.c:95:46: error: passing argument 2 of 'nft_parse_register_load' from incompatible pointer type [-Wincompatible-pointer-types]
      95 |         err = nft_parse_register_load(ctx, tb[NFTA_MATH_SREG], &priv->sreg,
         |                                            ~~^~~~~~~~~~~~~~~~
         |                                              |
         |                                              const struct nlattr *
   include/net/netfilter/nf_tables.h:235:60: note: expected 'u8 *' {aka 'unsigned char *'} but argument is of type 'const struct nlattr *'
     235 | int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
         |                                                        ~~~~^~~~
>> net/netfilter/nft_math.c:95:64: error: passing argument 3 of 'nft_parse_register_load' makes integer from pointer without a cast [-Wint-conversion]
      95 |         err = nft_parse_register_load(ctx, tb[NFTA_MATH_SREG], &priv->sreg,
         |                                                                ^~~~~~~~~~~
         |                                                                |
         |                                                                u8 * {aka unsigned char *}
   include/net/netfilter/nf_tables.h:235:70: note: expected 'u32' {aka 'unsigned int'} but argument is of type 'u8 *' {aka 'unsigned char *'}
     235 | int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
         |                                                                  ~~~~^~~
>> net/netfilter/nft_math.c:95:15: error: too many arguments to function 'nft_parse_register_load'; expected 3, have 4
      95 |         err = nft_parse_register_load(ctx, tb[NFTA_MATH_SREG], &priv->sreg,
         |               ^~~~~~~~~~~~~~~~~~~~~~~
      96 |                                       sizeof(u32));
         |                                       ~~~~~~~~~~~
   include/net/netfilter/nf_tables.h:235:5: note: declared here
     235 | int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
         |     ^~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nft_math.c: At top level:
>> net/netfilter/nft_math.c:129:27: error: initialization of 'int (*)(struct sk_buff *, const struct nft_expr *)' from incompatible pointer type 'int (*)(struct sk_buff *, const struct nft_expr *, bool)' {aka 'int (*)(struct sk_buff *, const struct nft_expr *, _Bool)'} [-Wincompatible-pointer-types]
     129 |         .dump           = nft_math_dump,
         |                           ^~~~~~~~~~~~~
   net/netfilter/nft_math.c:129:27: note: (near initialization for 'nft_math_op.dump')
   net/netfilter/nft_math.c:105:12: note: 'nft_math_dump' declared here
     105 | static int nft_math_dump(struct sk_buff *skb,
         |            ^~~~~~~~~~~~~


vim +49 net/netfilter/nft_math.c

    19	
    20	static void nft_math_eval_bitmask(u32 *src, u32 *dst,
    21					  const struct nft_math *priv)
    22	{
    23		u32 target, keep, bit_unit;
    24	
    25		target = *src & priv->bitmask;
    26		keep = *src & ~priv->bitmask;
    27		bit_unit = priv->bitmask & -priv->bitmask;
    28	
    29		switch (priv->op) {
    30		case NFT_MATH_OP_INC:
    31			if (target == priv->bitmask) {
    32				*dst = *src;
    33				break;
    34			}
    35	
    36			target = target + bit_unit;
    37			*dst = target | keep;
    38			break;
    39		case NFT_MATH_OP_DEC:
    40			if (!target) {
    41				*dst = *src;
    42				break;
    43			}
    44	
    45			target = target - bit_unit;
    46			*dst = target | keep;
    47			break;
    48		default:
  > 49			DEBUG_NET_WARN_ONCE(true, "unknown operation path in nft_math");
    50			*dst = *src;
    51			break;
    52		}
    53	}
    54	
    55	static void nft_math_eval(const struct nft_expr *expr,
    56				  struct nft_regs *regs,
    57				  const struct nft_pktinfo *pkt)
    58	{
    59		const struct nft_math *priv = nft_expr_priv(expr);
    60		u32 *src = &regs->data[priv->sreg];
    61		u32 *dst = &regs->data[priv->dreg];
    62	
    63		nft_math_eval_bitmask(src, dst, priv);
    64	}
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
   105	static int nft_math_dump(struct sk_buff *skb,
   106				 const struct nft_expr *expr, bool reset)
   107	{
   108		const struct nft_math *priv = nft_expr_priv(expr);
   109	
   110		if (nft_dump_register(skb, NFTA_MATH_SREG, priv->sreg))
   111			goto nla_put_failure;
   112		if (nft_dump_register(skb, NFTA_MATH_DREG, priv->dreg))
   113			goto nla_put_failure;
   114		if (nla_put_u32(skb, NFTA_MATH_BITMASK, priv->bitmask))
   115			goto nla_put_failure;
   116		if (nla_put_u32(skb, NFTA_MATH_OP, priv->op))
   117			goto nla_put_failure;
   118		return 0;
   119	
   120	nla_put_failure:
   121		return -1;
   122	}
   123	
   124	static struct nft_expr_type nft_math_type;
   125	static const struct nft_expr_ops nft_math_op = {
   126		.eval		= nft_math_eval,
   127		.size		= NFT_EXPR_SIZE(sizeof(struct nft_math)),
   128		.init		= nft_math_init,
 > 129		.dump		= nft_math_dump,
   130		.type		= &nft_math_type,
   131	};
   132	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
