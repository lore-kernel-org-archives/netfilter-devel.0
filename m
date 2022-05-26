Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93624C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 May 2022 13:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347514AbiEZNVO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 May 2022 09:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239641AbiEZNVN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 May 2022 09:21:13 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7870E013
        for <netfilter-devel@vger.kernel.org>; Thu, 26 May 2022 06:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653571269; x=1685107269;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rGshprtfTFf5DRIXFvNqu/mGzry0GYqUeey2aN6JSXo=;
  b=TUJ8SLiD3IW27YYeyZ8bIytHBfBBguvspQ4bST5nO3iJZCzvPxVAJKPG
   6w+1js32lNke55uWxwGcS0/XACuqGT66YbkugMNFBNG3npsiIMSUM62Ph
   aScmn1JR7uFzxjVYb6X3Cq7B0cxP7GiebP9Ot1YSmhmQ3wueoFmIN7gTX
   8JR13cYvisqOEl7hT70yp8UK69TGP3JI9bRi7mOo7SQiHKlhwP66FWo0i
   658uqA8UxTJJ7aCGNLOgyTnbf9/pKf4PjNBViT1r9yR8RVvOdt1mx4bEI
   6X1Xc8zO0SYZZMnFhg3ypfAoOdtx+D6xFigvptGHkH1/csg1socf7vfSV
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="337200965"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="337200965"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2022 06:21:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="902016093"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 26 May 2022 06:21:07 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nuDQI-0003tR-QX;
        Thu, 26 May 2022 13:21:06 +0000
Date:   Thu, 26 May 2022 21:20:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, edg-e@nccgroup.com
Subject: Re: [PATCH nf] netfilter: nf_tables: disallow non-stateful
 expression in sets earlier
Message-ID: <202205262104.cowfvBMc-lkp@intel.com>
References: <20220526105952.306242-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526105952.306242-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

I love your patch! Perhaps something to improve:

[auto build test WARNING on nf/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Pablo-Neira-Ayuso/netfilter-nf_tables-disallow-non-stateful-expression-in-sets-earlier/20220526-190122
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git master
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20220526/202205262104.cowfvBMc-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 6f4644d194da594562027a5d458d9fb7a20ebc39)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/08b6b97fd372a14e82e821bb2b4c9c10c1426080
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Pablo-Neira-Ayuso/netfilter-nf_tables-disallow-non-stateful-expression-in-sets-earlier/20220526-190122
        git checkout 08b6b97fd372a14e82e821bb2b4c9c10c1426080
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/netfilter/nf_tables_api.c:5431:17: warning: variable 'err' is uninitialized when used here [-Wuninitialized]
           return ERR_PTR(err);
                          ^~~
   net/netfilter/nf_tables_api.c:5413:9: note: initialize the variable 'err' to silence this warning
           int err;
                  ^
                   = 0
   1 warning generated.


vim +/err +5431 net/netfilter/nf_tables_api.c

60319eb1ca351a Pablo Neira Ayuso 2014-04-04  5407  
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5408  struct nft_expr *nft_set_elem_expr_alloc(const struct nft_ctx *ctx,
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5409  					 const struct nft_set *set,
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5410  					 const struct nlattr *attr)
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5411  {
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5412  	struct nft_expr *expr;
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5413  	int err;
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5414  
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5415  	expr = nft_expr_init(ctx, attr);
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5416  	if (IS_ERR(expr))
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5417  		return expr;
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5418  
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5419  	if (expr->ops->type->flags & NFT_EXPR_GC) {
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5420  		if (set->flags & NFT_SET_TIMEOUT)
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5421  			goto err_set_elem_expr;
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5422  		if (!set->ops->gc_init)
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5423  			goto err_set_elem_expr;
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5424  		set->ops->gc_init(set);
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5425  	}
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5426  
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5427  	return expr;
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5428  
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5429  err_set_elem_expr:
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5430  	nft_expr_destroy(ctx, expr);
a7fc9368040841 Pablo Neira Ayuso 2020-03-11 @5431  	return ERR_PTR(err);
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5432  }
a7fc9368040841 Pablo Neira Ayuso 2020-03-11  5433  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
