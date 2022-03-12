Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE5A5C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Mar 2022 03:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiCLDVR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Mar 2022 22:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiCLDVR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Mar 2022 22:21:17 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998311CB0E
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Mar 2022 19:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647055212; x=1678591212;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=goX+xGlmRDXAZwWMm5XbHhopwbierJEng2Bi61BgEyA=;
  b=VlBZSet4+5cV+QsODyQPj2YZqIlUMN0/RGOAW+2FCeCpWJC/tuuD5104
   uiIFNIo0M0yL4sWmCdtxM20mz9RDGZivupnsVZGVck8iYxhIuEFAmMc9+
   nO+A69D6t/T9ML6xPnRh4BafUCpyC6QQd1kznGY55m/zDximSKtN9kJou
   UNKcHVz80QWZw+jgNYYKwnkCARRmaWk6cgz9X3AcqMiFrWWsDBqxgfJF9
   UM7e36UeVyxgqLMsld8uJXV3bsMqHdHujgadDJNiORLVgdx1iWsubcSRA
   Omjrm0z+monSRYaTcaavr9buyzn7yKg7v3FTZpWwNN91/StqVRD/14mkq
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10283"; a="255462937"
X-IronPort-AV: E=Sophos;i="5.90,175,1643702400"; 
   d="scan'208";a="255462937"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 19:20:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,175,1643702400"; 
   d="scan'208";a="496991264"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 11 Mar 2022 19:20:10 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nSsIc-0007Sl-5L; Sat, 12 Mar 2022 03:20:10 +0000
Date:   Sat, 12 Mar 2022 11:19:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add stubs for readonly
 expressions
Message-ID: <202203121116.d70Q3u7w-lkp@intel.com>
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
config: m68k-defconfig (https://download.01.org/0day-ci/archive/20220312/202203121116.d70Q3u7w-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/a0cb27794354ccba36b882731b93fdda090f2003
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Florian-Westphal/netfilter-nf_tables-add-stubs-for-readonly-expressions/20220311-185613
        git checkout a0cb27794354ccba36b882731b93fdda090f2003
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=m68k SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/netfilter/nft_ct.c:732:27: error: 'nft_ct_set_reduce' undeclared here (not in a function); did you mean 'nft_ct_set_dump'?
     732 |         .reduce         = nft_ct_set_reduce,
         |                           ^~~~~~~~~~~~~~~~~
         |                           nft_ct_set_dump


vim +732 net/netfilter/nft_ct.c

   723	
   724	#ifdef CONFIG_NF_CONNTRACK_ZONES
   725	static const struct nft_expr_ops nft_ct_set_zone_ops = {
   726		.type		= &nft_ct_type,
   727		.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
   728		.eval		= nft_ct_set_zone_eval,
   729		.init		= nft_ct_set_init,
   730		.destroy	= nft_ct_set_destroy,
   731		.dump		= nft_ct_set_dump,
 > 732		.reduce		= nft_ct_set_reduce,
   733	};
   734	#endif
   735	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
