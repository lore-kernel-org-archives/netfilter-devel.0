Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2606BC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Mar 2022 10:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbiCNKks (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 06:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234281AbiCNKks (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 06:40:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07FD35264
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2022 03:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647254378; x=1678790378;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r0p9pm3oLKHWsveSIV6tlhiifZD0ElwFW/9g6MXz/7M=;
  b=VWyyCcM91Pm6d42fKUZMxKFdiAFngUnRGmKw0/lpzQR+B6ULx0UKfZ3X
   6MzAgjLyy+YSIxK1PVq0BQJMsFCAolfMw3BiS6h+jtl7LYpo8G1ZfEt5b
   FSfAiJ25imo9zsKIKt3v2JHxOWlHLifLWlmXocVAGQWA/5go0m4AKSjYL
   1TTJPNuDzklsc9QliPfLam4Q0jAB7Hh/Rl6aC/kSFLhGoj29pbFQ4nXxa
   10J1QpUhopoWaRAM36xHhs5uPTMQkJ5Nb8d2aHZDX+6erAAaiS9f2mYvD
   qxMNnvVTWJc3WrPNSRLaHPUBHeiq6QgcqjWgSPbNpwmRxuPJ04EHQfxAB
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10285"; a="255719741"
X-IronPort-AV: E=Sophos;i="5.90,180,1643702400"; 
   d="scan'208";a="255719741"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 03:39:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,180,1643702400"; 
   d="scan'208";a="515372378"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 14 Mar 2022 03:39:37 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nTi6y-0009ne-Km; Mon, 14 Mar 2022 10:39:36 +0000
Date:   Mon, 14 Mar 2022 18:38:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org
Subject: Re: [PATCH nf-next 02/12,v2] netfilter: nf_tables: cancel tracking
 for clobbered destination registers
Message-ID: <202203141859.3tgWL82t-lkp@intel.com>
References: <20220314005417.315832-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314005417.315832-3-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

I love your patch! Perhaps something to improve:

[auto build test WARNING on next-20220310]
[cannot apply to nf-next/master nf/master linus/master v5.17-rc8 v5.17-rc7 v5.17-rc6 v5.17-rc8]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Pablo-Neira-Ayuso/register-tracking-infrastructure-follow-up/20220314-085726
base:    71941773e143369a73c9c4a3b62fbb60736a1182
config: riscv-randconfig-r042-20220314 (https://download.01.org/0day-ci/archive/20220314/202203141859.3tgWL82t-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 3e4950d7fa78ac83f33bbf1658e2f49a73719236)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/0day-ci/linux/commit/33636fda14d7c54d333c939eaac47768c7baf913
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Pablo-Neira-Ayuso/register-tracking-infrastructure-follow-up/20220314-085726
        git checkout 33636fda14d7c54d333c939eaac47768c7baf913
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: vmlinux.o(.data+0x2b2994): Section mismatch in reference from the variable trace_event_fields_rpcgss_need_reencode to the function .init.text:set_reset_devices()
The variable trace_event_fields_rpcgss_need_reencode references
the function __init set_reset_devices()
If the reference is valid then annotate the
variable with or __refdata (see linux/init.h) or name the variable:

--
>> WARNING: modpost: vmlinux.o(.data+0x2940fc): Section mismatch in reference from the variable nft_range_type to the function .init.text:set_reset_devices()
The variable nft_range_type references
the function __init set_reset_devices()
If the reference is valid then annotate the
variable with or __refdata (see linux/init.h) or name the variable:


Note: the below error/warnings can be found in parent commit:
<< WARNING: modpost: vmlinux.o(.text+0x1448bbe): Section mismatch in reference from the function tcp4_proc_exit() to the function .init.text:set_reset_devices()
<< WARNING: modpost: vmlinux.o(.text+0x1448bc2): Section mismatch in reference from the function tcp4_proc_exit() to the variable .init.text:.LBB98_4
<< WARNING: modpost: vmlinux.o(.data+0x2b14a0): Section mismatch in reference from the variable trace_event_fields_rpcgss_ctx_class to the function .exit.text:test_ww_mutex_exit()
<< WARNING: modpost: vmlinux.o(.data+0x2b14b4): Section mismatch in reference from the variable trace_event_fields_rpcgss_ctx_class to the variable .exit.text:.LBB0_1
<< WARNING: modpost: vmlinux.o(.data+0x2b15e8): Section mismatch in reference from the variable event_rpcgss_ctx_init to the function .exit.text:test_ww_mutex_exit()
<< WARNING: modpost: vmlinux.o(.data+0x2b1634): Section mismatch in reference from the variable event_rpcgss_ctx_destroy to the function .exit.text:test_ww_mutex_exit()
<< WARNING: modpost: vmlinux.o(.data+0x2b1660): Section mismatch in reference from the variable trace_event_fields_rpcgss_svc_gssapi_class to the variable .init.text:.LBB1_1
<< WARNING: modpost: vmlinux.o(.data+0x2b168c): Section mismatch in reference from the variable trace_event_fields_rpcgss_svc_gssapi_class to the variable .exit.text:.LBB0_1
<< WARNING: modpost: vmlinux.o(.data+0x2b1690): Section mismatch in reference from the variable trace_event_fields_rpcgss_svc_gssapi_class to the function .init.text:set_reset_devices()
<< WARNING: modpost: vmlinux.o(.data+0x293824): Section mismatch in reference from the variable nf_ct_proto_mutex to the function .init.text:loglevel()
<< WARNING: modpost: vmlinux.o(.text+0x1448bbe): Section mismatch in reference from the function tcp4_proc_exit() to the function .init.text:set_reset_devices()
<< WARNING: modpost: vmlinux.o(.text+0x1448bc2): Section mismatch in reference from the function tcp4_proc_exit() to the variable .init.text:.LBB98_4
<< WARNING: modpost: vmlinux.o(.data+0x2b14a0): Section mismatch in reference from the variable trace_event_fields_rpcgss_ctx_class to the function .exit.text:test_ww_mutex_exit()
<< WARNING: modpost: vmlinux.o(.data+0x2b14b4): Section mismatch in reference from the variable trace_event_fields_rpcgss_ctx_class to the variable .exit.text:.LBB0_1
<< WARNING: modpost: vmlinux.o(.data+0x2b15e8): Section mismatch in reference from the variable event_rpcgss_ctx_init to the function .exit.text:test_ww_mutex_exit()
<< WARNING: modpost: vmlinux.o(.data+0x2b1634): Section mismatch in reference from the variable event_rpcgss_ctx_destroy to the function .exit.text:test_ww_mutex_exit()
<< WARNING: modpost: vmlinux.o(.data+0x2b1660): Section mismatch in reference from the variable trace_event_fields_rpcgss_svc_gssapi_class to the variable .init.text:.LBB1_1
<< WARNING: modpost: vmlinux.o(.data+0x2b168c): Section mismatch in reference from the variable trace_event_fields_rpcgss_svc_gssapi_class to the variable .exit.text:.LBB0_1
<< WARNING: modpost: vmlinux.o(.data+0x2b1690): Section mismatch in reference from the variable trace_event_fields_rpcgss_svc_gssapi_class to the function .init.text:set_reset_devices()
<< WARNING: modpost: vmlinux.o(.data+0x293824): Section mismatch in reference from the variable nf_ct_proto_mutex to the function .init.text:loglevel()

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
