Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A640C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 May 2022 01:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbiELBkG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 May 2022 21:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbiELBkG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 May 2022 21:40:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C991BDDAB
        for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2022 18:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652319603; x=1683855603;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=f8P69KupjwRzTuQNrmiBYiVPOIKlovqE/J+ffkEbhQ0=;
  b=EzitOVXRSL+OMQyc9V/KsABMnwbWDVhNq/JTo2/fL/K/lmRvbDIGCAjS
   1XY4MYWluG2bjqXWerhbr0rCg/0iTux/o1NH3qtkOWjyvFFjExOogm1eT
   SIBVB8mqdrgMldco5QCAEQyE6LvMJdalliiryA/H4W8kPFNruRtv7T56f
   /2pBigkeyxllNNifFIu/3lI0K1VCq6XJIvP/lx/oKnm/kbpgtHnq805na
   fent4DdM8cP0Roezryl0QvSRpGqYeZhK+YiK+8OJnlu71kgcZdyP73hbZ
   X+/ABDybKZi4Rb3tJb5Q2MPnhB5x3eAJcMbWI5q5DEk+6oB8reNZFn8/Z
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="295105318"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="295105318"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 18:40:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="624192423"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 11 May 2022 18:40:01 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1noxo9-000Jo2-8w;
        Thu, 12 May 2022 01:40:01 +0000
Date:   Thu, 12 May 2022 09:39:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kbuild-all@lists.01.org, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH 2/2] netfilter: nf_tables: Annotate reduced
 expressions
Message-ID: <202205120906.nNquMTSm-lkp@intel.com>
References: <20220511165453.22425-3-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511165453.22425-3-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on nf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Phil-Sutter/nf_tables-Export-rule-optimizer-results-to-user-space/20220512-005642
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20220512/202205120906.nNquMTSm-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/831b99f09285d0cc3a4fb0fcb6fd7c74aaea988a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Phil-Sutter/nf_tables-Export-rule-optimizer-results-to-user-space/20220512-005642
        git checkout 831b99f09285d0cc3a4fb0fcb6fd7c74aaea988a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/netfilter/nft_bitwise.c: In function 'nft_bitwise_reduce':
>> net/netfilter/nft_bitwise.c:306:28: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     306 |                 track->cur = expr;
         |                            ^
   net/netfilter/nft_bitwise.c: In function 'nft_bitwise_fast_reduce':
   net/netfilter/nft_bitwise.c:454:28: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     454 |                 track->cur = expr;
         |                            ^


vim +/const +306 net/netfilter/nft_bitwise.c

bd8699e9e29287 Pablo Neira Ayuso 2019-07-30  281  
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  282  static bool nft_bitwise_reduce(struct nft_regs_track *track,
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  283  			       const struct nft_expr *expr)
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  284  {
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  285  	const struct nft_bitwise *priv = nft_expr_priv(expr);
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  286  	const struct nft_bitwise *bitwise;
34cc9e52884a16 Pablo Neira Ayuso 2022-03-14  287  	unsigned int regcount;
34cc9e52884a16 Pablo Neira Ayuso 2022-03-14  288  	u8 dreg;
34cc9e52884a16 Pablo Neira Ayuso 2022-03-14  289  	int i;
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  290  
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  291  	if (!track->regs[priv->sreg].selector)
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  292  		return false;
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  293  
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  294  	bitwise = nft_expr_priv(expr);
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  295  	if (track->regs[priv->sreg].selector == track->regs[priv->dreg].selector &&
34cc9e52884a16 Pablo Neira Ayuso 2022-03-14  296  	    track->regs[priv->sreg].num_reg == 0 &&
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  297  	    track->regs[priv->dreg].bitwise &&
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  298  	    track->regs[priv->dreg].bitwise->ops == expr->ops &&
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  299  	    priv->sreg == bitwise->sreg &&
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  300  	    priv->dreg == bitwise->dreg &&
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  301  	    priv->op == bitwise->op &&
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  302  	    priv->len == bitwise->len &&
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  303  	    !memcmp(&priv->mask, &bitwise->mask, sizeof(priv->mask)) &&
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  304  	    !memcmp(&priv->xor, &bitwise->xor, sizeof(priv->xor)) &&
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  305  	    !memcmp(&priv->data, &bitwise->data, sizeof(priv->data))) {
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09 @306  		track->cur = expr;
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  307  		return true;
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  308  	}
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  309  
34cc9e52884a16 Pablo Neira Ayuso 2022-03-14  310  	if (track->regs[priv->sreg].bitwise ||
34cc9e52884a16 Pablo Neira Ayuso 2022-03-14  311  	    track->regs[priv->sreg].num_reg != 0) {
34cc9e52884a16 Pablo Neira Ayuso 2022-03-14  312  		nft_reg_track_cancel(track, priv->dreg, priv->len);
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  313  		return false;
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  314  	}
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  315  
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  316  	if (priv->sreg != priv->dreg) {
34cc9e52884a16 Pablo Neira Ayuso 2022-03-14  317  		nft_reg_track_update(track, track->regs[priv->sreg].selector,
34cc9e52884a16 Pablo Neira Ayuso 2022-03-14  318  				     priv->dreg, priv->len);
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  319  	}
34cc9e52884a16 Pablo Neira Ayuso 2022-03-14  320  
34cc9e52884a16 Pablo Neira Ayuso 2022-03-14  321  	dreg = priv->dreg;
34cc9e52884a16 Pablo Neira Ayuso 2022-03-14  322  	regcount = DIV_ROUND_UP(priv->len, NFT_REG32_SIZE);
34cc9e52884a16 Pablo Neira Ayuso 2022-03-14  323  	for (i = 0; i < regcount; i++, dreg++)
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  324  		track->regs[priv->dreg].bitwise = expr;
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  325  
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  326  	return false;
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  327  }
be5650f8f47e8c Pablo Neira Ayuso 2022-01-09  328  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
