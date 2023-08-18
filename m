Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C41C001DE
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 07:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352585AbjHRHtx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 03:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358301AbjHRHto (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 03:49:44 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251D23AA6
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 00:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692344980; x=1723880980;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dtZ7PkQSm/suc9nyv1QVhlNVz4vpaXbAM4VQiGLCyjA=;
  b=JJS0OvkOgItAwpyDHuJhmiGUZI1j9fANNZ5wIgF+AujbXngGxrc7mUUg
   qRrfpMlTnmAbu5MEWMmEnXaQitCdnrj3layzYh5gAT0jcuYpd677BHn/I
   k7ocnJQimsB39+Hug5ixWqrV8x7GI6DgLkZU4PPfJvmF2Sq3UL0PQmT9l
   mtl+JNzJfePKtIC2S7GHurGCxR9HzHpBbjtijlVNfuWtqUmd3BejwV9PZ
   +mW3Vi3qPQcaVdVLAZcgkQbv/+1oy0QQGewZhbQVp7XtVqsox5TN5GAYn
   uSLsu6zqbzhIsgAawzJFPHwLQHaJTa26EAxk7rJabToUEa98d33B6K3dR
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="376798570"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="376798570"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 00:49:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="684788912"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="684788912"
Received: from lkp-server02.sh.intel.com (HELO a9caf1a0cf30) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 18 Aug 2023 00:49:05 -0700
Received: from kbuild by a9caf1a0cf30 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qWuEC-0002Ei-2I;
        Fri, 18 Aug 2023 07:49:04 +0000
Date:   Fri, 18 Aug 2023 15:48:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH nf] netfilter: nf_tables: GC transaction race with abort
 path
Message-ID: <202308181545.lZbeE7Lm-lkp@intel.com>
References: <20230817231352.8412-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817231352.8412-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

kernel test robot noticed the following build errors:

[auto build test ERROR on nf/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Pablo-Neira-Ayuso/netfilter-nf_tables-GC-transaction-race-with-abort-path/20230818-071545
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git master
patch link:    https://lore.kernel.org/r/20230817231352.8412-1-pablo%40netfilter.org
patch subject: [PATCH nf] netfilter: nf_tables: GC transaction race with abort path
config: hexagon-randconfig-r045-20230818 (https://download.01.org/0day-ci/archive/20230818/202308181545.lZbeE7Lm-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce: (https://download.01.org/0day-ci/archive/20230818/202308181545.lZbeE7Lm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308181545.lZbeE7Lm-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/netfilter/nf_tables_api.c:9132:11: error: call to undeclared function 'nft_gc_seq_begin'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    9132 |         gc_seq = nft_gc_seq_begin(nft_net);
         |                  ^
>> net/netfilter/nf_tables_api.c:9134:2: error: call to undeclared function 'nft_gc_seq_end'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    9134 |         nft_gc_seq_end(nft_net, gc_seq);
         |         ^
   2 errors generated.


vim +/nft_gc_seq_begin +9132 net/netfilter/nf_tables_api.c

  9124	
  9125	static int nf_tables_abort(struct net *net, struct sk_buff *skb,
  9126				   enum nfnl_abort_action action)
  9127	{
  9128		struct nftables_pernet *nft_net = nft_pernet(net);
  9129		unsigned int gc_seq;
  9130		int ret;
  9131	
> 9132		gc_seq = nft_gc_seq_begin(nft_net);
  9133		ret = __nf_tables_abort(net, action);
> 9134		nft_gc_seq_end(nft_net, gc_seq);
  9135		mutex_unlock(&nft_net->commit_mutex);
  9136	
  9137		return ret;
  9138	}
  9139	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
