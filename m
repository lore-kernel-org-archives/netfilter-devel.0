Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AB71EA65
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Jan 2026 04:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768537299; cv=none; b=HTJJnVMcI6X8KGv1towtBIl7qo59Pg8dwhoI6pcV87xk/+PGYDej27N84+aEtY9iHRWkJbe8mLNf0ik8Mj77l/MVpz/wTPa+Jex55v3jZX8KT8zqIjtZ3g8FcYy0zcrZQt6ay/4JxXXvKoVLtLQS5xQGuo1ml/+ViMH3oj1B+wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768537299; c=relaxed/simple;
	bh=MYIFnB6pBidwLGKs83IbzIBRahmHLs0/1tG2mEJCb1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EkWhq7Iog9UlMkl/FR5JlAXgRB1Il3d92zORS3d+WpPLXktvP+7Jjs3YPpvkEGxQTCPSkMD959XCXYv6OZE8qOLE0xA0msZQQ0zO6GqWUgHDodnVmmK6hujqNHQM92j+N/7mo2i/Zxol7PrLM60jKzK/utwUUGQ6oynzB3aFv7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JSbQkRsQ; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JSbQkRsQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768537298; x=1800073298;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MYIFnB6pBidwLGKs83IbzIBRahmHLs0/1tG2mEJCb1o=;
  b=JSbQkRsQLqtOiy1h3wk/ye+KIgJqUcyecjdbQdAIpkECmFd/9tv3RmiH
   eT2BwzMmUn4yqMS1lSYEWOuStcWmvo7z3DR8uTMcGMjg83uDerbVsN221
   luJCCAGImmeGK2cWKQSGRugVOjst/KX+nJykmG0VtzTukpgz1nbIx4zU4
   0ZXZkFAZVYV8oVLo/O3kndwAD5Q0SSAVuoVCuVraLMDmY72EDW7EwXPBF
   Dj1yOv/BPAIfxPwxlNBt6kkkbYe/HHRtFg9KiKNXBAuaw3UzXn/LJ/OJX
   bbwvhFyF1WoxEq7+Yoj92rvONVcLOyZk5MK1pMGgbH2B22aHJ/fUYMIFO
   A==;
X-CSE-ConnectionGUID: HOk5FTV0RLmeDn10DFZ6yw==
X-CSE-MsgGUID: nahCIyqtTB6+HBtbx965Rg==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="92519363"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="92519363"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 20:21:38 -0800
X-CSE-ConnectionGUID: JlzT4hTRRbqywUfqBXiu/g==
X-CSE-MsgGUID: /SIGt+1ETfehcwdkm6P8ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="235831972"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 15 Jan 2026 20:21:37 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgbL4-00000000KMe-1Emt;
	Fri, 16 Jan 2026 04:21:34 +0000
Date: Fri, 16 Jan 2026 12:21:07 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, fw@strlen.de
Subject: Re: [PATCH nf-next,v1 2/3] netfilter: nft_set_rbtree: translate
 rbtree to array for binary search
Message-ID: <202601161133.QwCjx0vn-lkp@intel.com>
References: <20260115124322.90712-3-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115124322.90712-3-pablo@netfilter.org>

Hi Pablo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on netfilter-nf/main]
[also build test WARNING on linus/master v6.19-rc5 next-20260115]
[cannot apply to nf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pablo-Neira-Ayuso/netfilter-nf_tables-add-abort_skip_removal-flag-for-set-types/20260115-204555
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20260115124322.90712-3-pablo%40netfilter.org
patch subject: [PATCH nf-next,v1 2/3] netfilter: nft_set_rbtree: translate rbtree to array for binary search
config: sh-randconfig-r121-20260116 (https://download.01.org/0day-ci/archive/20260116/202601161133.QwCjx0vn-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601161133.QwCjx0vn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601161133.QwCjx0vn-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> net/netfilter/nft_set_rbtree.c:823:38: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct nft_array *array @@     got struct nft_array [noderef] __rcu *array @@
   net/netfilter/nft_set_rbtree.c:823:38: sparse:     expected struct nft_array *array
   net/netfilter/nft_set_rbtree.c:823:38: sparse:     got struct nft_array [noderef] __rcu *array
   net/netfilter/nft_set_rbtree.c: note: in included file (through include/linux/mm_types.h, include/linux/mmzone.h, include/linux/gfp.h, ...):
   include/linux/rbtree.h:102:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   include/linux/rbtree.h:102:9: sparse:    struct rb_node [noderef] __rcu *
   include/linux/rbtree.h:102:9: sparse:    struct rb_node *

vim +823 net/netfilter/nft_set_rbtree.c

   808	
   809	static void nft_rbtree_destroy(const struct nft_ctx *ctx,
   810				       const struct nft_set *set)
   811	{
   812		struct nft_rbtree *priv = nft_set_priv(set);
   813		struct nft_rbtree_elem *rbe;
   814		struct rb_node *node;
   815	
   816		while ((node = priv->root.rb_node) != NULL) {
   817			rb_erase(node, &priv->root);
   818			rbe = rb_entry(node, struct nft_rbtree_elem, node);
   819			nf_tables_set_elem_destroy(ctx, set, &rbe->priv);
   820		}
   821	
   822		if (priv->array)
 > 823			__nft_array_free(priv->array);
   824		if (priv->array_next)
   825			__nft_array_free(priv->array_next);
   826	}
   827	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
