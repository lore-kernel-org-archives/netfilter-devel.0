Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739F3C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Dec 2021 23:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhLPXtc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 18:49:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:5297 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhLPXtb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 18:49:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639698571; x=1671234571;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZqOQad8ijOnESgkxHixcz4BprEm777kirwRvPk7K25g=;
  b=eqrJp79ogI2KvM7HlBMDayazhXjf6xWa8WYNratxDyMKtAWkrEF3oLsb
   Pffn5YBUybGARn2yfOwIl/VzGSFjeGM9bhvUVu+L/3w+yTu3qx86JzPzl
   ARibdfgBm/yoVIquH38X+SQ50g4MGUyFsakHHXUmp7RzoynJPk5ucI8do
   ig0AVqAkY1RuGIRVfCx+1eEOWi/ipdECQKaqBMnWuUImkDCIivDbOmMyf
   12J6r/Ra91BTu7Wt5SX1zKeSMZ5JV+3RnMW7Gc7nWx/U/T3nV5WyiFXyG
   FdCySNxCivTwO3knvJmTqe9gnzorZR43DTcNT6g0p87nugZF12juLIDbb
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="237173632"
X-IronPort-AV: E=Sophos;i="5.88,212,1635231600"; 
   d="scan'208";a="237173632"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 15:49:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,212,1635231600"; 
   d="scan'208";a="506545809"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 16 Dec 2021 15:49:29 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1my0V7-0003y0-05; Thu, 16 Dec 2021 23:49:29 +0000
Date:   Fri, 17 Dec 2021 07:48:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Florian Westphal <fw@strlen.de>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf v3] netfilter: nat: force port remap to prevent
 shadowing well-known ports
Message-ID: <202112170757.knetsZWh-lkp@intel.com>
References: <20211216152816.1481-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216152816.1481-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

I love your patch! Yet something to improve:

[auto build test ERROR on nf/master]

url:    https://github.com/0day-ci/linux/commits/Florian-Westphal/netfilter-nat-force-port-remap-to-prevent-shadowing-well-known-ports/20211216-232930
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git master
config: arm-randconfig-r005-20211216 (https://download.01.org/0day-ci/archive/20211217/202112170757.knetsZWh-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project dd245bab9fbb364faa1581e4f92ba3119a872fba)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/0day-ci/linux/commit/cc216934b951862fcd3ea10c9bef2eecd84d8e6f
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Florian-Westphal/netfilter-nat-force-port-remap-to-prevent-shadowing-well-known-ports/20211216-232930
        git checkout cc216934b951862fcd3ea10c9bef2eecd84d8e6f
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/netfilter/nf_nat_core.c:550:11: error: no member named 'local_origin' in 'struct nf_conn'
               !ct->local_origin)
                ~~  ^
   1 error generated.


vim +550 net/netfilter/nf_nat_core.c

   528	
   529	/* Manipulate the tuple into the range given. For NF_INET_POST_ROUTING,
   530	 * we change the source to map into the range. For NF_INET_PRE_ROUTING
   531	 * and NF_INET_LOCAL_OUT, we change the destination to map into the
   532	 * range. It might not be possible to get a unique tuple, but we try.
   533	 * At worst (or if we race), we will end up with a final duplicate in
   534	 * __nf_conntrack_confirm and drop the packet. */
   535	static void
   536	get_unique_tuple(struct nf_conntrack_tuple *tuple,
   537			 const struct nf_conntrack_tuple *orig_tuple,
   538			 const struct nf_nat_range2 *range,
   539			 struct nf_conn *ct,
   540			 enum nf_nat_manip_type maniptype)
   541	{
   542		bool random_port = range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL;
   543		const struct nf_conntrack_zone *zone;
   544		struct net *net = nf_ct_net(ct);
   545	
   546		zone = nf_ct_zone(ct);
   547	
   548		if (maniptype == NF_NAT_MANIP_SRC &&
   549		    !random_port &&
 > 550		    !ct->local_origin)
   551			random_port = tuple_force_port_remap(orig_tuple);
   552	
   553		/* 1) If this srcip/proto/src-proto-part is currently mapped,
   554		 * and that same mapping gives a unique tuple within the given
   555		 * range, use that.
   556		 *
   557		 * This is only required for source (ie. NAT/masq) mappings.
   558		 * So far, we don't do local source mappings, so multiple
   559		 * manips not an issue.
   560		 */
   561		if (maniptype == NF_NAT_MANIP_SRC && !random_port) {
   562			/* try the original tuple first */
   563			if (in_range(orig_tuple, range)) {
   564				if (!nf_nat_used_tuple(orig_tuple, ct)) {
   565					*tuple = *orig_tuple;
   566					return;
   567				}
   568			} else if (find_appropriate_src(net, zone,
   569							orig_tuple, tuple, range)) {
   570				pr_debug("get_unique_tuple: Found current src map\n");
   571				if (!nf_nat_used_tuple(tuple, ct))
   572					return;
   573			}
   574		}
   575	
   576		/* 2) Select the least-used IP/proto combination in the given range */
   577		*tuple = *orig_tuple;
   578		find_best_ips_proto(zone, tuple, range, ct, maniptype);
   579	
   580		/* 3) The per-protocol part of the manip is made to map into
   581		 * the range to make a unique tuple.
   582		 */
   583	
   584		/* Only bother mapping if it's not already in range and unique */
   585		if (!random_port) {
   586			if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
   587				if (!(range->flags & NF_NAT_RANGE_PROTO_OFFSET) &&
   588				    l4proto_in_range(tuple, maniptype,
   589				          &range->min_proto,
   590				          &range->max_proto) &&
   591				    (range->min_proto.all == range->max_proto.all ||
   592				     !nf_nat_used_tuple(tuple, ct)))
   593					return;
   594			} else if (!nf_nat_used_tuple(tuple, ct)) {
   595				return;
   596			}
   597		}
   598	
   599		/* Last chance: get protocol to try to obtain unique tuple. */
   600		nf_nat_l4proto_unique_tuple(tuple, range, maniptype, ct);
   601	}
   602	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
