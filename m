Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1D5C77B75
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 May 2023 23:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjECXdm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 May 2023 19:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjECXdl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2023 19:33:41 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44868A6C
        for <netfilter-devel@vger.kernel.org>; Wed,  3 May 2023 16:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683156819; x=1714692819;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZhwOzWMOZxUWGCU3MSVEg7AJ325RqONEXeUlpoYvON8=;
  b=RNWoIJemJTAkoh3tvNQBhcXpycE4VVtOHRqxlPJAa8IKie2h6zPNys83
   aR2sWM0DEMzDSM4XkXfMBqJfg0KaJcGEfohdVrXXlawBhVHwTo+BtSBXv
   gzjBqmc6PDu7KaXGY7ifsYuaNOn9Igy1z1TRoN4bXNJO6lwhXlYA44zTs
   lzSIyGL6eQXTGRNKwy89tkWfQRRb6/r4qoCTZHXNVzgEqMhct8KI294I6
   v8TutbfT2YszN7fUuopMZtdXe1ESZxqFPPT3tdVSfqR71GqfHppAiT+jh
   oWjN+2ToXeSYr8k0fdWj9VDv/D1CbWnji9beQNqzequSUj8iU+tykcDqV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="414254004"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="414254004"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 16:33:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="729559448"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="729559448"
Received: from lkp-server01.sh.intel.com (HELO e3434d64424d) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 03 May 2023 16:33:38 -0700
Received: from kbuild by e3434d64424d with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1puLyb-0002MN-1F;
        Wed, 03 May 2023 23:33:37 +0000
Date:   Thu, 4 May 2023 07:32:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>,
        netfilter-devel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: Re: [PATCH nf-next 15/19] netfilter: nft: add payload application
Message-ID: <202305040734.75NgGlSH-lkp@intel.com>
References: <20230503125552.41113-16-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503125552.41113-16-boris.sukholitko@broadcom.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Boris,

kernel test robot noticed the following build errors:

[auto build test ERROR on shuah-kselftest/next]
[also build test ERROR on shuah-kselftest/fixes linus/master v6.3 next-20230428]
[cannot apply to nf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Boris-Sukholitko/selftest-netfilter-use-proc-for-pid-checking/20230503-205838
base:   https://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git next
patch link:    https://lore.kernel.org/r/20230503125552.41113-16-boris.sukholitko%40broadcom.com
patch subject: [PATCH nf-next 15/19] netfilter: nft: add payload application
config: arm-allmodconfig (https://download.01.org/0day-ci/archive/20230504/202305040734.75NgGlSH-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2dbe43b4daeda03360373d0a4f8ed72efee89a6a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Boris-Sukholitko/selftest-netfilter-use-proc-for-pid-checking/20230503-205838
        git checkout 2dbe43b4daeda03360373d0a4f8ed72efee89a6a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305040734.75NgGlSH-lkp@intel.com/

All errors (new ones prefixed by >>):

   arm-linux-gnueabi-ld: net/netfilter/nft_conntrack_ext.o: in function `nf_flow_offload_apply_payload':
   nft_conntrack_ext.c:(.text+0xa0): undefined reference to `__nf_ct_ext_find'
>> arm-linux-gnueabi-ld: nft_conntrack_ext.c:(.text+0x110): undefined reference to `nft_payload_mangle'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
