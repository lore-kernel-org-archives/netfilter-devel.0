Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D63C6C32772
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Aug 2022 13:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240447AbiHWNF5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Aug 2022 09:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242860AbiHWNFc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Aug 2022 09:05:32 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26F512E25F
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2022 03:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661249271; x=1692785271;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R3fk2LXJj3qtn40DbYaVUYor64b/ys7w638UXb2s/AY=;
  b=XOq+jfNLOU0LK7GsSorXlmoG7WFkWQMSuZiwQJc5tq34bK2BLZRp2AxX
   4clWuX+EJxhQho7r3u5iab34erHxJ9Tyrah8t8pt211I0SADwkB3KSWTF
   vjKUN36r0xdU2JA4np92hbPQjxjhF14xBT3BusE2emNJkp1uPdB1CQg3f
   WSuzAt3RKoBqyBEmvs8Mnajdr6pg54wSJVqKUMd36FnLngBDuiUqfWU6T
   yH8VTWSkvzQywhX66gUmEdaOoIC0kE+5yHulVORAfhdjvOHaBPSoau1vY
   Z57FTlj8ZSE0NPHGzP7J7184AzXWAvNhVJmwEBg7yLUk9mREZYAjY0o6b
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="293645073"
X-IronPort-AV: E=Sophos;i="5.93,257,1654585200"; 
   d="scan'208";a="293645073"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 03:06:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,257,1654585200"; 
   d="scan'208";a="642389190"
Received: from lkp-server02.sh.intel.com (HELO 9bbcefcddf9f) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 23 Aug 2022 03:06:48 -0700
Received: from kbuild by 9bbcefcddf9f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oQQo3-00008D-1I;
        Tue, 23 Aug 2022 10:06:47 +0000
Date:   Tue, 23 Aug 2022 18:06:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: remove NFPROTO_DECNET
Message-ID: <202208231725.M6uhYNZi-lkp@intel.com>
References: <20220822144121.22026-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822144121.22026-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

I love your patch! Perhaps something to improve:

[auto build test WARNING on nf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Westphal/netfilter-remove-NFPROTO_DECNET/20220822-224303
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
config: mips-randconfig-r014-20220822 (https://download.01.org/0day-ci/archive/20220823/202208231725.M6uhYNZi-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project b04d01c009d7f66bcca9138d2ce40999eedf104d)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install mips cross compiling tool for clang build
        # apt-get install binutils-mips-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/0776a7974c60171c4c1322add934ecc73273f538
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Florian-Westphal/netfilter-remove-NFPROTO_DECNET/20220822-224303
        git checkout 0776a7974c60171c4c1322add934ecc73273f538
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash net/decnet/ net/netfilter/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from net/decnet/af_decnet.c:109:
   include/linux/netfilter.h:247:7: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           case NFPROTO_DECNET:
                ^~~~~~~~~~~~~~
                NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   In file included from net/decnet/af_decnet.c:111:
   In file included from include/net/sock.h:60:
>> include/linux/poll.h:140:27: warning: division by zero is undefined [-Wdivision-by-zero]
                   M(RDNORM) | M(RDBAND) | M(WRNORM) | M(WRBAND) |
                                           ^~~~~~~~~
   include/linux/poll.h:138:32: note: expanded from macro 'M'
   #define M(X) (__force __poll_t)__MAP(val, POLL##X, (__force __u16)EPOLL##X)
                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/poll.h:124:51: note: expanded from macro '__MAP'
           (from < to ? (v & from) * (to/from) : (v & from) / (from/to))
                                                            ^ ~~~~~~~~~
   include/linux/poll.h:140:39: warning: division by zero is undefined [-Wdivision-by-zero]
                   M(RDNORM) | M(RDBAND) | M(WRNORM) | M(WRBAND) |
                                                       ^~~~~~~~~
   include/linux/poll.h:138:32: note: expanded from macro 'M'
   #define M(X) (__force __poll_t)__MAP(val, POLL##X, (__force __u16)EPOLL##X)
                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/poll.h:124:51: note: expanded from macro '__MAP'
           (from < to ? (v & from) * (to/from) : (v & from) / (from/to))
                                                            ^ ~~~~~~~~~
   2 warnings and 1 error generated.
--
   In file included from net/decnet/dn_neigh.c:37:
   In file included from include/uapi/linux/netfilter_decnet.h:11:
   include/linux/netfilter.h:247:7: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           case NFPROTO_DECNET:
                ^~~~~~~~~~~~~~
                NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   In file included from net/decnet/dn_neigh.c:47:
   In file included from include/net/dn.h:6:
   In file included from include/net/sock.h:60:
>> include/linux/poll.h:140:27: warning: division by zero is undefined [-Wdivision-by-zero]
                   M(RDNORM) | M(RDBAND) | M(WRNORM) | M(WRBAND) |
                                           ^~~~~~~~~
   include/linux/poll.h:138:32: note: expanded from macro 'M'
   #define M(X) (__force __poll_t)__MAP(val, POLL##X, (__force __u16)EPOLL##X)
                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/poll.h:124:51: note: expanded from macro '__MAP'
           (from < to ? (v & from) * (to/from) : (v & from) / (from/to))
                                                            ^ ~~~~~~~~~
   include/linux/poll.h:140:39: warning: division by zero is undefined [-Wdivision-by-zero]
                   M(RDNORM) | M(RDBAND) | M(WRNORM) | M(WRBAND) |
                                                       ^~~~~~~~~
   include/linux/poll.h:138:32: note: expanded from macro 'M'
   #define M(X) (__force __poll_t)__MAP(val, POLL##X, (__force __u16)EPOLL##X)
                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/poll.h:124:51: note: expanded from macro '__MAP'
           (from < to ? (v & from) * (to/from) : (v & from) / (from/to))
                                                            ^ ~~~~~~~~~
   net/decnet/dn_neigh.c:250:17: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           return NF_HOOK(NFPROTO_DECNET, NF_DN_POST_ROUTING,
                          ^~~~~~~~~~~~~~
                          NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   net/decnet/dn_neigh.c:291:17: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           return NF_HOOK(NFPROTO_DECNET, NF_DN_POST_ROUTING,
                          ^~~~~~~~~~~~~~
                          NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   net/decnet/dn_neigh.c:333:17: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           return NF_HOOK(NFPROTO_DECNET, NF_DN_POST_ROUTING,
                          ^~~~~~~~~~~~~~
                          NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   2 warnings and 4 errors generated.
--
   In file included from net/netfilter/core.c:10:
   include/linux/netfilter.h:247:7: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           case NFPROTO_DECNET:
                ^~~~~~~~~~~~~~
                NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   In file included from net/netfilter/core.c:19:
   In file included from include/linux/netfilter_ipv6.h:11:
   In file included from include/net/tcp.h:20:
   In file included from include/linux/tcp.h:19:
   In file included from include/net/sock.h:60:
>> include/linux/poll.h:140:27: warning: division by zero is undefined [-Wdivision-by-zero]
                   M(RDNORM) | M(RDBAND) | M(WRNORM) | M(WRBAND) |
                                           ^~~~~~~~~
   include/linux/poll.h:138:32: note: expanded from macro 'M'
   #define M(X) (__force __poll_t)__MAP(val, POLL##X, (__force __u16)EPOLL##X)
                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/poll.h:124:51: note: expanded from macro '__MAP'
           (from < to ? (v & from) * (to/from) : (v & from) / (from/to))
                                                            ^ ~~~~~~~~~
   include/linux/poll.h:140:39: warning: division by zero is undefined [-Wdivision-by-zero]
                   M(RDNORM) | M(RDBAND) | M(WRNORM) | M(WRBAND) |
                                                       ^~~~~~~~~
   include/linux/poll.h:138:32: note: expanded from macro 'M'
   #define M(X) (__force __poll_t)__MAP(val, POLL##X, (__force __u16)EPOLL##X)
                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/poll.h:124:51: note: expanded from macro '__MAP'
           (from < to ? (v & from) * (to/from) : (v & from) / (from/to))
                                                            ^ ~~~~~~~~~
   net/netfilter/core.c:304:7: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           case NFPROTO_DECNET:
                ^~~~~~~~~~~~~~
                NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   2 warnings and 2 errors generated.
--
   In file included from net/decnet/netfilter/dn_rtmsg.c:18:
   include/linux/netfilter.h:247:7: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           case NFPROTO_DECNET:
                ^~~~~~~~~~~~~~
                NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   In file included from net/decnet/netfilter/dn_rtmsg.c:23:
   In file included from include/net/sock.h:60:
>> include/linux/poll.h:140:27: warning: division by zero is undefined [-Wdivision-by-zero]
                   M(RDNORM) | M(RDBAND) | M(WRNORM) | M(WRBAND) |
                                           ^~~~~~~~~
   include/linux/poll.h:138:32: note: expanded from macro 'M'
   #define M(X) (__force __poll_t)__MAP(val, POLL##X, (__force __u16)EPOLL##X)
                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/poll.h:124:51: note: expanded from macro '__MAP'
           (from < to ? (v & from) * (to/from) : (v & from) / (from/to))
                                                            ^ ~~~~~~~~~
   include/linux/poll.h:140:39: warning: division by zero is undefined [-Wdivision-by-zero]
                   M(RDNORM) | M(RDBAND) | M(WRNORM) | M(WRBAND) |
                                                       ^~~~~~~~~
   include/linux/poll.h:138:32: note: expanded from macro 'M'
   #define M(X) (__force __poll_t)__MAP(val, POLL##X, (__force __u16)EPOLL##X)
                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/poll.h:124:51: note: expanded from macro '__MAP'
           (from < to ? (v & from) * (to/from) : (v & from) / (from/to))
                                                            ^ ~~~~~~~~~
   net/decnet/netfilter/dn_rtmsg.c:118:9: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           .pf             = NFPROTO_DECNET,
                             ^~~~~~~~~~~~~~
                             NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   2 warnings and 2 errors generated.


vim +140 include/linux/poll.h

7a163b2195cda0 Al Viro 2018-02-01  135  
7a163b2195cda0 Al Viro 2018-02-01  136  static inline __poll_t demangle_poll(u16 val)
7a163b2195cda0 Al Viro 2018-02-01  137  {
7a163b2195cda0 Al Viro 2018-02-01  138  #define M(X) (__force __poll_t)__MAP(val, POLL##X, (__force __u16)EPOLL##X)
7a163b2195cda0 Al Viro 2018-02-01  139  	return M(IN) | M(OUT) | M(PRI) | M(ERR) | M(NVAL) |
7a163b2195cda0 Al Viro 2018-02-01 @140  		M(RDNORM) | M(RDBAND) | M(WRNORM) | M(WRBAND) |
7a163b2195cda0 Al Viro 2018-02-01  141  		M(HUP) | M(RDHUP) | M(MSG);
7a163b2195cda0 Al Viro 2018-02-01  142  #undef M
7a163b2195cda0 Al Viro 2018-02-01  143  }
7a163b2195cda0 Al Viro 2018-02-01  144  #undef __MAP
7a163b2195cda0 Al Viro 2018-02-01  145  
7a163b2195cda0 Al Viro 2018-02-01  146  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
