Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DDE3C28D13
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Aug 2022 01:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239018AbiHWBRX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Aug 2022 21:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237907AbiHWBRW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2022 21:17:22 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F0657279
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2022 18:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661217441; x=1692753441;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=irbDdwULTts+VnsVfChGmEHc/uan+ubZUuhXAxQ2mSE=;
  b=GDmDeK3h+At7YkP5Wb+zk3xykFRho4Q1CPmc9o6FqYJ5qOBzWGsnw55v
   Lj5cSOoSE4OJlGuq1CjXyKQb5JizgedGCE3LZ1G+jc9nyZFxKo/wtm4Fy
   LbrSnyRdkNClnB9cYWnL+PUL6T8YyUkki+FbaEiS2I0UQVKTHQcFbl/mU
   0Bgp9CCT+KbU3l8u7pVuMYr7hz6l7KPQ7+K0yrxtdT8XzODOC2SFABgpE
   l7iO/yPeVYflTJ8tQgxCcFYFriODQtD+uKh5KM5kLSjfcFEaxB7cqDLru
   H3mnY8nQFyvoAhz5kuGtrudHBBKKf4PJpU/4fQAfUTihSrfZ7I4ighPaR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="357543214"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="357543214"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 18:17:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="638441942"
Received: from lkp-server01.sh.intel.com (HELO dd9b29378baa) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 22 Aug 2022 18:17:20 -0700
Received: from kbuild by dd9b29378baa with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oQIXf-0000yN-1A;
        Tue, 23 Aug 2022 01:17:19 +0000
Date:   Tue, 23 Aug 2022 09:16:42 +0800
From:   kernel test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: remove NFPROTO_DECNET
Message-ID: <202208230953.khEWYODC-lkp@intel.com>
References: <20220822144121.22026-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822144121.22026-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

I love your patch! Yet something to improve:

[auto build test ERROR on nf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Westphal/netfilter-remove-NFPROTO_DECNET/20220822-224303
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
config: hexagon-randconfig-r041-20220821 (https://download.01.org/0day-ci/archive/20220823/202208230953.khEWYODC-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project abce7acebd4c06c977bc4bd79170697f1122bc5e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0776a7974c60171c4c1322add934ecc73273f538
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Florian-Westphal/netfilter-remove-NFPROTO_DECNET/20220822-224303
        git checkout 0776a7974c60171c4c1322add934ecc73273f538
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/decnet/ net/netfilter/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from net/decnet/af_decnet.c:109:
>> include/linux/netfilter.h:247:7: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           case NFPROTO_DECNET:
                ^~~~~~~~~~~~~~
                NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   1 error generated.
--
   In file included from net/decnet/dn_nsp_in.c:64:
   In file included from include/uapi/linux/netfilter_decnet.h:11:
>> include/linux/netfilter.h:247:7: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           case NFPROTO_DECNET:
                ^~~~~~~~~~~~~~
                NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
>> net/decnet/dn_nsp_in.c:808:17: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           return NF_HOOK(NFPROTO_DECNET, NF_DN_LOCAL_IN,
                          ^~~~~~~~~~~~~~
                          NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   2 errors generated.
--
   In file included from net/decnet/dn_route.c:69:
   In file included from include/uapi/linux/netfilter_decnet.h:11:
>> include/linux/netfilter.h:247:7: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           case NFPROTO_DECNET:
                ^~~~~~~~~~~~~~
                NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
>> net/decnet/dn_route.c:567:17: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           return NF_HOOK(NFPROTO_DECNET, NF_DN_PRE_ROUTING,
                          ^~~~~~~~~~~~~~
                          NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   net/decnet/dn_route.c:595:17: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           return NF_HOOK(NFPROTO_DECNET, NF_DN_PRE_ROUTING,
                          ^~~~~~~~~~~~~~
                          NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   net/decnet/dn_route.c:700:19: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
                           return NF_HOOK(NFPROTO_DECNET, NF_DN_HELLO,
                                          ^~~~~~~~~~~~~~
                                          NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   net/decnet/dn_route.c:706:19: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
                           return NF_HOOK(NFPROTO_DECNET, NF_DN_ROUTE,
                                          ^~~~~~~~~~~~~~
                                          NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   net/decnet/dn_route.c:710:19: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
                           return NF_HOOK(NFPROTO_DECNET, NF_DN_HELLO,
                                          ^~~~~~~~~~~~~~
                                          NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   net/decnet/dn_route.c:715:19: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
                           return NF_HOOK(NFPROTO_DECNET, NF_DN_HELLO,
                                          ^~~~~~~~~~~~~~
                                          NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   net/decnet/dn_route.c:765:17: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           return NF_HOOK(NFPROTO_DECNET, NF_DN_LOCAL_OUT,
                          ^~~~~~~~~~~~~~
                          NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   net/decnet/dn_route.c:812:17: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           return NF_HOOK(NFPROTO_DECNET, NF_DN_FORWARD,
                          ^~~~~~~~~~~~~~
                          NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   9 errors generated.
--
   In file included from net/decnet/dn_neigh.c:37:
   In file included from include/uapi/linux/netfilter_decnet.h:11:
>> include/linux/netfilter.h:247:7: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           case NFPROTO_DECNET:
                ^~~~~~~~~~~~~~
                NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
>> net/decnet/dn_neigh.c:250:17: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
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
   4 errors generated.
--
   In file included from net/netfilter/core.c:10:
>> include/linux/netfilter.h:247:7: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           case NFPROTO_DECNET:
                ^~~~~~~~~~~~~~
                NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
>> net/netfilter/core.c:304:7: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           case NFPROTO_DECNET:
                ^~~~~~~~~~~~~~
                NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   2 errors generated.
--
   In file included from net/decnet/netfilter/dn_rtmsg.c:18:
>> include/linux/netfilter.h:247:7: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           case NFPROTO_DECNET:
                ^~~~~~~~~~~~~~
                NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
>> net/decnet/netfilter/dn_rtmsg.c:118:9: error: use of undeclared identifier 'NFPROTO_DECNET'; did you mean 'NFPROTO_INET'?
           .pf             = NFPROTO_DECNET,
                             ^~~~~~~~~~~~~~
                             NFPROTO_INET
   include/uapi/linux/netfilter.h:60:2: note: 'NFPROTO_INET' declared here
           NFPROTO_INET   =  1,
           ^
   2 errors generated.


vim +247 include/linux/netfilter.h

af4610c39589d8 Florian Westphal  2016-02-25  225  
e3b37f11e6e4e6 Aaron Conole      2016-09-21  226  	rcu_read_lock();
b0f38338aef2da Florian Westphal  2017-12-03  227  	switch (pf) {
b0f38338aef2da Florian Westphal  2017-12-03  228  	case NFPROTO_IPV4:
b0f38338aef2da Florian Westphal  2017-12-03  229  		hook_head = rcu_dereference(net->nf.hooks_ipv4[hook]);
b0f38338aef2da Florian Westphal  2017-12-03  230  		break;
b0f38338aef2da Florian Westphal  2017-12-03  231  	case NFPROTO_IPV6:
b0f38338aef2da Florian Westphal  2017-12-03  232  		hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
b0f38338aef2da Florian Westphal  2017-12-03  233  		break;
b0f38338aef2da Florian Westphal  2017-12-03  234  	case NFPROTO_ARP:
2a95183a5e0375 Florian Westphal  2017-12-07  235  #ifdef CONFIG_NETFILTER_FAMILY_ARP
421c119f558761 Florian Westphal  2018-09-24  236  		if (WARN_ON_ONCE(hook >= ARRAY_SIZE(net->nf.hooks_arp)))
421c119f558761 Florian Westphal  2018-09-24  237  			break;
b0f38338aef2da Florian Westphal  2017-12-03  238  		hook_head = rcu_dereference(net->nf.hooks_arp[hook]);
2a95183a5e0375 Florian Westphal  2017-12-07  239  #endif
b0f38338aef2da Florian Westphal  2017-12-03  240  		break;
b0f38338aef2da Florian Westphal  2017-12-03  241  	case NFPROTO_BRIDGE:
2a95183a5e0375 Florian Westphal  2017-12-07  242  #ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
b0f38338aef2da Florian Westphal  2017-12-03  243  		hook_head = rcu_dereference(net->nf.hooks_bridge[hook]);
2a95183a5e0375 Florian Westphal  2017-12-07  244  #endif
b0f38338aef2da Florian Westphal  2017-12-03  245  		break;
bb4badf3a3dc81 Florian Westphal  2017-12-07  246  #if IS_ENABLED(CONFIG_DECNET)
b0f38338aef2da Florian Westphal  2017-12-03 @247  	case NFPROTO_DECNET:
b0f38338aef2da Florian Westphal  2017-12-03  248  		hook_head = rcu_dereference(net->nf.hooks_decnet[hook]);
b0f38338aef2da Florian Westphal  2017-12-03  249  		break;
bb4badf3a3dc81 Florian Westphal  2017-12-07  250  #endif
b0f38338aef2da Florian Westphal  2017-12-03  251  	default:
b0f38338aef2da Florian Westphal  2017-12-03  252  		WARN_ON_ONCE(1);
b0f38338aef2da Florian Westphal  2017-12-03  253  		break;
b0f38338aef2da Florian Westphal  2017-12-03  254  	}
b0f38338aef2da Florian Westphal  2017-12-03  255  
e3b37f11e6e4e6 Aaron Conole      2016-09-21  256  	if (hook_head) {
107a9f4dc9211c David Miller      2015-04-05  257  		struct nf_hook_state state;
cfdfab314647b1 David S. Miller   2015-04-03  258  
01886bd91f1ba4 Pablo Neira Ayuso 2016-11-03  259  		nf_hook_state_init(&state, hook, pf, indev, outdev,
1610a73c4175e7 Pablo Neira Ayuso 2016-11-03  260  				   sk, net, okfn);
fe72926b792e52 Florian Westphal  2016-09-21  261  
960632ece6949b Aaron Conole      2017-08-24  262  		ret = nf_hook_slow(skb, &state, hook_head, 0);
e3b37f11e6e4e6 Aaron Conole      2016-09-21  263  	}
fe72926b792e52 Florian Westphal  2016-09-21  264  	rcu_read_unlock();
e3b37f11e6e4e6 Aaron Conole      2016-09-21  265  
fe72926b792e52 Florian Westphal  2016-09-21  266  	return ret;
cfdfab314647b1 David S. Miller   2015-04-03  267  }
16a6677fdf1d11 Patrick McHardy   2006-01-06  268  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
