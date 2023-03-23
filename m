Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77664C6FD1D
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Mar 2023 04:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjCWEcO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Mar 2023 00:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCWEcN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Mar 2023 00:32:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F70119B1
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2023 21:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679545932; x=1711081932;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=U8U3GK4R9Q3qgYMxyxvTCgVa/ZyTh3hAM8Jyj6bjRGI=;
  b=GeFgLpY5HwWPNjLtwDhHLH8KNmT7Tr/H9slDe/mjGhSHuJ/0NwhfXDde
   q4xU1K70tUwv5yWjhqQSGPEKqb+BXNzVdRLmmWII3XBP3GMZs5naeXk5y
   S5TaS+EJH11DPIPWhpzeOPRaMPZlbtlTTTRyE/otYZNYwUtup3H39vD1Q
   Ng/b6uuSCSUGQe9G5yhrr4jm4pzzyDXut730vdPu2aSpMnZlA1rdKr+sD
   Xfz8XdJ1eQ68W9QoAC/Ol6EjoxmUXicq8zAg/XZ/q/9a0J8YoaaEhA1wq
   rmzFQGrLEH+wUFROpcYVGrAYP22Z/PpWb0Y8RChqc4xvoV/E9p/Phf3dU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="425676490"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="425676490"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 21:32:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="675555097"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="675555097"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 22 Mar 2023 21:32:09 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pfCcS-000Dxg-1g;
        Thu, 23 Mar 2023 04:32:08 +0000
Date:   Thu, 23 Mar 2023 12:31:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     eric_sage@apple.com, netfilter-devel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, fw@strlen.de, kadlec@netfilter.org,
        pablo@netfilter.org, Eric Sage <eric_sage@apple.com>
Subject: Re: [PATCH] netfilter: nfnetlink_queue: enable classid socket info
 retrieval
Message-ID: <202303231242.QaYElp9P-lkp@intel.com>
References: <20230322223329.48949-1-eric_sage@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322223329.48949-1-eric_sage@apple.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on horms-ipvs/master]
[also build test ERROR on linus/master v6.3-rc3 next-20230322]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/eric_sage-apple-com/netfilter-nfnetlink_queue-enable-classid-socket-info-retrieval/20230323-073405
base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git master
patch link:    https://lore.kernel.org/r/20230322223329.48949-1-eric_sage%40apple.com
patch subject: [PATCH] netfilter: nfnetlink_queue: enable classid socket info retrieval
config: m68k-defconfig (https://download.01.org/0day-ci/archive/20230323/202303231242.QaYElp9P-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/c28410a18b276a059551ce4ffad5d3721ea8cbf5
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review eric_sage-apple-com/netfilter-nfnetlink_queue-enable-classid-socket-info-retrieval/20230323-073405
        git checkout c28410a18b276a059551ce4ffad5d3721ea8cbf5
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303231242.QaYElp9P-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/netfilter/nfnetlink_queue.c: In function 'nfqnl_put_sk_classid':
>> net/netfilter/nfnetlink_queue.c:312:9: error: implicit declaration of function 'sock_cgroup_classid' [-Werror=implicit-function-declaration]
     312 |         sock_cgroup_classid(&entskb->sk->sk_cgrp_data);
         |         ^~~~~~~~~~~~~~~~~~~
   net/netfilter/nfnetlink_queue.c:312:30: error: 'entskb' undeclared (first use in this function)
     312 |         sock_cgroup_classid(&entskb->sk->sk_cgrp_data);
         |                              ^~~~~~
   net/netfilter/nfnetlink_queue.c:312:30: note: each undeclared identifier is reported only once for each function it appears in
   cc1: some warnings being treated as errors


vim +/sock_cgroup_classid +312 net/netfilter/nfnetlink_queue.c

   303	
   304	static int nfqnl_put_sk_classid(struct sk_buff *skb, struct sock *sk)
   305	{
   306		u32 classid;
   307	
   308		if (!sk_fullsock(sk))
   309			return 0;
   310	
   311		read_lock_bh(sk->sk_callback_lock);
 > 312		sock_cgroup_classid(&entskb->sk->sk_cgrp_data);
   313		if (nla_put_be32(skb, NFQA_CLASSID, htonl(classid)))
   314			goto nla_put_failure;
   315		read_unlock_bh(sk->sk_callback_lock);
   316		return 0;
   317	
   318	nla_put_failure:
   319		read_unlock_bh(sk->sk_callback_lock);
   320		return -1;
   321	}
   322	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
