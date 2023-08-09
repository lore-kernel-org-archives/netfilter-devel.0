Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8FAC001B0
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Aug 2023 15:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbjHIPcl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 11:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbjHIPck (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 11:32:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64791FD4
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Aug 2023 08:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691595158; x=1723131158;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tGZ4hvQZ78xJFD9HQukeYai1A4SVMFh27ii/5Eojoyo=;
  b=NkK1Jh2q1uLMyg70WQDk3J3m+Ojy9Pi7MNCYQhlooVw68E1SNWnpvQei
   ifRnui4+mO/5dDY224j0XtKkdKtem/yC/J6godG9f8RS0yxfjllfySIdA
   ZcC+5M9MtMTOTrUn3bKBnre3g1uLtgDD/U56LpOg8DO9Qz7L29BHxnoZs
   9SnViv3h/Gd3fn9G1N+A1v0l1YVI+2y8N8cDRDmBc3UwSwQFSM8EykExr
   dMjX4M+xJ+Iz0mSDbCj0kWoXMTZ87B5VNRdzJxSHKFbp5IgxY7V674HHz
   cAmhFoRT9xCGwqPKvTFOoIPxd5roy0LLKO2nO8WKDJLvWZ51QHC4NeTC/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="371141042"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="371141042"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 08:32:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="801790268"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="801790268"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 09 Aug 2023 08:32:36 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qTlAq-0006CA-0a;
        Wed, 09 Aug 2023 15:32:36 +0000
Date:   Wed, 9 Aug 2023 23:32:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH nf 3/5] netfilter: nf_tables: adapt set backend to use GC
 transaction API
Message-ID: <202308092313.jSo4bmAR-lkp@intel.com>
References: <20230809131546.8598-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809131546.8598-3-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.5-rc5 next-20230809]
[cannot apply to nf/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pablo-Neira-Ayuso/netfilter-nf_tables-GC-transaction-API-to-avoid-race-with-control-plane/20230809-211751
base:   linus/master
patch link:    https://lore.kernel.org/r/20230809131546.8598-3-pablo%40netfilter.org
patch subject: [PATCH nf 3/5] netfilter: nf_tables: adapt set backend to use GC transaction API
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20230809/202308092313.jSo4bmAR-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230809/202308092313.jSo4bmAR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308092313.jSo4bmAR-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/netfilter/nft_set_rbtree.c: In function 'nft_rbtree_gc':
>> net/netfilter/nft_set_rbtree.c:607:12: warning: variable 'genmask' set but not used [-Wunused-but-set-variable]
     607 |         u8 genmask;
         |            ^~~~~~~


vim +/genmask +607 net/netfilter/nft_set_rbtree.c

20a69341f2d00c net/netfilter/nft_rbtree.c     Patrick McHardy   2013-10-11  596  
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  597  static void nft_rbtree_gc(struct work_struct *work)
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  598  {
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  599  	struct nft_rbtree_elem *rbe, *rbe_end = NULL;
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  600  	struct nftables_pernet *nft_net;
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  601  	struct nft_rbtree *priv;
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  602  	struct nft_trans_gc *gc;
a13f814a67b12a net/netfilter/nft_set_rbtree.c Taehee Yoo        2018-08-30  603  	struct rb_node *node;
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  604  	struct nft_set *set;
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  605  	unsigned int gc_seq;
5d235d6ce75c12 net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-01-14  606  	struct net *net;
5d235d6ce75c12 net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-01-14 @607  	u8 genmask;
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  608  
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  609  	priv = container_of(work, struct nft_rbtree, gc_work.work);
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  610  	set  = nft_set_container_of(priv);
5d235d6ce75c12 net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-01-14  611  	net  = read_pnet(&set->net);
5d235d6ce75c12 net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-01-14  612  	genmask = nft_genmask_cur(net);
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  613  	nft_net = nft_pernet(net);
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  614  	gc_seq  = READ_ONCE(nft_net->gc_seq);
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  615  
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  616  	gc = nft_trans_gc_alloc(set, gc_seq, GFP_KERNEL);
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  617  	if (!gc)
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  618  		goto done;
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  619  
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  620  	write_lock_bh(&priv->lock);
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  621  	write_seqcount_begin(&priv->count);
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  622  	for (node = rb_first(&priv->root); node != NULL; node = rb_next(node)) {
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  623  
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  624  		/* Ruleset has been updated, try later. */
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  625  		if (READ_ONCE(nft_net->gc_seq) != gc_seq) {
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  626  			nft_trans_gc_destroy(gc);
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  627  			gc = NULL;
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  628  			goto try_later;
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  629  		}
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  630  
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  631  		rbe = rb_entry(node, struct nft_rbtree_elem, node);
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  632  
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  633  		if (nft_set_elem_is_dead(&rbe->ext))
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  634  			goto dead_elem;
5d235d6ce75c12 net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-01-14  635  
5d235d6ce75c12 net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-01-14  636  		/* elements are reversed in the rbtree for historical reasons,
5d235d6ce75c12 net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-01-14  637  		 * from highest to lowest value, that is why end element is
5d235d6ce75c12 net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-01-14  638  		 * always visited before the start element.
5d235d6ce75c12 net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-01-14  639  		 */
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  640  		if (nft_rbtree_interval_end(rbe)) {
a13f814a67b12a net/netfilter/nft_set_rbtree.c Taehee Yoo        2018-08-30  641  			rbe_end = rbe;
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  642  			continue;
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  643  		}
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  644  		if (!nft_set_elem_expired(&rbe->ext))
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  645  			continue;
5d235d6ce75c12 net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-01-14  646  
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  647  		nft_set_elem_dead(&rbe->ext);
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  648  
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  649  		if (!rbe_end)
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  650  			continue;
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  651  
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  652  		nft_set_elem_dead(&rbe_end->ext);
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  653  
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  654  		gc = nft_trans_gc_queue_async(gc, gc_seq, GFP_ATOMIC);
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  655  		if (!gc)
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  656  			goto try_later;
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  657  
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  658  		nft_trans_gc_elem_add(gc, rbe_end);
a13f814a67b12a net/netfilter/nft_set_rbtree.c Taehee Yoo        2018-08-30  659  		rbe_end = NULL;
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  660  dead_elem:
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  661  		gc = nft_trans_gc_queue_async(gc, gc_seq, GFP_ATOMIC);
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  662  		if (!gc)
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  663  			goto try_later;
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  664  
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  665  		nft_trans_gc_elem_add(gc, rbe);
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  666  	}
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  667  
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  668  	gc = nft_trans_gc_catchall(gc, gc_seq);
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  669  
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  670  try_later:
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  671  	write_seqcount_end(&priv->count);
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  672  	write_unlock_bh(&priv->lock);
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  673  
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  674  	if (gc)
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  675  		nft_trans_gc_queue_async_done(gc);
9cbd4eae38ba6c net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2023-08-09  676  done:
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  677  	queue_delayed_work(system_power_efficient_wq, &priv->gc_work,
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  678  			   nft_set_gc_interval(set));
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  679  }
8d8540c4f5e03d net/netfilter/nft_set_rbtree.c Pablo Neira Ayuso 2018-05-16  680  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
