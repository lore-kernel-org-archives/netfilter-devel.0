Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FEAC77B75
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 May 2023 07:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbjEHHxc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 May 2023 03:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjEHHxb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2023 03:53:31 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F9F1C0FB
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2023 00:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683532408; x=1715068408;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K42rglbh2P9dOhQ5NKOCQoiMe85fJA18dTLB0nz32pY=;
  b=n75Pv9x57/JL4VK4vIL0r0kz53RhY4LA9+QFfKWEruWNKfHgN1a0Wnys
   Qx63fRYl+krMDAivBjA8CPTmECvdS4oygN7tDYD4ze9oUZKT76Ts5akWE
   qS+9Su1G6uv1u8w2eHy/6mXrQASR227Ae2ZJ+DPur6JbAGHQgyeKJofY+
   xEe1GcrHpjH31DaEnZ92tA98PwbS4dKr4FI6OfUZweuM8Szg/33f3MCHp
   tvqUNbzINpzOIbUnr8cBG9sqgNah9+RcHqXV4t7AUXRY2V8Cqaflsk1sS
   W0R3DtyhZAXZHgtrekcWr3pJtRtd6ONXBwgdL/KVfYHTPuvSUBoU7GO8+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="349615660"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="349615660"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 00:53:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="1028328724"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="1028328724"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 08 May 2023 00:53:26 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pvvgT-00017l-29;
        Mon, 08 May 2023 07:53:25 +0000
Date:   Mon, 8 May 2023 15:52:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Patryk Sondej <patryk.sondej@gmail.com>,
        netfilter-devel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, eric_sage@apple.com,
        Patryk Sondej <patryk.sondej@gmail.com>
Subject: Re: [PATCH 2/2] netfilter: nfnetlink_queue: enable cgroup id socket
 info retrieval
Message-ID: <202305081525.uKfLJoAa-lkp@intel.com>
References: <20230508031424.55383-3-patryk.sondej@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508031424.55383-3-patryk.sondej@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Patryk,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.4-rc1 next-20230508]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Patryk-Sondej/netfilter-nfnetlink_log-enable-cgroup-id-socket-info-retrieval/20230508-111728
base:   linus/master
patch link:    https://lore.kernel.org/r/20230508031424.55383-3-patryk.sondej%40gmail.com
patch subject: [PATCH 2/2] netfilter: nfnetlink_queue: enable cgroup id socket info retrieval
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20230508/202305081525.uKfLJoAa-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/275a8dc37e28e6be21d6f429b81f388de1cde7f6
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Patryk-Sondej/netfilter-nfnetlink_log-enable-cgroup-id-socket-info-retrieval/20230508-111728
        git checkout 275a8dc37e28e6be21d6f429b81f388de1cde7f6
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305081525.uKfLJoAa-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/netfilter/nfnetlink_queue.c: In function 'nfqnl_put_sk_cgroupid':
>> net/netfilter/nfnetlink_queue.c:311:42: error: 'inst' undeclared (first use in this function); did you mean 'insl'?
     311 |                 if (cgrp && nla_put_be64(inst->skb, NFQA_CGROUP_ID, cpu_to_be64(cgroup_id(cgrp)), NFQA_PAD))
         |                                          ^~~~
         |                                          insl
   net/netfilter/nfnetlink_queue.c:311:42: note: each undeclared identifier is reported only once for each function it appears in


vim +311 net/netfilter/nfnetlink_queue.c

   305	
   306	static int nfqnl_put_sk_cgroupid(struct sk_buff *skb, struct sock *sk)
   307	{
   308	#if IS_ENABLED(CONFIG_SOCK_CGROUP_DATA)
   309		if (sk && sk_fullsock(sk)) {
   310			struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
 > 311			if (cgrp && nla_put_be64(inst->skb, NFQA_CGROUP_ID, cpu_to_be64(cgroup_id(cgrp)), NFQA_PAD))
   312				return -1;
   313		}
   314	#endif
   315		return 0;
   316	}
   317	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
