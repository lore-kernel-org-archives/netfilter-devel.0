Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED0EC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Mar 2022 17:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350819AbiCKRkz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Mar 2022 12:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350828AbiCKRkz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Mar 2022 12:40:55 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC94C1BE4D0
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Mar 2022 09:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647020390; x=1678556390;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e4tfBPnSoTlMbYf9N8KaPsAkTwGngzrN8mMHYSEtzA0=;
  b=L6infI1yzpVxfIrtzwZR+An29gKP0P68kCvzCPCxxOZxdrLRq+BnjL0A
   CUQBGYTr7oHxQ4K4mrHw8ep1G29tOOAoGn6I39uLD6WnVJIS5m+j9OOe4
   nPXL3mjuBzTQGJ7BV/Pf2Bp3/nrLTlyGldrLdrgQLR08/LOr3788SeOoM
   B+u43gbDJRHkRqUJC3sQfZlMeU4Crb/fed5dDTKRTX0PeNO3S3ffJI5hQ
   KheyiFFzhLbwOM1J2c/OaXhDp86nHHULW8XxUPbMCD8bMHm/5N8O47TjB
   qZ/8BkHQSMXXMAyvLvE6cH6dUhBxGVQqmcFXEDfM66E+6eocffASr21LO
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10283"; a="342045221"
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="342045221"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 09:39:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="514575532"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 11 Mar 2022 09:39:39 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nSjEp-0006s7-6c; Fri, 11 Mar 2022 17:39:39 +0000
Date:   Sat, 12 Mar 2022 01:39:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add stubs for readonly
 expressions
Message-ID: <202203120145.fZ2sQ2qv-lkp@intel.com>
References: <20220311105430.12075-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311105430.12075-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

I love your patch! Yet something to improve:

[auto build test ERROR on next-20220310]
[cannot apply to nf-next/master nf/master linus/master v5.17-rc7 v5.17-rc6 v5.17-rc5 v5.17-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Florian-Westphal/netfilter-nf_tables-add-stubs-for-readonly-expressions/20220311-185613
base:    71941773e143369a73c9c4a3b62fbb60736a1182
config: powerpc64-buildonly-randconfig-r003-20220310 (https://download.01.org/0day-ci/archive/20220312/202203120145.fZ2sQ2qv-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/a0cb27794354ccba36b882731b93fdda090f2003
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Florian-Westphal/netfilter-nf_tables-add-stubs-for-readonly-expressions/20220311-185613
        git checkout a0cb27794354ccba36b882731b93fdda090f2003
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=powerpc SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/netfilter/nft_cmp.c:363:27: error: 'nft_cmp_reduce' undeclared here (not in a function); did you mean 'nft_cmp_dump'?
     363 |         .reduce         = nft_cmp_reduce,
         |                           ^~~~~~~~~~~~~~
         |                           nft_cmp_dump


vim +363 net/netfilter/nft_cmp.c

   354	
   355	
   356	const struct nft_expr_ops nft_cmp16_fast_ops = {
   357		.type		= &nft_cmp_type,
   358		.size		= NFT_EXPR_SIZE(sizeof(struct nft_cmp16_fast_expr)),
   359		.eval		= NULL,	/* inlined */
   360		.init		= nft_cmp16_fast_init,
   361		.dump		= nft_cmp16_fast_dump,
   362		.offload	= nft_cmp16_fast_offload,
 > 363		.reduce		= nft_cmp_reduce,
   364	};
   365	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
