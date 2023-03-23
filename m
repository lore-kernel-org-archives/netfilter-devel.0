Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1827C6FD1C
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Mar 2023 04:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjCWELN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Mar 2023 00:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjCWELM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Mar 2023 00:11:12 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CD4131
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2023 21:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679544671; x=1711080671;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FY2v0PUyZSgKwHx2+YcVvWaPld1/QwjpJZBtPe6ujAI=;
  b=iljKyBeklibO+P+5WHI5zzEO37fN0N7icmD1bO2GA7mm92RsOL5hF7+k
   X02m8wLW5gsfgveU+OXXN5MiOvs2kEGTH/C/LZoBBE7BevlLeuJ1d+UjM
   5fo2SoTuepHubqlM7MxT/TX5RPMFGAlPb1maeB9nLMpNIratHmwzeBtPx
   9Pj/mSOxstiZxa2O3087tey1Vea2rjHClph03kV1rZvHlcxjnnKFSqaC2
   dUIoaqjJ0So907mRMmkuTNYdNkqDeNdHHV7etYha7EwZYpEM+GHRKtDVL
   dKS9TrvnA3OuC4YjEh4I8DZVq/JEiiQly1/v2VNNmQKAh7BACo64gSPxY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="339427767"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="339427767"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 21:11:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="632228911"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="632228911"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 22 Mar 2023 21:11:08 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pfCI7-000DwU-2T;
        Thu, 23 Mar 2023 04:11:07 +0000
Date:   Thu, 23 Mar 2023 12:10:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     eric_sage@apple.com, netfilter-devel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, fw@strlen.de, kadlec@netfilter.org,
        pablo@netfilter.org, Eric Sage <eric_sage@apple.com>
Subject: Re: [PATCH] netfilter: nfnetlink_queue: enable classid socket info
 retrieval
Message-ID: <202303231155.PNtozlaS-lkp@intel.com>
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
config: i386-randconfig-a005 (https://download.01.org/0day-ci/archive/20230323/202303231155.PNtozlaS-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/c28410a18b276a059551ce4ffad5d3721ea8cbf5
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review eric_sage-apple-com/netfilter-nfnetlink_queue-enable-classid-socket-info-retrieval/20230323-073405
        git checkout c28410a18b276a059551ce4ffad5d3721ea8cbf5
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303231155.PNtozlaS-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/spinlock.h:304,
                    from include/linux/kref.h:16,
                    from include/linux/mm_types.h:8,
                    from include/linux/buildid.h:5,
                    from include/linux/module.h:14,
                    from net/netfilter/nfnetlink_queue.c:16:
   net/netfilter/nfnetlink_queue.c: In function 'nfqnl_put_sk_classid':
>> net/netfilter/nfnetlink_queue.c:311:24: error: incompatible type for argument 1 of '_raw_read_lock_bh'
     311 |         read_lock_bh(sk->sk_callback_lock);
         |                      ~~^~~~~~~~~~~~~~~~~~
         |                        |
         |                        rwlock_t
   include/linux/rwlock.h:93:59: note: in definition of macro 'read_lock_bh'
      93 | #define read_lock_bh(lock)              _raw_read_lock_bh(lock)
         |                                                           ^~~~
   In file included from include/linux/spinlock_api_smp.h:183,
                    from include/linux/spinlock.h:311,
                    from include/linux/kref.h:16,
                    from include/linux/mm_types.h:8,
                    from include/linux/buildid.h:5,
                    from include/linux/module.h:14,
                    from net/netfilter/nfnetlink_queue.c:16:
   include/linux/rwlock_api_smp.h:21:45: note: expected 'rwlock_t *' but argument is of type 'rwlock_t'
      21 | void __lockfunc _raw_read_lock_bh(rwlock_t *lock)       __acquires(lock);
         |                                   ~~~~~~~~~~^~~~
>> net/netfilter/nfnetlink_queue.c:312:30: error: 'entskb' undeclared (first use in this function)
     312 |         sock_cgroup_classid(&entskb->sk->sk_cgrp_data);
         |                              ^~~~~~
   net/netfilter/nfnetlink_queue.c:312:30: note: each undeclared identifier is reported only once for each function it appears in
   In file included from include/linux/spinlock.h:304,
                    from include/linux/kref.h:16,
                    from include/linux/mm_types.h:8,
                    from include/linux/buildid.h:5,
                    from include/linux/module.h:14,
                    from net/netfilter/nfnetlink_queue.c:16:
>> net/netfilter/nfnetlink_queue.c:315:26: error: incompatible type for argument 1 of '_raw_read_unlock_bh'
     315 |         read_unlock_bh(sk->sk_callback_lock);
         |                        ~~^~~~~~~~~~~~~~~~~~
         |                          |
         |                          rwlock_t
   include/linux/rwlock.h:106:61: note: in definition of macro 'read_unlock_bh'
     106 | #define read_unlock_bh(lock)            _raw_read_unlock_bh(lock)
         |                                                             ^~~~
   In file included from include/linux/spinlock_api_smp.h:183,
                    from include/linux/spinlock.h:311,
                    from include/linux/kref.h:16,
                    from include/linux/mm_types.h:8,
                    from include/linux/buildid.h:5,
                    from include/linux/module.h:14,
                    from net/netfilter/nfnetlink_queue.c:16:
   include/linux/rwlock_api_smp.h:33:47: note: expected 'rwlock_t *' but argument is of type 'rwlock_t'
      33 | void __lockfunc _raw_read_unlock_bh(rwlock_t *lock)     __releases(lock);
         |                                     ~~~~~~~~~~^~~~
   In file included from include/linux/spinlock.h:304,
                    from include/linux/kref.h:16,
                    from include/linux/mm_types.h:8,
                    from include/linux/buildid.h:5,
                    from include/linux/module.h:14,
                    from net/netfilter/nfnetlink_queue.c:16:
   net/netfilter/nfnetlink_queue.c:319:26: error: incompatible type for argument 1 of '_raw_read_unlock_bh'
     319 |         read_unlock_bh(sk->sk_callback_lock);
         |                        ~~^~~~~~~~~~~~~~~~~~
         |                          |
         |                          rwlock_t
   include/linux/rwlock.h:106:61: note: in definition of macro 'read_unlock_bh'
     106 | #define read_unlock_bh(lock)            _raw_read_unlock_bh(lock)
         |                                                             ^~~~
   In file included from include/linux/spinlock_api_smp.h:183,
                    from include/linux/spinlock.h:311,
                    from include/linux/kref.h:16,
                    from include/linux/mm_types.h:8,
                    from include/linux/buildid.h:5,
                    from include/linux/module.h:14,
                    from net/netfilter/nfnetlink_queue.c:16:
   include/linux/rwlock_api_smp.h:33:47: note: expected 'rwlock_t *' but argument is of type 'rwlock_t'
      33 | void __lockfunc _raw_read_unlock_bh(rwlock_t *lock)     __releases(lock);
         |                                     ~~~~~~~~~~^~~~


vim +/_raw_read_lock_bh +311 net/netfilter/nfnetlink_queue.c

   303	
   304	static int nfqnl_put_sk_classid(struct sk_buff *skb, struct sock *sk)
   305	{
   306		u32 classid;
   307	
   308		if (!sk_fullsock(sk))
   309			return 0;
   310	
 > 311		read_lock_bh(sk->sk_callback_lock);
 > 312		sock_cgroup_classid(&entskb->sk->sk_cgrp_data);
   313		if (nla_put_be32(skb, NFQA_CLASSID, htonl(classid)))
   314			goto nla_put_failure;
 > 315		read_unlock_bh(sk->sk_callback_lock);
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
