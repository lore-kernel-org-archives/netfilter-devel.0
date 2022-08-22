Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7096C28D13
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Aug 2022 21:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbiHVVXM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Aug 2022 17:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234342AbiHVVXM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2022 17:23:12 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC800520B1
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2022 14:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661203390; x=1692739390;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NsMs6HOYx1nVDbnRLnunVDgEg8kgboPMJBTmT8WkPRQ=;
  b=eS9jTuXKHT0mTvjyJaZmGp3GSZS1vAUvOBgwJR4DbASb3Fjrc4PlgHCG
   I0BfL+HN5GZk16TSsVIyf+TNcbZwym5P54mIuz2EmHiZ+xh2Lfz3q8jQE
   cH0BTb4I6yTIWv7B/Mr2RptULCbkpWQQ4v5AV4eUctCF5uUK49exvzJF/
   faFuadmh4PSvtU4WxYarqqedHAycznh4edbTEf8hDThVM7FrpNQYwDsBj
   pm3uhrkNGic/qdYmyxAf6glH7lZhS3m7abDkmlkHPhPWWA+1eAG0avVJq
   EGWhFjCqxiyoPEIwz04/itnaF1Tkg8nQEg2T6S3AtDlUQoQAEPOL5GDuh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="355253483"
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="355253483"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 14:23:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="638369803"
Received: from lkp-server01.sh.intel.com (HELO dd9b29378baa) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 22 Aug 2022 14:23:09 -0700
Received: from kbuild by dd9b29378baa with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oQEt2-0000jN-1d;
        Mon, 22 Aug 2022 21:23:08 +0000
Date:   Tue, 23 Aug 2022 05:22:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: remove NFPROTO_DECNET
Message-ID: <202208230516.6rswyc5t-lkp@intel.com>
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
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20220823/202208230516.6rswyc5t-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0776a7974c60171c4c1322add934ecc73273f538
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Florian-Westphal/netfilter-remove-NFPROTO_DECNET/20220822-224303
        git checkout 0776a7974c60171c4c1322add934ecc73273f538
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash net/decnet/ net/netfilter/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from net/decnet/af_decnet.c:109:
   include/linux/netfilter.h: In function 'nf_hook':
>> include/linux/netfilter.h:247:14: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     247 |         case NFPROTO_DECNET:
         |              ^~~~~~~~~~~~~~
         |              NFPROTO_INET
   include/linux/netfilter.h:247:14: note: each undeclared identifier is reported only once for each function it appears in
--
   In file included from include/uapi/linux/netfilter_decnet.h:11,
                    from net/decnet/dn_nsp_in.c:64:
   include/linux/netfilter.h: In function 'nf_hook':
>> include/linux/netfilter.h:247:14: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     247 |         case NFPROTO_DECNET:
         |              ^~~~~~~~~~~~~~
         |              NFPROTO_INET
   include/linux/netfilter.h:247:14: note: each undeclared identifier is reported only once for each function it appears in
   net/decnet/dn_nsp_in.c: In function 'dn_nsp_rx':
>> net/decnet/dn_nsp_in.c:808:24: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     808 |         return NF_HOOK(NFPROTO_DECNET, NF_DN_LOCAL_IN,
         |                        ^~~~~~~~~~~~~~
         |                        NFPROTO_INET
   net/decnet/dn_nsp_in.c:811:1: error: control reaches end of non-void function [-Werror=return-type]
     811 | }
         | ^
   cc1: some warnings being treated as errors
--
   In file included from include/uapi/linux/netfilter_decnet.h:11,
                    from net/decnet/dn_route.c:69:
   include/linux/netfilter.h: In function 'nf_hook':
>> include/linux/netfilter.h:247:14: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     247 |         case NFPROTO_DECNET:
         |              ^~~~~~~~~~~~~~
         |              NFPROTO_INET
   include/linux/netfilter.h:247:14: note: each undeclared identifier is reported only once for each function it appears in
   net/decnet/dn_route.c: In function 'dn_route_rx_long':
>> net/decnet/dn_route.c:567:24: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     567 |         return NF_HOOK(NFPROTO_DECNET, NF_DN_PRE_ROUTING,
         |                        ^~~~~~~~~~~~~~
         |                        NFPROTO_INET
   net/decnet/dn_route.c: In function 'dn_route_rx_short':
   net/decnet/dn_route.c:595:24: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     595 |         return NF_HOOK(NFPROTO_DECNET, NF_DN_PRE_ROUTING,
         |                        ^~~~~~~~~~~~~~
         |                        NFPROTO_INET
   net/decnet/dn_route.c: In function 'dn_route_rcv':
   net/decnet/dn_route.c:700:40: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     700 |                         return NF_HOOK(NFPROTO_DECNET, NF_DN_HELLO,
         |                                        ^~~~~~~~~~~~~~
         |                                        NFPROTO_INET
   net/decnet/dn_route.c: In function 'dn_output':
   net/decnet/dn_route.c:765:24: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     765 |         return NF_HOOK(NFPROTO_DECNET, NF_DN_LOCAL_OUT,
         |                        ^~~~~~~~~~~~~~
         |                        NFPROTO_INET
   net/decnet/dn_route.c: In function 'dn_forward':
   net/decnet/dn_route.c:812:24: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     812 |         return NF_HOOK(NFPROTO_DECNET, NF_DN_FORWARD,
         |                        ^~~~~~~~~~~~~~
         |                        NFPROTO_INET
--
   In file included from include/uapi/linux/netfilter_decnet.h:11,
                    from net/decnet/dn_neigh.c:37:
   include/linux/netfilter.h: In function 'nf_hook':
>> include/linux/netfilter.h:247:14: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     247 |         case NFPROTO_DECNET:
         |              ^~~~~~~~~~~~~~
         |              NFPROTO_INET
   include/linux/netfilter.h:247:14: note: each undeclared identifier is reported only once for each function it appears in
   net/decnet/dn_neigh.c: In function 'dn_long_output':
>> net/decnet/dn_neigh.c:250:24: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     250 |         return NF_HOOK(NFPROTO_DECNET, NF_DN_POST_ROUTING,
         |                        ^~~~~~~~~~~~~~
         |                        NFPROTO_INET
   net/decnet/dn_neigh.c: In function 'dn_short_output':
   net/decnet/dn_neigh.c:291:24: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     291 |         return NF_HOOK(NFPROTO_DECNET, NF_DN_POST_ROUTING,
         |                        ^~~~~~~~~~~~~~
         |                        NFPROTO_INET
   net/decnet/dn_neigh.c: In function 'dn_phase3_output':
   net/decnet/dn_neigh.c:333:24: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     333 |         return NF_HOOK(NFPROTO_DECNET, NF_DN_POST_ROUTING,
         |                        ^~~~~~~~~~~~~~
         |                        NFPROTO_INET
   net/decnet/dn_neigh.c:336:1: error: control reaches end of non-void function [-Werror=return-type]
     336 | }
         | ^
   net/decnet/dn_neigh.c: In function 'dn_long_output':
   net/decnet/dn_neigh.c:253:1: error: control reaches end of non-void function [-Werror=return-type]
     253 | }
         | ^
   net/decnet/dn_neigh.c: In function 'dn_short_output':
   net/decnet/dn_neigh.c:294:1: error: control reaches end of non-void function [-Werror=return-type]
     294 | }
         | ^
   cc1: some warnings being treated as errors
--
   In file included from net/netfilter/core.c:10:
   include/linux/netfilter.h: In function 'nf_hook':
>> include/linux/netfilter.h:247:14: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     247 |         case NFPROTO_DECNET:
         |              ^~~~~~~~~~~~~~
         |              NFPROTO_INET
   include/linux/netfilter.h:247:14: note: each undeclared identifier is reported only once for each function it appears in
   net/netfilter/core.c: In function 'nf_hook_entry_head':
>> net/netfilter/core.c:304:14: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     304 |         case NFPROTO_DECNET:
         |              ^~~~~~~~~~~~~~
         |              NFPROTO_INET
--
   In file included from net/netfilter/nfnetlink_hook.c:17:
   include/linux/netfilter.h: In function 'nf_hook':
>> include/linux/netfilter.h:247:14: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     247 |         case NFPROTO_DECNET:
         |              ^~~~~~~~~~~~~~
         |              NFPROTO_INET
   include/linux/netfilter.h:247:14: note: each undeclared identifier is reported only once for each function it appears in
   net/netfilter/nfnetlink_hook.c: In function 'nfnl_hook_entries_head':
>> net/netfilter/nfnetlink_hook.c:219:14: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     219 |         case NFPROTO_DECNET:
         |              ^~~~~~~~~~~~~~
         |              NFPROTO_INET
--
   In file included from net/decnet/netfilter/dn_rtmsg.c:18:
   include/linux/netfilter.h: In function 'nf_hook':
>> include/linux/netfilter.h:247:14: error: 'NFPROTO_DECNET' undeclared (first use in this function); did you mean 'NFPROTO_INET'?
     247 |         case NFPROTO_DECNET:
         |              ^~~~~~~~~~~~~~
         |              NFPROTO_INET
   include/linux/netfilter.h:247:14: note: each undeclared identifier is reported only once for each function it appears in
   net/decnet/netfilter/dn_rtmsg.c: At top level:
>> net/decnet/netfilter/dn_rtmsg.c:118:27: error: 'NFPROTO_DECNET' undeclared here (not in a function); did you mean 'NFPROTO_INET'?
     118 |         .pf             = NFPROTO_DECNET,
         |                           ^~~~~~~~~~~~~~
         |                           NFPROTO_INET


vim +247 include/linux/netfilter.h

af4610c39589d83 Florian Westphal  2016-02-25  225  
e3b37f11e6e4e6b Aaron Conole      2016-09-21  226  	rcu_read_lock();
b0f38338aef2dae Florian Westphal  2017-12-03  227  	switch (pf) {
b0f38338aef2dae Florian Westphal  2017-12-03  228  	case NFPROTO_IPV4:
b0f38338aef2dae Florian Westphal  2017-12-03  229  		hook_head = rcu_dereference(net->nf.hooks_ipv4[hook]);
b0f38338aef2dae Florian Westphal  2017-12-03  230  		break;
b0f38338aef2dae Florian Westphal  2017-12-03  231  	case NFPROTO_IPV6:
b0f38338aef2dae Florian Westphal  2017-12-03  232  		hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
b0f38338aef2dae Florian Westphal  2017-12-03  233  		break;
b0f38338aef2dae Florian Westphal  2017-12-03  234  	case NFPROTO_ARP:
2a95183a5e0375d Florian Westphal  2017-12-07  235  #ifdef CONFIG_NETFILTER_FAMILY_ARP
421c119f5587615 Florian Westphal  2018-09-24  236  		if (WARN_ON_ONCE(hook >= ARRAY_SIZE(net->nf.hooks_arp)))
421c119f5587615 Florian Westphal  2018-09-24  237  			break;
b0f38338aef2dae Florian Westphal  2017-12-03  238  		hook_head = rcu_dereference(net->nf.hooks_arp[hook]);
2a95183a5e0375d Florian Westphal  2017-12-07  239  #endif
b0f38338aef2dae Florian Westphal  2017-12-03  240  		break;
b0f38338aef2dae Florian Westphal  2017-12-03  241  	case NFPROTO_BRIDGE:
2a95183a5e0375d Florian Westphal  2017-12-07  242  #ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
b0f38338aef2dae Florian Westphal  2017-12-03  243  		hook_head = rcu_dereference(net->nf.hooks_bridge[hook]);
2a95183a5e0375d Florian Westphal  2017-12-07  244  #endif
b0f38338aef2dae Florian Westphal  2017-12-03  245  		break;
bb4badf3a3dc811 Florian Westphal  2017-12-07  246  #if IS_ENABLED(CONFIG_DECNET)
b0f38338aef2dae Florian Westphal  2017-12-03 @247  	case NFPROTO_DECNET:
b0f38338aef2dae Florian Westphal  2017-12-03  248  		hook_head = rcu_dereference(net->nf.hooks_decnet[hook]);
b0f38338aef2dae Florian Westphal  2017-12-03  249  		break;
bb4badf3a3dc811 Florian Westphal  2017-12-07  250  #endif
b0f38338aef2dae Florian Westphal  2017-12-03  251  	default:
b0f38338aef2dae Florian Westphal  2017-12-03  252  		WARN_ON_ONCE(1);
b0f38338aef2dae Florian Westphal  2017-12-03  253  		break;
b0f38338aef2dae Florian Westphal  2017-12-03  254  	}
b0f38338aef2dae Florian Westphal  2017-12-03  255  
e3b37f11e6e4e6b Aaron Conole      2016-09-21  256  	if (hook_head) {
107a9f4dc9211c1 David Miller      2015-04-05  257  		struct nf_hook_state state;
cfdfab314647b17 David S. Miller   2015-04-03  258  
01886bd91f1ba41 Pablo Neira Ayuso 2016-11-03  259  		nf_hook_state_init(&state, hook, pf, indev, outdev,
1610a73c4175e7d Pablo Neira Ayuso 2016-11-03  260  				   sk, net, okfn);
fe72926b792e52a Florian Westphal  2016-09-21  261  
960632ece6949be Aaron Conole      2017-08-24  262  		ret = nf_hook_slow(skb, &state, hook_head, 0);
e3b37f11e6e4e6b Aaron Conole      2016-09-21  263  	}
fe72926b792e52a Florian Westphal  2016-09-21  264  	rcu_read_unlock();
e3b37f11e6e4e6b Aaron Conole      2016-09-21  265  
fe72926b792e52a Florian Westphal  2016-09-21  266  	return ret;
cfdfab314647b17 David S. Miller   2015-04-03  267  }
16a6677fdf1d119 Patrick McHardy   2006-01-06  268  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
