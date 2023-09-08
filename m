Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D971EC8732
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 03:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbjIHDS7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 23:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235586AbjIHDS5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 23:18:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBBF1BEE;
        Thu,  7 Sep 2023 20:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694143129; x=1725679129;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oVRh3cA4wodne8omB5dWpaFCF6ymIphW1ZyNXeyQkJk=;
  b=SC+bf5PrIGz6ZQKFCSdrknYEMkshPuuht6fcrFg4/UPF3cL9QA/kFzQW
   uZZPvTlUzXOXYrKVHxTITjccWJj1jE8RbJi2Ybp2Kuna6+fwZGFaoAnN/
   vm9A4eVG3nP/NvrvD/bI3PEbT0PrGbI/87l9y0isc9l5X8s7gaK37+tKw
   x82rXZUS/nxpoK/82n6y3UsnxNgevNXivfxNhjuRySBOqcINFXl8DLOpZ
   iAr5c5K7sb+brYSoyaT5wZXMM6Z9qdR5nQ9I/wWzKWNmBVThwPj2+Gblw
   E9r4gCC75VsafXeSakiQk4ykFqBpaeo36wMsgET3L87W89LDY10dq5usW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="376451965"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="376451965"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2023 20:18:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="718974117"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="718974117"
Received: from lkp-server01.sh.intel.com (HELO 59b3c6e06877) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 07 Sep 2023 20:18:46 -0700
Received: from kbuild by 59b3c6e06877 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qeS15-0001rz-2f;
        Fri, 08 Sep 2023 03:18:43 +0000
Date:   Fri, 8 Sep 2023 11:17:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org
Subject: Re: [nf PATCH 1/2] netfilter: nf_tables: Fix entries val in rule
 reset audit log
Message-ID: <202309081138.IpMoJwFy-lkp@intel.com>
References: <20230908002229.1409-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230908002229.1409-2-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

kernel test robot noticed the following build warnings:

[auto build test WARNING on netfilter-nf/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Phil-Sutter/netfilter-nf_tables-Fix-entries-val-in-rule-reset-audit-log/20230908-082530
base:   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20230908002229.1409-2-phil%40nwl.cc
patch subject: [nf PATCH 1/2] netfilter: nf_tables: Fix entries val in rule reset audit log
config: mips-randconfig-r002-20230908 (https://download.01.org/0day-ci/archive/20230908/202309081138.IpMoJwFy-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230908/202309081138.IpMoJwFy-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309081138.IpMoJwFy-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/netfilter/nf_tables_api.c:3536:11: warning: comparison of distinct pointer types ('typeof (idx) *' (aka 'unsigned int *') and 'typeof (cb->args[0]) *' (aka 'long *')) [-Wcompare-distinct-pointer-types]
    3536 |                 s_idx = max(idx, cb->args[0]);
         |                         ^~~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:74:19: note: expanded from macro 'max'
      74 | #define max(x, y)       __careful_cmp(x, y, >)
         |                         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:36:24: note: expanded from macro '__careful_cmp'
      36 |         __builtin_choose_expr(__safe_cmp(x, y), \
         |                               ^~~~~~~~~~~~~~~~
   include/linux/minmax.h:26:4: note: expanded from macro '__safe_cmp'
      26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
         |                  ^~~~~~~~~~~~~~~~~
   include/linux/minmax.h:20:28: note: expanded from macro '__typecheck'
      20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
         |                    ~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~
   1 warning generated.


vim +3536 net/netfilter/nf_tables_api.c

  3486	
  3487	static int nf_tables_dump_rules(struct sk_buff *skb,
  3488					struct netlink_callback *cb)
  3489	{
  3490		const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
  3491		const struct nft_rule_dump_ctx *ctx = cb->data;
  3492		struct nft_table *table;
  3493		const struct nft_chain *chain;
  3494		unsigned int idx = 0, s_idx;
  3495		struct net *net = sock_net(skb->sk);
  3496		int family = nfmsg->nfgen_family;
  3497		struct nftables_pernet *nft_net;
  3498		bool reset = false;
  3499		int ret;
  3500	
  3501		if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
  3502			reset = true;
  3503	
  3504		rcu_read_lock();
  3505		nft_net = nft_pernet(net);
  3506		cb->seq = READ_ONCE(nft_net->base_seq);
  3507	
  3508		list_for_each_entry_rcu(table, &nft_net->tables, list) {
  3509			if (family != NFPROTO_UNSPEC && family != table->family)
  3510				continue;
  3511	
  3512			if (ctx && ctx->table && strcmp(ctx->table, table->name) != 0)
  3513				continue;
  3514	
  3515			if (ctx && ctx->table && ctx->chain) {
  3516				struct rhlist_head *list, *tmp;
  3517	
  3518				list = rhltable_lookup(&table->chains_ht, ctx->chain,
  3519						       nft_chain_ht_params);
  3520				if (!list)
  3521					goto done;
  3522	
  3523				rhl_for_each_entry_rcu(chain, tmp, list, rhlhead) {
  3524					if (!nft_is_active(net, chain))
  3525						continue;
  3526					__nf_tables_dump_rules(skb, &idx,
  3527							       cb, table, chain, reset);
  3528					break;
  3529				}
  3530				if (reset && idx > cb->args[0])
  3531					audit_log_rule_reset(table, cb->seq,
  3532							     idx - cb->args[0]);
  3533				goto done;
  3534			}
  3535	
> 3536			s_idx = max(idx, cb->args[0]);
  3537			list_for_each_entry_rcu(chain, &table->chains, list) {
  3538				ret = __nf_tables_dump_rules(skb, &idx,
  3539							     cb, table, chain, reset);
  3540				if (ret)
  3541					break;
  3542			}
  3543			if (reset && idx > s_idx)
  3544				audit_log_rule_reset(table, cb->seq, idx - s_idx);
  3545	
  3546			if ((ctx && ctx->table) || ret)
  3547				break;
  3548		}
  3549	done:
  3550		rcu_read_unlock();
  3551	
  3552		cb->args[0] = idx;
  3553		return skb->len;
  3554	}
  3555	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
