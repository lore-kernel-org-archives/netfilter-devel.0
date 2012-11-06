From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [nf-next:nf_tables-experiments 19/19]
 net/netfilter/nf_tables_api.c:718 nf_tables_newchain() info: why not
 propagate 'type' from nf_tables_chain_type_lookup() instead of -2?
Date: Tue, 6 Nov 2012 10:41:06 +0800
Message-ID: <20121106024106.GP16883@yliu-dev.sh.intel.com>
References: <50982648.6QMp7+ZwwPGArwHD%yuanhan.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
	changlongx.xie@intel.com, fengguang.wu@intel.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:40457 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933560Ab2KFClF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Nov 2012 21:41:05 -0500
Content-Disposition: inline
In-Reply-To: <50982648.6QMp7+ZwwPGArwHD%yuanhan.liu@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi Pablo,

Just FYI, there are new _smatch_ warnings show up in

tree:   git://150.214.188.80/nf-next nf_tables-experiments
head:   4581c95a751df71f77861c95f3b34882c37bb2fe
commit: 4581c95a751df71f77861c95f3b34882c37bb2fe [19/19] netfilter: nf_tables: replace built-in tables by chain types

+ net/netfilter/nf_tables_api.c:718 nf_tables_newchain() info: why not propagate 'type' from nf_tables_chain_type_lookup() instead of -2?
  net/netfilter/nf_tables_api.c:1263 nf_tables_newrule() warn: 'info' puts 864 bytes on stack

vim +718 +/type net/netfilter/nf_tables_api.c

89459d9e Pablo Neira Ayuso 2012-10-01  702  						      nla[NFTA_CHAIN_POLICY]);
89459d9e Pablo Neira Ayuso 2012-10-01  703  		}
a6332633 Pablo Neira Ayuso 2012-09-16  704  		return 0;
a6332633 Pablo Neira Ayuso 2012-09-16  705  	}
a6332633 Pablo Neira Ayuso 2012-09-16  706  
a6332633 Pablo Neira Ayuso 2012-09-16  707  	if (nla[NFTA_CHAIN_HOOK]) {
a6332633 Pablo Neira Ayuso 2012-09-16  708  		struct nf_hook_ops *ops;
4581c95a Pablo Neira Ayuso 2012-11-05  709  		nf_hookfn *hookfn;
4581c95a Pablo Neira Ayuso 2012-11-05  710  		u32 hooknum;
4581c95a Pablo Neira Ayuso 2012-11-05  711  		int type = NFT_CHAIN_T_DEFAULT;
4581c95a Pablo Neira Ayuso 2012-11-05  712  
4581c95a Pablo Neira Ayuso 2012-11-05  713  		if (nla[NFTA_CHAIN_TYPE]) {
4581c95a Pablo Neira Ayuso 2012-11-05  714  			type = nf_tables_chain_type_lookup(afi,
4581c95a Pablo Neira Ayuso 2012-11-05  715  							   nla[NFTA_CHAIN_TYPE],
4581c95a Pablo Neira Ayuso 2012-11-05  716  							   create);
4581c95a Pablo Neira Ayuso 2012-11-05  717  			if (type < 0)
4581c95a Pablo Neira Ayuso 2012-11-05 @718  				return -ENOENT;
4581c95a Pablo Neira Ayuso 2012-11-05  719  		}
a6332633 Pablo Neira Ayuso 2012-09-16  720  
a6332633 Pablo Neira Ayuso 2012-09-16  721  		err = nla_parse_nested(ha, NFTA_HOOK_MAX, nla[NFTA_CHAIN_HOOK],
a6332633 Pablo Neira Ayuso 2012-09-16  722  				       nft_hook_policy);
a6332633 Pablo Neira Ayuso 2012-09-16  723  		if (err < 0)
a6332633 Pablo Neira Ayuso 2012-09-16  724  			return err;
a6332633 Pablo Neira Ayuso 2012-09-16  725  		if (ha[NFTA_HOOK_HOOKNUM] == NULL ||
a6332633 Pablo Neira Ayuso 2012-09-16  726  		    ha[NFTA_HOOK_PRIORITY] == NULL)

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
