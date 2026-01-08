Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCF630FF36;
	Thu,  8 Jan 2026 18:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767896896; cv=none; b=UJGU+dqe7BH8fSpE22q+OChhM+wSus9kJRS4jti5MFaNktO8/97tqVn+CIE9v8N5CW97Oba3cWweSn9Mn0Rv7tP/t8Wh6DBNknDn5uD73a5vgk1DK5t7T3r3qe6tRHOnVXvwZsmfLruD6/1ciXkQOkjYdz2UK8Apca4+gMcX/nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767896896; c=relaxed/simple;
	bh=qyq5nhbDoXDiN3ijuo6psDR0mWRwMVhzlc18Fvdqv+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ChTFIIcNouDG+QOjRd98dTkZU8fb/jTjSOajZrMrbWV0VRfXi9KW+L9CFLB5GLxwsJ3uM8k0GgVABbV7BCpEyQQ+GiEedVVP5D+SbdZAluYmpbsU5McBE0u2KJjSRgkYziMa8Rb7rit7zKxsNCdrxfsE18dbs0NV3GZvOOYa7fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mIwYiqXu; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mIwYiqXu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767896895; x=1799432895;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qyq5nhbDoXDiN3ijuo6psDR0mWRwMVhzlc18Fvdqv+8=;
  b=mIwYiqXu5HMh+jI9eHK6mUGXiZ4BAJKSNZHTIUXc+7x/bxqmR9AvcMmH
   XdH18xFi4noXpOKdAvlTns3upsqBueUb1TuMFIZSlwtIrJg5lZQxRdpwT
   JKkqUDgC/ji5MXSdQU7qVM/F53OHm2pA03znOFINNh8VhCPs5jzkzKkJU
   LafKpnsKDVFYvSWjoV4/N9kssKfixTOCTgkHfZQsSOmENmHvVLj+kE8Ge
   6Hl3rC+DYUKPht5/nI1urSHQqPcF4haGnTJXlUR9qPtcXM1w/WSDHOXFY
   hSZ7AY/cW6x3lJqXS0NnZALicy56HIZtOKzsLvBoLcmqziUgAOMyKLzBT
   g==;
X-CSE-ConnectionGUID: hKrxvdxgSmW/fFUT+ECHmg==
X-CSE-MsgGUID: SwWgOUioTqOGzRv/kp9/zA==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="69355822"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="69355822"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 10:28:14 -0800
X-CSE-ConnectionGUID: etBJ+3X4TreNu+KYnkqQQA==
X-CSE-MsgGUID: PUHwBd40QNuDeHW6uVvqLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="202481406"
Received: from igk-lkp-server01.igk.intel.com (HELO 92b2e8bd97aa) ([10.211.93.152])
  by orviesa010.jf.intel.com with ESMTP; 08 Jan 2026 10:28:13 -0800
Received: from kbuild by 92b2e8bd97aa with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vdujx-000000001pw-2Xqg;
	Thu, 08 Jan 2026 18:28:09 +0000
Date: Thu, 8 Jan 2026 19:27:54 +0100
From: kernel test robot <lkp@intel.com>
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, jhs@mojatatu.com,
	xiyou.wangcong@gmail.com, jiri@resnulli.us, audit@vger.kernel.org,
	bridge@lists.linux.dev, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/2] netfilter: nf_conntrack: don't rely on
 implicit includes
Message-ID: <202601081929.C2oDWexU-lkp@intel.com>
References: <20260107152548.31769-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107152548.31769-2-fw@strlen.de>

Hi Florian,

kernel test robot noticed the following build errors:

[auto build test ERROR on netfilter-nf/main]
[also build test ERROR on pcmoore-audit/next next-20260108]
[cannot apply to nf-next/master linus/master v6.16-rc1]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Westphal/netfilter-nf_conntrack-don-t-rely-on-implicit-includes/20260108-012311
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20260107152548.31769-2-fw%40strlen.de
patch subject: [PATCH nf-next 1/2] netfilter: nf_conntrack: don't rely on implicit includes
config: x86_64-rhel-9.4-bpf (https://download.01.org/0day-ci/archive/20260108/202601081929.C2oDWexU-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260108/202601081929.C2oDWexU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601081929.C2oDWexU-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/netfilter/nf_conntrack_bpf.c: In function 'bpf_skb_ct_alloc':
>> net/netfilter/nf_conntrack_bpf.c:367:46: error: implicit declaration of function 'sock_net'; did you mean 'check_net'? [-Wimplicit-function-declaration]
     367 |         net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
         |                                              ^~~~~~~~
         |                                              check_net
>> net/netfilter/nf_conntrack_bpf.c:367:44: error: pointer/integer type mismatch in conditional expression [-Wint-conversion]
     367 |         net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
         |                                            ^
   net/netfilter/nf_conntrack_bpf.c: In function 'bpf_skb_ct_lookup':
   net/netfilter/nf_conntrack_bpf.c:402:51: error: pointer/integer type mismatch in conditional expression [-Wint-conversion]
     402 |         caller_net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
         |                                                   ^


vim +367 net/netfilter/nf_conntrack_bpf.c

b4c2b9593a1c4c Kumar Kartikeya Dwivedi 2022-01-14  343  
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  344  /* bpf_skb_ct_alloc - Allocate a new CT entry
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  345   *
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  346   * Parameters:
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  347   * @skb_ctx	- Pointer to ctx (__sk_buff) in TC program
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  348   *		    Cannot be NULL
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  349   * @bpf_tuple	- Pointer to memory representing the tuple to look up
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  350   *		    Cannot be NULL
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  351   * @tuple__sz	- Length of the tuple structure
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  352   *		    Must be one of sizeof(bpf_tuple->ipv4) or
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  353   *		    sizeof(bpf_tuple->ipv6)
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  354   * @opts	- Additional options for allocation (documented above)
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  355   *		    Cannot be NULL
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  356   * @opts__sz	- Length of the bpf_ct_opts structure
ece4b296904167 Brad Cowie              2024-05-22  357   *		    Must be NF_BPF_CT_OPTS_SZ (16) or 12
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  358   */
400031e05adfce David Vernet            2023-02-01  359  __bpf_kfunc struct nf_conn___init *
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  360  bpf_skb_ct_alloc(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  361  		 u32 tuple__sz, struct bpf_ct_opts *opts, u32 opts__sz)
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  362  {
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  363  	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  364  	struct nf_conn *nfct;
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  365  	struct net *net;
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  366  
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21 @367  	net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  368  	nfct = __bpf_nf_ct_alloc_entry(net, bpf_tuple, tuple__sz, opts, opts__sz, 10);
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  369  	if (IS_ERR(nfct)) {
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  370  		if (opts)
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  371  			opts->error = PTR_ERR(nfct);
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  372  		return NULL;
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  373  	}
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  374  
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  375  	return (struct nf_conn___init *)nfct;
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  376  }
d7e79c97c00ca8 Lorenzo Bianconi        2022-07-21  377  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
