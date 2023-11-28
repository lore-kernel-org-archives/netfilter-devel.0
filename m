Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gf3vKk++"
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E97C1
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Nov 2023 16:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701130784; x=1732666784;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SkTqX8hlsddW4reO79XjBqo2yCRVDIOjUwvm/nqeuyI=;
  b=Gf3vKk++mHNU/04pwUc0MGpjcWhIcpy44FOSzj/FoIbtvCuZMY/JvI+K
   Dxclx8VCCHwvx2EQXtP+sD5mBg0sqgjvsP+j1nrzRieavnd3r3+ZvnqsP
   QA02rMAFhp/hJHxtkqYVIVLucCa+HLLz1PKPdr+wNWonyebpHswJawICk
   GcPLV8VoZDc6ZUirmsXPwF76IsnuYFRDsVL5w6pPtcSzYKGL01c75+Stx
   n6MO97/tcNkFX8BOqCzKTUeADEcOHWJH4nHIl3WZqi60vvErDsRu4YSyC
   yV8tvOoqaYw7Vh3awEaoYZ7ldJonYJ0ePTEQd3wFHnTfCkDY/7iBr26FC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="14374386"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="14374386"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 16:19:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="941743835"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="941743835"
Received: from lkp-server01.sh.intel.com (HELO d584ee6ebdcc) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 27 Nov 2023 16:19:41 -0800
Received: from kbuild by d584ee6ebdcc with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r7lpD-0006o0-1s;
	Tue, 28 Nov 2023 00:19:39 +0000
Date: Tue, 28 Nov 2023 08:19:18 +0800
From: kernel test robot <lkp@intel.com>
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: mark newset as dead on
 transaction abort
Message-ID: <202311280410.7aUI1BHd-lkp@intel.com>
References: <20231127100040.1944-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127100040.1944-1-fw@strlen.de>

Hi Florian,

kernel test robot noticed the following build errors:

[auto build test ERROR on nf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Westphal/netfilter-nf_tables-mark-newset-as-dead-on-transaction-abort/20231127-180311
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
patch link:    https://lore.kernel.org/r/20231127100040.1944-1-fw%40strlen.de
patch subject: [PATCH nf-next] netfilter: nf_tables: mark newset as dead on transaction abort
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20231128/202311280410.7aUI1BHd-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231128/202311280410.7aUI1BHd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311280410.7aUI1BHd-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/netfilter/nf_tables_api.c: In function '__nf_tables_abort':
>> net/netfilter/nf_tables_api.c:9037:45: error: 'struct nft_set' has no member named 'dead'
    9037 |                         nft_trans_set(trans)->dead = 1;
         |                                             ^~


vim +9037 net/netfilter/nf_tables_api.c

  8954	
  8955	static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
  8956	{
  8957		struct nftables_pernet *nft_net = nft_pernet(net);
  8958		struct nft_trans *trans, *next;
  8959		struct nft_trans_elem *te;
  8960		struct nft_hook *hook;
  8961	
  8962		if (action == NFNL_ABORT_VALIDATE &&
  8963		    nf_tables_validate(net) < 0)
  8964			return -EAGAIN;
  8965	
  8966		list_for_each_entry_safe_reverse(trans, next, &nft_net->commit_list,
  8967						 list) {
  8968			switch (trans->msg_type) {
  8969			case NFT_MSG_NEWTABLE:
  8970				if (nft_trans_table_update(trans)) {
  8971					if (!(trans->ctx.table->flags & __NFT_TABLE_F_UPDATE)) {
  8972						nft_trans_destroy(trans);
  8973						break;
  8974					}
  8975					if (trans->ctx.table->flags & __NFT_TABLE_F_WAS_DORMANT) {
  8976						nf_tables_table_disable(net, trans->ctx.table);
  8977						trans->ctx.table->flags |= NFT_TABLE_F_DORMANT;
  8978					} else if (trans->ctx.table->flags & __NFT_TABLE_F_WAS_AWAKEN) {
  8979						trans->ctx.table->flags &= ~NFT_TABLE_F_DORMANT;
  8980					}
  8981					trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
  8982					nft_trans_destroy(trans);
  8983				} else {
  8984					list_del_rcu(&trans->ctx.table->list);
  8985				}
  8986				break;
  8987			case NFT_MSG_DELTABLE:
  8988				nft_clear(trans->ctx.net, trans->ctx.table);
  8989				nft_trans_destroy(trans);
  8990				break;
  8991			case NFT_MSG_NEWCHAIN:
  8992				if (nft_trans_chain_update(trans)) {
  8993					free_percpu(nft_trans_chain_stats(trans));
  8994					kfree(nft_trans_chain_name(trans));
  8995					nft_trans_destroy(trans);
  8996				} else {
  8997					if (nft_chain_is_bound(trans->ctx.chain)) {
  8998						nft_trans_destroy(trans);
  8999						break;
  9000					}
  9001					trans->ctx.table->use--;
  9002					nft_chain_del(trans->ctx.chain);
  9003					nf_tables_unregister_hook(trans->ctx.net,
  9004								  trans->ctx.table,
  9005								  trans->ctx.chain);
  9006				}
  9007				break;
  9008			case NFT_MSG_DELCHAIN:
  9009				trans->ctx.table->use++;
  9010				nft_clear(trans->ctx.net, trans->ctx.chain);
  9011				nft_trans_destroy(trans);
  9012				break;
  9013			case NFT_MSG_NEWRULE:
  9014				trans->ctx.chain->use--;
  9015				list_del_rcu(&nft_trans_rule(trans)->list);
  9016				nft_rule_expr_deactivate(&trans->ctx,
  9017							 nft_trans_rule(trans),
  9018							 NFT_TRANS_ABORT);
  9019				if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
  9020					nft_flow_rule_destroy(nft_trans_flow_rule(trans));
  9021				break;
  9022			case NFT_MSG_DELRULE:
  9023				trans->ctx.chain->use++;
  9024				nft_clear(trans->ctx.net, nft_trans_rule(trans));
  9025				nft_rule_expr_activate(&trans->ctx, nft_trans_rule(trans));
  9026				if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
  9027					nft_flow_rule_destroy(nft_trans_flow_rule(trans));
  9028	
  9029				nft_trans_destroy(trans);
  9030				break;
  9031			case NFT_MSG_NEWSET:
  9032				trans->ctx.table->use--;
  9033				if (nft_trans_set_bound(trans)) {
  9034					nft_trans_destroy(trans);
  9035					break;
  9036				}
> 9037				nft_trans_set(trans)->dead = 1;
  9038				list_del_rcu(&nft_trans_set(trans)->list);
  9039				break;
  9040			case NFT_MSG_DELSET:
  9041				trans->ctx.table->use++;
  9042				nft_clear(trans->ctx.net, nft_trans_set(trans));
  9043				nft_trans_destroy(trans);
  9044				break;
  9045			case NFT_MSG_NEWSETELEM:
  9046				if (nft_trans_elem_set_bound(trans)) {
  9047					nft_trans_destroy(trans);
  9048					break;
  9049				}
  9050				te = (struct nft_trans_elem *)trans->data;
  9051				nft_setelem_remove(net, te->set, &te->elem);
  9052				if (!nft_setelem_is_catchall(te->set, &te->elem))
  9053					atomic_dec(&te->set->nelems);
  9054				break;
  9055			case NFT_MSG_DELSETELEM:
  9056				te = (struct nft_trans_elem *)trans->data;
  9057	
  9058				nft_setelem_data_activate(net, te->set, &te->elem);
  9059				nft_setelem_activate(net, te->set, &te->elem);
  9060				if (!nft_setelem_is_catchall(te->set, &te->elem))
  9061					te->set->ndeact--;
  9062	
  9063				nft_trans_destroy(trans);
  9064				break;
  9065			case NFT_MSG_NEWOBJ:
  9066				if (nft_trans_obj_update(trans)) {
  9067					nft_obj_destroy(&trans->ctx, nft_trans_obj_newobj(trans));
  9068					nft_trans_destroy(trans);
  9069				} else {
  9070					trans->ctx.table->use--;
  9071					nft_obj_del(nft_trans_obj(trans));
  9072				}
  9073				break;
  9074			case NFT_MSG_DELOBJ:
  9075				trans->ctx.table->use++;
  9076				nft_clear(trans->ctx.net, nft_trans_obj(trans));
  9077				nft_trans_destroy(trans);
  9078				break;
  9079			case NFT_MSG_NEWFLOWTABLE:
  9080				if (nft_trans_flowtable_update(trans)) {
  9081					nft_unregister_flowtable_net_hooks(net,
  9082							&nft_trans_flowtable_hooks(trans));
  9083				} else {
  9084					trans->ctx.table->use--;
  9085					list_del_rcu(&nft_trans_flowtable(trans)->list);
  9086					nft_unregister_flowtable_net_hooks(net,
  9087							&nft_trans_flowtable(trans)->hook_list);
  9088				}
  9089				break;
  9090			case NFT_MSG_DELFLOWTABLE:
  9091				if (nft_trans_flowtable_update(trans)) {
  9092					list_for_each_entry(hook, &nft_trans_flowtable(trans)->hook_list, list)
  9093						hook->inactive = false;
  9094				} else {
  9095					trans->ctx.table->use++;
  9096					nft_clear(trans->ctx.net, nft_trans_flowtable(trans));
  9097				}
  9098				nft_trans_destroy(trans);
  9099				break;
  9100			}
  9101		}
  9102	
  9103		synchronize_rcu();
  9104	
  9105		list_for_each_entry_safe_reverse(trans, next,
  9106						 &nft_net->commit_list, list) {
  9107			list_del(&trans->list);
  9108			nf_tables_abort_release(trans);
  9109		}
  9110	
  9111		if (action == NFNL_ABORT_AUTOLOAD)
  9112			nf_tables_module_autoload(net);
  9113		else
  9114			nf_tables_module_autoload_cleanup(net);
  9115	
  9116		return 0;
  9117	}
  9118	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
