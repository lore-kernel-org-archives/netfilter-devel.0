Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC5DC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Mar 2022 07:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbiCNHhq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 03:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236733AbiCNHhl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 03:37:41 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE7A40E51
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2022 00:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647243391; x=1678779391;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8WH2UbYG0ReXKv7c6v0ene8EGu8uj68lyZsd6Zr7ZWo=;
  b=eq57qN7gmb7Se+5LGduNoFC/Ka8rI7SmdUG4M8EOME/JRIBNG5izkgiz
   4HdTpps58n5gNM58+m0l4e8YWo+lR/HWVAdio0jS5sn6tKdSJxBvqKSRS
   7E0DZFRQu+Fm97HhQeC/3pNoN2WGie8q+vUt+KDwpFlRAYR1FiRE+kWET
   h12jcWkYHS7beFxqrA1R4N4klU2WMXo1pF2DiND6TLWQ5fwgORokgimR0
   w1VvJ1k1nijnI52Rwo9VCeCkamWr6nfSiUlB0pS7gDPq906R6nfXZrcVS
   DZJ2m8J3Kamuq1v6TS2HuZfUOMbTOWYKjFeyIYsjzzW+tS2vGQ0Yyrbkw
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10285"; a="254788465"
X-IronPort-AV: E=Sophos;i="5.90,180,1643702400"; 
   d="scan'208";a="254788465"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 00:36:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,180,1643702400"; 
   d="scan'208";a="645690610"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 14 Mar 2022 00:36:14 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nTfFV-0009hD-Fy; Mon, 14 Mar 2022 07:36:13 +0000
Date:   Mon, 14 Mar 2022 15:35:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org
Subject: Re: [PATCH nf-next 01/12,v2] netfilter: nf_tables: do not reduce
 read-only expressions
Message-ID: <202203141536.2pRQaVTk-lkp@intel.com>
References: <20220314005417.315832-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314005417.315832-2-pablo@netfilter.org>
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
config: riscv-randconfig-r042-20220314 (https://download.01.org/0day-ci/archive/20220314/202203141536.2pRQaVTk-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 3e4950d7fa78ac83f33bbf1658e2f49a73719236)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/0day-ci/linux/commit/95cc95fe1fe4ea0141d13453b818a3f14aacf4f0
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Pablo-Neira-Ayuso/register-tracking-infrastructure-follow-up/20220314-085726
        git checkout 95cc95fe1fe4ea0141d13453b818a3f14aacf4f0
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: vmlinux.o(.data+0x2b2500): Section mismatch in reference from the variable trace_event_fields_rpcgss_svc_authenticate to the function .init.text:set_reset_devices()
The variable trace_event_fields_rpcgss_svc_authenticate references
the function __init set_reset_devices()
If the reference is valid then annotate the
variable with or __refdata (see linux/init.h) or name the variable:


Note: the below error/warnings can be found in parent commit:
<< WARNING: modpost: vmlinux.o(.text+0x1448baa): Section mismatch in reference from the function tcp4_proc_exit() to the function .init.text:set_reset_devices()
<< WARNING: modpost: vmlinux.o(.data+0x2b15cc): Section mismatch in reference from the variable event_rpcgss_ctx_init to the function .exit.text:test_ww_mutex_exit()
<< WARNING: modpost: vmlinux.o(.data+0x2b15ec): Section mismatch in reference from the variable event_rpcgss_ctx_init to the variable .exit.text:.LBB0_1
<< WARNING: modpost: vmlinux.o(.data+0x2b1618): Section mismatch in reference from the variable event_rpcgss_ctx_destroy to the function .exit.text:test_ww_mutex_exit()
<< WARNING: modpost: vmlinux.o(.data+0x2b1638): Section mismatch in reference from the variable event_rpcgss_ctx_destroy to the variable .exit.text:.LBB0_1
<< WARNING: modpost: vmlinux.o(.data+0x2b1660): Section mismatch in reference from the variable trace_event_fields_rpcgss_svc_gssapi_class to the function .exit.text:test_ww_mutex_exit()
<< WARNING: modpost: vmlinux.o(.data+0x2b1690): Section mismatch in reference from the variable trace_event_fields_rpcgss_svc_gssapi_class to the function .init.text:init_nls_cp737()
<< WARNING: modpost: vmlinux.o(.data+0x2b1be8): Section mismatch in reference from the variable event_rpcgss_svc_unwrap to the function .init.text:set_reset_devices()
<< WARNING: modpost: vmlinux.o(.data+0x293824): Section mismatch in reference from the variable nf_ct_proto_mutex to the function .init.text:loglevel()
<< WARNING: modpost: vmlinux.o(.data+0x2b1c08): Section mismatch in reference from the variable event_rpcgss_svc_unwrap to the variable .init.text:.LBB1_1

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
