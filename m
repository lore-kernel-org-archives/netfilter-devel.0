Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C287C77B7A
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 20:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbjFFUhQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 16:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbjFFUhP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 16:37:15 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1E6E49
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2023 13:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686083834; x=1717619834;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ngE5tkLL3OUbO5pflDl4gRt6pQd57kpEElEHSkEOFKE=;
  b=W56JPoJjiobEshZ9okgloytPmpzU4VsupQuYRy7Vu7/Ce6XPDvDy8F6y
   scXAjCrevdud8IMH0QR2k11sXhMajwWhGOOHBDqqgv1V+lhJ7rHSI5G5E
   Dta1t6Vw0LYh3cIf9L1sxiAsxeMemSoTevWVYEj7LktqGeVBTfr7Mxnpj
   fneDN+rPbBm6fOZjZ+rcbGtuYuBMiPxOsd8jAZ8VSnfNRAR61P24I4iL+
   S9vWVo3CuM346Kv7BMW3aAivlK6ORcrHxRVdDILip5OReb0ey9FoGSI/U
   bun1sfvs/JDMz3oFNBC3LrqZHdMmvgrL+9H+ZNApLtXrzw5yIGvH4OuOU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="359258314"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="359258314"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 13:37:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="703341919"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="703341919"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 06 Jun 2023 13:37:12 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q6dQV-0005iB-1p;
        Tue, 06 Jun 2023 20:37:11 +0000
Date:   Wed, 7 Jun 2023 04:37:05 +0800
From:   kernel test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: snat: evict closing tcp entries on
 reply tuple collision
Message-ID: <202306070406.KtN7gaNL-lkp@intel.com>
References: <20230606125421.15487-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606125421.15487-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.4-rc5 next-20230606]
[cannot apply to nf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Westphal/netfilter-snat-evict-closing-tcp-entries-on-reply-tuple-collision/20230606-205654
base:   linus/master
patch link:    https://lore.kernel.org/r/20230606125421.15487-1-fw%40strlen.de
patch subject: [PATCH nf-next] netfilter: snat: evict closing tcp entries on reply tuple collision
config: x86_64-randconfig-a014-20230606 (https://download.01.org/0day-ci/archive/20230607/202306070406.KtN7gaNL-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout linus/master
        b4 shazam https://lore.kernel.org/r/20230606125421.15487-1-fw@strlen.de
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306070406.KtN7gaNL-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/netfilter/nf_nat_core.c:262:6: warning: variable 'ct' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (thash->tuple.dst.dir == IP_CT_DIR_ORIGINAL)
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_nat_core.c:280:12: note: uninitialized use occurs here
           nf_ct_put(ct);
                     ^~
   net/netfilter/nf_nat_core.c:262:2: note: remove the 'if' if its condition is always false
           if (thash->tuple.dst.dir == IP_CT_DIR_ORIGINAL)
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_nat_core.c:239:20: note: initialize the variable 'ct' to silence this warning
           struct nf_conn *ct;
                             ^
                              = NULL
   1 warning generated.


vim +262 net/netfilter/nf_nat_core.c

   228	
   229	static int
   230	nf_nat_used_tuple_harder(const struct nf_conntrack_tuple *tuple,
   231				 const struct nf_conn *ignored_conntrack,
   232				 unsigned int attempts_left)
   233	{
   234		static const unsigned long flags_offload = IPS_OFFLOAD | IPS_HW_OFFLOAD;
   235		struct nf_conntrack_tuple_hash *thash;
   236		const struct nf_conntrack_zone *zone;
   237		struct nf_conntrack_tuple reply;
   238		unsigned long flags;
   239		struct nf_conn *ct;
   240		bool taken = true;
   241		struct net *net;
   242	
   243		nf_ct_invert_tuple(&reply, tuple);
   244	
   245		if (attempts_left > NF_NAT_HARDER_THRESH ||
   246		    tuple->dst.protonum != IPPROTO_TCP ||
   247		    ignored_conntrack->proto.tcp.state != TCP_CONNTRACK_SYN_SENT)
   248			return nf_conntrack_tuple_taken(&reply, ignored_conntrack);
   249	
   250		/* :ast few attempts to find a free tcp port. Destructive
   251		 * action: evict colliding if its in timewait state and the
   252		 * tcp sequence number has advanced past the one used by the
   253		 * old entry.
   254		 */
   255		net = nf_ct_net(ignored_conntrack);
   256		zone = nf_ct_zone(ignored_conntrack);
   257	
   258		thash = nf_conntrack_find_get(net, zone, &reply);
   259		if (!thash)
   260			return false;
   261	
 > 262		if (thash->tuple.dst.dir == IP_CT_DIR_ORIGINAL)
   263			goto out;
   264	
   265		ct = nf_ct_tuplehash_to_ctrack(thash);
   266		if (WARN_ON_ONCE(ct == ignored_conntrack))
   267			goto out;
   268	
   269		flags = READ_ONCE(ct->status);
   270		if (!nf_nat_may_kill(ct, flags))
   271			goto out;
   272	
   273		if (!nf_seq_has_advanced(ct, ignored_conntrack))
   274			goto out;
   275	
   276		/* Even if we can evict do not reuse if entry is offloaded. */
   277		if (nf_ct_kill(ct))
   278			taken = flags & flags_offload;
   279	out:
   280		nf_ct_put(ct);
   281		return taken;
   282	}
   283	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
